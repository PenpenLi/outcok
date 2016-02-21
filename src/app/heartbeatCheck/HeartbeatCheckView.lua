
--[[
	jinyan.zhang
	心跳包检测
--]]

HeartbeatCheckView = class("HeartbeatCheckView")

--构造
--返回值(无)
function HeartbeatCheckView:ctor()
	self:init()
end

--初始化
--返回值(无)
function HeartbeatCheckView:init() 
	self.sendTime = 0
	self.recvTime = 0
end

--打开发送心跳包定时器
--返回值(无)
function HeartbeatCheckView:openSendHeartbeatTime()
	local timeInfo = TimeMgr:getInstance():findTypeInfoByIndex(TimeType.SendHeartbeatTime,1,1)
    if not timeInfo then
        local info = {}
        info.index = 1
        TimeMgr:getInstance():addInfo(TimeType.SendHeartbeatTime, info, 1,self.sendHeartbeatTime, self)
    else
        timeInfo.pause = false
    end
    self.sendTime = 0
end

--停止发送心跳包定时器
--返回值(无)
function HeartbeatCheckView:stopSendHeartbeatTime()
	local timeInfo = TimeMgr:getInstance():findTypeInfoByIndex(TimeType.SendHeartbeatTime,1,1)
	if timeInfo ~= nil then
		TimeMgr:getInstance():removeTypeInfoByIndex(TimeType.SendHeartbeatTime,1,1)
	end
	self.sendTime = 0
end

--暂停发送心跑包定时器
--返回值(无)
function HeartbeatCheckView:pauseSendHeartbeatTime()
	local timeInfo = TimeMgr:getInstance():findTypeInfoByIndex(TimeType.SendHeartbeatTime,1,1)
	if timeInfo ~= nil then
		timeInfo.pause = true
	end
end

--恢复发送心跑包定时器
--返回值(无)
function HeartbeatCheckView:resumeSendHeartbeatTime()
	local timeInfo = TimeMgr:getInstance():findTypeInfoByIndex(TimeType.SendHeartbeatTime,1,1)
	if timeInfo ~= nil then
		timeInfo.pause = false
	else
		self:openSendHeartbeatTime()
	end
	self.sendTime = 0
end

--发送心跳包定时器
--info 信息
--返回值(无)
function HeartbeatCheckView:sendHeartbeatTime(info)
	self.sendTime = self.sendTime + 1
	if self.sendTime >= 4 then
		self.sendTime = 0
		self:pauseSendHeartbeatTime()
		HeartbeatCheckService:sendHeartbeatReq()
		self:resumeRecvHeartbeatTime()
	end
end

--打开接收心跳包定时器
--返回值(无)
function HeartbeatCheckView:openRecvHeartbeatTime()
	local timeInfo = TimeMgr:getInstance():findTypeInfoByIndex(TimeType.RecvHeartbeatTime,1,1)
    if not timeInfo then
        local info = {}
        info.index = 1
        TimeMgr:getInstance():addInfo(TimeType.RecvHeartbeatTime, info, 1,self.recvHeartbeatTime, self)
    else
        timeInfo.pause = false
    end
    self.recvTime = 0
end 

--停止接收心跳包定时器
--返回值(无)
function HeartbeatCheckView:stopRecvHeartbeatTime()
	local timeInfo = TimeMgr:getInstance():findTypeInfoByIndex(TimeType.RecvHeartbeatTime,1,1)
	if timeInfo ~= nil then
		TimeMgr:getInstance():removeTypeInfoByIndex(TimeType.RecvHeartbeatTime,1,1)
	end
	self.recvTime = 0
end

--暂停接收心跑包定时器
--返回值(无)
function HeartbeatCheckView:pauseRecvHeartbeatTime()
	local timeInfo = TimeMgr:getInstance():findTypeInfoByIndex(TimeType.RecvHeartbeatTime,1,1)
	if timeInfo ~= nil then
		timeInfo.pause = true
	end
end

--恢复接收心跑包定时器
--返回值(无)
function HeartbeatCheckView:resumeRecvHeartbeatTime()
	local timeInfo = TimeMgr:getInstance():findTypeInfoByIndex(TimeType.RecvHeartbeatTime,1,1)
	if timeInfo ~= nil then
		timeInfo.pause = false
	else
		self:openRecvHeartbeatTime()
	end
	self.recvTime = 0
end

--接收心跳包定时器
--info 信息
--返回值(无)
function HeartbeatCheckView:recvHeartbeatTime(info)
	self.recvTime = self.recvTime + 1
	if self.recvTime >= 10 then
		self.recvTime = 0
		self:pauseRecvHeartbeatTime()
		if HeartbeatCheckModel:getInstance():isHaveRecvData() then
			self:resumeSendHeartbeatTime()
		else
			UIMgr:getInstance():openUI(UITYPE.PROP_BOX, {type=PROP_BOX_TYPE.DIS_CONNECT,text=CommonStr.DIS_CONNECT,
				callback=handler(self, self.againConnectServer)})
		end
	end
end

--断线重连
function HeartbeatCheckView:againConnectServer()
	CacheDataMgr:getInstance():clearCache()
	SceneMgr:getInstance():goToLoginScene()
end


