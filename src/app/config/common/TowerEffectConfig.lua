
--[[
    jinyan.zhang
    防御塔效果配置
--]]

TowerEffectConfig = class("TowerEffectConfig")
local instance = nil

local TowerEffectTab = require(CONFIG_SRC_PRE_PATH .. "TowerEffect") --防御塔升级表

--构造
--返回值(无)
function TowerEffectConfig:ctor()
    self:init()
end

--初始化
--返回值(无)
function TowerEffectConfig:init()

end

--获取单例
--返回值(单例)
function TowerEffectConfig:getInstance()
    if instance == nil then
        instance = TowerEffectConfig.new()
    end
    return instance
end

--获取资源信息
--buildingLv 建筑等级
--返回值(建筑效果)
function TowerEffectConfig:getConfigInfo(buildingLv)
    for k,v in pairs(TowerEffectTab) do
        if v.te_level == buildingLv then
            return v
        end
    end
end

--获取详情信息
--buildingType 建筑类型
--返回值(详情信息列表)
function TowerEffectConfig:getDetailsInfo(buildingType)
    local list = {}
    for i=1,#TowerEffectTab do
        local v = TowerEffectTab[i]
        if buildingType == v.te_buildingid then
            local info = {}
            local buildingInfo = BuildingUpLvConfig:getInstance():getConfigInfo(buildingType,v.te_level)
            info.te_level = v.te_level
            info.te_attack = v.te_attack
            if buildingInfo ~= nil then
                info.bu_fightforce = buildingInfo.bu_fightforce
            else
                info.bu_fightforce = 0
            end
            table.insert(list,info)
        end
    end
    return list
end





