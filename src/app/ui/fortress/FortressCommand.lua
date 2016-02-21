
--[[
    jinyan.zhang
    副本界面
--]]

FortressCommand = class("FortressCommand")
local instance = nil

--构造
--返回值(无)
function FortressCommand:ctor()

end

--打开界面
--uiType UI类型
--data 数据
--返回值(无)
function FortressCommand:open(uiType,data)
    self.view = FortressView.new(uiType,data)
    self.view:addToLayer(GAME_ZORDER.UI)
end 

--关闭集结界面
--返回值(无)
function FortressCommand:close()
    if self.view ~= nil then
        self.view:removeFromLayer()
        self.view = nil
    end
end

--获取单例
--返回值(单例)
function FortressCommand:getInstance()
    if instance == nil then
        instance = FortressCommand.new()
    end
    return instance
end

