
--[[
    jinyan.zhang
    驻军
--]]

GarrisionView = class("GarrisionView")

--构造
--parent 父结点UI
function GarrisionView:ctor(parent)
	self.parent = parent
    self.checkNode = {}  --待检测结点
	self:init()
end

--初始化
function GarrisionView:init()
    --驻军面板
    self.garrisionPan = Common:seekNodeByName(self.parent.root,"garrisionPan")
    self.garrisionPan:setVisible(true)
    self.garrisionPan:setTouchEnabled(false)

    --标题
    self.titleLab = Common:seekNodeByName(self.garrisionPan,"lab_title")
    self.titleLab:setString(CommonStr.STATE_ARMS)

    --关闭按钮
    self.closeBtn = Common:seekNodeByName(self.garrisionPan,"btn_close")
    self.closeBtn:addTouchEventListener(handler(self,self.closeCallback))

    --触摸层
    self.touchLayer = MMUITouchLayer.new()
    self.garrisionPan:addChild(self.touchLayer,1)
    self.touchLayer:setAble(true)

    --列表层
    self.listviewPan = Common:seekNodeByName(self.garrisionPan,"listviewPan")
    self:createList()
end

function GarrisionView:show()
    self.garrisionPan:setVisible(true)
    self.touchLayer:setAble(true)
end

function GarrisionView:hide()
    self.garrisionPan:setVisible(false)
    self.touchLayer:setAble(false)
end

--关闭按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function GarrisionView:closeCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        UIMgr:getInstance():openUI(UITYPE.BUILDING_MENU, {building=self.parent.data.building})
        UIMgr:getInstance():closeUI(self.parent.uiType)
    end
end

--删除英雄结果
function GarrisionView:delHeroRes()
    self.checkNode = {}
    self:createList()
end

--创建驻军列表
--返回值(无)
function GarrisionView:createList()
    if self.listView ~= nil then
        self.listView:removeFromParent()
    end
    self.touchLayer:clearData()

    local signHigh = 150
    local size = self.listviewPan:getContentSize()
    self.listView = cc.ui.UIListView.new {
        bgColor = cc.c4b(255, 255, 0, 0),
        viewRect = cc.rect(0, 0, size.width, size.height),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
    }
    self.listviewPan:addChild(self.listView)
    self.listView:setTouchEnabled(false)

    local function createEmptyNode()
        local content = display.newCutomColorLayer(cc.c4b(255,0,255,128),size.width,signHigh)
        content:setContentSize(size.width, signHigh)
        local item = self.listView:newItem()
        item:addContent(content)
        item:setItemSize(size.width, signHigh)
        self.listView:addItem(item)

        --添加按钮
        local addBtn = cc.ui.UIPushButton.new("#btn_blue.png")
        addBtn:setAnchorPoint(0.5,0.5)
        addBtn:setButtonSize(300,100)
        Common:setTouchSwallowEnabled(false,addBtn)
        content:addChild(addBtn)
        addBtn:setPosition(size.width/2, signHigh/2)
        addBtn:setButtonEnabled(true)
        addBtn:onButtonClicked(function(event)
            self:hide()
            if self.addHeroView == nil then
                self.addHeroView = AddHeroView.new(self.parent,self)
            end
            self.addHeroView:createIdleHeroList()
        end)

        local addLab = display.newTTFLabel({
            text = CommonStr.ADD,
            font = "Arial",
            size = 24,
            color = cc.c3b(255, 255, 255), 
            align = cc.TEXT_ALIGNMENT_LEFT,
        })
        addBtn:addChild(addLab)
        addLab:setPosition(0, 0)
    end

    local heroList = PlayerData:getInstance():getDefHeroList()
    for i=1,#heroList do
        local data = heroList[i]
        local content = nil
        if i == 1 then
            content = display.newCutomColorLayer(cc.c4b(255,0,0,128),size.width,signHigh)
        elseif i == 2 then
            content = display.newCutomColorLayer(cc.c4b(255,255,0,128),size.width,signHigh)
        elseif i == 3 then
            content = display.newCutomColorLayer(cc.c4b(0,255,0,128),size.width,signHigh)
        elseif i == 4 then
            content = display.newCutomColorLayer(cc.c4b(0,0,255,128),size.width,signHigh)
        elseif i == 5 then
            content = display.newCutomColorLayer(cc.c4b(255,0,255,128),size.width,signHigh)
        end
        content:setContentSize(size.width, signHigh)

        local item = self.listView:newItem()
        item:addContent(content)
        item:setItemSize(size.width, signHigh)
        self.listView:addItem(item)

        local moveNode = display.newCutomColorLayer(cc.c4b(255,255,255,0),size.width,signHigh)
        content:addChild(moveNode)

        --删除按钮
        local delBtn = cc.ui.UIPushButton.new("#btn_blue.png")
        delBtn:setAnchorPoint(0,0)
        delBtn:setButtonSize(150,80)
        Common:setTouchSwallowEnabled(false,delBtn)
        moveNode:addChild(delBtn)
        delBtn:setPosition(size.width, 30)
        delBtn:setButtonEnabled(true)
        delBtn:onButtonClicked(function(event)
            print("click delBtn...")
            WallService:getInstance():removeHeroReq(data:getObjId())
        end)
        local delLab = display.newTTFLabel({
            text = CommonStr.DEL,
            font = "Arial",
            size = 24,
            color = cc.c3b(255, 255, 255), 
            align = cc.TEXT_ALIGNMENT_LEFT,
        })
        delBtn:addChild(delLab)
        delLab:setPosition(75, 40)

        --头像
        local headImg = MMUISimpleUI:getInstance():getHead(data)
        moveNode:addChild(headImg)
        headImg:setPosition(80, 70)
        headImg:setScale(0.5)

        --名字
        local nameLab = display.newTTFLabel({
            text = data:getName(),
            font = "Arial",
            size = 24,
            color = cc.c3b(255, 255, 255), 
            align = cc.TEXT_ALIGNMENT_LEFT,
        })
        moveNode:addChild(nameLab)
        nameLab:setAnchorPoint(0,0)
        nameLab:setPosition(180, 70)

        --等级
        local levelLab = display.newTTFLabel({
            text = "lv" .. data:getHeroLevel(),
            font = "Arial",
            size = 24,
            color = cc.c3b(255, 255, 255), 
            align = cc.TEXT_ALIGNMENT_LEFT,
        })
        moveNode:addChild(levelLab)
        levelLab:setAnchorPoint(0,0)
        levelLab:setPosition(350, 70)

        --兵种适性
        local best = data:getBestOccupation()
        local adaptLab = display.newTTFLabel({
            text = CommonStr.SOLDIER_FITNESS .. ArmsData:getInstance():getOccupatuinName(best),
            font = "Arial",
            size = 24,
            color = cc.c3b(255, 255, 255), 
            align = cc.TEXT_ALIGNMENT_LEFT,
        })
        moveNode:addChild(adaptLab)
        adaptLab:setAnchorPoint(0,0)
        adaptLab:setPosition(500, 70)

        --添加数据至触摸检测层
        self.touchLayer:addData(i,content,moveNode,-150) 
    end

    local leftCount = 5 - #heroList
    for i=1,leftCount do
        createEmptyNode()
    end

    self.listView:reload()
end












