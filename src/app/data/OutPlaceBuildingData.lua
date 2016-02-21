
--[[
	jinyan.zhang
	野外已经放置的建筑实例
--]]

OutPlaceBuildingData = class("OutPlaceBuildingData")

local instance = nil

--获取单例
--返回值(单例)
function OutPlaceBuildingData:getInstance()
	if instance == nil then
		instance = OutPlaceBuildingData.new()
	end
	return instance
end

function OutPlaceBuildingData:ctor()
	self:init()
end

function OutPlaceBuildingData:init()
	self.arryBuilding = {}
end

--创建建筑列表
function OutPlaceBuildingData:createBuildingList(data)
	for k,v in pairs(data) do
		self:createBuilding(v)
	end
end

function OutPlaceBuildingData:getList()
	return self.arryBuilding
end

--创建建筑
function OutPlaceBuildingData:createBuilding(data)
	local info = {}
	--建筑基础实例ID
	info.id = {}
	info.id.id_h = data.wildBuildingId.id_h
	info.id.id_l = data.wildBuildingId.id_l
	--建筑实例ID
	info.placedBuildingId = {}
	info.placedBuildingId.id_h = data.placedBuildingId.id_h
	info.placedBuildingId.id_l = data.placedBuildingId.id_l
	local buildingInfo = OutBuildingData:getInstance():getInfoById(info.id)
	--类型
	info.type = buildingInfo.type
	--建筑等级
	info.level = buildingInfo.level
	--坐标x
	info.x = data.x
	--坐标y
	info.y = data.y
	--test
	s = s or 1
	s = s + 1
	info.x = PlayerData:getInstance().x + s
	info.y = PlayerData:getInstance().y + s
	table.insert(self.arryBuilding,info)
end

--创建建筑信息
function OutPlaceBuildingData:createBuildingInfo(id,type,level,x,y,placedBuildingId)
	local info = {}
	--建筑基础实例ID
	info.id = id
	--建筑实例ID
	info.placedBuildingId = placedBuildingId
	--类型
	info.type = type
	--建筑等级
	info.level = level
	--坐标x
	info.x = x
	--坐标y
	info.y = y
	table.insert(self.arryBuilding,info)
end

--删除建筑信息通过实例id
function OutPlaceBuildingData:delBuildingInfo(id)
	for k,v in pairs(self.arryBuilding) do
		if v.id.id_h == id.id_h and v.id.id_l == id.id_l then
			self.arryBuilding[k] = nil
			break
		end
	end
end

--获取建筑信息通过建筑类型
function OutPlaceBuildingData:getInfoByType(buildingType)
	for k,v in pairs(self.arryBuilding) do
		if v.type == buildingType then
			return v
		end
	end
end

--获取建筑信息通过id
function OutPlaceBuildingData:getBuildingInfoById(id)
	for k,v in pairs(self.arryBuilding) do
		if v.id.id_h == id.id_h and v.id.id_l == id.id_l then
			return v
		end
	end
end




