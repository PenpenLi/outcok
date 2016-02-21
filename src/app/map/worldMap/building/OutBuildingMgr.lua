
--[[
	jinyan.zhang
	野外建筑管理器
--]]

OutBuildingMgr = class("OutBuildingMgr")

local instance = nil

--获取单例
--返回值(单例)
function OutBuildingMgr:getInstance()
    if instance == nil then
        instance = OutBuildingMgr.new()
    end
    return instance
end

function OutBuildingMgr:ctor()
	self:init()
end

function OutBuildingMgr:init()
	self.arry = {}
end

function OutBuildingMgr:getData()
	return self.arry
end

--清理缓存数据
--返回值(无)
function OutBuildingMgr:clearCache()
	self:init()
end

function OutBuildingMgr:create(buildingType,level,gridPos,instanceId,placeId)
   self.imgBuilding = MMUIOutBuildingView.new(buildingType,level)
   local girdCount = BuildingTypeConfig:getInstance():getConfigInfo(buildingType).bt_wildmaphold 
   self.imgBuilding:setGridCount(girdCount)
   local resPath = BuildingUpLvConfig:getInstance():getBuildingResPath2(buildingType,level)
   self.imgBuilding:setSpritePath(resPath)
   self.imgBuilding:calPosByGridPos(gridPos)
   self.imgBuilding:create()
   self.imgBuilding:setInstanceId(instanceId)
   self.imgBuilding:setPlaceId(placeId)
   local worldMap = MapMgr:getInstance():getWorldMap()
   worldMap:getBgMap():addChild(self.imgBuilding,10)
   local info = {}
   info.gridPos = gridPos
   info.img = self.imgBuilding
   info.instanceId = instanceId
   table.insert(self.arry,info)
end

--是否点击在建筑上
function OutBuildingMgr:isClickBuilding(clickPos)
	local arry = OutPlaceBuildingData:getInstance():getList()
  for k,v in pairs(self.arry) do
      v.img:hideBlankImg()
  end

	for k,v in pairs(arry) do
		if v.x == clickPos.x and v.y == clickPos.y then
      for k,v in pairs(self.arry) do
         if v.gridPos.x == clickPos.x and v.gridPos.y == clickPos.y then
            v.img:showBlankImg()
         end
      end
			return true
		end
	end
	return false
end

--删除野外建筑图片通过实例ID
function OutBuildingMgr:delBuildingImgById(instanceId)
  for k,v in pairs(self.arry) do
     if v.instanceId.id_h == instanceId.id_h and v.instanceId.id_l == instanceId.id_l then
        v.img:removeFromParent()
        self.arry[k] = nil
        break
     end
  end
end



