
--[[
	拖拽建筑管理器
	jinyan.zhang
--]]

DrapBuildingMgr = class("DrapBuildingMgr")

local instance = nil

function DrapBuildingMgr:ctor()
	self:init()
end

function DrapBuildingMgr:init()
	self.imgDragBuilding = nil
end

--获取单例
--返回值(单例)
function DrapBuildingMgr:getInstance()
    if instance == nil then
        instance = DrapBuildingMgr.new()
    end
    return instance
end

--创建拖拽建筑
function DrapBuildingMgr:createImg(buildingType,level,arryId)
   self.buildingType = buildingType
   self.arryId = arryId
   self.imgDragBuilding = MMUIDrapBuilding.new(buildingType)
   local girdCount = BuildingTypeConfig:getInstance():getConfigInfo(buildingType).bt_wildmaphold 
   self.imgDragBuilding:setGridCount(girdCount)
   local resPath = BuildingUpLvConfig:getInstance():getBuildingResPath2(buildingType,level)
   self.imgDragBuilding:setSpritePath(resPath)
   local gridPos = self:calImgGridPos(girdCount)
   self.imgDragBuilding:calPosByGridPos(gridPos)
   self.imgDragBuilding:create()
   self.imgDragBuilding:setSureCallback(self.onSure,self)
   self.imgDragBuilding:setCancelCallback(self.onCancel,self)
   local worldMap = MapMgr:getInstance():getWorldMap()
   worldMap:getBgMap():addChild(self.imgDragBuilding,10)
   local pos = worldMap:worldGridPosToScreenPos(gridPos)
   worldMap:goToPos(pos)
end

--计算建筑图片位置
function DrapBuildingMgr:calImgGridPos(girdCount)
   local x,y = PlayerData:getInstance():getCastlePos()
   local info = CityBuildingModel:getInstance():getBuildInfoByType(BuildType.castle)
   local viewRange = CastleEffectConfig:getInstance():getRangeByLevel(1)
   self.left = x - viewRange
   self.right = x + viewRange
   self.up = y + viewRange
   self.down = y - viewRange
   if self.left < 0 then
      self.left = 0
   end
   if self.right > 1199 then
      self.right = 1199
   end
   if self.up > 1199 then
      self.up = 1199
   end
   if self.down < 0 then
      self.down = 0
   end
   self.imgDragBuilding:setEdage(self.left,self.right,self.up,self.down)

   for col=self.left,self.right do
      for row=self.down,self.up do
         local gridPos = cc.p(row,col)
         if not CheckObstacle:getInstance():isHaveBlock(gridPos) then
            return gridPos
         end
      end
   end

   return cc.p(self.left,self.up)
end

--确定放置回调
function DrapBuildingMgr:onSure()
  local id = self.arryId[1]
  local arryGridPos = self.imgDragBuilding:getGridPos()
  local pos = arryGridPos[1]
	PlaceBuildingService:getInstance():placeBuildingsReq(id,pos.x,pos.y)
end

--取消放置回调
function DrapBuildingMgr:onCancel()
  self:delImg()
end

function DrapBuildingMgr:delImg()
    if self.imgDragBuilding ~= nil then
      self.imgDragBuilding:removeFromParent()
      self.imgDragBuilding = nil
    end
end



