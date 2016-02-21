
--[[
	jinyan.zhang
	造兵消息处理
--]]

MakeSoldierService = {}

local P_CMD_C_FIRE_ARMS = 39 			--解雇士兵 
local P_CMD_C_ARMS_CANCEL_TRAIN = 43 	--取消训练士兵 

--初始化
--返回值(无)
function MakeSoldierService:initialize()
	NetMsgMgr:getInstance():registerMsg(MESSAGE_TYPE.P_CMD_S_ARMS_CREATE, MakeSoldierService, MakeSoldierService.makeSoldiersFinishRes)
	NetMsgMgr:getInstance():registerMsg(MESSAGE_TYPE.P_CMD_C_ARMS_CREATE, MakeSoldierService, MakeSoldierService.makeSoldiersRes)
	NetMsgMgr:getInstance():registerMsg(MESSAGE_TYPE.P_CMD_C_GETARMS_CREATE, MakeSoldierService, MakeSoldierService.getMakeSoldiersRes)
	NetMsgMgr:getInstance():registerMsg(P_CMD_C_ARMS_CANCEL_TRAIN, MakeSoldierService, MakeSoldierService.cancelTrainRes)
	NetMsgMgr:getInstance():registerMsg(P_CMD_C_FIRE_ARMS, MakeSoldierService, MakeSoldierService.fireSoldierRes)
end

--造兵请求
--pos 建筑位置
--soldierType 士兵类型
--lv 士兵等级
--num 士兵数量
--soldierAnmationTempleType 士兵动画模板类型
--name 士兵名称
--返回值(无)
function MakeSoldierService:makeSoldiersSeq(pos,soldierType,lv,num,soldierAnmationTempleType,name)
	local info = {}
	info.buildingPos = pos
	info.soldierType = soldierType
	info.lv = lv
	info.num = num
	info.name = name
	info.soldierAnmationTempleType = soldierAnmationTempleType
	MakeSoldierModel:getInstance():saveMakeSoldierLocalData(info)

	local makeSoldierData = {
		pos = pos,
		type = soldierType,
		level = lv,
		number = num,
		markId = info.markId,
	}
	dump(makeSoldierData)
	NetWorkMgr:getInstance():sendData("game.CreateArms",makeSoldierData,MESSAGE_TYPE.P_CMD_C_ARMS_CREATE)
	
	local buildingType = CityBuildingModel:getInstance():getBuildType(pos)
	local buildingName = BuildingTypeConfig:getInstance():getBuildingNameByType(buildingType)
	MyLog("发送造兵请求 pos=",pos,"buildingName=",buildingName,"soldierType=",soldierType,"soldierName=",soldierName,"lv=",lv,"num=",num,"buildingType=",buildingType)
	MessageProp:apper()
end

--造兵结果
--msg 数据包
--返回值(无)
function MakeSoldierService:makeSoldiersRes(msg)
	MessageProp:dissmis()
	MyLog("收到造兵结果 result=",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end

	local data = Protobuf.decode("game.TimeoutPacket", msg.data)
	local info = MakeSoldierModel:getInstance():getMakeSoldierLocalData(data.markId)
	MakeSoldierModel:getInstance():syncMakeSoldiersData(data,info)
	MakeSoldierModel:getInstance():delMakeSoldierLocalData(info.markId)
end

--完成造兵结果
--msg 数据包
--返回值(无)
function MakeSoldierService:makeSoldiersFinishRes(msg)
	MyLog("收到完成造兵消息 result=",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end

	local data = Protobuf.decode("game.CreateArmsResult", msg.data)
	MakeSoldierModel:getInstance():syncMakeSoldiersFinishData(data)
end

--取兵请求
--pos 建筑位置
--返回值(无)
function MakeSoldierService:getMakeSoldiersSeq(pos)
	local getMakeSoldierData = {
		pos = pos,
	}
	NetWorkMgr:getInstance():sendData("game.GetReadyArms",getMakeSoldierData,MESSAGE_TYPE.P_CMD_C_GETARMS_CREATE)
	MyLog("取兵 pos=",pos)
	MessageProp:apper()
end

--取兵结果
--msg 消息
--返回值(无)
function MakeSoldierService:getMakeSoldiersRes(msg)
	MessageProp:dissmis()
	MyLog("收到取兵结果=",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end

	local data = Protobuf.decode("game.GetReadyArmsResult", msg.data)
	MakeSoldierModel:getInstance():syncGetMakeSoldiersData(data)
end

--取消训练请求
--buildingPos 建筑位置
--返回值(无)
function MakeSoldierService:cancelTrainReq(buildingPos)
	local data = {
		pos = buildingPos,
	}
	NetWorkMgr:getInstance():sendData("game.CancelTrainArms",data,P_CMD_C_ARMS_CANCEL_TRAIN)
	MyLog("发送取消训练请求pos=",buildingPos)
	MessageProp:apper()
end

--取消训练结果
--msg 消息
--返回值(无)
function MakeSoldierService:cancelTrainRes(msg)
	MessageProp:dissmis()
	MyLog("收到取消训练结果=",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end

	local data = Protobuf.decode("game.CancelTrainArmsResult", msg.data)
	MakeSoldierModel:getInstance():cancelTrainRes(data)
end

--解雇士兵请求
--arms 士兵
--buildingPos 建筑位置
--返回值(无)
function MakeSoldierService:sendFireSoldierReq(arms,buildingPos)
	local data = {
		arms = arms,
	}
	dump(data)
	NetWorkMgr:getInstance():sendData("game.FireArmsPacket",data,P_CMD_C_FIRE_ARMS)
	MyLog("发送解雇士兵请求")
	MessageProp:apper()
end

--解雇士兵结果
--msg 消息
--返回值(无)
function MakeSoldierService:fireSoldierRes(msg)
	MessageProp:dissmis()
	MyLog("解雇士兵结果=",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end

	local data = Protobuf.decode("game.FireArmsResult", msg.data)
	MakeSoldierModel:getInstance():fireSoldierRes(data)
end

MakeSoldierService:initialize()




