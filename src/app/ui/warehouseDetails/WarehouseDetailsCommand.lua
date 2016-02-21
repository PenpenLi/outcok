
--[[
    hejun
    仓库详情界面
--]]

WarehouseDetailsCommand = class("WarehouseDetailsCommand")
local instance = nil

--构造
--返回值(无)
function WarehouseDetailsCommand:ctor()

end

--uiType UI类型
--data 数据
--返回值(无)
function WarehouseDetailsCommand:open(uiType,data)
    self.view = WarehouseDetailsView.new(uiType,data)
    self.view:addToLayer(GAME_ZORDER.UI)
end

--关闭登录界面
--返回值(无)
function WarehouseDetailsCommand:close()
    if self.view ~= nil then
        self.view:removeFromLayer()
        self.view = nil
    end
end

--获取单例
--返回值(单例)
function WarehouseDetailsCommand:getInstance()
    if instance == nil then
        instance = WarehouseDetailsCommand.new()
    end
    return instance
end

--获取建筑位置
--返回值(建筑位置)
function WarehouseDetailsCommand:getBuildingPos()
    if self.view ~= nil then
        return self.view:getBuildingPos()
    end
end

