
--[[
	jinyan.zhang
	logo界面
--]]

LogoCommand = class("LogoCommand")
 local instance = nil

--构造
--返回值(无)
function LogoCommand:ctor()
	
end

--打开logo界面
--uiType UI类型
--data 数据
--返回值(无)
function LogoCommand:open(uiType,data)
	self.view = LogoView.new(uiType,data)
	self.view:addToLayer(GAME_ZORDER.UI)
end 

--关闭logo界面
--返回值(无)
function LogoCommand:close()
	if self.view ~= nil then
		self.view:removeFromLayer()
		self.view = nil
	end
end

--获取单例
--返回值(单例)
function LogoCommand:getInstance()
	if instance == nil then
		instance = LogoCommand.new()
	end
	return instance
end


