--[[
    hejun
    出征界面
--]]

GoBattleView = class("GoBattleView",UIBaseView)

--战斗类型
BattleType ={
    pvpBattle = 1, --pvp
    copy = 2, --副本
    def = 3,  --城外守军
}

--构造
--uiType UI类型
--data 数据
--返回值(无)
function GoBattleView:ctor(uiType,data)
    self.data = data
    self.sliderList = {}   --士兵数量列表信息
    self.heroListInfo = {}     --英雄列表信息
    self.curSelHeroIndex = 1   --默认选择的英雄
    self.clickedHeroID = 0 --被点击的英雄id
    self.arms = clone(ArmsData:getInstance():getSoldierArmsList())
    self.cloneArms = {}
    self.autoArmy = false
    self.super.ctor(self,uiType)
    self:adapterSize()
end

--勾选资源
GoBattleView.CHECKBOX_BUTTON2_IMAGES = {
    off = "test/CheckBoxButton2Off.png",
    on = "test/CheckBoxButton2On.png",
}

--滑动条资源
GoBattleView.SLIDER_IMAGES = {
    bar = "test/SliderBar.png",
    button = "test/SliderButton.png",
}


--初始化
--返回值(无)
function GoBattleView:init()
    self.root = Common:loadUIJson(GO_BATTLE_HEAD)
    self:addChild(self.root)

    --pan1
    self.pan1 = Common:seekNodeByName(self.root,"Panel_1")

    --关闭按钮
    self.closeBtn = Common:seekNodeByName(self.root,"closeBtn")
    self.closeBtn:addTouchEventListener(handler(self,self.closeCallback))

    --自动编队按钮
    self.formationBtn = Common:seekNodeByName(self.root,"formationBtn")
    self.formationBtn:addTouchEventListener(handler(self,self.formationBtnCallback))

    --出征按钮
    self.battleBtn = Common:seekNodeByName(self.root,"battleBtn")
    self.battle2Btn = Common:seekNodeByName(self.root,"battle2Btn")
    self.battle2Btn:addTouchEventListener(handler(self,self.battleBtnCallback))
    self.battleBtn:addTouchEventListener(handler(self,self.battleBtnCallback))

    --层容器
    self.BattleView = Common:seekNodeByName(self.root,"Panel_1")
    self.Choice = Common:seekNodeByName(self.root,"Panel_2")
    -- 出征部队总数量
    self.lbl_totalNum = cc.ui.UILabel.new(
            {text = "部队数量：",
            size = 26,
            align = cc.ui.TEXT_ALIGN_LEFT,
            color = display.COLOR_WHITE})
    self.lbl_totalNum:setPosition(100, 200)
    self.BattleView:addChild(self.lbl_totalNum)
    -- 负重
    self.lbl_weight = cc.ui.UILabel.new(
            {text = "负重：",
            size = 26,
            align = cc.ui.TEXT_ALIGN_LEFT,
            color = display.COLOR_WHITE})
    self.lbl_weight:setPosition(450, 200)
    self.BattleView:addChild(self.lbl_weight)

    --标题文本
     self.titleLab = Common:seekNodeByName(self.root,"battleLab")

     --出征时间
     self.timeLab = Common:seekNodeByName(self.root,"timeLab")

    --返回出征界面按钮
    self.close2Btn = Common:seekNodeByName(self.root,"close2Btn")
    self.close2Btn:addTouchEventListener(handler(self,self.close2BtnCallback))

    --判断什么界面选兵
    if BattleType.copy == self.data.battleType then
        self.battleBtn:setVisible(false)
        self.battle2Btn:setVisible(true)
        self.titleLab:setString("选择部队")
        self.battle2Btn:setTitleText("进攻副本")
    elseif BattleType.def == self.data.battleType then
        local title = Common:seekNodeByName(self.pan1,"lab_title")
        title:setString(Lan:lanText(220, "设置守军"))
        self.timeLab:setVisible(false)
        self.titleLab:setVisible(false)
        self.battleBtn:setTitleText(Lan:lanText(221, "驻守"))
    else
        self.battleBtn:setVisible(true)
        self.battle2Btn:setVisible(false)
        self.timeLab:setString(self.data.castTime)
    end

    self:isOwnArys()

   -- local arr = PlayerData:getInstance():getAllArms()
   -- if #arr == 0 then
   --      self.timeLab:setString("00:00:00")
   --  else
   --      self.timeLab:setString(self.data.castTime)

   -- end
    --重置所有英雄出征军队
    PlayerData:getInstance():resetAllHeroArmy();
    --创建五个职业多数组
    self:createLocalArms()
    --根据英雄对士兵对适性排序
    self:sortArmyByFit()
    --出征列表
    self:createUIListView()
