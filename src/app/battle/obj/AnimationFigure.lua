
--[[
	jinyan.zhang
	动画模型
--]]

AnimationFigure = class("AnimationFigure", function()
	return display.newLayer()
end)

--构造
--params 参数
--dir 人物朝向
--soldierType 士兵类型
--owner 动画拥有者
--返回值(无)
function AnimationFigure:ctor(params,dir,soldierType,owner)
	self.params = params or {}
	self.dir = dir
	self.soldierType = soldierType
	self.owner = owner
	self:setNodeEventEnabled(true)

	--创建精灵
	local fileName = self:getFirstFrameAnmationName(self.dir,self.params.idle.defaultFileName)
	self.sprite = display.newSprite(fileName)
	self.sprite:setAnchorPoint(0.5,0.5)
	self.sprite:setPosition(0, 0)
	self:addChild(self.sprite)

	self:setAnchorPoint(0,0)
	self:setContentSize(self.sprite:getBoundingBox())

	self:init()
end

--设置颜色
--color 颜色
--返回值(无)
function AnimationFigure:setMyColor(color)
	if self.sprite ~= nil and color ~= nil then
		self.sprite:setColor(color)
	end
end

--初始化
--返回值(无)
function AnimationFigure:init()
	--MyLog("AnimationFigure init...")
end

--加入到舞台后会调用这个接口
--返回值(无)
function AnimationFigure:onEnter()
	--MyLog("AnimationFigure onEnter()")
end

--离开舞台后会调用这个接口
--返回值(无)
function AnimationFigure:onExit()
	--MyLog("AnimationFigure onExit()")
end

--从内存释放后会调用这个接口
--返回值(无)
function AnimationFigure:onDestroy()
	--MyLog("AnimationFigure onDestroy()")
end 

--是否需要翻转
--dir 方向
--返回值(true:需要翻转，false:不需要)
function AnimationFigure:isNeedFileX(dir)
	if dir >= ANMATION_DIR.LEFT_DOWN and dir <= ANMATION_DIR.LEFT_UP then
		return true
	end
	return false
end

--设置精灵朝向
--dir 精灵朝向
--返回值(无)
function AnimationFigure:setSpriteFace(dir)
	if self:isNeedFileX(dir) then
		self.sprite:setFlippedX(true)
	else
		self.sprite:setFlippedX(false)
	end
end

--获取动画方向
--dir 动画方向	
--返回值(动画方向)
function AnimationFigure:getDir(dir)
	local anmationDir = dir
	if dir >= ANMATION_DIR.LEFT_DOWN and dir <= ANMATION_DIR.LEFT_UP then
		if dir == ANMATION_DIR.LEFT_DOWN then
			anmationDir = ANMATION_DIR.RIGHT_DOWN
		elseif dir == ANMATION_DIR.LEFT then
			anmationDir = ANMATION_DIR.RIGHT
		elseif dir == ANMATION_DIR.LEFT_UP then
			anmationDir = ANMATION_DIR.RIGHT_UP
		end
	end
	return anmationDir
end

--获取空闲动画名
--dir 动画方向
--返回值(动画名)
function AnimationFigure:getIdleAnmationNameByDir(dir)
	local anmationDir = self:getDir(dir)
	return self.params.idle[anmationDir]
end

--获取移动动画名
--dir 动画方向
--返回值(动画名)
function AnimationFigure:getMoveAnmationNameByDir(dir)
	local anmationDir = self:getDir(dir)
	return self.params.move[anmationDir]
end

--获取死亡动画名
--dir 动画方向
--返回值(动画名)
function AnimationFigure:getDeathAnmationNameByDir(dir)
	local anmationDir = self:getDir(dir)
	return self.params.death[anmationDir]
end

--获取攻击动画名
--dir 动画方向
--返回值(动画名)
function AnimationFigure:getAtt1AnmationNameByDir(dir)
	local anmationDir = self:getDir(dir)
	return self.params.att1[anmationDir]
end

--获取攻击动画名
--dir 动画方向
--返回值(动画名)
function AnimationFigure:getAtt2AnmationNameByDir(dir)
	local anmationDir = self:getDir(dir)
	return self.params.att2[anmationDir]
end

--获取受击动画名
--dir 动画方向
--返回值(动画名)
function AnimationFigure:getHurtAnmationNameByDir(dir)
	local anmationDir = self:getDir(dir)
	return self.params.hurt[anmationDir]
end

--获取第一帧空闲动画名
--dir 动画方向
--name 第一帧动画后辍名
--返回值(第一帧动画后辍名)
function AnimationFigure:getFirstFrameAnmationName(dir,name)
	local idleAnmationName = self:getIdleAnmationNameByDir(dir)
	local firstAnmationName = "#" .. idleAnmationName .. name
	return firstAnmationName
