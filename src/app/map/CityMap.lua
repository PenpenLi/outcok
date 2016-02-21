
--[[
	jinyan.zhang
	城内地图
--]]

CityMap = class("CityMap",function()
    return display.newLayer()
end)

local scheduler = require("framework.scheduler")

local SCROLL_DEACCEL_RATES = 0.8		--地图X方向滚动系数
local SCROLL_DEACCEL_Y = 0.1 			--地图Y方向滚动系数
local MIN_SCROLL_DIS = 15 				--地图最小拖动距离
local DRAP_DIS = 15 					--手指拖动距离

--构造
--返回值(无)
function CityMap:ctor()
	self.touchCount = 0 --触摸点个数
	self.distance = 0 	--两个触摸点之间的距离  
	self.bgScale = 1   	--初始地图缩放比例  
	self.touchDir = TouchDirection.enum_Both   --地图滚动方向
	self.mVecScrollDis = cc.p(0,0)			   --地图拖动距离
	self:setNodeEventEnabled(true) 			   --使能onEnter,onExit接口
	self:init()
end

--初始化地图相关信息
--返回值(无)
function CityMap:init()
	--self.bgMapSize = cc.size(display.width*3,display.height*2)
	--self.bgMap = display.newCutomColorLayer(cc.c4b(0,255,0,150),self.bgMapSize.width,self.bgMapSize.height)
	self.bgMap = display.newSprite("test/city.jpg")
	self.bgMapSize = self.bgMap:getContentSize()
	self.bgMap:setAnchorPoint(0.0,0)
	self.bgMap:setContentSize(self.bgMapSize.width,self.bgMapSize.height)
	self.bgMap:setPosition(0,0)
	self:addChild(self.bgMap)
	--MyLog("bgMap width = ",self.bgMap:getBoundingBox().width,"high=",self.bgMap:getBoundingBox().height)

	self.cityBuilding = CityBuildingView.new(self)
	self:setIsDrap(false)
end

--开关地图上的建筑触摸
--able(true:开启,false:关闭)
--返回值(无)
function CityMap:setMapBuildingTouchAble(able)
	self:setTouchAble(able,self:getBgMap())
	self.cityBuilding:setBuilgingTouchAble(able)
	local cityCtrl = UIMgr:getInstance():getUICtrlByType(UITYPE.CITY)
	if cityCtrl ~= nil then
		cityCtrl:setBtnTouchAble(able)
	end
end

--UI加到舞台后会调用这个接口
--返回值(无)
function CityMap:onEnter()
	--MyLog("CityMap:onEnter()")
	self:setTouchAble(true,self:getBgMap())
	self:beginScrollingTime()
end

--UI离开舞台后会调用这个接口
--返回值(无)
function CityMap:onExit()
	--MyLog("CityMap:onExit()")
	self:stopScrollingTime()
	self:setTouchAble(false,self:getBgMap())
end

--UI从内存中删除后，会调用这个接口
--返回值(无)
function CityMap:onDestroy()
	--MyLog("CityMap:onDestroy")
end

--使能/禁止地图拖动
--able 使能触摸(true:使能,false:禁止)
--返回值(无)
function CityMap:setTouchAble(able,node)
	if node:isTouchEnabled() == able then
		return
	end

	node:setTouchEnabled(able) 
	self.touchCount = 0 
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

--获取地图
--返回值(地图)
function CityMap:getBgMap()
	return self.bgMap
end

--获取地图当前放大倍数
--返回值(地图放大倍数)
function CityMap:getMapScale()
	return self.bgScale
end

--获取地图放大后的大小
--返回值(放大后的地图大小)
function CityMap:getBgMapSize()
	local size = self:getBgMap():getBoundingBox()
	return size
end

--获取地图放大之前的原始大小
--返回值(地图放大前的大小)
function CityMap:getBgMapOldSize()
	return self.bgMapSize
end

--获取地图位置
--返回值(地图坐标)
function CityMap:getBgMapPos()
	local bg = self:getBgMap()
	local pos = cc.p(bg:getPositionX(),bg:getPositionY())
	return pos
end

--设置地图位置
--pos 坐标
--返回值(无)
function CityMap:setBgMapPos(pos)
	self:getBgMap():setPosition(pos)
end

--开始滚动
--返回值(无)
function CityMap:beginScrollingTime()
	if self.handle  ~= nil then
		return
	end

    self:stopScrollingTime()
    self.handle = scheduler.scheduleGlobal(handler(self, self.update), 0)
end

--停止滚动
--返回值(无)
function CityMap:stopScrollingTime()
	if self.handle ~= nil then
		scheduler.unscheduleGlobal(self.handle)
		self.handle = nil
	end
end

--计算地图滑动值
--返回值(滑动后的坐标)
function CityMap:changeVecScrollDis(point,factorX,factorY)
	local pos = { x = point.x * factorX , y = point.y * factorY }
	return pos
end

