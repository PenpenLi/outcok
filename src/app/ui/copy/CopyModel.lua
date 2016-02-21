
--[[
	jinyan.zhang
	保存副本数据
--]]

CopyModel = class("CopyModel")
local instance = nil

--关卡状态
checkpointState = 
{
	unActive = 0,  --未激活
	active = 1,    --已经激活
}

--构造
--返回值(无)
function CopyModel:ctor()
	self:init()
end

--初始化
--返回值(空)
function CopyModel:init()
	self.passCount = 0
end

--获取单例
--返回值(单例)
function CopyModel:getInstance()
	if instance == nil then
		instance = CopyModel.new()
	end
	return instance
end

--清理缓存数据
--返回值(无)
function CopyModel:clearCache()
	self:init()
end

--设置副本数据
--data 数据
--返回值(无)
function CopyModel:setData(data)
	self.passCount = data
end

--增加通关数
--curPassIndex 当前通关副本下标
--返回值(无)
function CopyModel:updatePassCount(curPassIndex)
	if curPassIndex > self.passCount then
		self.passCount = self.passCount + 1
	end
end

--获取通关数
--返回值(通关数)
function CopyModel:getPassCount()
	return self.passCount
end


