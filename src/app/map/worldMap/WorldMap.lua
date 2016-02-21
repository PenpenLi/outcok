
--[[
	jinayn.zhang
	城外世界地图
--]]

WorldMap = class("WorldMap",function()
    return display.newLayer()
end)

local scheduler = require("framework.scheduler")

local SCROLL_DEACCEL_RATES = 0.91		--地图X方向滚动系数
local SCROLL_DEACCEL_Y = 0.9			--地图Y方向滚动系数
local MIN_SCROLL_DIS = 15 				--地图最小拖动距离

--test
-- local SCROLL_DEACCEL_RATES = 0.95		--地图X方向滚动系数
-- local SCROLL_DEACCEL_Y = 0.95			--地图Y方向滚动系数

--拖动检测边界格子数
local DRAP_GRID_COUNT = 3

--构造
--返回值(无)
function WorldMap:ctor()
	self.touchCount = 0 --触摸点个数
	self.distance = 0 	--两个触摸点之间的距离
	self.bgScale = 1   	--初始地图缩放比例
	self.touchDir = TouchDirection.enum_Both   --地图滚动方向
	self.updateTime = 0    --时间
	self.isOpenScrollTime = false  			   --启动拖动地图定时器
	self.mVecScrollDis = cc.p(0,0)			   --地图拖动距离
	self.isCanClick = false  				  --是否可以点击地图
	self.mapTool = WorldMapTool.new(self)      --地图工具类,主要用来计算分屏(客户端专用)
	self:addChild(self.mapTool)
	self.curShowMenuBtnList = {}
	self:setNodeEventEnabled(true) 			   --使能onEnter,onExit接口
	self:setIsFinishScroll(true)
	self:init()
	self.movePos = cc.p(0,0)
	self:setTouchAble(true,self)
end

--初始化
--返回值(无)
function WorldMap:init()
	--父结点锚点为0
	self:setAnchorPoint(0,0)
	self:setPosition(0,0)

	--放置地图的结点,放大和移动都是操作这个结点
	self.node = display.newLayer()
	self.node:setAnchorPoint(0,0)
	self.node:setPosition(0,0)
	self:addChild(self.node)
	self.bgMap = self.node
	self.mapTool:setBgMap(self.bgMap)

	local mapSize = self.mapTool:calMapSize()
	self:setBgMapOldSize(mapSize)

	--跳转到我的城堡位置处
  	local pos = self:getPlayerCastlePos()
  	self:goToPos(pos)

    self.marchLineMgr = {}     --行军路线管理器
   	self.marchList = {}  --行军部队管理器

   	--网格宽度 
   	self.gridWide = self.mapTool:getTileWidth()
   	--网格高度
	self.girdHigh = self.mapTool:getTileHeight()
	--网格斜高
	self.gridXieHigh = self.mapTool:getTileHypotenuseHeight()
	--之前的网格坐标
	self.preGridPos = cc.p(0,0)

	--城堡管理器
	self.castleView = CastleView.new(self)
	self.bgMap:addChild(self.castleView,1)
	self:update(1)
end

--获取城堡层
function WorldMap:getCastleView()
	return self.castleView
end

--获取玩家城堡位置
--返回值(玩家城堡位置)
function WorldMap:getPlayerCastlePos()
	return self:worldGridPosToScreenPos(cc.p(PlayerData:getInstance().x,PlayerData:getInstance().y))
end

--网格坐标转换成地图屏幕坐标
--worldGridPos 世界网格坐标
--返回值(屏幕坐标)
function WorldMap:worldGridPosToScreenPos(worldGridPos)
	local mapInfo = self.mapTool:getMapInfo(worldGridPos)
	if mapInfo == nil then
		return
	end
  	local map = self.mapTool:createMap(mapInfo.row,mapInfo.col)
	return self.mapTool:converWorldGridPosToScreenPos(worldGridPos)
end

--跳转到某个位置
--pos 坐标 
--返回值(无)
function WorldMap:goToPos(pos)
	self:getBgMap():setPosition(0,0)

	--当前点击在哪一张地图上
	local mapInfo = self.mapTool:getCurClickMapInfo(pos)
	if mapInfo == nil then
		return
	end

	local map = self.mapTool:createMap(mapInfo.row,mapInfo.col)
	local newPos = cc.p(-pos.x+display.width/2,-pos.y+display.height/2)
	local bgPos = self:getRightOutPos(newPos)
    self:getBgMap():setPosition(bgPos)

    --迁城
    if MoveCastleAniModel:getInstance():isNeedMoveCastle() then
    	MoveCastleAniModel:getInstance():setMoveCastle(false)
    end
