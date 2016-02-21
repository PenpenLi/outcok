
--[[
    jinyan.zhang
    资源描述配置
--]]

ResourcebuildingEffectConfig = class("ResourcebuildingEffectConfig")
local instance = nil

local ResourcebuildingEffectTab = require(CONFIG_SRC_PRE_PATH .. "ResourcebuildingEffect") --资源描述表

--构造
--返回值(无)
function ResourcebuildingEffectConfig:ctor()
    self:init()
end

--初始化
--返回值(无)
function ResourcebuildingEffectConfig:init()

end

--获取单例
--返回值(单例)
function ResourcebuildingEffectConfig:getInstance()
    if instance == nil then
        instance = ResourcebuildingEffectConfig.new()
    end
    return instance
end

--获取资源信息
--buildingType 建筑类型
--buildingLv 建筑等级
--返回值(建筑效果)
function ResourcebuildingEffectConfig:getConfigInfo(buildingType,buildingLv)
    for k,v in pairs(ResourcebuildingEffectTab) do
        if v.re_type == buildingType and v.re_level == buildingLv then
            return v
        end
    end
end

--获取配置信息
--buildingType 建筑类型
--返回值(配置信息)
function ResourcebuildingEffectConfig:getAllConfigInfo(buildingType)
    for k,v in pairs(ResourcebuildingEffectTab) do
        if v.re_type == buildingType then
            return v
        end
    end
end

--获取详情信息
--buildingType 建筑类型
--返回值(详情信息列表)
function ResourcebuildingEffectConfig:getDetailsInfo(buildingType)
    local effectInfoList = {}
    local index = 1
    for i=1,#ResourcebuildingEffectTab do
        if ResourcebuildingEffectTab[i].re_type == buildingType then
            effectInfoList[index] = {}
            effectInfoList[index].lv = ResourcebuildingEffectTab[i].re_level
            effectInfoList[index].yields = ResourcebuildingEffectTab[i].re_yields
            effectInfoList[index].capacity = ResourcebuildingEffectTab[i].re_content
            index = index + 1
        end
    end
    return effectInfoList
end