end

--是否选兵判断
function GoBattleView:isOwnArys()
   local arr = PlayerData:getInstance():getAllArms()
   if #arr == 0 then
       self.timeLab:setString("00:00:00")
       --return false
   else
       if self.data ~= nil and self.data.castTime ~= nil then
           self.timeLab:setString(self.data.castTime)
       end
   end
              --return true
end

--创建出征UIListView
--返回值(无)
function GoBattleView:createUIListView()

    if self.listView ~= nil then
        self.listView:removeFromParent()
    end

    --判断是否选兵
    self:isOwnArys()

    self.listView = cc.ui.UIListView.new {
        bgColor = cc.c4b(0, 0, 0, 0),
        viewRect = cc.rect(0, 150, 750, 1100),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
    }
    --点击item
    :onTouch(handler(self, self.touchListener8))

    self.listInfoBox = Common:seekNodeByName(self.root,"Panel_1")
    self.listInfoBox:addChild(self.listView,0)

    for k,v in pairs(PlayerData:getInstance():getHeroListByState(HeroState.normal)) do
        local item = self.listView:newItem()
        local content = display.newNode()

        self.heroListInfo[k] = {}
        self.heroListInfo[k].hero = v
        --头像
        local btn = cc.ui.UIPushButton.new("test/loading_juhua.png")
        btn:setPosition(110, 60)
        btn:addTo(content)
        btn:setTouchSwallowEnabled(false)
        --唯一id
        self.heroListInfo[k].id = v:getHeroID()
        --英雄名字
        local nameLab = cc.ui.UILabel.new(
                {text = v.name,
                size = 26,
                align = cc.ui.TEXT_ALIGN_CENTER,
                color = display.COLOR_WHITE})
        nameLab:setPosition(180, 90)
        nameLab:addTo(content)
        self.heroListInfo[k].nameLab = nameLab
        --等级
        local levenLab = cc.ui.UILabel.new(
                {text = "LV:".. v:getHeroLevel(),
                size = 26,
                align = cc.ui.TEXT_ALIGN_CENTER,
                color = display.COLOR_WHITE})
        levenLab:setPosition(180, 35)
        levenLab:addTo(content)
        self.heroListInfo[k].levenLab = levenLab
        --可带兵量
        local maxArmsCountLab = cc.ui.UILabel.new(
                {text = CommonStr.MAX_ARMS_COUNT_STR .. v:getHeroMaxSoldiers(),
                size = 26,
                align = cc.ui.TEXT_ALIGN_CENTER,
                color = display.COLOR_WHITE})
        maxArmsCountLab:setPosition(350, 90)
        maxArmsCountLab:addTo(content)
        self.heroListInfo[k].maxArmsCountLab = maxArmsCountLab
        --士兵适性
        local soldierFitnessLab = cc.ui.UILabel.new(
                {text = CommonStr.SOLDIER_FITNESS .. ArmsData:getInstance():getOccupatuinName(v:getBestOccupation()),
                size = 26,
                align = cc.ui.TEXT_ALIGN_CENTER,
                color = display.COLOR_WHITE})
        soldierFitnessLab:setPosition(550, 90)
        soldierFitnessLab:addTo(content)
        self.heroListInfo[k].soldierFitnessLab = soldierFitnessLab
        --已带兵量
        local curArmsCountLab = cc.ui.UILabel.new(
                {text = CommonStr.ARMS_COUNT_STR .. v:getCurSoldiers(),
                size = 26,
                align = cc.ui.TEXT_ALIGN_CENTER,
                color = display.COLOR_WHITE})
        curArmsCountLab:setPosition(350, 35)
        curArmsCountLab:addTo(content)
        self.heroListInfo[k].curArmsCountLab = curArmsCountLab
        --勾选
        local CheckBoxButton = cc.ui.UICheckBoxButton.new(GoBattleView.CHECKBOX_BUTTON2_IMAGES)
        :setButtonLabelOffset(40, 0)
        CheckBoxButton:setPosition(50, 60)
        CheckBoxButton:addTo(content)
        self.heroListInfo[k].CheckBoxButton = CheckBoxButton
        if v:getCurSoldiers() > 0 then
            --todo
            CheckBoxButton:setButtonSelected(true)
        else
            --todo
            CheckBoxButton:setButtonSelected(false)
        end
        --判断是否勾选
        local function updateCheckBoxButtonLabel(checkbox)
        local state = ""
        if checkbox:isButtonSelected() then
            MyLog("勾选")
        else
            MyLog("取消勾选")
        end
    end
        CheckBoxButton:onButtonStateChanged(function(event)
            updateCheckBoxButtonLabel(event.target)
        end)

        content:setContentSize(750, 120)
        item:addContent(content)
        item:setItemSize(750, 150)
        self.listView:addItem(item)
        MyLog(curArmsCountLab:getString())
    end
    self.listView:reload()
