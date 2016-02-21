
--[[
	jinyan.zhang
	读取城墙效果配置表
--]]

WallEffectConfig = class("WallEffectConfig")
local instance = nil

local WallEffectTab = require(CONFIG_SRC_PRE_PATH .. "WallEffect")

--构造
--返回值(无)
function WallEffectConfig:ctor()
	self:init()
end

--初始化
--返回值(无)
function WallEffectConfig:init()

end

--获取单例
--返回值(单例)
function WallEffectConfig:getInstance()
	if instance == nil then
		instance = WallEffectConfig.new()
	end
	return instance
end

--获取配置通过等级
--level 等级
--返回值(配置)
function WallEffectConfig:getConfigByLevel(level)
	for k,v in pairs(WallEffectTab) do
		if v.we_level == level then
			return v
		end
	end
end

--获取资源信息
--buildingLv 建筑等级
--返回值(建筑效果)
function WallEffectConfig:getConfigInfo(buildingLv)
    for k,v in pairs(WallEffectTab) do
        if v.we_level == buildingLv then
            return v
        end
    end
end

--获取详情信息
--返回值(详情信息列表)
function WallEffectConfig:getDetailsInfo(buildingType)
	local list = {}
	for i=1,#WallEffectTab do
		local v = WallEffectTab[i]
		local info = {}
		local buildingInfo = BuildingUpLvConfig:getInstance():getConfigInfo(buildingType,v.we_level)
		info.we_level = v.we_level
		info.we_defend = v.we_defend
		info.we_trap = v.we_trap
		if buildingInfo ~= nil then
			info.bu_fightforce = buildingInfo.bu_fightforce
		else
	        info.bu_fightforce = 0
		end
		table.insert(list,info)
	end
	return list
end





