
--[[
	jinyan.zhang
	放置野外建筑数据处理
--]]

PlaceBuildingModel = class("PlaceBuildingModel")

local instance = nil
local _markId = 1

--创建一个标记id
--返回值(id)
function PlaceBuildingModel:createMarkId()
    _markId = _markId + 1
    if _markId > 9999 then
        _markId = 1
    end
    return _markId
end

--获取单例
--返回值(单例)
function PlaceBuildingModel:getInstance()
	if instance == nil then
		instance = PlaceBuildingModel.new()
	end
	return instance
end

--清理缓存数据
--返回值(无)
function PlaceBuildingModel:clearCache()
	self:init()
end

function PlaceBuildingModel:ctor()
	self:init()
end

function PlaceBuildingModel:init()
	self.placeBuildingInfo = {}
end

--保存放置建筑信息
function PlaceBuildingModel:savePlaceBuildingInfo(info)
    info.markId = self:createMarkId()
    table.insert(self.placeBuildingInfo,info)
end

--获取放置建筑信息
function PlaceBuildingModel:getPlaceBuildingInfo(markId)
	for k,v in pairs(self.placeBuildingInfo) do
		if v.markId == markId then
			return v
		end
	end
end

--删除放置建筑信息
function PlaceBuildingModel:delPlaceBuildingInfo(markId)
	for k,v in pairs(self.placeBuildingInfo) do
		if v.markId == markId then
			table.remove(self.placeBuildingInfo,k)
			break
		end
	end
end

--放置野外建筑结果
function PlaceBuildingModel:placeBuildingsRes(data)
	--放置的建筑ID
	local placementBuildingId = data.wildBuildingId
	--x
	local x = data.x
	--y
	local y = data.y
	--客户端标记ID
	local markId = data.markId
	--本地配置
	local info = self:getPlaceBuildingInfo(markId)
	--建筑实例id
	local wildBuildingId = info.wildBuildingId
	--建筑数据
	local buildingInfo = OutBuildingData:getInstance():getInfoById(wildBuildingId)
	--删除拖动的UI
	DrapBuildingMgr:getInstance():delImg()
	--创建放置建筑信息
	OutPlaceBuildingData:getInstance():createBuildingInfo(wildBuildingId,buildingInfo.type,buildingInfo.level,x,y,placementBuildingId)
	--todo 刷新UI
	OutBuildingMgr:getInstance():create(buildingInfo.type,buildingInfo.level,cc.p(x,y))
	--删除本地配置
	self:delPlaceBuildingInfo(markId)
end

--收回野外建筑结果
function PlaceBuildingModel:takeBuildingRes(data)
	--野外建筑基础ID
	local wildBuildingId = data.wildBuildingId
	--放置的建筑ID
	local placementBuildingId = data.placementBuildingId
	--客户端标记ID
	local markId = data.markId
	--删除野外建筑UI
	OutBuildingMgr:getInstance():delBuildingImgById(wildBuildingId)
	--删除数据
	OutPlaceBuildingData:getInstance():delBuildingInfo(wildBuildingId)
end