end

--选择兵种UIListView
function GoBattleView:choiceSoldierUIListView()
    if self.listView1 ~= nil then
        self.sliderList = {}
        self.listView1:removeFromParent()
    end
    self.sliderArms = {} --
    --列表背景
    self.listView1 = cc.ui.UIListView.new {
        bgColor = cc.c4b(0, 0, 0, 0),
        viewRect = cc.rect(0, 0, 750, 1270),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
    }
    --总背景
    self.listInfoBox = Common:seekNodeByName(self.root,"Panel_2")
    self.listInfoBox:addChild(self.listView1,0)
    --军队数据
    self:setCloneArms()
    --
    local hero = PlayerData:getInstance():getHeroByID(self.clickedHeroID)
    print("self.cloneArms",#self.cloneArms)
    for k,v in pairs(self.cloneArms) do
        -- dump(v)
        --单项
        local cell = self.listView1:newItem()
        cell:setItemSize(750, 120)
        self.listView1:addItem(cell)
        --单项背景
        local cellBG = display.newNode()
        cellBG:setContentSize(750, 120)
        cell:addContent(cellBG)
        --士兵信息
        local config = ArmsAttributeConfig:getInstance():getArmyTemplate(v.type,v.level)
        local headPath = "#" .. config.aa_icon .. ".png"

        --头像
        local headImg = cc.ui.UIPushButton.new(headPath)
        headImg:setPosition(110, 50)
        headImg:setTouchSwallowEnabled(false)
        headImg:addTo(cellBG)
        --数量文本
        local valueLabel = cc.ui.UILabel.new({text = hero:getSoldiersByOne(v.type,v.level).."/"..v.number, size = 26, color = display.COLOR_WHITE})
        valueLabel:setPosition(540, 80)
        valueLabel:addTo(cellBG)
        --数量控件
        local slider = cc.ui.UISlider.new(display.LEFT_TO_RIGHT, GoBattleView.SLIDER_IMAGES, {scale9 = true})
        slider:setSliderSize(400, 40)
        slider:setPosition(220, 10)
        slider:setTag(k)
        slider:setSliderValue(Common:getFourHomesFive(hero:getSoldiersByOne(v.type,v.level)/v.number*100))
        --slider:setTouchEnabled(false)
        --设置slider是否拖动
        if hero:getHeroOcupation() == 0 then
            slider:setTouchEnabled(true)
        else
            if hero:getHeroOcupation() == v.type then
                slider:setTouchEnabled(true)
            else
                slider:setTouchEnabled(false)
            end
        end
        slider:addTo(cellBG)
        --数量控件事件
        slider:onSliderValueChanged(function(event)
            local curNum = event.value * v.number/100
            curNum = Common:getFourHomesFive(curNum)
            if curNum <= hero:getHeroMaxSoldiers() then
                --todo
                valueLabel:setString("" .. curNum.."/"..v.number)
                self:changeSlider(v,curNum)
            else
                slider:setSliderValue(Common:getFourHomesFive(hero:getHeroMaxSoldiers()/v.number*100))
            end
        end)
        print("type,lv:",v.type,v.level,v.number)
        --士兵名称
        local armsName = self:getOccupationName(v.type,v.level)

        local armsNameLab = cc.ui.UILabel.new(
                {text = armsName,
                size = 26,
                align = cc.ui.TEXT_ALIGN_CENTER,
                color = display.COLOR_WHITE})
        armsNameLab:setPosition(225, 80)
        armsNameLab:addTo(cellBG)
        --控件列表
        self.sliderList[k] = {}
        self.sliderList[k].valueLabel = valueLabel
        self.sliderList[k].slider = slider
        self.sliderList[k].armsNameLab = armsNameLab
    end
    self.listView1:reload()
end

--值的改变
function GoBattleView:changeSlider(slider, number)
    local hero = PlayerData:getInstance():getHeroByID(self.clickedHeroID)
    if number == 0 then
        hero:delSoldiersByOne(slider.type,slider.level)
    else
        hero:changeSoldiersByOne(slider.type,slider.level,number)
    end

    for k,v in pairs(self.sliderList) do
        if hero:getHeroOcupation() == 0 then
             v.slider:setTouchEnabled(true)
        else
            if self.cloneArms[k] ~= nil then
                if hero:getHeroOcupation() == self.cloneArms[k].type then
                    v.slider:setTouchEnabled(true)
                else
                    v.slider:setTouchEnabled(false)
                end
            end

        end
    end
end


--获取职业名称
--type --士兵类型
--lv 等级
--返回值(士兵名称)
function GoBattleView:getOccupationName(type,lv)
    if type == nil then
        return
    end
    return "" .. lv .. CommonStr.LEVEL .. ArmsData:getInstance():getOccupatuinName(type)
end

function GoBattleView:setCloneArms()
    self.cloneArms = clone(ArmsData:getInstance():getSoldierArmsList())
    for k,hero in pairs(PlayerData:getInstance():getHeroListByState(HeroState.normal)) do
        if hero:getHeroOcupation() ~= 0 and hero:getHeroID() ~= self.clickedHeroID then
            for k1,army in pairs(hero:getArmy()) do
                self:setCloneArms1(army)
            end
        end
    end
end

function GoBattleView:setCloneArms1(army)
    for k,v in pairs(self.cloneArms) do
        -- print(v.type, army.type, v.level, army.level,hero:getHeroOcupation(), v.type)
        if v.type == army.type and v.level == army.level then
            -- local num = v.number - army.number
            if v.number <= army.number then
                -- table.remove(self.cloneArms,k)
                self.cloneArms[k] = nil
            else
                v.number = v.number - army.number
            end
        end
    end
end

--自动编队
function GoBattleView:autoSetArmy()
    local armsData = ArmsData:getInstance()
    --如果士兵的总数量小于等于0 就返回0
    if armsData:getTotalNumber() <= 0 then
        Prop:getInstance():showMsg(CommonStr.NO_SOLDIERS)
        return 0
    end
    --重置所有英雄出征军队
    PlayerData:getInstance():resetAllHeroArmy();
    --创建五个职业多数组
    self:createLocalArms()
    --根据英雄对士兵对适性排序
    self:sortArmyByFit()

    for i=1,5 do
        --判断骑兵总数量是否为0 如果为0不进行操作
        if self:getSoldiersByOccupation(self.cavalryArr) ~= 0 then
            -- print("军队里有骑兵")
            -- 获取英雄id
            local id = self:getHeroByOccupation(OCCUPATION.cavalry, i)
            --设置英雄出征兵
            self:setHeroArmy(id, self.cavalryArr, OCCUPATION.cavalry)
        end
        --判断步兵总数量是否为0 如果为0不进行操作
        if self:getSoldiersByOccupation(self.infantryArr) ~= 0 then
            -- print("军队里有步兵")
            local id = self:getHeroByOccupation(OCCUPATION.footsoldier, i)
            --设置英雄出征兵
            self:setHeroArmy(id, self.infantryArr, OCCUPATION.footsoldier)
        end
        --判断弓兵总数量是否为0 如果为0不进行操作
        if self:getSoldiersByOccupation(self.archerArr) ~= 0 then
            -- print("军队里有弓兵")
            local id = self:getHeroByOccupation(OCCUPATION.archer, i)
            --设置英雄出征兵
            self:setHeroArmy(id, self.archerArr, OCCUPATION.archer)
        end
        --判断法师总数量是否为0 如果为0不进行操作
        if self:getSoldiersByOccupation(self.sorcererArr) ~= 0 then
            -- print("军队里有法师")
            local id = self:getHeroByOccupation(OCCUPATION.master, i)
            --设置英雄出征兵
            self:setHeroArmy(id, self.sorcererArr, OCCUPATION.master)
        end
        --判断战车总数量是否为0 如果为0不进行操作
        if self:getSoldiersByOccupation(self.chariotArr) ~= 0 then
            -- print("军队里有战车")
            local id = self:getHeroByOccupation(OCCUPATION.tank, i)
            --设置英雄出征兵
            self:setHeroArmy(id, self.chariotArr, OCCUPATION.tank)
        end
    end
end

--设置英雄出征兵
--id 英雄id
--arr 职业数组
function GoBattleView:setHeroArmy(id,arr,occupation)
    if id == nil then
        return
    end
    -- body
    local hero = PlayerData:getInstance():getHeroByID(id)

    --英雄携带出征军队的职业不是0 并且不等于所要遍历军队的职业 不做操作
    if hero:getHeroOcupation() ~= 0 and hero:getHeroOcupation() ~= occupation then
        return
    end

    --还能带多少兵
    local lastNum = hero:getHeroMaxSoldiers() - hero:getCurSoldiers()
    --判断英雄携带士兵数量
    if lastNum > 0 then
        --循环某种职业的兵
        for k,v in pairs(arr) do
            if v.number == nil or lastNum == nil then
                return
            end
            local army = {}
            army = ArmsData:getInstance():createInfo(v)
            if v.number <= lastNum then
                arr[k] = nil
            else
                army.number = lastNum
                v.number = v.number - lastNum
            end
            table.insert(hero.army,army)
            hero:setHeroOcupation(occupation)
        end
    end
end

--根据职业查询适性最好的英雄
--occupation 职业
--theKey 适性等级
function GoBattleView:getHeroByOccupation(occupation,theKey)
    -- body
    for k,v in pairs(self.armyFitArr) do
        if v[theKey].occupation == occupation then
            --找到最佳适性为骑兵的英雄
            return v[theKey].id
        end
    end
end

--根据英雄对士兵对适性排序
function GoBattleView:sortArmyByFit()
    --雄对士兵对适性数组
    self.armyFitArr = {}
    for k,v in pairs(PlayerData:getInstance():getHeroListByState(HeroState.normal)) do
        local arr = {}
        arr[1] = {occupation = OCCUPATION.footsoldier, value = v.infantry, id = v:getHeroID()}
        arr[2] = {occupation = OCCUPATION.cavalry, value = v.cavalry, id = v:getHeroID()}
        arr[3] = {occupation = OCCUPATION.archer, value = v.archer, id = v:getHeroID()}
        arr[4] = {occupation = OCCUPATION.master, value = v.mage, id = v:getHeroID()}
        arr[5] = {occupation = OCCUPATION.tank, value = v.chariot, id = v:getHeroID()}
        --排序
        table.sort(arr,function(a,b) return a.value > b.value end )
        --设置英雄最好的适性职业
        -- v:setBestOccupation(arr[1].occupation)
        print("最佳适性：",v.name,ArmsData:getInstance():getOccupatuinName(arr[1].occupation),arr[1].value)
        --添加到allArr
        table.insert(self.armyFitArr,arr)

    end
end


--创建五个职业多数组
function GoBattleView:createLocalArms()
    -- body
    --骑兵
    self.cavalryArr = {}
    --步兵
    self.infantryArr = {}
    --弓兵
    self.archerArr = {}
    --法师
    self.sorcererArr = {}
    --战车兵
    self.chariotArr = {}

    local armBigType = 0
    --遍历军队数组
    for k,v in pairs(self.arms) do
        --获取职业
        -- armBigType = Common:soldierTypeToOccupation(v.type)
        if v.type == OCCUPATION.cavalry then --骑兵
            table.insert(self.cavalryArr,v)
        elseif v.type == OCCUPATION.footsoldier then--步兵
            table.insert(self.infantryArr,v)
        elseif v.type == OCCUPATION.archer then--弓兵
            table.insert(self.archerArr,v)
        elseif v.type == OCCUPATION.master then--法师
            table.insert(self.sorcererArr,v)
        elseif v.type == OCCUPATION.tank then--战车兵
            table.insert(self.chariotArr,v)
        end
    end
    --排序
    self:sortArmByLv(self.cavalryArr)
    self:sortArmByLv(self.infantryArr)
    self:sortArmByLv(self.archerArr)
    self:sortArmByLv(self.sorcererArr)
    self:sortArmByLv(self.chariotArr)
end

function GoBattleView:sortArmByLv(myArmy)
    table.sort(myArmy,function(a,b) return a.level > b.level end )
end

--根据职业统计士兵数量
--arr 职业数组
function GoBattleView:getSoldiersByOccupation(arr)
    -- body
    local num = 0
    for k,v in pairs(arr) do
        num = v.number + num
    end
    return num
end

--点击item
--返回值(无)
function GoBattleView:touchListener8(event)
    local listView = event.listView
    if "clicked" == event.name then
        self.Choice:setVisible(true)
        self.BattleView:setVisible(false)
        -- MyLog(event.itemPos)
        self.clickedHeroID = self.heroListInfo[event.itemPos].id

        --选择兵种列表
        self:choiceSoldierUIListView()


        self.curSelHeroIndex = event.itemPos
    end
end

--隐藏显示建筑详请面板
--visible (true:显示，false:隐藏)
--返回值(无)
function GoBattleView:setPanVis(visible)
    self.BattleView:setVisible(visible)
    self.Choice:setVisible(visible)
end

--自动编队按钮回调
--sender 按钮本身
--eventType 事件类型i
--返回值(无)
function GoBattleView:formationBtnCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then

        --self:setPanVis(false)
        if self.autoArmy == false then
            print("自动编队")
            self.autoArmy = true
            self:autoSetArmy()
            --判断是否选兵
            self:isOwnArys()
        else
            print("取消自动编队")

            self.arms = clone(ArmsData:getInstance():getSoldierArmsList())
            self.cloneArms = {}

            self.autoArmy = false
            for k,v in pairs(PlayerData:getInstance():getHeroListByState(HeroState.normal)) do
                v:setArmy()
            end
            --判断是否选兵
            self:isOwnArys()

        end
        --计算带了多少兵
        for k,v in pairs(PlayerData:getInstance():getHeroListByState(HeroState.normal)) do
            -- print(v.name,ArmsData:getInstance():getOccupatuinName(v:getHeroOcupation()))
            for k1,v1 in pairs(v.army) do
                print("士兵类型：",ArmsData:getInstance():getOccupatuinName(v1.type))
                print("level：",v1.level)
                print("数量：",v1.number)
            end
            local cell = self:getCellByID(v:getHeroID())
            if cell == nil then
                return
            end
            cell.curArmsCountLab:setString(CommonStr.ARMS_COUNT_STR .. v:getCurSoldiers())
            if v:getCurSoldiers() > 0 then
                cell.CheckBoxButton:setButtonSelected(true)
            else
                cell.CheckBoxButton:setButtonSelected(false)
            end
        end
    end
    PlayerData:getInstance():getAllArms()
    --修改出征部队和负重
    self:changeArmyNumberAndWeight()
end

function GoBattleView:getCellByID(id)
    -- body
    for k,v in pairs(self.heroListInfo) do
        if id == v.id then
            --todo
            return v
        end
    end
end

--返回出征界面回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function GoBattleView:close2BtnCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
    self.Choice:setVisible(false)
    self.BattleView:setVisible(true)
    self:createUIListView()
    --修改出征部队和负重
    self:changeArmyNumberAndWeight()
    --self.BattleView:setVisible(false)
    end
end

--获取参加战斗的部队数据
function GoBattleView:getBattleArms()
    local arry = {}
    for k,v in pairs(self.heroListInfo) do
        if v.CheckBoxButton:isButtonSelected() then
            local info = {}
            info.heroId = v.hero.heroid
            info.arms = v.hero:getArmy()
            table.insert(arry,info)
        end
    end
    return arry
end

--出征按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function GoBattleView:battleBtnCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        -- 出征的军队
        local arms = PlayerData:getInstance():getAllArms()
        -- 取出数量为0多部队
        for k,v in pairs(arms) do
            print("level：",v.level,"士兵类型：",ArmsData:getInstance():getOccupatuinName(v.type),"数量：",v.number)
            if v.number == 0 then
                table.remove(arms,k)
            end
        end
        -- 提示出征军队不能为空
        if #arms == 0 then
            if BattleType.def == self.data.battleType then
                Lan:hintClient(19, "城外守军数量不能为0")
            else
                Prop:getInstance():showMsg(CommonStr.BATTLE_SOLDIER_IS_EMPTY)
            end
            return
        end

        local battleArms = self:getBattleArms()
        if BattleType.copy == self.data.battleType then
            MyLog("进攻副本")
            CopyBattleService:sendEnterCopyReq(self.data.copyId,battleArms,self.data.copyIndex)
        elseif BattleType.def == self.data.battleType then --驻军
            MyLog("驻军")
            TerritoryService:getInstance():setDeferArmsReq(battleArms)
        else
            MyLog("进攻pvp")
            if PlayerMarchModel:getInstance():isCanMarch() then
                PlayerMarchService:getInstance():sendMarchReq(battleArms,1,self.data.gridPos.x,self.data.gridPos.y,MarchOperationType.attack)
            end
        end
    end
end

--修改出征部队和负重
function GoBattleView:changeArmyNumberAndWeight()
    -- 出征部队总数量
    self.lbl_totalNum:setString("部队数量："..PlayerData:getInstance():getAllArmsNum())
    -- 负重
    self.lbl_weight:setString("负重："..PlayerData:getInstance():getAllArmsWeight())
end

--UI加到舞台后都会调用这个接口
--返回值(无)
function GoBattleView:onEnter()
    --MyLog("GoBattleView onEnter...")
    UICommon:getInstance():setMapTouchAable(false)
end

--UI离开舞台后都会调用这个接口
--返回值(无)
function GoBattleView:onExit()
    --MyLog("GoBattleView onExit()")
    UICommon:getInstance():setMapTouchAable(true)
end

--析构函数(此时已经从内存中释放掉资源了)
--返回值(无)
function GoBattleView:onDestroy()
   -- MyLog("GoBattleView:onDestroy")
end

--关闭按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function GoBattleView:closeCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        if BattleType.copy == self.data.battleType then  --副本
            UIMgr:getInstance():openUI(UITYPE.INSTANCE_CITY,{copyIndex=self.data.copyIndex,building=self.data.building})
        elseif BattleType.def == self.data.battleType then  --设置守军
            local command = UIMgr:getInstance():getUICtrlByType(UITYPE.TERRITORY)
            if command ~= nil then
                command:updateDefArmsUI()
            end
        end
        UIMgr:getInstance():closeUI(self.uiType)
    end
end