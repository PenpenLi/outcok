
--[[
	jinyan.zhang
	堡垒消息
--]]

FortressService = {}

P_CMD_C_TRAP_CREATE = 57 --建造陷阱  
P_CMD_S_TRAP_CREATE = 58  --建造陷阱完成  
P_CMD_C_GETTRAP_CREATE = 59 --取出建造完成的陷阱
P_CMD_C_TRAP_CANCEL_CREATE = 62  --取消建造陷阱 
P_CMD_C_REMOVE_TRAP = 64 --摧毁陷阱  

--初始化
--返回值(无)
function FortressService:initialize()
	NetMsgMgr:getInstance():registerMsg(P_CMD_C_TRAP_CREATE, FortressService, FortressService.makeTrapRes)
	NetMsgMgr:getInstance():registerMsg(P_CMD_S_TRAP_CREATE, FortressService, FortressService.finishMakeTrapRes)
	NetMsgMgr:getInstance():registerMsg(P_CMD_C_GETTRAP_CREATE, FortressService, FortressService.getMakeTrapRes)
	NetMsgMgr:getInstance():registerMsg(P_CMD_C_TRAP_CANCEL_CREATE, FortressService, FortressService.cancelMakeTrapRes)
	NetMsgMgr:getInstance():registerMsg(P_CMD_C_REMOVE_TRAP, FortressService, FortressService.destroyTrapRes)
end

--建造陷井请求
--pos 建筑位置
--soldierType 陷井类型
--lv 等级
--num 数量
--name 名称
--返回值(无)
function FortressService:makeTrapSeq(pos,trapType,lv,num,name)
	local info = {}
	info.buildingPos = pos
	info.soldierType = trapType
	info.lv = lv
	info.num = num
	info.name = name
	MakeSoldierModel:getInstance():saveMakeSoldierLocalData(info)

	local data = {
		pos = pos,
		type = trapType,
		level = lv,
		number = num,
		markId = info.markId,
	}
	dump(data)
	NetWorkMgr:getInstance():sendData("game.CreateArms",data,P_CMD_C_TRAP_CREATE)
	print("发送制造陷井请求")
	MessageProp:apper()
end

--制造陷井结果
--msg 数据包
--返回值(无)
function FortressService:makeTrapRes(msg)
	MessageProp:dissmis()
	MyLog("收到制造陷井结果 result=",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end

	local data = Protobuf.decode("game.TimeoutPacket", msg.data)
	local info = MakeSoldierModel:getInstance():getMakeSoldierLocalData(data.markId)
	MakeSoldierModel:getInstance():syncMakeSoldiersData(data,info)
	MakeSoldierModel:getInstance():delMakeSoldierLocalData(info.markId)
end

--完成制造陷井结果
--msg 数据包
--返回值(无)
function FortressService:finishMakeTrapRes(msg)
	MyLog("收到完成制造陷井结果 result=",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end

	local data = Protobuf.decode("game.CreateArmsResult", msg.data)
	MakeSoldierModel:getInstance():syncMakeSoldiersFinishData(data)
end

--取出陷井请求
--pos 建筑位置
--返回值(无)
function FortressService:getMakeTrapSeq(pos)
	local data = {
		pos = pos,
	}
	NetWorkMgr:getInstance():sendData("game.GetReadyArms",data,P_CMD_C_GETTRAP_CREATE)
	MyLog("取出陷井请求 pos=",pos)
	MessageProp:apper()
end

--取出陷井结果
--msg 消息
--返回值(无)
function FortressService:getMakeTrapRes(msg)
	MessageProp:dissmis()
	MyLog("收到取出陷井结果=",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end

	local data = Protobuf.decode("game.GetReadyArmsResult", msg.data)
	MakeSoldierModel:getInstance():syncGetMakeSoldiersData(data)
end

--取消制造陷井请求
--buildingPos 建筑位置
--返回值(无)
function FortressService:cancelMakeTrapReq(buildingPos)
	local data = {
		pos = buildingPos,
	}
	NetWorkMgr:getInstance():sendData("game.CancelTrainArms",data,P_CMD_C_TRAP_CANCEL_CREATE)
	MyLog("发送取消制造陷井请求pos=",buildingPos)
	MessageProp:apper()
end

--取消制造陷井结果
--msg 消息
--返回值(无)
function FortressService:cancelMakeTrapRes(msg)
	MessageProp:dissmis()
	MyLog("收到取消制造陷井结果=",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end

	local data = Protobuf.decode("game.CancelTrainArmsResult", msg.data)
	MakeSoldierModel:getInstance():cancelTrainRes(data)
end

--销毁陷井请求
--arms 士兵
--buildingPos 建筑位置
--返回值(无)
function FortressService:sendDestroyTrapReq(arms,buildingPos)
	local data = {
		arms = arms,
	}
	dump(data)
	NetWorkMgr:getInstance():sendData("game.FireArmsPacket",data,P_CMD_C_REMOVE_TRAP)
	MyLog("发送销毁陷井请求")
	MessageProp:apper()
end

--销毁陷井结果
--msg 消息
--返回值(无)
function FortressService:destroyTrapRes(msg)
	MessageProp:dissmis()
	MyLog("销毁陷井结果=",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end

	local data = Protobuf.decode("game.FireArmsResult", msg.data)
	MakeSoldierModel:getInstance():fireSoldierRes(data)
end


FortressService:initialize()




