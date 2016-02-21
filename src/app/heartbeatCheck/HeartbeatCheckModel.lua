
--[[
	jinyan.zhang
	心跳包数据
--]]

HeartbeatCheckModel = class("HeartbeatCheckModel")
local instance = nil

--构造
--返回值(无)
function HeartbeatCheckModel:ctor()
	self:init()
end

--初始化
--返回值(空)
function HeartbeatCheckModel:init()
	self.isHaveRecv = false
end

--获取单例
--返回值(单例)
function HeartbeatCheckModel:getInstance()
	if instance == nil then
		instance = HeartbeatCheckModel.new()
	end
	return instance
end

--设置收到数据标志
--返回值(无)
function HeartbeatCheckModel:setData()
	self.isHaveRecv = true
end

--置空收到数据标志
--返回值(无)
function HeartbeatCheckModel:clearData()
	self.isHaveRecv = false
end

--是否收到心跳包数据
--返回值(true:是,false:否)
function HeartbeatCheckModel:isHaveRecvData()
	return self.isHaveRecv 
end