end

--地图加到舞台后，会调用这个接口
--返回值(无)
function WorldMap:onEnter()
	--MyLog("worldMap onEnter()")
	self:openTime()
	self:beginScrollingTime()

	self:synArmsMarch()

	local arryList = OutPlaceBuildingData:getInstance():getList()
	for k,v in pairs(arryList) do
		OutBuildingMgr:getInstance():create(v.type,v.level,cc.p(v.x,v.y),v.id,v.placedBuildingId)
	end
end

--同步地图上其它玩家的行军表现
--返回值(无)
function WorldMap:synArmsMarch()
	AllPlayerMarchView:getInstance():updateWorldMapMarchArms()
end

--地图离开舞台后，会调用这个接口
--返回值(无)
function WorldMap:onExit()
	--MyLog("worldMap onExit()")
	self:stopScrollingTime()
	self:stopTime()
	self:setTouchAble(false,self)
end

--使能或者禁用世界地图
--able(true:开启触摸,false:否)
--返回值(无)
function WorldMap:setMapAble(able)
	self:setTouchAble(able,self)
	local outCity = UIMgr:getInstance():getUICtrlByType(UITYPE.OUT_CITY)
	if outCity ~= nil then
		outCity:setBtnTouchAble(able)
	end
end

--地图从内存中删除后，会调用这个接口
--返回值(无)
function WorldMap:onDestroy()
	--MyLog("WorldMap:onDestroy")
end

--获取地图
--返回值(地图)
function WorldMap:getBgMap()
	return self.bgMap
end

--获取地图当前放大倍数
--返回值(地图放大倍数)
function WorldMap:getMapScale()
	return self.bgScale
end

--设置地图放大倍数
--scale 放大倍数
--返回值(无)
function WorldMap:setMapScale(scale)
	self.bgMap:setScale(scale)
	self.bgScale = scale
end

--获取地图放大后的大小
--返回值(地图放大后的大小)
function WorldMap:getBgMapSize()
	local size = cc.size(self:getBgMap():getContentSize().width*self:getMapScale(),
						self:getBgMap():getContentSize().height*self:getMapScale())
	return size
end

--获取地图放大之前的原始大小
--返回值(地图放大这前的大小)
function WorldMap:getBgMapOldSize()
	return self.bgMapSize
end

--设置放大之前的地图大小
--size 地图大小
--返回值(无)
function WorldMap:setBgMapOldSize(size)
	self.bgMapSize = size
	self.bgMap:setContentSize(size)
end

--获取地图位置
--返回值(地图位置)
function WorldMap:getBgMapPos()
	local bg = self:getBgMap()
	return cc.p(bg:getPositionX(),bg:getPositionY())
end

--设置地图位置
--pos 位置
--返回值(无)
function WorldMap:setBgMapPos(pos)
	self:getBgMap():setPosition(pos)
end

--使能/禁止地图拖动
--able 使能触摸(true:使能，false:禁止)
--node 目标结点
--返回值(无)
function WorldMap:setTouchAble(able,node)
	if able == self.able then
		return
	end
	self.able = able

	self.touchCount = 0
	node:setTouchEnabled(able)

	if able == true then
		node:setTouchMode(cc.TOUCHES_ALL_AT_ONCE)
	    self.touchHandle = node:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
	        if self:getBgMap() == nil then
	        	return
	        end
	        if event.name == "began" then
	        	self:touchBegin(event)
	        elseif event.name == "added" then
	        	self:touchAdd(event)
	        elseif event.name == "moved" then
	           self:touchMove(event)
	        elseif event.name == "removed" then
	        	self:touchRemove(event)
	        elseif event.name == "ended" then
	        	self:touchEnd(event)
	        end
	        return true
	    end)
	else
		node:removeNodeEventListener(self.touchHandle)
	end
end

--打开定时器
--返回值(无)
function WorldMap:openTime()
	if self.handle  ~= nil then
		return
	end
    self:stopTime()
    self.handle = scheduler.scheduleGlobal(handler(self, self.update), 0)
end

