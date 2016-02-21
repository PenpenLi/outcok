
--[[
	jinyan.zhang
	心跳包检测
--]]

PropBoxView = class("PropBoxView",UIBaseView)

PROP_BOX_TYPE =
{
	DIS_CONNECT = 1, --断线重连
	REMOVE_BUILDING = 2, --移除建筑
    COMMON = 3,  --通用提示框
    MONEY_ACCELERATION = 4,  --金钱加速提示框
    BUY = 5, --购买提示框
    SIGINAL_BTN = 6,        --单个按钮的提示框
}

--构造
--uiType UI类型
--data 数据
--返回值(无)
function PropBoxView:ctor(uiType,data)
	self.type = data.type
	self.text = data.text
	self.callback = data.callback
    self.time = data.time
    self.buildingPos = data.buildingPos
    self.sureBtnText = data.sureBtnText
    self.cancelBtnText = data.cancelBtnText
    self.timeText = data.timeText
	self.super.ctor(self,uiType)
    self:adapterSize()
end

--初始化
--返回值(无)
function PropBoxView:init()
	self.root = Common:loadUIJson(PROP_BOX_HEAD)
    self:addChild(self.root)

    self.bgImg = Common:seekNodeByName(self.root,"Image1")
    self.bgImg2 = Common:seekNodeByName(self.root,"Image2")
    self.bgImg3 = Common:seekNodeByName(self.root,"Image3")
    self.bgImg4 = Common:seekNodeByName(self.root,"Image4")

    self.sure1Btn = Common:seekNodeByName(self.root,"sure1Btn")
    self.sure1Btn:addTouchEventListener(handler(self,self.sureBtnCallback))
    self.sure1Btn:setTitleText("确定")

    self.sure2Btn = Common:seekNodeByName(self.root,"sure2Btn")
    self.sure2Btn:addTouchEventListener(handler(self,self.sureBtnCallback))
    self.sure2Btn:setTitleText("确定")

    self.sure4Btn = Common:seekNodeByName(self.root,"sure4Btn")
    self.sure4Btn:addTouchEventListener(handler(self,self.sureBtnCallback))
    self.sure4Btn:setTitleText("确定")

    --取消按钮2
    self.cancel2Btn = Common:seekNodeByName(self.root,"cancel2Btn")
    self.cancel2Btn:addTouchEventListener(handler(self,self.cancelBtnCallback))
    self.cancel2Btn:setTitleText("取消")

    --取消按钮
    self.cancel3Btn = Common:seekNodeByName(self.root,"cancel3Btn")
    self.cancel3Btn:addTouchEventListener(handler(self,self.cancelBtnCallback))
    self.cancel3Btn:setTitleText("取消")

    self.cancel4Btn = Common:seekNodeByName(self.root,"cancel4Btn")
    self.cancel4Btn:addTouchEventListener(handler(self,self.cancelBtnCallback))

    --拆除按钮
    self.demolitionBtn = Common:seekNodeByName(self.root,"sure3Btn")
    self.demolitionBtn:addTouchEventListener(handler(self,self.sureBtnCallback))

    self.pan1Layer = Common:seekNodeByName(self.root,"Panel_1")
    self.pan2Layer = Common:seekNodeByName(self.root,"Panel_2")
    self.pan3Layer = Common:seekNodeByName(self.root,"Panel_3")
    self.pan4Layer = Common:seekNodeByName(self.root,"Panel_4")


   	self.title1Lab = Common:seekNodeByName(self.root,"title1Lab")
   	self.title2Lab = Common:seekNodeByName(self.root,"title2Lab")
    self.title3Lab = Common:seekNodeByName(self.root,"title3Lab")
    self.title4Lab = Common:seekNodeByName(self.root,"title4Lab")
    self.time3Lab = Common:seekNodeByName(self.root,"time3Lab")
    self.sure3Lab = Common:seekNodeByName(self.root,"sure3Lab")
    self.time4Lab = Common:seekNodeByName(self.root,"time4Lab")
    self.sure4Lab = Common:seekNodeByName(self.root,"sure4Lab")
    self.text1 = Common:seekNodeByName(self.root,"text1")
    self.text2 = Common:seekNodeByName(self.root,"text2")

    --触摸检测用的
    self.touchableNode = display.newNode()
    self.touchableNode:setContentSize(display.width,display.height)
    self:addChild(self.touchableNode)
