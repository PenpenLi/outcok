
--[[
	jinyan.zhang
	建筑效果配置
--]]

CopyMapConfig = class("CopyMapConfig")
local instance = nil

local CopyMapTab = require(CONFIG_SRC_PRE_PATH .. "CopyMap") --建筑升级表

--构造
--返回值(无)
function CopyMapConfig:ctor()
	self:init()
end

--初始化
--返回值(无)
function CopyMapConfig:init()
	
end

--获取单例
--返回值(单例)
function CopyMapConfig:getInstance()
	if instance == nil then
		instance = CopyMapConfig.new()
	end
	return instance
end

--获取配置
--返回值(配置)
function CopyMapConfig:getConfig()
	return CopyMapTab
end







