
--[[
	jinyan.zhang
	触摸滑动后出现删除按钮功能
--]]

local g_id = 0

MMUITouchLayer = class("MMUITouchLayer",function()
	return display.newLayer()
end)

function MMUITouchLayer:ctor()
    g_id = g_id + 1
    self.id = g_id
	self:init()
end

function MMUITouchLayer:init()
	self.checkNode = {}  --待检测结点
    self.isEnable = true

    self.touchableNode = display.newNode()
    self.touchableNode:setContentSize(display.width,display.height)
    self:addChild(self.touchableNode)

    self.touchableNode:setTouchEnabled(true)
    self.touchableNode:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)
    self.touchableNode:setTouchSwallowEnabled(false)
    self.touchableNode:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
        if event.name == "began" and self.isEnable then
            self:touchBegin(cc.p(event.x,event.y))
        elseif event.name == "moved" and self.isEnable then
            self:touchMove(cc.p(event.x,event.y))
        elseif event.name == "ended" and self.isEnable then
            self:touchEnd()
        end
        return true
    end)
end

function MMUITouchLayer:clearData()
	self.checkNode = {}  --待检测结点
	self.clickNodeInfo = nil
    self.isMoveing = false
    self.moveX = nil
    self.action = nil
end

--使能触摸
function MMUITouchLayer:setAble(able)
    self.isEnable = able
    --print("albe=",able,"id=",self.id)
end

--添加检测数据
function MMUITouchLayer:addData(index,rowBg,moveNode,targetX,callback,obj,data)
    local info = {}
    info.index = index  			--第几行
    info.rowBg = rowBg	  			--行背景
    info.moveNode = moveNode 		--待移动的结点
    info.targetX = targetX   		--移动的目标X位置
    info.callback = callback   		--回调函数
    info.obj = obj 					--回调函数类实例
    info.data = data                --数据
    table.insert(self.checkNode,info)
end

--是否点击在目标结点上
--clickPos 点击坐标
--node 目标结点
--返回值(true:是，false:否)
function MMUITouchLayer:isClicNode(clickPos,node)
    local worldPos = Common:converToWorldPos(node)
    local size = node:getBoundingBox()
    worldPos.x = worldPos.x - size.width*node:getAnchorPoint().x
    worldPos.y = worldPos.y - size.height*node:getAnchorPoint().y
    
    if clickPos.x >= worldPos.x and clickPos.x <= worldPos.x + size.width and
        clickPos.y >= worldPos.y and clickPos.y <= worldPos.y + size.height then
        return true
    end

    return false
end

--获取点击信息
function MMUITouchLayer:getClickIndex(clickPos)
    for k,v in pairs(self.checkNode) do
        if self:isClicNode(clickPos,v.rowBg) then
            return v
        end
    end
end

function MMUITouchLayer:touchBegin(pos)
    --print("MMUITouchLayer touchBegin id=",self.id)
	if self.clickNodeInfo ~= nil then
		local curX = self.clickNodeInfo.moveNode:getPositionX()
		if curX ~= 0 and self.moveX ~= 0 then
			self:move()
			return
		end
	end

    self.beginPos = pos
    self.clickNodeInfo = self:getClickIndex(self.beginPos)
end

function MMUITouchLayer:touchMove(movePos)
    if self.clickNodeInfo == nil then
        return
    end

    if self.isMoveing then
        self.beginPos = movePos
        return
    end

    local curX = self.clickNodeInfo.moveNode:getPositionX()
    local moveX = movePos.x - self.beginPos.x
    self.beginPos = movePos
    local x = curX + moveX 
    if x > 0 then
        return
    elseif x < self.clickNodeInfo.targetX then
        return
    end
    self.clickNodeInfo.moveNode:setPositionX(x)
end

function MMUITouchLayer:touchEnd()
    if self.clickNodeInfo == nil then
        return
    end

    if self.isMoveing then
        return
    end

    local moveX = 0
    local curX = self.clickNodeInfo.moveNode:getPositionX()
    if curX == 0 or curX == math.abs(self.clickNodeInfo.targetX) then
    	if self.clickNodeInfo.callback ~= nil then
    		self.clickNodeInfo.callback(self.clickNodeInfo.obj,self.clickNodeInfo.index,self.clickNodeInfo.data)
    	end
        return
    end

    if math.abs(curX) < math.abs(self.clickNodeInfo.targetX)/2 then  --移动距离太小，往回弹
        moveX = 0
    else
        moveX = self.clickNodeInfo.targetX
    end
    self.moveX = moveX

    local sequence = transition.sequence({
        cc.MoveTo:create(0.1, cc.p(moveX,0)),
        cc.CallFunc:create(function()
            self.isMoveing = false  --完成移动
            self.action = nil
        end),
    })
    self.action = sequence
    self.clickNodeInfo.moveNode:runAction(sequence)
    self.isMoveing = true
end

function MMUITouchLayer:move()
	local moveX = 0
	self.moveX = moveX

    local sequence = transition.sequence({
        cc.MoveTo:create(0.1, cc.p(moveX,0)),
        cc.CallFunc:create(function()
            self.isMoveing = false  --完成移动
        end),
    })
   	self.clickNodeInfo.moveNode:stopAction(self.action)
    self.clickNodeInfo.moveNode:runAction(sequence)
    self.isMoveing = true
end
