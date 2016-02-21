
--[[
	jinyan.zhang
	地图行军消息处理
--]]

PlayerMarchService = class("PlayerMarchService")

local instance = nil

--获取单例
--返回值(单例)
function PlayerMarchService:getInstance()
    if instance == nil then
        instance = PlayerMarchService.new()
    end
    return instance
end

--初初化
function PlayerMarchService:init()
	NetMsgMgr:getInstance():registerMsg(MESSAGE_TYPE.P_CMD_C_MARCHINGGROUP_CREATE, self, self.marchTimeResult)
	NetMsgMgr:getInstance():registerMsg(MESSAGE_TYPE.P_CMD_S_MARCHINGGROUP_CREATE, self, self.marchReturnResult)
	NetMsgMgr:getInstance():registerMsg(MESSAGE_TYPE.P_CMD_S_MARCHINGGROUP_ARRIVED, self, self.marchFinishResult)
end

--行军请求
--arms 部队
--targetX 目标点X坐标
--targetY 目标点Y坐标
--type 操作类型
--返回值(无)
function PlayerMarchService:sendMarchReq(arms,mapId,targetX,targetY,type)
  local MarchRequest = {
		mapId = mapId,
		posx = targetX,
		posy = targetY,
		type = type,
		marching = arms,
		markId = 1,
	}
	dump(MarchRequest,"MarchRequest=")

	NetWorkMgr:getInstance():sendData("game.CreateMarchingGroup",MarchRequest,MESSAGE_TYPE.P_CMD_C_MARCHINGGROUP_CREATE)
	MyLog("sendMarchReq")
	MessageProp:apper()
end 

--行军结果
--msg 数据
--返回值(无)
function PlayerMarchService:marchTimeResult(msg)
	MessageProp:dissmis()
	MyLog("收到玩家行军开始数据 msg.result=",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end

	local data = Protobuf.decode("game.MarchingGroupStatusResult", msg.data)
	PlayerMarchModel:getInstance():syncMarchData(data)
end

--行军返回结果
--msg 数据
--返回值(无)
function PlayerMarchService:marchReturnResult(msg)
	MyLog("收到玩家行军返回数据 msg.result=",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end

	local data = Protobuf.decode("game.MarchingGroupStatusResult", msg.data)
	PlayerMarchModel:getInstance():marchReturnData(data)
end

--完成行军
--msg 数据
--返回值(无)
function PlayerMarchService:marchFinishResult(msg)
	MyLog("收到玩家完成行军数据 msg.result=",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end

	local data = Protobuf.decode("game.MarchingGroupStatusResult", msg.data)
	PlayerMarchModel:getInstance():finishMarchingResult(data)
end

PlayerMarchService:getInstance():init()

