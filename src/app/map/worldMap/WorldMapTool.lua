
--[[
	jinayn.zhang
	城外世界地图工具类，主要用来计算分屏
--]]

WorldMapTool = class("WorldMapTool",function()
	return display.newLayer()
end)

local _offsetY = nil

--构造
--worldMap 城外地图
--返回值(无)
function WorldMapTool:ctor(worldMap)
	self.worldMap = worldMap
	self:init()
end

--获取世界地图放大倍数
--返回值(世界地图放大倍数)
function WorldMapTool:getMapScale()
	return self.worldMap:getMapScale()
end

--设置世界地图放大倍数
--scale 放大倍数
--返回值(无)
function WorldMapTool:setMapScale(scale)
	self.worldMap:setMapScale(scale)
end

--获取背景地图大小
--返回值(大地图大小)
function WorldMapTool:getBgMapSize()
	return self.worldMap:getBgMapSize()
end

--初始化
--返回值(无)
function WorldMapTool:init()
	self.mapInfo = {}
end

--保存世界地图父结点
--bgMap 世界地图父结点
--返回值(无)
function WorldMapTool:setBgMap(bgMap)
	self.bgMap = bgMap
end

--获取地图格子数
--返回值(地图格子数)
function WorldMapTool:getMapTiledCount()
	return 1200,1201
end

--获取正常行数
--返回值(地图正常行数)
function WorldMapTool:getNorRowCount()
	return 100
end

--获取正常列数
--返回值(地图正常列数)
function WorldMapTool:getNorColCount()
	return 100
end

--获取最大列(1200*1200块地图划分成12个区,每个区的大小是100*100)
--返回值(地图最大列数)
function WorldMapTool:getMaxCol()
	return 12
end

--获取最大行
--返回值(地图最大行数)
function WorldMapTool:getMaxRow()
	return 12
end

--获取最大行数
--返回值(地图最大行数)
function WorldMapTool:getMaxRowCount()
	return 102
end

--获取最大列数
--返回值(地图最大列数)
function WorldMapTool:getMaxColCount()
	return 102
end

--获取地图单元格宽度
--mapCtrol 地图控制器 
--返回值(单元格宽度)
function WorldMapTool:getTileWidth(mapCtrol)
	if self.tiledWide == nil then
		self.tiledWide = 150
		--self.tiledWide = mapCtrol:getTileWidth()
	end
	return self.tiledWide
end

--获取地图单元格高度
--mapCtrol 地图控制器 
--返回值(单元格高度)
function WorldMapTool:getTileHeight(mapCtrol)
	if self.tiledHigh == nil then
		self.tiledHigh = 100
		--self.tiledHigh = mapCtrol:getTileHeight()
	end
	return self.tiledHigh 
end

--获取地图单元格斜边高度
--mapCtrol 地图控制器 
--返回值(单元格斜边高度)
function WorldMapTool:getTileHypotenuseHeight(mapCtrol)
	if self.xiegao == nil then
		self.xiegao = 25
		--self.xiegao = mapCtrol:getTileHypotenuseHeight()
	end
	return self.xiegao
end

--获取超出的高度(有两个格子超出了,104格,100格是正常的,2格在底下看不到,还有两格可以看到,这两格和UI重在一起,所以要多出这两格,
	--原先是102格就够了)
function WorldMapTool:getOverHigh()
	local overCount = 2
	return (self:getTileHeight()-self:getTileHypotenuseHeight())*overCount
end

--获取地图Y轴单元格数量
--mapCtrol 地图控制器 
--返回值(单元格Y轴数量)
function WorldMapTool:getTilesHeightCount(mapCtrol)
	return mapCtrol:getTilesHeightCount()
end

--获取地图X轴单元格数量
--mapCtrol 地图控制器 
--返回值(单元格X轴数量)
function WorldMapTool:getTilesWidthCount(mapCtrol)
	return mapCtrol:getTilesWidthCount()
end

--获取区域
--index 区域下标
--返回值(行，列)
function WorldMapTool:getArean(index)
	local maxCol = self:getMaxCol()
	local col = index%maxCol
	if col == 0 then
		col = maxCol
	end
	local maxRow = self:getMaxRow()
	local row,yu = math.modf(index/maxRow)
	if row == 0 then
		row = 1
	elseif yu ~= 0 then
		row = row + 1
	end
	return row,col
