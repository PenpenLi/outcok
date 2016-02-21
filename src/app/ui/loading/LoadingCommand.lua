
--[[
	jinyan.zhang
	加载进度条界面
--]]

LoadingCommand = class("LoadingCommand")
local instance = nil

--加载的loading类型
LoadingType =
{
	LOGIN = 0, 	 --登录
	GOTO_BATTLE = 1, --进入战斗
	ENTER_WORLD_MAP = 2, --进入世界地图
	ENTER_CITY = 3, --进入主界面
	FROM_PVP_ENTER_CITY = 4, --从PVP界面进入主界面
	ENTER_COPY = 5, 		--进入副本
	FROM_COPY_ENTER_CITY = 6, --从副本进入主城
	FROM_PVP_ENTER_WORLD = 7, --从PVP进入世界地图
}

--构造
--返回值(空)
function LoadingCommand:ctor()

end

--打开loading界面
--uiType UI类型
--data 数据
--返回值(无)
function LoadingCommand:open(uiType,data)
	self.view = LoadingView.new(uiType,data)
	self.view:addToLayer(GAME_ZORDER.UI)
end 

--关闭Loading界面
--返回值(无)
function LoadingCommand:close()
	if self.view ~= nil then
		self.view:removeFromLayer()
		self.view = nil
	end
end

--获取单例
--返回值(单例)
function LoadingCommand:getInstance()
	if instance == nil then
		instance = LoadingCommand.new()
	end
	return instance
end

--加载消息进度
function LoadingCommand:loadMsgProcess()
	if self.view ~= nil then
		self.view:loadResProcess()
	end
end

--设置加载文本
function LoadingCommand:loadText(text)
 	if self.view ~= nil then
		self.view:setLoadText(text)
	end
end 


