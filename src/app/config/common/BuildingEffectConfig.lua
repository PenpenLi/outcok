
--[[
	jinyan.zhang
	建筑效果配置
--]]

BuildingEffectConfig = class("BuildingEffectConfig")
local instance = nil

local BuildingEffect = require(CONFIG_SRC_PRE_PATH .. "BuildingEffect") --建筑升级表

--构造
--返回值(无)
function BuildingEffectConfig:ctor()
	self:init()
end

--初始化
--返回值(无)
function BuildingEffectConfig:init()

end

--获取单例
--返回值(单例)
function BuildingEffectConfig:getInstance()
	if instance == nil then
		instance = BuildingEffectConfig.new()
	end
	return instance
end

--获取建筑效果
--buildingType 建筑类型
--buildingLv 建筑等级
--返回值(建筑效果)
function BuildingEffectConfig:getBukldingEffect(buildingType,buildingLv)
	for k,v in pairs(BuildingEffect) do
		if v.ce_buildingid == buildingType and v.ce_level == buildingLv then
			return v.ce_effect
		end
	end
end

--获取建筑效果
--buildingType 建筑类型
--buildingLv 建筑等级
--返回值(建筑效果)
function BuildingEffectConfig:getBuildingEffectByType(buildingType,buildingLv)
	while true do
		local effect = self:getBukldingEffect(buildingType,buildingLv)
		if effect ~= nil then
			return effect
		end
		buildingLv = buildingLv - 1
		effect = self:getBukldingEffect(buildingType,buildingLv)
		if buildingLv <= 0 then
			return effect
		end
	end
end

--获取详情信息
--buildingType 建筑类型
--返回值(详情信息列表)
function BuildingEffectConfig:getDetailsInfo(buildingType)
	local list = {}
	for i=1,#BuildingEffect do
		local v = BuildingEffect[i]
		if buildingType == v.ce_buildingid then
			local info = {}
			local buildingInfo = BuildingUpLvConfig:getInstance():getConfigInfo(buildingType,v.ce_level)
			info.ce_level = v.ce_level
			info.ce_effect = v.ce_effect
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





