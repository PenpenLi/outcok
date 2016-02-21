
--[[
    hejun
    英雄训练列表界面
--]]

 HeroTrainView = class("HeroTrainView",UIBaseView)


--训练状态
TRAIN_TYPE =
{
    TRAINING = 1, --训练中
    TRAIN = 0, --训练
}

--构造
--uiType UI类型
--data 数据
--返回值(无)
function HeroTrainView:ctor(uiType,data)
    self.data = data
    --父类构造
    self.super.ctor(self,uiType)
    --适配屏幕
    self:adapterSize()
end

--初始化
--返回值(无)
function HeroTrainView:init()
    self.root = Common:loadUIJson(HERO_TRAIN)
    self:addChild(self.root)

    self.cellArr = {}

    --选中的英雄
    self.curSelHero = nil

    --主界面层容器
    self.view = Common:seekNodeByName(self.root,"panelHeroList")

    --训练详情界面
    self.heroTrainDetails = HeroTrainDetailsView.new(self)
    self.heroTrainDetails:hideView()
    -- 新增英雄训练界面
    self.newHeroTrain = NewHeroTrainView.new(self)
    self.newHeroTrain:hideView()
    -- 道具加速训练界面
    self.heroPropTrain = HeroTrainPropAccView.new(self)
    self.heroPropTrain:hideView()
    --关闭按钮
    self.btn_back = Common:seekNodeByName(self.view,"btn_back")
    self.btn_back:addTouchEventListener(handler(self,HeroTrainView.onBack))

    --标题
    local lbl_title = Common:seekNodeByName(self.view,"lbl_title")
    local text = Lan:lanText(1,"训练")
    lbl_title:setString(text)

    --训练剩余位置
    local buildingPos = self:getBuildingPos()
    local buildingLv = CityBuildingModel:getInstance():getBuildingLv(buildingPos)
    local pos = TrainEffectConfig:getInstance():getTrainNumByLevel(buildingLv)
    local lbl_position = Common:seekNodeByName(self.view,"lbl_position")
    local num = HeroTrainModel:getInstance():getTrainHeroCount()
    lbl_position:setString(CommonStr.TRAINING_POSITION ..  num .. "/" .. pos)

    self:createList()
end

--英雄训练列表
function HeroTrainView:createList()
    if self.listView ~= nil then
        self.listView:removeFromParent()
    end

    local heroList = PlayerData:getInstance().heroList

    if #heroList == 0 then
        Lan:hintClient(5,"你暂时还没有英雄，请到酒馆招揽英雄",nil,3)
        return
    end

    --训练剩余位置
    local buildingPos = self:getBuildingPos()
    local buildingLv = CityBuildingModel:getInstance():getBuildingLv(buildingPos)
    local pos = TrainEffectConfig:getInstance():getTrainNumByLevel(buildingLv)
    local lbl_position = Common:seekNodeByName(self.view,"lbl_position")
    local num = HeroTrainModel:getInstance():getTrainHeroCount()
    --lbl_position:setString(CommonStr.TRAINING_POSITION ..  pos.te_trainnum-num .. "/" .. pos)
    lbl_position:setString(CommonStr.TRAINING_POSITION ..  pos-num .. "/" .. pos)


    --列表背景
    self.listView = cc.ui.UIListView.new {
        -- bgColor = cc.c4b(100, 100, 100, 255),
        bgColor = cc.c4b(0, 0, 0, 0),
        viewRect = cc.rect(0, 0, 700, 1200),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
    }
    --总背景
    self.heroListBG = Common:seekNodeByName(self.view,"heroList")
    self.heroListBG:addChild(self.listView,0)
    --
    local myCell = Common:seekNodeByName(self.root,"heroCell")

    --排序
    table.sort(heroList,function(a,b) return a.state < b.state end )

    for i=1,#heroList do
        local heroData = heroList[i]
        local copyCell = myCell:clone()
        --单项
        local cell = self.listView:newItem()
        cell:setItemSize(700, 200)
        cell:setPosition(0, 1200)
        self.listView:addItem(cell)
        cell:addContent(copyCell)
        --
        self:setCellInfo(copyCell,i,heroData)
    end
    self.listView:setTouchEnabled(true)
    self.listView:onTouch(handler(self, self.onClickCell))
    self.listView:reload()
end

--获取建筑物位置
--返回值(建筑位置)
function HeroTrainView:getBuildingPos()
    return self.data.building:getTag()
end