--停止定时器
--返回值(无)
function WorldMap:stopTime()
	if self.handle ~= nil then
		scheduler.unscheduleGlobal(self.handle)
		self.handle = nil
	end
end

--开始滚动
--返回值(无)
function WorldMap:beginScrollingTime()
	self.isOpenScrollTime = true
end

--停止滚动
--返回值(无)
function WorldMap:stopScrollingTime()
	self.isOpenScrollTime = false
end

--获取触摸点坐标
function WorldMap:getTouchPos(event,id)
	local x = event.points[id].x
	local y = event.points[id].y
	return cc.p(x,y)
end

--获取拖动距离
function WorldMap:getDiff(event)
	for id, point in pairs(event.points) do
		local curPoint = cc.p(point.x,point.y)
   		local prePos = cc.p(point.prevX,point.prevY)
		local diff = cc.pSub(curPoint,prePos)
		return diff
  	end
end

--开始触摸
--event 触摸事件类型
--返回值(无)
function WorldMap:touchBegin(event)
	self.touchCount = self.touchCount + 1
    self.mVecScrollDis = cc.p(0,0)
    self.beginPoint = self:getTouchPos(event,"0")
    self.isCanClick = true

	for id, point in pairs(event.points) do
		if id ~= "0" then
			local secondPoint = cc.p(point.x,point.y)
			self.distance = cc.pGetDistance(self.beginPoint,secondPoint)  --计算两个触摸点距离
			self:stopScrollingTime()
			self.touchCount = self.touchCount + 1
			self.isCanClick  = false
			return
		end
	end

	self:beginScrollingTime()
end

--添加一个触摸点
--event 触摸事件类型
--返回值(无)
function WorldMap:touchAdd(event)
    self.touchCount = self.touchCount + 1
    if self.touchCount == 2 then
    	self:stopScrollingTime()
    	for id, point in pairs(event.points) do
    		if id ~= "0" then
    			local secondPoint = cc.p(point.x,point.y)
	        	self.distance = cc.pGetDistance(self.beginPoint,secondPoint)  --计算两个触摸点距离
	        	break
    		end
  		end
    end
    self.isCanClick = false
    self:stopScrollingTime()
end

--移除一个触摸点
--event 触摸事件类型
--返回值(无)
function WorldMap:touchRemove(event)
	self.touchCount = self.touchCount - 1
	if self.touchCount == 1 then
		for id, point in pairs(event.points) do
			self.beginPoint = cc.p(point.x,point.y)
  		end
  		self.mVecScrollDis = cc.p(0,0)
		self:beginScrollingTime()
	end
end

--手指移动触摸
--event 触摸事件类型
--返回值(无)
function WorldMap:touchMove(event)
	if self.touchCount  > 1 then
		self:stopScrollingTime()
		self:changeMapSize(event)
		self.isCanClick  = false
	else
	    self:dropMap(event)
	end
end

--是否可以拖动地图
--dis 距离
--返回值(true:可以拖动，false:不可以拖动)
function WorldMap:isCanMovePos(dis)
	if math.abs(dis) < MIN_SCROLL_DIS then
		return false
	end
	return true
end

--拖动地图
--event 触摸事件
--返回值(无)
function WorldMap:dropMap(event)
	local twoPointDiff = self:getDiff(event)
	if twoPointDiff == nil then
		return
	end

    if self.touchDir == TouchDirection.enum_Horizontal then
    	twoPointDiff.y = 0
    	if not self:isCanMovePos(twoPointDiff.x) then
    		return
    	end
    elseif self.touchDir == TouchDirection.enum_Vertical then
    	twoPointDiff.x = 0
    	if not self:isCanMovePos(twoPointDiff.y) then
    		return
    	end
    else
    	if self:isCanMovePos(twoPointDiff.x) or self:isCanMovePos(twoPointDiff.y) then
    		self.mVecScrollDis = twoPointDiff
    		self:beginScrollingTime()
    		self.isCanClick  = false
    		return
    	else
    		return
    	end
    end
    self.mVecScrollDis = twoPointDiff
    self:beginScrollingTime()
end

