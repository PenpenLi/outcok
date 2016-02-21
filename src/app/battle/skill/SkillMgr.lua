
--[[
	jinyan.zhang
	技能管理器
--]]

SkillMgr = class("SkillMgr")

local instance = nil

--构造
--返回值(空)
function SkillMgr:ctor()
	self:init()
end

--初始化
--返回值(无)
function SkillMgr:init()
	self.list = {}
	self.id = 0
end

--加入到舞台后会调用这个接口
--返回值(无)
function SkillMgr:onEnter()
	--MyLog("SkillMgr onEnter()")
end

--离开舞台后会调用这个接口
--返回值(无)
function SkillMgr:onExit()
	--MyLog("SkillMgr onExit()")
end

--从内存释放后会调用这个接口
--返回值(无)
function SkillMgr:onDestroy()
	--MyLog("SkillMgr onDestroy()")
end 

--获取单例
--返回值(单例)
function SkillMgr:getInstance()
	if instance == nil then
		instance = SkillMgr.new()
	end
	return instance
end

--创建技能id
--返回值(技能id)
function SkillMgr:createSkillId()
	self.id = self.id + 1
	if self.id > 9999 then
		self.id = 1
	end
	return self.id
end

--创建技能
--skillType 技能类型
--owner  技能拥有者
--useSkillIndex 使用第几个技能
--返回值(技能)
function SkillMgr:createSkill(skillType,owner,useSkillIndex)
	local skill = nil
	if skillType == SkillsType.REGION then  --区域性
		skill = SkillRegion.new(owner,useSkillIndex)
	elseif skillType == SkillsType.FLG then --子弹
		skill = SkillFly.new(owner,useSkillIndex)
	end

	if skill ~= nil then
		local newSkillId = self:createSkillId()
		self:addSkill(skillType,owner,skill,newSkillId,useSkillIndex)
	end

	return skill
end

--创建全屏技能
function SkillMgr:createNewSkill(skillType,params,emenyCamp,callback,obj,skillId)
	local skill = nil
	if skillType == SkillsType.FALLROCEK then  --陷井落石
		skill = SkillFallingRocks.new(params,emenyCamp,callback,obj)
	elseif skillType == SkillsType.BOWLING then --陷井滚木
		skill = SkillBowling.new(params,emenyCamp,callback,obj)
	elseif skillType == SkillsType.ROCKET then --陷井火箭
		skill = SkillRocket.new(params,emenyCamp,callback,obj)
	elseif skillType == SkillsType.HERO_ROCKET then  --英雄火箭
		skill = SkillHeroRocket.new(params,emenyCamp,callback,obj,skillId)
	elseif skillType == SkillsType.BUFF then  --buff
		skill = SkillBuffBase.new(params,emenyCamp,callback,obj,skillId)
	end

	if skill ~= nil then
		local newSkillId = self:createSkillId()
		self:addSkill(skillType,nil,skill,newSkillId)
	end

	return skill
end

--添加技能
--skillType 技能类型
--owner  技能拥有者
--skill 技能
--skillId 技能id
--useSkillIndex 使用第几个技能
--返回值(无)
function SkillMgr:addSkill(skillType,owner,skill,skillId,useSkillIndex)
	local info = {}
	info.skillType = skillType
	info.owner = owner
	info.skillId = skillId
	info.skill = skill
	info.useSkillIndex = useSkillIndex
	table.insert(self.list,info)
end

--删除技能
--owner  拥有者
--返回值(无)
function SkillMgr:removeAllSkill(owner)
	for k,v in pairs(self.list) do
		if v.owner == owner then
			table.remove(self.list,k)
			v.skill:removeFromParent()
		end
	end
end

--删除技能
--skill  技能
--返回值(无)
function SkillMgr:removeSkill(skill)
	for k,v in pairs(self.list) do
		if v.skill == skill then
			table.remove(self.list,k)
			v.skill:removeFromParent()
			break
		end
	end
end



