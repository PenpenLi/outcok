
--[[
    =hejun
    训练场描述描述配置
--]]

TrainEffectConfig = class("TrainEffectConfig")
local instance = nil

local trainEffectTab = require(CONFIG_SRC_PRE_PATH .. "TrainEffect") --训练场描述表

--构造
--返回值(无)
function TrainEffectConfig:ctor()
    self:init()
end

--初始化
--返回值(无)
function TrainEffectConfig:init()

end

--获取单例
--返回值(单例)
function TrainEffectConfig:getInstance()
    if instance == nil then
        instance = TrainEffectConfig.new()
    end
    return instance
end

--获取训练场详情信息
--返回值(训练场详情信息列表)
function TrainEffectConfig:getDetailsInfo()
    return trainEffectTab
end

--获取训练场信息
--buildingLv 建筑等级
--返回值(建筑效果)
function TrainEffectConfig:getConfigInfo(buildingLv)
    for k,v in pairs(trainEffectTab) do
        if v.te_level == buildingLv then
            return v
        end
    end
    print("无配置")
end

--根据建筑等级获取英雄训练个数
--buildingLv 建筑等级
--返回值(建筑效果)
function TrainEffectConfig:getTrainNumByLevel(buildingLv)
    for k,v in pairs(trainEffectTab) do
        if v.te_level == buildingLv then
            return v.te_trainnum
        end
    end
    print("无配置")
end

--获取训练场信息
--buildingLv 建筑等级
--返回值(训练场效果)
function TrainEffectConfig:getTrainConfigInfo(buildingType)
    local list = {}
    for i=1,#trainEffectTab do
        local v = trainEffectTab[i]
        local info = {}
        local buildingInfo = BuildingUpLvConfig:getInstance():getConfigInfo(buildingType,v.te_level)
        info.te_level = v.te_level
        info.te_trainnum = v.te_trainnum
        info.te_exp = v.te_exp
        info.te_grain = v.te_grain
        info.te_wood = v.te_wood
        info.te_iron = v.te_iron
        info.te_mithril = v.te_mithril
        if buildingInfo ~= nil then
            info.bu_fightforce = buildingInfo.bu_fightforce
        else
            info.bu_fightforce = 0
        end
        table.insert(list,info)
    end
    return list
end



