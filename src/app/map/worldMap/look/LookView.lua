--[[
    jinyan.zhang
    侦察界面
--]]

LookView = class("LookView",UIBaseView)

--构造
--uiType UI类型
--data 数据
--返回值(无)
function LookView:ctor(uiType,data)
    self.data = data
    self.super.ctor(self,uiType)
    self:adapterSize()
end

--初始化
--返回值(无)
function LookView:init() 
    self.root = Common:loadUIJson(LOOK_HEAD)
    self:addChild(self.root)
    self.root:setTouchEnabled(false)

    --触摸检测用的
    self.touchableNode = display.newNode()
    self.touchableNode:setContentSize(display.width,display.height)
    self:addChild(self.touchableNode)

    --背景
    self.bgImg = Common:seekNodeByName(self.root,"Image_2")
    --粮食
    self.foodlab = Common:seekNodeByName(self.root,"foodlab")
    --时间
    self.timelab = Common:seekNodeByName(self.root,"timelab")
    --x坐标
    self.xlab = Common:seekNodeByName(self.root,"xlab")
    --y坐标
    self.ylab = Common:seekNodeByName(self.root,"ylab")

    --侦察按钮
    self.lookBtn = Common:seekNodeByName(self.root,"lookbtn")
    self.lookBtn:addTouchEventListener(handler(self,self.lookBtnCallback))
    self.lookBtn:setTouchSwallowEnabled(true) 
end

--UI加到舞台后都会调用这个接口
--返回值(无)
function LookView:onEnter()
    --MyLog("LookView onEnter...")

    self.foodlab:setString("" .. self.data.castFood)
    self.timelab:setString(Common:getFormatTime(self.data.castTime))
    self.xlab:setString("x: " .. self.data.targetGridPos.x)
    self.ylab:setString("y: " .. self.data.targetGridPos.y)
    if PlayerData:getInstance().food < self.data.castFood then
        self.foodlab:setColor(cc.c3b(255, 0, 0))
    end

    self.touchableNode:setTouchMode(cc.TOUCHES_ONE_BY_ONE)  
    self.touchableNode:setTouchEnabled(true)
    self.touchableNode:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "ended" then
            if not self:isClickLookView(cc.p(event.x, event.y)) then
                UIMgr:getInstance():closeUI(self.uiType)
            end
        end
        return true
    end)
end

--UI离开舞台后都会调用这个接口
--返回值(无)
function LookView:onExit()
    --MyLog("LookView onExit()")
end

--析构函数(此时已经从内存中释放掉资源了)
--返回值(无)
function LookView:onDestroy()
    --MyLog("LookView:onDestroy")
end

function LookView:getWorldPos(node)
    local x = node:getPositionX()
    local y = node:getPositionY()
    return node:getParent():convertToWorldSpace(cc.p(x,y))
end

--是否点击在侦察界面上
--pos 点击坐标
--返回值(true:是，false:否)
function LookView:isClickLookView(clickPos)
    local worldPos = self:getWorldPos(self.bgImg)
    local size = self.bgImg:getBoundingBox()
    worldPos.x = worldPos.x - size.width/2
    worldPos.y = worldPos.y - size.height/2
    
    if clickPos.x >= worldPos.x and clickPos.x <= worldPos.x + size.width and
        clickPos.y >= worldPos.y and clickPos.y <= worldPos.y + size.height then
        return true
    end

    return false
end

--侦察按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function LookView:lookBtnCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        if PlayerData:getInstance().food < self.data.castFood then
            Prop:getInstance():showMsg(CommonStr.FOOD_NO_ENOUGH)
            return            
        end
        
        if PlayerMarchModel:getInstance():isCanMarch() then
            PlayerMarchService:getInstance():sendMarchReq(nil,1,self.data.targetGridPos.x,self.data.targetGridPos.y,MarchOperationType.reconnaissance)
            UIMgr:getInstance():closeUI(self.uiType)
        end
    end
end



