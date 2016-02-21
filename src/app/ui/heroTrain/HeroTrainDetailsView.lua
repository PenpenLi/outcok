
--[[
    hejun
    英雄训练详情界面
--]]

 HeroTrainDetailsView = class("HeroTrainDetailsView")


--构造
--uiType UI类型
--data 数据
function HeroTrainDetailsView:ctor(theSelf)
    self.parent = theSelf
    self.view = Common:seekNodeByName(self.parent.root,"panelTraining")
    self:init()
end

--初始化
--返回值(无)
function HeroTrainDetailsView:init()
    --关闭按钮
    self.btn_back = Common:seekNodeByName(self.view,"btn_back")
    self.btn_back:addTouchEventListener(handler(self,self.onBack))

    --标题
    self.lbl_title2 = Common:seekNodeByName(self.view,"lbl_title2")
    self.lbl_title2:setString(CommonStr.IN_TRAINING)

    --英雄名字
    self.lbl_name2 = Common:seekNodeByName(self.view,"lbl_name2")


    --英雄等级
    self.lbl_level2 = Common:seekNodeByName(self.view,"lbl_level2")

    --剩余时间
    self.lbl_time2 = Common:seekNodeByName(self.view,"lbl_time2")

    --经验
    self.lbl_experience2 = Common:seekNodeByName(self.view,"lbl_experience2")

    --取消训练按钮
    self.btn_cancel = Common:seekNodeByName(self.view,"btn_cancel")
    self.btn_cancel:setTitleText(CommonStr.CANCEL_TRAIN)
    self.btn_cancel:addTouchEventListener(handler(self,self.onCancel))

    --金币加速按钮
    self.lbl_gold = Common:seekNodeByName(self.view,"lbl_gold")
    self.lbl_gold:setString(CommonStr.RIGHTNOW_TRAIN)
    self.lbl_gold2 = Common:seekNodeByName(self.view,"lbl_gold2")
    self.lbl_gold2:setString("" .. CommonStr.GOLD)
    self.btn_gold = Common:seekNodeByName(self.view,"btn_gold")
    self.btn_gold:addTouchEventListener(handler(self,self.onGold))
    self.btn_gold2 = Common:seekNodeByName(self.view,"btn_gold2")
    self.btn_gold2:addTouchEventListener(handler(self,self.onGold))
    self.lbl_2gold = Common:seekNodeByName(self.view,"lbl_2gold")
    self.lbl_2gold:setString(CommonStr.RIGHTNOW_TRAIN)
    self.lbl_2gold2 = Common:seekNodeByName(self.view,"lbl_2gold2")
    self.lbl_2gold2:setString("" .. CommonStr.GOLD)


    --道具加速按钮
    self.btn_prop = Common:seekNodeByName(self.view,"btn_prop")
    self.btn_prop:setTitleText(CommonStr.PROP_SPEED)
    self.btn_prop:addTouchEventListener(handler(self,self.onProp))
    if HeroTrainModel:getInstance():getAccPropCount() <= 0 then
        self.btn_prop:setVisible(false)
        self.btn_gold:setVisible(false)
        self.btn_gold2:setVisible(true)
    end

end

function HeroTrainDetailsView:setData(hero)
    self.hero = hero
    self.lbl_name2:setString(self.hero.name)
    self.lbl_level2:setString(CommonStr.GRADE .. ":" .. self.hero.level)


    local leftTime = self.parent.curSelHero:getTrainTime()
    if leftTime == nil or leftTime == 0 then
        Prop:getInstance():showMsg(CommonStr.BUILDING_HAVE_FULL_LEVEL)
        return
    end
    TimeMgr:getInstance():createTime(leftTime,self.onUpdate,self,nil,1002)

    self.lbl_time2:setString(CommonStr.LEFT_TIME .. Common:getFormatTime(leftTime))

    local buildingPos = self.parent:getBuildingPos()
    local buildingLv = CityBuildingModel:getInstance():getBuildingLv(buildingPos)
    local experience = self.parent.curSelHero.trainHour * TrainEffectConfig:getInstance():getConfigInfo(buildingLv).te_exp
    self.lbl_experience2:setString(CommonStr.TRAINING_CAN_GAIN_EXPERIENCE .. experience)

    --头像
    local head = MMUISimpleUI:getInstance():getHead(hero)
    head:setPosition(356,1130)
    self.view:addChild(head)
end

