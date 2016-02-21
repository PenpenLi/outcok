
--[[
	jinyan.zhang
	城内建筑消息处理
--]]

CityBuildingService = {}

local P_CMD_C_RESOURCE_COLLECT = 31  --收集资源
local P_CMD_S_RESOURCE_COLLECT = 32  --通知资源田完成生产
local P_CMD_C_CANCEL_REMOVE = 34     --取消移除建筑

--初始化
--返回值(无)
function CityBuildingService:initialize()
	NetMsgMgr:getInstance():registerMsg(MESSAGE_TYPE.P_CMD_S_BUILDING_CREATE, CityBuildingService, CityBuildingService.createBuildingFinishRes)
	NetMsgMgr:getInstance():registerMsg(MESSAGE_TYPE.P_CMD_C_BUILDING_CREATE, CityBuildingService, CityBuildingService.createBuildingRes)
	NetMsgMgr:getInstance():registerMsg(MESSAGE_TYPE.P_CMD_S_BUILDING_REMOVE, CityBuildingService, CityBuildingService.removeBuildingFinishRes)
	NetMsgMgr:getInstance():registerMsg(MESSAGE_TYPE.P_CMD_C_BUILDING_REMOVE, CityBuildingService, CityBuildingService.removeBuildingRes)
	NetMsgMgr:getInstance():registerMsg(MESSAGE_TYPE.P_CMD_S_BUILDING_UPGRADE, CityBuildingService, CityBuildingService.upLvBuildingFinishRes)
	NetMsgMgr:getInstance():registerMsg(MESSAGE_TYPE.P_CMD_C_BUILDING_UPGRADE, CityBuildingService, CityBuildingService.upLvBuildingRes)
	NetMsgMgr:getInstance():registerMsg(MESSAGE_TYPE.P_CMD_C_BUILDING_CANCEL_UPGRADE, CityBuildingService, CityBuildingService.cancelUpBuildingRes)
	NetMsgMgr:getInstance():registerMsg(P_CMD_C_RESOURCE_COLLECT, CityBuildingService, CityBuildingService.recvCollectingResourcesRes)
	NetMsgMgr:getInstance():registerMsg(P_CMD_S_RESOURCE_COLLECT, CityBuildingService, CityBuildingService.recvNoticeHarvestResourcesRes)
	NetMsgMgr:getInstance():registerMsg(P_CMD_C_CANCEL_REMOVE, CityBuildingService, CityBuildingService.cancelRemoveRes)
end

--建造建筑请求
--pos 位置
--buildingType 建筑类型
--返回值(无)
function CityBuildingService:createbuildingSeq(pos,buildingType)
	local info = {}
	info.buildingPos = pos
	info.buildingType = buildingType
	info.level = 0
	CityBuildingModel:getInstance():saveBuildingUpLocalData(info)

	local buildingData = {
		pos = pos,
		type = buildingType,
		markId = info.markId,
	}
	NetWorkMgr:getInstance():sendData("game.CreateBuilding",buildingData,MESSAGE_TYPE.P_CMD_C_BUILDING_CREATE)

	local buildingName = BuildingTypeConfig:getInstance():getBuildingNameByType(buildingType)
	MyLog("send createbuildingSeq pos=",pos,"buildingType=",buildingType,"buildingName=",buildingName,"info.markId=",info.markId)
	MessageProp:apper()
end

