--
-- Author: oyhc
-- Date: 2015-12-03 00:03:04
--
PubHeroListView = class("PubHeroListView")
--构造
--uiType UI类型
--data 数据
function PubHeroListView:ctor(theSelf)
	self.parent = theSelf
	self.model = self.parent.model
	self.view = Common:seekNodeByName(self.parent.root,"PubHeroList")
	-- self:init()
end

--初始化
--返回值(无)
function PubHeroListView:init(panel)
    self.panel = panel
	if self.listView ~= nil then
        self.listView:removeFromParent()
    end
    --列表背景
    self.listView = cc.ui.UIListView.new {
        -- bgColor = cc.c4b(100, 100, 100, 255),
        bgColor = cc.c4b(0, 0, 0, 0),
        viewRect = cc.rect(0, 0, 700, 1100),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
    }
    --总背景
    self.heroListBG = Common:seekNodeByName(self.view,"heroList")
    self.heroListBG:addChild(self.listView,0)
	--标题
	local lbl_title = Common:seekNodeByName(self.view,"lbl_title")
	if self.panel == TavernPanelType.TAVERN_PANEL_HALL then
		lbl_title:setString("招贤馆")
	else
		lbl_title:setString("聚贤馆")
	end
    --返回按钮
    self.btn_back = Common:seekNodeByName(self.view,"btn_back")
    self.btn_back:addTouchEventListener(handler(self,self.onBack))
    --立即刷新
    self.btn_refresh = Common:seekNodeByName(self.view,"btn_refresh")
    self.btn_refresh:addTouchEventListener(handler(self,self.onRefresh))
    self.btn_refresh:setTitleText("立即刷新")
    --刷新时间
    self.lbl_time = Common:seekNodeByName(self.view,"lbl_time")
    self.lbl_time:setString("刷新时间:00:00:00")
    --先上取整的行数
    local row = math.ceil(#self.model.pubGoldArr / 2)
    --数组索引
    local index = 0
    local myCell = Common:seekNodeByName(self.parent.root,"heroCell")
    -- myCell:setPosition(0,0)
    -- myCell:setAnchorPoint(0,0)
    --
    for i=1,row do
        local copyCell = myCell:clone()
        local copyCell1 = myCell:clone()
        copyCell1:setPosition(700,0)
        --单项
        local cell = self.listView:newItem()
        cell:setItemSize(700, 350)
        cell:setPosition(0, 1100)
        self.listView:addItem(cell)
        -- cell:setAnchorPoint(0,1)
        index = index+1
        cell:addContent(copyCell)
        self:setCellInfo(copyCell,index)
        -- self:createItem(cell,index,0)
        index = index+1
        if index <= #self.model.pubGoldArr then
            cell:addContent(copyCell1)
            self:setCellInfo(copyCell1,index)
        end

        -- self:createItem(cell,index,1)
    end
    self.listView:reload()
end

function PubHeroListView:setCellInfo(cell,index)
    local info =  self.model.pubGoldArr[index]
    if info == nil then
        return
    end
    --头像
    local img_head = Common:seekNodeByName(cell,"img_head")
    img_head:setTag(index)
    img_head:setTouchEnabled(true)
    -- 头像id
    local headID = HeroFaceConfig:getInstance():getHeroFaceByID(info.image)
    img_head:loadTexture(ResPath:getInstance():getHeroHeadPath(headID))
    img_head:addTouchEventListener(handler(self,self.onClickHead))

    -- 头像背景
    local headBG = display.newSprite(ResPath:getInstance():getHeadQualityPath(info.quality))
    headBG:setAnchorPoint(0,0)
    img_head:addChild(headBG)

    --名字
    local lbl_name = Common:seekNodeByName(cell,"lbl_name")
    lbl_name:setString(info.name)
    lbl_name:setColor(Common:getQualityColor(info.quality))
    --战斗力
    local lbl_fight = Common:seekNodeByName(cell,"lbl_fight")
    lbl_fight:setString("战斗力："..info.fightforce)
    -- 是否已经被招募
    local icon_hire = Common:seekNodeByName(cell,"icon_hire")
    if info.hired == 0 then
        icon_hire:setVisible(false)
    else
        icon_hire:setVisible(true)
    end

end

--头像点击按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function PubHeroListView:onClickHead(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        local headTag = sender:getTag()
        local clickInfo = self.model:getPubHeroInfo(headTag)
        -- print("点击英雄的id",clickInfo.name)
        self:hideView()
        -- 显示英雄详情
        self.parent.heroInfoView:showView()
        -- 加载英雄详情数据
        self.parent.heroInfoView:init(clickInfo, self.panel)
    end
end

--立即刷新按钮回调
--sender 按钮本身
--eventType 事件类型
function PubHeroListView:onRefresh(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        local str = ""
        if self.panel == TavernPanelType.TAVERN_PANEL_HALL then
            str = "立即刷新英雄别表需要花费金币".. CommonConfig:getInstance():getResHeroRefreshGold() .."，确定要立即刷新？"
        else
            str = "立即刷新英雄别表需要花费金币".. CommonConfig:getInstance():getGoldHeroRefreshGold() .."，确定要立即刷新？"
        end
        UIMgr:getInstance():openUI(UITYPE.PROP_BOX, {type=PROP_BOX_TYPE.COMMON,text=str,
            callback=handler(self, self.onSureRefresh),sureBtnText=CommonStr.SURE,cancelBtnText=CommonStr.CANCEL
        })
    end
end

--确定立即刷新按钮回调
function PubHeroListView:onSureRefresh()
    print("确定立即刷新按钮回调")
    -- 离开酒馆发送的消息包
    PubService:getInstance():sendRefreshList(self.panel,self.parent.pos)
end

--获得上次刷新时间
-- refresh_time
-- state 1为创建 2为刷新
function PubHeroListView:getRefreshTime(refresh_time,state)
    print("获得上次刷新时间",refresh_time, state)
    local leftTime = 0 -- 剩余时间
    if state == 1 then
        local passTime = Common:getOSTime() - refresh_time
        local configTime = 0
        local level = CityBuildingModel:getInstance():getBuildingLv(self.parent.pos)
        if self.panel == TavernPanelType.TAVERN_PANEL_HALL then
            print("根据等级减的招贤馆时间:",PubEffectConfig:getInstance():getResCost(level))
            configTime = CommonConfig:getInstance():getResHeroTime() - PubEffectConfig:getInstance():getResCost(level)
        else
            print("根据等级减的聚贤馆时间",PubEffectConfig:getInstance():getGoldCost(level))
            configTime = CommonConfig:getInstance():getGoldHeroTime() - PubEffectConfig:getInstance():getGoldCost(level)
        end
        -- print("刷新时间",configTime, passTime)
        leftTime = configTime - passTime
    else
        leftTime = refresh_time
    end

    print("leftTime:"..leftTime)
    TimeMgr:getInstance():createTime(leftTime,self.updateRefTime,self)
end

function PubHeroListView:updateRefTime(info)
    if info.time <= 0 then
        TimeMgr:getInstance():removeInfo(TimeType.COMMON,1)
    end
    self.lbl_time:setString("刷新时间:" .. Common:getFormatTime(info.time))
end

--返回按钮回调
--sender 按钮本身
--eventType 事件类型
function PubHeroListView:onBack(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        -- 离开酒馆发送的消息包
        PubService:getInstance():sentLevelList(self.panel)
        --
        self:hideView()
        self.parent.pubMain:setVisible(true)
    end
end

-- 显示界面
function PubHeroListView:showView()
	self.view:setVisible(true)
end

-- 隐藏界面
function PubHeroListView:hideView()
	self.view:setVisible(false)
end