--每帧更新地图位置
--dt 时间
--返回值(无)
function CityMap:update(dt)
	if self:getBgMap() == nil then
        return
    end
    
    local curPos = cc.pAdd(self:getBgMapPos(),self.mVecScrollDis)
    local outPos = self:getRightOutPos(curPos)

    self:setBgMapPos(outPos)
    self.mVecScrollDis = self:changeVecScrollDis(self.mVecScrollDis,SCROLL_DEACCEL_RATES,SCROLL_DEACCEL_Y)
	if math.abs(self.mVecScrollDis.x) <= 2 then
    	self.mVecScrollDis.x = 0
    end

    if math.abs(self.mVecScrollDis.y) <= 2 then
    	self.mVecScrollDis.y = 0
    end
end

--获取触摸点坐标
--event 事件类型
--id 触摸点id
function CityMap:getTouchPos(event,id)
	local x = event.points[id].x
	local y = event.points[id].y
	return cc.p(x,y)
end

--获取拖动距离
--event 事件
--返回值(拖动距离)
function CityMap:getDiff(event)
	for id, point in pairs(event.points) do
		local curPoint = cc.p(point.x,point.y)
   		local prePos = cc.p(point.prevX,point.prevY)
		local diff = cc.pSub(curPoint,prePos)
		return diff
  	end
end

--开始触摸
--event 事件类型
--返回值(无)
function CityMap:touchBegin(event)
	self:setIsDrap(false)
	self.touchCount = self.touchCount + 1
    self.mVecScrollDis = cc.p(0,0)
    self.beginPoint = self:getTouchPos(event,"0") 

	for id, point in pairs(event.points) do
		if id ~= "0" then
			local secondPoint = cc.p(point.x,point.y)
			self.distance = cc.pGetDistance(self.beginPoint,secondPoint)  --计算两个触摸点距离
			self:stopScrollingTime()
			self.touchCount = self.touchCount + 1
			--print("touchBegin id=",id,"id=",0,"self.distance=",self.distance)
			return
		end
	end

	self:beginScrollingTime()
end

--添加一个触摸点
--event 事件
--返回值(无)
function CityMap:touchAdd(event)
    self.touchCount = self.touchCount + 1
    if self.touchCount == 2 then
    	self:stopScrollingTime()
    	for id, point in pairs(event.points) do
    		if id ~= "0" then
    			local secondPoint = cc.p(point.x,point.y)
	        	self.distance = cc.pGetDistance(self.beginPoint,secondPoint)  --计算两个触摸点距离
	        	break
    		end
    		--print("add id=",id)
  		end
    end
    self:stopScrollingTime()
end

--移除一个触摸点
--event 触摸事件
--返回值(无)
function CityMap:touchRemove(event)
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
--event 事件
--返回值(无)
function CityMap:touchMove(event)
	if self.touchCount  > 1 then	
		self:stopScrollingTime()	 
		self:changeMapSize(event)
		self:setIsDrap(true)
	else    	
	    self:dropMap(event)

	    for id, point in pairs(event.points) do
			local xDis = math.abs(point.x-self.beginPoint.x)
			local yDis = math.abs(point.y-self.beginPoint.y)
			if xDis > DRAP_DIS or yDis > DRAP_DIS then
				self:setIsDrap(true)
				return
			end
		end
		self:setIsDrap(false)
	end
end

--设置拖拽标志
--isDrop(true:拖拽,false:没有拖拽)
--返回值(无)
function CityMap:setIsDrap(isDrap)
	self.isDrap = isDrap
end

--是否可以拖动地图
--dis 距离
--返回值(true:可以拖动,false:不可以拖动)
function CityMap:isCanMovePos(dis)
	if math.abs(dis) < MIN_SCROLL_DIS then
		return false
	end
	return true
end

--拖动地图
--event 事件
--返回值(无)
function CityMap:dropMap(event)
	local twoPointDiff = self:getDiff(event)
	if twoPointDiff == nil then
		return
	end

	if self.cityBuilding:isClickResAtTouchBegin() then
		self.cityBuilding:drapCollectRes(cc.p(event.points["0"].x,event.points["0"].y))
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
    		return
    	else
    		return
    	end
    end
    self.mVecScrollDis = twoPointDiff
    self:beginScrollingTime()
end

--调整地图大小和位置
--focusPos 焦点坐标
-- scale 放大倍数
--返回值(无)
function CityMap:adjustMapSizeAndPos(focusPos,scale)
	self:getBgMap():setScale(scale)

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
--event 事件
--返回值(放大倍数,焦点坐标)
function CityMap:getMapScaleAndFouce(event)
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
--event 事件
--返回值(无)
function CityMap:changeMapSize(event)
    local scale,focusPos = self:getMapScaleAndFouce(event)
    if nil == scale or nil == focusPos then
    	return
    end
    self:adjustMapSizeAndPos(focusPos,scale)
end

--触摸结束
--event 事件
--返回值(无)
function CityMap:touchEnd(event)
	self.touchCount = 0
	self.cityBuilding:setIsClickRes(false)
end

--是否拖拽了地图
--返回值(true:是,false:否)
function CityMap:isDrapMap()
	return self.isDrap
end

--调整地图位置，使其不超出屏幕范围
--inPos 地图坐标
--返回值(纠正后的地图坐标)
function CityMap:getRightOutPos(inPos)
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

    return outPos
end






