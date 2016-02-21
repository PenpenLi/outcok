
--[[
    hejun
    加速建筑界面
--]]

BuildingAccelerationCommand = class("BuildingAccelerationCommand")
local instance = nil

--构造
--返回值(无)
function BuildingAccelerationCommand:ctor()

end

--uiType UI类型
--data 数据
--返回值(无)
function BuildingAccelerationCommand:open(uiType,data)
    self.view = BuildingAccelerationView.new(uiType,data)
    self.view:addToLayer(GAME_ZORDER.UI)
end

--关闭登录界面
--返回值(无)
function BuildingAccelerationCommand:close()
    if self.view ~= nil then
        self.view:removeFromLayer()
        self.view = nil
    end
end

--获取单例
--返回值(单例)
function BuildingAccelerationCommand:getInstance()
    if instance == nil then
        instance = BuildingAccelerationCommand.new()
    end
    return instance
end

--获取建筑位置
--返回值(建筑位置)
function BuildingAccelerationCommand:getBuildingPos()
    if self.view ~= nil then
        return self.view:getBuildingPos()
    end
end