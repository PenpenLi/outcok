
--[[
	jinyan.zhang
	更新包处理
--]]

Update = class("Update")
local instance = nil

function Update:ctor()
	self:init()
end

function Update:init()

end

function Update:getInstance()
	if instance == nil then
		instance = Update.new()
	end
	return instance
end 