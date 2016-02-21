
--[[
	jinyan.zhang
	弹出框数据
--]]

PropBoxModel = class("PropBoxModel")
local instance = nil

--构造
--返回值(无)
function PropBoxModel:ctor()
	self:init()
end

--初始化
--返回值(空)
function PropBoxModel:init()

end

--获取单例
--返回值(单例)
function PropBoxModel:getInstance()
	if instance == nil then
		instance = PropBoxModel.new()
	end
	return instance
end


