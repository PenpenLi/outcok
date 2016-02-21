
--[[
	jinyan.zhang
	怪物类
--]]

Monster = class("Monster",Monomer)

--构造
--params 参数
--dir 英雄朝向
--soldierType 士兵类型
--camp 阵营(true攻者方,false:防守方)
--hp 血量
--返回值(无)
function Monster:ctor(params,dir,soldierType,camp,hp)
    self.curHp = hp
    self.maxHp = hp
	self.super.ctor(self,params,dir,soldierType,camp)
end

--初始化
--返回值(无)
function Monster:init()
    self:createHeadHp(cc.size(40,4))
end

--减少Hp
--minusHp 减少的HP
--返回值(无)
function Monster:minusHp(minusHp)
    self.curHp = self.curHp - minusHp
    if self.curHp < 0 then
        self.curHp = 0
    end
    local per = (self.curHp/self.maxHp)*100
    self.hp:setPercentage(per)
end

function Monster:getHp()
    return self.curHp
end

--加入到舞台后会调用这个接口
--返回值(无)
function Monster:onEnter()
	--MyLog("Monster onEnter()")

	self:showFigure()
end

--离开舞台后会调用这个接口
--返回值(无)
function Monster:onExit()
	--MyLog("Monster onExit()")
end

--从内存释放后会调用这个接口
--返回值(无)
function Monster:onDestroy()
	--MyLog("Monster onDestroy()")
end 

--开始攻击
--返回值(无)
function Monster:startAttack()
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
    --if self:isInTheAttackRange(self.m_AttackMajor) then
        local skillIndex = self:getSkillIndex()
        self:normalattackEnemy(skillIndex)
    --end
end

--受击
--atter 攻击者
--返回值(无)
function Monster:hurt(atter)
    self.super.hurt(atter)
    if self:getAttackMajor() == nil then
        self:setAttackMajor(atter)
    end
end

--获取攻击范围内的敌人
--返回攻击范围内的敌人
function Monster:getAttDisEnemy()
    local soldierList = HeroMgr:getInstance():getSoldierList(self.enemyCamp)
    local pos = Common:getPosition(self)
    local attkDis = self:getAttackDis()

    for k,v in pairs(soldierList) do
        if v.hero:getState() ~= AI_STATE.DEATH then
            local targetPos = Common:getPosition(v.hero)
            local dis = cc.pGetDistance(targetPos,pos)
            if dis <= attkDis then
                return v.hero
            end
        end
    end
end

--获取技能CD时间
--useSkillIndex 使用第几个技能
--返回值(技能CD时间)
function Monster:getSkillCDTime(useSkillIndex)
    return 0
end

--每帧更新英雄逻辑
--dt 时间
--返回值(无)
function Monster:update(dt)
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
        --return
    end

	--有目标先攻击选定的目标
    local target = self:getAttackMajor()
    if target ~= nil and target.id ~= nil and target:getState() ~= AI_STATE.DEATH then
        self:startAttack()
        return
    end

    local target = self:getAttDisEnemy()
    if target ~= nil then
        self:setAttackMajor(target)
    end
end











