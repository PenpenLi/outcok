
--[[
	jinyan.zhang
	放置野外建筑消息处理
--]]

PlaceBuildingService = class("PlaceBuildingService")

local instance = nil

local P_CMD_C_PLACEMENT_WILDBUILDING = 114	--放置野外建筑到地图上
local P_CMD_C_TAKEBACK_WILDBUILDING = 115   --回收野外建筑

--获取单例
--返回值(单例)
function PlaceBuildingService:getInstance()
    if instance == nil then
        instance = PlaceBuildingService.new()
    end
    return instance
end

--初初化
function PlaceBuildingService:init()
	NetMsgMgr:getInstance():registerMsg(P_CMD_C_PLACEMENT_WILDBUILDING, self, self.placeBuildingRes)
	NetMsgMgr:getInstance():registerMsg(P_CMD_C_TAKEBACK_WILDBUILDING, self, self.takeBuildingRes)
end

--放置野外建筑请求
function PlaceBuildingService:placeBuildingsReq(wildBuildingId,x,y)
	local info = {}
	info.x = x
	info.y = y
	info.wildBuildingId = wildBuildingId
	PlaceBuildingModel:getInstance():savePlaceBuildingInfo(info)

	local data = {
		wildBuildingId = wildBuildingId,
		x = x,
		y = y,
		markId = info.markId
	}
	dump(data)
	NetWorkMgr:getInstance():sendData("game.PlacementWildBuildingPacket",data,P_CMD_C_PLACEMENT_WILDBUILDING)
	MessageProp:apper()
	MyLog("发送放置野外建筑请求")
end

--放置野外建筑结果
function PlaceBuildingService:placeBuildingRes(msg)
	MessageProp:dissmis()
	MyLog("放置野外建筑结果 result=",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end

	local data = Protobuf.decode("game.PlacementWildBuildingPacket", msg.data)
	PlaceBuildingModel:getInstance():placeBuildingsRes(data)
end

--收回野外建筑请求
function PlaceBuildingService:takeBuildingReq(wildBuildingId,placementBuildingId)
	local data = {
		wildBuildingId = wildBuildingId,
		placementBuildingId = placementBuildingId,
		markId = 1
	}
	NetWorkMgr:getInstance():sendData("game.TakebackWildBuildingPacket",data,P_CMD_C_TAKEBACK_WILDBUILDING)
	MessageProp:apper()
	MyLog("收回野外建筑请求")
end

--收回野外建筑结果
function PlaceBuildingService:takeBuildingRes(msg)
	MessageProp:dissmis()
	MyLog("收回野外建筑结果 result=",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end

	local data = Protobuf.decode("game.TakebackWildBuildingPacket", msg.data)
	PlaceBuildingModel:getInstance():takeBuildingRes(data)
end

PlaceBuildingService:getInstance():init()
