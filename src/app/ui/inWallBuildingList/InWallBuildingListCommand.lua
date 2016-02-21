
--[[
	hechun
	城内建筑列表
--]]

InWallBuildingListCommand = class("InWallBuildingListCommand")
local instance = nil--城内空地建筑列表

--构造
--返回值(无)
function InWallBuildingListCommand:ctor()

end

--打开建筑列表界面
--uiType UI类型
--data 数据
--返回值(无)
function InWallBuildingListCommand:open(uiType,data)
	self.view = InWallBuildingListView.new(uiType,data)
	self.view:addToLayer(GAME_ZORDER.UI)
end 

--关闭建筑列表界面
--返回值(无)
function InWallBuildingListCommand:close()
	if self.view ~= nil then
		self.view:removeFromLayer()
		self.view = nil
	end
end

--获取单例
--返回值(单例)
function InWallBuildingListCommand:getInstance()
	if instance == nil then
		instance = InWallBuildingListCommand.new()
	end
	return instance
end

--获取城内空地个数
--返回值（空地个数）
function InWallBuildingListCommand:getEmbtyFloorCount()
    local count = 0
    local emptyList = BuildingTypeConfig:getInstance():getInWallEmptyList()
    for i=1,#emptyList do
        if not CityBuildingModel:getInstance():isHaveCreateBuilding(emptyList[i].buildType) then
            count = count + 1
        end
    end
    return count
end


