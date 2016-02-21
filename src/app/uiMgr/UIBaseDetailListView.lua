--
-- Author: oyhc
-- Date: 2016-01-11 23:28:55
-- 详情列表
UIBaseDetailListView = class("UIBaseDetailListView")

--构造
--uiType UI类型
--data 数据
function UIBaseDetailListView:ctor(theSelf)
	self.parent = theSelf
	self.view = Common:seekNodeByName(self.parent.root,"Panel_2")
end

--初始化
--返回值(无)
function UIBaseDetailListView:init()
    --关闭按钮
    self.closeBtn = Common:seekNodeByName(self.view,"btn_close")
    self.closeBtn:addTouchEventListener(handler(self,self.closeCallback))
    --更多信息标题
    self.lbl_title = Common:seekNodeByName(self.view,"lbl_title")
    self.lbl_title:setString(self.parent.buildInfo.bt_name .. " " .. Lan:lanText(144,"等级") .. self.parent.buildingInfo.level)
    -- 设置详细
    local lbl_description = cc.ui.UILabel.new(
        {text = self.parent.buildInfo.bt_detaileddescription,
        size = 26,
        color = display.COLOR_WHITE})
    lbl_description:setAlignment(0,0)
    lbl_description:setWidth(600)
    lbl_description:setPosition(self.view:getContentSize().width / 2 - 300, 1175)
    self.view:addChild(lbl_description)
    -- 细节
    local lbl_des = cc.ui.UILabel.new(
        {text = self.parent.buildInfo.bt_name .. " " .. Lan:lanText(143,"细节"),
        size = 30,
        color = display.COLOR_RED})
    lbl_des:setAlignment(1,1)
    lbl_des:setWidth(600)
    lbl_des:setPosition(self.view:getContentSize().width / 2 - 300, 1125)
    self.view:addChild(lbl_des)
end

function UIBaseDetailListView:setData(titleArr, conArr)
	if self.listView ~= nil then
        self.listView:removeFromParent()
    end
    --列表背景
    self.listView = cc.ui.UIListView.new {
        bgColor = cc.c4b(100, 100, 100, 255),
        -- bgColor = cc.c4b(0, 0, 0, 0),
        viewRect = cc.rect(0, 0, 700, 1000),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
    }
    self.listView:setPosition(25, 50)
    self.view:addChild(self.listView)
    -- 单个文本宽度
    local theWidth = 500 / (#titleArr - 1)
    -- 设置数据标题
    for h=1,#titleArr do
        local lbl_value = cc.ui.UILabel.new(
                {text = titleArr[h],
                size = 26,
                color = display.COLOR_WHITE})
        if h == 1 then
            lbl_value:setAlignment(1,1)
            lbl_value:setWidth(200)
            lbl_value:setPosition(25, 1075)
        else
            lbl_value:setAlignment(0,1)
            lbl_value:setWidth(theWidth)
            lbl_value:setPosition((h - 2) * theWidth + 225, 1075)
        end
        self.view:addChild(lbl_value)
    end

    for i=1,#conArr do
        local item = self.listView:newItem()
        local content = display.newNode()
    	local arr = conArr[i]
    	for j=1,#arr do
            local lbl_value = cc.ui.UILabel.new(
                    {text = arr[j],
                    size = 26,
                    color = display.COLOR_WHITE})
            if j == 1 then
                lbl_value:setAlignment(1,1)
                lbl_value:setWidth(200)
                lbl_value:setPosition(0, 25)
            else
                lbl_value:setAlignment(0,1)
                lbl_value:setWidth(theWidth)
                lbl_value:setPosition((j - 2) * theWidth + 200, 25)
            end
            content:addChild(lbl_value)
    	end
        content:setContentSize(700, 50)
        item:addContent(content)
        item:setItemSize(700, 50)
        self.listView:addItem(item)    
    end
    self.listView:reload()
end

--
function UIBaseDetailListView:createTech(arr, id)
end

--关闭按钮回调
function UIBaseDetailListView:closeCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        -- 隐藏自己
        self:hideView()
        -- 显示
        self.parent:showView()
    end
end

-- 显示界面
function UIBaseDetailListView:showView()
	self.view:setVisible(true)
end

-- 隐藏界面
function UIBaseDetailListView:hideView()
	self.view:setVisible(false)
end