end

--调整坐标用的(测试)
--parent 父结点
--row 行
--col 列
--返回值(lab)
function WorldMapTool:createTextLab(parent,row,col,fonSize)
	local label = display.newTTFLabel({
	    text = "row=" .. row .. "col=" .. col,
	    font = "Arial",
	    size = fonSize or 32,
	    color = cc.c3b(255, 0, 0), -- 使用纯红色
	    align = cc.TEXT_ALIGNMENT_LEFT,
	})
	parent:addChild(label)
	label:setLocalZOrder(2000)
	return label
end

--获取行数和列数
--row 行数
--col 列数
--返回值(行数，列表)
function WorldMapTool:getRowCountAndColCount(row,col)
	local maxColCount = self:getMaxColCount()
	local norColCount = self:getNorColCount()
	local maxRowCount = self:getMaxRowCount()
	local norRowCount = self:getNorRowCount()
	local maxCol = self:getMaxCol()
	local maxRow = self:getMaxRow()

	local colCount = norColCount
	if col == 1 or col == maxCol then
		colCount = maxColCount
	end
	local rowCount = norRowCount
	if row == 1 or row == maxRow then
		rowCount = maxRowCount
	end
	return rowCount,colCount
end

--获取资源路径
--rowCount 行数
--colCount 列数
--返回值(资源路径)
function WorldMapTool:getResPath(rowCount,colCount)
	local maxColCount = self:getMaxColCount()
	local norColCount = self:getNorColCount()
	local maxRowCount = self:getMaxRowCount()
	local norRowCount = self:getNorRowCount()

	--得出资源大小
	local resPath = ""
	if colCount == maxColCount and rowCount == maxRowCount then
		resPath = "test/map102102.tmx"
	elseif colCount == maxColCount and rowCount == norRowCount then
		resPath = "test/map102100.tmx"
	elseif colCount == norColCount and rowCount == norRowCount then
		resPath = "test/map100100.tmx"
	elseif colCount == norColCount and rowCount == maxRowCount then
		resPath = "test/map100102.tmx"
	end

	return resPath
end

--创建地图
--row 行
--col 列
--返回值(地图)
function WorldMapTool:createMap(row,col)
	if self:isHaveCreateMap(row,col) then
		return
	end
	--print("创建地图....row=",row,"col=",col)

	--地图可以放大，这个时候坐标会变，所以要先变成1倍大小，即没放大之前
	local preScale = self:getMapScale()
	self:setMapScale(1)
	local preAnchorPoint = self.bgMap:getAnchorPoint()
	self.bgMap:setAnchorPoint(0,0)

	--创建地图
	local worldMapInfo = WorldMapPosData:getInstance():getWorldMapInfo(row,col)	

	local bgMap = worldMapInfo.mapCtrol:buildMapInfo(worldMapInfo.resPath)
	--MyLog("create map row=",row,"col=",col,"resPath=",worldMapInfo.resPath,"map=",bgMap)
	bgMap:setAnchorPoint(0,0)
	bgMap:setPosition(worldMapInfo.pos)
	self.bgMap:addChild(bgMap)

	--self:createGridLab(bgMap,worldMapInfo)

	--[[
	local lab = self:createTextLab(bgMap,row,col)
	lab:setAnchorPoint(0,0)
	lab:setPosition(bgMap:getContentSize().width-450,worldMapInfo.size.height-220)

	local lab = self:createTextLab(bgMap,row,col)
	lab:setAnchorPoint(0,0)
	lab:setPosition(304,178)
	--]]

	local bg = display.newCutomColorLayer(worldMapInfo.color,
	bgMap:getContentSize().width,worldMapInfo.size.height)
	--self.bgMap:addChild(bg, 100)
	bg:setPosition(worldMapInfo.pos)
	bg:setAnchorPoint(0,0)
	-- local lab = self:createTextLab(bg,row,col)
	-- lab:setAnchorPoint(0,0)
	-- lab:setPosition(0,400)

	-- local lab = self:createTextLab(bg,row,col)
	-- lab:setAnchorPoint(0,0)
	-- lab:setPosition(bgMap:getContentSize().width,120)

	-- local lab = self:createTextLab(bg,row,col)
	-- lab:setAnchorPoint(0,0)
	-- lab:setPosition(100,worldMapInfo.size.height-25)

	-- local lab = self:createTextLab(bg,row,col)
	-- lab:setAnchorPoint(0,0)
	-- lab:setPosition(bgMap:getContentSize().width-225,500)
	----]]

	--保存地图信息
	local mapInfo = {}
	mapInfo.map = bgMap
	mapInfo.row = row   						 --第几行
	mapInfo.col = col   						 --第几列
	mapInfo.pos = worldMapInfo.pos    			 --坐标
	mapInfo.size = worldMapInfo.size
	table.insert(self.mapInfo,mapInfo)

	self:setMapScale(preScale)
	self.bgMap:setAnchorPoint(preAnchorPoint)

	return bgMap
