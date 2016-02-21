--
-- Author: oyhc
-- Date: 2016-01-15 15:58:31
--
-- 领主天赋表
local lordSkillList = require(CONFIG_SRC_PRE_PATH .. "LordSkill")

LordSkillConfig = class("LordSkillConfig")

local instance = nil

-- 获取单例
-- 返回值(单例)
function LordSkillConfig:getInstance()
	if instance == nil then
		instance = LordSkillConfig.new()
	end
	return instance
end

-- 构造
function LordSkillConfig:ctor()
	-- self:init()
end

-- 初始化
function LordSkillConfig:init()

end

-- 获取科技配置表
function LordSkillConfig:getLordSkillList()
	return lordSkillList
end

function LordSkillConfig:isInLordSkillList(id)
	for k,v in pairs(lordSkillList) do
		if v.ls_id == id then
			return true
		end
	end
	return false
end

-- 根据id获取领主技能模板
-- id
function LordSkillConfig:getTemplateByID(id)
	for k,v in pairs(lordSkillList) do
		if v.ls_id == id then
			return v
		end
	end
	print("根据id获取领主技能模板"..id)
end
