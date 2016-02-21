
--[[
	jinyan.zhang
	建筑列表控件
--]]

UIBuildingList = class("UIBuildingList",function()
    return display.newLayer()
end)

local instance = nil

--构造
--data 数据
--返回值(无)
function UIBuildingList:ctor(data)
    instance = self
	self.buildSize = data.buildingSize  --建筑的大小
	self.buildDis = data.buildDis  --每个建筑的间距
	self.count = data.count     --建筑的个数
	self.pointBoxNode = data.pointBoxNode  --建筑要移动到的UI目标点
	self.parent = data.parent
	self.idx = -1
	self.eventHandlerTable = {}
	self.eventObjTable = {}
	self:init()
end

--初始化
--返回值(无)
function UIBuildingList:init()
	self:createBuildList()
end

--建筑列表加到舞台后会调用这个接口
--返回值(无)
function UIBuildingList:onEnter()
	MyLog("UIBuildingList:onEnter()")
end

--建筑列表离开舞台后会调用这个接口
--返回值(无)
function UIBuildingList:onExit()
	MyLog("UIBuildingList:onExit()")
end

--建筑列表从内存中移除后，会调用这个接口
--返回值(无)
function UIBuildingList:onDestroy()
	MyLog("UIBuildingList:onDestroy()")
end

--注册消息
--evenType 事件类型
--obj 事件回调接口所在的类名
--handler 事件回调接口
--返回值(无)
function UIBuildingList:registerMsg(evenType, obj, handler)
    self.eventHandlerTable[evenType] = handler
    self.eventObjTable[evenType] = obj
end

--获取建筑列表的个数
--返回值(列表个数)
function UIBuildingList:getBuildListCount()
	if self.count > 3 then
		return 3
	end
	return self.count
end

--获取建筑列表的真实个数
--返回值(个数)
function UIBuildingList:getBuildListRealCount()
	return self.count
end

--获取建筑列表的中点值
--返回值(中点值)
function UIBuildingList:getBuildlistMid()
	local mid = self:getBuildListCount()/2
	return math.floor(mid)
end

--获取单个建筑的大小
--返回值(建筑大小)
function UIBuildingList:getBuildSize()
	return self.buildSize
end

--获取每个建筑之间的间距
--返回值(建筑间距)
function UIBuildingList:getBuildOffset()
	return self.buildDis
end

--获取建筑列表的大小
--返回值(建筑列表大小)c
function UIBuildingList:getBuildListSize()
	local size = self:getBuildSize()
	local wide = size.width + 30
	local count = self:getBuildListCount()
	local high = size.height * count + self:getBuildOffset() * (count-1)
	if high <= 0 then
		high = size.height
	end

	return cc.size(wide,high)
end

--获取建筑列表的起始位置
--返回值(建筑列表的位置)
function UIBuildingList:getBuildListPos()
	local size = self:getBuildSize()
	local x,y = self.pointBoxNode:getPosition()
	x = x - 40
	local buildlistSize = self:getBuildListSize()	
	y = y - (size.height/2+self:getBuildOffset()) - buildlistSize.height/2 + 10
	local count = self:getBuildListCount()
	if count == 3 or count == 5 then
		y = y + (size.height/2+self:getBuildOffset()) - 10
	elseif count == 1 then
		y = self.pointBoxNode:getPosition() + (size.height/2+self:getBuildOffset()) + size.height/4 + 50
	elseif count >= 7 then
		y = y + size.height/2
	end
	return cc.p(x,y)
end

--获取建筑列表回弹值
--返回值(最大回弹值)
function UIBuildingList:getBuildMaxBackValue()
	local buildlistSize = self:getBuildListSize()	
	local backY = buildlistSize.height/2 + 12
	local buildSize = self:getBuildSize()
	if backY <= buildSize.height then
		backY = 0
	end
	local count = self:getBuildListCount()
	if count == 1 then 
		return cc.p(0,buildSize.height/4-40)
	elseif count == 3 then
		backY = buildlistSize.height - 2*(buildSize.height+self:getBuildOffset()) + 20
		return cc.p(0,backY)
	elseif count == 5 then
		backY = buildlistSize.height/2  - (buildSize.height+self:getBuildOffset()) + 84
	elseif count >= 7 then
		backY = buildlistSize.height/2  - (self:getBuildOffset()) - 70
	end
	return cc.p(0,backY)
end

--获取建筑列表回弹值
--返回值(最小回弹值)
function UIBuildingList:getBuildMinBackValue()
	local buildSize = self:getBuildSize()
	local buildlistSize = self:getBuildListSize()	
	local backY = buildlistSize.height/2 + buildSize.height + 30
	if backY <= buildSize.height then
		backY = buildSize.height
	end
	local count = self:getBuildListCount()
	if count == 1 then 
		return cc.p(0,buildSize.height+self:getBuildOffset()+buildSize.height/4-40)
	elseif count == 3 then
		backY = buildlistSize.height - buildSize.height
	elseif count == 5 then
		backY = buildlistSize.height/2 + buildSize.height - 40
	elseif count >= 7 then
		backY = buildlistSize.height/2 + buildSize.height - 60
	end
	return cc.p(0,backY)
end 

--建筑大小
--table tableView控件
--idx 第几个
--返回值(建筑大小)
function UIBuildingList.cellSizeForTable(table,idx) 
    return instance:getBuildSize().width,instance:getBuildSize().height
