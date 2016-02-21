
--[[
    jinyan.zhang
    进军帐篷描述描述配置
--]]

CampEffectConfig = class("CampEffectConfig")
local instance = nil

local CampEffectTab = require(CONFIG_SRC_PRE_PATH .. "CampEffect") --进军帐篷描述表

--构造
--返回值(无)
function CampEffectConfig:ctor()
    self:init()
end

--初始化
--返回值(无)
function CampEffectConfig:init()

end

--获取单例
--返回值(单例)
function CampEffectConfig:getInstance()
    if instance == nil then
        instance = CampEffectConfig.new()
    end
    return instance
end

--获取进军帐篷详情信息
--返回值(急救帐篷详情信息列表)
function CampEffectConfig:getDetailsInfo()
    return CampEffectTab
end

--获取行军帐篷信息
--buildingLv 建筑等级
--返回值(建筑效果)
function CampEffectConfig:getConfigInfo(buildingLv)
    for k,v in pairs(CampEffectTab) do
        if v.ce_lv == buildingLv then
            return v
        end
    end
end



