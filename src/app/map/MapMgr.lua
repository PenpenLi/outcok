
--[[
	jinyan.zhang
	地图管理器 
--]]

MapMgr = class("MapMgr")
local instance = nil

--构造
--返回值(无)
function MapMgr:ctor()
	self:init()
end

--初始化
--返回值(无)
function MapMgr:init()

end

--获取单例
--返回值(单例)
function MapMgr:getInstance()
	if instance == nil then
		instance = MapMgr.new()
	end
	return instance
end

--加载城内
--返回值(城内)
function MapMgr:loadCity()
	self.city = CityMap.new()
	return self.city
end

--获取城内建筑列表管理器
--返回值(城内建筑列表管理器)
function MapMgr:getCityBuildingListCtrl()
	if self.city == nil then
		return
	end
	return self.city.cityBuilding
end

--获取城内
--返回值(城内)
function MapMgr:getCity()
	return self.city
end

--获取城内地图
--返回值(城内地图)
function MapMgr:getCityMap()
	if self.city then
		local bgMap = self.city:getBgMap()
		return bgMap
	end
end

--加载城外
--返回值(城外)
function MapMgr:loadWorldMap()
	self.worldMap = WorldMap.new()
	return self.worldMap
end

--获取城外
--返回值(城外)
function MapMgr:getWorldMap()
	return self.worldMap
end

--加载副本地图
--返回值(城外)
function MapMgr:loadCopyMap()
	self.copyMap = CopyMap.new()
	return self.copyMap
end

--获取副本地图
--返回值(城外)
function MapMgr:getCopyMap()
	return self.copyMap
end

--清空地图
function MapMgr:clearData()
	self.worldMap = nil
	self.copyMap = nil
	self.city = nil
end