end

--创建测试网格坐标
--map 地图
--mapInfo 地图信息
--返回值(无)
function WorldMapTool:createGridLab(map,mapInfo)
	local rowCount = mapInfo.rowCount
	local colCount = mapInfo.colCount
	local maxColCount = self:getMaxColCount()
	local maxRowCount = self:getMaxRowCount()
	local offsetX = 0
	local offsetY = 0
	if rowCount == maxRowCount then
		local offset = maxRowCount - self:getNorRowCount()
		if mapInfo.row == 1 then
			offsetY = offset 
		end
	end
	if colCount == maxColCount then
		local offset = maxColCount - self:getNorColCount()
		if mapInfo.col == 1 then
			offsetX = offset
		end
	end

	for i=1,rowCount do
		for j=1,colCount do
			local x = j-offsetX
			local y = i-offsetY
			local worldGridPos = self:getWorldGridPos(cc.p(x,y),mapInfo)
			local lab = self:createTextLab(map,worldGridPos.y,worldGridPos.x,22)
			lab:setAnchorPoint(0,0)
			local posX = (j-1)*self:getTileWidth() + 12
			if i%2 == 0 then
				posX = posX + self:getTileWidth()/2
			end
			local posY = (i-1)*self:getTileHeight() - (i-1)*self:getTileHypotenuseHeight() + 30
			lab:setPosition(posX,posY)
		end
	end
end

--获取创建好的地图放置位置
--row 行
--col 列
--mapSize 地图大小
--返回值(地图坐标)
function WorldMapTool:getCreateMapPos(row,col,totalHigh,totalWide)
	local offset = self:getBgMapOffset(row*self:getMaxRowCount())
	local x = totalWide - offset.x

	local offsetY = offset.y*(-1)/2
	local y = 0
	if row == 1 then
		y = offset.y
	else
		y = offset.y + totalHigh
	end

	return cc.p(x,y)
end

--计算地图大小
--返回值(地图大小)
function WorldMapTool:calMapSize()
	local maxRow = 0
	local maxCol = 0
	for k,v in pairs(self.mapInfo) do
		if v.row > maxRow then
			maxRow = v.row
		end
		if v.col > maxCol then
			maxCol = v.col
		end
	end
	
	local rowCount,colCount = self:getMapTiledCount()
	return self:getMapSize(rowCount,colCount)
end

--获取地图大小
--rowCount 行数
--colCount 列数
--返回值(地图大小)
function WorldMapTool:getMapSize(rowCount,colCount)
	local wide = self:getTileWidth()*colCount
	local offsetY = (rowCount-1)*self:getTileHypotenuseHeight() 
	local high = self:getTileHeight()*rowCount-offsetY
	return cc.size(wide,high)
end

--获取地图大小
--row 行
--col 列
--返回值(地图大小)
function WorldMapTool:getMapSizeByRowAndCol(row,col)
	local rowCount,colCount = self:getRowCountAndColCount(row,col)
	return self:getMapSize(rowCount,colCount)
end

--纠正列值
--col 列
--返回值(列值)
function WorldMapTool:getRightCol(col)
	local maxCol = self:getMaxCol()
	if col <= 1 then
		col = 1
	elseif col > maxCol then
		col = maxCol
	end
	return col
end

--纠正行值
--row 行
--返回值(行值)
function WorldMapTool:getRightRow(row)
	local maxRow = self:getMaxRow()
	if row <= 1 then
		row = 1
	elseif row > maxRow then
		row = maxRow
	end
	return row
end

