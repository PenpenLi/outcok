
--[[
	jinyan.zhang
	解锁区域消息处理
--]]

UnLockAreaService = class("UnLockAreaService")

local instance = nil

local P_CMD_C_UNLOCK_AREA = 83 --解锁土地区域 

--初始化
--返回值(无)
function UnLockAreaService:initialize()
	NetMsgMgr:getInstance():registerMsg(P_CMD_C_UNLOCK_AREA, self, self.unLockAreaRes)
end

--获取单例
--返回值(单例)
function UnLockAreaService:getInstance()
    if instance == nil then
        instance = UnLockAreaService.new()
    end
    return instance
end

--解锁区域请求
--返回值(无)
function UnLockAreaService:sndUnLockAreaReq(areaId)
	local data = {
		areaId = areaId
	}
	NetWorkMgr:getInstance():sendData("game.UnlockAreaPacket",data,P_CMD_C_UNLOCK_AREA)
	MessageProp:apper()
	MyLog("发送解锁区域请求 areaId=",areaId)
end

--收到解锁区域结果
--msg 数据包
--返回值(无)
function UnLockAreaService:unLockAreaRes(msg)
	MessageProp:dissmis()
	MyLog("解锁区域结果 result=",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end

	local data = Protobuf.decode("game.UnlockAreaPacket", msg.data)
	UnLockAreaModel:getInstance():setUnLockIndex(data)
end

UnLockAreaService:getInstance():initialize()

