
--[[
	jinyan.zhang
	副本英雄部队类
--]]

CopyHeroArms = class("CopyHeroArms",Monomer)

--构造
--params 参数
--dir 英雄朝向
--soldierType 士兵类型
--camp 阵营(true攻者方,false:防守方)
--movePos 目标位置
--moveSpeed 移动速度
--返回值(无)
function CopyHeroArms:ctor(params,dir,soldierType,camp,movePos,moveSpeed)
    self.movePos = movePos
    self.speed = moveSpeed
    params.attack_distance = 100
	self.super.ctor(self,params,dir,soldierType,camp)
end

--初始化
--返回值(无)
function CopyHeroArms:init()

end

--加入到舞台后会调用这个接口
--返回值(无)
function CopyHeroArms:onEnter()
	--MyLog("CopyHeroArms onEnter()")

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
function CopyHeroArms:onExit()
	--MyLog("CopyHeroArms onExit()")
end

--从内存释放后会调用这个接口
--返回值(无)
function CopyHeroArms:onDestroy()
	--MyLog("CopyHeroArms onDestroy()")
end 

-- 向着目标的轨迹行动
--返回值(无)
function CopyHeroArms:followTheTracks()
    self:goTo()
end

--计算目标点，并移动到该点
--targetPos 目标位置
--返回值(无)
function CopyHeroArms:goTo(targetPos)
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
function CopyHeroArms:startAttack()
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

    --敌人在攻击范围内
    if self:isInTheAttackRange(self.m_AttackMajor) then
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
function CopyHeroArms:isCanChaseThisPos(targetPos,chaseTarget)
    if targetPos == nil then
        return false
    end

    return true
end

--获取技能CD时间
--useSkillIndex 使用第几个技能
--返回值(技能CD时间)
function CopyHeroArms:getSkillCDTime(useSkillIndex)
    return 0
end

--每帧更新英雄逻辑
--dt 时间
--返回值(无)
function CopyHeroArms:update(dt)
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

	--有目标先攻击选定的目标
    local target = self:getAttackMajor()
    if target ~= nil and target.id ~= nil and target:getState() ~= AI_STATE.DEATH then
        self:startAttack()
        return
    end
end