--获取当前区域
--返回值(行，列)
function WorldMapTool:getCurArena()
	local preScale = self:getMapScale()
	local row = -1 
	local col = -1
	local mapInfos = WorldMapPosData:getInstance():getAllWorldMapInfo()
	for k,v in pairs(mapInfos) do
		--把地图转换为世界坐标
		local worldPos2 = self.bgMap:convertToWorldSpace(v.pos)
		worldPos = self.bgMap:getParent():convertToWorldSpace(worldPos2)
		--地图在屏幕内
		if worldPos.x <= v.srceenSize.width and worldPos.x + v.size.width*preScale >= v.srceenSize.width then
			col = v.col
		end
		if worldPos.y <= v.srceenSize.height and worldPos.y + v.size.height*preScale >= v.srceenSize.height then
			row = v.row
		end
	end
	return row,col
end

--地图是否已经创建了
--row 行
--col 列
function WorldMapTool:isHaveCreateMap(row,col)
	local mapInfo = self:findMapInfo(row,col)
	if mapInfo ~= nil then
		return true
	end
	return false
end

--查找创建过的地图信息
--row 行
--col 列
--返回值(地图信息)
function WorldMapTool:findMapInfo(row,col)
	for k,v in pairs(self.mapInfo) do
		if v.row == row and v.col == col then
			return v
		end
	end
end

--根据滑动方向创建新地图
--返回值(无)
function WorldMapTool:createNewMapByDir()
	local row,col = self:getCurArena()
	if row == -1 or col == -1 then
		return
    end

    if row ~= self.curRow and col ~= self.curCol then
    	print("row=",row,"col=",col)
    end
    self.curRow = row
    self.curCol = col

	self:createMap(row,col)

	local leftCol = col + 1
	leftCol = self:getRightCol(leftCol)
	self:createMap(row,leftCol)

	local rightCol = col - 1
	rightCol = self:getRightCol(rightCol)
	self:createMap(row,rightCol)

	local upRow = row - 1
	upRow = self:getRightRow(upRow)
	self:createMap(upRow,col)

	local downRow = row + 1
	downRow = self:getRightRow(downRow)
	self:createMap(downRow,col)

	self:createMap(upRow,rightCol)
end

--删除一些不在屏幕中的地图
--返回值(无)
function WorldMapTool:removeSomeMap()
	local row,col = self:getCurArena()
	if row == -1 or col == -1 then
		return
	end

    local leftCol = col - 2
	while true do
		if leftCol <= 0 then
			break
		end
		self:delMap(row,leftCol)
		leftCol = leftCol - 1
	end

	local rightCol = col + 2
	local maxCol = self:getMaxCol()
	for i=rightCol,maxCol do
		self:delMap(row,i)
	end

	local upRow = row + 2
	local maxRow = self:getMaxRow()
	for i=upRow,maxRow do
		self:delMap(i,col)
	end

	local downRow = row - 2
	while true do
		if downRow <= 0 then
			break
		end
		self:delMap(downRow,col)
		downRow = downRow - 1
	end
end

--删除地图
--row 行
--col 列
--返回值(无)
function WorldMapTool:delMap(row,col)
	for k,v in pairs(self.mapInfo) do
		if v.row == row and v.col == col then
			v.map:removeFromParent()
			table.remove(self.mapInfo,k)
			MyLog("delMap row=",row,"col=",col)
			break
		end
	end
end

--获取当前点击的地图索引
--pos 坐标
--返回值(行，列)
function WorldMapTool:getCurClickMapIndex(pos)
	for k,v in pairs(self.mapInfo) do
		local size = Common:getAfterScaleSize(v.size,self:getMapScale())
		local targetPos = Common:converToWorldPos(v.map)
		local rect = cc.rect(targetPos.x,targetPos.y,size.width,size.height)
		if Common:isClickRect(pos,rect) then
			return v.row,v.col
		end
	end
end

--获取当前点击的地图
--row 行
--col 列
--返回值(地图)
function WorldMapTool:getCurClickMap(row,col)
	for k,v in pairs(self.mapInfo) do
		if v.row == row and v.col == col then
			return v.map
		end
	end
end

