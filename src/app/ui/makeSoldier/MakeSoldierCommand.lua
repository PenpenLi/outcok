
--[[
    hejun
    训练界面
--]]

MakeSoldierCommand = class("MakeSoldierCommand")
local instance = nil

--构造
--返回值(无)
function MakeSoldierCommand:ctor()

end

--打开训练界面
--uiType UI类型
--data 数据
--返回值(无)
function MakeSoldierCommand:open(uiType,data)
    self.view = MakeSoldierView.new(uiType,data)
    self.view:addToLayer(GAME_ZORDER.UI)
end 

--关闭训练界面
--返回值(无)
function MakeSoldierCommand:close()
    if self.view ~= nil then
        self.view:removeFromLayer()
        self.view = nil
    end
end

--获取单例
--返回值(单例)
function MakeSoldierCommand:getInstance()
    if instance == nil then
        instance = MakeSoldierCommand.new()
    end
    return instance
end

