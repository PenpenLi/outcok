
--[[
	jinyan.zhang
	登录界面
--]]

LoginCommand = class("LoginCommand")
local instance = nil

--构造
--返回值(无)
function LoginCommand:ctor()

end

--uiType UI类型
--data 数据
--返回值(无)
function LoginCommand:open(uiType,data)
	self.view = LoginView.new(uiType,data)
	self.view:addToLayer(GAME_ZORDER.UI)
end 

--关闭登录界面
--返回值(无)
function LoginCommand:close()
	if self.view ~= nil then
		self.view:removeFromLayer()
		self.view = nil
	end
end

--获取单例
--返回值(单例)
function LoginCommand:getInstance()
	if instance == nil then
		instance = LoginCommand.new()
	end
	return instance
end


