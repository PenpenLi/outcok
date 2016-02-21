
--[[
	jinyan.zhang
	所有UI的基类
--]]

UIBaseView = class("UIBaseView",function()
	return display.newLayer()
end)

local scheduler = require("framework.scheduler")

--构造
--uiType UI类型
--delTime 删除UI时间
--返回值(无)
function UIBaseView:ctor(uiType,delTime)
	self.delUITime = delTime or 0
	self.uiType = uiType
	self:setNodeEventEnabled(true)
	self:setAnchorPoint(0.5,0.5)
	self:setPosition(display.cx,display.cy)
	self:init()
end

--屏幕分辨率适配
function UIBaseView:adapterSize()
	local scaleY = display.height/self.root:getBoundingBox().height
	self.root:setScaleY(scaleY)
end

--初始化
--返回值(无)
function UIBaseView:init()
	--MyLog("baeView init...")
end

--UI加到舞台后，会调用这个接口
--返回值(无)
function UIBaseView:onEnter()
	--MyLog("UIBaseView onEnter()..")
end

--UI离开舞台后，会调用这个接口
--返回值(无)
function UIBaseView:onExit()
	--MyLog("UIBaseView onExit()")
end

--关闭UI
--返回值(无)
function UIBaseView:removeFromLayer()
	local function removeSelf(dt)
		self:removeFromParent()
	end
	if self.delUITime ~= 0 then
		scheduler.performWithDelayGlobal(removeSelf, self.delUITime)
	else
		removeSelf()
	end
end

--添加UI到舞台中显示
--zorder 层级
--tag tag
--返回值(无)
function UIBaseView:addToLayer(zorder,tag)
	 UIMgr:getInstance():addToLayer(self,zorder,tag)
end

--UI从内存中删除后，会用调用这个接口
--返回值(无)
function UIBaseView:onDestroy()
	--MyLog("UIBaseView:onDestroy")
end

--开关触摸
--able 使能触摸(true:使能，false:禁止)
--返回值(无)
function UIBaseView:setTouchAble(able)
	Common:setTouchEnabled(self,able)
	if self.root ~= nil then
		Common:setTouchEnabled(self.root,able)
	end
end



