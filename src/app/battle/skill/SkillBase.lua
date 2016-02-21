
--[[
	jinyan.zhang
	技能基类
--]]

SkillBase = class("SkillBase", function()
	return display.newLayer()
end)

--构造
--params 数据
--useSkillIndex 使用第几个技能
--返回值(无)
function SkillBase:ctor(params,useSkillIndex)
	self:setNodeEventEnabled(true)
	self.params = params
	self.atkAnimationIndex = useSkillIndex
	self:setAnchorPoint(0,0)
	self:setPosition(0, 0)
	self:init()
end

--初始化
--返回值(无)
function SkillBase:init()
	--MyLog("SkillBase init...")
end

--加到舞台后，会调用这个接口
--返回值(无)
function SkillBase:onEnter()
	--MyLog("SkillBase onEnter()..")
end

--离开舞台后，会调用这个接口
--返回值(无)
function SkillBase:onExit()
	--MyLog("SkillBase onExit()")
end

--从内存中删除后，会用调用这个接口
--返回值(无)
function SkillBase:onDestroy()
	--MyLog("SkillBase:onDestroy")
end

--删除技能
--返回值(无)
function SkillBase:removeSkill()
	SkillMgr:getInstance():removeSkill(self)
	if self.params:getState() ~= AI_STATE.DEATH then
		self.params:setStateAndDir(AI_STATE.IDLE, self.params:getDir())
	end
end

--获取攻击特效坐标
--返回值(攻击特效位置)
function SkillBase:getAttEffectPos(attEffect)
	local x,y = self.params:getPosition()
	local attackDis = self.params:getAttackDis()
	local dir = self.params:getDir()
	local pos = cc.p(x,y)
	if dir == ANMATION_DIR.LEFT_DOWN then
		pos.x = pos.x - attackDis
		pos.y = pos.y - attackDis
	elseif dir == ANMATION_DIR.RIGHT_DOWN then
		pos.x = pos.x + attackDis
		pos.y = pos.y - attackDis
	elseif dir == ANMATION_DIR.LEFT_UP then
		pos.x = pos.x - attackDis
		pos.y = pos.y + attackDis
	elseif dir == ANMATION_DIR.RIGHT_UP then
		pos.x = pos.x + attackDis
		pos.y = pos.y + attackDis
	elseif dir == ANMATION_DIR.UP then
		pos.y = pos.y + attackDis
	elseif dir == ANMATION_DIR.DOWN then
		pos.y = pos.y - attackDis
	elseif dir == ANMATION_DIR.LEFT then
		pos.x = pos.x - attackDis
	elseif dir == ANMATION_DIR.RIGHT then
		pos.x = pos.x + attackDis
	end
	return pos
end

--是否命中目标
--返回值(true:命中,false:未命中)
function SkillBase:isHitTarget()
	local attTarget = self.params:getAttackMajor()
	if attTarget ~= nil and attTarget.id and attTarget:getState() ~= AI_STATE.DEATH then
		if self.params:isInTheAttackRange(attTarget) then
			return true
		end
	end
	return false
end

--播放攻击动画
--返回值(无)
function SkillBase:playAttAnimation()
	local figure = self.params.monor
	if self.atkAnimationIndex == 1 then
		figure:playAtt1Anmation(figure:getAnimationDir())
	elseif self.atkAnimationIndex == 2 then
		figure:playAtt2Anmation(figure:getAnimationDir())
	end
end

--运行结束技能ACTION
--返回值(无)
function SkillBase:runEndSkillAction()
	local lastTime = BattleCommon:getInstance():getAttAnimationLastTime(self.params,self.atkAnimationIndex)
	local sequence = transition.sequence({
		cc.DelayTime:create(lastTime),
    	cc.CallFunc:create(self.removeSkill),
	})
	self:runAction(sequence)
end

--获取攻击区
--返回值(攻击区)
function SkillBase:getAtkRect()
	local dir = self.params:getDir()
	local x,y = self.params:getPosition()
	local attackDis = self.params:getAttackDis()
	local atkRect = cc.rect(0,0,attackDis,attackDis)

	if dir == ANMATION_DIR.LEFT_DOWN then
		atkRect.x = x - atkRect.width
		atkRect.y = y - atkRect.height/2
	elseif dir == ANMATION_DIR.RIGHT_DOWN then
		atkRect.x = x 
		atkRect.y = y - atkRect.height/2
	elseif dir == ANMATION_DIR.LEFT_UP then
		atkRect.x = x - atkRect.width
		atkRect.y = y + atkRect.height/2
	elseif dir == ANMATION_DIR.RIGHT_UP then
		atkRect.x = x
		atkRect.y = y + atkRect.height/2
	elseif dir == ANMATION_DIR.UP then
		atkRect.x = x - atkRect.width/2
		atkRect.y = y + atkRect.height
	elseif dir == ANMATION_DIR.DOWN then
		atkRect.x = x - atkRect.width/2
		atkRect.y = y - atkRect.height
	elseif dir == ANMATION_DIR.LEFT then
		atkRect.x = x - atkRect.width
		atkRect.y = y
	elseif dir == ANMATION_DIR.RIGHT then
		atkRect.x = x 
		atkRect.y = y 
	end
	atkRect.y = atkRect.y - atkRect.height/2

	return atkRect
end





