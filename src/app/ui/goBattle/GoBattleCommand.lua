
--[[
    hejun
    出征界面
--]]

GoBattleCommand = class("GoBattleCommand")
local instance = nil

--构造
--返回值(无)
function GoBattleCommand:ctor()

end

--打开出征界面
--uiType UI类型
--data 数据
--返回值(无)
function GoBattleCommand:open(uiType,data)
    self.view = GoBattleView.new(uiType,data)
    self.view:addToLayer(GAME_ZORDER.UI)
end 

--关闭出征界面
--返回值(无)
function GoBattleCommand:close()
    if self.view ~= nil then
        self.view:removeFromLayer()
        self.view = nil
    end
end

--获取单例
--返回值(单例)
function GoBattleCommand:getInstance()
    if instance == nil then
        instance = GoBattleCommand.new()
    end
    return instance
end