--调整地图大小和位置
--focusPos 焦点位置
--scale 放大倍数
--返回值(无)
function WorldMap:adjustMapSizeAndPos(focusPos,scale)
	self:setMapScale(scale)

	local fouce = self:getBgMap():convertToNodeSpace(focusPos)

     --ax-新的anchor point中x的值，ay同理
    local oldMapSize = self:getBgMapOldSize()
    local ax = fouce.x / oldMapSize.width
    local ay = fouce.y / oldMapSize.height

    local prevAnchor = self:getBgMap():getAnchorPoint()
    self:getBgMap():setAnchorPoint(ax,ay)

    --调整后的地图位置
    local mapPos = self:getBgMapPos()
    local mapSize = self:getBgMapSize()
    local newBgPos =cc.p(oldMapSize.width*ax*scale+mapPos.x-mapSize.width*prevAnchor.x,
    	oldMapSize.height*ay*scale+mapPos.y-mapSize.height*prevAnchor.y)

    local bgPos = self:getRightOutPos(newBgPos)
    self:getBgMap():setPosition(bgPos)
end

--通过手势获取地图放大倍数和焦点位置
--event 触摸事件
--返回值(放大倍数，焦点位置)
function WorldMap:getMapScaleAndFouce(event)
	local pointSet = {}
    for id, point in pairs(event.points) do
		pointSet[id] = cc.p(point.x,point.y)
	end

	local point1 = nil
    local point2 = nil
    local count = 0

	for id,point in pairs(pointSet) do
		if id == "0" then
			self.beginPoint = point
			point1 = point
			count = count + 1
		else
			point2 = point
			count = count + 1
		end
		if count > 1 then
			break
		end
	end

	if point1 == nil then
		point1 = self.beginPoint
	end

	if point2 == nil then
		return
	end

    local distance = cc.pGetDistance(point1,point2)
    self.bgScale = distance/self.distance * self.bgScale   	--新的距离 / 老的距离  * 原来的缩放比例，即为新的缩放比例
    --MyLog("distance = ",distance,"scale=",self.bgScale)
    if self.bgScale < 1 then
    	self.bgScale = 1
    elseif self.bgScale >= 2 then
    	self.bgScale = 2
    end
    self.distance = distance
    local focusPos = cc.pMidpoint(point1,point2)

    return self.bgScale,focusPos
end

--改变地图大小
--event 触摸事件
--返回值(无)
function WorldMap:changeMapSize(event)
    local scale,focusPos = self:getMapScaleAndFouce(event)
    if nil == scale or nil == focusPos then
    	return
    end
    self:adjustMapSizeAndPos(focusPos,scale)
end

--调整地图位置，使其不超出屏幕范围
--inPos 地图坐标
--返回值(纠正后的地图坐标)
function WorldMap:getRightOutPos(inPos)
	if inPos then
		--print("inPos.x=",inPos.x,"y=",inPos.y)
		--return inPos
	end

    local mapWide = self:getBgMapSize().width
    local mapHigh = self:getBgMapSize().height
    local mapAnchorPoint = self:getBgMap():getAnchorPoint()
    local limitX = mapWide * mapAnchorPoint.x
    local limitY = mapHigh * mapAnchorPoint.y
    local viewSize = cc.Director:getInstance():getVisibleSize()

    local outPos = inPos
    if inPos.x > limitX  then
        outPos.x = limitX
    elseif inPos.x < limitX then
        if inPos.x + mapWide - mapWide*mapAnchorPoint.x <= viewSize.width then
            outPos.x = viewSize.width-mapWide+mapWide*mapAnchorPoint.x
        end
    end

	if inPos.y > limitY  then
        outPos.y = limitY
    elseif inPos.y < limitY then
        if inPos.y + mapHigh - mapHigh*mapAnchorPoint.y <= viewSize.height then
            outPos.y = viewSize.height-mapHigh+mapHigh*mapAnchorPoint.y
        end
    end
    --print("outPos.x=",outPos.x,"y=",outPos.y)

    return outPos
end

--计算地图滑动值
--point 坐标点
--factorX X放大倍数
--factorY Y放大倍数
--返回值(滑动后的坐标值)
function WorldMap:changeVecScrollDis(point,factorX,factorY)
	local pos = { x = point.x * factorX , y = point.y * factorY }
	return pos
end

function WorldMap:setScrollDis(dis)
	self.mVecScrollDis.x = dis.x + self.mVecScrollDis.x
	self.mVecScrollDis.y = dis.y + self.mVecScrollDis.y
	self.mVecScrollDis = dis
	self:setIsFinishScroll(false)
end

--设置滚动完成标志
function WorldMap:setIsFinishScroll(isFinish)
	self.isFinishScroll = isFinish
