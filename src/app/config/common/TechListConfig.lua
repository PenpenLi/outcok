--
-- Author: oyhc
-- Date: 2016-01-05 22:47:01
--
-- 科技列表
local techTemplate = require(CONFIG_SRC_PRE_PATH .. "TechList")

TechListConfig = class("TechListConfig")

local instance = nil

-- 获取单例
-- 返回值(单例)
function TechListConfig:getInstance()
	if instance == nil then
		instance = TechListConfig.new()
	end
	return instance
end

-- 构造
function TechListConfig:ctor()
	-- self:init()
end

-- 初始化
function TechListConfig:init()

end

-- 获取科技配置表
function TechListConfig:getTechList()
	return techTemplate
end

-- 根据type和pos获取天赋模板
function TechListConfig:getTemplateByTypeAndPos(type, pos)
	for k,v in pairs(techTemplate) do
		if v.tl_type == type and v.tl_pos == pos then
			return v
		end
	end
	print("根据type和pos获取科技模板"..type..pos)
end

-- 根据id获取科技模板
-- id
function TechListConfig:getTemplateByID(id)
	for k,v in pairs(techTemplate) do
		if v.tl_id == id then
			return v
		end
	end
	print("根据id获取科技模板："..id)
end
