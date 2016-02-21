--
-- Author: oyhc
-- Date: 2015-12-27 15:55:19
--
local skillTemplate = require(CONFIG_SRC_PRE_PATH .. "SkillList")

SkillConfig = class("SkillConfig")

local instance = nil

-- 获取单例
-- 返回值(单例)
function SkillConfig:getInstance()
	if instance == nil then
		instance = SkillConfig.new()
	end
	return instance
end

-- 构造
function SkillConfig:ctor()
	-- self:init()
end

-- 初始化
function SkillConfig:init()

end

-- 根据id获取物品模板
-- id
function SkillConfig:getSkillTemplateByID(id)
	for k,v in pairs(skillTemplate) do
		if v.sl_id == id then
			return v
		end
	end
	print("找不到模板id为"..id.."的技能")
end