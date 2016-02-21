--[[
    hejun
    瞭望塔界面
--]]

WatchTowerView = class("WatchTowerView",UIBaseView)

--构造
--uiType UI类型
--data 数据
--返回值(无)
function WatchTowerView:ctor(uiType,data)
    self.data = data
    self.watchtowerList = {}     --瞭望塔列表信息
    self.super.ctor(self,uiType)
    self:adapterSize()
end

--初始化
--返回值(无)
function WatchTowerView:init()
    self.root = Common:loadUIJson(CITY_WATCHTOWER)
    self:addChild(self.root)
    self.root:setTouchEnabled(false)

    self.type = 2

    --关闭按钮
    self.closeBtn = Common:seekNodeByName(self.root,"closeBtn")
    self.closeBtn:addTouchEventListener(handler(self,self.closeCallback))
    --列表详情界面
    self.contentDetails = Common:seekNodeByName(self.root,"contentDetails")
    --瞭望塔列表界面
    self.watchtowerContent = Common:seekNodeByName(self.root,"watchtowerContent")
    --全部忽略按钮
    self.ignoreBtn = Common:seekNodeByName(self.root,"ignoreBtn")
    self.ignoreBtn:addTouchEventListener(handler(self,self.ignoreBtnCallback))

    self:sendRequestList()
    --瞭望塔列表
    --self:watchtowerListView()
    --详情列表
    --self:contentDetailsListView()
end

--发送瞭望塔列表请求
function WatchTowerView:sendRequestList()
    WatchTowerService:sendGetWatchTowerReportReq(self.data.pos)
end

--发送瞭望塔列表详情请求
function WatchTowerView:sendDetailtList(marchingid)
    WatchTowerService:sendGetWatchTowerDetail(self.data.pos,marchingid)
end

--创建瞭望塔ListView
--返回值(无)
function WatchTowerView:updateWatchtowerList()
    if self.watchtowerListView ~= nil then
        self.watchtowerListView:removeFromParent()
    end
    self.watchtowerListView = cc.ui.UIListView.new {
        bgColor = cc.c4b(0, 0, 0, 0),
        viewRect = cc.rect(0, 150, 750, 1100),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
    }
    --点击item
    :onTouch(handler(self, self.touchList))
    self.watchtowerListView:setTouchEnabled(true)
    --主背景
    self.listInfoBox = Common:seekNodeByName(self.root,"watchtowerContent")
    self.listInfoBox:addChild(self.watchtowerListView,1000)

    -- add items
    for k,v in pairs(WatchTowerModel:getInstance():getList()) do
        local item = self.watchtowerListView:newItem()
        local content = display.newNode()
        content:setContentSize(750, 120)
        item:addContent(content)
        item:setItemSize(750, 180)
        self.watchtowerListView:addItem(item)

        --瞭望塔列表控件保存
        self.watchtowerList[k] = {}

        --头像
        local headImg = cc.ui.UIPushButton.new("test/skills20200.png")
        headImg:setPosition(100, 30)
        headImg:addTo(content)
        headImg:setTouchSwallowEnabled(false)
        self.watchtowerList[k].headImg = headImg
        --领主名字
        local nameLab = cc.ui.UILabel.new(
                {text = "领主名字:"..v.name,
                size = 26,
                align = cc.ui.TEXT_ALIGN_CENTER,
                color = display.COLOR_WHITE})
        nameLab:setPosition(200, 95)
        nameLab:addTo(content)
        self.watchtowerList[k].nameLab = nameLab
        --行军目的
        local typeStr = nil
        if v.type == 0 then
            typeStr = "侦查"
        else
            typeStr = "攻击"
        end

        local marchPurposeLab = cc.ui.UILabel.new(
                {text = "行军目的:"..typeStr,
                size = 26,
                align = cc.ui.TEXT_ALIGN_CENTER,
                color = display.COLOR_WHITE})
        marchPurposeLab:setPosition(200, 45)
        marchPurposeLab:addTo(content)
        self.watchtowerList[k].marchPurposeLab = marchPurposeLab
         --剩余时间
        local leftTime = CityBuildingModel:getLeftUpBuildingTime(v.startTime,v.interval)
        --到达时间
        local timeLab = cc.ui.UILabel.new(
                {text = "到达时间:"..Common:getFormatTime(leftTime),
                size = 26,
                align = cc.ui.TEXT_ALIGN_CENTER,
                color = display.COLOR_WHITE})
        timeLab:setPosition(200, -10)
        timeLab:addTo(content)
        self.watchtowerList[k].leftTime = leftTime
        self.watchtowerList[k].timeLab = timeLab

        --倒计时相关
        -- local process = UICommon:createProgress(leftTime,content,"test/expbase.png","test/expbar.png",cc.p(500,300),cc.p(0,0),1000,10000)
        local timeInfo = TimeMgr:getInstance():findTypeInfoByIndex(TimeType.UPDATE_WATCH_TOWER,1,k)
        if not timeInfo then
            local info = {}
            info.index = 1
            info.k = k
            info.id = v.id
            TimeMgr:getInstance():addInfo(TimeType.UPDATE_WATCH_TOWER, info, k,self.updateTime, self)
        else
            timeInfo.pause = false
        end
    end
    self.watchtowerListView:reload()
