--
-- Author: oyhc
-- Date: 2015-12-04 15:51:58
--
BagView = class("BagView",UIBaseView)

--构造
--uiType UI类型
--data 数据
function BagView:ctor(uiType,data)
	--父类构造
	self.super.ctor(self,uiType)
	--适配屏幕
    self:adapterSize()
end

--初始化
--返回值(无)
function BagView:init()
	self.root = Common:loadUIJson(BAG_PATH)
	self.root:setTouchEnabled(false)
    self:addChild(self.root)
    --
    --数据层
    self.model = BagModel:getInstance()
    --主界面层容器
    self.view = Common:seekNodeByName(self.root,"bg")
    --购买界面
    self.buyView = BuyView.new(self)
    -- 隐藏购买界面
    self.buyView:hideView()
    -- 关闭按钮
    self.btn_back = Common:seekNodeByName(self.view,"btn_back")
    self.btn_back:addTouchEventListener(handler(self,self.onBack))
    -- 标题
    local lbl_title = Common:seekNodeByName(self.view,"lbl_title")
    lbl_title:setString("背包")
    -- 金币
    self.lbl_gold = Common:seekNodeByName(self.view,"lbl_gold")
    self.lbl_gold:setString(PlayerData:getInstance().gold)
    -- 物品按钮
    self.btn_item = Common:seekNodeByName(self.view,"btn_item")
    self.btn_item:addTouchEventListener(handler(self,self.onItem))
    self.btn_item:setTitleText("物品")
    self.btn_item:setBright(false)
    -- 商场按钮
    self.btn_shop = Common:seekNodeByName(self.view,"btn_shop")
    self.btn_shop:addTouchEventListener(handler(self,self.onShop))
    self.btn_shop:setTitleText("商场")
    -- 军事按钮
    self.btn_army = Common:seekNodeByName(self.view,"btn_army")
    self.btn_army:addTouchEventListener(handler(self,self.onArmy))
    self.btn_army:setTitleText("军事")
    self.btn_army:setBright(false)
    -- 物资按钮
    self.btn_res = Common:seekNodeByName(self.view,"btn_res")
    self.btn_res:addTouchEventListener(handler(self,self.onRes))
    self.btn_res:setTitleText("物资")
    -- 加速按钮
    self.btn_speed = Common:seekNodeByName(self.view,"btn_speed")
    self.btn_speed:addTouchEventListener(handler(self,self.onSpeed))
    self.btn_speed:setTitleText("加速")
    -- 其他按钮
    self.btn_other = Common:seekNodeByName(self.view,"btn_other")
    self.btn_other:addTouchEventListener(handler(self,self.onOther))
    self.btn_other:setTitleText("其他")

    -- if #self.model.selectList == 0 then
    --     Lan:hintClient(7,"你暂时还没有道具，请到商店购买",nil,3)
    -- end
end

