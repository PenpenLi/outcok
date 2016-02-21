--
-- Author: oyhc
-- Date: 2015-12-11 16:54:19
--
-- 物品表
local itemTemplate = require(CONFIG_SRC_PRE_PATH .. "ItemTemplate")

ItemTemplateConfig = class("ItemTemplateConfig")

local instance = nil

-- 获取单例
-- 返回值(单例)
function ItemTemplateConfig:getInstance()
	if instance == nil then
		instance = ItemTemplateConfig.new()
	end
	return instance
end

-- 构造
function ItemTemplateConfig:ctor()
	-- self:init()
end

-- 初始化
function ItemTemplateConfig:init()

end

--
function ItemTemplateConfig:getItemTemplate()
	return itemTemplate
end

-- 根据id获取物品模板
-- id
function ItemTemplateConfig:getItemTemplateByID(id)
	for k,v in pairs(itemTemplate) do
		if v.it_id == id then
			return v
		end
	end
end

-- 根据状态获取物品模板
--
function ItemTemplateConfig:getItemTemplateByType(type)
	local arr = {}
	for k,v in pairs(itemTemplate) do
		if v.it_id == type then
			table.insert(arr,v)
		end
	end
	return arr
end