end

--更新时间
--dt 时间
--返回值(无)
function WatchTowerView:updateTime(info)
    if self.watchtowerList == nil then
        return
    end
    local v = self.watchtowerList[info.k]
    local lab = v.timeLab
    v.leftTime = v.leftTime - 1
    if v.leftTime < 0 then
        v.leftTime = 0
        local timeInfo = TimeMgr:getInstance():findTypeInfoByIndex(TimeType.UPDATE_WATCH_TOWER,1,info.k)
        if timeInfo ~= nil then
            TimeMgr:getInstance():removeTypeInfoByIndex(TimeType.UPDATE_WATCH_TOWER,1,info.k)
        end
        -- WatchTowerModel:getInstance():delWatchtowerDataByID(info.id)
    end

    local timeStr = Common:getFormatTime(v.leftTime)
    lab:setString("到达时间:"..timeStr)
end

--创建列表详情ListView
--返回值(无)
function WatchTowerView:getWatchtowerDetail(info)
    if self.detailsListView ~= nil then
        self.detailsListView:removeFromParent()
    end

    self.detailsListView = cc.ui.UIListView.new {
        bgColor = cc.c4b(0, 0, 0, 0),
        viewRect = cc.rect(0, 150, 750, 1100),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
    }

    --主背景
    self.listInfoBox = Common:seekNodeByName(self.root,"contentDetails")
    self.listInfoBox:addChild(self.detailsListView,0)

    local item = self.detailsListView:newItem()
    local content = display.newNode()
    content:setContentSize(750, 120)
    item:addContent(content)
    item:setItemSize(750, 240)
    self.detailsListView:addItem(item)


    --头像
    local detailsHeadImg = cc.ui.UIPushButton.new("test/skills20200.png")
    detailsHeadImg:setPosition(100, 50)
    detailsHeadImg:addTo(content)
    detailsHeadImg:setTouchSwallowEnabled(false)

    --领主名字
    local detailsNameLab = cc.ui.UILabel.new(
            {text = "领主名字:" .. info.name,
            size = 26,
            align = cc.ui.TEXT_ALIGN_CENTER,
            color = display.COLOR_WHITE})
    detailsNameLab:setPosition(200, 95)
    detailsNameLab:addTo(content)

     --领主名字
    local detailsNameLab = cc.ui.UILabel.new(
            {text = "等级:" .. info.level,
            size = 26,
            align = cc.ui.TEXT_ALIGN_CENTER,
            color = display.COLOR_WHITE})
    detailsNameLab:setPosition(500, 95)
    detailsNameLab:addTo(content)

    --行军目的
        local typeStr = nil
        if info.type == 0 then
            typeStr = "侦查"
        else
            typeStr = "攻击"
        end

    --行军目的
    local detailMarchPurposeLab = cc.ui.UILabel.new(
            {text = "行军目的:" .. typeStr,
            size = 26,
            align = cc.ui.TEXT_ALIGN_CENTER,
            color = display.COLOR_WHITE})
    detailMarchPurposeLab:setPosition(200, 45)
    detailMarchPurposeLab:addTo(content)
    --坐标
    local detailCoordinateLab = cc.ui.UILabel.new(
            {text = "X:" .. info.x .. "Y:" .. info.y,
            size = 26,
            align = cc.ui.TEXT_ALIGN_CENTER,
            color = display.COLOR_WHITE})
    detailCoordinateLab:setPosition(500, 45)
    detailCoordinateLab:addTo(content)
    --剩余时间
    local leftTime = CityBuildingModel:getLeftUpBuildingTime(info.startTime,info.interval)
    --到达时间
    local timeLab = cc.ui.UILabel.new(
            {text = "到达时间:"..Common:getFormatTime(leftTime),
            size = 26,
            align = cc.ui.TEXT_ALIGN_CENTER,
            color = display.COLOR_WHITE})
    timeLab:setPosition(200, -10)
    timeLab:addTo(content)

    --倒计时相关
    -- local process = UICommon:createProgress(leftTime,content,"test/expbase.png","test/expbar.png",cc.p(500,300),cc.p(0,0),1000,10000)
    self.timeInfo = TimeMgr:getInstance():findTypeInfoByIndex(TimeType.UPDATE_WATCH_TOWER_DETAILS,1,1)
    if not timeInfo then
        local info = {}
        info.index = 1
        info.id = info.id
        info.timeLab = timeLab
        info.leftTime = leftTime
        TimeMgr:getInstance():addInfo(TimeType.UPDATE_WATCH_TOWER_DETAILS, info, 1,self.updateTime1, self)
    else
        timeInfo.pause = false
    end

    --部队列表
    if info.type == 1 then

        for k,v in pairs(info.armsArray) do
            print("dddddddddddddddddddd",v.unmber)
            --士兵类型和等级
            local levelLab = cc.ui.UILabel.new(
                    {text = self:getOccupationName(v.type,v.level),
                    size = 26,
                    align = cc.ui.TEXT_ALIGN_CENTER,
                    color = display.COLOR_WHITE})
            levelLab:setPosition(150, - 60 * k)
            levelLab:addTo(content)
            --士兵等级
            local numberLab = cc.ui.UILabel.new(
                    {text = "士兵数量：" .. v.number,
                    size = 26,
                    align = cc.ui.TEXT_ALIGN_CENTER,
                    color = display.COLOR_WHITE})
            numberLab:setPosition(400, - 60 * k)
            numberLab:addTo(content)
        end
    end
    self.detailsListView:reload()
