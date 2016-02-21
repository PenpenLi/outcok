--[[
    hejun
    治疗界面
--]]

TreatmentView = class("TreatmentView",UIBaseView)

TreatmentType = {
    HERO_THERAPY = 1,  --英雄治疗
    SOLDIER_TREATMENT = 2, --士兵治疗
}

--滑动条资源
TreatmentView.SLIDER_IMAGES = {
    bar = "test/SliderBar.png",
    button = "test/SliderButton.png",
}

--构造
--uiType UI类型
--data 数据
--返回值(无)
function TreatmentView:ctor(uiType,data)
    self.data = data
    self.super.ctor(self,uiType)
    self:adapterSize()
end

--初始化
--返回值(无)
function TreatmentView:init()
    self.root = Common:loadUIJson(TREATMENT)
    self:addChild(self.root)
    --总士兵
    self.atterPower = 0
    self.selNum = {}

    self.isSelectedAll = false

    --关闭按钮
    self.closeBtn = Common:seekNodeByName(self.root,"closeBtn")
    self.closeBtn:addTouchEventListener(handler(self,self.closeCallback))
    --标题
    self.titleLab = Common:seekNodeByName(self.root,"titleLab")
    --受伤士兵文本
    self.woundedSoldierLab = Common:seekNodeByName(self.root,"woundedSoldierLab")
    --受伤英雄文本
    self.heroSoldierLab = Common:seekNodeByName(self.root,"heroSoldierLab")
    --当前加速文本
    self.currentAccelerationLab = Common:seekNodeByName(self.root,"currentAccelerationLab")
    --立即治疗文本
    self.immediateTreatmentLab = Common:seekNodeByName(self.root,"immediateTreatmentLab")
    self.immediateTreatmentLab:setString(CommonStr.IMMEDIATE_TREATMENT)
    --治疗文本
    self.treatmentLab = Common:seekNodeByName(self.root,"treatmentLab")
    self.treatmentLab:setString(CommonStr.TREATMENT)
    --粮食文本
    self.grainLab = Common:seekNodeByName(self.root,"grainLab")
    self.grainLab:setString(CommonStr.FOOD .. "    " .. "0/" .. Common:getCompany(PlayerData:getInstance():getFood()))
    --木材文本
    self.woodLab = Common:seekNodeByName(self.root,"woodLab")
    self.woodLab:setString(CommonStr.WOOD .. "    " .. "0/" ..Common:getCompany(PlayerData:getInstance().wood))
    --铁矿文本
    self.ironLab = Common:seekNodeByName(self.root,"ironLab")
    self.ironLab:setString(CommonStr.IRON .. "    " .. "0/" ..Common:getCompany(PlayerData:getInstance().iron))
    --秘银文本
    self.mithrilLab = Common:seekNodeByName(self.root,"mithrilLab")
    self.mithrilLab:setString(CommonStr.MITHRIL .. "    " .. "0/" ..Common:getCompany(PlayerData:getInstance().mithril))
    --时间文本
    self.timeLab = Common:seekNodeByName(self.root,"timeLab")
    self.timeLab:setString("00:00:00")
    --金币文本
    self.goldLab = Common:seekNodeByName(self.root,"goldLab")
    self.goldLab:setString("0")
    --全选按钮
    self.selectBtn = Common:seekNodeByName(self.root,"selectBtn")
    self.selectBtn:setTitleText(CommonStr.SELECT)
    self.selectBtn:addTouchEventListener(handler(self,self.selectCallback))
    --立即治疗按钮
    self.immediateTreatmentBtn = Common:seekNodeByName(self.root,"immediateTreatmentBtn")
    self.immediateTreatmentBtn:addTouchEventListener(handler(self,self.rightNowTreatmentBtnCallback))
    --治疗按钮
    self.treatmentBtn = Common:seekNodeByName(self.root,"treatmentBtn")
    self.treatmentBtn:addTouchEventListener(handler(self,self.treatmentCallback))

    --获取总伤兵
    local arms = HurtArmsData:getInstance():getSoldierArmsList()
    for k,v in pairs(arms) do
        self.atterPower = v.number + self.atterPower
    end

    if self.data.accTreatmentType == TreatmentType.HERO_THERAPY then  --治疗英雄
        self.titleLab:setString(CommonStr.TREATMENT_HERO)
        self.woundedSoldierLab:setVisible(false)
        self.heroSoldierLab:setVisible(true)
        self.heroSoldierLab:setString(CommonStr.WOUNDED_HERO)
        self.currentAccelerationLab:setVisible(true)
        self.currentAccelerationLab:setString(CommonStr.CURRENT_ACCELERATION)
    elseif self.data.accTreatmentType == TreatmentType.SOLDIER_TREATMENT then --治疗士兵
        self.woundedSoldierLab:setVisible(true)
        self.heroSoldierLab:setVisible(false)
        self.currentAccelerationLab:setVisible(false)
        self.titleLab:setString(CommonStr.TREATMENT_SOLDIERS)
        self.woundedSoldierLab:setString(CommonStr.WOUNDED_SOLDIER .. " " .. "0/" .. self.atterPower)

        self:woundedSoldierUIListView()
    end
