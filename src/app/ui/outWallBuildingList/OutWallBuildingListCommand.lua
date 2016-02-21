--[[
    hejun
    城墙外建筑列表
--]]

OutWallBuildingListCommand = class("OutWallBuildingListCommand")
local instance = nil

--构造
--返回值(无)
function OutWallBuildingListCommand:ctor()

end

--打开城内UI
--uiType UI类型
--data 数据
--返回值(无)
function OutWallBuildingListCommand:open(uiType,data)
    self.view = OutWallBuildingListView.new(uiType,data)
    self.view:addToLayer(GAME_ZORDER.UI)
end

--关闭城内UI
function OutWallBuildingListCommand:close()
    if self.view ~= nil then
        self.view:removeFromLayer()
        self.view = nil
    end
end

--获取单例
--返回值(单例)
function OutWallBuildingListCommand:getInstance()
    if instance == nil then
        instance = OutWallBuildingListCommand.new()
    end
    return instance
end

