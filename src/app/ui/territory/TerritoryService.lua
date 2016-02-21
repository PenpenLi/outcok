
--[[
	jinyan.zhang
	野外领地消息
--]]

local P_CMD_C_WILD_BUILDING_UPDRADE = 110 	--升级野外建筑       
local P_CMD_S_WILD_BUILDING_UPDRADE = 111 	--升级野外建筑完成   
local P_CMD_S_CREATE_NEW_WILDWALLS = 117    --新增野外城墙基础实例
local P_CMD_C_SET_GARRISON_ARMS = 119       --设置城外守军

TerritoryService = class("TerritoryService")

local instance = nil

--获取单例
--返回值(单例)
function TerritoryService:getInstance()
	if instance == nil then
		instance = TerritoryService.new()
	end
	return instance
end

function TerritoryService:init()
	NetMsgMgr:getInstance():registerMsg(P_CMD_C_PLAYER_WILDBUILDING_LIST, self, self.recvOutBuildingList)
	NetMsgMgr:getInstance():registerMsg(P_CMD_C_WILD_BUILDING_UPDRADE, self, self.upLevelBuildingRes)
	NetMsgMgr:getInstance():registerMsg(P_CMD_S_WILD_BUILDING_UPDRADE, self, self.finishUpLevelBuildingRes)
	NetMsgMgr:getInstance():registerMsg(P_CMD_S_CREATE_NEW_WILDWALLS, self, self.syncAddOutWallRes)
	NetMsgMgr:getInstance():registerMsg(P_CMD_C_SET_GARRISON_ARMS, self, self.recvDeferArmsRes)
	NetMsgMgr:getInstance():registerMsg(P_CMD_C_PLAYER_GARRISON_LIST, self, self.recvDeferArmListRes)
end

--获取野外建筑列表
function TerritoryService:getOutBuildingList()
	NetWorkMgr:getInstance():sendData("",nil,P_CMD_C_PLAYER_WILDBUILDING_LIST)
end

--收到野外建筑列表
function TerritoryService:recvOutBuildingList(msg)
	MyLog("收到野外建筑列表结果 msg.result=",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end

	local data = Protobuf.decode("game.PlayerWildBuildingPacket", msg.data)
	TerritoryModel:getInstance():recvOutBuildingList(data)
end

--升级野外建筑请求
function TerritoryService:upLevelBuildingReq(wildBuildingIds)
	local info = {}
	info.wildBuildingIds = clone(wildBuildingIds)
	TerritoryModel:getInstance():saveUpLevelInfo(info)
	local data = {
		wildBuildingId = wildBuildingIds,
		markId = info.markId
	}
	NetWorkMgr:getInstance():sendData("game.UpgradeWildBuilding",data,P_CMD_C_WILD_BUILDING_UPDRADE)
	MessageProp:apper()
	MyLog("发送升级野外建筑请求")
end

--升级野外建筑结果
--msg 数据
--返回值(无)
function TerritoryService:upLevelBuildingRes(msg)
	MessageProp:dissmis()
	MyLog("收到升级野外建筑结果 msg.result=",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end

	local data = Protobuf.decode("game.TimeoutPacket", msg.data)
	TerritoryModel:getInstance():upLevelBuildingRes(data)
end

--完成升级野外建筑结果
function TerritoryService:finishUpLevelBuildingRes(msg)
	MessageProp:dissmis()
	MyLog("收到完成升级野外建筑结果 msg.result=",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end

	local data = Protobuf.decode("game.UpgradeWildBuildingResult", msg.data)
	TerritoryModel:getInstance():finishUpLevelBuildingRes(data)
end

--同步添加野外城墙实例
function TerritoryService:syncAddOutWallRes(msg)
	MessageProp:dissmis()
	MyLog("升级城墙后,收到添加野外城墙实例 msg.result=",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end

	local data = Protobuf.decode("game.CastleAddNewWildWallPacket", msg.data)
	TerritoryModel:getInstance():syncAddOutWallRes(data)
end

--设置守军部队请求
function TerritoryService:setDeferArmsReq(garrison)
	local data = {
		garrison = garrison,
	}
	NetWorkMgr:getInstance():sendData("game.SetGarrisonPacket",data,P_CMD_C_SET_GARRISON_ARMS)
	MessageProp:apper()
	MyLog("设置守军部队请求")
end

--收到守军部队数据
function TerritoryService:recvDeferArmsRes(msg)
	MessageProp:dissmis()
	MyLog("收到守军部队数据 msg.result=",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end

	local data = Protobuf.decode("game.PlayerGarrisonPacket", msg.data)
	TerritoryModel:getInstance():recvDeferArmsRes(data)
end

--获取城外守军请求
function TerritoryService:getDeferArmsReq()
	NetWorkMgr:getInstance():sendData("",nil,P_CMD_C_PLAYER_GARRISON_LIST)
end

--收到城外守军列表
function TerritoryService:recvDeferArmListRes(msg)
	MyLog("收到城外守军部队列表 msg.result=",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end

	local data = Protobuf.decode("game.PlayerGarrisonPacket", msg.data)
	TerritoryModel:getInstance():recvDeferArmListRes(data)
end

TerritoryService:getInstance():init()
