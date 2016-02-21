
--[[
	jinyan.zhang
	城外建筑数据
--]]

OutBuildingData = class("OutBuildingData")

local instance = nil

--获取单例
--返回值(单例)
function OutBuildingData:getInstance()
	if instance == nil then
		instance = OutBuildingData.new()
	end
	return instance
end

--清理缓存数据
--返回值(无)
function OutBuildingData:clearCachData()
	self:init()
end

function OutBuildingData:ctor()
	self:init()
end

function OutBuildingData:init()
	self.arryBuilding = {}
end

--创建测试数据
function OutBuildingData:createTestData()
	local arry = {}
	for i=27,34 do
		local info = {}
		info.wildBuildingId = {}
		info.wildBuildingId.id_h = i
		info.wildBuildingId.id_l = i
		info.type = i
		info.level = 1
		info.timeoutId = {}
		table.insert(arry,info)
	end
	self:createBuildingList(arry)
	local id = {}
	id.id_h = 123
	id.id_l = 1222
	OutPlaceBuildingData:getInstance():createBuildingInfo(id,28,1,10,10,id)
end

--创建建筑列表
function OutBuildingData:createBuildingList(data)
	for k,v in pairs(data) do
		self:createBuilding(v)
	end
end

--创建建筑
function OutBuildingData:createBuilding(data)
	local info = {}
	--建筑实例ID
	info.id = {}
	info.id.id_h = data.wildBuildingId.id_h
	info.id.id_l = data.wildBuildingId.id_l
	--类型
	info.type = data.type
	--建筑等级
	info.level = data.level
	--定时器ID
	info.timeoutId = data.timeoutId
	table.insert(self.arryBuilding,info)
	TimeInfoData:getInstance():setInstanceIds(info.timeoutId.id_h,info.timeoutId.id_l,info.id)
end

--获取建筑信息通过实例ID
function OutBuildingData:getInfoById(instanceId)
	if instanceId == nil then
		return
	end

	for k,v in pairs(self.arryBuilding) do
		if v.id.id_h == instanceId.id_h and v.id.id_l == instanceId.id_l then
			return v
		end
	end
end

--获取建筑等级通过实例ID
function OutBuildingData:getLevelById(instanceId)
	local info = self:getInfoById(instanceId)
	if info ~= nil then
		return info.level
	end
	return 1
end

--获取建筑信息通过类型
function OutBuildingData:getInfoByType(type)
	if type == nil then
		return
	end

	for k,v in pairs(self.arryBuilding) do
		if v.type == type then
			return v
		end
	end
end

--获取建筑等级通过类型
function OutBuildingData:getLevelByType(type)
	local info = self:getInfoByType(type)
	if info ~= nil then
		return info.level
	end
	return 1
end

--设置建筑等级通过实例id
function OutBuildingData:setLevelById(instanceId,level)
	local info = self:getInfoById(instanceId)
	if info ~= nil then
		info.level = level
	end
end

--获取城墙列表
function OutBuildingData:getWallList()
	local arry = {}
	for k,v in pairs(self.arryBuilding) do
		if v.type == BuildType.out_wall then
			table.insert(arry,v)
		end
	end
	return arry
end

--获取城墙列表通过等级
function OutBuildingData:getWallListByLevel(level,instanceId)
	if level == nil or instanceId == nil then
		return
	end

	local arry = {}
	table.insert(arry,instanceId)
	local list = {}
	local leftTime = TimeInfoData:getInstance():getLeftTimeByInstanceIdList(arry)
	local arry = self:getWallList()
	for k,v in pairs(arry) do
		local arryId = {}
		table.insert(arryId,v.id)
		local time = TimeInfoData:getInstance():getLeftTimeByInstanceIdList(arryId)
		if v.level == level and time == leftTime then
			local info = OutPlaceBuildingData:getInstance():getBuildingInfoById(v.id)
			if info == nil then
				table.insert(list,v.id)
			end
		end
	end
	return list
end

--获取未放置的城墙数量
function OutBuildingData:getUnPlaceWallCount(level)
	if level == nil then
		return
	end

	local list = {}
	local arry = self:getWallList()
	for k,v in pairs(arry) do
		if v.level == level then
			local info = OutPlaceBuildingData:getInstance():getBuildingInfoById(v.id)
			if info == nil then
				table.insert(list,v.id)
			end
		end
	end
	return list
end

--获取城墙数量
function OutBuildingData:getWallCount(level)
	if level == nil then
		return
	end

	local list = {}
	local arry = self:getWallList()
	for k,v in pairs(arry) do
		if v.level == level then
			table.insert(list,v.id)
		end
	end
	return list
end




 