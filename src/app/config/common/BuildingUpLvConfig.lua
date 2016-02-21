
--[[
	jinyan.zhang
	建筑升级配置
--]]

BuildingUpLvConfig = class("BuildingUpLvConfig")
local instance = nil

local BuildingUpgrade = require(CONFIG_SRC_PRE_PATH .. "BuildingUpgrade") --建筑升级表

--构造
--返回值(无)
function BuildingUpLvConfig:ctor()
	self:init()
end

--初始化
--返回值(无)
function BuildingUpLvConfig:init()

end

--获取单例
--返回值(单例)
function BuildingUpLvConfig:getInstance()
	if instance == nil then
		instance = BuildingUpLvConfig.new()
	end
	return instance
end

--获取详情信息
--buildingType 建筑类型
--返回值(详情信息列表)
function BuildingUpLvConfig:getDetailsInfo(buildingType)
    local list = {}
    for i=1,#BuildingUpgrade do
        local v = BuildingUpgrade[i]
        if buildingType == v.bu_id then
            local info = {}
            info.bu_level = v.bu_level
            info.bu_fightforce = v.bu_fightforce
            table.insert(list,info)
        end
    end
    return list
end

--获取配置信息
--buildingType 建筑类型
--buildingLv 建筑等级
--返回值(配置信息)
function BuildingUpLvConfig:getConfigInfo(buildingType,buildingLv)
	for k,v in pairs(BuildingUpgrade) do
		if v.bu_id == buildingType and v.bu_level == buildingLv then
			return v
		end
	end
end

--获取战斗力
--buildingType 建筑类型
--返回值(战斗力)
function BuildingUpLvConfig:getFightforceInfo(buildingType)
	local fightforceList = {}
    local index = 1
    for i=1,#BuildingUpgrade do
        if BuildingUpgrade[i].bu_id == buildingType then
            fightforceList[index] = {}
            fightforceList[index].fightforce = BuildingUpgrade[i].bu_fightforce
            index = index + 1
        end
    end
    return fightforceList
end

--获取建筑资源路径
--buildingType 建筑类型
--buildingLv 建筑等级
--picName 图片名字
--返回值(配置信息)
function BuildingUpLvConfig:getBuildingResPath(buildingType,buildingLv,picName)
	local info = self:getConfigInfo(buildingType,buildingLv)
	if buildingType == BuildType.farmland or BuildType.loggingField == buildingType then
		picName = picName or "_001.png"
		return "#" .. info.bu_picture .. picName
	end
	return  "#" .. info.bu_picture .. ".png"
end

--获取建筑资源路径2
--buildingType 建筑类型
--buildingLv 建筑等级
--返回值(配置信息)
function BuildingUpLvConfig:getBuildingResPath2(buildingType,buildingLv,picName)
	local info = self:getConfigInfo(buildingType,buildingLv)
	if buildingType == BuildType.farmland or BuildType.loggingField == buildingType
	or buildingType == BuildType.ironOre or buildingType == BuildType.illithium then
		picName = picName or "_001.png"
		return info.bu_picture .. picName
	end
	return info.bu_picture .. ".png"
end

