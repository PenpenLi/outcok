--
-- Author: Your Name
-- Date: 2016-01-15 16:02:51
-- 领主技能
LordSkillData = class("LordSkillData")

local instance = nil

-- 获取单例
-- 返回值(单例)
function LordSkillData:getInstance()
	if instance == nil then
		instance = LordSkillData.new()
	end
	return instance
end

--构造
function LordSkillData:ctor()
	self:init()
end

--初始化
function LordSkillData:init()
	-- 领主技能列表
	self:createLordSkillList()
end

-- 创建领主技能
function LordSkillData:createLordSkillList()
	self.lordSkillList = {}
	local list = LordSkillConfig:getInstance():getLordSkillList()
	for i=1,#list do
		local info = self:createLordSkill(list[i])
		self:addItem(self.lordSkillList, info)
	end
end

function LordSkillData:createLordSkill(data)
	local info = {}
	-- 模板id
	info.templateID = data.ls_id
	-- 名字
	info.name = data.ls_name
	-- icon
	info.icon = data.ls_icon
	-- 类型
	info.type = data.ls_type
	-- 描述
	info.des = data.ls_des
	-- cd
	info.cdtime = data.ls_cdtime
	-- 持续时间
	info.time = data.ls_continuedtime
	return info
end

-- 设置数据列表
function LordSkillData:setLordSkillList(arr)
	for k,v in pairs(arr) do
		for i,info in pairs(self.lordSkillList) do
			if v.template_id == info.templateID then
				--实例id
				info.objId = {
					id_h = v.skill_id.id_h,
					id_l = v.skill_id.id_l,
				}
				-- 唯一id
				info.id = info.objId.id_h .. info.objId.id_l
				-- 冷却开始时间
				info.cdStartTime = v.cdstart_time
				-- 持续技能的定时器，定时器结束就是持续时间结束
				info.timer_id = v.timer_id
			end
		end
	end
end

-- 设置数据
function LordSkillData:setLordSkillInfo(data)
	for k,v in pairs(self.lordSkillList) do
		local id = data.skillid.id_h .. data.skillid.id_l
		if id == v.id then
			-- 冷却开始时间
			v.cdstartTime = data.cdstartTime
			-- 持续技能的定时器，定时器结束就是持续时间结束
			local info = TimeInfoData:getInstance():addTimeInfo(data.duration)
			if info ~= nil then
				v.timeInfoID = {
					id_h = info.id_h,
					id_l = info.id_l,
				}
			end
			
			-- info.start_time = data.cdstartTime
			-- data.duration
			-- 改变的属性, 根据属性类型区别哪个属性
			-- data.attribs
		end
	end
end

-- 根据index获取领主技能数据
function LordSkillData:getLordSkillInfoByIndex(index)
	return self.lordSkillList[index]
end

-- 删除cd开始时间
function LordSkillData:delLordSkillCDData(id)
	for k,v in pairs(self.lordSkillList) do
		if id == v.id then
			info.cdStartTime = 0
			return
		end
	end
end

-- 删除数据
function LordSkillData:delLordSkillTimeObjId(data)
	for k,v in pairs(self.lordSkillList) do
		local id = data.skillid.id_h .. data.skill_id.id_l
		if id == v.id then
			v.timeObjId = nil
			TimeInfoData:getInstance():detTimeInfoById(v.timeInfoID.id_h,v.timeInfoID.id_l)
			return
		end
	end
end

-- 添加数据
-- list 数组
-- info 数据
function LordSkillData:addItem(list,info)
	table.insert(list,info)
end
