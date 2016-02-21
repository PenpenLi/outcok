
--[[
	jinyan.zhang
	陷井滚木
--]]

 SkillBowling = class("SkillBowling",function()
	return display.newLayer()
end)

function SkillBowling:ctor(params,emenyCamp,callback,obj)
	self.callback = callback
	self.obj = obj
 	self.params = params
 	self.emenyCamp = emenyCamp
 	self:setNodeEventEnabled(true)
 	self:setAnchorPoint(0,0)
	self:setPosition(0, 0)
	self:init()
 end

function SkillBowling:init()
	self:createBowling()
 	self:runEndSkillAction()
end

function SkillBowling:createBowling()
	local bgMapSize = BattleLogic:getInstance():getBgMapSize()
	local beginX = 10
	local beginY = bgMapSize.height/2 - 100
	local delayTime = 1

	local function createAction(beginPos,targetPos)
		local sprite = CreateAnimation:getInstance():create(self.params.idle)
	 	self:addChild(sprite)
	 	sprite:setPosition(beginPos)
	 	sprite:setOpacity(0)

		local sequence = transition.sequence({
			cc.FadeIn:create(1),
			cc.MoveTo:create(1.1,targetPos),
			cc.CallFunc:create(function()
				sprite:removeFromParent()
			end),
	    })
	    sprite:runAction(sequence)

	    local sequence2 = transition.sequence({
			cc.DelayTime:create(1.1),
			cc.CallFunc:create(function()
				Shake:startShake()
			end),
			cc.DelayTime:create(0.6),
			cc.CallFunc:create(function()
				Shake:endShake()
			end),
			cc.FadeOut:create(0.4),
	    })

		local actions = cca.spawn({sequence,sequence2})
		sprite:runAction(sequence2)

	end

	for row=1,1 do
		local function createAnimation()
			for col=1,8 do
				local x = beginX + (col-1)*100
				local y = beginY
				local targetX = x
				local targetY = 300
				createAction(cc.p(x,y),cc.p(targetX,targetY))
			end
		end
		local time = (row-1)*delayTime
		local sequence = transition.sequence({
			cc.DelayTime:create(time),
			cc.CallFunc:create(function()
				createAnimation()
			end),
	    })
	    self:runAction(sequence)
	end	

	--碰撞检测
	local sequence = transition.sequence({
		cc.DelayTime:create(1.4),
    	cc.CallFunc:create(self.checkCollision),
	})
	self:runAction(sequence)
end

--碰撞检测
--返回值(无)
function SkillBowling:checkCollision()
	local soldierList = HeroMgr:getInstance():getSoldierList(self.emenyCamp)
	if soldierList == nil then
		return
	end

    for k,v in pairs(soldierList) do
        if v.hero:getState() ~= AI_STATE.DEATH then
			--播放受击特效
            local hurtEffect = CreateAnimation:getInstance():create(self.params.hurtEffect)
            v.hero:addChild(hurtEffect)
            hurtEffect:setPosition(0, 0)
            hurtEffect:setScale(BATTLE_CONFIG.SCALE)
            v.hero:setStateAndDir(AI_STATE.HURT, v.hero:getDir())

            local lastTime = self.params.hurtEffect.time
            local sequence = transition.sequence({
                cc.DelayTime:create(lastTime),
                cc.CallFunc:create(function()
                    hurtEffect:removeFromParent()
                    --切回空闲状态
                    if v.hero:getState() ~= AI_STATE.DEATH and not SceneMgr:isAtCopyMap() then
                        v.hero:setStateAndDir(AI_STATE.IDLE, v.hero:getDir())
                    end
                end),
            })
            hurtEffect:runAction(sequence)
        end
    end
end

--运行结束技能ACTION
--返回值(无)
function SkillBowling:runEndSkillAction()
	local lastTime = self.params.lastTime
	local sequence = transition.sequence({
		cc.DelayTime:create(lastTime),
    	cc.CallFunc:create(self.removeSkill),
	})
	self:runAction(sequence)
end

--删除技能
--返回值(无)
function SkillBowling:removeSkill()
	local func = self.callback 
	local obj = self.obj
	SkillMgr:getInstance():removeSkill(self)
	if func ~= nil then
		func(obj)
	end
end

function SkillBowling:onEnter()
 	
end

function SkillBowling:onExit()
	
end

function SkillBowling:onDestroy()
	
end

