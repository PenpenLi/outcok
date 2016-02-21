
--[[
	jinyan.zhang
	领主头像配置
--]]

local LordHeadTab = require(CONFIG_SRC_PRE_PATH .. "LordHead")

LordHeadConfig = class("LordHeadConfig")

local instance = nil

-- 获取单例
-- 返回值(单例)
function LordHeadConfig:getInstance()
	if instance == nil then
		instance = LordHeadConfig.new()
	end
	return instance
end

-- 构造
function LordHeadConfig:ctor()
	-- self:init()
end

-- 初始化
function LordHeadConfig:init()

end

function LordHeadConfig:getConfig(id)
	for k,v in pairs(LordHeadTab) do
		if v.lh_id == id then
			return v
		end
	end
end