end

function WorldMap:moveToPos(pos)
	if pos == nil then
		return
	end
	self.isOpenScrollTime = false
	self:setIsFinishScroll(false)

	-- self.movePos.x = pos.x + self.movePos.x
	-- self.movePos.y = pos.y + self.movePos.y
	--self.movePos = pos

	local curPos = cc.pAdd(self:getBgMapPos(),self.movePos)
	local outPos = self:getRightOutPos(curPos)

	local sequence = transition.sequence({
			cc.MoveTo:create(0.3,outPos),
			cc.CallFunc:create(function()
				self:setIsFinishScroll(true)
			end),
	    })
	self:getBgMap():stopAllActions()
	self:getBgMap():runAction(sequence)
end

--每帧更新地图位置
--dt 时间
--返回值(无)
function WorldMap:update(dt)
	if self:getBgMap() == nil then
        return
    end
    ----[[
    if self.isOpenScrollTime then
    	local curPos = cc.pAdd(self:getBgMapPos(),self.mVecScrollDis)
	    local outPos = self:getRightOutPos(curPos)
	    local x = math.modf(outPos.x)
	    local y = math.modf(outPos.y)
	    outPos = cc.p(x,y)
	    self:setBgMapPos(outPos)
	    self.mVecScrollDis = self:changeVecScrollDis(self.mVecScrollDis,SCROLL_DEACCEL_RATES,SCROLL_DEACCEL_Y)
	    if math.abs(self.mVecScrollDis.x) <= 2 then
	    	self.mVecScrollDis.x = 0
	    end

	    if math.abs(self.mVecScrollDis.y) <= 2 then
	    	self.mVecScrollDis.y = 0
	    end

	    if self.mVecScrollDis.x == 0 and self.mVecScrollDis.y == 0 then
	    	self:setIsFinishScroll(true)
	    end

	    self.mapTool:createNewMapByDir()
	    self.updateTime = self.updateTime + 1
	    if self.updateTime > 50 then
	    	self.updateTime = 0
	    	self.mapTool:removeSomeMap()
	    end

		if x ~= self.curX or y ~= self.curY then
	    	--print("out x=",x,"y=",y)
	    	local pos = cc.p(display.width/2,display.height/2)
	    	local xCount = math.ceil(pos.x/self.gridWide)
	    	local yCount = math.ceil(pos.y/self.girdHigh)
	    	local gridPos,mapInfo = self.mapTool:getCurClickWorldGrid(pos)
			if gridPos == nil or mapInfo == nil then
				MyLog("error......map...")
			else
				local moveGridX = math.abs(gridPos.x-self.preGridPos.x)
				local moveGirdY = math.abs(gridPos.y-self.preGridPos.y)
				if moveGridX > DRAP_GRID_COUNT or moveGirdY > DRAP_GRID_COUNT then
					local beginGridX = gridPos.x - xCount
					if beginGridX <= 0 then
						beginGridX = 0
					end
					local beginGridY = gridPos.y - yCount - DRAP_GRID_COUNT
					if beginGridY <= 0 then
						beginGridY = 0
					end
					local endGirdX = gridPos.x + xCount + DRAP_GRID_COUNT
					if endGirdX >= 1999 then
						endGirdX = 1999
					end
					local endGridY = gridPos.y + xCount + DRAP_GRID_COUNT
					if endGridY >= 1999 then
						endGridY = 1999
					end
					--print("当前在屏幕中央的网格坐标x=",gridPos.x,"y=",gridPos.y)
					--print("开始x=",beginGridX,"beignY=",beginGridY,"endX=",endGirdX,"endY=",endGridY)
					local mapId = CommonConfig:getInstance():getWorldMapId()
					local beginPos = {}
					beginPos.x = beginGridX
					beginPos.y = beginGridY
					local endPos = {}
					endPos.x = endGirdX
					endPos.y = endGridY
					if not self.first then
						WorldMapServer:getInstance():sendEnterWorldMapReq(mapId,beginPos,endPos)
						self.first = true
					else
						WorldMapServer:getInstance():updateMapPosReq(mapId,beginPos,endPos)
					end
					--print("beginPos.x=",beginPos.x,"beginPos.y=",beginPos.y,"endPos.x=",endPos.x,"endPos.y=",endPos.y)
					self.preGridPos.x = gridPos.x
					self.preGridPos.y = gridPos.y
				end
			end
	    end
	    self.curX = x 
	    self.curY = y
    end
    --]]
