
--[[
	jinyan.zhang
	堡垒数据
--]]

FortressModel = class("FortressModel")
local instance = nil

local _markId = 0

--创建一个标记id
--返回值(id)
function FortressModel:createMarkId()
	_markId = _markId + 1
	if _markId > 9999 then
		_markId = 1
	end
	return _markId
end

--构造
--返回值(无)
function FortressModel:ctor()
	self:init()
end

--初始化
--返回值(空)
function FortressModel:init()
	
end

--获取单例
--返回值(单例)
function FortressModel:getInstance()
	if instance == nil then
		instance = FortressModel.new()
	end
	return instance
end

--获取最大陷井个数
--返回值(最大值)
function FortressModel:getMaxTrapCount()
	local wallLevel = CityBuildingModel:getInstance():getBuildingLvByType(BuildType.wall)
	if wallLevel == nil then
		wallLevel = 1
	end
    local configInfo = WallEffectConfig:getInstance():getConfigByLevel(wallLevel)
    if configInfo == nil then
    	configInfo = {}
    	configInfo.we_trap = 1
    end
    return configInfo.we_trap
end

--消耗资源
--configId 配置表id
--返回值(无)
function FortressModel:castResource(typeId,level)
	local castInfo = TrapListConfig:getInstance():getConfigByType(typeId,level)
	PlayerData:getInstance():setPlayerWood(castInfo.tl_wood)
    PlayerData:getInstance():setPlayerFood(castInfo.tl_grain)
    PlayerData:getInstance():setPlayerIron(castInfo.tl_iron)
    PlayerData:getInstance():setPlayerMithril(castInfo.tl_mithril)
end

--获取陷井列表数据
--buildingPos 建筑位置
--返回值(陷井列表数据)
function FortressModel:getTrapListData(buildingPos)
	local buildingInfo = CityBuildingModel:getInstance():getBuildInfo(buildingPos)
	local trapList = {}
	local data = TrapListConfig:getInstance():getConfig()
	for i=1,#data do
		trapList[i] = {}
		trapList[i].tempeleId = data[i].tl_id
		trapList[i].trapType = data[i].tl_armstypeid
		trapList[i].name = ArmsData:getInstance():getOccupatuinName(trapList[i].trapType,data[i].tl_level)
		trapList[i].lv = data[i].tl_level
		local config = TrapListConfig:getInstance():getConfigById(trapList[i].tempeleId)
		if buildingInfo.level >= data[i].tl_needbuildlevel then
			trapList[i].isCanBuild = true
		else
			trapList[i].isCanBuild = false
		end
		trapList[i].unlockDesStr = data[i].tl_needbuildlevel .. CommonStr.LEVEL .. BuildingTypeConfig:getInstance():getBuildingNameByType(buildingInfo.type) .. CommonStr.UNLOCK
		trapList[i].createTime = data[i].tl_buildtime
		trapList[i].food = data[i].tl_grain
		trapList[i].wood = data[i].tl_wood
		trapList[i].iron = data[i].tl_iron
		trapList[i].mithril = data[i].tl_mithril
		trapList[i].trapNum = ArmsData:getInstance():getNumberByTypeAndLevel(trapList[i].trapType,trapList[i].lv)
		trapList[i].smallPicName = "#" .. config.tl_icon .. ".png"
		trapList[i].bigPicName = config.tl_icon .. ".png"
		trapList[i].templeteInfo = data[i]
	end
	return trapList
end

--清理缓存
--返回值(无)
function FortressModel:clearCache()
	self:init()
end





