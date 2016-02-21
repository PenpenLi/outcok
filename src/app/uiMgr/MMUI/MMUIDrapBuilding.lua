
--[[
	jinyan.zhang
	拖拽建筑
--]]

MMUIDrapBuilding = class("MMUIDrapBuilding",function()
    return cc.Layer:create()
end)

local _spriteTag = 9000

function MMUIDrapBuilding:ctor(buildingType)
    self.buildingType = buildingType
    self:setNodeEventEnabled(true)
	self:init()
end

function MMUIDrapBuilding:init()
    --区域闪烁图片列表
    self.arryBlankImg = {}
    --网格坐标列表
    self.arryGridPos = {}
    --地图
    self.worldMap = MapMgr:getInstance():getWorldMap()
    --网格宽度
    self.gridWide = self.worldMap.mapTool:getTileWidth()
    --网格高度
    self.gridHigh = self.worldMap.mapTool:getTileHeight()  
    self.layer = ccui.Layout:create()
    self:addChild(self.layer)  
end

function MMUIDrapBuilding:onEnter()
    self.worldMap:setMapAble(false)
end

function MMUIDrapBuilding:onExit()
    self.worldMap:setMapAble(true)
end

--设置建筑图片路径
function MMUIDrapBuilding:setSpritePath(path)
    self.path = path
end 

--设置占用格子数
function MMUIDrapBuilding:setGridCount(count)
    self.gridCount = count
end

--设置建筑位置
function MMUIDrapBuilding:setPosition(pos)
    self.sprite:setPosition(pos)
end

--设置边缘
function MMUIDrapBuilding:setEdage(left,right,up,down)
    self.left = left
    self.right = right
    self.up = up
    self.down = down
end

--设置确定回调
function MMUIDrapBuilding:setSureCallback(callback,target)
    self.sureCallback = callback
    self.sureTarget = target
end

--设置取消回调
function MMUIDrapBuilding:setCancelCallback(callback,target)
    self.cancelCallback = callback
    self.cancelTarget = target
end

