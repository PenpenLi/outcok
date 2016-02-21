--
-- Author: Your Name
-- Date: 2016-01-14 17:13:22
-- 天赋
TalentData = class("TalentData")

-- 天赋类型
TalentDataType =
{
	mil = 1,  --军事
	gdp = 2,  --经济
	def = 3,  --防御
}

local instance = nil

--构造
--返回值(无)
function TalentData:ctor()
	self:init()
end

--获取单例
--返回值(单例)
function TalentData:getInstance()
	if instance == nil then
		instance = TalentData.new()
	end
	return instance
end

--初始化
function TalentData:init()
end

-- 根据类型创建对应的科技树
-- arr 对应的数组
-- type 类型，1为军事，2为经济，3为防御
function TalentData:createListByType(arr, type)
	local list = TalentListConfig:getInstance():getTalentList()
	for k,v in pairs(list) do
		if type == v.tl_type then
			local info = self:ctrateInfo(v)
			self:addItem(arr, info)
		end
	end
end

-- 创建数据
-- data 配置的info
function TalentData:ctrateInfo(data)
	local info = {}
	-- 科技配置表Id
	info.id = data.tl_id
	-- 科技等级
	info.level = 0
	-- 名字
	info.name = data.tl_name
	-- 图标
	info.icon = data.tl_icon
	-- 描述
	info.des = data.tl_des
	-- 类型
	info.type = data.tl_type
	-- 最大等级
	info.maxlv = data.tl_maxlv
	-- 位置
	info.pos = data.tl_pos
	-- 前置条件
	info.beforeArr = {}
	-- 创建前置条件
	self:createBeforeList(info)
	return info
end

-- 创建前置条件
function TalentData:createBeforeList(info)
	if info.level == 0 then
		-- 当前增益
		info.gain = "0%"
	else
		-- print("当前的升级信息")
		-- 当前的升级信息
		local curLevelInfo = TalentUpgradeConfig:getInstance():getTemplateByIDAndLevel(info.id, info.level)
		-- 当前增益
		info.gain = TalentUpgradeConfig:getInstance():getTalentAttribute(curLevelInfo)
	end
	-- 判断是否满级
	if info.level == info.maxlv then
		return
	end
	-- print("下一级的升级信息",info.id, info.level + 1)
	-- 下一级的升级信息
	local nextLevelInfo = TalentUpgradeConfig:getInstance():getTemplateByIDAndLevel(info.id, info.level + 1)
	-- 下一级增益
	info.nextLevelGain = TalentUpgradeConfig:getInstance():getTalentAttribute(nextLevelInfo)
	--
	local techInfo = TalentListConfig:getInstance():getTemplateByID(info.id)
	-- 条件1
	if techInfo.tl_beforetalent1pos ~= -1 then
		self:createBefore(info.beforeArr, techInfo.tl_beforetalent1pos, techInfo.tl_beforetalent1lv, info.type)
	end
	
	-- 条件2
	if techInfo.tl_beforetalent2pos ~= -1 then
		self:createBefore(info.beforeArr, techInfo.tl_beforetalent2pos, techInfo.tl_beforetalent2lv, info.type)
	end
	-- 条件3
	if techInfo.tl_beforetalent3pos ~= -1 then
		self:createBefore(info.beforeArr, techInfo.tl_beforetalent3pos, techInfo.tl_beforetalent3lv, info.type)
	end
end

function TalentData:createBefore(arr, pos, level, type)
	if id ~= -1 then
		-- 前置条件
		local techInfo = TalentListConfig:getInstance():getTemplateByTypeAndPos(type, pos)
		--
		local beforeInfo = self:createBeforeInfo(techInfo.tl_id, techInfo.tl_name, level, techInfo.tl_icon)
		self:addItem(arr, beforeInfo)
	end
end

function TalentData:createBeforeInfo(id, name, level, icon)
	local info = {}
	-- 前置条件id
	info.id = id
	-- 名字
	info.name = name
	-- 科技等级
	info.level = level
	-- 科技图标
	info.icon = icon
	return info
end

-- 根据id获取科技配置
-- arr 对应的数组
-- id 
function TalentData:getInfoByID(arr, id)
	for k,v in pairs(arr) do
		if id == v.id then
			return v
		end
	end
	print("错误 根据id获取天赋配置：",id)
end

-- 根据pos获取科技配置
-- arr 对应的数组
-- id 
function TalentData:getInfoByPos(arr, pos)
	for k,v in pairs(arr) do
		if pos == v.pos then
			return v
		end
	end
	print("错误 根据pos获取天赋配置：",id)
end

-- 设置数据
-- arr 服务器下发的数组
-- totalArr 列表
function TalentData:setTalentInfo(arr,totalArr)
	for k,v in pairs(arr) do
		for i,info in pairs(totalArr) do
			if v.type_id == info.id then
				info.level = v.level
				-- 创建前置条件
				self:createBeforeList(info)
				-- 判断是否有定时器
				if v.skill_id ~= nil then
					info.skillID = {
						id_h = v.skill_id.id_h,
						id_l = v.skill_id.id_l,
					}
				end
			end
		end
	end
end

-- 获取某个天赋类型的总点数
-- arr 数组
function TalentData:getPointByArr(arr)
	local point = 0
	for k,v in pairs(arr) do
		print("aaaaa:",v.level)
		point = point + v.level
	end
	return point
end

-- 添加数据
-- list 数组
-- info 数据
function TalentData:addItem(list,info)
	table.insert(list,info)
end

