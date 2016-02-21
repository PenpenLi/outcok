
--[[
	jinyan.zhang
	侦察界面
--]]

LookCommand = class("LookCommand")
local instance = nil

--构造
--返回值(无)
function LookCommand:ctor()
    
end

--uiType UI类型
--data 数据
--返回值(无)
function LookCommand:open(uiType,data)
    self.view = LookView.new(uiType,data)
    self.view:addToLayer(GAME_ZORDER.UI)
end 

--关闭登录界面
--返回值(无)
function LookCommand:close()
    if self.view ~= nil then
        self.view:removeFromLayer()
        self.view = nil
    end
end

--获取单例
--返回值(单例)
function LookCommand:getInstance()
    if instance == nil then
        instance = LookCommand.new()
    end
    return instance
end


