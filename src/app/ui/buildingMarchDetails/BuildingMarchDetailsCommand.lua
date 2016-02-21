
--[[
    hejun
    行军帐篷详情界面
--]]

BuildingMarchDetailsCommand = class("BuildingMarchDetailsCommand")
local instance = nil

--构造
--返回值(无)
function BuildingMarchDetailsCommand:ctor()

end

--uiType UI类型
--data 数据
--返回值(无)
function BuildingMarchDetailsCommand:open(uiType,data)
    self.view = BuildingMarchDetailsView.new(uiType,data)
    self.view:addToLayer(GAME_ZORDER.UI)
end

--关闭登录界面
--返回值(无)
function BuildingMarchDetailsCommand:close()
    if self.view ~= nil then
        self.view:removeFromLayer()
        self.view = nil
    end
end

--获取单例
--返回值(单例)
function BuildingMarchDetailsCommand:getInstance()
    if instance == nil then
        instance = BuildingMarchDetailsCommand.new()
    end
    return instance
end

--获取建筑位置
--返回值(建筑位置)
function BuildingMarchDetailsCommand:getBuildingPos()
    if self.view ~= nil then
        return self.view:getBuildingPos()
    end
end

