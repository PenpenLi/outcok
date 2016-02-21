
--[[
    jinyan.zhang
    邮件界面
--]]

MailsView = class("MailsView",UIBaseView)

--构造
--uiType UI类型
--data 数据
--返回值(无)
function MailsView:ctor(uiType,data)
    self.data = data
    self.super.ctor(self,uiType)
    self:adapterSize()
end

--初始化
--返回值(无)
function MailsView:init()
    self.root = Common:loadUIJson(MAIL_PATH)
    self:addChild(self.root)

    --保存信息列表UI
    self.arryListUI = {}

    --初始化邮件列表面板
    self:initMailListPan()

    --写邮件UI
    self.writeMailsView = WriteMailsView.new(self)
    --战斗报告列表UI
    self.batReptListView = BattleReportListView.new(self)
    --系统报告列表UI
    self.sysReportListView = SysReportListView.new(self)
    --联盟报告列表UI
    self.alianceReportListView = AlianceReportListView.new(self)
    --信息报告列表UI
    self.infoReportListView = InfoReportListView.new(self)
    --cok工作室列表UI
    self.workReportListView = WorkReportListView.new(self)
    --战斗结果UI
    self.battleResultView = BattleResultView.new(self)
    --战斗详情数据UI
    self.battleDetailsInfo = BattleDetailsInfo.new(self)
    --侦察邮件UI
    self.watchMailsView = WatchMailsView.new(self)

    table.insert(self.arryListUI,self.batReptListView)
    table.insert(self.arryListUI,self.sysReportListView)
    table.insert(self.arryListUI,self.alianceReportListView)
    table.insert(self.arryListUI,self.infoReportListView)
    table.insert(self.arryListUI,self.workReportListView)
end

--更新报告列表UI
function MailsView:updateReportListUI()
    for k,v in pairs(self.arryListUI) do
        if v:isShow() then
            v:updateUI()
            break
        end
    end
end

--初始化邮件列表面板
function MailsView:initMailListPan()
    --邮件列表
    self.panList = Common:seekNodeByName(self.root,"pan_list")

    --关闭按钮
    self.btnClose = Common:seekNodeByName(self.panList,"btn_close")
    self.btnClose:addTouchEventListener(handler(self,self.onClose))

    --标题
    self.labTitle = Common:seekNodeByName(self.panList,"lab_title")
    self.labTitle:setString(Lan:lanText(40, "邮件"))

    --写邮件按钮
    self.btnWrite = Common:seekNodeByName(self.panList,"btn_edit")
    self.btnWrite:addTouchEventListener(handler(self,self.onWrite))

    --内容层
    self.panContent = Common:seekNodeByName(self.panList,"pan_content")

    self.listTouchLayer = MMUITouchLayer.new()
    self.panList:addChild(self.listTouchLayer,1)

    --创建邮件列表
    self:createList()
end