end

-- 受伤士兵UIListView
function TreatmentView:woundedSoldierUIListView()
    if self.listView ~= nil then
        self.sliderList = {}
        self.listView:removeFromParent()
    -- else
    --     self.treatmentBtn:setTouchEnabled(false)
    --     self.immediateTreatmentBtn:setTouchEnabled(false)
    --     self.selectBtn:setTouchEnabled(false)
    end
    --列表背景
    self.listView = cc.ui.UIListView.new {
        bgColor = cc.c4b(0, 0, 0, 0),
        viewRect = cc.rect(0, 0, 750, 800),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
    }
    --总背景
    self.listInfoBox = Common:seekNodeByName(self.root,"list")
    self.listInfoBox:addChild(self.listView,0)
    local arms = HurtArmsData:getInstance():getSoldierArmsList()
    for k,v in pairs(arms) do
        --单项
        local cell = self.listView:newItem()
        cell:setItemSize(750, 150)
        self.listView:addItem(cell)
        --单项背景
        local cellBG = display.newNode()
        cellBG:setContentSize(750, 150)
        cell:addContent(cellBG)
        --头像
        local headImg = cc.ui.UIPushButton.new("test/loading_juhua.png")
        headImg:setPosition(110, 80)
        headImg:addTo(cellBG)
        headImg:setTouchSwallowEnabled(false)
        --士兵名字
        local soldierNameLab = cc.ui.UILabel.new(
                {text = ArmsData:getInstance():getSoldierName(v.type,v.level),
                size = 26,
                align = cc.ui.TEXT_ALIGN_CENTER,
                color = display.COLOR_WHITE})
        soldierNameLab:setPosition(240, 110)
        soldierNameLab:addTo(cellBG)
        --士兵数量
        local soldierNumLab = cc.ui.UILabel.new(
                {text = "0/" .. v.number,
                size = 26,
                align = cc.ui.TEXT_ALIGN_CENTER,
                color = display.COLOR_WHITE})
        soldierNumLab:setPosition(500, 110)
        soldierNumLab:addTo(cellBG)

        --数量控件
        local slider = cc.ui.UISlider.new(display.LEFT_TO_RIGHT, TreatmentView.SLIDER_IMAGES, {scale9 = true})
        slider:setSliderSize(400, 40)
        slider:setPosition(220, 30)
        slider:addTo(cellBG)
        slider:setTag(k)

        self.selNum[k] = {}
        self.selNum[k].num = 0
        self.selNum[k].slider = slider

        --数量控件事件
        slider:onSliderValueChanged(function(event)
            local curNum = event.value * v.number/100
            curNum = Common:getFourHomesFive(curNum)
            if curNum <= v.number then
                self.selNum[k].num = curNum
                soldierNumLab:setString("" .. curNum.."/"..v.number)
                self:changeSlider(v,curNum)
            -- else
            --     slider:setSliderValue(Common:getFourHomesFive(hero:getHeroMaxSoldiers()/v.number*100))
            end
        end)
    end
    self.listView:reload()
end

--值的改变
function TreatmentView:changeSlider(info, number)
    TreatmentModel:getInstance():changeSelectArms(info,number)
    local arms = TreatmentModel:getInstance():getList()
    local costInfo = TreatmentModel:getInstance():getCosd(arms)
    local playerData = PlayerData:getInstance()
    local leftTime = TreatmentModel:getInstance():getleftTime()
    local castGold = TreatmentModel:getInstance():getCastGoldByTime(leftTime)
    self.goldLab:setString("" .. castGold)
    self.grainLab:setString(CommonStr.FOOD .. "    " .. costInfo.grain  .. "/" .. Common:getCompany(PlayerData:getInstance():getFood()))
    self.woodLab:setString(CommonStr.WOOD .. "    " .. costInfo.wood  .. "/" .. Common:getCompany(PlayerData:getInstance().wood))
    self.ironLab:setString(CommonStr.IRON .. "    " .. costInfo.iron  .. "/" .. Common:getCompany(PlayerData:getInstance().iron))
    self.mithrilLab:setString(CommonStr.MITHRIL .. "    " .. costInfo.mithril  .. "/" .. Common:getCompany(PlayerData:getInstance().mithril))
    local total = 0
    for k,v in pairs(self.selNum) do
        total = total + v.num
    end
    self.woundedSoldierLab:setString(CommonStr.WOUNDED_SOLDIER .. " " .. total .. "/" .. self.atterPower)
    local num = self:getAllTurbo()
    local time = Common:getFormatTime(costInfo.time/num)
    self.timeLab:setString(time)
end

--获取建筑物位置
--返回值(建筑位置)
function TreatmentView:getBuildingPos()
    return self.data.building:getTag()
end

