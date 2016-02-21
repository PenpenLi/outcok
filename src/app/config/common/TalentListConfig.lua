--
-- Author: oyhc
-- Date: 2016-01-14 17:05:19
--
-- 领主天赋表
local talentTemplate = require(CONFIG_SRC_PRE_PATH .. "TalentList")

TalentListConfig = class("TalentListConfig")

local instance = nil

-- 获取单例
-- 返回值(单例)
function TalentListConfig:getInstance()
	if instance == nil then
		instance = TalentListConfig.new()
	end
	return instance
end

-- 构造
function TalentListConfig:ctor()
	-- self:init()
end

-- 初始化
function TalentListConfig:init()

end

-- 获取科技配置表
function TalentListConfig:getTalentList()
	return talentTemplate
end

-- 根据type和pos获取天赋模板
function TalentListConfig:getTemplateByTypeAndPos(type, pos)
	for k,v in pairs(talentTemplate) do
		if v.tl_type == type and v.tl_pos == pos then
			return v
		end
	end
	print("根据type和pos获取天赋模板"..type..pos)
end

-- 根据id获取领主天赋模板
-- id
function TalentListConfig:getTemplateByID(id)
	for k,v in pairs(talentTemplate) do
		if v.tl_id == id then
			return v
		end
	end
	print("根据id获取领主天赋模板"..id)
end
