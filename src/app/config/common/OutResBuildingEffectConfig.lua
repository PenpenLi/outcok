
--[[
	jinyan.zhang
	城外资源建筑效果表
--]]

OutResBuildingEffectConfig = class("OutResBuildingEffectConfig")
local instance = nil

local WildresourcebuildingEffectTab = require(CONFIG_SRC_PRE_PATH .. "WildresourcebuildingEffect")

--构造
--返回值(无)
function OutResBuildingEffectConfig:ctor()
	self:init()
end

--初始化
--返回值(无)
function OutResBuildingEffectConfig:init()
	
end

--获取单例
--返回值(单例)
function OutResBuildingEffectConfig:getInstance()
	if instance == nil then
		instance = OutResBuildingEffectConfig.new()
	end
	return instance
end

function OutResBuildingEffectConfig:getConfig(type,level)
	for k,v in pairs(WildresourcebuildingEffectTab) do
		if v.wre_type == type and v.wre_level == level then
			return v
		end
	end
end

function OutResBuildingEffectConfig:getConfigList(type,buidlingType)
	local arry = {}
	for k,v in pairs(WildresourcebuildingEffectTab) do
		if v.wre_type == type then
			local level = v.wre_level
			local builingUpInfo = BuildingUpLvConfig:getInstance():getConfigInfo(buidlingType,level)
			local force = builingUpInfo.bu_fightforce
			table.insert(arry,{level,force})
		end
	end
    table.sort(arry,function(a,b) return a[1] < b[1] end)
    return arry
end






