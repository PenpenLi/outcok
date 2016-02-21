
--[[
	jinyan.zhang
	箭塔类
--]]

ArrowTower = class("ArrowTower",Monomer)

--构造
--params 参数
--dir 英雄朝向
--soldierType 士兵类型
--camp 阵营(true攻者方,false:防守方)
--返回值(无)
function ArrowTower:ctor(params,dir,soldierType,camp)
	self.super.ctor(self,params,dir,soldierType,camp)
end

--初始化
--返回值(无)
function ArrowTower:init()

end

--加入到舞台后会调用这个接口
--返回值(无)
function ArrowTower:onEnter()
	--MyLog("ArrowTower onEnter()")
	self:showFigure()
end

--离开舞台后会调用这个接口
--返回值(无)
function ArrowTower:onExit()
	--MyLog("ArrowTower onExit()")
end

--从内存释放后会调用这个接口
--返回值(无)
function ArrowTower:onDestroy()
	--MyLog("ArrowTower onDestroy()")
end 

--开始攻击
--返回值(无)
function ArrowTower:startAttack()
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

    -- 敌人在攻击范围内
    if self:isInTheAttackRange(self.m_AttackMajor) then
        local skillIndex = self:getSkillIndex()
        self:normalattackEnemy(skillIndex)
    end
end

--获取攻击范围内的敌人
--返回值(攻击范围内的敌人)
function ArrowTower:getAttRangeEnemy()
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

    ----[[
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

--获取最近的敌人
--返回值(最近的敌人)
function ArrowTower:getNearEnemy()
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

--每帧更新英雄逻辑
--dt 时间
--返回值(无)
function ArrowTower:update(dt)
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

	--有目标先攻击选定的目标
    local target = self:getAttackMajor()
    if target ~= nil and target.id ~= nil then
        self:startAttack()
        return
    end

    local att_major = self:getAttRangeEnemy()

    --没目标的时候，判断是否换攻击对象
    if att_major and self:getAttackMajor() ~= att_major then
        self:clearChasetDir()
        self:setAttackMajor(att_major)
        self:startAttack()
    end
end











