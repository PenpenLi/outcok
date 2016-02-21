
--[[
    jinyan.zhang
    仓库描述配置
--]]

StorehouseEffectConfig = class("StorehouseEffectConfig")
local instance = nil

local StorehouseEffectTab = require(CONFIG_SRC_PRE_PATH .. "StorehouseEffect") --仓库描述表

--构造
--返回值(无)
function StorehouseEffectConfig:ctor()
    self:init()
end

--初始化
--返回值(无)
function StorehouseEffectConfig:init()

end

--获取单例
--返回值(单例)
function StorehouseEffectConfig:getInstance()
    if instance == nil then
        instance = StorehouseEffectConfig.new()
    end
    return instance
end

--获取资源信息
--buildingType 建筑类型
--buildingLv 建筑等级
--返回值(建筑效果)
function StorehouseEffectConfig:getConfigInfo(buildingLv)
    for k,v in pairs(StorehouseEffectTab) do
        if v.se_level == buildingLv then
            return v
        end
    end
end

--获取配置信息
--buildingType 建筑类型
--返回值(配置信息)
function StorehouseEffectConfig:getAllConfigInfo(buildingType)
    for k,v in pairs(StorehouseEffectTab) do
        if v.re_type == buildingType then
            return v
        end
    end
end

--获取详情信息
--返回值(详情信息列表)
function StorehouseEffectConfig:getDetailsInfo()
    local effectInfoList = {}
    local index = 1
    for i=1,#StorehouseEffectTab do
        effectInfoList[index] = {}
        effectInfoList[index].lv = StorehouseEffectTab[i].se_level
        effectInfoList[index].storegrain = StorehouseEffectTab[i].se_storegrain
        effectInfoList[index].storewood = StorehouseEffectTab[i].se_storewood
        effectInfoList[index].storeiron = StorehouseEffectTab[i].se_storeiron
        effectInfoList[index].storemithril = StorehouseEffectTab[i].se_storemithril
        effectInfoList[index].protectgrain = StorehouseEffectTab[i].se_protectgrain
        effectInfoList[index].protectwood = StorehouseEffectTab[i].se_protectwood
        effectInfoList[index].protectiron = StorehouseEffectTab[i].se_protectiron
        effectInfoList[index].protectmithril = StorehouseEffectTab[i].se_protectmithril
        index = index + 1
    end
    return effectInfoList
end