--取消训练按钮回调
--返回值(无)
function HeroTrainDetailsView:onCancel(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        UIMgr:getInstance():openUI(UITYPE.PROP_BOX, {type=PROP_BOX_TYPE.COMMON,text=CommonStr.SURE_RETURN_HALF_RESOURCE,
        callback=handler(self, self.sendCancelTrainReq),sureBtnText=CommonStr.SURE,cancelBtnText=CommonStr.CANCEL,buildingPos=pos
        })
    end
end

--发送取消训练请求
function HeroTrainDetailsView:sendCancelTrainReq()
    HeroTrainService:getInstance():sendCancelTrainReq(self.parent.curSelHero.heroid)
end

--金币加速按钮回调
--返回值(无)
function HeroTrainDetailsView:onGold(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        local pos = self.parent:getBuildingPos()
        local leftTime = self.parent.curSelHero:getTrainTime()
        if leftTime == nil or leftTime == 0 then
            Prop:getInstance():showMsg(CommonStr.BUILDING_HAVE_FULL_LEVEL)
            return
        end
        local buildingGold = CommonConfig:getInstance():getAccGoldTrainHero(leftTime)
        local title2 = CommonStr.LEFT_TIME .. Common:getFormatTime(leftTime)
        local title = CommonStr.SURECAST .. buildingGold .. CommonStr.GOLD_FINISH_TRAIN
            UIMgr:getInstance():openUI(UITYPE.PROP_BOX, {type=PROP_BOX_TYPE.MONEY_ACCELERATION,text=title,timeText=title2,
                    callback=handler(self, self.sendGoldTrainHero),sureBtnText=CommonStr.YES,cancelBtnText=CommonStr.NO,buildingPos=self.pos
            })
        TimeMgr:getInstance():createTime(leftTime,self.onTime,self,nil,1000)
    end
end

function HeroTrainDetailsView:onTime(info)
    if info.time <= 0 then
        info.time = 0
        TimeMgr:getInstance():removeInfo(TimeType.COMMON,info.id)
        Prop:getInstance():showMsg(CommonStr.COMPLETE_TRAINING_RECEIVE,3)
        UIMgr:getInstance():closeUI(UITYPE.HERO_TRAIN)
    end
    self.lbl_time2:setString(CommonStr.LEFT_TIME .. Common:getFormatTime(info.time))

    local castGold = CommonConfig:getInstance():getAccGoldTrainHero(info.time)
    self.lbl_gold2:setString("" .. castGold .. CommonStr.GOLD)
    self.lbl_2gold2:setString("" .. castGold .. CommonStr.GOLD)
    local propCommand = UIMgr:getInstance():getUICtrlByType(UITYPE.PROP_BOX)
    if propCommand ~= nil then
        propCommand.view.title4Lab:setString(CommonStr.SURECAST .. castGold .. CommonStr.GOLD_FINISH_TRAIN)
        propCommand.view.time4Lab:setString(CommonStr.LEFT_TIME .. Common:getFormatTime(info.time))
    end
end

function HeroTrainDetailsView:onUpdate(info)
    if info.time <= 0 then
        info.time = 0
        TimeMgr:getInstance():removeInfo(TimeType.COMMON,info.id)
        Prop:getInstance():showMsg(CommonStr.COMPLETE_TRAINING_RECEIVE,3)
        UIMgr:getInstance():closeUI(UITYPE.HERO_TRAIN)
    end
    self.lbl_time2:setString(CommonStr.LEFT_TIME .. Common:getFormatTime(info.time))

    local castGold = CommonConfig:getInstance():getAccGoldTrainHero(info.time)
    self.lbl_gold2:setString("" .. castGold .. CommonStr.GOLD)
    self.lbl_2gold2:setString("" .. castGold .. CommonStr.GOLD)
end

--发送金币加速训练英雄
--返回值(无)
function HeroTrainDetailsView:sendGoldTrainHero()
    local trainTime = self.parent.newHeroTrain:getSelectTrainTime()
    local leftTime = self.parent.curSelHero:getTrainTime()
    local castGold = CommonConfig:getInstance():getAccGoldTrainHero(leftTime)
    local buildingPos = self.parent:getBuildingPos()
    local buildingLv = CityBuildingModel:getInstance():getBuildingLv(buildingPos)
    HeroTrainService:getInstance():sendGoldTrainingHero(0,self.hero.heroid,trainTime,castGold,buildingLv)
end

--道具加速按钮回调
--返回值(无)
function HeroTrainDetailsView:onProp(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self:hideView()
        self.parent.heroPropTrain:showView()
        self.parent.view:setVisible(true)
    end
end

-- 显示界面
function HeroTrainDetailsView:showView()
    self.view:setVisible(true)
end

-- 隐藏界面
function HeroTrainDetailsView:hideView()
    self.view:setVisible(false)
end

--关闭按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function HeroTrainDetailsView:onBack(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self:hideView()
        self.parent.view:setVisible(true)
    end
end