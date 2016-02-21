
--[[
    hejun
    新增英雄训练界面
--]]

 NewHeroTrainView = class("NewHeroTrainView")


--构造
--uiType UI类型
--data 数据
function NewHeroTrainView:ctor(theSelf)
    self.parent = theSelf
    self.view2 = Common:seekNodeByName(self.parent.root,"panelNewHero")
    self:init()
end

--初始化
--返回值(无)
function NewHeroTrainView:init()

    self.selected = 1

    self.wood = 0
    self.food = 0
    self.iron = 0
    self.mithril = 0

    -- 关闭按钮
    self.btn_back = Common:seekNodeByName(self.view2,"btn_back")
    self.btn_back:addTouchEventListener(handler(self,NewHeroTrainView.onBack))

    --标题
    self.lbl_title1 = Common:seekNodeByName(self.view2,"lbl_title1")
    self.lbl_title1:setString(CommonStr.NEW_TRAINING)

    --英雄名字
    self.lbl_name1 = Common:seekNodeByName(self.view2,"lbl_name1")

    --英雄等级
    self.lbl_level1 = Common:seekNodeByName(self.view2,"lbl_level1")

    --选择时间
    self.lbl_selectionTime = Common:seekNodeByName(self.view2,"lbl_selectionTime")
    self.lbl_selectionTime:setString(CommonStr.SELECTION_TIME)

    --时间1
    self.lbl_selectionTime1 = Common:seekNodeByName(self.view2,"lbl_selectionTime1")
    local buildingPos = self.parent:getBuildingPos()
    local buildingType = CityBuildingModel:getInstance():getBuildType(buildingPos)
    local buildingLv = CityBuildingModel:getInstance():getBuildingLv(buildingPos)
    local experience1 = TrainEffectConfig:getInstance():getConfigInfo(buildingLv).te_exp * CommonConfig:getInstance():getTrainHeroTime1()
    self.lbl_selectionTime1:setString(CommonConfig:getInstance():getTrainHeroTime1() .. CommonStr.AVAILABLE_EXPERIENCE .. experience1)

    --时间2
    self.lbl_selectionTime2 = Common:seekNodeByName(self.view2,"lbl_selectionTime2")
    local experience2 = TrainEffectConfig:getInstance():getConfigInfo(buildingLv).te_exp * CommonConfig:getInstance():getTrainHeroTime2()
    self.lbl_selectionTime2:setString(CommonConfig:getInstance():getTrainHeroTime2()  .. CommonStr.AVAILABLE_EXPERIENCE .. experience2)

    --时间3
    self.lbl_selectionTime3 = Common:seekNodeByName(self.view2,"lbl_selectionTime3")
    local experience3 = TrainEffectConfig:getInstance():getConfigInfo(buildingLv).te_exp * CommonConfig:getInstance():getTrainHeroTime3()
    self.lbl_selectionTime3:setString(CommonConfig:getInstance():getTrainHeroTime3()  .. CommonStr.AVAILABLE_EXPERIENCE .. experience3)

    --损耗1
    self.lbl_consume1 = Common:seekNodeByName(self.view2,"lbl_consume1")
    self.lbl_consume1:setString(CommonStr.FOOD)

    --损耗2
    self.lbl_consume2 = Common:seekNodeByName(self.view2,"lbl_consume2")
    self.lbl_consume2:setString(CommonStr.WOOD)

    --损耗3
    self.lbl_consume3 = Common:seekNodeByName(self.view2,"lbl_consume3")
    self.lbl_consume3:setString(CommonStr.IRON)

    --损耗4
    self.lbl_consume4 = Common:seekNodeByName(self.view2,"lbl_consume4")
    self.lbl_consume4:setString(CommonStr.MITHRIL)

    --金币
    self.lbl_gold = Common:seekNodeByName(self.view2,"lbl_gold")
    local gold = CommonConfig:getInstance():getTrainingGold() * self.selected
    self.lbl_gold:setString(gold .. CommonStr.GOLD)

    --复选框
    self.check1 = Common:seekNodeByName(self.view2,"check1")
    self.check1:addTouchEventListener(handler(self,NewHeroTrainView.onCheck1))
    self.check1:setSelected(true)
    self.check1:setTouchEnabled(false)
    self.check2 = Common:seekNodeByName(self.view2,"check2")
    self.check2:addTouchEventListener(handler(self,NewHeroTrainView.onCheck2))
    self.check3 = Common:seekNodeByName(self.view2,"check3")
    self.check3:addTouchEventListener(handler(self,NewHeroTrainView.onCheck3))
    print(self.check1:isSelected())
    print(self.check2:isSelected())

    --立即训练
    self.lbl_immediateTraining = Common:seekNodeByName(self.view2,"lbl_immediateTraining")
    self.lbl_immediateTraining:setString(CommonStr.RIGHTNOW_TRAIN)
    self.btn_immediateTraining = Common:seekNodeByName(self.view2,"btn_immediateTraining")
    self.btn_immediateTraining:addTouchEventListener(handler(self,NewHeroTrainView.onImmediateTraining))

    --开始训练按钮
    self.btn_training = Common:seekNodeByName(self.view2,"btn_training")
    self.btn_training:setTitleText(CommonStr.START_TRAINING)
    self.btn_training:addTouchEventListener(handler(self,NewHeroTrainView.onTraining))

    self:getCost()