--物品按钮回调
--sender 按钮本身
--eventType 事件类型
function BagView:onItem(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self.btn_item:setBright(false)
        self.btn_shop:setBright(true)
        self.model.kind = 0
        -- 获取切换的数据
        self.model:getSlectList()
        -- 创建列表
        self:createList()
    end
end

--商城按钮回调
--sender 按钮本身
--eventType 事件类型
function BagView:onShop(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self.btn_item:setBright(true)
        self.btn_shop:setBright(false)
        self.model.kind = 1
        -- 获取切换的数据
        self.model:getSlectList()
        -- 创建列表
        self:createList()
    end
end

--军事按钮回调
--sender 按钮本身
--eventType 事件类型
function BagView:onArmy(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self.btn_army:setBright(false)
        self.btn_res:setBright(true)
        self.btn_speed:setBright(true)
        self.btn_other:setBright(true)
        self.model.type = 1
        -- 获取切换的数据
        self.model:getSlectList()
        -- 创建列表
        self:createList()
    end
end

--物资按钮回调
--sender 按钮本身
--eventType 事件类型
function BagView:onRes(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self.btn_army:setBright(true)
        self.btn_res:setBright(false)
        self.btn_speed:setBright(true)
        self.btn_other:setBright(true)
        self.model.type = 3
        -- 获取切换的数据
        self.model:getSlectList()
        -- 创建列表
        self:createList()
    end
end

--加速按钮回调
--sender 按钮本身
--eventType 事件类型
function BagView:onSpeed(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self.btn_army:setBright(true)
        self.btn_res:setBright(true)
        self.btn_speed:setBright(false)
        self.btn_other:setBright(true)
        self.model.type = 2
        -- 获取切换的数据
        self.model:getSlectList()
        -- 创建列表
        self:createList()
    end
end

--其他按钮回调
--sender 按钮本身
--eventType 事件类型
function BagView:onOther(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self.btn_army:setBright(true)
        self.btn_res:setBright(true)
        self.btn_speed:setBright(true)
        self.btn_other:setBright(false)
        self.model.type = 4
        -- 获取切换的数据
        self.model:getSlectList()
        -- 创建列表
        self:createList()
    end
end

-- 创建列表
function BagView:createList()
	if self.listView ~= nil then
        self.listView:removeFromParent()
    end
    --列表背景
    self.listView = cc.ui.UIListView.new {
        -- bgColor = cc.c4b(100, 100, 100, 255),
        bgColor = cc.c4b(0, 0, 0, 0),
        viewRect = cc.rect(0, 0, 700, 1050),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
    }
    --总背景
    self.bg_list = Common:seekNodeByName(self.view,"bg_list")
    self.bg_list:addChild(self.listView,0)
    local myCell = Common:seekNodeByName(self.root,"item_cell")
    for k,v in pairs(self.model.selectList) do
    	local copyCell = myCell:clone()
        --单项
        local cell = self.listView:newItem()
        cell:setItemSize(700, 200)
        cell:setPosition(0, 1050)
        self.listView:addItem(cell)

        cell:addContent(copyCell)
        self:setCellInfo(copyCell,v,k)
    end
    self.listView:reload()
    -- 隐藏购买界面
    self.buyView:hideView()
    -- 刷新金钱
    self.lbl_gold:setString(PlayerData:getInstance().gold)
end

function BagView:setCellInfo(cell,info,index)
    if info == nil then
        return
    end
    --头像
    local img_item = MMUISimpleUI:getInstance():getItem(info.quality,info.icon)
    img_item:setPosition(0,cell:getContentSize().height / 2 - img_item:getContentSize().height / 2 )
    cell:addChild(img_item)
    --名字
    local lbl_name = Common:seekNodeByName(cell,"lbl_name")
    lbl_name:setString(info.name)
    --介绍
    local lbl_details = Common:seekNodeByName(cell,"lbl_details")
    lbl_details:setString(info.description)
    --拥有
    local lbl_have = Common:seekNodeByName(cell,"lbl_have")
    --
    local btn_use = Common:seekNodeByName(cell,"btn_use")
    btn_use:setTag(index)
    btn_use:addTouchEventListener(handler(self,self.onBuy))
    btn_use:setTitleText("购买")
	--购买
    local lbl_buy = Common:seekNodeByName(btn_use,"lbl_buy")
    --金币
    local lbl_gold = Common:seekNodeByName(btn_use,"lbl_gold")
    if self.model.kind == 1 then
	    lbl_buy:setString("购买")
	    lbl_gold:setString("金币" .. info.price)
	    btn_use:setTitleText("")
    	lbl_have:setString("拥有：" .. self.model:getShopItemNum(info.templateId))
	else
		lbl_buy:setString("")
		lbl_gold:setString("")
		btn_use:setTitleText("使用")
    	lbl_have:setString("拥有：" .. info.number)
        -- 使用按钮判断
        if ItemTemplateConfig:getInstance():getItemTemplateByID(info.templateId).it_beuse == 0 then
            btn_use:setVisible(false)
        else
            btn_use:setVisible(true)
        end
    end
end

--购买和使用按钮回调
--sender 按钮本身
--eventType 事件类型
function BagView:onBuy(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        local headTag = sender:getTag()
        local clickInfo = self.model.selectList[headTag]
        if self.model.kind == 1 then
            self.buyView:showView()
            self.buyView:init(clickInfo, self.model.kind)
        else
            if clickInfo.number > 1 then
                self.buyView:showView()
                self.buyView:init(clickInfo, self.model.kind)
            else
                -- 使用物品 objId,templateId,number
                BagService:getInstance():sendUseItem(clickInfo.objId,clickInfo.templateId,1)
            end
        end
    end
end

--关闭按钮回调
--sender 按钮本身
--eventType 事件类型
function BagView:onBack(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
    	UIMgr:getInstance():closeUI(self.uiType)
    end
end

function BagView:onEnter()
    UICommon:getInstance():setMapTouchAable(false)
end

function BagView:onExit()
	UICommon:getInstance():setMapTouchAable(true)
end

function BagView:onDestroy()

end
