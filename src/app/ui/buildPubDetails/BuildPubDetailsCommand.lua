
--[[
    hejun
    酒吧详情界面
--]]

BuildPubDetailsCommand = class("BuildPubDetailsCommand")
local instance = nil

--构造
--返回值(无)
function BuildPubDetailsCommand:ctor()

end

--uiType UI类型
--data 数据
--返回值(无)
function BuildPubDetailsCommand:open(uiType,data)
    self.view = BuildPubDetailsView.new(uiType,data)
    self.view:addToLayer(GAME_ZORDER.UI)
end

--关闭登录界面
--返回值(无)
function BuildPubDetailsCommand:close()
    if self.view ~= nil then
        self.view:removeFromLayer()
        self.view = nil
    end
end

--获取单例
--返回值(单例)
function BuildPubDetailsCommand:getInstance()
    if instance == nil then
        instance = BuildPubDetailsCommand.new()
    end
    return instance
end

--获取建筑位置
--返回值(建筑位置)
function BuildPubDetailsCommand:getBuildingPos()
    if self.view ~= nil then
        return self.view:getBuildingPos()
    end
end

