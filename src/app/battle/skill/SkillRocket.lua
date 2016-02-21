
--[[
	jinyan.zhang
	陷井火箭
--]]

 SkillRocket = class("SkillRocket",function()
	return display.newLayer()
end)

function SkillRocket:ctor(params,emenyCamp,callback,obj)
	self.callback = callback
	self.obj = obj
 	self.params = params
 	self.emenyCamp = emenyCamp
 	self:setNodeEventEnabled(true)
 	self:setAnchorPoint(0,0)
	self:setPosition(0, 0)
	self:init()
 end

function SkillRocket:init()
	self:createRocket()
 	self:runEndSkillAction()
end

function SkillRocket:createPos(arry,index,beginPos,targetPos)
	arry[index] = {}
	arry[index].x = beginPos.x
	arry[index].y = beginPos.y
	arry[index].targetX = targetPos.x
	arry[index].targetY = targetPos.y
end

function SkillRocket:createRocket()
	local bgMapSize = BattleLogic:getInstance():getBgMapSize()
	local beginY = bgMapSize.height
	local beginX = 10
	local midY = bgMapSize.height/2 - 200
	local posTab = {}
	self:createPos(posTab,1,cc.p(beginX,beginY),cc.p(beginX,midY))	
	self:createPos(posTab,2,cc.p(150,beginY),cc.p(150,midY))
	self:createPos(posTab,3,cc.p(300,beginY),cc.p(300,midY))	
	self:createPos(posTab,4,cc.p(450,beginY),cc.p(450,midY))	
	self:createPos(posTab,5,cc.p(600,beginY),cc.p(600,midY))
	self:createPos(posTab,6,cc.p(750,beginY),cc.p(750,midY))	
	self:createPos(posTab,7,cc.p(200,beginY),cc.p(200,midY-200))	
	self:createPos(posTab,8,cc.p(400,beginY),cc.p(400,midY-200))	
	self:createPos(posTab,9,cc.p(600,beginY),cc.p(600,midY-200))	
	self:createPos(posTab,10,cc.p(300,beginY),cc.p(300,midY-400))
	-- self:createPos(posTab,11,cc.p(200,beginY),cc.p(200,midY-400))
	-- self:createPos(posTab,12,cc.p(500,beginY),cc.p(500,midY-400))
	-- self:createPos(posTab,12,cc.p(700,beginY),cc.p(700,midY-400))
	-- self:createPos(posTab,13,cc.p(100,beginY),cc.p(100,midY-600))
	-- self:createPos(posTab,14,cc.p(300,beginY),cc.p(300,midY-600))
	-- self:createPos(posTab,15,cc.p(500,beginY),cc.p(500,midY-600))
	-- self:createPos(posTab,16,cc.p(700,beginY),cc.p(700,midY-600))
	-- self:createPos(posTab,17,cc.p(50,beginY),cc.p(50,midY-800))
	-- self:createPos(posTab,18,cc.p(200,beginY),cc.p(200,midY-800))
	-- self:createPos(posTab,19,cc.p(350,beginY),cc.p(350,midY-800))
	-- self:createPos(posTab,20,cc.p(500,beginY),cc.p(500,midY-800))

	local index = 1
	local function createAction()
		local posInfo = posTab[index]
		local x = posInfo.x
		local y = posInfo.y
		local targetX = posInfo.targetX
		local targetY = posInfo.targetY
		local dis = math.abs(targetY-y)
		time = 0.3	

		local sprite = CreateAnimation:getInstance():create(self.params.idle)
	 	self:addChild(sprite)
	 	sprite:setPosition(x, y)
	 	sprite:setRotation(150)

		local sequence = transition.sequence({
			cc.MoveTo:create(time,cc.p(targetX,targetY)),
			cc.CallFunc:create(function()
				Shake:startShake()
				index = index + 1
				if index <= #posTab then
					createAction()
				end
			end),
			cc.DelayTime:create(0.2),
			cc.CallFunc:create(function()
				sprite:removeFromParent()
				Shake:endShake()
			end),
	    })
		sprite:runAction(sequence)
	end	
	createAction()

	--碰撞检测
	local sequence = transition.sequence({
		cc.DelayTime:create(1),
    	cc.CallFunc:create(self.checkCollision),
	})
	self:runAction(sequence)
end

--碰撞检测
--返回值(无)
function SkillRocket:checkCollision()
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

function SkillRocket:createRocket2()
	local bgMapSize = BattleLogic:getInstance():getBgMapSize()
	local beginY = bgMapSize.height
	local beginX = 10
	local midY = bgMapSize.height/2 - 200
	local delayTime = 0.5

	local function createAction(beginPos,targetPos)
		local sprite = CreateAnimation:getInstance():create(self.params,idle)
	 	self:addChild(sprite)
	 	sprite:setPosition(beginPos)

		local sequence = transition.sequence({
			cc.MoveTo:create(delayTime,targetPos),
			cc.CallFunc:create(function()
				Shake:startShake()
			end),
			cc.DelayTime:create(0.2),
			cc.CallFunc:create(function()
				sprite:removeFromParent()
				Shake:endShake()
			end),
	    })
		sprite:runAction(sequence)
	end

	for row=1,10 do
		local function createAnimation()
			for col=1,8 do
				local x = beginX + (col-1)*100
				local y = beginY
				local targetX = x
				local targetY = midY - (row-1)*100
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
end

--运行结束技能ACTION
--返回值(无)
function SkillRocket:runEndSkillAction()
	local lastTime = self.params.lastTime
	local sequence = transition.sequence({
		cc.DelayTime:create(lastTime),
    	cc.CallFunc:create(self.removeSkill),
	})
	self:runAction(sequence)
end

--删除技能
--返回值(无)
function SkillRocket:removeSkill()
	local func = self.callback 
	local obj = self.obj
	SkillMgr:getInstance():removeSkill(self)
	if func ~= nil then
		func(obj)
	end
end

function SkillRocket:onEnter()
 	
end

function SkillRocket:onExit()
	
end

function SkillRocket:onDestroy()
	
end

