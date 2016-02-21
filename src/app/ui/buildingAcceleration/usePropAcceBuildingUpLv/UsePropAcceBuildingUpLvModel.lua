
--[[
    jinyan.zhang
    使用道具加速升级建筑
--]]

UsePropAcceBuildingUpLvModel = class("UsePropAcceBuildingUpLvModel")

local instance = nil

--构造
--返回值(无)
function UsePropAcceBuildingUpLvModel:ctor()
    self:init()
end

--初始化
--返回值(无)
function UsePropAcceBuildingUpLvModel:init()

end

--获取单例
--返回值(单例)
function UsePropAcceBuildingUpLvModel:getInstance()
    if instance == nil then
        instance = UsePropAcceBuildingUpLvModel.new()
    end
    return instance
end

--使用道具加速升级建筑结果
--data 数据
function UsePropAcceBuildingUpLvModel:propAccelerationBuildingUpLvRes(data)
    local items = data.items
    local buildingPos = data.pos
    local config = ItemTemplateConfig:getInstance():getItemTemplateByID(items.templateId)
    local second = config.it_turbotime*60
    local timeInfo = CityBuildingModel:getInstance():minusBuilderTime(buildingPos,second)
    BagModel:getInstance():useItem(items)

    local info = BuildingAccelerationModel:getInstance():getGoldAcclerationLocalDataByPos(buildingPos)
    BuildingAccelerationModel:getInstance():delGoldAccelerationLocalDataByPos(buildingPos)

    --刷新地图上的建筑
    local cityBuildingListCtrl = MapMgr:getInstance():getCityBuildingListCtrl()
    if cityBuildingListCtrl ~= nil then
        cityBuildingListCtrl:createUpBuildingUI(buildingPos,info.buildingType,timeInfo.start_time,timeInfo.interval)
    end

    UIMgr:getInstance():closeUI(info.buildingType)
    UIMgr:getInstance():closeUI(UITYPE.BUILDING_ACCELERATION)
    UIMgr:getInstance():closeUI(UITYPE.CITY_BUILD_UPGRADE)
    UIMgr:getInstance():closeUI(UITYPE.CITY_BUILD_LIST)
    UIMgr:getInstance():closeUI(UITYPE.OUT_WALL_BUILDINGLIST)
    UIMgr:getInstance():closeUI(UITYPE.TOWER_DEFENSE_LIST)
    UIMgr:getInstance():closeUI(UITYPE.CITY_BUILD_UPGRADE)
    UIMgr:getInstance():closeUI(UITYPE.BUILDING_MENU)
end

--获取加速道具数量
function UsePropAcceBuildingUpLvModel:getPropNum()
    local total = 0
    local itemlist = ItemData:getInstance():getQuickItemList()
    for k,v in pairs(itemlist) do
        if v.speedType == ItemSpeedType.build or v.speedType == ItemSpeedType.all then
            total = total + v.number
        end
    end
    return total
end

--清理缓存数据
--返回值(无)
function UsePropAcceBuildingUpLvModel:clearCache()
    self:init()
end



