
--[[
	jinyan.zhang
	读取怪物列表配置
--]]

MonsterListConfig = class("MonsterListConfig")
local instance = nil

local MonsterListTab = require(CONFIG_SRC_PRE_PATH .. "CopymapMonster")

--构造
--返回值(无)
function MonsterListConfig:ctor()
	self:init()
end

--初始化
--返回值(无)
function MonsterListConfig:init()
	
end

--获取单例
--返回值(单例)
function MonsterListConfig:getInstance()
	if instance == nil then
		instance = MonsterListConfig.new()
	end
	return instance
end

--获取怪物列表
--mapId 地图id
--返回值(怪物列表)
function MonsterListConfig:getMonsterList(mapId)
	local tab = {}
	for k,v in pairs(MonsterListTab) do
		if v.ml_map == mapId then
			table.insert(tab,v)
		end
	end
	return tab
end





