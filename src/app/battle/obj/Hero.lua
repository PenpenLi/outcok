
--[[
	jinyan.zhang
	英雄类
--]]

Hero = class("Hero",Monomer)

--构造
--params 参数
--dir 英雄朝向
--soldierType 士兵类型
--camp 阵营(true攻者方,false:防守方)
--返回值(无)
function Hero:ctor(params,dir,soldierType,camp)
	self.super.ctor(self,params,dir,soldierType,camp)
end

--初始化
--返回值(无)
function Hero:init()
    --self.thinkTime = math.random(100,2000)
    --self.thinkTime = self.thinkTime/1000
    --self.aiPassTime = 0
end

--修正坐标
--x,y 坐标
--返回值(修正后的坐标)
function Hero:modifPos(x,y)
    local offsetX = 50
    local offsetY = 50
    local outPos = cc.p(x,y)
    local bgSize = BattleLogic:getInstance():getBgMapSize()
    if x <= offsetX then
        outPos.x = offsetX       
    elseif x >= bgSize.width - offsetX then
        outPos.x = bgSize.width - offsetX      
    end

    if y <= offsetY then
       outPos.y = offsetY
    elseif y >= bgSize.height - offsetY then
        outPos.y = bgSize.height - offsetY
    end

    return outPos
end

--加入到舞台后会调用这个接口
--返回值(无)
function Hero:onEnter()
	--MyLog("Hero onEnter()")

	self:showFigure()

    local moveX = 0
    local moveY = 0    
    if self.camp == CAMP.ATTER then
        moveY = 150
    elseif self.camp == CAMP.DEFER then
        moveY = -150
    end

    local x,y = self:getPosition()
    local curPos = cc.p(x,y)
    local movePos = self:modifPos(x + moveX,y + moveY)

    self:walkToDest(movePos)
end

--离开舞台后会调用这个接口
--返回值(无)
function Hero:onExit()
	--MyLog("Hero onExit()")
end

--从内存释放后会调用这个接口
--返回值(无)
function Hero:onDestroy()
	--MyLog("Hero onDestroy()")
end 

-- 向着目标的轨迹行动
--返回值(无)
function Hero:followTheTracks()
    self:goTo()
end

--计算目标点，并移动到该点
--targetPos 目标位置
--返回值(无)
function Hero:goTo(targetPos)
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
function Hero:startAttack()
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

    local useChaseEmptyCount = self:getUseingChaseEmptyCount(target)
    if self.m_chaseDir == nil and useChaseEmptyCount == 0 then
        --isArriveTarget = true
    end

    --敌人在攻击范围内
    if isArriveTarget and self:isInTheAttackRange(self.m_AttackMajor) then
        local skillIndex = self:getSkillIndex()
        self:normalattackEnemy(skillIndex)
    else
        --在可视范围，沿着轨迹行动
        self:followTheTracks()
    end
end

--获取最近的敌人
--返回值(最近的敌人)
function Hero:getNearEnemy()

    local soldierList = HeroMgr:getInstance():getSoldierList(self.enemyCamp)

    local function getEnemyList(count)
        local enemyList = {}
        for k,v in pairs(soldierList) do
            if v.hero:getState() ~= AI_STATE.DEATH and self:getUseingChaseEmptyCount(v.hero) == count then
                table.insert(enemyList,v)
            end
        end
        return enemyList
    end

    local pos = Common:getPosition(self)

    local function getEnemy(count)
        local enemyList = getEnemyList(count)
        local minDis = 100000
        local enemy = nil
        for k,v in pairs(enemyList) do
            local targetPos = Common:getPosition(v.hero)
            local dis = cc.pGetDistance(targetPos,pos)
            if dis < minDis then
                minDis = dis
                enemy = v.hero
            end
        end
        return enemy
    end

    for i=1,8 do
        local enemy = getEnemy(i-1)
        if enemy ~= nil then
            return enemy
        end
    end
end

--获取攻击范围内的敌人
--返回值(攻击范围内的敌人)
function Hero:getAttRangeEnemy()
    local attRangeEnemyList = {}
    local soldierList = HeroMgr:getInstance():getSoldierList(self.enemyCamp)
    local pos = Common:getPosition(self)
    local attkDis = self:getAttackDis()

    ----[[
    for k,v in pairs(soldierList) do
        if v.hero:getState() ~= AI_STATE.DEATH then
            local targetPos = Common:getPosition(v.hero)
            local dis = cc.pGetDistance(targetPos,pos)
            if dis <= attkDis then
                table.insert(attRangeEnemyList,v)
            end
        end
    end

    for k,v in pairs(attRangeEnemyList) do
        if self:getUseingChaseEmptyCount(v.hero) <= 7 then
            return v.hero
        end
    end

    --[[
    for k,v in pairs(attRangeEnemyList) do
        if self:getUseingChaseEmptyCount(v.hero) == 1 then
            return v.hero
        end
    end

    for k,v in pairs(attRangeEnemyList) do
        if self:getUseingChaseEmptyCount(v.hero) == 2 then
            return v.hero
        end
    end

    for k,v in pairs(attRangeEnemyList) do
        if self:getUseingChaseEmptyCount(v.hero) <= 4 then
            return v.hero
        end
    end
    --]]
end

--每帧更新英雄逻辑
--dt 时间
--返回值(无)
function Hero:update(dt)
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

    if self.pause then
        return
    end

	if self.moveInfo.targetPos ~= nil then
		self:updatePos(dt)
	end

    --self.aiPassTime = self.aiPassTime + dt
    --if self.aiPassTime >= self.thinkTime then
        --self.aiPassTime = 0

        --if self.camp ~= CAMP.DEFER and self.soldierType == SOLDIER_TYPE.knight then
            self:doLogic()
        --end
    --end 
end

function Hero:doLogic()
    --有目标先攻击选定的目标
    local target = self:getAttackMajor()
    if target ~= nil and target.id ~= nil and target:getState() ~= AI_STATE.DEATH then
         self:startAttack()
        return
    end

    --冲刺中获取攻击范围内的敌人,否则获取离自己最近的敌人
    local att_major = nil
    if self.isRushing then
        self.time = self.time or 0
        self.time = self.time + 1
        if self.time <= 1 then
            --return
           -- att_major = self:getAttRangeEnemy()
        end
    else
        att_major = self:getNearEnemy()
    end

    --没目标的时候，判断是否换攻击对象
    if att_major and self:getAttackMajor() ~= att_major then
        self:clearChasetDir()
        self:clearMoveInfo()
        self:setAttackMajor(att_major)
         if self.isRushing then
            self.isRushing = false
        else
            self:startAttack()
        end
    end
end