--获取当前点击的网格
--pos 坐标
--返回值(网格坐标)
function WorldMapTool:getCurClickGrid(pos)
	--当前点击在哪一张地图上
	local mapInfo = self:getCurClickMapInfo(pos)
	if mapInfo == nil then
		MyLog("click no at map")
		return
	end

	--把点击坐标转换为相对于地图的坐标
	local curMap = self:getCurClickMap(mapInfo.row,mapInfo.col)
	local newPos = curMap:convertToNodeSpace(pos)
	--获取网格坐标
	local gridPos = self:getCoordinateOfScreen(mapInfo.mapCtrol,newPos)
	gridPos = self:getModifGridPos(gridPos,mapInfo) 
	--MyLog("map row=",mapInfo.row,"col=",mapInfo.col,
		--"newPos.x=",newPos.x,"y=",newPos.y,
		--"gridPos x=",gridPos.x,"y=",gridPos.y)
	return gridPos
end

--获取当前点击的地图信息
--pos 坐标
--返回值(地图信息)
function WorldMapTool:getCurClickMapInfo(pos)
	local row,col = self:getCurClickMapIndex(pos)
	return WorldMapPosData:getInstance():getWorldMapInfo(row,col)
end

--获取当前点击的世界网格坐标
--pos 坐标
--返回值(网格世界坐标,地图信息)
function WorldMapTool:getCurClickWorldGrid(pos)
	local gridPos = self:getCurClickGrid(pos)
	local mapInfo = self:getCurClickMapInfo(pos)
	if mapInfo == nil then
		return
	end
	-- print("gridPos x=",gridPos.x,"y=",gridPos.y)
	return self:getWorldGridPos(gridPos,mapInfo),mapInfo
end

--获取世界网格坐标
--gridPos 网格坐标
--mapInfo 地图信息
--返回值(网格世界坐标)
function WorldMapTool:getWorldGridPos(gridPos,mapInfo)
	local y = (mapInfo.row-1)*self:getNorRowCount()+gridPos.y
	local x = (mapInfo.col-1)*self:getNorColCount()+gridPos.x
	return cc.p(x,y)
end

--是否点击在了地图边缘
--gridPos 网格坐标
--mapInfo 地图信息
--返回值(true:点在边缘,false:没有点在边缘上)
function WorldMapTool:isClickMapEdage(gridPos,mapInfo)
	local maxRowCount = self:getMaxRowCount()
	local maxColCount = self:getMaxColCount()
	if mapInfo.rowCount == maxRowCount then  --靠边的地图
		local offset = maxRowCount - self:getNorRowCount()
		if mapInfo.row == 1 then
			if gridPos.y < 0 then
				return true
			end
		elseif mapInfo.row == self:getMaxRow() then
			if maxRowCount - gridPos.y < offset then
				return true
			end
		end
	end
	if mapInfo.colCount == maxColCount then  --靠边的地图
		local offset = maxColCount - self:getNorColCount()
		if mapInfo.col == 1 then
			if gridPos.x < 0 then
				return true
			end
		elseif mapInfo.col == self:getMaxCol() then
			if maxColCount - gridPos.x < offset then
				return true
			end
		end
	end
	return false
end

--获取修正后的网格坐标(因为地图四个边不算在内,所以要修正一下网格坐标)
--gridPos 网格坐标
--mapInfo 地图信息
--返回值(网格坐标)
function WorldMapTool:getModifGridPos(gridPos,mapInfo)
	local maxRowCount = self:getMaxRowCount()
	local maxColCount = self:getMaxColCount()
	if mapInfo.rowCount == maxRowCount then
		local offset = maxRowCount - self:getNorRowCount()
		if mapInfo.row == 1 then  --靠下的地图
			gridPos.y = gridPos.y - offset
		end
	end
	if mapInfo.colCount == maxColCount then
		local offset = maxColCount - self:getNorColCount()
		if mapInfo.col == 1 then --靠左的地图
			gridPos.x = gridPos.x - offset
		end
	end
	return gridPos
end

--根据屏幕像素坐标获取地图x,y坐标
--mapCtrol 地图控制器
--pos 坐标
--返回值(网格坐标)
function WorldMapTool:getCoordinateOfScreen(mapCtrol,pos)
	local anchort = self.bgMap:getAnchorPoint()
	local gridPos = mapCtrol:getCoordinateOfScreen(pos.x,pos.y,self:getMapScale(),anchort.x,anchort.y)
	return gridPos
end

--把网格坐标转换成屏幕坐标
--mapCtrol 地图控制器
--gridPos 网格坐标
--返回值(屏幕坐标)
function WorldMapTool:getScreenPosByGridPos(mapCtrol,girdPos)
	local anchort = self.bgMap:getAnchorPoint()
	return mapCtrol:getCoordinateOfMapPos(girdPos.x,girdPos.y,self:getMapScale(),anchort.x,anchort.y)
