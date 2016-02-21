
--[[
	jinyan.zhang
	解锁区域
--]]

UnLockAreaModel = class("UnLockAreaModel")
local instance = nil

--构造
--返回值(无)
function UnLockAreaModel:ctor()
	self:init()
end

--初始化
--返回值(空)
function UnLockAreaModel:init()
	self.areaState = {}
	self.areaState[1] = {}
	self.areaState[1].unLock = false
	self.areaState[2] = {}
	self.areaState[2].unLock = false
	self.areaState[3] = {}
	self.areaState[3].unLock = false
	self.areaState[4] = {}
	self.areaState[4].unLock = false
end

--获取单例
--返回值(单例)
function UnLockAreaModel:getInstance()
	if instance == nil then
		instance = UnLockAreaModel.new()
	end
	return instance
end

function UnLockAreaModel:setUnLockList(data)
	if data == nil then
		return
	end
	for k,v in pairs(data) do
		self.areaState[v].unLock = true
	end
end

function UnLockAreaModel:setUnLockIndex(data)
	local index = data.areaId
	self.areaState[index].unLock = true
	local castInfo = CastleEffectConfig:getInstance():getConfigByArea(index)
	if castInfo == nil then
		return
	end

	PlayerData:getInstance():setPlayerFood(castInfo.ce_needgrain)
	PlayerData:getInstance():setPlayerWood(castInfo.ce_needwood)
	UICommon:getInstance():updatePlayerDataUI()

	local cityBuildingListCtrl = MapMgr:getInstance():getCityBuildingListCtrl()
	if cityBuildingListCtrl ~= nil then
	 	cityBuildingListCtrl:updateUnLockArea()
	end
end

function UnLockAreaModel:getUnLockList()
	return self.areaState 
end

function UnLockAreaModel:getUnLockLevel(areaIndex)
	local areaConfig = CastleEffectConfig:getInstance():getConfigByArea(areaIndex)
	if areaConfig == nil then
		return 100
	end
	return areaConfig.ce_level
end

function UnLockAreaModel:isCanUnLockArea(areaIndex)	
	local minUnLockLevel = self:getUnLockLevel(areaIndex)
	local castleInfo = CityBuildingModel:getInstance():getBuildInfoByType(BuildType.castle)
	if castleInfo.level >= minUnLockLevel then
		return true
	end
	return false
end

--清理缓存数据
--返回值(无)
function UnLockAreaModel:clearCache()
	self:init()
end



