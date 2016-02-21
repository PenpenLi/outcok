
--[[
	jinyan.zhang
	子弹类技能
--]]

SkillFly = class("SkillFly",SkillBase)

--构造
--params 数据
--useSkillIndex 使用第几个技能
--返回值(无)
function SkillFly:ctor(params,useSkillIndex)
	self.super.ctor(self,params,useSkillIndex)
end

--初始化
--返回值(无)
function SkillFly:init()
	--MyLog("SkillFly init...")

	--播放攻击动画
	self:playAttAnimation()

	--攻击特效延迟时间
	local attEffectDelayTime = BattleCommon:getInstance():getAttEffectDelayTime(self.params,self.atkAnimationIndex)

	--播放攻击特效
	local effectMgr = EffectMgr:getInstance()
	local sequence = transition.sequence({
		cc.DelayTime:create(attEffectDelayTime),
    	cc.CallFunc:create(function()
    		self:createArrowEffect(figure,effectMgr)
    	end),
	})
	self:runAction(sequence)

	--技能结束
	self:runEndSkillAction()
end

--加到舞台后，会调用这个接口
--返回值(无)
function SkillFly:onEnter()
	--MyLog("SkillFly onEnter()..")
end

--离开舞台后，会调用这个接口
--返回值(无)
function SkillFly:onExit()
	--MyLog("SkillFly onExit()")
end

--从内存中删除后，会用调用这个接口
--返回值(无)
function SkillFly:onDestroy()
	--MyLog("SkillFly:onDestroy")
end

--创建弓箭特效
--figure 人物动画形象
--effectMgr 特效管理器层
--返回值(无) 
function SkillFly:createArrowEffect(figure,effectMgr)
	--目标如果不存在，就结束技能
	local target = self.params:getAttackMajor()
	if target == nil or not target.id or target:getState() == AI_STATE.DEATH then
		self:removeSkill(self)
		return
	end

	local targetPos = Common:getPosition(target)
	local beginPos = Common:getPosition(self.params)

	--创建弓箭抛物线动画
	local arrowSprite = BattleCommon:getInstance():createArrowAnimationEffect(self.params,self.atkAnimationIndex)

	--执行抛物线运动
	local degree = BattleCommon:getInstance():getFlyEffectDegree(self.params:getDir())
	arrowSprite:setRotation(degree)
	arrowSprite:setPosition(beginPos)
	arrowSprite:setScale(BATTLE_CONFIG.SCALE)
	--effectMgr:addChild(arrowSprite)
	self.params:getParent():addChild(arrowSprite)
	local flySpeed = BattleCommon:getInstance():getFlySpeed(self.params,self.atkAnimationIndex)
	local action = BattleCommon:getInstance():initBezierTo(beginPos,targetPos,flySpeed)
	arrowSprite:runAction(action)

	--抛物线运行时间x
	local flyTime = BattleCommon:getInstance():calculateBulletFlyTime(beginPos,targetPos,flySpeed)
	--获取特效大小
	local attEffectSize = BattleCommon:getInstance():getAttEffectAnimationSize(self.params,self.atkAnimationIndex)

	--把特效加到管理器中
	effectMgr:addEffect(self.params,arrowSprite,flyTime,attEffectSize,self.params.enemyCamp,self.atkAnimationIndex)
end



