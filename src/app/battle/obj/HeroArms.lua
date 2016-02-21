
--[[
	jinyan.zhang
	英雄部队类
--]]

HeroArms = class("HeroArms",Monomer)

--构造
--params 参数
--dir 英雄朝向
--soldierType 士兵类型
--camp 阵营(true攻者方,false:防守方)
--movePos 目标位置
--moveSpeed 移动速度
--islook (true:侦察,false:不是侦察)
--返回值(无)
function HeroArms:ctor(params,dir,soldierType,camp,movePos,moveSpeed,islook)
    self.movePos = movePos
    self.speed = moveSpeed
    self.isReturnCastle = false
    self.isLook = islook
	self.super.ctor(self,params,dir,soldierType,camp)
end

--初始化
--返回值(无)
function HeroArms:init()
    self.eventHandlerTable = {}
    self.eventObjTable = {}
    self.eventDataTable = {}
end

--设置是否是返回城堡
--isReturnCastle 返回城堡标记(true:是返回城堡,false:不是)
--返回值(无)
function HeroArms:setIsReturnCastle(isReturnCastle)
    self.isReturnCastle = isReturnCastle
end

--注册消息
--evenType 事件类型
--obj 事件回调接口所在的类名
--handler 事件回调接口
--返回值(无)
function HeroArms:registerMsg(evenType, obj, handler,data)
    self.eventHandlerTable[evenType] = handler
    self.eventObjTable[evenType] = obj
    self.eventDataTable[evenType] = data
end

--设置行军部队id
--armsid_h 行军部队id
--armsid_l 行军部队id
--返回值(无)
function HeroArms:setMarchArmsId(armsid_h,armsid_l)
    self.armsid_h = armsid_h
    self.armsid_l = armsid_l
end

--加入到舞台后会调用这个接口
--返回值(无)
function HeroArms:onEnter()
	--MyLog("HeroArms onEnter()")

	self:showFigure()
    
    if self.speed ~= nil then
        self:setSpeed(self.speed)
    end

    if self.movePos ~= nil then
        self:walkToDest(self.movePos)
    end
end

--离开舞台后会调用这个接口
--返回值(无)
function HeroArms:onExit()
	--MyLog("HeroArms onExit()")
end

--从内存释放后会调用这个接口
--返回值(无)
function HeroArms:onDestroy()
	--MyLog("HeroArms onDestroy()")
end 

-- 向着目标的轨迹行动
--返回值(无)
function HeroArms:followTheTracks()
    self:goTo()
end

--计算目标点，并移动到该点
--targetPos 目标位置
--返回值(无)
function HeroArms:goTo(targetPos)
	if self:getState() == AI_STATE.DEATH then
		return
	end

    -- 移动目标一样
    if self.moveInfo.targetPos and targetPos ~= nil and self.moveInfo.targetPos.x == targetPos.x and
       self.moveInfo.targetPos.y == targetPos.y then
        return
    end

    local target = self:getAttackMajor()
    if target ~= nil then
        if self.m_chaseDir ~= nil then
            targetPos = self:getChasePos(target , self.m_chaseDir)
        else
            self.m_chaseDir = self:getChasetDir(target)
            if self.m_chaseDir ~= nil then       
                targetPos = self:getChasePos(target , self.m_chaseDir)
                self:setChaseDirValue(self.m_chaseDir , FULL , false , self)
            end
        end
    end

    if target ~= nil and not self:isCanChaseThisPos(targetPos) then
        self:clearChasetDir()
        self.m_chaseDir = self:getChasetDir(target)
        if self.m_chaseDir ~= nil then
            targetPos = self:getChasePos(target , self.m_chaseDir)
            self:setChaseDirValue(self.m_chaseDir , FULL , false , self)
        else
            return 
        end
    end

    if targetPos == nil then
        return
    end

    self:walkToDest(targetPos)
end

--开始攻击
--返回值(无)
function HeroArms:startAttack()
    if self.m_AttackMajor == nil then
        return
    end

    if self.m_AttackMajor.id == nil then
        return
    end

    if self.m_AttackMajor:getState() == AI_STATE.DEATH then
        self:clearChasetDir()
        self:setAttackMajor(nil)
        self:clearMoveInfo()
        self:setStateAndDir(AI_STATE.IDLE, self:getDir())
        return
    end
    
    if self:getState() == AI_STATE.ATTACT then
        return
    end

    local isArriveTarget = self:isHaveArryChasePos(self.m_chaseDir)
    isArriveTarget = true

    --敌人在攻击范围内
    if isArriveTarget and self:isInTheAttackRange(self.m_AttackMajor) then
        local skillIndex = self:getSkillIndex()
        self:normalattackEnemy(skillIndex)
    else
        --在可视范围，沿着轨迹行动
        self:followTheTracks()
    end
end

--是否可以追击这个位置(边界检测)
--targetPos 追击位置
--chaseTarget 追击目标
--返回值(true:可以,false:不可以)
function HeroArms:isCanChaseThisPos(targetPos,chaseTarget)
    if targetPos == nil then
        return false
    end

    return true
end

--每帧更新英雄逻辑
--dt 时间
--返回值(无)
function HeroArms:update(dt)
	if self.monor == nil then
		return
	end

	if self:getState() == AI_STATE.DEATH then
		return
	end

	if self:getState() == AI_STATE.ATTACT then
		return
	end

    if self:getState() == AI_STATE.HURT then
        return
    end

	if self.moveInfo.targetPos ~= nil then
		self:updatePos(dt)
	end

    if self.isRushing then
        return
    end

    if self.isLook then
        return
    end

    local worldMap = MapMgr:getInstance():getWorldMap()
    if worldMap ~= nil then
        worldMap:removeMarchLine(self.armsid_h,self.armsid_l)
    end

    if not self.isReturnCastle then
        self:setSpeed(150)
    end

    --返回到城堡就删除自己
    if self.isReturnCastle then
        self:remove()
        return
    end

	--有目标先攻击选定的目标
    local target = self:getAttackMajor()
    if target ~= nil and target.id ~= nil and target:getState() ~= AI_STATE.DEATH then
        self:startAttack()
    else
        local func = self.eventHandlerTable[0]
        local obj = self.eventObjTable[0]
        local data = self.eventDataTable[0]
        if nil == func or nil == obj or data == nil then
            return
        end
        func(obj,self,data)
    end
end 