--获取急救帐篷数量
--返回值()
function TreatmentView:getAllTurbo()
    local buildingPos = self:getBuildingPos()
    local buildingType = CityBuildingModel:getInstance():getBuildType(buildingPos)
    local id = BuildingTypeConfig:getInstance():getConfigInfo(buildingType).bt_id
    local num = 0
    local arr = CityBuildingModel:getInstance():getBuildListByType(buildingType)
    for k,v in pairs(arr) do
        num = BuildingTypeConfig:getInstance():getConfigInfo(buildingType).bt_id/id + num
    end
    return num
end

--全选按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function TreatmentView:selectCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        local arms = HurtArmsData:getInstance():getSoldierArmsList()
        if self.isSelectedAll == false then
            for k,v in pairs(arms) do
                self.selNum[k].num = v.number
            end
            for k,v in pairs(self.selNum) do
                v.slider:setSliderValue(100)
            end
            self.isSelectedAll = true
        else
            for k,v in pairs(arms) do
                self.selNum[k].num = 0
            end
            for k,v in pairs(self.selNum) do
                v.slider:setSliderValue(0)
            end
            self.isSelectedAll = false
        end
    end
end

--治疗按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function TreatmentView:treatmentCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        if not self:isCanTreatment() then
            return
        end

        local list = TreatmentModel:getInstance():getList()
        local buildingPos = self:getBuildingPos()
        local buildingType = CityBuildingModel:getInstance():getBuildType(buildingPos)
        TreatmentService:woundedSoldierSeq(list,buildingType)
        for k,v in pairs(list) do
           print(v.number .. "个" .. ArmsData:getInstance():getSoldierName(v.type,v.level))
        end
        UIMgr:getInstance():closeUI(self.uiType)
    end
end

--是否可以治疗
--返回值(true:可以,false:不可以)
function TreatmentView:isCanTreatment()
    local list = TreatmentModel:getInstance():getList()
    --判断是否选择伤兵
    if #list == 0 then
        Prop:getInstance():showMsg(CommonStr.PLEASE_SELECT_WOUNDED)
        return
    end
    local castInfo = TreatmentModel:getInstance():getCosd(list)
    --粮食判断
    if castInfo.grain > PlayerData:getInstance():getFood() then
        print("粮食不足")
        Prop:getInstance():showMsg(CommonStr.NOT_ENOUGH_FOOD)
        return false
    end
    --木头判断
    if castInfo.wood > PlayerData:getInstance().wood then
        print("木头不足")
        Prop:getInstance():showMsg(CommonStr.NOT_ENOUGH_WOOD)
        return false
    end
    --铁矿判断
    if castInfo.iron > PlayerData:getInstance().iron then
        print("铁矿不足")
        Prop:getInstance():showMsg(CommonStr.NOT_ENOUGH_IRON)
        return false
    end
    --秘银判断
    if castInfo.mithril > PlayerData:getInstance().mithril then
        print("秘银不足")
        Prop:getInstance():showMsg(CommonStr.NOT_ENOUGH_MITHRIL)
        return false
    end

    return true
end

--立即治疗按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function TreatmentView:rightNowTreatmentBtnCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        if not self:isCanTreatment() then
            return
        end
        local leftTime = TreatmentModel:getInstance():getleftTime()
        local castGold = TreatmentModel:getInstance():getCastGoldByTime(leftTime)
        if castGold > PlayerData:getInstance().gold then
            Prop:getInstance():showMsg(CommonStr.NO_GOLD_SPEED_TREATMENT)
            return
        end

        local title2 = CommonStr.LEFT_TIME .. Common:getFormatTime(leftTime)
        local title = CommonStr.SURECAST .. castGold .. CommonStr.IMMEDIATE_COMPLETION_TREATMENT
            UIMgr:getInstance():openUI(UITYPE.PROP_BOX, {type=PROP_BOX_TYPE.MONEY_ACCELERATION,text=title,timeText=title2,
                callback=handler(self,self.sendRightNowTreatmentReq),sureBtnText=CommonStr.YES,cancelBtnText=CommonStr.NO,buildingPos=self:getBuildingPos()
            })
    end
end

--立即完成治疗
function TreatmentView:sendRightNowTreatmentReq()
    local list = TreatmentModel:getInstance():getList()
    local leftTime = TreatmentModel:getInstance():getleftTime()
    local castGold = TreatmentModel:getInstance():getCastGoldByTime(leftTime)
    UseGoldAcceTreatmentService:sendAccelerationTreatmentReq(AcceTreatmentAction.rightNowGold,castGold,list)
end

--UI加到舞台后都会调用这个接口
--返回值(无)
function TreatmentView:onEnter()
    UICommon:getInstance():setMapTouchAable(false)
end

--UI离开舞台后都会调用这个接口
--返回值(无)
function TreatmentView:onExit()
    UICommon:getInstance():setMapTouchAable(true)
end

--析构函数(此时已经从内存中释放掉资源了)
--返回值(无)
function TreatmentView:onDestroy()
end

--关闭按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function TreatmentView:closeCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        UIMgr:getInstance():openUI(UITYPE.BUILDING_MENU, {building=self.data.building})
        UIMgr:getInstance():closeUI(self.uiType)
    end
end




