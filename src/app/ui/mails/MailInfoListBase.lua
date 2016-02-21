
--[[
	jinyan.zhang
	邮件信息列表基类
--]]

MailInfoListBase = class("MailInfoListBase")

function MailInfoListBase:ctor(parent)
	self.parent = parent
    self.nodeList = {}
    self.isVisible = false
	self:init()
end

function MailInfoListBase:init()
	--信息列表
    self.panInfoList = Common:seekNodeByName(self.parent.root,"pan_infolist")

    --列表
    self.panListView = Common:seekNodeByName(self.panInfoList,"pan_listview")

    --列表数据为空时的信息描述
    self.labEmptyData = Common:seekNodeByName(self.panInfoList,"lab_empty")
    self.labEmptyData:setColor(cc.c3b(0, 0, 0))
    self.labEmptyData:setString(Lan:lanText(53, "信封里一封里都没有下次,再来看吧"))

    --关闭按钮
    self.btnClose = Common:seekNodeByName(self.panInfoList,"btn_close")
    self.btnClose:addTouchEventListener(handler(self,self.onClose))

    --标题
    self.labTitle = Common:seekNodeByName(self.panInfoList,"lab_title")

    --编辑复选框
    self.checkboxEdit = Common:seekNodeByName(self.panInfoList,"checkbox_edit")
    self.checkboxEdit:addEventListener(handler(self,self.onEidt))

    --编辑层
    self.panEdit = Common:seekNodeByName(self.panInfoList,"pan_edit")
    --全选复选框按钮
    self.checkboxSelAll = Common:seekNodeByName(self.panEdit,"checkbox_all")
    self.checkboxSelAll:addEventListener(handler(self,self.onSelAll))

    --领取取物品按钮
    self.btnGetAward = Common:seekNodeByName(self.panEdit,"btn_getAward")
    self.btnGetAward:addTouchEventListener(handler(self,self.onGetAward))

    --写邮件按钮
    self.btnWrite = Common:seekNodeByName(self.panEdit,"btn_write")
    self.btnWrite:addTouchEventListener(handler(self,self.onWrite))

    --删除按钮
    self.btnDel = Common:seekNodeByName(self.panEdit,"btn_del")
    self.btnDel:addTouchEventListener(handler(self,self.onDel))

    --创建一个触摸检测层
    if self.touchLayer == nil then
    	self.touchLayer = MMUITouchLayer.new()
	    self.panInfoList:addChild(self.touchLayer,1)
	    self.touchLayer:setAble(false)
    end
    self:clearData()
end

--设置标题
function MailInfoListBase:setTitle(content)
	self.labTitle:setString(content)
end

function MailInfoListBase:isShow()
    return self.isVisible
end

--显示
function MailInfoListBase:show()
	self:init()
	self.panInfoList:setVisible(true)
	self.isVisible = true
end

--隐藏
function MailInfoListBase:hide()
	self.panInfoList:setVisible(false)
	self.isVisible = false
end

