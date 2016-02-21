
--[[
	jinyan.zhang
	技能buff
--]]

SkillBuffBase = class("SkillBuffBase", function()
	return display.newLayer()
end)

--构造
--params 数据
--useSkillIndex 使用第几个技能
--返回值(无)
function SkillBuffBase:ctor(parms,emenyCamp,callback,obj,skillId)
	self.callback = callback
	self.obj = obj
 	self.skillId = skillId
 	self.skillConfig = SkillConfig:getInstance():getSkillTemplateByID(skillId)
 	self.emenyCamp = emenyCamp
 	self:setNodeEventEnabled(true)
 	self:setAnchorPoint(0,0)
	self:setPosition(0, 0)
	self:init()
end

--初始化
--返回值(无)
function SkillBuffBase:init()
	self:create()
end

function SkillBuffBase:create() 
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
		 	self:runEndSkillAction()	
		end),	
	})
	self.bg:runAction(sequence)
end

--运行结束技能ACTION
--返回值(无)
function SkillBuffBase:runEndSkillAction()
	local lastTime = 0.5
	local sequence = transition.sequence({
		cc.DelayTime:create(lastTime),
    	cc.CallFunc:create(self.removeSkill),
	})
	self:runAction(sequence)
end

--删除技能
--返回值(无)
function SkillBuffBase:removeSkill()
	local func = self.callback 
	local obj = self.obj
	SkillMgr:getInstance():removeSkill(self)
	if func ~= nil then
		func(obj)
	end
end

function SkillBuffBase:onEnter()
 	
end

function SkillBuffBase:onExit()
	
end

function SkillBuffBase:onDestroy()
	
end