end

---建筑个数
--table tableView控件
--返回值(建筑个数)
function UIBuildingList.numberOfCellsInTableView(table)
   return instance:getBuildListRealCount()
end

--每次拖动建筑列表，都会回调这个接口
--view scrollview控件
--返回值(无)
function UIBuildingList.scrollViewDidScroll(view)
  	
end

--点击建筑物回调接口
--table tableView控件 
--cell tableView中的某一个单元格
--返回值(无)
function UIBuildingList.tableCellTouched(table,cell)
    MyLog("cell touched at index: " .. cell:getIdx()+1)
    instance:moveBuildToPos(cell:getIdx())
end

--滑动建筑完毕后，都会因调这个接口
--view scrollview控件
--返回值(无)
function UIBuildingList.endScrollView(view)
	local pos = view:getContentOffset()
    MyLog("endScroll x=" .. pos.x .. "y=" .. pos.y)
    local idx = instance:getSelBuildingIdx(pos)
    instance.idx = idx
    MyLog("sel idx =",idx)
    
    local func = instance.eventHandlerTable[0]
    local obj = instance.eventObjTable[0]
    if nil == func or nil == obj then
        return
    end
    func(obj,idx)
end

--建筑列表放大，都会回调这个接口
--view scrollview控件
--返回值(无)
function UIBuildingList.scrollViewDidZoom(view)
    MyLog("scrollViewDidZoom")
end

--移动建筑到目标位置
--index 建筑id
--返回值(无)
function UIBuildingList:moveBuildToPos(index)
	local mid = self:getBuildlistMid()
	local dis = (mid - index)*(self:getBuildSize().height+self:getBuildOffset())
	self.buildList:moveToPos(cc.p(0,dis))
	MyLog("mid=",mid)
end

--获取选择的建筑
--pos 建筑位置
--返回值(建筑id)
function UIBuildingList:getSelBuildingIdx(pos)
	local mid = self:getBuildlistMid()
	local buildHigh = (self:getBuildSize().height+self:getBuildOffset())
	return mid - pos.y/buildHigh
end

--创建建筑接口
--table tableView控件
--idx 建筑id
function UIBuildingList.tableCellAtIndex(table, idx)
	local strValue = string.format("%d",idx)
	local cell = table:dequeueCell()
	local label = nil
	if nil == cell then
		local x = 0  
		
	    cell = cc.TableViewCell:new()
	    local sprite = cc.Sprite:create("citybuilding/buildingbg.png")
	    sprite:setAnchorPoint(cc.p(0,0))
	    sprite:setPosition(cc.p(x, 0))
	    cell:addChild(sprite)

	    --[[
	    label = cc.Label:createWithSystemFont(strValue, "Helvetica", 20.0)
	    label:setPosition(cc.p(x,0))
	    label:setAnchorPoint(cc.p(0,0))
	    label:setTag(123)
	    cell:addChild(label)
	    --]]
	else
		--[[
	    label = cell:getChildByTag(123)
	    if nil ~= label then
	        label:setString(strValue)
	    end
	    --]]
	end

	return cell
end

--创建建筑列表
--返回值(无)
function UIBuildingList:createBuildList()
	local tableView = cc.TableView:create(self:getBuildListSize())
	self.buildList = tableView
	tableView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	local pos = self:getBuildListPos()
	tableView:setPosition(pos)
	tableView:setCellDis(self:getBuildOffset())
	tableView:setMinContentOffset(self:getBuildMinBackValue())
	tableView:setMaxContentOffset(self:getBuildMaxBackValue())
	tableView:setDelegate()
	tableView:setVerticalFillOrder(cc.TABLEVIEW_FILL_BOTTOMUP)
	self:addChild(tableView)
	tableView:registerScriptHandler(UIBuildingList.scrollViewDidScroll,cc.SCROLLVIEW_SCRIPT_SCROLL)
	tableView:registerScriptHandler(UIBuildingList.endScrollView,cc.SCROLLVIEW_END_SCROLL)
	tableView:registerScriptHandler(UIBuildingList.scrollViewDidZoom,cc.SCROLLVIEW_SCRIPT_ZOOM)
	tableView:registerScriptHandler(UIBuildingList.tableCellTouched,cc.TABLECELL_TOUCHED)
	tableView:registerScriptHandler(UIBuildingList.cellSizeForTable,cc.TABLECELL_SIZE_FOR_INDEX)
	tableView:registerScriptHandler(UIBuildingList.tableCellAtIndex,cc.TABLECELL_SIZE_AT_INDEX)
	tableView:registerScriptHandler(UIBuildingList.numberOfCellsInTableView,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
	tableView:reloadData()
	tableView:setAdjustSize(self:getBuildSize().height+self:getBuildOffset())
	self:moveBuildToPos(0)
end

--获取建筑列表
--返回值(建筑列表)
function UIBuildingList:getBuildingList()
	local tab = {}
	local count = self:getBuildListRealCount()
	for i=0,count do
		local building = self.buildList:cellAtIndex(i)
		table.insert(tab,building) 
	end
	return tab
end

 --获取当前选中的建筑
 --返回值(建筑)
function UIBuildingList:getCurSelBuilding()
	return self.buildList:cellAtIndex(self.idx)
end



