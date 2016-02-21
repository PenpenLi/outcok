
--[[
	jinyan.zhang
	野外建筑
--]]

MMUIOutBuildingView = class("MMUIOutBuildingView",function()
	return cc.Layer:create()
end)

local _spriteTag = 1000

function MMUIOutBuildingView:ctor(buildingType,level)
	self.buildingType = buildingType
	self.level = level
	self:init()
end

function MMUIOutBuildingView:init()
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

--设置建筑图片路径
function MMUIOutBuildingView:setSpritePath(path)
    self.path = path
end 

--设置占用格子数
function MMUIOutBuildingView:setGridCount(count)
    self.gridCount = count
end

--设置建筑位置
function MMUIOutBuildingView:setPosition(pos)
    self.sprite:setPosition(pos)
end 

--设置建筑实例id
function MMUIOutBuildingView:setInstanceId(id)
    self.instanceId = id
end

--设置建筑放置id
function MMUIOutBuildingView:setPlaceId(id)
    self.placeId = id
end

--创建
function MMUIOutBuildingView:create()
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

    --说明
    if self.buildingType >= BuildType.out_farmland and 
        self.buildingType <= BuildType.out_goldoreField then
        self.btnExplain = ccui.Button:create()
        self.btnExplain:loadTextureNormal("btn_blue.png",ccui.TextureResType.plistType)
        self.sprite:addChild(self.btnExplain,0,2000)
        self.btnExplain:setScale(0.6)
        self.btnExplain:setTitleText(Lan:lanText(223, "说明"))
        self.btnExplain:setTitleFontSize(30)
        self.btnExplain:addTouchEventListener(handler(self,self.onExplain))
    end

    --收回
    self.btnTakeBack = ccui.Button:create()
    self.btnTakeBack:loadTextureNormal("btn_blue.png",ccui.TextureResType.plistType)
    self.sprite:addChild(self.btnTakeBack,0,2001)
    self.btnTakeBack:setScale(0.6)
    self.btnTakeBack:setTitleText(Lan:lanText(224, "收回"))
    self.btnTakeBack:setTitleFontSize(30)
    self.btnTakeBack:addTouchEventListener(handler(self,self.onTakeBack))

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
    self:hideBlankImg()

    local arrySortGirdPosX = clone(self.arryGridPos)
    local arrySortGridPosY = clone(self.arryGridPos)
    table.sort(arrySortGirdPosX,function(a,b) return a.pos.x < b.pos.x end)
    table.sort(arrySortGridPosY,function(a,b) return a.pos.y < b.pos.y end)
    local pos = cc.p(arrySortGirdPosX[1].pos.x,arrySortGridPosY[1].pos.y)
    local newPos = self.sprite:convertToNodeSpace(pos)
    newPos.y = newPos.y - self.gridHigh/2-20

    if self.gridCount == 4 then
        if self.btnExplain ~= nil then
            self.btnExplain:setPosition(newPos.x-20,newPos.y)
            self.btnTakeBack:setPosition(newPos.x+self.sprite:getBoundingBox().width+20,newPos.y)
        else
            self.btnTakeBack:setPosition(newPos.x,newPos.y)
        end
    elseif self.gridCount == 1 then
        if self.btnExplain ~= nil then
            self.btnExplain:setPosition(newPos.x-self.btnExplain:getBoundingBox().width/2-20,newPos.y)
            self.btnTakeBack:setPosition(newPos.x+self.btnExplain:getBoundingBox().width/2+20,newPos.y)
        else
            self.btnTakeBack:setPosition(newPos.x,newPos.y)
        end
    end
end

--显示闪烁图片
function MMUIOutBuildingView:showBlankImg()
	for k,v in pairs(self.arryBlankImg) do
		v:setVisible(true)
	end
    if self.btnExplain ~= nil then
        self.btnExplain:setVisible(true)
    end    
    self.btnTakeBack:setVisible(true)
end

--隐藏闪烁图片
function MMUIOutBuildingView:hideBlankImg()
	for k,v in pairs(self.arryBlankImg) do
		v:setVisible(false)
	end
    if self.btnExplain ~= nil then
        self.btnExplain:setVisible(false)
    end
    self.btnTakeBack:setVisible(false)
end

--计算精灵位置
function MMUIOutBuildingView:calSpritePos()
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
function MMUIOutBuildingView:calPosByGridPos(firstGridPos)
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

--说明按钮回调
function MMUIOutBuildingView:onExplain(sender,eventType)
    if eventType == ccui.TouchEventType.ended then

    end
end

--收回按钮回调
function MMUIOutBuildingView:onTakeBack(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        PlaceBuildingService:getInstance():takeBuildingReq(self.instanceId,self.placeId)
    end
end


