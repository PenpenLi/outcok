
--[[
	jinyan.zhang
	英雄全屏火箭技能
--]]

 SkillHeroRocket = class("SkillHeroRocket",function()
	return display.newLayer()
end)

function SkillHeroRocket:ctor(params,emenyCamp,callback,obj,skillId)
	self.callback = callback
	self.obj = obj
 	self.params = params
 	self.emenyCamp = emenyCamp
 	self.skillId = skillId
 	self.skillConfig = SkillConfig:getInstance():getSkillTemplateByID(skillId)
 	self:setNodeEventEnabled(true)
 	self:setAnchorPoint(0,0)
	self:setPosition(0, 0)
	self:init()
 end

function SkillHeroRocket:init()
	self:create()
end

function SkillHeroRocket:create() 
	self.bg = display.newSprite("battle/skillfloor.png")
	self.bg:setAnchorPoint(0,0.5)
	SceneMgr:getInstance():getUILayer():addChild(self.bg,10)
	local bgMapSize = BattleLogic:getInstance():getBgMapSize()
	local y = bgMapSize.height/2 - 50
	self.bg:setPosition(0, -self.bg:getContentSize().height/2-70)

	local headImg = MMUIHead:getInstance():getHeadByHeadId("hero1001",1)
	headImg:setAnchorPoint(0,0)
	self.bg:addChild(headImg)
	headImg:setScale(0.8)
	headImg:setPosition(50, self.bg:getContentSize().height/2)

	 local label = display.newTTFLabel({
        text = "",
        font = "Arial",
        size = 36,
        color = cc.c3b(255, 0, 0), -- 使用纯红色
    })
    self.bg:addChild(label)
    label:setAnchorPoint(0,0.5)
    label:setPosition(300, self.bg:getContentSize().height/2+30)
    label:setString(self.skillConfig.sl_name)

    local sequence = transition.sequence({
    	cc.MoveTo:create(0.1,cc.p(0,self.bg:getContentSize().height/2)),
		cc.DelayTime:create(1),
		cc.MoveTo:create(0.1,cc.p(0,-self.bg:getContentSize().height/2-70)),
		cc.CallFunc:create(function()
			self.bg:removeFromParent()
			self:createFalling()
		 	self:runEndSkillAction()	
		end),	
	})
	self.bg:runAction(sequence)
end

function SkillHeroRocket:createPos(arry,index,beginPos,targetPos)
	arry[index] = {}
	arry[index].x = beginPos.x
	arry[index].y = beginPos.y
	arry[index].targetX = targetPos.x
	arry[index].targetY = targetPos.y
end

function SkillHeroRocket:createFalling()
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
function SkillHeroRocket:checkCollision()
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
function SkillHeroRocket:runEndSkillAction()
	local lastTime = self.params.lastTime
	local sequence = transition.sequence({
		cc.DelayTime:create(lastTime),
    	cc.CallFunc:create(self.removeSkill),
	})
	self:runAction(sequence)
end

--删除技能
--返回值(无)
function SkillHeroRocket:removeSkill()
	local func = self.callback 
	local obj = self.obj
	SkillMgr:getInstance():removeSkill(self)
	if func ~= nil then
		func(obj)
	end
end

function SkillHeroRocket:onEnter()
 	
end

function SkillHeroRocket:onExit()
	
end

function SkillHeroRocket:onDestroy()
	
end