function HeroTrainView:setCellInfo(cell,index,heroData)
    --头像
    local head = MMUISimpleUI:getInstance():getHead(heroData)
    head:setPosition(100,100)
    cell:addChild(head)
    --名字
    local lbl_name = Common:seekNodeByName(cell,"lbl_name")
    lbl_name:setString(heroData.name)
    --经验
    local lbl_experience = Common:seekNodeByName(cell,"lbl_experience")
    --等级
    local lbl_level = Common:seekNodeByName(cell,"lbl_level")
    lbl_level:setString("等级：" .. heroData.level)
    --训练状态
    local lbl_type = Common:seekNodeByName(cell,"lbl_type")

    --英雄状态
    local state = heroData:getState()
    if state ~= HeroState.train then
        local exp = heroData.exp
        local maxExp = heroData.maxexp
        local processBg = MMUIProcess:getInstance():create("citybuilding/processbg.png","citybuilding/process.png",cell,exp,maxExp,0.7)
        processBg:setPosition(350,80)
    end

    if state == HeroState.normal then
        lbl_type:setString(CommonStr.NORMAL)
    elseif state == HeroState.train then
        lbl_type:setString(CommonStr.IN_TRAINING)
        lbl_experience:setVisible(true)
        local buildingPos = self:getBuildingPos()
        local buildingLv = CityBuildingModel:getInstance():getBuildingLv(buildingPos)
        local experience = heroData.trainHour * TrainEffectConfig:getInstance():getConfigInfo(buildingLv).te_exp
        lbl_experience:setString(CommonStr.CAN_EXPERIENCE .. experience)
    elseif state == HeroState.finish_train then
        lbl_type:setString(CommonStr.COMPLETE_TRAINING)
    elseif state == HeroState.def then
        lbl_type:setString(CommonStr.STATIONED)
    elseif state == HeroState.battle then
        local text = Lan:lanText(2,"出征")
        lbl_type:setString(text)
    end

    --时间
    local lbl_time = Common:seekNodeByName(cell,"lbl_time")
    lbl_time:setString(CommonStr.LEFT_TIME)
    if heroData:getTrainTime() > 0 then
        lbl_time:setVisible(true)
        TimeMgr:getInstance():createTime(heroData:getTrainTime(),self.onTime,self,nil,index)
    else
        lbl_time:setVisible(false)
    end

    local info = {}
    info.id = index
    info.labTime = lbl_time

    table.insert(self.cellArr,info)
end

function HeroTrainView:onTime(info)
    local lbl_time = nil
    for k,v in pairs(self.cellArr) do
        if v.id == info.id then
            lbl_time = v.labTime
        end
    end

    if lbl_time == nil then
        return
    end

    local leftTime = Common:getFormatTime(info.time)
    lbl_time:setString(CommonStr.LEFT_TIME .. leftTime)
    if info.time == 0 then
        lbl_time:setVisible(false)
        TimeMgr:getInstance():removeInfo(TimeType.COMMON,info.id)
        Prop:getInstance():showMsg(CommonStr.COMPLETE_TRAINING_RECEIVE,3)
        UIMgr:getInstance():closeUI(UITYPE.HERO_TRAIN)
    end
end

--英雄详情按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function HeroTrainView:onClickCell(event)
    if "clicked" == event.name then
        local heroData = PlayerData:getInstance().heroList[event.itemPos]
        local buildingPos = self:getBuildingPos()
        local buildingLv = CityBuildingModel:getInstance():getBuildingLv(buildingPos)
        local pos = TrainEffectConfig:getInstance():getConfigInfo(buildingLv)
        local num = HeroTrainModel:getInstance():getTrainHeroCount()

        self.curSelHero = heroData
        local state = heroData:getState()

        if state == HeroState.def then
            Lan:hintClient(2,"您的英雄正驻扎在城墙无法训练")
            return
        elseif state == HeroState.battle then
            Lan:hintClient(3,"您的英雄正出征无法训练")
            return
        elseif state == HeroState.finish_train then
            Lan:hintClient(4,"当前英雄已完成训练，请退出当前页面领取英雄",nil,3)
            return
        end

        --TimeMgr:getInstance():removeInfoByType(TimeType.COMMON)
        if state == HeroState.train then  --训练中
            self.view:setVisible(false)
            self:hideView()
            self.heroTrainDetails:showView()
            self.heroTrainDetails:setData(heroData)
        else
            if pos.te_trainnum <= num then
                Prop:getInstance():showMsg(CommonStr.NO_TRAINING_VACANCIES)
                return
            end
            self:hideView()
            self.newHeroTrain:showView()
            -- 加载英雄信息
            self.newHeroTrain:setData(heroData)
        end
    end
end

--UI加到舞台后会调用这个接口
--返回值(无)
function HeroTrainView:onEnter()
    --MyLog("HeroTrainView onEnter...")
end

--UI离开舞台后会调用这个接口
--返回值(无)
function HeroTrainView:onExit()
    print("HeroTrainView:onExit()")
    TimeMgr:getInstance():removeInfoByType(TimeType.COMMON)
end

--析构函数(此时已经从内存中释放掉资源了)
--返回值(无)
function HeroTrainView:onDestroy()
    --MyLog("--HeroTrainView:onDestroy")
end

--关闭按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function HeroTrainView:onBack(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        UIMgr:getInstance():openUI(UITYPE.BUILDING_MENU, {building=self.data.building})
        UIMgr:getInstance():closeUI(self.uiType)
    end
end

-- 显示界面
function HeroTrainView:showView()
    self.view:setVisible(true)
end

-- 隐藏界面
function HeroTrainView:hideView()
    self.view:setVisible(false)
end