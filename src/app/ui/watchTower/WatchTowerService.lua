
--[[
	jinyan.zhang
	瞭望塔消息处理
--]]

WatchTowerService = {}

--初初化
function WatchTowerService:initialize()
	--获取暸望塔列表
	NetMsgMgr:getInstance():registerMsg(MESSAGE_TYPE.P_CMD_C_ENTER_WATCHTOWER, WatchTowerService, WatchTowerService.getWatchTowerResult)
	--获取暸望塔详情
	NetMsgMgr:getInstance():registerMsg(MESSAGE_TYPE.P_CMD_C_ENTER_WATCHTOWER_DETAIL, WatchTowerService, WatchTowerService.getWatchTowerDetail)
	NetMsgMgr:getInstance():registerMsg(MESSAGE_TYPE.P_CMD_S_NOTIFY_WATCHTOWER, WatchTowerService, WatchTowerService.syncWatchTowerWarData)
	NetMsgMgr:getInstance():registerMsg(MESSAGE_TYPE.P_CMD_S_NOTIFY_WATCHTOWER_CLEAR, WatchTowerService, WatchTowerService.clearWatchTowerData)

end

--发送瞭望塔战报请求
--pos 瞭望塔位置
--返回值(无)
function WatchTowerService:sendGetWatchTowerReportReq(pos)
	local data = {
		pos = pos,
	}
	NetWorkMgr:getInstance():sendData("game.GetWatchTowerReport",data,MESSAGE_TYPE.P_CMD_C_ENTER_WATCHTOWER)
	MyLog("sendGetWatchTowerReportReq",pos)
	MessageProp:apper()
end

--获取瞭望塔战报结果
--msg 数据
--返回值(无)
function WatchTowerService:getWatchTowerResult(msg)
	MessageProp:dissmis()
	MyLog("getWatchTowerResult msg.result=",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end

	local data = Protobuf.decode("game.GetWatchTowerBaseResult", msg.data)
	WatchTowerModel:getInstance():setWatchtowerData(data.data)
end

--发送瞭望塔详情请求
--pos 瞭望塔位置
--返回值(无)
function WatchTowerService:sendGetWatchTowerDetail(pos,marchingid)
	local data = {
		pos = pos,
		marchingid = marchingid
	}
	NetWorkMgr:getInstance():sendData("game.GetWatchTowerDetail",data,MESSAGE_TYPE.P_CMD_C_ENTER_WATCHTOWER_DETAIL)
	MyLog("sendGetWatchTowerDetail",pos)
	MessageProp:apper()
end

--获取瞭望塔详情结果
--msg 数据
--返回值(无)
function WatchTowerService:getWatchTowerDetail(msg)
	MessageProp:dissmis()
	MyLog("getWatchTowerDetail msg.result=",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end

	local data = Protobuf.decode("game.GetWatchTowerDetailResult", msg.data)
	WatchTowerModel:getInstance():detailtInfo(data)
end

--同步瞭望塔军情数据
--msg 数据
--返回值(无)
function WatchTowerService:syncWatchTowerWarData(msg)
	MyLog("syncWatchTowerWarData msg.result=",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end
	WatchTowerModel:getInstance():setIsNeedCreateWarnPicFlg(true)
end

--清空瞭望塔数据
--msg 数据
--返回值(无)
function WatchTowerService:clearWatchTowerData(msg)
	MyLog("clearWatchTowerData msg.result=",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end
	WatchTowerModel:getInstance():setIsNeedCreateWarnPicFlg(false)
end

WatchTowerService:initialize()