end

--获取世界坐标
--node 结点
--返回值(世界坐标)
function PropBoxView:getWorldPos(node)
    local x = node:getPositionX()
    local y = node:getPositionY()
    return node:getParent():convertToWorldSpace(cc.p(x,y))
end

--是否点击在侦察界面上
--pos 点击坐标
--返回值(true:是，false:否)
function PropBoxView:isClickLookView(clickPos)
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

--取消按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function PropBoxView:cancelBtnCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        UIMgr:getInstance():closeUI(self.uiType)
    end
end

--获取建筑位置
--返回值(建筑位置)
function PropBoxView:getBuildingPos()
    return self.buildingPos
end

--确定按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function PropBoxView:sureBtnCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        if self.callback ~= nil then
        	self.callback()
        end
        UIMgr:getInstance():closeUI(self.uiType)
    end
end

function PropBoxView:onEnter()
	if self.type == PROP_BOX_TYPE.DIS_CONNECT or self.type == PROP_BOX_TYPE.SIGINAL_BTN then
		self.pan1Layer:setVisible(true)
		self.pan2Layer:setVisible(false)
        self.pan3Layer:setVisible(false)
        self.pan4Layer:setVisible(false)
	elseif self.type == PROP_BOX_TYPE.REMOVE_BUILDING then
        self.pan1Layer:setVisible(false)
        self.pan2Layer:setVisible(false)
        self.pan3Layer:setVisible(true)
        self.pan4Layer:setVisible(false)
        self.time3Lab:setString(Common:getFormatTime(self.time))
    elseif self.type == PROP_BOX_TYPE.COMMON then
        self.pan1Layer:setVisible(false)
        self.pan2Layer:setVisible(true)
        self.pan3Layer:setVisible(false)
        self.pan4Layer:setVisible(false)
        self.sure2Btn:setTitleText(self.sureBtnText)
        self.cancel2Btn:setTitleText(self.cancelBtnText)
    elseif self.type == PROP_BOX_TYPE.MONEY_ACCELERATION then
        self.pan1Layer:setVisible(false)
        self.pan2Layer:setVisible(false)
        self.pan3Layer:setVisible(false)
        self.pan4Layer:setVisible(true)
    elseif self.type == PROP_BOX_TYPE.BUY then
        self.pan1Layer:setVisible(true)
        self.pan2Layer:setVisible(false)
        self.pan3Layer:setVisible(false)
        self.pan4Layer:setVisible(false)
        self.text1:setVisible(true)
        self.text2:setVisible(true)
        self.sure1Btn:setTitleText("")
        self.text1:setString(self.sureBtnText)
        self.text2:setString(self.cancelBtnText)
    end

	if self.text ~= nil then
   		self.title1Lab:setString(self.text)
   		self.title2Lab:setString(self.text)
        self.title3Lab:setString(self.text)
        self.title4Lab:setString(self.text)
        self.time4Lab:setString(self.timeText)
   	end

    self:addTouchEvent()

    self.bgImg:setScale(0)
    self.bgImg2:setScale(0)
    self.bgImg3:setScale(0)
    self.bgImg4:setScale(0)
    local actionTo = cc.ScaleTo:create(0.1, 1)
    self.bgImg:runAction(actionTo)
    local actionTo2 = cc.ScaleTo:create(0.1, 1)
    self.bgImg2:runAction(actionTo2)
    local actionTo3 = cc.ScaleTo:create(0.1, 1)
    self.bgImg3:runAction(actionTo3)
    local actionTo4 = cc.ScaleTo:create(0.1, 1)
    self.bgImg4:runAction(actionTo4)
end

--添加触摸事件
--返回值(无)
function PropBoxView:addTouchEvent()
    local function onTouchBegan(touch, event)
        return true
    end

    local function onTouchEnded(touch, event)
        local location = touch:getLocation()
        if not self:isClickLookView(cc.p(location.x, location.y)) and self.type ~= PROP_BOX_TYPE.DIS_CONNECT then
            UIMgr:getInstance():closeUI(self.uiType)
        end
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self.touchableNode:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.touchableNode)
end

function PropBoxView:onExit()

end

function PropBoxView:onDestroy()

end


