
--[[
	jinyan.zhang
	城外防御塔配置
--]]

local WildtowerEffectTab = require(CONFIG_SRC_PRE_PATH .. "WildtowerEffect") 

OutTowerEffectConfig = class("OutTowerEffectConfig")

local instance = nil

-- 获取单例
-- 返回值(单例)
function OutTowerEffectConfig:getInstance()
	if instance == nil then
		instance = OutTowerEffectConfig.new()
	end
	return instance
end

-- 构造
function OutTowerEffectConfig:ctor()
	-- self:init()
end

-- 初始化
function OutTowerEffectConfig:init()
	
end

function OutTowerEffectConfig:getConfig(type,level)
	for k,v in pairs(WildtowerEffectTab) do
		if v.wte_type == type and v.wte_level == level then
			return v
		end
	end
end

function OutTowerEffectConfig:getConfigList(type,buidlingType)
	local arry = {}
	for k,v in pairs(WildtowerEffectTab) do
		if v.wte_type == type then
			local level = v.wte_level
			local builingUpInfo = BuildingUpLvConfig:getInstance():getConfigInfo(buidlingType,level)
			table.insert(arry,{level,v.wre_attack,v.wre_range,builingUpInfo.bu_fightforce})
		end
	end
    table.sort(arry,function(a,b) return a[1] < b[1] end)
    return arry
end

