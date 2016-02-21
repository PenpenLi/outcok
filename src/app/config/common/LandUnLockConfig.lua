
--[[
	jinyan.zhang
	区域解锁表
--]]


local LandUnlockTab = require(CONFIG_SRC_PRE_PATH .. "LandUnlock")

LandUnLockConfig = class("LandUnLockConfig")

local instance = nil

-- 获取单例
-- 返回值(单例)
function LandUnLockConfig:getInstance()
	if instance == nil then
		instance = LandUnLockConfig.new()
	end
	return instance
end

-- 构造
function LandUnLockConfig:ctor()
	-- self:init()
end

-- 初始化
function LandUnLockConfig:init()

end

function LandUnLockConfig:getUnLockAreaByIndex(index)
	local arry = {}
	for k,v in pairs(LandUnlockTab) do
		if v.lu_unlockid == index then
			table.insert(arry,v.lu_landid)
		end
	end
	return arry
end
