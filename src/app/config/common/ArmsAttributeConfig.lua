--
-- Author: oyhc
-- Date: 2015-12-29 11:45:02
--
local armsAttribute = require(CONFIG_SRC_PRE_PATH .. "ArmsAttribute") --军队士兵属性表（配置表）

ArmsAttributeConfig = class("ArmsAttributeConfig")

local instance = nil

-- 获取单例
-- 返回值(单例)
function ArmsAttributeConfig:getInstance()
	if instance == nil then
		instance = ArmsAttributeConfig.new()
	end
	return instance
end

-- 构造
function ArmsAttributeConfig:ctor()
	-- self:init()
end

-- 初始化
function ArmsAttributeConfig:init()

end

-- 根据等级和类型获取士兵配置模板
-- type 类型
-- level 等级
-- 返回 士兵配置
function ArmsAttributeConfig:getArmyTemplate(type,level)
	for k,v in pairs(armsAttribute) do
		if v.aa_typeid == type and v.aa_level == level then
			return v
		end
	end
	print("找不到士兵模板："..type..level)
end

-- 根据类型获取士兵配置模板
-- subType 类型
-- 返回 士兵配置
function ArmsAttributeConfig:getArmyTemplatebySubType(subType)
	for k,v in pairs(armsAttribute) do
		if v.aa_subtype == subType then
			return v
		end
	end
	print("找不到士兵模板："..subType)
end


-- 根据等级和类型获取士兵每秒消耗
-- type 类型
-- level 等级
-- 返回 士兵配置
function ArmsAttributeConfig:getArmyCost(type,level)
	for k,v in pairs(armsAttribute) do
		if v.aa_typeid == type and v.aa_level == level then
			return v.aa_burning
		end
	end
	print("每秒消耗 找不到士兵模板："..type..level)
end

--能否造兵
--armType 兵种类型
--armLevel 兵种等级
--buildingLv 建筑等级
--返回值(true:可以造兵,false:不可以造兵)
function ArmsAttributeConfig:isCanMakeSoldier(armType,armLevel,buildingLv)
	for k,v in pairs(armsAttribute) do
		if v.aa_typeid == armType and v.aa_level == armLevel then
			if buildingLv  >= v.aa_buildinglevel then
				return true
			end
		end
	end
	return false
end

--获取行军最小速度
--arms 部队
--返回值(最小速度)
function ArmsAttributeConfig:getMarchMinSpeed(arms)
	if 1==1 then
		return 50*3
	end

	if arms == nil then
		local minSpeed= 999999
		for k,v in pairs(armsAttribute) do
			if v.aa_typeid == type and v.aa_level == level then
				if v.aa_speed < minSpeed then
					minSpeed = v.aa_speed
				end
			end
		end
		return minSpeed
	end

	local minSpeed= 999999
	for k,v in pairs(arms) do
		-- 根据等级和类型获取士兵配置模板
		local armyTemplate = self:getArmyTemplate(v.type,v.level)
		local speed = armyTemplate.aa_speed
		if speed < minSpeed then
			minSpeed = speed
		end
	end
	return minSpeed
end

--获取训练列表
--buildingPos 建筑位置
--返回值(训练列表)
function ArmsAttributeConfig:getTrainList(buildingPos)
	local buildingLv = 1
	local buildingInfo = CityBuildingModel:getInstance():getBuildInfo(buildingPos)
	if buildingInfo ~= nil then
		buildingLv = buildingInfo.level
	end

	local trainList = {}
  	local index = 1
	for i=1,#armsAttribute do
		local attrInfo = armsAttribute[i]
		if attrInfo.aa_building == buildingInfo.type then
			trainList[index] = {}
			trainList[index].soldierType = attrInfo.aa_subtype
			trainList[index].name = ArmsData:getInstance():getSoldierName(trainList[index].soldierType,attrInfo.aa_level)
			if buildingLv >= attrInfo.aa_buildinglevel then
				trainList[index].isCanMakeSoldier = true
			else
				trainList[index].isCanMakeSoldier = false
			end
			trainList[index].food = attrInfo.aa_grain
			trainList[index].wood = attrInfo.aa_wood
			trainList[index].iron = attrInfo.aa_iron
			trainList[index].mithril = attrInfo.aa_mithril
			trainList[index].lv = attrInfo.aa_level
			trainList[index].soldierNum = ArmsData:getInstance():getNumberByTypeAndLevel(attrInfo.aa_typeid,attrInfo.aa_level)
			trainList[index].unlockDesStr = attrInfo.aa_buildinglevel .. CommonStr.LEVEL .. BuildingTypeConfig:getInstance():getBuildingNameByType(buildingInfo.type) .. CommonStr.UNLOCK
			trainList[index].makeSoldierTime = attrInfo.aa_time
			trainList[index].smallPicName = "#" .. attrInfo.aa_icon .. ".png"
			trainList[index].bigPicName = attrInfo.aa_picture .. ".png"
			trainList[index].templeteInfo = attrInfo
			index = index + 1
		end
	end
	return trainList
end

