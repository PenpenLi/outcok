
--[[
    jinyan.zhang
    心跳包
--]]

HeartbeatCheckCommand = class("HeartbeatCheckCommand")
local instance = nil

--构造
--返回值(无)
function HeartbeatCheckCommand:ctor()
	self.view = HeartbeatCheckView.new()
end

--获取单例
--返回值(单例)
function HeartbeatCheckCommand:getInstance()
    if instance == nil then
        instance = HeartbeatCheckCommand.new()
    end
    return instance
end

--打开心跳包检测
--返回值(无)
function HeartbeatCheckCommand:openHeartbeatCheck()
	self:closeHeartbeatCheck()
	self.view:openSendHeartbeatTime()
end

--关闭心跳包检测
--返回值(无)
function HeartbeatCheckCommand:closeHeartbeatCheck()
    if self.view ~= nil then
        self.view:stopSendHeartbeatTime()
        self.view:stopRecvHeartbeatTime()
    end
end




