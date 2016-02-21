--
-- Author: oyhc
-- Date: 2015-12-18 18:30:28
--
-- 酒馆效果表
local pubEffect = require(CONFIG_SRC_PRE_PATH .. "PubEffect")

PubEffectConfig = class("PubEffectConfig")

local instance = nil

-- 获取单例
-- 返回值(单例)
function PubEffectConfig:getInstance()
	if instance == nil then
		instance = PubEffectConfig.new()
	end
	return instance
end

-- 构造
function PubEffectConfig:ctor()
	-- self:init()
end

-- 初始化
function PubEffectConfig:init()

end

-- 根据level酒馆效果表
-- level
function PubEffectConfig:getPubEffectByLv(level)
	for k,v in pairs(pubEffect) do
		if level == v.pe_level then
			return v
		end
	end
	print("找不到酒馆效果表")
end

-- 根据level获取招贤馆刷新减的时间
-- level
function PubEffectConfig:getResCost(level)
	local info = self:getPubEffectByLv(level)
	if info ~= nil then
		return info.pe_resource_reducetime
	end
	print("找不到等级为" .. level .. "酒馆效果表")
end

-- 根据level获取聚贤馆刷新减的时间
-- level
function PubEffectConfig:getGoldCost(level)
	local info = self:getPubEffectByLv(level)
	if info ~= nil then
		return info.pe_gold_reducetime
	end
	print("找不到等级为" .. level .. "酒馆效果表")
end

--获取酒吧信息
--buildingLv 建筑等级
--返回值(训练场效果)
function PubEffectConfig:getTrainConfigInfo(buildingType)
    local list = {}
    for i=1,#pubEffect do
        local v = pubEffect[i]
        local info = {}
        local buildingInfo = BuildingUpLvConfig:getInstance():getConfigInfo(buildingType,v.pe_level)
        info.pe_level = v.pe_level
        info.pe_resource_reducetime = v.pe_resource_reducetime
        info.pe_gold_reducetime = v.pe_gold_reducetime
        if buildingInfo ~= nil then
            info.bu_fightforce = buildingInfo.bu_fightforce
        else
            info.bu_fightforce = 0
        end
        table.insert(list,info)
    end
    return list
end