end

--获取地图起始坐标偏差值
--row 行
--返回值(起始坐标偏差值)
function WorldMapTool:getBgMapOffset(row)
	if self.offset == nil then
		local high = self:getTileHypotenuseHeight()
		local rowCount = row or self:getTilesHeightCount()
		local y = self:getOffsetY()
		local x = self:getTileWidth()*2
		self.offset = cc.p(x,y)
	end
	return self.offset
end

--计算Y起始坐标(102格，有两格不用，要扣掉这两格高度)
--返回值(获取Y方向上的起始偏差值)
function WorldMapTool:getOffsetY()
	if _offsetY == nil then
		local xieGao = self:getTileHypotenuseHeight()
		local high = self:getTileHeight()
		_offsetY = (self:getMaxRowCount()-self:getNorRowCount())*(high - xieGao)*(-1)
	end
	return _offsetY
end

--根据网格坐标获取地图信息
--gridPos 网格坐标
--rowCount 行数
--colCount 列数
--返回值(地图信息)
function WorldMapTool:getMapInfoByGridPos(gridPos,rowCount,colCount)
	local function getMapIndex(value,count)
		local index = value/count
		local index,yu = math.modf(index)
		if yu ~= 0 then
			index = index + 1
		end
		return index
	end

	local x = gridPos.x + 1
	local y = gridPos.y + 1
	local mapIndexCol = getMapIndex(x,rowCount)
	local mapIndexRow = getMapIndex(y,colCount)

	return WorldMapPosData:getInstance():getWorldMapInfo(mapIndexRow,mapIndexCol)	
end

--获取地图信息
--worldGridPos 网格坐标
--返回值(地图信息)
function WorldMapTool:getMapInfo(worldGridPos)
	local rowCount = self:getNorRowCount()
	local colCount = self:getNorColCount()
	return self:getMapInfoByGridPos(worldGridPos,rowCount,colCount)
end

--获取偏移坐标
--rowCount 行数
--colCount 列数
--返回值(坐标)
function WorldMapTool:getOffsetPos(rowCount,colCount)
	local offsetX = self:getTileWidth()*colCount
	local offsetY = rowCount*self:getTileHypotenuseHeight() 
	offsetY = self:getTileHeight()*rowCount-offsetY
	return cc.p(offsetX,offsetY)
end

--把网格坐标转成地图上的屏幕坐标
--worldGridPos 网格坐标
--返回值(屏幕坐标)
function WorldMapTool:converWorldGridPosToScreenPos(worldGridPos)
	local function worldGridPosToCurMapGridPos(worldGridPos,rowCount,colCount)
		local x = math.mod(worldGridPos.x,rowCount)
		local y = math.mod(worldGridPos.y,colCount)
		return cc.p(x,y)
	end

	--地图可以放大，这个时候坐标会变，所以要先变成1倍大小，即没放大之前
	local preScale = self:getMapScale()
	self:setMapScale(1)
	local preAnchorPoint = self.bgMap:getAnchorPoint()
	self.bgMap:setAnchorPoint(0,0)

	local rowCount = self:getNorRowCount()
	local colCount = self:getNorColCount()
	
	local mapInfo = self:getMapInfoByGridPos(worldGridPos,rowCount,colCount)
	local gridPos = worldGridPosToCurMapGridPos(worldGridPos,rowCount,colCount)
	local pos = self:getScreenPosByGridPos(mapInfo.mapCtrol,gridPos)

	local newRowCount = (mapInfo.row-1)*rowCount 
	local newColCount = (mapInfo.col-1)*colCount

	local offsetPos = self:getOffsetPos(newRowCount,newColCount)
	local worldPos = cc.pAdd(pos,offsetPos)
	-- MyLog("grid to woldrPos x=",worldPos.x,"y=",worldPos.y,"worldGridPos.x=",worldGridPos.x,"worldGridPos.y=",worldGridPos.y,
	-- 	"gridPos.y=",gridPos.y,"gridPos.x=",gridPos.x,"mapInfo.row=",mapInfo.row)

	self:setMapScale(preScale)
	self.bgMap:setAnchorPoint(preAnchorPoint)

	return worldPos
end




