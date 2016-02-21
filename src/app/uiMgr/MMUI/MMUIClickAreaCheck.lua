
--[[
	jinyan.zhang
	是否点击在指定图片区域中
--]]

MMUIClickAreaCheck = class("MMUIClickAreaCheck",function()
    return cc.Layer:create()
end)

function MMUIClickAreaCheck:ctor(imgCheck,callback,obj)
	self.imgCheck = imgCheck
    self.callback = callback
    self.obj = obj
	self:init()
end

function MMUIClickAreaCheck:init()

end

function MMUIClickAreaCheck:setTouchEnabled(able)
    local function onTouchBegan(touch, event)
        if self:isClickView(touch:getLocation()) then
            -- print("点击在里面")
        else
            -- print("点击在外面")
            if self.callback ~= nil then
                self.isReadyClose = true
             end
        end
        return true
    end

    local function onTouchEnded(touch, event)
        if self.isReadyClose then
            self.isReadyClose = false
            self.callback(self.obj)
        end
    end

    if able == self.isEnabled then
        return
    end
    self.isEnabled = able

    if self.isEnabled then
        local listener = cc.EventListenerTouchOneByOne:create()
        listener:setSwallowTouches(false)
        listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
        listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
        local eventDispatcher = self:getEventDispatcher()
        eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
        self.listener = listener
    else
        self:getEventDispatcher():removeEventListener(self.listener)
    end
end

--是否点击在界面上
--pos 点击坐标
--返回值(true:是，false:否)
function MMUIClickAreaCheck:isClickView(clickPos)
	if self.imgCheck == nil then
		print("检测图片是空的,数据有错")
		return false
	end

    local worldPos = Common:converToWorldPos(self.imgCheck)
    local size = self.imgCheck:getBoundingBox()
    worldPos.x = worldPos.x - size.width*self.imgCheck:getAnchorPoint().x
    worldPos.y = worldPos.y - size.height*self.imgCheck:getAnchorPoint().y

    if clickPos.x >= worldPos.x and clickPos.x <= worldPos.x + size.width and
        clickPos.y >= worldPos.y and clickPos.y <= worldPos.y + size.height then
        return true
    end

    return false
end