end

--获取攻击1特效动画名
--dir 动画方向
--返回值(动画名)
function AnimationFigure:getAtt1EffectAnmationNameByDir(dir)
	local anmationDir = self:getDir(dir)
	return self.params.effect.att1[anmationDir]
end

--获取攻击2特效动画名
--dir 动画方向
--返回值(动画名)
function AnimationFigure:getAtt2EffectAnmationNameByDir(dir)
	local anmationDir = self:getDir(dir)
	return self.params.effect.att2[anmationDir]
end

--停止所有动作
--返回值(无)
function AnimationFigure:stopAllActions()
	self.sprite:stopAllActions()
end

--获取方向
--返回值(方向)
function AnimationFigure:getAnimationDir()
	return self.dir
end

--脚
function AnimationFigure:getAnchorPointWithFoot()
    local x = 0.0
    local y = 0.0
    return cc.p(x, y)
end

--获取攻击动画1延迟检测时间
--返回值(延迟检测时间)
function AnimationFigure:getAtt1DelayCheckTime()
	return self.params.att1.delayAttCheckTime
end

--获取攻击动画2延迟检测时间
--返回值(延迟检测时间)
function AnimationFigure:getAtt2DelayCheckTime()
	return self.params.att2.delayAttCheckTime
end

--获取播放攻击1效果动画延迟时间
--返回值(延迟播放效果时间)
function AnimationFigure:getPlayAtt1EffectDelayTime()
	return self.params.effect.att1.delayPlayEffectTime
end

--获取播放攻击2效果动画延迟时间
--返回值(延迟播放效果时间)
function AnimationFigure:getPlayAtt2EffectDelayTime()
	return self.params.effect.att2.delayPlayEffectTime
end

--获取攻击1特效持续时间
--返回值(攻击特效播放时长)
function AnimationFigure:getAtt1EffectLastTime()
	local time = self.params.effect.att1.time
	if SceneMgr:getInstance():getLastOpenSceneType() == SCENE_TYPE.WORLD then
		time = self.params.effect.att1.worldMap_time
	end
	return time
end

--获取攻击2特效持续时间
--返回值(攻击特效播放时长)
function AnimationFigure:getAtt2EffectLastTime()
	local time = self.params.effect.att2.time
	if SceneMgr:getInstance():getLastOpenSceneType() == SCENE_TYPE.WORLD then
		time = self.params.effect.att2.worldMap_time
	end
	return time
end

--获取攻击1动画的持续时间
--dir 方向
--返回值(播放时长)
function AnimationFigure:getAtt1AnmationLastTime(dir)
	local time = self.params.att1.time
	if SceneMgr:getInstance():getLastOpenSceneType() == SCENE_TYPE.WORLD then
		time = self.params.att1.worldMap_time
	end
	return time
end

--获取攻击2动画的持续时间
--dir 方向
--返回值(播放时长)
function AnimationFigure:getAtt2AnmationLastTime(dir)
	local time = self.params.att2.time
	if SceneMgr:getInstance():getLastOpenSceneType() == SCENE_TYPE.WORLD then
		time = self.params.att2.worldMap_time
	end
	return time
end

--获取受击1特效持续时间
--effectConfig 特效配置信息
--返回值(播放时长)
function AnimationFigure:getHurtEffect1AnimatonLastTime(effectConfig)
	return effectConfig.hurt1.time
end

--获取受击2特效持续时间
--effectConfig 特效配置信息
--返回值(播放时长)
function AnimationFigure:getHurtEffect2AnimatonLastTime(effectConfig)
	return effectConfig.hurt2.time
end

--获取攻击1特效动画大小
--返回值(特效大小)
function AnimationFigure:getAtt1EffectAnimationSize()
	return self.params.effect.att1.size
end

--获取攻击2特效动画大小
--返回值(特效大小)
function AnimationFigure:getAtt2EffectAnimationSize()
	return self.params.effect.att2.size
end

--获取子弹飞行速度1
--返回值(速度)
function AnimationFigure:getFlySpped1()
	local time = self.params.att1.flySpeed
	if SceneMgr:getInstance():getLastOpenSceneType() == SCENE_TYPE.WORLD then
		time = self.params.att1.WorldMap_flySpeed
	end
	return time
end

--获取子弹飞行速度2
--返回值(速度)
function AnimationFigure:getFlySpped2()
	local time = self.params.att2.flySpeed
	if SceneMgr:getInstance():getLastOpenSceneType() == SCENE_TYPE.WORLD then
		time = self.params.att2.WorldMap_flySpeed
	end
	return time
end

--获取死亡动画的持续时间
--返回值(持续时间)
function AnimationFigure:getDeathAnimationLastTime()
	return self.params.death.time
