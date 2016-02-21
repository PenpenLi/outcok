

UseGoldMakeSoldierAcceModel = class("UseGoldMakeSoldierAcceModel")

local instance = nil

--构造
--返回值(无)
function UseGoldMakeSoldierAcceModel:ctor()
    self:init()
end

--初始化
--返回值(无)
function UseGoldMakeSoldierAcceModel:init()
	self.localData = {}
end

--获取单例
--返回值(单例)
function UseGoldMakeSoldierAcceModel:getInstance()
    if instance == nil then
        instance = UseGoldMakeSoldierAcceModel.new()
    end
    return instance
end

--保存本地配置
--data 数据
--返回值(无)
function UseGoldMakeSoldierAcceModel:saveLocalData(data)
    for k,v in pairs(self.localData) do
        if v.buildingPos == data.buildingPos then
            return
        end
    end
    table.insert(self.localData,data)
end

--获取本地数据
--buildingPos 建筑位置
--返回值(本地数据)
function UseGoldMakeSoldierAcceModel:getLocalDataByPos(buildingPos)
    for k,v in pairs(self.localData) do
        if v.buildingPos == buildingPos then
            return v
        end
    end
end

--删除本地数据
--buildingPos 建筑位置
--返回值(无)
function UseGoldMakeSoldierAcceModel:delLocalDataByPos(buildingPos)
    for k,v in pairs(self.localData) do
        if v.buildingPos == buildingPos then
            self.localData[k] = nil
            break
        end
    end
end

--加速造兵结果
--data 数据
--返回值(无)
function UseGoldMakeSoldierAcceModel:accelerationMakeSoldierRes(data)
	local buildingPos = data.pos
    data.buildingPos = buildingPos
    local info = self:getLocalDataByPos(buildingPos)
    if info == nil then
    	return
    end
    PlayerData:getInstance():setPlayerMithrilGold(info.castGold)

    local buildingType = CityBuildingModel:getInstance():getBuildType(buildingPos)
    if buildingType == BuildType.fortress then  --堡垒
        UIMgr:getInstance():closeUI(UITYPE.BUILDING_ACCELERATION)
        UIMgr:getInstance():closeUI(UITYPE.FORTRESS)
        UIMgr:getInstance():closeUI(UITYPE.BUILDING_MENU)
        if info.action == AccelerationMakeSoldierAction.rightNowGold then --立即加速 
            FortressModel:getInstance():castResource(info.soldierType,info.level)
            MakeSoldierModel:getInstance():setHaveReadyArms(buildingPos,1,info.soldierType,info.level,info.number,info.name,info.soldierAnmationTempleType)
            local cityBuildingListCtrl = MapMgr:getInstance():getCityBuildingListCtrl()
            if cityBuildingListCtrl ~= nil then
                cityBuildingListCtrl:finishFortressMakeTrap(buildingPos)
            end
        else
            MakeSoldierModel:getInstance():syncMakeSoldiersFinishData(data)
        end
    else
        UIMgr:getInstance():closeUI(UITYPE.BUILDING_ACCELERATION)
        UIMgr:getInstance():closeUI(UITYPE.TRAINING_CITY)
        UIMgr:getInstance():closeUI(UITYPE.BUILDING_MENU)

        if info.action == AccelerationMakeSoldierAction.rightNowGold then  --立即加速
            MakeSoldierModel:getInstance():makeSoldierCost(info.soldierType,info.level,info.number)
            MakeSoldierModel:getInstance():setHaveReadyArms(buildingPos,1,info.soldierType,info.level,info.number,info.name,info.soldierAnmationTempleType)
            local cityBuildingListCtrl = MapMgr:getInstance():getCityBuildingListCtrl()
            if cityBuildingListCtrl ~= nil then
                cityBuildingListCtrl:rightNowFinishTrainRes(buildingPos,info.soldierAnmationTempleType)
            end
        else 
            MakeSoldierModel:getInstance():syncMakeSoldiersFinishData(data)
        end
    end
    self:delLocalDataByPos(buildingPos)
    UICommon:getInstance():updatePlayerDataUI()
end

--清理缓存数据
--返回值(无)
function UseGoldMakeSoldierAcceModel:clearCache()
    self:init()
end



