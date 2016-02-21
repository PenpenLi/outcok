--
-- Author: oyhc
-- Date: 2015-12-27 15:21:15
-- 英雄技能
SkillData = class("SkillData")

--构造
function SkillData:ctor(data)
	self:init(data)
end

--初始化
function SkillData:init(data)
	if #data == 0 then
		print("该英雄服务器没有下发技能")
		return
	end
	--技能实例ID
	self.skill_id = {}
	self.skill_id.id_h = data.skill_id.id_h
	self.skill_id.id_l = data.skill_id.id_l
	-- print("高位",data.skill_id.id_h,"低位",data.skill_id.id_l)
	--唯一id
	self.id = data.skill_id.id_h .. data.skill_id.id_l
	-- 技能模板id
	self.templateID = data.template_id
	--技能模板
	self.skillTemplate = SkillConfig:getInstance():getSkillTemplateByID(self.templateID)
	--名字
	self.name = self.skillTemplate.sl_name
	--icon
	self.icon = self.skillTemplate.sl_icon
	--描述
	self.des = self.skillTemplate.sl_des
end