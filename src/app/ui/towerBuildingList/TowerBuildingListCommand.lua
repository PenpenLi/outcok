
--[[
    hechun
    防御塔列表
--]]

TowerBuildingListCommand = class("TowerBuildingListCommand")
local instance = nil--城内空地建筑列表

--构造
--返回值(无)
function TowerBuildingListCommand:ctor()

end

--打开建筑列表界面
--uiType UI类型
--data 数据
--返回值(无)
function TowerBuildingListCommand:open(uiType,data)
    self.view = TowerBuildingListView.new(uiType,data)
    self.view:addToLayer(GAME_ZORDER.UI)
end

--关闭建筑列表界面
--返回值(无)
function TowerBuildingListCommand:close()
    if self.view ~= nil then
        self.view:removeFromLayer()
        self.view = nil
    end
end

--获取单例
--返回值(单例)
function TowerBuildingListCommand:getInstance()
    if instance == nil then
        instance = TowerBuildingListCommand.new()
    end
    return instance
end

--获取城内空地个数
--返回值（空地个数）
function TowerBuildingListCommand:getEmbtyFloorCount()
    local total = 0
    local emptyList = BuildingTypeConfig:getInstance():getDefTowerList()
    for i=1,#emptyList do
        local count = CityBuildingModel:getInstance():getHaveCreatBuildingCountByType(emptyList[i].buildType)
        total = total + count
    end
    return #emptyList - total
end