--创建邮件列表
function MailsView:createList()
    self.panContent:removeAllChildren()
    self.listTouchLayer:clearData()

    local config = {}
    config[1] = {head="mail_pic_flag_16.png",title=Lan:lanText(41, "信息"),callback=self.onInfo,type=-1}
    config[2] = {head="mail_pic_flag_5.png",title=Lan:lanText(42, "联盟"),callback=self.onAlliance,type=-1}
    config[3] = {head="mail_pic_flag_14.png",title=Lan:lanText(43, "战斗报告"),callback=self.onBattleReport,type=MailType.battle}
    config[4] = {head="mail_pic_flag_4.png",title=Lan:lanText(44, "COK工作室"),callback=self.onWork,type=-1}
    config[5] = {head="mail_pic_flag_9.png",title=Lan:lanText(45, "系统"),callback=self.onSystem,type=-1}
    config[6] = {head="mail_pic_flag_18.png",title=Lan:lanText(46, "怪物报告"),callback=self.onMonsterReport,type=-1}
    config[7] = {head="mail_pic_flag_4.png",title=Lan:lanText(47, "资源采集报告"),callback=self.onResReport,type=-1}

    local rowHigh = 110
    local beginY = display.height - 230
    for i=1,5 do
        --背景
        local imgBg = display.newScale9Sprite("#mail_floor.png", 0, 0, cc.size(display.width,rowHigh))
        imgBg:setAnchorPoint(0,0)
        self.panContent:addChild(imgBg)
        local y = beginY - (i-1)*rowHigh
        imgBg:setPosition(0, y)

        --移动结点
        local moveNode = display.newCutomColorLayer(cc.c4b(255,255,255,0),display.width,rowHigh)
        imgBg:addChild(moveNode)

        local info = config[i]
        --图标
        local imgHead = display.newSprite("#" .. info.head,ccui.TextureResType.plistType)
        imgHead:setAnchorPoint(0,0)
        imgHead:setPosition(20, 10)
        moveNode:addChild(imgHead)

        --名称
        local labName = display.newTTFLabel({
            text = "",
            font = "Arial",
            size = 28,
            color = cc.c3b(0, 0, 0),
        })
        labName:setString(info.title)
        labName:setAnchorPoint(0,0.5)
        labName:setPosition(110, 50)
        moveNode:addChild(labName)

        --数量
        local labNumer = display.newTTFLabel({
            text = "",
            font = "Arial",
            size = 28,
            color = cc.c3b(0, 0, 0),
        })
        labNumer:setAnchorPoint(0,0.5)
        labNumer:setPosition(display.width-100, 50)
        moveNode:addChild(labNumer)
        local number = MailsModel:getInstance():getUnReadMailNumByType(info.type)
        if number > 0 then
            labNumer:setString("" .. number)
        else
            labNumer:setString("")
        end

        --最新邮件简要内容
        local mailInfo = MailsModel:getInstance():getMostNewMailByType(info.type)
        if mailInfo ~= nil then
            local labNewContent = display.newTTFLabel({
                text = "",
                font = "Arial",
                size = 28,
                color = cc.c3b(0, 0, 0),
            })
            labNewContent:setAnchorPoint(0,0.5)
            labNewContent:setPosition(200, 50)
            moveNode:addChild(labNewContent)
            labNewContent:setString(mailInfo.content)
        end

        --标记已读按钮
        local btnRemarkRead = cc.ui.UIPushButton.new("#btn_blue.png")
        btnRemarkRead:setAnchorPoint(0,0)
        btnRemarkRead:setButtonSize(150,80)
        Common:setTouchSwallowEnabled(false,btnRemarkRead)
        moveNode:addChild(btnRemarkRead)
        btnRemarkRead:setPosition(display.width, 20)
        btnRemarkRead:setButtonEnabled(true)
        btnRemarkRead:onButtonClicked(function(event)
            print("click remark btn...")
        end)
        local labRemarkRead = display.newTTFLabel({
            text = "",
            font = "Arial",
            size = 24,
            color = cc.c3b(255, 255, 255), 
            align = cc.TEXT_ALIGNMENT_LEFT,
        })
        btnRemarkRead:addChild(labRemarkRead)
        labRemarkRead:setPosition(75, 40)
        labRemarkRead:setString(Lan:lanText(48, "标记已读"))

        --添加数据至触摸检测层
        self.listTouchLayer:addData(i,imgBg,moveNode,-150,info.callback,self) 
    end

    --分隔图片
    local imgReportTitle = display.newScale9Sprite("#mail_bg2.png", 0, 0, cc.size(display.width,50))
    imgReportTitle:setAnchorPoint(0,0)
    self.panContent:addChild(imgReportTitle)
    local y = beginY - (5-1)*rowHigh - 60
    imgReportTitle:setPosition(0, y)

    --分隔标题
    local labTitle = display.newTTFLabel({
        text = "",
        font = "Arial",
        size = 28,
        color = cc.c3b(0, 0, 0),
    })
    labTitle:setString("Report")
    labTitle:setAnchorPoint(0,0)
    labTitle:setPosition(10, 10)
    imgReportTitle:addChild(labTitle)

    -- local index = 0
    -- for i=6,7 do
    --     --背景
    --     local imgBg = display.newScale9Sprite("#mail_floor.png", 0, 0, cc.size(display.width,rowHigh))
    --     imgBg:setAnchorPoint(0,0)
    --     self.panContent:addChild(imgBg)
    --     local y = imgReportTitle:getPositionY()-100-index*rowHigh
    --     imgBg:setPosition(0, y)

    --     local info = config[i]
    --     index = index + 1

    --     --图标
    --     local imgHead = display.newSprite("#" .. info.head,ccui.TextureResType.plistType)
    --     imgHead:setAnchorPoint(0,0)
    --     imgHead:setPosition(20, 30)
    --     imgBg:addChild(imgHead)

    --     --标题
    --     local labTitle = display.newTTFLabel({
    --         text = "",
    --         font = "Arial",
    --         size = 28,
    --         color = cc.c3b(0, 0, 0),
    --     })
    --     labTitle:setString(info.title)
    --     labTitle:setAnchorPoint(0,0)
    --     labTitle:setPosition(110, 50)
    --     imgBg:addChild(labTitle)

    --     --数量
    --     local labNumer = display.newTTFLabel({
    --         text = "",
    --         font = "Arial",
    --         size = 28,
    --         color = cc.c3b(0, 0, 0),
    --     })
    --     labNumer:setString("1")
    --     labNumer:setAnchorPoint(0,0.5)
    --     labNumer:setPosition(display.width-100, 50)
    --     imgBg:addChild(labNumer)
    -- end
end

--信息邮件回调
function MailsView:onInfo(index)
    self:hide()
    self.infoReportListView:show()
    self.infoReportListView:updateUI()
end

--联盟邮件回调
function MailsView:onAlliance(index)
    self:hide()
    self.alianceReportListView:show()
    self.alianceReportListView:updateUI()
end

--战斗报告邮件回调
function MailsView:onBattleReport(index)
    self:hide()
    self.batReptListView:show()
    self.batReptListView:updateUI()
end

--系统邮件回调
function MailsView:onSystem(index)
    self:hide()
    self.sysReportListView:show()
    self.sysReportListView:updateUI()
end

--工作室邮件回调
function MailsView:onWork(index)
    self:hide()
    self.workReportListView:show()
    self.workReportListView:updateUI()
end

--怪物报告邮件回调
function MailsView:onMonsterReport(index)
    
end

--资源采集报告邮件回调
function MailsView:onResReport(index)
    
end

--显示
function MailsView:show()
    self.panList:setVisible(true)
end

--隐藏
function MailsView:hide()
    self.panList:setVisible(false)
end

--写邮件按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function MailsView:onWrite(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self.writeMailsView:show()
    end
end

--关闭按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function MailsView:onClose(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        UIMgr:getInstance():closeUI(self.uiType)
    end
end

--UI加到舞台后会调用这个接口
--返回值(无)
function MailsView:onEnter()
    UICommon:getInstance():setMapTouchAable(false)
    --邮件详情数据
    if self.data ~= nil and self.data.details ~= nil then
        self:hide()
        self.battleResultView:show()
        self.battleResultView:updateUI(self.data.details)
    end
end

--UI离开舞台后会调用这个接口
--返回值(无)
function MailsView:onExit()
    UICommon:getInstance():setMapTouchAable(true)
end

--析构函数(此时已经从内存中释放掉资源了)
--返回值(无)
function MailsView:onDestroy()
end

