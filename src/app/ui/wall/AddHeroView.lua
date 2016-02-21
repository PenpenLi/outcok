
--[[
    jinyan.zhang
    添加英雄
--]]

AddHeroView = class("AddHeroView")

--构造
--parent 父结点UI
function AddHeroView:ctor(parent,garrisonView)
	self.parent = parent
    self.garrisonView = garrisonView
	self:init()
end

--初始化
function AddHeroView:init()
    --添加英雄面板
    self.addHeroPan = Common:seekNodeByName(self.parent.root,"addHeroPan")
    self.addHeroPan:setVisible(true)

    --标题
    self.titleLab = Common:seekNodeByName(self.addHeroPan,"lab_title")
    self.titleLab:setString(CommonStr.SEL_HERO)

    --关闭按钮
    self.closeBtn = Common:seekNodeByName(self.addHeroPan,"btn_close")
    self.closeBtn:addTouchEventListener(handler(self,self.closeCallback))

    --列表层
    self.listviewPan = Common:seekNodeByName(self.addHeroPan,"listviewPan")
end

function AddHeroView:show()
    self.addHeroPan:setVisible(true)
end

function AddHeroView:hide()
    self.addHeroPan:setVisible(false)
end

--添加驻守英雄结果
function AddHeroView:addHeroRes()
    if self.listView ~= nil then
        self.listView:removeFromParent()
        self.listView = nil
    end
    self:hide()
    self.garrisonView:show()
    self.garrisonView:delHeroRes()
end

--添加事件监听
function AddHeroView:touchListener(event)
    if "clicked" == event.name then
        local heroList = PlayerData:getInstance():getDefHeroList()
        if #heroList >= 5 then
            Prop:getInstance():showMsg(CommonStr.DEF_HERO_IS_FULL)
            return
        end

        local clickIndex = event.itemPos
        local heroList = PlayerData:getInstance():getIdleHeroList()
        local data = heroList[clickIndex]
        if data ~= nil then
            WallService:getInstance():addHeroReq(data:getObjId())
        end
    end
end

--创建英雄列表
--返回值(无)
function AddHeroView:createIdleHeroList()
    if self.listView ~= nil then
        self.listView:removeFromParent()
    end
    self:show()

    local heroList = PlayerData:getInstance():getIdleHeroList()
    if #heroList == 0 then
        return
    end

    local signHigh = 150
    local size = self.listviewPan:getContentSize()
    self.listView = cc.ui.UIListView.new {
        bgColor = cc.c4b(255, 255, 0, 0),
        viewRect = cc.rect(0, 0, size.width, size.height),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
    }
    self.listviewPan:addChild(self.listView)
    self.listView:setTouchEnabled(true)
    self.listView:onTouch(handler(self, self.touchListener))

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
        else
            content = display.newCutomColorLayer(cc.c4b(255,255,255,128),size.width,signHigh)
        end
        content:setContentSize(size.width, signHigh)

        local item = self.listView:newItem()
        item:addContent(content)
        item:setItemSize(size.width, signHigh)
        self.listView:addItem(item)

        --头像
        local headImg = MMUISimpleUI:getInstance():getHead(data)
        content:addChild(headImg)
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
        content:addChild(nameLab)
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
        content:addChild(levelLab)
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
        content:addChild(adaptLab)
        adaptLab:setAnchorPoint(0,0)
        adaptLab:setPosition(500, 70)
    end

    self.listView:reload()
end

--关闭按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function AddHeroView:closeCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self:addHeroRes()
    end
end
