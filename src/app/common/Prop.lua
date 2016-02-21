
--[[
	jinyan.zhang
	通用提示框
--]]

Prop = class("Prop",function()
	return display.newLayer()
end)

local instance = nil

--构造
--返回值(空)
function Prop:ctor()
	self:setNodeEventEnabled(true) 
	self:addToParent()
	self:init()
end

--初始化
--返回值(无)
function Prop:init()
	self.bg = display.newSprite("test/msgbox.png")
	self.bg:setAnchorPoint(0.5,0.5)
	self:addChild(self.bg)
	self.oldSize = self.bg:getBoundingBox()
	local bgPos = self:calBgPos()
	self.bg:setPosition(bgPos)

	local label = display.newTTFLabel({
	    text = "",
	    font = "Arial",
	    size = 32,
	    color = cc.c3b(255, 0, 255), -- 使用纯红色
	    align = cc.TEXT_ALIGNMENT_CENTER,
	    valign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER,
	    dimensions = cc.size(self.bgSize.width-50,0),
	})
	self:addChild(label)
	local labPos = self:calLabelPos()
	label:setPosition(labPos)
	self.label = label
end

--计算提示框背景图片位置
--返回值(背景图片位置)
function Prop:calBgPos()
	local screenSize = Common:getScreenSize()
	self.bgSize = self.bg:getBoundingBox()
	local x = (screenSize.width - self.bgSize.width)/2 + self.bgSize.width/2
	local y = (screenSize.height - self.bgSize.height)/2 + self.bgSize.height/2
	return cc.p(x,y)
end

--计算Lab位置
--返回值(lab位置)
function Prop:calLabelPos()
	return cc.p(self.bg:getPositionX()+2, self.bg:getPositionY())
end

--当提示框加到舞台中后，会调用这个接口
--返回值(无)
function Prop:onEnter()
	--MyLog("Prop onEnter()")
end

--当提示框离开舞台后，会调用这个接口
--返回值(无)
function Prop:onExit()
	--MyLog("Prop onExit()")
end

--从内存中移除了
--返回值(无)
function Prop:onDestroy()
	--MyLog("Prop onDestroy()")
end

--获取单例
--返回值(单例)
function Prop:getInstance()
	if instance == nil then
		instance = Prop.new()
	end
	return instance
end

--添加提示框到场景中
--返回值(无)
function Prop:addToParent()
	local runScene = cc.Director:getInstance():getRunningScene()
	if runScene == nil then 
		return
	end
	runScene:addChild(self, GAME_ZORDER.PROP)
end

--显示消息
--msg 显示文本
--time 显示时间
--返回值(无)
function Prop:showMsg(msg,time)
	self.showTime = time or 1
	self:stopAllAction()
	self:showMagCallback(msg)
	local action = self:createAction()
	self.bg:runAction(action)
	local action = self:createAction()
	self.label:runAction(action)
end

--停止动作
--返回值(空)
function Prop:stopAllAction()
	self.label:stopAllActions()
	self.bg:stopAllActions()
end

--创建淡入淡出动作
--返回值(动作)
function Prop:createAction()
	local sequence = transition.sequence({
		cc.FadeIn:create(0.0),
		cc.DelayTime :create(self.showTime),
	    cc.FadeOut:create(0.3),
	})
	return sequence
end

--显示提示框
--返回值(无)
function Prop:showMagCallback(msg)
	self.label:setString(msg)
	local offset = self.bgSize.height - self.label:getContentSize().height
	if offset < 0 then
		local newHigh = self.label:getContentSize().height + 40 
		local scaleY = newHigh/self.oldSize.height
		self.bg:setScaleY(scaleY)
	else
		self.bg:setScaleY(1)
	end
end