end

--触摸结束
--event 触摸事件
--返回值(无)
function WorldMap:touchEnd(event)
	self.touchCount = 0
	if self.isCanClick then
		for id, point in pairs(event.points) do
			local pos = cc.p(point.x,point.y)
			local gridPos,mapInfo = self.mapTool:getCurClickWorldGrid(pos)
			if gridPos == nil or mapInfo == nil then
				MyLog("clide error")
				return
			end

			if self.mapTool:isClickMapEdage(gridPos, mapInfo) then
				MyLog("click edage...")
				return
			end
			MyLog("click gridPos.x=",gridPos.x,"gridPos.y=",gridPos.y,"row=",mapInfo.row,"col=",mapInfo.col)
			local str = "click gridPos.x=" .. gridPos.x .. " gridPos.y=" .. gridPos.y .. " touch x=" .. pos.x .. " y=" .. pos.y
			--Prop:getInstance():showMsg(str,5)
			--print("row=",mapInfo.row,"col=",mapInfo.col)

			self:checkClick(gridPos)
		end
	end
end

--点击检测
--clickGridPos 点击的网格位置
--返回值(无)
function WorldMap:checkClick(clickGridPos)
	--检测是否点击在城堡上
	if self.castleView:isClickCastle(clickGridPos) then
		return
	end

	--检测是否点击在野外建筑上
	if OutBuildingMgr:getInstance():isClickBuilding(clickGridPos) then
		return
	end
end

--删除除了自己外的所有行军部队
function WorldMap:delAllArmsButMe()
	local list = PlayerMarchModel:getInstance():getData()
	for k,v in pairs(self.marchList) do
		local isMe = false
		for k,value in pairs(list) do
			if value.id_h == v.armsid_h and value.id_l == v.armsid_l then
				isMe = true
				break
			end
		end
		if not isMe then
			self:removeMarchUI(v.armsid_h,v.armsid_l)
		end
	end
end

--删除行军路线
---armsid_h 行军部队id
--armsid_l 行军部队id
--返回值(无)
function WorldMap:removeMarchLine(armsid_h,armsid_l)
	local index = 1
	local readyDelTab = {}
	for k,v in pairs(self.marchLineMgr) do
		if v.armsid_h == armsid_h and v.armsid_l == armsid_l then
			readyDelTab[index] = {}
			readyDelTab[index].index = k
			readyDelTab[index].sprite = v.sprite
			index = index + 1
		end
	end

	for k,v in pairs(readyDelTab) do
		v.sprite:removeFromParent()
    	self.marchLineMgr[v.index] = nil
	end
end

--删除行军部队
--armsid_h 行军部队id
--armsid_l 行军部队id
--返回值(无)
function WorldMap:removeMarchArms(armsid_h,armsid_l)
	local index = 1
	local readyDelTab = {}
	for k,v in pairs(self.marchList) do
		if v.armsid_h == armsid_h and v.armsid_l == armsid_l then
			readyDelTab[index] = {}
			readyDelTab[index].index = k
			readyDelTab[index].sprite = v.sprite
			readyDelTab[index].beginSprite = v.beginSprite
			readyDelTab[index].targetSprite = v.targetSprite
			index = index + 1
		end
	end

	for k,v in pairs(readyDelTab) do
		v.sprite:remove()
		if v.beginSprite ~= nil then
			v.beginSprite:removeFromParent()
		end
		if v.targetSprite ~= nil then
			v.targetSprite:removeFromParent()
		end
    	self.marchList[v.index] = nil
	end
end

--是否已经创建过行军队伍
--armsid_h 行军部队id
--armsid_l 行军部队id
--返回值(true:是,false:否)
function WorldMap:isHaveCreateMarchArms(armsid_h,armsid_l)
	for k,v in pairs(self.marchList) do
		if v.armsid_h == armsid_h and v.armsid_l == armsid_l then
			return true
		end
	end
	return false
end

--删除行军相关的UI
--armsid_h 行军部队id
--armsid_l 行军部队id
--返回值(无)
function WorldMap:removeMarchUI(armsid_h,armsid_l)
	self:removeMarchLine(armsid_h,armsid_l)
	self:removeMarchArms(armsid_h,armsid_l)
end