end

--获取职业名称
--type --士兵类型
--lv 等级
--返回值(士兵名称)
function WatchTowerView:getOccupationName(type,lv)
    if type == nil then
        return
    end
    return "" .. lv .. CommonStr.LEVEL .. ArmsData:getInstance():getOccupatuinName(type)
end

--更新时间
--dt 时间
--返回值(无)
function WatchTowerView:updateTime1(info)
    local lab = info.timeLab
    info.leftTime = info.leftTime - 1
    if info.leftTime < 0 then
        info.leftTime = 0
        local timeInfo = TimeMgr:getInstance():findTypeInfoByIndex(TimeType.UPDATE_WATCH_TOWER_DETAILS,1,1)
        if timeInfo ~= nil then
            TimeMgr:getInstance():removeTypeInfoByIndex(TimeType.UPDATE_WATCH_TOWER_DETAILS,1,1)
        end
        -- WatchtowerData:getInstance():delWatchtowerDataByID(info.id)
    end

    local timeStr = Common:getFormatTime(info.leftTime)
    lab:setString("到达时间:"..timeStr)
end

--点击item
--返回值(无)
function WatchTowerView:touchList(event)
    local watchtowerListView = event.watchtowerListView
    if "clicked" == event.name then
        self:setPanVis(false)
        self.contentDetails:setVisible(true)
        self.type = 1
        local info = WatchTowerModel:getInstance():getWatchtowerDataByIndex(event.itemPos)
        self:sendDetailtList(info.marchingid)
    end
end

--隐藏显示建筑详请面板
--visible (true:显示，false:隐藏)
--返回值(无)
function WatchTowerView:setPanVis(visible)
    self.contentDetails:setVisible(visible)
    self.watchtowerContent:setVisible(visible)
end

--全部忽略按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function WatchTowerView:ignoreBtnCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        UICommon:getInstance():delBlankPic()
    end
end

--UI加到舞台后都会调用这个接口
--返回值(无)
function WatchTowerView:onEnter()
    --MyLog("WatchTowerView onEnter...")
    UICommon:getInstance():setMapTouchAable(false)
end

--UI离开舞台后都会调用这个接口
--返回值(无)
function WatchTowerView:onExit()
    --MyLog("WatchTowerView onExit()")
    UICommon:getInstance():setMapTouchAable(true)
    local timeInfo = TimeMgr:getInstance():findTypeInfoByIndex(TimeType.UPDATE_WATCH_TOWER_DETAILS,1,1)
    if timeInfo ~= nil then
        TimeMgr:getInstance():removeTypeInfoByIndex(TimeType.UPDATE_WATCH_TOWER_DETAILS,1,1)
    end
end

--析构函数(此时已经从内存中释放掉资源了)
--返回值(无)
function WatchTowerView:onDestroy()
    --MyLog("WatchTowerView:onDestroy")
end

--关闭按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function WatchTowerView:closeCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        MyLog("close click...")
        UIMgr:getInstance():openUI(UITYPE.BUILDING_MENU, {building=self.data.building})
        if self.type == 1 then
            self:setPanVis(false)
            self.watchtowerContent:setVisible(true)
            self.type = 2
        else
            UIMgr:getInstance():closeUI(self.uiType)
        end
    end
end