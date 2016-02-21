
--[[
	jinyan.zhang
	建筑类型表
--]]

BuildingTypeConfig = class("BuildingTypeConfig")
local instance = nil

local BuildingType = require(CONFIG_SRC_PRE_PATH .. "BuildingType")

--构造
--返回值(无)
function BuildingTypeConfig:ctor()
	self:init()
end

--初始化
--返回值(无)
function BuildingTypeConfig:init()

end

--获取单例
--返回值(单例)
function BuildingTypeConfig:getInstance()
	if instance == nil then
		instance = BuildingTypeConfig.new()
	end
	return instance
end

--获取建筑配置信息
--buildingType 建筑类型
--返回值(配置信息)
function BuildingTypeConfig:getConfigInfo(buildingType)
	for k,v in pairs(BuildingType) do
		if v.bt_id == buildingType then
			return v
		end
	end
	print("获取建筑配置信息：找不到建筑类型："..buildingType)
end

--获取建筑名称
--buildingType 建筑类型
function BuildingTypeConfig:getBuildingNameByType(buildingType)
	local info = self:getConfigInfo(buildingType)
	if info ~= nil then
		return info.bt_name
	end
	print("找不到建筑名称")
end

--获取建筑描述
--buildingType 建筑类型
function BuildingTypeConfig:getBuildingDesByType(buildingType)
	local info = self:getConfigInfo(buildingType)
	if info ~= nil then
		return info.bt_detaileddescription
	end
	print("找不到建筑描述")
end

--获取防御塔列表
--返回值(防御塔列表)
function BuildingTypeConfig:getDefTowerList()
	local defTowerList = {
	 	[1] = {buildType=BuildType.arrowTower},   --箭塔
	    [2] = {buildType=BuildType.turret},      --炮塔
	    [3] = {buildType=BuildType.magicTower}   --魔法塔
	}
	return defTowerList
end

--获取城墙内空地列表
--返回值(建筑列表)
function BuildingTypeConfig:getInWallEmptyList()
	local buildinglist = {
	    [1] = {buildType=BuildType.infantryBattalion}, --步兵营
	    [2] = {buildType=BuildType.cavalryBattalion}, --骑兵营
	    [3] = {buildType=BuildType.archerCamp}, --弓兵营
	    [4] = {buildType=BuildType.chariotBarracks}, --战车兵营
	    [5] = {buildType=BuildType.masterBarracks}, --法师兵营
	    [6] = {buildType=BuildType.warFortress}, --战争要塞
	    [7] = {buildType=BuildType.castle},			--城堡
	    [8] = {buildType=BuildType.wathchTower}, 		--瞭望塔
	    [9] = {buildType=BuildType.wall}, 			--城墙
	    [10] = {buildType=BuildType.PUB}, 		--酒馆
	    [11] = {buildType=BuildType.fortress},   --堡垒
	    [12] = {buildType=BuildType.trainingCamp},   --训练场
	    [13] = {buildType=BuildType.COLLEGE},   --学院
	 }
	return buildinglist

	--[[
	local buildinglist = {}
	for k,v in pairs(BuildingType) do
		if v.bt_position == 1 then
			local info = {}
			info.buildType = v.bt_id
			table.insert(buildinglist,info)
		end
	end
	return buildinglist
	--]]
end

--获取城墙外空地列表
--返回值(建筑列表)
function BuildingTypeConfig:getOutWallEmptyList()
	local buildinglist = {}
	for k,v in pairs(BuildingType) do
		if v.bt_id == BuildType.farmland or BuildType.loggingField == v.bt_id or
		 BuildType.ironOre == v.bt_id or BuildType.illithium == v.bt_id or
		 BuildType.marchTent == v.bt_id or BuildType.firstAidTent == v.bt_id  then
			local info = {}
			info.buildType = v.bt_id
			info.count = v.bt_num
			table.insert(buildinglist,info)
	     end
	 end

	return buildinglist
end

--获取剩余可建造数量
--返回值(建筑列表)
function BuildingTypeConfig:getLeftBuidingCount(buildingType)
	local info = self:getConfigInfo(buildingType)
    return info.bt_num - CityBuildingModel:getInstance():getHaveCreatBuildingCountByType(buildingType)
end