end

--获取攻击1CD时间
--返回值(CD时间)
function AnimationFigure:getAtt1CDTime()
	return self.params.att1.cdTime
end

--获取攻击2CD时间
--返回值(CD时间)
function AnimationFigure:getAtt2CDTime()
	return self.params.att2.cdTime
end

--播放空闲动画
--dir 动画方向
--返回值(无)
function AnimationFigure:playIdleAnmation(dir)
	local idleAnmationName = self:getIdleAnmationNameByDir(dir)
	local anmation = AnmationHelp:getInstance():createAnmation(idleAnmationName,self.params.idle.begin,
																self.params.idle.count,self.params.idle.time)
	AnmationHelp:playAnmationForver(anmation,self.sprite)
	self:setSpriteFace(dir)
end

--播放移动动画
--dir 动画方向
--返回值(无)
function AnimationFigure:playMoveAnmation(dir)
	local moveAnmationName = self:getMoveAnmationNameByDir(dir)
	local anmation = AnmationHelp:getInstance():createAnmation(moveAnmationName,self.params.move.begin,
																self.params.move.count,self.params.move.time)
	AnmationHelp:playAnmationForver(anmation,self.sprite)
	self:setSpriteFace(dir)
end

--播放死亡动画
--dir 动画方向
--返回值(无)
function AnimationFigure:playDeathAnimation(dir)
	local deathAnimation =  self:getDeathAnmationNameByDir(dir)
	local animation = AnmationHelp:getInstance():createAnmation(deathAnimation,self.params.death.begin,
																self.params.death.count,self.params.death.time)
	AnmationHelp:playAnmationOnce(animation,self.sprite)
	self:setSpriteFace(dir)
end

--播放攻击1动画
--dir 动画方向
--返回值(无)
function AnimationFigure:playAtt1Anmation(dir)
	local time = self.params.att1.time
	if SceneMgr:getInstance():getLastOpenSceneType() == SCENE_TYPE.WORLD then
		time = 	self.params.att1.worldMap_time
	end

	local att1AnmationName = self:getAtt1AnmationNameByDir(dir)
	local anmation = AnmationHelp:getInstance():createAnmation(att1AnmationName,self.params.att1.begin,
																self.params.att1.count,time)
	AnmationHelp:playAnmationOnce(anmation,self.sprite)
	self:setSpriteFace(dir)
end

--播放攻击2动画
--dir 动画方向
--返回值(无)
function AnimationFigure:playAtt2Anmation(dir)
	local time = self.params.att2.time
	if SceneMgr:getInstance():getLastOpenSceneType() == SCENE_TYPE.WORLD then
		time = 	self.params.att2.worldMap_time
	end

	local att2AnmationName = self:getAtt2AnmationNameByDir(dir)
	local anmation = AnmationHelp:getInstance():createAnmation(att2AnmationName,self.params.att2.begin,
																self.params.att2.count,time)
	AnmationHelp:playAnmationOnce(anmation,self.sprite)
	self:setSpriteFace(dir)
end

--播放受击动画
--dir 动画方向
--返回值(无)
function AnimationFigure:playHurtAnimation(dir)
	local hurtAnmationName = self:getHurtAnmationNameByDir(dir)
	local anmation = AnmationHelp:getInstance():createAnmation(hurtAnmationName,self.params.hurt.begin,
																self.params.hurt.count,self.params.hurt.time)
	AnmationHelp:playAnmationOnce(anmation,self.sprite)
	self:setSpriteFace(dir)
end

--创建受击1动画特效
--effectConfig 特效配置
--返回值(精灵)
function AnimationFigure:createHurt1EffectAnmation(effectConfig)
	local hurtAnmatonName = effectConfig.hurt1.path
	local anmation = AnmationHelp:getInstance():createAnmation(hurtAnmatonName,effectConfig.hurt1.begin,
																effectConfig.hurt1.count,
																effectConfig.hurt1.time)
	local firstAnmationName = "#" .. hurtAnmatonName .. effectConfig.hurt1.defaultFileName
	local hurtSprite = display.newSprite(firstAnmationName)
	AnmationHelp:playAnmationOnce(anmation,hurtSprite)

	return hurtSprite
end

--创建受击2动画特效
--effectConfig 特效配置
--返回值(精灵)
function AnimationFigure:createHurt2EffectAnmation(effectConfig)
	local hurtAnmatonName = effectConfig.hurt2.path
	local anmation = AnmationHelp:getInstance():createAnmation(hurtAnmatonName,effectConfig.hurt2.begin,
																effectConfig.hurt2.count,
																effectConfig.hurt2.time)
	local firstAnmationName = "#" .. hurtAnmatonName .. effectConfig.hurt2.defaultFileName
	local hurtSprite = display.newSprite(firstAnmationName)
	AnmationHelp:playAnmationOnce(anmation,hurtSprite)
	return hurtSprite
