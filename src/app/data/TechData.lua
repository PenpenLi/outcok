--
-- Author: oyhc
-- Date: 2016-01-05 22:24:53
--
TechData = class("TechData")

-- 科技类型
TechDataType =
{
	mil = 1,  --军事
	gdp = 2,  --经济
	def = 3,  --防御
}

local instance = nil

--构造
--返回值(无)
function TechData:ctor()
	self:init()
end

--获取单例
--返回值(单例)
function TechData:getInstance()
	if instance == nil then
		instance = TechData.new()
	end
	return instance
end

--初始化
function TechData:init()
end

-- 根据类型创建对应的科技树
-- arr 对应的数组
-- type 类型，1为军事，2为经济，3为防御
function TechData:createListByType(arr, type)
	local list = TechListConfig:getInstance():getTechList()
	for k,v in pairs(list) do
		if type == v.tl_type then
			local info = self:ctrateInfo(v)
			self:addItem(arr, info)
		end
	end
end

-- 创建数据
-- data 配置的info
function TechData:ctrateInfo(data)
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
function TechData:createBeforeList(info)
	if info.level == 0 then
		-- 当前增益
		info.gain = "0%"
	else
		-- 当前的升级信息
		local curLevelInfo = TechUpgradeConfig:getInstance():getTemplateByIDAndLevel(info.id, info.level)
		-- 当前增益
		info.gain = TechUpgradeConfig:getInstance():getTechAttribute(curLevelInfo)
	end
	-- 判断是否满级
	if info.level == info.maxlv then
		return
	end
	-- 下一级的升级信息
	local nextLevelInfo = TechUpgradeConfig:getInstance():getTemplateByIDAndLevel(info.id, info.level + 1)
	-- 下一级增益
	info.nextLevelGain = TechUpgradeConfig:getInstance():getTechAttribute(nextLevelInfo)
	-- 下一级升级时间（秒）
	info.nextLevelTime = nextLevelInfo.tu_time
	-- 需要学院等级
	local beforeInfo = self:createBeforeInfo(nextLevelInfo.tu_collegelv, 0, 0, 0, 0, 0)
	self:addItem(info.beforeArr, beforeInfo)
	local techInfo = TechListConfig:getInstance():getTemplateByID(info.id)
	-- 条件1
	if techInfo.tl_beforetech1pos ~= -1 then
		self:createBefore(info.beforeArr, techInfo.tl_beforetech1pos, techInfo.tl_beforetech1lv,info.type)
	end
	-- 条件2
	if techInfo.tl_beforetech2pos ~= -1 then
		self:createBefore(info.beforeArr, techInfo.tl_beforetech2pos, techInfo.tl_beforetech2lv,info.type)
	end
	-- 条件3
	if techInfo.tl_beforetech3pos ~= -1 then
		self:createBefore(info.beforeArr, techInfo.tl_beforetech3pos, techInfo.tl_beforetech3lv,info.type)
	end
	-- 资源条件
	-- 粮食
	self:addItem(info.beforeArr, self:createBeforeInfo(0, 0, 0, 0, RESOURCES.food, nextLevelInfo.tu_grain))
	-- 木头
	self:addItem(info.beforeArr, self:createBeforeInfo(0, 0, 0, 0, RESOURCES.wood, nextLevelInfo.tu_wood))
	-- 铁矿
	self:addItem(info.beforeArr, self:createBeforeInfo(0, 0, 0, 0, RESOURCES.iron, nextLevelInfo.tu_iron))
	-- 秘银
	self:addItem(info.beforeArr, self:createBeforeInfo(0, 0, 0, 0, RESOURCES.mithril, nextLevelInfo.tu_mithril))
end

function TechData:createBefore(arr, pos, level, type)
	if id ~= -1 then
		-- 前置条件
		local techInfo = TechListConfig:getInstance():getTemplateByTypeAndPos(type, pos)
		--
		local beforeInfo = self:createBeforeInfo(0, techInfo.tl_id, techInfo.tl_name, level, 0, 0)
		self:addItem(arr, beforeInfo)
	end
end

function TechData:createBeforeInfo(techLevel, id, name, level, kind, value)
	local info = {}
	-- 需要学院等级
	info.techLevel = techLevel
	-- 前置条件id
	info.id = id
	-- 名字
	info.name = name
	-- 科技等级
	info.level = level
	-- 资源类型
	info.kind = kind
	-- 值
	info.value = value
	
	return info
end

-- 根据id获取科技配置
-- arr 对应的数组
-- id 
function TechData:getInfoByID(arr, id)
	for k,v in pairs(arr) do
		if id == v.id then
			return v
		end
	end
	print("错误 根据id获取科技配置：",id)
end

-- 根据pos获取科技配置
-- arr 对应的数组
-- id 
function TechData:getInfoByPos(arr, pos)
	for k,v in pairs(arr) do
		if pos == v.pos then
			return v
		end
	end
	print("错误 根据pos获取科技配置：",id)
end

-- 设置数据
-- arr 服务器下发的数组
-- totalArr 列表
function TechData:setTechInfo(arr,totalArr)
	for k,v in pairs(arr) do
		for i,info in pairs(totalArr) do
			if v.type_id == info.id then
				info.level = v.level
				-- 创建前置条件
				self:createBeforeList(info)
				-- 判断是否有定时器
				if v.timeout_id ~= nil then
					if v.timeout_id.id_h ~= 0 and v.timeout_id.id_l ~= 0 then
						-- 设置升级中的科技数据
						TechnologyModel:getInstance():setTechUpgradeData(v.timeout_id.id_h, v.timeout_id.id_l, v.type_id)
					end
				end
			end
		end
	end
end

-- 添加数据
-- list 数组
-- info 数据
function TechData:addItem(list,info)
	table.insert(list,info)
end