--创建建筑结果
--msg 数据包
--返回值(无)
function CityBuildingService:createBuildingRes(msg)
	MessageProp:dissmis()
	MyLog("create Building result=",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end

	local data = Protobuf.decode("game.BuilderPacket", msg.data)
	local info = CityBuildingModel:getInstance():getBuildingUpLocalData(data.markId)
	data.buildingPos = info.buildingPos
	data.type = info.buildingType

	CityBuildingModel:getInstance():syncCreateBuildingData(data)
	CityBuildingModel:getInstance():delBuildingUpLocalData(data.markId)
end

--创建建筑完成结果
--msg 数据包
--返回值(无)
function CityBuildingService:createBuildingFinishRes(msg)
	MyLog("createBuildingFinishRes result=",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end

	local data = Protobuf.decode("game.CreateBuildingResult", msg.data)
	CityBuildingModel:getInstance():syncFinishCreateBuildingData(data)
end

--升级建筑请求
--pos 建筑位置
--返回值(无)
function CityBuildingService:upLvBuildingSeq(pos)
	local info = {}
	info.buildingPos = pos
	info.buildingType = CityBuildingModel:getInstance():getBuildType(pos)
	CityBuildingModel:getInstance():saveBuildingUpLocalData(info)

	local upLvBuildingData = {
		pos = pos,
		markId = info.markId,
	}
	NetWorkMgr:getInstance():sendData("game.UpgradeBuilding",upLvBuildingData,MESSAGE_TYPE.P_CMD_C_BUILDING_UPGRADE)

	local buildingName = BuildingTypeConfig:getInstance():getBuildingNameByType(info.buildingType)
	MyLog("send UpLvBuilding Req pos=",pos,"buildingType=",buildingType,"buildingName=",buildingName)
	MessageProp:apper()
end

--升级建筑结果
--msg 数据包
--返回值(无)
function CityBuildingService:upLvBuildingRes(msg)
	MessageProp:dissmis()
	MyLog("upLv Building result=",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end

	local data = Protobuf.decode("game.BuilderPacket", msg.data)
	--text
	--data.interval = 300
	local info = CityBuildingModel:getInstance():getBuildingUpLocalData(data.markId)
	data.buildingPos = info.buildingPos
	data.type = info.buildingType

	CityBuildingModel:getInstance():syncUpLvBuildingData(data)
	CityBuildingModel:getInstance():delBuildingUpLocalData(info.markId)
end

--升级建筑完成结果
--msg 数据包
--返回值(无)
function CityBuildingService:upLvBuildingFinishRes(msg)
	MyLog("upLv Building result=",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end

	local data = Protobuf.decode("game.UpgradeBuildingResult", msg.data)
	CityBuildingModel:getInstance():syncUpLvBuildingFinishData(data)
end

--移除建筑请求
--pos 建筑位置
--返回值(无)
function CityBuildingService:removeBuildingReq(pos)
	local info = {}
	info.buildingPos = pos
	info.buildingType = CityBuildingModel:getInstance():getBuildType(pos)
	CityBuildingModel:getInstance():saveBuildingRemoveLocalData(info)

	local removeBuildingData = {
		pos = pos,
		markId = info.markId,
	}
	NetWorkMgr:getInstance():sendData("game.RemoveBuilding",removeBuildingData,MESSAGE_TYPE.P_CMD_C_BUILDING_REMOVE)

	local buildingType = CityBuildingModel:getInstance():getBuildType(pos)
	local buildingName = BuildingTypeConfig:getInstance():getBuildingNameByType(buildingType)
	MyLog("send removeBuildingReq pos=",pos,"buildingType=",buildingType,"buildingName=",buildingName)
	MessageProp:apper()
end

--移除建筑结果
--msg 数据包
--返回值(无)
function CityBuildingService:removeBuildingRes(msg)
	MessageProp:dissmis()
	MyLog("remove Building result=",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end

	local data = Protobuf.decode("game.BuilderPacket", msg.data)
	local info = CityBuildingModel:getInstance():getBuildingRemoveLocalData(data.markId)
	data.buildingPos = info.buildingPos
	data.type = info.buildingType

	CityBuildingModel:getInstance():syncDelBuildingData(data)
	CityBuildingModel:getInstance():delBuildingRemoveLocalData(info.markId)
end

--完成移除建筑结果
--msg 数据包
--返回值(无)
function CityBuildingService:removeBuildingFinishRes(msg)
	MyLog("remove Building result=",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end

	local data = Protobuf.decode("game.RemoveBuildingResult", msg.data)
	CityBuildingModel:getInstance():syncDelBuildingFinishData(data)
end

--取消升级建筑
--posId 建筑位置
function CityBuildingService:cancelUpBuildingReq(pos)
	local cancelUpLvBuildingData = {
		pos = pos,
	}
	NetWorkMgr:getInstance():sendData("game.CancelUpgradeBuilding",cancelUpLvBuildingData,MESSAGE_TYPE.P_CMD_C_BUILDING_CANCEL_UPGRADE)
	local buildingType = CityBuildingModel:getInstance():getBuildType(pos)
	local buildingName = BuildingTypeConfig:getInstance():getBuildingNameByType(buildingType)
	MyLog("send cancelUpBuildingReq pos=",pos,"buildingType=",buildingType,"buildingName=",buildingName)
	MessageProp:apper()
end

--取消升级建筑结果
--msg 数据包
--返回值(无)
function CityBuildingService:cancelUpBuildingRes(msg)
	MessageProp:dissmis()
	MyLog("cancelUpBuildingRes result=",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end

	local data = Protobuf.decode("game.CancelUpgradeBuilding", msg.data)
	CityBuildingModel:getInstance():syncCancelUpBuildingRes(data)
end

--发送取消移除建筑请求
--buildingPos 建筑位置
--返回值(无)
function CityBuildingService:sendCancelRemoveReq(buildingPos)
	MyLog("发送取消移除建筑位置=",buildingPos)
	local cancelRemoveData = {
		pos = buildingPos,
	}
	NetWorkMgr:getInstance():sendData("game.CancelRemoveBuilding",cancelRemoveData,P_CMD_C_CANCEL_REMOVE)
	MessageProp:apper()
end

--取消移除建筑结果
--返回值(无)
function CityBuildingService:cancelRemoveRes(msg)
	MessageProp:dissmis()
	MyLog("取消移除建筑结果=",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end

	local data = Protobuf.decode("game.CancelRemoveBuildingRes", msg.data)
	CityBuildingModel:getInstance():cancelRemoveBuildingRes(data)
end

--请求收集资源
--返回值(无)
function CityBuildingService:sendCollectingResourcesReq(buildingPos)
    local data = {
		pos = buildingPos,
	}
	NetWorkMgr:getInstance():sendData("game.ResourceCollectPacket",data,P_CMD_C_RESOURCE_COLLECT)
	MyLog("发送收集资源消息",data.pos)
end

--收到收集资源
--返回值(无)
function CityBuildingService:recvCollectingResourcesRes(msg)
	MyLog("收到收集资源消息",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end

	local data = Protobuf.decode("game.ResourceCollectResult", msg.data)
	CityBuildingModel:getInstance():collectingResourcesRes(data)
end

--通知资源田完成生产
--返回值(无)
function CityBuildingService:recvNoticeHarvestResourcesRes(msg)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end
	local data = Protobuf.decode("game.ResourceFinishedPacket", msg.data)
	CityBuildingModel:getInstance():recvNoticeHarvestResourcesRes(data)
end


CityBuildingService:initialize()