end

--创建攻击1特效动画
--返回值(精灵)
function AnimationFigure:createAtt1EffectAnmation(dir)
	local time = self.params.effect.att1.time
	if SceneMgr:getInstance():getLastOpenSceneType() == SCENE_TYPE.WORLD then
		time = self.params.effect.att1.worldMap_time
	end

	local attEffectAnmationName = self:getAtt1EffectAnmationNameByDir(dir)
	local anmation = AnmationHelp:getInstance():createAnmation(attEffectAnmationName,self.params.effect.att1.begin,
																self.params.effect.att1.count,self.params.effect.att1.time)
	local firstAnmationName = "#" .. attEffectAnmationName .. self.params.effect.att1.defaultFileName
	local attEffectSprite = display.newSprite(firstAnmationName)
	attEffectSprite:setAnchorPoint(0.5,0.5)
	AnmationHelp:playAnmationOnce(anmation,attEffectSprite)
	return attEffectSprite
end

--创建攻击2特效动画
--返回值(精灵)
function AnimationFigure:createAtt2EffectAnmation(dir)
	local time = self.params.effect.att2.time
	if SceneMgr:getInstance():getLastOpenSceneType() == SCENE_TYPE.WORLD then
		time = self.params.effect.att2.worldMap_time
	end

	local attEffectAnmationName = self:getAtt2EffectAnmationNameByDir(dir)
	local anmation = AnmationHelp:getInstance():createAnmation(attEffectAnmationName,self.params.effect.att2.begin,
																self.params.effect.att2.count,time)
	local firstAnmationName = "#" .. attEffectAnmationName .. self.params.effect.att2.defaultFileName
	local attEffectSprite = display.newSprite(firstAnmationName)
	AnmationHelp:playAnmationForver(anmation,attEffectSprite)
	return attEffectSprite
end

--创建弓箭1特效动画
--返回值(精灵)
function AnimationFigure:createGongJian1EffectAnmation()
	local time = self.params.effect.att1.time
	if SceneMgr:getInstance():getLastOpenSceneType() == SCENE_TYPE.WORLD then
		time = self.params.effect.att1.worldMap_time
	end

	local arrowAnmatonName = self.params.effect.att1.path
	local anmaton = AnmationHelp:getInstance():createAnmation(arrowAnmatonName,self.params.effect.att1.begin,
																self.params.effect.att1.count,
																time)
	local firstAnmationName = "#" .. arrowAnmatonName .. self.params.effect.att1.defaultFileName
	local arrowSprite = display.newSprite(firstAnmationName)
	AnmationHelp:playAnmationForver(anmaton,arrowSprite)
	return arrowSprite
end

--创建弓箭2特效动画
--返回值(精灵)
function AnimationFigure:createGongJian2EffectAnmation()
	local time = self.params.effect.att2.time
	if SceneMgr:getInstance():getLastOpenSceneType() == SCENE_TYPE.WORLD then
		time = self.params.effect.att2.worldMap_time
	end

	local arrowAnmatonName = self.params.effect.att2.path
	local anmaton = AnmationHelp:getInstance():createAnmation(arrowAnmatonName,self.params.effect.att2.begin,
																self.params.effect.att2.count,
																time)
	local firstAnmationName = "#" .. arrowAnmatonName .. self.params.effect.att2.defaultFileName
	local arrowSprite = display.newSprite(firstAnmationName)
	AnmationHelp:playAnmationForver(anmaton,arrowSprite)
	return arrowSprite
end

-- 设置状态和方向
--state 状态
--dir 方向
--返回值(无)
function AnimationFigure:setStateAndDir(state,dir)
    local isChange = false
    if self.state == AI_STATE.DEATH then
    	assert(0)
    end
    
    if state ~= nil and state ~= self.state then
        self.state = state
        isChange = true
    end
    
    if dir ~= nil and dir ~= self.dir then
        self.dir = dir
        isChange = true
    end

    if isChange then
        self:updateState()
    end
end

--更新人物状态
--返回值(无)
function AnimationFigure:updateState()
	self:stopAllActions()
	if self.state == AI_STATE.IDLE then
		self:playIdleAnmation(self.dir)
	elseif self.state == AI_STATE.MOVE then
	  	self:playMoveAnmation(self.dir)
	elseif self.state == AI_STATE.DEATH then
		self:playDeathAnimation(self.dir)
	elseif self.state == AI_STATE.HURT then
		self:playHurtAnimation(self.dir)
	elseif self.state == AI_STATE.ATTACT then
		--todo
	end
end










