--
-- Author: Your Name
-- Date: 2016-01-22 20:55:42
-- 详情列表
UIBaseCityOutDetailListView = class("UIBaseCityOutDetailListView",function()
    return display.newLayer()
end)

--构造
--uiType UI类型
--data 数据
function UIBaseCityOutDetailListView:ctor(theSelf)
	self.parent = theSelf
	self.root = Common:loadUIJson(DETAILS_PATH)
    self:addChild(self.root)

    self.view1 = Common:seekNodeByName(self.root,"Panel_1")
    self.view1:setVisible(false)
	self.view = Common:seekNodeByName(self.root,"Panel_2")
    self.view:setVisible(true)
    self:init()
    self:hideView()
end

--设置标题
function UIBaseCityOutDetailListView:setTitle(name,level,descrp)
    self.labTitle:setString(name .. " " .. Lan:lanText(144,"等级") .. level)
    self.labDes:setString(descrp)
end

--初始化
--返回值(无)
function UIBaseCityOutDetailListView:init()
    --关闭按钮
    self.closeBtn = Common:seekNodeByName(self.view,"btn_close")
    self.closeBtn:addTouchEventListener(handler(self,self.onClose))

    --更多信息标题
    self.labTitle = Common:seekNodeByName(self.view,"lbl_title")

    -- 细节
    self.labDes = cc.ui.UILabel.new({text = "",size = 30})
    self.labDes:setAlignment(1,1)
    self.labDes:setWidth(600)
    self.labDes:setPosition(self.view:getContentSize().width / 2 - 300, 1125)
    self.view:addChild(self.labDes)
end

function UIBaseCityOutDetailListView:setData(titleArr, conArr)
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
    local theWidth = 700 / #titleArr
    -- 设置数据标题
    for h=1,#titleArr do
        local lbl_value = cc.ui.UILabel.new(
                {text = titleArr[h],
                size = 26,
                color = display.COLOR_WHITE})
        lbl_value:setAlignment(1,1)
        --lbl_value:setAnchorPoint(0.5,0.5)
        lbl_value:setWidth(theWidth)
        lbl_value:setPosition((h - 1) * theWidth+30, 1075)
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
            --lbl_value:setAnchorPoint(0.5,0.5)
            lbl_value:setAlignment(1,1)
            lbl_value:setWidth(theWidth)
            lbl_value:setPosition((j - 1) * theWidth , 25)
            content:addChild(lbl_value)
    	end
        content:setContentSize(700, 50)
        item:addContent(content)
        item:setItemSize(700, 50)
        self.listView:addItem(item)    
    end
    self.listView:reload()
    self:showView()
end

--关闭按钮回调
function UIBaseCityOutDetailListView:onClose(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self:getParent().baseView:showView(self.parent)
    end
end

-- 显示界面
function UIBaseCityOutDetailListView:showView()
	self.view:setVisible(true)
end

-- 隐藏界面
function UIBaseCityOutDetailListView:hideView()
	self.view:setVisible(false)
end
