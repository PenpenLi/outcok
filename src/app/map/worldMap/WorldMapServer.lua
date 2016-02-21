
--[[
	jinyan.zhang
	世界地图消息处理
--]]

WorldMapServer = class("WorldMapServer")

local P_CMD_C_KINGDOM_RANGE = 122  -- 获取地图区域内的对象
local instance = nil

--获取单例
--返回值(单例)
function WorldMapServer:getInstance()
    if instance == nil then
        instance = WorldMapServer.new()
    end
    return instance
end

--初初化
function WorldMapServer:init()
	NetMsgMgr:getInstance():registerMsg(MESSAGE_TYPE.P_CMD_C_ENTER_KINGDOM, self, self.enterWorldMapResult)
	NetMsgMgr:getInstance():registerMsg(P_CMD_C_KINGDOM_RANGE, self, self.recvMapPosRes)
end

--进入世界地图请求
--mapId 世界地图id
--返回值(无)
function WorldMapServer:sendEnterWorldMapReq(mapId,start_pos,end_pos)
  	local WorldMapRequest = {
		map_id = mapId,
		start_pos = start_pos,
		end_pos = end_pos,
	}
	NetWorkMgr:getInstance():sendData("game.EnterKingdomPacket",WorldMapRequest,MESSAGE_TYPE.P_CMD_C_ENTER_KINGDOM)
	MyLog("进入世界地图消息请求")
	MessageProp:apper()
end

--进入世界地图结果
--msg 数据
--返回值(无)
function WorldMapServer:enterWorldMapResult(msg)
	MessageProp:dissmis()
	MyLog("enterWorldMapResult msg.result=",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end

	local data = Protobuf.decode("game.EnterKingdomResultPacket", msg.data)
	local objects = data.objects
	local lines = data.lines
	CastleModel:getInstance():setData(objects)
	AllPlayerMarchModel:getInstance():setData(lines)
	CalLoadingTime:getInstance():calGetCastleListTime()
end

--更新地图位置请求
function WorldMapServer:updateMapPosReq(mapId,start_pos,end_pos)
	local WorldMapRequest = {
		map_id = mapId,
		start_pos = start_pos,
		end_pos = end_pos,
	}
	NetWorkMgr:getInstance():sendData("game.KingdomRangePacket",WorldMapRequest,P_CMD_C_KINGDOM_RANGE)
	--MyLog("进入世界地图消息请求")
	MessageProp:apper()
end

--收到地图位置结果
function WorldMapServer:recvMapPosRes(msg)
	MessageProp:dissmis()
	if msg.result <= 0 then
		MyLog("收到地图位置结果 msg.result=",msg.result)
		Lan:hintService(msg.result)
		return
	end

	local data = Protobuf.decode("game.KingdomRangeResult", msg.data)
	local objects = data.objects
	CastleModel:getInstance():setData(objects)
end

WorldMapServer:getInstance():init()

