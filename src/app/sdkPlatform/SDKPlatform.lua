
--[[
	jinyan.zhang
	SDK平台相关的处理
--]]

SDKPlatform = class("SDKPlatform")
local instance = nil

--构造
--返回值(无)
function SDKPlatform:ctor()
	self:init()
end

--初始化
--返回值(无)
function SDKPlatform:init()
	
end

--打开SDK平台
function SDKPlatform:startPlatform(platFormCallback)
	platFormCallback()
end

--获取单例
--返回值(单例)
function SDKPlatform:getInstance()
	if instance == nil then
		instance = SDKPlatform.new()
	end
	return instance
end