
--[[
    hejun
    副本界面
--]]

CopyCommand = class("CopyCommand")
local instance = nil

--构造
--返回值(无)
function CopyCommand:ctor()

end

--打开副本界面
--uiType UI类型
--data 数据
--返回值(无)
function CopyCommand:open(uiType,data)
    self.view = CopyView.new(uiType,data)
    self.view:addToLayer(GAME_ZORDER.UI)
end 

--关闭集结界面
--返回值(无)
function CopyCommand:close()
    if self.view ~= nil then
        self.view:removeFromLayer()
        self.view = nil
    end
end

--获取单例
--返回值(单例)
function CopyCommand:getInstance()
    if instance == nil then
        instance = CopyCommand.new()
    end
    return instance
end

