
--[[
    jinyan.zhang
    迁城
--]]

MoveCastleAniCommand = class("MoveCastleAniCommand")
local instance = nil

--构造
--返回值(无)
function MoveCastleAniCommand:ctor()
    
end

--打开界面
--uiType UI类型
--data 数据
--返回值(无)
function MoveCastleAniCommand:open(uiType,data)
    self.view = MoveCastleAniView.new(uiType,data)
    self.view:addToLayer(GAME_ZORDER.UI)
end 

--关闭集结界面
--返回值(无)
function MoveCastleAniCommand:close()
    if self.view ~= nil then
        self.view:removeFromLayer()
        self.view = nil
    end
end

--获取单例
--返回值(单例)
function MoveCastleAniCommand:getInstance()
    if instance == nil then
        instance = MoveCastleAniCommand.new()
    end
    return instance
end



