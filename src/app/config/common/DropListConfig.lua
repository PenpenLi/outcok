
--[[
	jinyan.zhang
	读取掉落物品
--]]

local DropListTab = require(CONFIG_SRC_PRE_PATH .. "DropList") 

DropListConfig = class("DropListConfig")

local instance = nil

-- 获取单例
-- 返回值(单例)
function DropListConfig:getInstance()
	if instance == nil then
		instance = DropListConfig.new()
	end
	return instance
end

-- 构造
function DropListConfig:ctor()
	-- self:init()
end

-- 初始化
function DropListConfig:init()
	
end

function DropListConfig:getDropItems(copyId)
	local arry = {}
	for k,v in pairs(DropListTab) do
		if v.dl_dropid == copyId then
			table.insert(arry,v.dl_itemid)
		end
	end
	return arry
end
