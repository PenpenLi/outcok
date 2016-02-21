
--[[
	jinyan.zhang
	城堡效果表
--]]

local CastleEffectTab = require(CONFIG_SRC_PRE_PATH .. "CastleEffect")

CastleEffectConfig = class("CastleEffectConfig")

local instance = nil

-- 获取单例
-- 返回值(单例)
function CastleEffectConfig:getInstance()
    if instance == nil then
        instance = CastleEffectConfig.new()
    end
    return instance
end

-- 构造
function CastleEffectConfig:ctor()
    self:init()
end

-- 初始化
function CastleEffectConfig:init()

end

--获取城外城墙数量
function CastleEffectConfig:getWallCount(level)
    local config = self:getConfigByLevel(level)
    if config ~= nil then
        return config.ce_wildwallnum
    end
    print("找不到城堡配置")
end

--获取城堡可视范围
function CastleEffectConfig:getRangeByLevel(level)
    local info = self:getConfigByLevel(level)
    if info ~= nil then
        return info.ce_over
    end
end

function CastleEffectConfig:getConfigByLevel(level)
    for k,v in pairs(CastleEffectTab) do
        if v.ce_level == level then
            return v
        end
    end
end

function CastleEffectConfig:getConfigByArea(areaIndex)
    for k,v in pairs(CastleEffectTab) do
        if v.ce_unlock == areaIndex then
            return v
        end
    end
end
