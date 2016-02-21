
--[[
	jinyan.zhang
	副本消息处理
--]]

CopyBattleService = {}


--初初化
function CopyBattleService:initialize()
	NetMsgMgr:getInstance():registerMsg(MESSAGE_TYPE.P_CMD_C_DUPLICATE_FIGHT, CopyBattleService, CopyBattleService.enterCopyResult)
end

--进入副本请求
--copyId 副本id
--arms 部队
--copyIndex 第几关副本
--返回值(无)
function CopyBattleService:sendEnterCopyReq(copyId,marching,copyIndex)
	local info = {}
	info.copyId = copyId
	info.marching = clone(marching)
	info.copyIndex = copyIndex
	CopyBattleModel:getInstance():saveLocalBattleArmsData(info)
	--删除参加战斗的士兵
	CopyBattleModel:getInstance():delGoBattleArms(info.marching)

  	local CopyRequest = {
		type = copyId,
		marching = marching,
		markId = info.markId
	}
	dump(CopyRequest,"CopyRequest")

	NetWorkMgr:getInstance():sendData("game.DuplicatePacket",CopyRequest,MESSAGE_TYPE.P_CMD_C_DUPLICATE_FIGHT)
	MyLog("发送进入副本请求")
	MessageProp:apper()
end

--进入副本结果
--msg 数据
--返回值(无)
function CopyBattleService:enterCopyResult(msg)
	MessageProp:dissmis()
	MyLog("收到进入副本结果 msg.result=",msg.result)
	if msg.result <= 0 then
		CopyBattleModel:getInstance():delLocalBattleArmsData()
		Lan:hintService(msg.result)
		return
	end

	local data = Protobuf.decode("game.DuplicateFightResult", msg.data)
	CopyBattleModel:getInstance():setData(data)

	SceneMgr:getInstance():goToCopyMap()
end

CopyBattleService:initialize()

