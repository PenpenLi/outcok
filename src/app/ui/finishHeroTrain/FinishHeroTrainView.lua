--[[
    jinyan.zhang
    完成英雄训练
--]]

FinishHeroTrainView = class("FinishHeroTrainView",UIBaseView)

local scheduler = require("framework.scheduler")  --定时器

--构造
--uiType UI类型
--data 数据
--返回值(无)
function FinishHeroTrainView:ctor(uiType,data)
    self.battle = data.battle
    self.data = data.info
    self.super.ctor(self,uiType)
    self:adapterSize()
end

--初始化
--返回值(无)
function FinishHeroTrainView:init()
    self.root = Common:loadUIJson(HERO_FINISH_TRAIN)
    self:addChild(self.root)

    --确定按钮
    self.sureBtn = Common:seekNodeByName(self.root,"btn_sure")
    self.sureBtn:setTitleText(CommonStr.SURE)
    self.sureBtn:addTouchEventListener(handler(self,self.sureCallback))

    --标题
    self.titleLab = Common:seekNodeByName(self.root,"lab_title")
    self.titleLab:setString(CommonStr.TRAIN_FINISH)

    --列表层
    self.listviewPan = Common:seekNodeByName(self.root,"listviewPan")
    self:createList()
end

--创建英雄列表
--返回值(无)
function FinishHeroTrainView:createList()
    if self.listView ~= nil then
        self.listView:removeFromParent()
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

    for i=1,#self.data do
        local data = self.data[i]
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
        local headImg = MMUISimpleUI:getInstance():getHead(data.hero)
        content:addChild(headImg)
        headImg:setPosition(80, 70)
        headImg:setScale(0.5)

        --名字等级
        local nameLab = display.newTTFLabel({
            text = "",
            font = "Arial",
            size = 24,
            color = cc.c3b(255, 255, 255), 
            align = cc.TEXT_ALIGNMENT_LEFT,
        })
        content:addChild(nameLab)
        nameLab:setAnchorPoint(0,0)
        nameLab:setPosition(250, 70)
        nameLab:setString(data.name .. "  " .. data.curLevel)

        --进度条
        local proceeBg = display.newSprite("citybuilding/processbg.png")
        content:addChild(proceeBg)
        proceeBg:setPosition(440, 40)
        local processBar = ccui.LoadingBar:create()
        processBar:setAnchorPoint(0,0)
        processBar:loadTexture("citybuilding/process.png")
        proceeBg:addChild(processBar)
        processBar:setPercent(data.curPer)

        data.nameLab = nameLab
        data.proceeBar = processBar
    end

    self.listView:reload()
end

--UI加到舞台后都会调用这个接口
--返回值(无)
function FinishHeroTrainView:onEnter()
    UICommon:getInstance():setMapTouchAable(false)
    self:openTime()
end

--UI离开舞台后都会调用这个接口
--返回值(无)
function FinishHeroTrainView:onExit()
    --MyLog("FinishHeroTrainView onExit()")
    UICommon:getInstance():setMapTouchAable(true)
    self:stopTime()
end

--析构函数(此时已经从内存中释放掉资源了)
--返回值(无)
function FinishHeroTrainView:onDestroy()
    --MyLog("FinishHeroTrainView:onDestroy")
end

--打开定时器
--返回值(无)
function FinishHeroTrainView:openTime()
    if self.handle ~= nil then
        return
    end
    self:stopTime()
    self.handle = scheduler.scheduleGlobal(handler(self, self.updateTime), 0.05)
end

--停止定时器
--返回值(无)
function FinishHeroTrainView:stopTime()
    if self.handle ~= nil then
        scheduler.unscheduleGlobal(self.handle)
        self.handle = nil
    end
end

--更新定时器
function FinishHeroTrainView:updateTime(dt)
    local per = 0
    for k,v in pairs(self.data) do
        local del = false
        v.curPer = v.curPer + v.addPer
        per = v.curPer
        if v.upLvTimer == 0 then
            if v.curPer >= v.per then
                v.curPer = v.per
                per = v.curPer
                del = true
            end
        else
            if v.curPer >= 100 then
                 v.curPer = 0
                 per = 100
                 v.upLvTimer = v.upLvTimer - 1
                 v.curLevel = v.curLevel + 1 
                 v.nameLab:setString(v.name .. "  " .. v.curLevel)
            end 
        end
        v.proceeBar:setPercent(per)

        if del then
            self.data[k] = nil
        end     
    end
end

--确定按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function FinishHeroTrainView:sureCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        PlayerData:getInstance():increaseBattleForce(self.battle)
        UIMgr:getInstance():closeUI(self.uiType)
    end
end

