
--[[
	jinyan.zhang
	UI基类
--]]

BaseView = class("BaseView",function()
	return display.newLayer()
end)

local scheduler = require("framework.scheduler")

--view 基类
function BaseView:ctor(theSelf,uiType,data)
	self.theSelf = theSelf
	self.theSelf.uiType = uiType
	self.theSelf.data = data
	self.uiType = uiType

	--保存UI
	self.arryUI = {}
	self:addView(self.theSelf)

	self.theSelf:setNodeEventEnabled(true)
	self:setNodeEventEnabled(true)
	self.theSelf:setAnchorPoint(0.5,0.5)
	self.theSelf:setPosition(display.cx,display.cy)
	self.theSelf:addChild(self)
	self.theSelf:init(self)
	self:adapter()
end

--显示菜单
function BaseView:showMenu()
	if self.menu  ~= nil then
		self.menu:showView(self.menu)
	end
end

function BaseView:addView(view)
	if view == nil then
		return
	end
	for k,v in pairs(self.arryUI) do
		if v == view then
			return
		end
	end
	table.insert(self.arryUI,view)
end

function BaseView:hideView()
	for k,v in pairs(self.arryUI) do
		v:hideView()
	end
end

function BaseView:showView(view)
	if view == nil then
		return
	end
	
	self:hideView()
	view:showView()
end

--显示顶层UI
function BaseView:showTopView()
	local command = UIMgr:getInstance():getUICtrlByType(self.uiType)
	if command ~= nil then
		self:showView(command.view)
	end
end

--屏幕分辨率适配
function BaseView:adapter()
	local scaleY = display.height/self.theSelf.root:getBoundingBox().height
	self.theSelf.root:setScaleY(scaleY)
end

--添加UI到舞台中显示
--zorder 层级
--tag tag
--返回值(无)
function BaseView:addToLayer(zorder,tag)
	UIMgr:getInstance():addToLayer(self.theSelf,zorder,tag)
end

--关闭UI
--返回值(无)
function BaseView:removeFromLayer()
	local function removeSelf(dt)
		self.theSelf:removeFromParent()
	end
	if self.theSelf.delUITime ~= nil and self.theSelf.delUITime > 0 then
		scheduler.performWithDelayGlobal(removeSelf, self.theSelf.delUITime)
	else
		removeSelf()
	end
end

function BaseView:onEnter()

end

function BaseView:onExit()

end

--UI从内存中删除后，会用调用这个接口
--返回值(无)
function BaseView:onDestroy()
end
