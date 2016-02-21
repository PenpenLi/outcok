
--[[
	jinyan.zhang
	logo界面
--]]

 LogoView = class("LogoView",UIBaseView)

local scheduler = require("framework.scheduler")

--构造
--uiType UI类型
--data 数据
--返回值(无)
function LogoView:ctor(uiType,data)
	self.data = data
	self.super.ctor(self,uiType)
end

--初始化
--返回值(无)
function LogoView:init()
	self.layer = display.newCutomColorLayer(cc.c4b(255,255,255,255),display.width,display.height)
	self.layer:setContentSize(display.width,display.height)
	self.layer:ignoreAnchorPointForPosition(false)
	self.layer:setAnchorPoint(0.5,0.5)
	self.layer:setPosition(display.cx,display.cy)
	self:addChild(self.layer)

	self.logo = display.newSprite("logo/logo.png")
	self.logo:setPosition(display.cx,display.cy)
	self.layer:addChild(self.logo)

	scheduler.performWithDelayGlobal(function(dt)
		UIMgr:getInstance():closeUI(self.uiType)
		UIMgr:getInstance():openUI(UITYPE.LOGIN)
	end, 1)
end

--UI加到舞台后会调用这个接口
--返回值(无)
function LogoView:onEnter()
	--MyLog("LogoView onEnter...")
end

--UI离开舞台后会调用这个接口
--返回值(无)
function LogoView:onExit()
	--MyLog("LogoView onExit()")
end

--析构函数(此时已经从内存中释放掉资源了)
--返回值(无)
function LogoView:onDestroy()
	--MyLog("--LogoView:onDestroy")
end