--确定回调
function MMUIDrapBuilding:onSure(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        if self.sureCallback ~= nil then
            self.sureCallback(self.sureTarget)
        end
    end
end

--取消回调
function MMUIDrapBuilding:onCancel(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        if self.cancelCallback ~= nil then
            self.cancelCallback(self.cancelTarget)
        end
    end
end

--创建
function MMUIDrapBuilding:create()
    if self.arryGridPos == nil or self.path == nil then
        return
    end

    --建筑图片
    self.sprite = ccui.ImageView:create("")
    self.sprite:loadTexture(self.path,ccui.TextureResType.plistType)
    self.layer:addChild(self.sprite,1)
    self.sprite:setTag(_spriteTag)
    self:setPosition(self:calSpritePos())
    self:setTouchEnabled(true)
    self.sprite:setOpacity(150)

    --确定
    self.btnSure = ccui.Button:create()
    self.btnSure:loadTextureNormal("btn_blue.png",ccui.TextureResType.plistType)
    self.sprite:addChild(self.btnSure,0,2000)
    self.btnSure:setScale(0.6)
    self.btnSure:setTitleText(Lan:lanText(222, "放置"))
    self.btnSure:setTitleFontSize(30)
    self.btnSure:addTouchEventListener(handler(self,self.onSure))

    --取消
    self.btnCancel = ccui.Button:create()
    self.btnCancel:loadTextureNormal("btn_blue.png",ccui.TextureResType.plistType)
    self.sprite:addChild(self.btnCancel,0,2001)
    self.btnCancel:setScale(0.6)
    self.btnCancel:setTitleText(Lan:lanText(51, "取消"))
    self.btnCancel:setTitleFontSize(30)
    self.btnCancel:addTouchEventListener(handler(self,self.onCancel))

    for k,v in pairs(self.arryGridPos) do
        local blankImg = UICommon:getInstance():createBlankNode("outsidemap/green.png",self.layer)
        blankImg:setPosition(v.pos)
        blankImg:setTag(k+_spriteTag)
        table.insert(self.arryBlankImg,blankImg)

        local label = display.newTTFLabel({
            text = "",
            font = "Arial",
            size = 26,
            color = cc.c3b(255, 0, 0), -- 使用纯红色
        })
        label:setString("" .. k)
        blankImg:addChild(label)
        label:setPosition(80,30)
    end

    local arrySortGirdPosX = clone(self.arryGridPos)
    local arrySortGridPosY = clone(self.arryGridPos)
    table.sort(arrySortGirdPosX,function(a,b) return a.pos.x < b.pos.x end)
    table.sort(arrySortGridPosY,function(a,b) return a.pos.y < b.pos.y end)
    local pos = cc.p(arrySortGirdPosX[1].pos.x,arrySortGridPosY[1].pos.y)
    local newPos = self.sprite:convertToNodeSpace(pos)
    newPos.y = newPos.y - self.gridHigh/2-20

    if self.gridCount == 4 then
        self.btnSure:setPosition(newPos.x-20,newPos.y)
        self.btnCancel:setPosition(newPos.x+self.sprite:getBoundingBox().width+20,newPos.y)
    elseif self.gridCount == 1 then
        self.btnSure:setPosition(newPos.x-self.btnSure:getBoundingBox().width/2-20,newPos.y)
        self.btnCancel:setPosition(newPos.x+self.btnSure:getBoundingBox().width/2+20,newPos.y)
    end
end

--使能/禁止触摸
function MMUIDrapBuilding:setTouchEnabled(able)
    local function onTouch(touch)
        local clickPos = touch:getLocation()
        local diff = cc.pSub(clickPos,self.oldPos)
        local x,y = self.sprite:getPosition()
        local curPos = cc.p(x,y)
        local newPos = cc.pAdd(curPos,diff)
        self.sprite:setPosition(newPos)
        self.oldPos = clickPos
        self:moveGridPos(diff)
    end

    local function onTouchBegan(touch, event)
        self.worldMap:setMapAble(false)
        local clickPos = touch:getLocation()
        for k,v in pairs(self.arryBlankImg) do
            if UICommon:getInstance():isClickNode(v,clickPos) then
                self.oldPos = clickPos
                self:onTouch(touch)
                self:createClone()
                return true
            end
        end 
        return false
    end

    local function onTouchMoved(touch, event)
        onTouch(touch)
    end

    local function onTouchEnded(touch, event)
        onTouch(touch)
        self:createClone2()
    end

    if able == self.isEnabled then
        return
    end

    self.isEnabled = able

    if self.isEnabled then
        local listener = cc.EventListenerTouchOneByOne:create()
        listener:setSwallowTouches(true)
        listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
        listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
        listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
        local eventDispatcher = self:getEventDispatcher()
        eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
        self.listener = listener
    else
        self:getEventDispatcher():removeEventListener(self.listener)
    end
end

--复制一个建筑层
function MMUIDrapBuilding:createClone()
    local screenPos = Common:converToWorldPos(self.sprite)

    local cloneSprite = self.sprite:clone()
    cloneSprite:retain()
    cloneSprite:removeFromParent()
    SceneMgr:getInstance():getUILayer():addChild(cloneSprite)
    self.sprite:removeFromParent()
    self.sprite = cloneSprite
    self.sprite:setPosition(screenPos)
end

--复制一个建筑层
function MMUIDrapBuilding:createClone2()
    local x,y = self.sprite:getPosition()
    local pos = self.layer:convertToNodeSpace(cc.p(x,y))
    self.sprite:setPosition(pos)

    local cloneSprite = self.sprite:clone()
    cloneSprite:retain()
    cloneSprite:removeFromParent()
    self.layer:addChild(cloneSprite)
    self.sprite:removeFromParent()
    self.sprite = cloneSprite
    self.btnSure = cloneSprite:getChildByTag(2000)
    self.btnSure:addTouchEventListener(handler(self,self.onSure))
    self.btnCancel = cloneSprite:getChildByTag(2001)
    self.btnCancel:addTouchEventListener(handler(self,self.onCancel))
end

--计算精灵位置
function MMUIDrapBuilding:calSpritePos()
    local pos = {}
    local count = #self.arryGridPos
    if count == 1 then
        pos = self.arryGridPos[1].pos
    elseif count == 4 then
        pos.x = (self.arryGridPos[1].pos.x + self.arryGridPos[2].pos.x)/2
        pos.y = (self.arryGridPos[3].pos.y + self.arryGridPos[4].pos.y)/2
    end
    return pos
end

--计算格子坐标
function MMUIDrapBuilding:calPosByGridPos(firstGridPos)
    if self.worldMap == nil or firstGridPos == nil then
        return
    end

    local arry = {}
    --第一个网格坐标如果就在边界的话，就不执行移动了
    local oneGirdPos = cc.p(firstGridPos.x,firstGridPos.y)
    local pos = self.worldMap:worldGridPosToScreenPos(oneGirdPos)
    if pos == nil then
        return
    end

    local info = {}
    info.gridPos = oneGirdPos
    info.pos = pos
    info.order = 1
    table.insert(arry,info)

    --建筑占用四个网格
    if self.gridCount == 4 then
        local secondGridPos = nil
        local value,yu = math.modf(firstGridPos.y/2)
        if yu ~= 0 then
            secondGridPos = cc.p(firstGridPos.x-1,firstGridPos.y)
        else
            secondGridPos = cc.p(firstGridPos.x+1,firstGridPos.y)
        end
        local pos2 = self.worldMap:worldGridPosToScreenPos(secondGridPos)
        local info = {}
        info.gridPos = secondGridPos
        info.pos = pos2
        info.order = 2
        if info.pos ~= nil then
            table.insert(arry,info)
        else
           return 
        end

        local thirdGirdPos = cc.p(firstGridPos.x,firstGridPos.y+1)
        local pos3 = self.worldMap:worldGridPosToScreenPos(thirdGirdPos)
        local info = {}
        info.gridPos = thirdGirdPos
        info.pos = pos3
        info.order = 3
        if info.pos ~= nil then
            table.insert(arry,info)
        else
            return 
        end

        local fourthGridPos = cc.p(firstGridPos.x,firstGridPos.y-1)
        local pos4 = self.worldMap:worldGridPosToScreenPos(fourthGridPos)
        local info = {}
        info.gridPos = fourthGridPos
        info.pos = pos4
        info.order = 4
        if info.pos ~= nil then
            table.insert(arry,info)
        else
            return
        end
    end
    self.arryGridPos = arry
end

--重新设置闪烁的图片
function MMUIDrapBuilding:resetSetBlankImgList()
    if self.arryGridPos == nil then
        return
    end

    for k,v in pairs(self.arryBlankImg) do
        local pos = self.arryGridPos[k].pos
        v:setPosition(pos)
        local gridPos = self.arryGridPos[k].gridPos
        if CheckObstacle:getInstance():isHaveBlock(gridPos) then
            v:loadTexture("outsidemap/red.png")
        else
            v:loadTexture("outsidemap/green.png")
        end

        if self:isOverEdage(gridPos) then
            v:loadTexture("outsidemap/red.png")
        end
    end
end

--是否超出边缘
function MMUIDrapBuilding:isOverEdage(gridPos)
    if gridPos.x < self.left or gridPos.x > self.right
        or gridPos.y < self.down or gridPos.y > self.up then
        return true
    end
    return false
end

--获取所在的网格坐标
function MMUIDrapBuilding:getGridPos()
    local arry = {}
    for k,v in pairs(self.arryGridPos) do
        table.insert(arry,v.gridPos)
    end
    return arry
end

--移动网格坐标
function MMUIDrapBuilding:moveGridPos()
    local x,y = self.sprite:getPosition()
    local pos = cc.p(x,y)

    local gridPos,mapInfo = self.worldMap.mapTool:getCurClickWorldGrid(pos)
    if gridPos == nil or mapInfo == nil then
        return
    end

    if self.worldMap.mapTool:isClickMapEdage(gridPos, mapInfo) then
        return
    end

    self:calPosByGridPos(gridPos)
    self:resetSetBlankImgList()

    if x + self.gridWide >= display.width then
        self.worldMap:setScrollDis(cc.p(-16.5,0))
    elseif x - self.gridWide <= 0 then
        self.worldMap:setScrollDis(cc.p(16.5,0))
    end

    if y + self.gridHigh >= display.height then
        self.worldMap:setScrollDis(cc.p(0,-24.5))
    elseif y - self.gridHigh <= 0 then
        self.worldMap:setScrollDis(cc.p(0,24.5))
    end
end



