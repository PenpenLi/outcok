
--[[
	jinyan.zhang
	区域性技能
--]]

SkillRegion = class("SkillRegion",SkillBase)

--构造
--params 数据
--useSkillIndex 使用第几个技能
--返回值(无)
function SkillRegion:ctor(params,useSkillIndex)
	self.super.ctor(self,params,useSkillIndex)
end

--初始化
--返回值(无)
function SkillRegion:init()
	--MyLog("SkillRegion init...")

	--播放攻击动画
	self:playAttAnimation()

	--攻击特效延迟时间
	local attEffectDelayTime = BattleCommon:getInstance():getAttEffectDelayTime(self.params,self.atkAnimationIndex)
	--攻击特效持续时间
	local attEffectLastTime = BattleCommon:getInstance():getAttEffectLastTime(self.params,self.atkAnimationIndex)

	--[[
	--播放攻击特效
	local effectLayer = BattleLogic:getInstance():getEffectLayer()
	local attEffect = nil
	local sequence = transition.sequence({
		cc.DelayTime:create(attEffectDelayTime),
    	cc.CallFunc:create(function()
    		attEffect = BattleCommon:getInstance():createAttEffectAnimation(self.params,self.atkAnimationIndex)
    		effectLayer:addChild(attEffect)
    		local pos = self:getAttEffectPos(attEffect)
    		attEffect:setPosition(pos)
    		attEffect:setScale(BATTLE_CONFIG.SCALE)
    	end),
    	cc.DelayTime:create(attEffectLastTime),
    	cc.CallFunc:create(function()
    		attEffect:removeFromParent()
    	end)
	})
	self:runAction(sequence)
	--]]

	--碰撞检测延迟时间
	local attCheckDelayTime = BattleCommon:getInstance():getCheckDelayTime(self.params,self.atkAnimationIndex)

	--碰撞检测
	local sequence = transition.sequence({
		cc.DelayTime:create(attCheckDelayTime),
    	cc.CallFunc:create(self.checkCollision),
	})
	self:runAction(sequence)

	--技能结束
	self:runEndSkillAction()
end

--加到舞台后，会调用这个接口
--返回值(无)
function SkillRegion:onEnter()
	--MyLog("SkillRegion onEnter()..")
end

--离开舞台后，会调用这个接口
--返回值(无)
function SkillRegion:onExit()
	--MyLog("SkillRegion onExit()")
end

--从内存中删除后，会用调用这个接口
--返回值(无)
function SkillRegion:onDestroy()
	--MyLog("SkillRegion:onDestroy")
end

--碰撞检测
--返回值(无)
function SkillRegion:checkCollision()
	local atkRect = self:getAtkRect()
	BattleCommon:getInstance():checkCollision(self.params,atkRect,self.params.enemyCamp,self.atkAnimationIndex,self.params.params)
end



