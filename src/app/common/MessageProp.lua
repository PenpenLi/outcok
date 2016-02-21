
--[[
	jinyan.zhang
	网络消息转菊花提示
--]]

MessageProp = class("MessageProp",function()
	return display.newLayer()
end)

local scheduler = require("framework.scheduler")

local instance = nil
local messagePropTag = -98221

--构造
--返回值(无)
function MessageProp:ctor()
	self:setNodeEventEnabled(true) 
	self:init()
end

--初始化
--返回值(无)
function MessageProp:init()
	self.root = Common:loadUIJson(LOADPROP_PATH)
	self:addChild(self.root)

	self.pan = Common:seekNodeByName(self.root,"pan")

	self.rolling = display.newSprite("test/loading_juhua.png")
	self.rolling:setPosition(0,0)
	self:addChild(self.rolling)
	local sequence = transition.sequence({
			cc.RotateBy:create(1, 360),
        })
    local action = cc.RepeatForever:create(sequence)
	self.rolling:runAction(action)

	local label = display.newTTFLabel({
	    text = "",
	    font = "Arial",
	    size = 26,
	    color = cc.c3b(255, 0, 255), -- 使用纯红色
	    --align = cc.TEXT_ALIGNMENT_CENTER,
	    --valign = cc.VERTICAL_TEXT_ALIGNMENT_CENTER,
	    --dimensions = cc.size(self.bgSize.width-50,0),
	})
	self:addChild(label)
	label:setPosition(0,self.rolling:getPositionY()+30)
	self.label = label
	self.label:setVisible(false)
end

function MessageProp:setTouchAble(able)
	if able ~= nil then
		self.pan:setTouchEnabled(able)
	end
end

--加入舞台后，会调用这个接口
--返回值(无)
function MessageProp:onEnter()
	--MyLog("MessageProp:onEnter()")
end

--离开舞台后，会调用这个接口
--返回值(无)
function MessageProp:onExit()
	--MyLog("MessageProp:onExit()")
	self:stopTime()
end

--从内存中删除掉后，会调用这个接口
--返回值(无)
function MessageProp:onDestroy()
	--MyLog("MessageProp:onDestroy()")
end

--开启超时检测定时器
--返回值(无)
function MessageProp:openTime()
	if self.handle  ~= nil then
		return
	end
    self:stopTime()
    self.handle = scheduler.performWithDelayGlobal(handler(self, self.timeOut), 10)
end

--关闭超时检测定时器
--返回值(无)
function MessageProp:stopTime()
	if self.handle ~= nil then
		scheduler.unscheduleGlobal(self.handle)
		self.handle = nil
	end
end

--网络连接超时检测
--dt 时间
--返回值(无)
function MessageProp:timeOut(dt)
	self:stopTime()
	self:removeFromParent()
end

--菊花位置
--返回值(无)
function MessageProp:setRollingPos(pos)
	if pos == nil then
		return
	end

	self.rolling:setPosition(pos)
	self.label:setPosition(pos.x,pos.y+30)
end

--显示网络消息提示
--parent 网络消息提示框父结点
--x 坐标
--y 坐标
--able 是否要敝掉触摸(true:是,false:否)
--tips 提示内容
--返回值(无)
function MessageProp:apper(parent,x,y,tips,able)
	parent = parent or cc.Director:getInstance():getRunningScene()
	if parent == nil then
		return
	end
	x = x or display.cx 
	y = y or display.cy
	tips = tips or ""
	able = able or true

	local propNode = parent:getChildByTag(messagePropTag)
	if propNode == nil then
		instance = MessageProp.new()
		parent:addChild(instance, 3000, messagePropTag)
		instance:setRollingPos(cc.p(x,y))
		instance:stopTime()
		instance:openTime()
		instance.label:setString(tips)
		instance.parent = parent
		instance:setTouchAble(able)
	end
end

--删除网络消息提示
--返回值(无)
function MessageProp:dissmis()
	if instance == nil or instance.parent == nil then
		return
	end

	local propNode = instance.parent:getChildByTag(messagePropTag)
	if propNode ~= nil then
		propNode:removeFromParent()
	end
end



