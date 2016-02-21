
--[[
	jinyan.zhang
	世界地图坐标信息
--]]

WorldMapPosData = class("WorldMapPosData")
local instance = nil

--构造
--返回值(空)
function WorldMapPosData:ctor()
	self:init()
end

--初始化
--返回值(空)
function WorldMapPosData:init()
	self.mapPosInfo = {}
end

--计算世界分屏地图坐标信息(每屏的大小差不多是100*100，然后有12*12个这样的大小，再加上周围四个边要各留一格出来)
--返回值(空)
function WorldMapPosData:calWorldMapPos()
	local totalHigh = 0
	local maxRowCount = WorldMapTool:getMaxRow()
	local maxColCount = WorldMapTool:getMaxCol()
	for row=1,maxRowCount do
		local totalWide = 0
		for col=1,maxColCount do
			local mapSize = WorldMapTool:getMapSizeByRowAndCol(row,col)
			local mapPos = WorldMapTool:getCreateMapPos(row,col,totalHigh,totalWide)
			totalWide = totalWide + mapSize.width
			local mapInfo = {}
			mapInfo.pos = mapPos
			mapInfo.row = row
			mapInfo.col = col
			mapInfo.size = mapSize
			mapInfo.mapCtrol = CMapControl.new("")
			local rowCount,colCount = WorldMapTool:getRowCountAndColCount(row,col)
			mapInfo.rowCount = rowCount
			mapInfo.colCount = colCount
			mapInfo.resPath = WorldMapTool:getResPath(rowCount,colCount)
			mapInfo.srceenSize = Common:getScreenSize()
			local index = col
			if index == 1 then
				mapInfo.color = cc.c4b(255,0,0,50)
			elseif index == 2 then
				mapInfo.color = cc.c4b(255,255,0,50)
			elseif index == 3 then
				mapInfo.color = cc.c4b(255,255,255,50)
			elseif index == 4 then
				mapInfo.color = cc.c4b(255,0,255,50)
			elseif index == 5 then
				mapInfo.color = cc.c4b(0,0,0,50)
			elseif index == 6 then
				mapInfo.color = cc.c4b(0,255,0,50)
			elseif index == 7 then
				mapInfo.color = cc.c4b(0,255,255,50)
			elseif index == 8 then
				mapInfo.color = cc.c4b(0,0,255,50)
			elseif index == 9 then
				mapInfo.color = cc.c4b(255,193,193,50)
			elseif index == 10 then
				mapInfo.color = cc.c4b(245,245,220,50)
			elseif index == 11 then
				mapInfo.color = cc.c4b(0,191,225,50)
			elseif index == 12 then
				mapInfo.color = cc.c4b(47,79,79,50)
			else
				mapInfo.color = cc.c4b(100,200,100,50)
			end
			table.insert(self.mapPosInfo,mapInfo)
			if (row == 2 and col == 1) or (row==2 and col == 2) then
				--print("mapInfo.pos x=",mapInfo.pos.x,"y=",mapInfo.pos.y,"row=",row,"col=",col,"size high=",mapSize.height)
			end
		end
		local high = WorldMapTool:getMapSizeByRowAndCol(row,1).height
		totalHigh = totalHigh + high - 24
	end
	--DivTool:getInstance():calDivMap()
end

--获取地图信息
--row 第几行
--col 第几列
--返回值(地图信息)
function WorldMapPosData:getWorldMapInfo(row,col)
	for k,v in pairs(self.mapPosInfo) do
		if v.row == row and v.col == col then
			return v
		end
	end
end

--获取地图信息
--返回值(地图信息)
function WorldMapPosData:getAllWorldMapInfo()
	return self.mapPosInfo
end

--获取单例
--返回值(单例)
function WorldMapPosData:getInstance()
	if instance == nil then
		instance = WorldMapPosData.new()
	end
	return instance
end

