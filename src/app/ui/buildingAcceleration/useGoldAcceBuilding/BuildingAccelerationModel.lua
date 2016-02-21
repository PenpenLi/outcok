

--[[
    hejun
    加速建筑数据
--]]

BuildingAccelerationModel = class("BuildingAccelerationModel")

local instance = nil
local _markId = 0

--创建一个标记id
--返回值(id)
function BuildingAccelerationModel:createMarkId()
    _markId = _markId + 1
    if _markId > 9999 then
        _markId = 0
    end
    return _markId
end

--构造
--返回值(无)
function BuildingAccelerationModel:ctor(data)
    self:init(data)
end

--初始化
--返回值(无)
function BuildingAccelerationModel:init(data)
    self.goldAccelerationLocalData = {}   --金币加速本地数据
end

--获取单例
--返回值(单例)
function BuildingAccelerationModel:getInstance()
    if instance == nil then
        instance = BuildingAccelerationModel.new()
    end
    return instance
end

--保存本地配置
--data 数据
--返回值(无)
function BuildingAccelerationModel:saveGoldAccelerationLocalData(data)
    for k,v in pairs(self.goldAccelerationLocalData) do
        if v.buildingPos == data.buildingPos then
            return
        end
    end
    data.markId = self:createMarkId()
    table.insert(self.goldAccelerationLocalData,data)
end

--获取使用金币加速时保存的本地数据
--buildingPos 建筑位置
--返回值(本地数据)
function BuildingAccelerationModel:getGoldAcclerationLocalDataByPos(buildingPos)
    for k,v in pairs(self.goldAccelerationLocalData) do
        if v.buildingPos == buildingPos then
            return v
        end
    end
end

--删除使用金币加速时保存的本地数据
--buildingPos 建筑位置
--返回值(无)
function BuildingAccelerationModel:delGoldAccelerationLocalDataByPos(buildingPos)
    for k,v in pairs(self.goldAccelerationLocalData) do
        if v.buildingPos == buildingPos then
            self.goldAccelerationLocalData[k] = nil
            break
        end
    end
end

--金币加速结果
--返回值(无)
function BuildingAccelerationModel:goldAccelerationRes(data)
    local buildingPos = data.pos
    local buildingLv = data.level
    local fightforce = data.fightforce
    local action = data.type  --加速类型

    CityBuildingModel:getInstance():delHammerBuildTime(buildingPos)
    local isUpBuilding = false
    local builderInfo =  CityBuildingModel:getInstance():getBuilderInfo(buildingPos)
    if builderInfo then
        isUpBuilding = true
    end

    --删除定时器
    CityBuildingModel:getInstance():delBuilder(buildingPos)
    TimeInfoData:getInstance():delTimeInfoByBuildingPos(buildingPos)

    local goldAccelerationData = self:getGoldAcclerationLocalDataByPos(buildingPos)
    PlayerData:getInstance():setPlayerMithrilGold(goldAccelerationData.castGold)

    print("收到金币加速升级结果 buildingPos=",buildingPos,"buildingType=",goldAccelerationData.buildingType)

    if action == AccelerationAction.RIGHT_NOW_UP then                           --瞬间升级
        if not CityBuildingModel:getInstance():setBuildingLv(buildingPos,buildingLv) then
            local info = {}
            info.type =  goldAccelerationData.buildingType   --建筑类型
            info.level = 1                                   --建筑等级
            info.builderid_h = 0                             --建筑列表ID（锤子）builder ,升级建造使用builder, 如果没有升级或创建两个值为0
            info.builderid_l = 0
            info.pos = buildingPos                           --建筑所在的格子位置, 从0开始
            info.timeoutid_h = 0                             --定时器ID，定时器timeout, 造兵等等使用timeout, 如果没有建筑内部创建两个值为0
            info.timeoutid_l = 0
            CityBuildingModel:getInstance():addBuildingData(info)
        end
        if not isUpBuilding then
            CityBuildingModel:getInstance():buildingUpgtadeCost(buildingPos,goldAccelerationData.buildingType)
        end
    elseif action == AccelerationAction.RIGHT_NOW_BUILDING then                 --瞬间建造
        local info = {}
        info.type =  goldAccelerationData.buildingType   --建筑类型
        info.level = 1                                   --建筑等级
        info.builderid_h = 0                             --建筑列表ID（锤子）builder ,升级建造使用builder, 如果没有升级或创建两个值为0
        info.builderid_l = 0
        info.pos = buildingPos                           --建筑所在的格子位置, 从0开始
        info.timeoutid_h = 0                             --定时器ID，定时器timeout, 造兵等等使用timeout, 如果没有建筑内部创建两个值为0
        info.timeoutid_l = 0
        CityBuildingModel:getInstance():addBuildingData(info)
        if not isUpBuilding then
            CityBuildingModel:getInstance():buildingUpgtadeCost(buildingPos,goldAccelerationData.buildingType)
        end
    elseif action == AccelerationAction.RIGHT_NOW_REMOVE then  --瞬间拆除
        CityBuildingModel:getInstance():delBuildingDataByPos(buildingPos)
    end

    --增加战斗力
    if fightforce ~= 0 then
        PlayerData:getInstance():increaseBattleForce(fightforce)
    end
    UICommon:getInstance():updatePlayerDataUI()

    UIMgr:getInstance():closeUI(goldAccelerationData.buildingType)
    UIMgr:getInstance():closeUI(UITYPE.BUILDING_ACCELERATION)
    UIMgr:getInstance():closeUI(UITYPE.CITY_BUILD_UPGRADE)
    UIMgr:getInstance():closeUI(UITYPE.CITY_BUILD_LIST)
    UIMgr:getInstance():closeUI(UITYPE.OUT_WALL_BUILDINGLIST)
    UIMgr:getInstance():closeUI(UITYPE.TOWER_DEFENSE_LIST)
    UIMgr:getInstance():closeUI(UITYPE.CITY_BUILD_UPGRADE)
    UIMgr:getInstance():closeUI(UITYPE.BUILDING_MENU)

    --刷新地图上的建筑
    local cityBuildingListCtrl = MapMgr:getInstance():getCityBuildingListCtrl()
    if cityBuildingListCtrl ~= nil then
        if action == AccelerationAction.RIGHT_NOW_UP then           --瞬间升级
            cityBuildingListCtrl:finishUpBuilding(buildingPos)
        elseif action == AccelerationAction.RIGHT_NOW_BUILDING then --瞬间建造
            if goldAccelerationData.buildingState == BuildingState.createBuilding then
                cityBuildingListCtrl:finishUpBuilding(buildingPos)
            else
                cityBuildingListCtrl:updateCreateBuildingUI(buildingPos,goldAccelerationData.buildingType,BuidState.UN_FINISH)
            end
        elseif action == AccelerationAction.RIGHT_NOW_REMOVE then  --瞬间拆除
            cityBuildingListCtrl:updateRemoveBuildingUI(buildingPos,0,BuidState.FINISH)
        end
    end
    self:delGoldAccelerationLocalDataByPos(buildingPos)
end

--清除缓存数据
--返回值(无)
function BuildingAccelerationModel:clearCache()
    self:init()
end