end

function NewHeroTrainView:setData(hero)
    self.hero = hero
    self.lbl_level1:setString(CommonStr.GRADE .. ":" .. self.hero.level)
    self.lbl_name1:setString(self.hero.name)

    --经验条
    local exp = self.hero.exp
    local maxExp = self.hero.maxexp
    local processBg = MMUIProcess:getInstance():create("citybuilding/processbg.png","citybuilding/process.png",self.view2,exp,maxExp,0.7)
    processBg:setPosition(440,1030)

    --头像
    local head = MMUISimpleUI:getInstance():getHead(hero)
    head:setPosition(150,1100)
    self.view2:addChild(head)

    --删除定时器
    TimeMgr:getInstance():removeInfoByType(TimeType.COMMON)

    self:resetData()
end

--勾选1
--返回值(无)
function NewHeroTrainView:onCheck1(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        if self.check1:isSelected() == false then
            self.selected = CommonConfig:getInstance():getTrainHeroTime1()
            self.check2:setSelected(false)
            self.check3:setSelected(false)
            self.check1:setTouchEnabled(false)
            self.check2:setTouchEnabled(true)
            self.check3:setTouchEnabled(true)
            self:getCost()
        end
    end
end

--勾选2
--返回值(无)
function NewHeroTrainView:onCheck2(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        if self.check2:isSelected() == false then
            self.selected = CommonConfig:getInstance():getTrainHeroTime2()
            self.check1:setSelected(false)
            self.check3:setSelected(false)
            self.check1:setTouchEnabled(true)
            self.check2:setTouchEnabled(false)
            self.check3:setTouchEnabled(true)
            self:getCost()
        end
    end
end

--勾选3
--返回值(无)
function NewHeroTrainView:onCheck3(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        if self.check3:isSelected() == false then
            self.selected = CommonConfig:getInstance():getTrainHeroTime3()
            self.check1:setSelected(false)
            self.check2:setSelected(false)
            self.check1:setTouchEnabled(true)
            self.check2:setTouchEnabled(true)
            self.check3:setTouchEnabled(false)
            self:getCost()
        end
    end
end

function NewHeroTrainView:resetData()
    self.selected = 1
    self.check1:setSelected(true)
    self.check2:setSelected(false)
    self.check3:setSelected(false)
    self.check1:setTouchEnabled(false)
    self.check2:setTouchEnabled(true)
    self.check3:setTouchEnabled(true)
end

function NewHeroTrainView:getCost()
    local buildingPos = self.parent:getBuildingPos()
    local buildingInfo = CityBuildingModel:getInstance():getBuildInfo(buildingPos)
    local info = TrainEffectConfig:getInstance():getConfigInfo(buildingInfo.level)
    if info.te_wood ~= 0 then
        self.wood = info.te_wood * self.selected
    end
    if info.te_grain ~= 0 then
        self.grain = info.te_grain * self.selected
    end
    if info.te_iron ~= 0 then
        self.iron = info.te_iron * self.selected
    end
    if info.te_mithril ~= 0 then
        self.mithril = info.te_mithril * self.selected
    end

    local gold = CommonConfig:getInstance():getTrainingGold() * self.selected
    self.lbl_gold:setString(gold .. CommonStr.GOLD)

    if self.grain == 0 then
        self.lbl_consume1:setVisible(false)
    else
        self.lbl_consume1:setVisible(true)
        self.lbl_consume1:setString(CommonStr.FOOD .. ":" .. self.grain)
    end
    if self.wood == 0 then
        self.lbl_consume2:setVisible(false)
    else
        self.lbl_consume2:setVisible(true)
        self.lbl_consume2:setString(CommonStr.WOOD .. ":" .. self.wood)
    end
    if self.iron == 0 then
        self.lbl_consume3:setVisible(false)
    else
        self.lbl_consume3:setVisible(true)
        self.lbl_consume3:setString(CommonStr.IRON .. ":" .. self.iron)
    end
    if self.mithril == 0 then
        self.lbl_consume4:setVisible(false)
    else
        self.lbl_consume4:setVisible(true)
        self.lbl_consume4:setString(CommonStr.MITHRIL .. ":" .. self.mithril)
    end
end

--判断资源
function NewHeroTrainView:isCanTrain()
    --粮食判断
    if self.food > PlayerData:getInstance():getFood() then
        print("粮食不足")
        Prop:getInstance():showMsg(CommonStr.NOT_ENOUGH_FOOD)
        return
    end
    --木头判断
    if self.wood > PlayerData:getInstance().wood then
        print("木头不足")
        Prop:getInstance():showMsg(CommonStr.NOT_ENOUGH_WOOD)
        return
    end
    --铁矿判断
    if self.iron > PlayerData:getInstance().iron then
        print("铁矿不足")
        Prop:getInstance():showMsg(CommonStr.NOT_ENOUGH_IRON)
        return
    end
    --秘银判断
    if self.mithril > PlayerData:getInstance().mithril then
        print("秘银不足")
        Prop:getInstance():showMsg(CommonStr.NOT_ENOUGH_MITHRIL)
        return
    end

    return true
end

--立即训练按钮回调
--返回值(无)
function NewHeroTrainView:onImmediateTraining(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        local pos = self.parent:getBuildingPos()
        local buildingGold = CommonConfig:getInstance():getTrainingGold() * self.selected
        local title2 = ""
        local title = CommonStr.SURECAST .. buildingGold .. CommonStr.GOLD_FINISH_TRAIN
            UIMgr:getInstance():openUI(UITYPE.PROP_BOX, {type=PROP_BOX_TYPE.MONEY_ACCELERATION,text=title,timeText=title2,
                    callback=handler(self, self.sendImmediateTraining),sureBtnText=CommonStr.YES,cancelBtnText=CommonStr.NO,buildingPos=pos
            })
    end
end

--发送立即训练请求
--返回值(无)
function NewHeroTrainView:sendImmediateTraining()
    if self:isCanTrain() then
        local castGold = CommonConfig:getInstance():getTrainingGold() * self.selected
        if castGold > PlayerData:getInstance().gold then
            Prop:getInstance():showMsg(CommonStr.NO_GOLD_RIGHTNOW_TRAIN)
            return
        end

        local buildingPos = self.parent:getBuildingPos()
        local buildingLv = CityBuildingModel:getInstance():getBuildingLv(buildingPos)
        HeroTrainService:getInstance():sendGoldTrainingHero(1,self.hero.heroid,self.selected,castGold,buildingLv)
    end
end

--开始训练按钮回调
--返回值(无)
function NewHeroTrainView:onTraining(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        if self:isCanTrain() then
            local buildingPos = self.parent:getBuildingPos()
            local buildingLv = CityBuildingModel:getInstance():getBuildingLv(buildingPos)
            HeroTrainService:getInstance():sendTrainingHero(self.hero.heroid,self.selected,PlayerData:getInstance():getHeroIndexByID(self.hero.id),buildingLv)
        end
    end
end

--现实英雄列表
--返回值(无)
function NewHeroTrainView:showHeroList()
    self:hideView()
    self.parent.view:setVisible(true)
    self.parent:createList()
end

--关闭按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function NewHeroTrainView:onBack(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self:hideView()
        self.parent.view:setVisible(true)
        self.parent:createList()
    end
end

-- 显示界面
function NewHeroTrainView:showView()
    self.view2:setVisible(true)
end

-- 隐藏界面
function NewHeroTrainView:hideView()
    self.view2:setVisible(false)
end

--获取选中的是训练时间
function NewHeroTrainView:getSelectTrainTime()
   return self.selected
end