--设置地图上的行军部队攻击目标handle
--heroArms 行军部队
--targetGridPos 目标位置
--返回值(无)
function WorldMap:setHeroArmsAttTargetHandle(heroArms,targetGridPos)
	local attTarget = self.castleView:getAttTargetByGridPos(targetGridPos)
	if attTarget ~= nil then
		heroArms:setAttackMajor(attTarget)
	end
end

--创建部队
--beginPos 开始位置
--endPos  目标位置
--moveSpeed 移动速度
--armsList 行军部队
--marchArmsId 行军部队id
--armsid_h 行军部队id
--armsid_l 行军部队id
--armsCurPos 部队当前位置
--targetGridPos 行军目标点网格坐标
--isReturnCastle 返回城堡标记(true:是返回城堡,false:不是)
--marchLineTargetPos 行军路线目标位置(画行军路线用的)
--islook(true:侦察,false:不是侦察)
--isOther 是否是其它人(true:是，false:否)
--返回值(部队)
function WorldMap:createArms(beginPos,endPos,moveSpeed,armsList,armsid_h,armsid_l,armsCurPos,targetGridPos,isReturnCastle,marchLineTargetPos,islook,isOther)
	if self:isHaveCreateMarchArms(armsid_h,armsid_l) then
		return
	end

	local nextMidPos = armsCurPos
	local nexMidTargetPos = endPos

	local soldierTypeList = ArmsData:getInstance():getSortSoldier(armsList)
	local poslist = {}

	local attTarget = self.castleView:getAttTargetByGridPos(targetGridPos)
	for i=1,#soldierTypeList do
		local info = soldierTypeList[i]
		if islook then
			info.count = 1
		end

		if info.count == 4 then
			poslist = Common:getFourtPosAndTargetPos(30,nextMidPos,nexMidTargetPos,-50)
		elseif info.count == 3 then
			poslist = Common:getThreePosAndTargetPos(60,nextMidPos,nexMidTargetPos,-50)
		elseif info.count == 2 then
			poslist = Common:getTwoPosAndTargetPos(30,nextMidPos,nexMidTargetPos,-50)
		elseif info.count == 5 then
			poslist = Common:getFivePosAndTargetPos(30,nextMidPos,nexMidTargetPos,-50)
		elseif info.count == 1 then
		    poslist[1] = {}
		    poslist[1].pos = nextMidPos
		    poslist[1].targetPos = nexMidTargetPos
		end
		nextMidPos,nexMidTargetPos = Common:getNextMidPos(50,nextMidPos,nexMidTargetPos)

		for k,v in pairs(poslist) do
			--[[
			local beginSprite = display.newSprite("test/RadioButtonOff.png")
			self:getBgMap():addChild(beginSprite,WORLDE_MAP_ZORDER.HERO)
			beginSprite:setPosition(v.pos)

			local targetSprite = display.newSprite("test/RadioButtonOn.png")
			self:getBgMap():addChild(targetSprite,WORLDE_MAP_ZORDER.HERO)
			targetSprite:setPosition(v.targetPos)
			--]]

			local angle =  BattleCommon:getInstance():getTwoPosAngle(v.pos,v.targetPos)
		    local dir = BattleCommon:getInstance():getDirection(angle)
			local arms = HeroArms.new(BATTLE_CONFIG[info.soldierType],dir,info.soldierType,CAMP.ATTER,v.targetPos,100,islook)
			self:getBgMap():addChild(arms,WORLDE_MAP_ZORDER.HERO)
			arms:setPosition(v.pos)
			HeroMgr:getInstance():addSoldier(arms,info.soldierType,CAMP.ATTER)
			arms:setAttackMajor(attTarget)
			arms:setSpeed(moveSpeed)
			arms:setIsReturnCastle(isReturnCastle)
			arms:setMarchArmsId(armsid_h,armsid_l)
			arms:registerMsg(0,self,self.setHeroArmsAttTargetHandle,targetGridPos)

			marchInfo = {}
			marchInfo.sprite = arms
			marchInfo.armsid_h = armsid_h
			marchInfo.armsid_l = armsid_l
      		marchInfo.beginSprite = beginSprite
      		marchInfo.targetSprite = targetSprite
			table.insert(self.marchList,marchInfo)
		end
	end

	Common:createLineAnimation(beginPos,marchLineTargetPos,armsid_h,armsid_l,self:getBgMap(),self.marchLineMgr,isOther)

	return arms
end


