
--[[
	jinyan.zhang
	读取陷井列表配置表
--]]

TrapListConfig = class("TrapListConfig")
local instance = nil

local TrapListTab = require(CONFIG_SRC_PRE_PATH .. "TrapList")

--构造
--返回值(无)
function TrapListConfig:ctor()
	self:init()
end

--初始化
--返回值(无)
function TrapListConfig:init()
	
end

--获取单例
--返回值(单例)
function TrapListConfig:getInstance()
	if instance == nil then
		instance = TrapListConfig.new()
	end
	return instance
end

--获取配置
--typeId 类型
--level 等级
--返回值(配置)
function TrapListConfig:getConfigByType(typeId,level)
	for k,v in pairs(TrapListTab) do
		if v.tl_armstypeid == typeId and v.tl_level == level then
			return v
		end
	end
end

--获取配置
function TrapListConfig:getConfigById(id)
	for k,v in pairs(TrapListTab) do
		if v.tl_id == id then
			return v
		end
	end
end

--获取配置
function TrapListConfig:getConfig()
	return TrapListTab
end





