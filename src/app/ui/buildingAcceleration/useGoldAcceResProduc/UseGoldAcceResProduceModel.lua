

--[[
    hejun
    使用金币资源产量加速数据
--]]

UseGoldAcceResProduceModel = class("UseGoldAcceResProduceModel")

local instance = nil
local _markId = 0

--创建一个标记id
--返回值(id)
function UseGoldAcceResProduceModel:createMarkId()
    _markId = _markId + 1
    if _markId > 9999 then
        _markId = 0
    end
    return _markId
end

--构造
--返回值(无)
function UseGoldAcceResProduceModel:ctor(data)
    self:init(data)
end

--初始化
--返回值(无)
function UseGoldAcceResProduceModel:init(data)
    self.resInfo = {}                     --产量加速资源信息
    self.procduResSpeedLocalData = {}     --产量加速本地数据
end

--获取单例
--返回值(单例)
function UseGoldAcceResProduceModel:getInstance()
    if instance == nil then
        instance = UseGoldAcceResProduceModel.new()
    end
    return instance
end

--保存产量加速本地配置
--data 数据
--返回值(无)
function UseGoldAcceResProduceModel:saveProcduResSpeedLocalData(data)
    data.markId = self:createMarkId()
    table.insert(self.procduResSpeedLocalData,data)
end

--获取产量加速本地数据
--markId id
--返回值(本地数据)
function UseGoldAcceResProduceModel:getProcduResSpeedLocalData(markId)
    for k,v in pairs(self.procduResSpeedLocalData) do
        if v.markId == markId then
            return v
        end
    end
end

--删除产量加速本地数据
--markId id
--返回值(无)
function UseGoldAcceResProduceModel:delProcduResSpeedLocalData(markId)
    for k,v in pairs(self.procduResSpeedLocalData) do
        if v.markId == markId then
            self.procduResSpeedLocalData[k] = nil
            break
        end
    end
end

--添加建筑产量加速信息
--data 数据
--返回值(无)
function UseGoldAcceResProduceModel:addBuildingResInfo(data)
    local info = {}
    info.buildingPos = data.pos
    info.id_h = data.speedTimeoutId.id_h
    info.id_l = data.speedTimeoutId.id_l
    if data.collectFlag ~= 0 then
        info.state = ResourceState.harvest
    else
        info.state = ResourceState.noHarvest
    end
    table.insert(self.resInfo,info)
end

--添加产量加速信息
--data 数据
--返回值(无)
function UseGoldAcceResProduceModel:addResInfo(data)
    for k,v in pairs(data) do
        self:addBuildingResInfo(v)
    end

    for k,v in pairs(self.resInfo) do
        CityBuildingModel:getInstance():setBuildingState(v.buildingPos,v.state)
        TimeInfoData:getInstance():setBuildingPos(v.id_h,v.id_l,v.buildingPos)
    end
end

--资源产量加速结果
--data 数据
--返回值(无)
function UseGoldAcceResProduceModel:resProcduSpeedRes(data)
    TimeInfoData:getInstance():addTimeInfo(data)
    UIMgr:getInstance():closeUI(UITYPE.BUILDING_ACCELERATION)
    UIMgr:getInstance():closeUI(UITYPE.BUILDING_MENU)

    local info = self:getProcduResSpeedLocalData(data.markId)
    if info ~= nil then
        TimeInfoData:getInstance():setBuildingPos(data.id_h,data.id_l,info.buildingPos)
        PlayerData:getInstance():setPlayerMithrilGold(info.castGold)
        self:delProcduResSpeedLocalData(info.markId)
    end

    UICommon:getInstance():updatePlayerDataUI()
    --刷新地图上的建筑
    local cityBuildingListCtrl = MapMgr:getInstance():getCityBuildingListCtrl()
    if cityBuildingListCtrl ~= nil and info ~= nil then
        cityBuildingListCtrl:createProducSpeedLab(info.buildingPos)
    end
end

--完成资源产量加速结果
--data 数据
--返回值(无)
function UseGoldAcceResProduceModel:finishResProcduSpeedRes(data)
    local buildingPos = data.pos
    TimeInfoData:getInstance():delTimeInfoByBuildingPos(buildingPos)

    --刷新地图上的建筑
    local cityBuildingListCtrl = MapMgr:getInstance():getCityBuildingListCtrl()
    if cityBuildingListCtrl ~= nil then
        cityBuildingListCtrl:finishProducSpeed(buildingPos)
    end
end

--获取产量加速定时器信息
--buildingPos 建筑位置
--返回值(定时器信息)
function UseGoldAcceResProduceModel:getProcduResSpeedTimeInfo(buildingPos)
    local timeInfo = TimeInfoData:getInstance():getTimeInfoByBuildingPos(buildingPos)
    if timeInfo ~= nil and timeInfo.action == TimeAction.produc_res_speed then
        return timeInfo
    end
end

--清除缓存数据
--返回值(无)
function UseGoldAcceResProduceModel:clearCache()
    self:init()
end

