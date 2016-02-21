
--[[
    hejun
    城堡信息界面
--]]

CastleInformationCommand = class("CastleInformationCommand")
local instance = nil

--构造
--返回值(无)
function CastleInformationCommand:ctor()

end

--打开界面
--uiType UI类型
--data 数据
--返回值(无)
function CastleInformationCommand:open(uiType,data)
    self.view = CastleInformationView.new(uiType,data)
    self.view:addToLayer(GAME_ZORDER.UI)
end

--关闭界面
--返回值(无)
function CastleInformationCommand:close()
    if self.view ~= nil then
        self.view:removeFromLayer()
        self.view = nil
    end
end

--获取单例
--返回值(单例)
function CastleInformationCommand:getInstance()
    if instance == nil then
        instance = CastleInformationCommand.new()
    end
    return instance
end