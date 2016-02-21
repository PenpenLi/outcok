
--[[
    jinyan.zhang
    伤兵数据
--]]

TreatmentModel = class("TreatmentModel")
local instance = nil

local armsAttribute = require(CONFIG_SRC_PRE_PATH .. "ArmsAttribute") --军队士兵属性表（配置表）

local _markId = 0

--创建一个标记id
--返回值(id)
function TreatmentModel:createMarkId()
    _markId = _markId + 1
    if _markId > 9999 then
        _markId = 1
    end
    return _markId
end

--保存本地数据
--data 数据
--返回值(无)
function TreatmentModel:saveLocalData(data)
    data.markId = self:createMarkId()
    table.insert(self.localData,data)
end

--获取本地数据
--markId 标记id
--返回值(本地数据)
function TreatmentModel:getLocalData(markId)
    for k,v in pairs(self.localData) do
        if v.markId == markId then
            return v
        end
    end
end

--删除本地数据
--markId 标记id
--返回值(无)
function TreatmentModel:delLocalData(markId)
    for k,v in pairs(self.localData) do
        if v.markId == markId then
            self.localData[k] = nil
            break
        end
    end
end

--构造
--返回值(无)
function TreatmentModel:ctor()
    self:init()
end

--初始化
--返回值(无)
function TreatmentModel:init()
    self.selectArms = {}  --选中的伤兵
    self.localData = {} --本地数据
end

--获取单例
--返回值(单例)
function TreatmentModel:getInstance()
    if instance == nil then
        instance = TreatmentModel.new()
    end
    return instance
end

--获取选中的伤兵数据
function TreatmentModel:createInfo(content)
    local info = {}
    -- 类型ID （配置表ID）
    info.type = content.type
    -- 兵等级
    info.level = content.level
    -- 兵数量
    info.number = content.number
    -- 消耗粮食
    info.consumption = content.consumption
    -- 增加多少战力
    info.fightforce = content.fightforce
    -- 添加到self.selectArms
    table.insert(self.selectArms,info)
    return info
end

-- 根据士兵类型和等级添加数量
-- info 军队
function TreatmentModel:addInfo(info)
    table.insert(self.selectArms,info)
end


function TreatmentModel:changeSelectArms(info,number)
    for k,v in pairs(self.selectArms) do
        if info.type == v.type and info.level == v.level then
            if number == 0 then
                self.selectArms[k] = nil
            else
                v.number = number
            end
            return
        end
    end
    if number == 0 then
        return
    end
    local copy = clone(info)
    copy.number = number
    table.insert(self.selectArms,copy)
end

--获取军队列表
function TreatmentModel:getList()
    return self.selectArms
end

function TreatmentModel:getCosd(arms)
    local info = {}
    info.grain = 0
    info.wood = 0
    info.iron = 0
    info.mithril = 0
    info.time = 0

    for k,v in pairs(arms) do
        for k1,v1 in pairs(armsAttribute) do
            if v1.aa_typeid == v.type and v1.aa_level == v.level then
                info.grain = (v1.aa_aidgrain * v.number) + info.grain
                info.wood = (v1.aa_aidwood * v.number) + info.wood
                info.iron = (v1.aa_aidiron * v.number) + info.iron
                info.mithril = (v1.aa_aidmithril * v.number) + info.mithril
                info.time = (v1.aa_aidtime * v.number) + info.time
            end
        end
    end
    return info
end

--剩余时间
--返回值(剩余时间)
function TreatmentModel:getleftTime()
    local leftTime = 0
    for k,v in pairs(self.selectArms) do
        local info = ArmsAttributeConfig:getInstance():getArmyTemplate(v.type,v.level)
        leftTime = info.aa_aidtime + leftTime
    end
    return leftTime
end

--获取消耗的金币
--time 时间
--返回值(金币)
function TreatmentModel:getCastGoldByTime(time)
   return CommonConfig:getInstance():getAccelerationTreatmentCastGold(time)
end

--消耗资源
--arms 军队
--返回值(无)
function TreatmentModel:castResource(arms)
    local castInfo = self:getCosd(arms)
    PlayerData:getInstance():setPlayerWood(castInfo.wood)
    PlayerData:getInstance():setPlayerFood(castInfo.grain)
    PlayerData:getInstance():setPlayerIron(castInfo.iron)
    PlayerData:getInstance():setPlayerMithril(castInfo.mithril)
end

--伤兵治疗中
--data 数据
--返回值(无)
function TreatmentModel:woundedSoldierRes(data)
    TimeInfoData:getInstance():detTimeInfoById(data.id_h,data.id_l)
    TimeInfoData:getInstance():addTimeInfo(data)
    local info = self:getLocalData(data.markId)
    TimeInfoData:getInstance():setBuildingType(data.id_h,data.id_l,info.buildingType)
    TimeInfoData:getInstance():setArmsByBuildingType(info.arms,info.buildingType)
    HurtArmsData:getInstance():delArmsNoChangeForce(info.arms)
    self:castResource(info.arms)
    self:delLocalData(data.markId)
    --刷新地图上的建筑
    local cityBuildingListCtrl = MapMgr:getInstance():getCityBuildingListCtrl()
    if cityBuildingListCtrl ~= nil then
        cityBuildingListCtrl:updateTreatmentTime()
    end
    UICommon:getInstance():updatePlayerDataUI()
end

--完成治疗
--data 数据
--返回值(无)
function TreatmentModel:syncCompleteTreatmentData(data)
    local arms = data.arms
    local fightforce = data.fightforce
    TimeInfoData:getInstance():delTimeInfoByType(BuildType.firstAidTent)

    if fightforce ~= 0 then
        PlayerData:getInstance():increaseBattleForce(fightforce)
    end
    --删除完成治疗的伤兵
    HurtArmsData:getInstance():delArmsNoChangeForce(arms)
    --添加完成治疗的士兵
    ArmsData:getInstance():addArmsNoChangeForce(arms)

    --刷新地图上的建筑
    local cityBuildingListCtrl = MapMgr:getInstance():getCityBuildingListCtrl()
    if cityBuildingListCtrl ~= nil then
        cityBuildingListCtrl:finishTreatmentTime()
    end
    UICommon:getInstance():updatePlayerDataUI()
end

--更新数据
function TreatmentModel:setData()
    TimeInfoData:getInstance():setTimeInfoByActron(BuildingState.TREATMENT,BuildType.firstAidTent)
end

--取消治疗
--data 数据
--返回值(无)
function TreatmentModel:cancelTreatmentResult(data)
    local arms = data.arms
    HurtArmsData:getInstance():addArmsData(arms)
    TimeInfoData:getInstance():delTimeInfoByType(BuildType.firstAidTent)

     --刷新地图上的建筑
    local cityBuildingListCtrl = MapMgr:getInstance():getCityBuildingListCtrl()
    if cityBuildingListCtrl ~= nil then
        cityBuildingListCtrl:finishTreatmentTime()
    end
    UIMgr:getInstance():closeUI(UITYPE.BUILDING_MENU)
end

--清理缓存数据
--返回值(无)
function TreatmentModel:clearCache()
    self:init()
end



