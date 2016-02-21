
--[[
    jinyan.zhang
    急救帐篷描述描述配置
--]]

AidEffectConfig = class("AidEffectConfig")
local instance = nil

local AidEffectTab = require(CONFIG_SRC_PRE_PATH .. "AidEffect") --急救帐篷描述表

--构造
--返回值(无)
function AidEffectConfig:ctor()
    self:init()
end

--初始化
--返回值(无)
function AidEffectConfig:init()

end

--获取单例
--返回值(单例)
function AidEffectConfig:getInstance()
    if instance == nil then
        instance = AidEffectConfig.new()
    end
    return instance
end

--获取急救帐篷详情信息
--返回值(急救帐篷详情信息列表)
function AidEffectConfig:getDetailsInfo()
    return AidEffectTab
end

--获取急救帐篷信息
--buildingLv 建筑等级
--返回值(建筑效果)
function AidEffectConfig:getConfigInfo(buildingLv)
    for k,v in pairs(AidEffectTab) do
        if v.ae_level == buildingLv then
            return v
        end
    end
end




