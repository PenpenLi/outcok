

--[[
    hejun
    行军账篷数据
--]]

BuildingMarchDetailsModel = class("BuildingMarchDetailsModel")

local instance = nil

--构造
--返回值(无)
function BuildingMarchDetailsModel:ctor()
    self:init()
end

--初始化
--返回值(无)
function BuildingMarchDetailsModel:init(data)

end

--获取单例
--返回值(单例)
function BuildingMarchDetailsModel:getInstance()
    if instance == nil then
        instance = BuildingMarchDetailsModel.new()
    end
    return instance
end

--获取总训练量
--buildingType 建筑类型
--返回值()
function BuildingMarchDetailsModel:getAllSoldier(buildingType)
    local num = 0
    local arr = CityBuildingModel:getInstance():getBuildListByType(buildingType)
    for k,v in pairs(arr) do
        num = CampEffectConfig:getInstance():getConfigInfo(v.level).ce_soldier + num
    end
    return num
end

--获取最大造兵数
function BuildingMarchDetailsModel:getMaxMakeSoldierCount()
    return self:getAllSoldier(BuildType.marchTent) + CommonConfig:getInstance():getMakeSoldierInitNum()
end

--获取所有行军账篷提供的训练速度之和
--buildingType 建筑类型
function BuildingMarchDetailsModel:getAllMarchTentProduceTrainTimeTotal()
    local totalTime = 0
    local arr = CityBuildingModel:getInstance():getBuildListByType(BuildType.marchTent)
    for k,v in pairs(arr) do
        totalTime = CampEffectConfig:getInstance():getConfigInfo(v.level).ce_speed + totalTime
    end
    return totalTime
end

--清理缓存数据
--返回值(无)
function BuildingMarchDetailsModel:clearCache()
    self:init()
end

