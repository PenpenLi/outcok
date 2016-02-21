
--[[
    hejun
    资源详情界面
--]]

BuildingResDetailsCommand = class("BuildingResDetailsCommand")
local instance = nil

--构造
--返回值(无)
function BuildingResDetailsCommand:ctor()

end

--uiType UI类型
--data 数据
--返回值(无)
function BuildingResDetailsCommand:open(uiType,data)
    self.view = BuildingResDetailsView.new(uiType,data)
    self.view:addToLayer(GAME_ZORDER.UI)
end

--关闭登录界面
--返回值(无)
function BuildingResDetailsCommand:close()
    if self.view ~= nil then
        self.view:removeFromLayer()
        self.view = nil
    end
end

--获取单例
--返回值(单例)
function BuildingResDetailsCommand:getInstance()
    if instance == nil then
        instance = BuildingResDetailsCommand.new()
    end
    return instance
end

--获取建筑位置
--返回值(建筑位置)
function BuildingResDetailsCommand:getBuildingPos()
    if self.view ~= nil then
        return self.view:getBuildingPos()
    end
end

