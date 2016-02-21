
--[[
    hejun
    急救帐篷详情界面
--]]

BuildingAidDetailsCommand = class("BuildingAidDetailsCommand")
local instance = nil

--构造
--返回值(无)
function BuildingAidDetailsCommand:ctor()

end

--uiType UI类型
--data 数据
--返回值(无)
function BuildingAidDetailsCommand:open(uiType,data)
    self.view = BuildingAidDetailsView.new(uiType,data)
    self.view:addToLayer(GAME_ZORDER.UI)
end

--关闭登录界面
--返回值(无)
function BuildingAidDetailsCommand:close()
    if self.view ~= nil then
        self.view:removeFromLayer()
        self.view = nil
    end
end

--获取单例
--返回值(单例)
function BuildingAidDetailsCommand:getInstance()
    if instance == nil then
        instance = BuildingAidDetailsCommand.new()
    end
    return instance
end

--获取建筑位置
--返回值(建筑位置)
function BuildingAidDetailsCommand:getBuildingPos()
    if self.view ~= nil then
        return self.view:getBuildingPos()
    end
end