--写邮件按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function MailInfoListBase:onWrite(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
    	self.parent.writeMailsView:show()
    end
end

--删除邮件按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function MailInfoListBase:onDel(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
	    UIMgr:getInstance():openUI(UITYPE.PROP_BOX, {type=PROP_BOX_TYPE.COMMON,text=Lan:lanText(52, "您真的要删除这些邮件吗"),
        	callback=handler(self, self.onSureDel),sureBtnText=Lan:lanText(50, "确定"),cancelBtnText=Lan:lanText(51, "取消")
        })
    end
end

--确定删除邮件回调
function MailInfoListBase:onSureDel(index)
	local arry = {}
	for k,v in pairs(self.nodeList) do
		if v.checkbox:isSelected() then
			table.insert(arry,v.mailId)
		end
	end
    if #arry > 0 then
        MailsService:getInstance():delMailReq(arry)
    end
end

--领取奖励按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function MailInfoListBase:onGetAward(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
    	
    end
end

--编辑按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function MailInfoListBase:onEidt(sender,eventType)
	if eventType == 0 then
		print("选中")
		self:showEditLayer()
	else
		print("未选中")
		self:hideEditLayer()
	end
end

--全选邮件按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function MailInfoListBase:onSelAll(sender,eventType)
    if eventType == 0 then 
    	self:selAll()
    else 
    	self:cancelSelAll()
    end
end

--全选邮件
function MailInfoListBase:selAll()
	for k,v in pairs(self.nodeList) do
		v.checkbox:setSelected(true)
	end
end

--取消全选邮件
function MailInfoListBase:cancelSelAll()
	for k,v in pairs(self.nodeList) do
		v.checkbox:setSelected(false)
	end
end

--关闭按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function MailInfoListBase:onClose(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self:clearData()
    	self:hide()
    	self.parent:show()
    end
end

--显示空数据描述
function MailInfoListBase:showEmptyDataDescrp()
	self.labEmptyData:setVisible(true)
	self.panListView:setVisible(false)
end

--显示列表数据
function MailInfoListBase:showListData()
	self.labEmptyData:setVisible(false)
	self.panListView:setVisible(true)
end

--显示编辑层
function MailInfoListBase:showEditLayer()
	self.panEdit:setVisible(true)
	self.panListView:setTouchEnabled(true)
	for k,v in pairs(self.nodeList) do
		v.moveNode:setPositionX(v.targetX)
	end
end

--隐藏编辑层
function MailInfoListBase:hideEditLayer()
	self.panEdit:setVisible(false)
	self.panListView:setTouchEnabled(false)
	for k,v in pairs(self.nodeList) do
		v.moveNode:setPositionX(0)
	end
	self.checkboxSelAll:setSelected(false)
end

function MailInfoListBase:clearData()
	self.touchLayer:clearData()
    self.panListView:removeAllChildren()
    self.nodeList = {}
    self.touchLayer:setAble(false)
    self:hideEditLayer()
    self.checkboxEdit:setSelected(false)
end

--创建列表
function MailInfoListBase:createList(data)
	self:clearData()

    if data == nil or #data == 0 then
    	self:showEmptyDataDescrp()
    	return
    end

    self.touchLayer:setAble(true)
    self:showListData()

    local signHigh = 150
    local size  = self.panListView:getContentSize()
    self.listView = cc.ui.UIListView.new {
        bgColor = cc.c4b(255, 255, 0, 0),
        viewRect = cc.rect(0, 0, size.width, size.height),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
    }
    self.panListView:addChild(self.listView)

    for i=1,#data do
    	local info = data[i]
    	--背景
        local imgBg = display.newScale9Sprite("#mail_floor.png", 0, 0, cc.size(display.width,signHigh))
        --item
        local item = self.listView:newItem()
        item:addContent(imgBg)
        item:setItemSize(size.width, signHigh)
        self.listView:addItem(item)

        --移动结点
        local moveNode = display.newCutomColorLayer(cc.c4b(255,255,255,0),size.width,signHigh)
        imgBg:addChild(moveNode)

        --删除按钮
        local btnDel = cc.ui.UIPushButton.new("#btn_blue.png")
        btnDel:setAnchorPoint(0,0)
        btnDel:setButtonSize(150,80)
        Common:setTouchSwallowEnabled(false,btnDel)
        moveNode:addChild(btnDel)
        btnDel:setPosition(size.width, 30)
        btnDel:setButtonEnabled(true)
        btnDel:onButtonClicked(function(event)
            local arry = {}
            table.insert(arry,info.id)
            MailsService:getInstance():delMailReq(arry)
        end)
        local labDel = display.newTTFLabel({
            text = "",
            font = "Arial",
            size = 24,
            color = cc.c3b(255, 255, 255), 
            align = cc.TEXT_ALIGNMENT_LEFT,
        })
        btnDel:addChild(labDel)
        labDel:setPosition(75, 40)
        labDel:setString(Lan:lanText(49, "删除"))

        --复选框
        local checkbox = ccui.CheckBox:create("mail_checkbox0.png","mail_checkbox1.png","mail_checkbox1.png","","",ccui.TextureResType.plistType)
		moveNode:addChild(checkbox) 
		checkbox:setAnchorPoint(0,0.5)
		checkbox:setPosition(-50, 70)
		checkbox:setTag(i)

		--保存数据
        local nodeInfo = {}
        nodeInfo.checkbox = checkbox
        nodeInfo.moveNode = moveNode
        nodeInfo.targetX = 70
        nodeInfo.mailId = info.id
        table.insert(self.nodeList,nodeInfo)

        --图标
        if info.icon ~= nil then
            local imgIcon = display.newSprite("#" .. info.icon)
            imgIcon:setAnchorPoint(0,0.5)
            moveNode:addChild(imgIcon)
            imgIcon:setPosition(30, 70)
        end

        --标题
        local labTitle = display.newTTFLabel({
            text = "",
            font = "Arial",
            size = 26,
            color = cc.c3b(0, 0, 0), 
            align = cc.TEXT_ALIGNMENT_LEFT,
        })
        moveNode:addChild(labTitle)
        labTitle:setAnchorPoint(0,0)
        labTitle:setPosition(120, 90)
        labTitle:setString(info.title)

        --内容
        local labContent = display.newTTFLabel({
            text = "",
            font = "Arial",
            size = 24,
            color = cc.c3b(0, 0, 0), 
            align = cc.TEXT_ALIGNMENT_LEFT,
        })
        moveNode:addChild(labContent)
        labContent:setAnchorPoint(0,0)
        labContent:setPosition(120, 40)
        labContent:setString(info.content)

        --时间
        local labTime = display.newTTFLabel({
            text = "",
            font = "Arial",
            size = 24,
            color = cc.c3b(0, 0, 0), 
            align = cc.TEXT_ALIGNMENT_LEFT,
        })
        moveNode:addChild(labTime)
        labTime:setAnchorPoint(0,0)
        labTime:setPosition(500, 90)
        labTime:setString("" .. info.time)

        --礼物图标
        if info.gift ~= nil then
        	local imgGift = display.newSprite("#" .. info.gift)
	        moveNode:addChild(imgGift)
	        imgGift:setAnchorPoint(0,0)
	        imgGift:setPosition(display.width-100, 30)
        end

        --添加数据至触摸检测层
        self.touchLayer:addData(i,imgBg,moveNode,-150,info.callback,self,info) 
    end

    self.listView:reload()
end


