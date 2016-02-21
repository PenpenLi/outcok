

UseGoldAcceTreatmentModel = class("UseGoldAcceTreatmentModel")

local instance = nil

--构造
--返回值(无)
function UseGoldAcceTreatmentModel:ctor()
    self:init()
end

--初始化
--返回值(无)
function UseGoldAcceTreatmentModel:init()
    self.localData = {}
end

--获取单例
--返回值(单例)
function UseGoldAcceTreatmentModel:getInstance()
    if instance == nil then
        instance = UseGoldAcceTreatmentModel.new()
    end
    return instance
end

--保存本地配置
--data 数据
--返回值(无)
function UseGoldAcceTreatmentModel:saveLocalData(data)
    for k,v in pairs(self.localData) do
        if v.buildingType == data.buildingType then
            return
        end
    end
    table.insert(self.localData,data)
end

--获取本地数据
--buildingType 建筑类型
--返回值(本地数据)
function UseGoldAcceTreatmentModel:getLocalDataByType(buildingType)
    for k,v in pairs(self.localData) do
        if v.buildingType == buildingType then
            return v
        end
    end
end

--删除本地数据
--buildingType 建筑类型
--返回值(无)
function UseGoldAcceTreatmentModel:delLocalDataByType(buildingType)
    for k,v in pairs(self.localData) do
        if v.buildingType == buildingType then
            self.localData[k] = nil
            break
        end
    end
end

--收到金币加速治疗结果
function UseGoldAcceTreatmentModel:recvGoldAcceTrestmentRes()
    local info = self:getLocalDataByType(BuildType.firstAidTent)
    ArmsData:getInstance():addArms(info.arms)
    --删除定时器
    TimeInfoData:getInstance():delTimeInfoByType(BuildType.firstAidTent)
    if info.action == AcceTreatmentAction.commonGold then  --正常加速
        --删除ui定时器
        local cityBuildingListCtrl = MapMgr:getInstance():getCityBuildingListCtrl()
        if cityBuildingListCtrl ~= nil then
            cityBuildingListCtrl:finishTreatmentTime()
        end
    elseif info.action == AcceTreatmentAction.rightNowGold then  --立即加速
        HurtArmsData:getInstance():delArmsNoChangeForce(info.arms)
        TreatmentModel:getInstance():castResource(info.arms)
    end
    UIMgr:getInstance():closeUI(UITYPE.BUILDING_ACCELERATION)
    UIMgr:getInstance():closeUI(UITYPE.TREATMENT)
    UIMgr:getInstance():closeUI(UITYPE.BUILDING_MENU)
    self:delLocalDataByType(BuildType.firstAidTent)
    UICommon:getInstance():updatePlayerDataUI()
end

--清理缓存数据
--返回值(无)
function UseGoldAcceTreatmentModel:clearCache()
    self:init()
end



