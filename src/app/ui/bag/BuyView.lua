--
-- Author: oyhc
-- Date: 2015-12-07 17:31:39
--
BuyView = class("BuyView")

--构造
--theSelf 父级
function BuyView:ctor(theSelf)
	self.parent = theSelf
    self.model = self.parent.model
	self.bg = Common:seekNodeByName(self.parent.root,"bg_buy")
	self.view = Common:seekNodeByName(self.bg,"bg")
	----触摸检测用的
    self.touchableNode = display.newNode()
    self.touchableNode:setContentSize(display.width,display.height)
    self.bg:addChild(self.touchableNode)
	-- self:init()
end

--初始化
--id 物品
--返回值(无)
function BuyView:init(itemData)
	self.itemData = itemData
    -- 物品名称
    local lbl_name = Common:seekNodeByName(self.view,"lbl_name")
    lbl_name:setString(itemData.name)
    -- tip
    local lbl_tip = Common:seekNodeByName(self.view,"lbl_tip")
    -- 金币
    self.lbl_gold = Common:seekNodeByName(self.view,"lbl_gold")
    
    -- 数量
    self.lbl_num = Common:seekNodeByName(self.view,"lbl_num")
    self.lbl_num:setString("1")
    -- 刷新按钮
    self.btn_sure = Common:seekNodeByName(self.view,"btn_sure")
    self.btn_sure:addTouchEventListener(handler(self,self.onSure))
    self.btn_sure:setTitleText("确定")
    -- 加按钮
    self.btn_add = Common:seekNodeByName(self.view,"btn_add")
    self.btn_add:addTouchEventListener(handler(self,self.onAdd))
    -- 减按钮
    self.btn_sub = Common:seekNodeByName(self.view,"btn_sub")
    self.btn_sub:addTouchEventListener(handler(self,self.onSub))
    -- 数量控件
    self.slider_num = Common:seekNodeByName(self.view,"slider_num")
    self.slider_num:addEventListener(handler(self,self.onChangeSlider))
    --
    if self.model.kind == 1 then
        self.totalNum = 100
        lbl_tip:setString("请您选择购买此物品的数量")
        self.lbl_gold:setVisible(true)
        self.lbl_gold:setString("总价："..itemData.price.."金币")
    else
        self.totalNum = self.itemData.number
        lbl_tip:setString("请您选择使用物品的数量")
        self.lbl_gold:setVisible(false)
    end
    self.slider_num:setPercent(100 / self.totalNum)

    self:onChange()
end

--购买按钮回调
--sender 按钮本身
--eventType 事件类型
function BuyView:onSure(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        print("购买的id",self.itemData.id)
        print("类型：",self.model.kind)

        if self.model.kind == 1 then
            local total = self.itemData.price * self.lbl_num:getString()
            if total > PlayerData:getInstance().gold then
                -- 提示
                self.lbl_gold:setColor(cc.c3b(255, 0, 0))
                Prop:getInstance():showMsg("您的金币不足")
            else
                self.model.buyNum = self.lbl_num:getString()
                -- 购买 模板id 数量
                BagService:getInstance():sendBuyItem(self.itemData.templateId, self.lbl_num:getString())
            end
        else
            -- 使用物品 objId,templateId,number
            BagService:getInstance():sendUseItem(self.itemData.objId, self.itemData.templateId, self.lbl_num:getString())
        end
        
    end
end

--加按钮回调
--sender 按钮本身
--eventType 事件类型
function BuyView:onAdd(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self.slider_num:setPercent(self.slider_num:getPercent()+100 / self.totalNum)
        self:onChange()
    end
end

--减按钮回调
--sender 按钮本身
--eventType 事件类型
function BuyView:onSub(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self.slider_num:setPercent(self.slider_num:getPercent()-100 / self.totalNum)
        self:onChange()
    end
end

--滑动按钮改变回调
--sender 按钮本身
--eventType 事件类型
function BuyView:onChangeSlider(sender,eventType)
    
    --百分比 = 当前/总 * 100
    --当前的 = 百分比/100 * 总
    self:onChange()
end

function BuyView:onChange()
    if self.model.kind == 1 then
        self.lbl_num:setString(self.slider_num:getPercent())
        local total = self.itemData.price * self.lbl_num:getString()
        if total > PlayerData:getInstance().gold then
            -- 红色
            self.lbl_gold:setColor(cc.c3b(255, 0, 0))
        else
            -- 白色
            self.lbl_gold:setColor(cc.c3b(255, 255, 255))
        end
        self.lbl_gold:setString("总价：".. total .."金币")
    else
        -- print("···",self.slider_num:getPercent() .. self.totalNum)
        self.lbl_num:setString(Common:getFourHomesFive(self.slider_num:getPercent() / 100 * self.totalNum))
    end
    
end

--添加触摸事件
--返回值(无)
function BuyView:addTouchEvent()
    local function onTouchBegan(touch, event)
        return true
    end

    local function onTouchEnded(touch, event)
        local location = touch:getLocation()
        if not self:isClickLookView(cc.p(location.x, location.y)) and self.type ~= PROP_BOX_TYPE.DIS_CONNECT then
            -- UIMgr:getInstance():closeUI(self.uiType)
            self:hideView()
        end
    end

    self.listener = cc.EventListenerTouchOneByOne:create()
    self.listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    self.listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = self.touchableNode:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(self.listener, self.touchableNode)
end

--是否点击在侦察界面上
--pos 点击坐标
--返回值(true:BuyView:否)
function BuyView:isClickLookView(clickPos)
    local worldPos = self:getWorldPos(self.view)
    local size = self.view:getBoundingBox()
    worldPos.x = worldPos.x
    worldPos.y = worldPos.y
    
    if clickPos.x >= worldPos.x and clickPos.x <= worldPos.x + size.width and
        clickPos.y >= worldPos.y and clickPos.y <= worldPos.y + size.height then
        return true
    end
    return false
end

--获取世界坐标
--node 结点
--返回值(世界坐标)
function BuyView:getWorldPos(node)
    local x = node:getPositionX()
    local y = node:getPositionY()
    return node:getParent():convertToWorldSpace(cc.p(x,y))
end

-- 显示界面
function BuyView:showView()
	self.bg:setVisible(true)
	self:addTouchEvent()
end

-- 隐藏界面
function BuyView:hideView()
	self.bg:setVisible(false)
    -- 移除点击空白区域事件
    local eventDispatcher = self.touchableNode:getEventDispatcher()
    eventDispatcher:removeEventListener(self.listener)
end
