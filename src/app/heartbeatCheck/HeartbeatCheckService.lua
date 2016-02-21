
--[[
	jinyan.zhang
	心跳包消息处理
--]]

HeartbeatCheckService = {}

local P_CMD_C_PLAYER_BEATHEART = 30  --心跳包

--初初化
function HeartbeatCheckService:initialize()
	NetMsgMgr:getInstance():registerMsg(P_CMD_C_PLAYER_BEATHEART, HeartbeatCheckService, HeartbeatCheckService.recvHeartbeatResult)
end

--发送心跳包
--返回值(无)
function HeartbeatCheckService:sendHeartbeatReq()
	NetWorkMgr:getInstance():sendData("",nil,P_CMD_C_PLAYER_BEATHEART)
	HeartbeatCheckModel:getInstance():clearData()
	--MyLog("发送心跳包请求")
end

--收到心跳包结果
--msg 数据
--返回值(无)
function HeartbeatCheckService:recvHeartbeatResult(msg)
	--MyLog("收到心跳包 msg.result=",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end
	HeartbeatCheckModel:getInstance():setData()
end

HeartbeatCheckService:initialize()

