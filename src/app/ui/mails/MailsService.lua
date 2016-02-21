
--[[
	jinyan.zhang
	邮件消息处理
--]]

MailsService = class("MailsService")

local instance = nil

local P_CMD_C_DELETE_MAIL = 108 --删除邮件

--初初化
function MailsService:init()
	NetMsgMgr:getInstance():registerMsg(MESSAGE_TYPE.P_CMD_C_ENTER_MAIL, self, self.recvMailListResult)
	NetMsgMgr:getInstance():registerMsg(MESSAGE_TYPE.P_CMD_C_RECEIVE_MAIL, self, self.recvMailDeatailsResult)
	NetMsgMgr:getInstance():registerMsg(MESSAGE_TYPE.P_CMD_S_SEND_MAIL, self, self.recvUnReadMailNumResult)
	NetMsgMgr:getInstance():registerMsg(P_CMD_C_DELETE_MAIL, self, self.recvDelMailRes)
end

--发送获取邮件列表请求
--返回值(无)
function MailsService:sendGetMailListReq()
	NetWorkMgr:getInstance():sendData("",nil,MESSAGE_TYPE.P_CMD_C_ENTER_MAIL)
	MessageProp:apper()
	MyLog("发送获取邮件列表请求")
end

--收到邮件列表结果
--msg 数据
--返回值(无)
function MailsService:recvMailListResult(msg)
	MessageProp:dissmis()
	MyLog("收到邮件列表结果 msg.result=",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end

	local data = Protobuf.decode("game.EnterMailResultPacket", msg.data)
	MailsModel:getInstance():recvMailListData(data)
end

--获取未读邮件数量结果
--返回值(无)
function MailsService:recvUnReadMailNumResult(msg)
	MyLog("收到未读邮件数量 msg.result=",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end

	local data = Protobuf.decode("game.NotifyMailPacket", msg.data)
	MailsModel:getInstance():setUnReadMailCount(data.unopened_count)
end

--发送获取邮件详情请求
--mailIdInfo 邮件id信息
--返回值(无)
function MailsService:sendGetMailDetailsReq(mailId)
	local data = {
		mail_id = mailId,
	}
	dump(mailId)

	NetWorkMgr:getInstance():sendData("game.ReceiveMailPacket",data,MESSAGE_TYPE.P_CMD_C_RECEIVE_MAIL)
	MessageProp:apper()
	MyLog("发送获取邮件详情请求")
end

--收到邮件列表详情信息
--msg 消息
--返回值(无)
function MailsService:recvMailDeatailsResult(msg)
	MessageProp:dissmis()
	MyLog("收到邮件列表详情信息 msg.result=",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end

	local data = Protobuf.decode("game.ReceiveMailResultPacket", msg.data)
	MailsModel:getInstance():recvMailDetailsInfo(data)
end

--删除邮件请求
function MailsService:delMailReq(mailIds)
	local data = {
		mail_id = mailIds
	}
	dump(data)

	NetWorkMgr:getInstance():sendData("game.DeleteMailPacket",data,P_CMD_C_DELETE_MAIL)
	MessageProp:apper()
	MyLog("删除邮件请求")
end

--收到删除邮件结果
function MailsService:recvDelMailRes(msg)
	MessageProp:dissmis()
	MyLog("收到删除邮件结果 msg.result=",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end

	local data = Protobuf.decode("game.DeleteMailResult", msg.data)
	MailsModel:getInstance():recvDelMailRes(data)
end

--获取单例
--返回值(单例)
function MailsService:getInstance()
    if instance == nil then
        instance = MailsService.new()
    end
    return instance
end

MailsService:getInstance():init()

