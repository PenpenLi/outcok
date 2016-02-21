--[[
    hejun
    训练界面
--]]

MakeSoldierView = class("MakeSoldierView",UIBaseView)

--构造
--uiType UI类型
--data 数据
--返回值(无)
function MakeSoldierView:ctor(uiType,data)
    self.data = data
    self.super.ctor(self,uiType)
    self:adapterSize()
end

--初始化
--返回值(无)
function MakeSoldierView:init()
    self.root = Common:loadUIJson(BUILD_TRAINING_HEAD)
    self:addChild(self.root)

    --关闭按钮
    self.closeBtn = Common:seekNodeByName(self.root,"closeBtn")
    self.closeBtn:addTouchEventListener(handler(self,self.closeCallback))

    self.pointBuildListPosWin = Common:seekNodeByName(self.root,"frame")
    self.trainPan = Common:seekNodeByName(self.root,"Panel_1")

    --左侧士兵图片
    self.soldierImg = Common:seekNodeByName(self.root,"soldierimg")
    self.soldierImg:setVisible(false)
    self.soldierImg:setTouchEnabled(true)
    self.soldierImg:addTouchEventListener(handler(self,self.soldierBtnCallBack))

    --士兵名字
    self.soldierNameLab = Common:seekNodeByName(self.root,"namelab")

    --拥有士兵数量
    self.soldierNumLab = Common:seekNodeByName(self.root,"numlab")

    --添加士兵数量
    self.addSoldierNumLab = Common:seekNodeByName(self.root,"num_lab")

    --粮食
    self.foodLab = Common:seekNodeByName(self.root,"foodlab")

    --木材
    self.woodLab = Common:seekNodeByName(self.root,"woodlab")

    --铁矿
    self.ironLab = Common:seekNodeByName(self.root,"tielab")

    --秘银
    self.metialLab = Common:seekNodeByName(self.root,"miyinlab")
    --加
    self.plusBtn = Common:seekNodeByName(self.root,"plusbtn")
    self.plusBtn:addTouchEventListener(handler(self,self.plusCallback))
    --减
    self.minusBtn = Common:seekNodeByName(self.root,"minusbtn")
    self.minusBtn:addTouchEventListener(handler(self,self.minusCallback))
    --计算建筑图片大小
    local building = display.newSprite("citybuilding/buildingbg.png")
    self.buildSize = building:getContentSize()

    --创建建筑列表
    self.buildinglist = UIBuildingList.new({buildingSize=self.buildSize,
                                    buildDis=self:getBuildingDis(),
                                    count=self:getTrainSoldierListCount(),
                                    pointBoxNode=self.pointBuildListPosWin,
        parent=self})
    self.root:addChild(self.buildinglist)
    self.buildinglist:registerMsg(0,self,self.finishSelBuildingCallBack)

    --训练按钮
    self.trainBtn = Common:seekNodeByName(self.root,"trainingBtn")
    self.trainBtn:addTouchEventListener(handler(self,self.trainBtnCallback))
    self.trianLab = Common:seekNodeByName(self.trainBtn,"trainingLab")
    local text = Lan:lanText(1,"训练")
    self.trianLab:setString(text)
    self.trainTimeLab = Common:seekNodeByName(self.trainBtn,"timelab")

    --立即训练按钮
    self.rightNowTrainBtn = Common:seekNodeByName(self.root,"immediateTrainingBtn")
    self.rightNowTrainBtn:addTouchEventListener(handler(self,self.rightNowTrainBtnCallback))
    self.rightNowTrainLab = Common:seekNodeByName(self.rightNowTrainBtn,"immediateTrainingLab")
    self.rightNowTrainLab:setString(CommonStr.RIGHTNOW_TRAIN)
    self.castLab = Common:seekNodeByName(self.rightNowTrainBtn,"goldLab")

    --下侧面板
    self.downPan = Common:seekNodeByName(self.root,"Panel_35")

    --创建滑动条
    self.maxMakeSoldierCount = BuildingMarchDetailsModel:getInstance():getMaxMakeSoldierCount()
    local str = tostring(self.maxMakeSoldierCount)
    local len = string.len(str)
    self.offsetSliderValue = 1/math.pow(10,len)

    self.makeAccTotalTime = BuildingMarchDetailsModel:getInstance():getAllMarchTentProduceTrainTimeTotal()
    self:createSlider()

    --创建士兵信息层
    self.soldierInfoView = SoldierInfoView.new(self)
    --创建训练中的士兵信息层
    self.trainingInfo = TrainingInfo.new(self)
end

--UI加到舞台后都会调用这个接口
--返回值(无)
function MakeSoldierView:onEnter()
    --MyLog("MakeSoldierView onEnter...")
    local tempData = {}
    UICommon:getInstance():setMapTouchAable(false)

    local buildingBtnList = self.buildinglist:getBuildingList()
    print("buildingBtnList=",buildingBtnList,"#buildingBtnList=",#buildingBtnList)
    for i=1,#buildingBtnList do
        local soldierType = self.trainlistData[i].soldierType
        buildingBtnList[i]:setTag(i)

        local sprite = display.newSprite(self.trainlistData[i].smallPicName)
        sprite:setPosition(cc.p(sprite:getContentSize().width/2+50, 100))
        buildingBtnList[i]:addChild(sprite)

        local nameLab = display.newTTFLabel({
            text = self.trainlistData[i].name,
            font = "Arial",
            size = 24,
            color = cc.c3b(255, 255, 0),
            align = cc.TEXT_ALIGNMENT_LEFT,
        })
        buildingBtnList[i]:addChild(nameLab)
        nameLab:setPosition(130, 100)

        if not self.trainlistData[i].isCanMakeSoldier then
            sprite:setOpacity(128)
            self:setDownPanVisible(false)
            local unlockLab = display.newTTFLabel({
                text = self.trainlistData[i].unlockDesStr,
                font = "Arial",
                size = 24,
                color = cc.c3b(255, 0, 0),
                align = cc.TEXT_ALIGNMENT_LEFT,
            })
            buildingBtnList[i]:addChild(unlockLab)
            unlockLab:setPosition(130, 90)
            nameLab:setPosition(130, 130)
        else
            self:setDownPanVisible(true)
            table.insert(tempData,self.trainlistData[i])
        end
    end

    self.buildinglist:moveBuildToPos(self:getBuildIndex(tempData))
end

--完成选择建筑回调
--idx 第几个建筑被选中
--返回值(无)
function MakeSoldierView:finishSelBuildingCallBack(idx)
    local curSelSoldierBtn = self:getCurSelSoldierType()
    local index = curSelSoldierBtn:getTag()
    local info = self.trainlistData[index]
    print("idx=",idx,"curSelSoldierBtn=",curSelSoldierBtn,"index=",index)
    self.soldierNameLab:setString(info.name)
    self.soldierNumLab:setString(CommonStr.HAVE .. ": " .. info.soldierNum)
    self.soldierImg:loadTexture(info.bigPicName,ccui.TextureResType.plistType)
    self.trainTimeLab:setString(Common:getFormatTime(info.makeSoldierTime))
    self.foodLab:setString(CommonStr.FOOD .. ": " ..  info.food)
    self.woodLab:setString(CommonStr.WOOD .. ": " .. info.wood)
    self.ironLab:setString(CommonStr.IRON .. ": " .. info.iron)
    self.metialLab:setString(CommonStr.MITHRIL .. ": " .. info.mithril)

    local buildingPos = self.data.building:getTag()
    local buildingState = CityBuildingModel:getInstance():getBuildingState(buildingPos)
    if info.isCanMakeSoldier and buildingState ~= BuildingState.makeSoldiers then
        self:setDownPanVisible(true)
        self.trainingInfo.trainingInfoPan:setVisible(false)
    else
        self:setDownPanVisible(false)
        self.trainingInfo:updateUI(info)
    end

    self.soldierImg:setVisible(true)
    self:setSliderValue(1)
end

--士兵按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function MakeSoldierView:soldierBtnCallBack(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        local curSelSoldierBtn = self:getCurSelSoldierType()
        local index = curSelSoldierBtn:getTag()
        local info = self.trainlistData[index]
        self.soldierInfoView:updateUI(info)
        self.trainPan:setVisible(false)
        self.buildinglist:setVisible(false)
        self.soldierInfoView.infoPan:setVisible(true)
    end
end

--设置滑动条数值
--number 数值
function MakeSoldierView:setSliderValue(number)
    local tmpValue = 100/self.maxMakeSoldierCount
    local per = tmpValue*number + self.offsetSliderValue
    if per > 100 then
        per = 100
    end
    self.slider:setSliderValue(per)
end

--创建滑动条
--返回值(无)
function MakeSoldierView:createSlider()
    sliderResPath =
    {
        bar = "ui/build_training/sliderBar.png",
        button = "ui/build_training/sliderButton.png",
    }

    local barHeight = 40
    local barWidth = 400
    self.slider = cc.ui.UISlider.new(display.LEFT_TO_RIGHT, sliderResPath, {scale9 = true})
    self.slider:onSliderValueChanged(function(event)
        local curNum = self.maxMakeSoldierCount*event.value/100
        curNum = math.floor(curNum)
        self.addSoldierNumLab:setString("" .. curNum)
        self:updateUIByNum(curNum)
    end)
    self.slider:setSliderSize(barWidth, barHeight)
    self.slider:addTo(self.downPan)
    self.slider:setPosition(80, 160)
end

--加按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function MakeSoldierView:plusCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        local num = tonumber(self.addSoldierNumLab:getString())
        if num < self.maxMakeSoldierCount then
            num = num + 1
            self:setSliderValue(num)
        end
    end
end

--减按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function MakeSoldierView:minusCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        local num = tonumber(self.addSoldierNumLab:getString())
        if num > 0 then
            num = num - 1
            self:setSliderValue(num)
        end
    end
end

--根据士兵数量,刷新UI
--number 士兵数量
function MakeSoldierView:updateUIByNum(number)
    local curSelSoldierBtn = self:getCurSelSoldierType()
    local index = curSelSoldierBtn:getTag()
    local info = self.trainlistData[index]

    --训练时间
    local trainTime = self:getTrainTime(info.makeSoldierTime,number)
    self.trainTimeLab:setString(Common:getFormatTime(trainTime))
    local castGold = CommonConfig:getInstance():getAccelerationMakeSoldierCastGold(trainTime)
    self.castLab:setString("" .. castGold .. CommonStr.GOLD)

    --粮食
    self.foodLab:setString(CommonStr.FOOD .. ": " ..  info.food * number)
    --木材
    self.woodLab:setString(CommonStr.WOOD .. ": " .. info.wood * number)
    --铁矿
    self.ironLab:setString(CommonStr.IRON .. ": " .. info.iron * number)
    --秘银
    self.metialLab:setString(CommonStr.MITHRIL .. ": " .. info.mithril * number)
end

--获取训练时间
--time 单个兵的训练时间
--num 兵的数量
function MakeSoldierView:getTrainTime(time,num)
    local totalTime = time*num*(1-self.makeAccTotalTime)
    totalTime = math.ceil(totalTime)
    if totalTime <= 0 then
        totalTime = 0
    end
    return totalTime
end

--设置底下那个面板的隐藏/显示
--返回值(无)
function MakeSoldierView:setDownPanVisible(visible)
    self.downPan:setVisible(visible)
end

function MakeSoldierView:getBuildIndex(arr)
    table.sort(arr,function(a,b) return a.lv > b.lv end )
    local info = arr[1]
    for k,v in pairs(self.trainlistData) do
        if info.lv == v.lv then
            return k - 1
        end
    end
    return 0
end

--获取当前选择的士兵类型
--返回值(当前选择的建筑)
function MakeSoldierView:getCurSelSoldierType()
    return self.buildinglist:getCurSelBuilding()
end

--获取建筑间隔
--返回值(建筑间距)
function MakeSoldierView:getBuildingDis()
    return 20
end

--获取训练士兵列表个数
--返回值(建筑列表个数)
function MakeSoldierView:getTrainSoldierListCount()
    local buildingPos = self.data.building:getTag()
    self.trainlistData = ArmsAttributeConfig:getInstance():getTrainList(buildingPos)
    return #self.trainlistData
end

--能否造兵
--返回值(true:可以,false:不可以)
function MakeSoldierView:isCanMakeingSoldier()
    local curSelSoldierBtn = self:getCurSelSoldierType()
    local index = curSelSoldierBtn:getTag()
    local info = self.trainlistData[index]
    local num = tonumber(self.addSoldierNumLab:getString())
    if num == 0 then
        Prop:getInstance():showMsg(CommonStr.MAKE_SOLDIER_NUM_IS_EMPTY)
        return false
    end
    
    --粮食判断
    if info.food * num > PlayerData:getInstance():getFood() then
        print("粮食不足")
        Prop:getInstance():showMsg(CommonStr.NOT_ENOUGH_FOOD)
        return false
    end
    --木头判断
    if info.wood * num > PlayerData:getInstance().wood then
        print("木头不足")
        Prop:getInstance():showMsg(CommonStr.NOT_ENOUGH_WOOD)
        return false
    end
    --铁矿判断
    if info.iron * num > PlayerData:getInstance().iron then
        print("铁矿不足")
        Prop:getInstance():showMsg(CommonStr.NOT_ENOUGH_IRON)
        return false
    end
    --秘银判断
    if info.mithril * num > PlayerData:getInstance().mithril then
        print("秘银不足")
        Prop:getInstance():showMsg(CommonStr.NOT_ENOUGH_MITHRIL)
        return false
    end

    return true
end

--训练按钮回调
--sender按钮本身
--eventType 事件类型
--返回值(无)
function MakeSoldierView:trainBtnCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        if not self:isCanMakeingSoldier() then
            return
        end

        local building = self.data.building
        local buildingPos = building:getTag()
        local buildingType = CityBuildingModel:getInstance():getBuildType(buildingPos)

        local curSelSoldierBtn = self:getCurSelSoldierType()
        local index = curSelSoldierBtn:getTag()
        local info = self.trainlistData[index]
        local num = tonumber(self.addSoldierNumLab:getString())

        local soldierAnmationTempleType = ArmsData:getInstance():getDefaultSoldierAnmationTempleTypeByBuildingType(buildingType)
        local soldierJob = ArmsData:getInstance():getSoldierJobByBuildingType(buildingType)
        MakeSoldierService:makeSoldiersSeq(buildingPos,soldierJob,info.lv,num,soldierAnmationTempleType,info.name)
    end
end

--立即训练按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function MakeSoldierView:rightNowTrainBtnCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        if not self:isCanMakeingSoldier() then
            return
        end

        local building = self.data.building
        local buildingPos = building:getTag()
        local buildingType = CityBuildingModel:getInstance():getBuildType(buildingPos)

        local curSelSoldierBtn = self:getCurSelSoldierType()
        local index = curSelSoldierBtn:getTag()
        local info = self.trainlistData[index]
        local num = tonumber(self.addSoldierNumLab:getString())
        local leftTime = self:getTrainTime(info.makeSoldierTime,num)
        local castGold = CommonConfig:getInstance():getAccelerationMakeSoldierCastGold(leftTime)
        if castGold > PlayerData:getInstance().gold then
            Prop:getInstance():showMsg(CommonStr.NO_GOLD_SPEED_MAKE_SOLDIER)
            return
        end
        local title2 = CommonStr.LEFT_TIME .. Common:getFormatTime(leftTime)
        local title = CommonStr.SURECAST .. castGold .. CommonStr.GOLD_FINISH_BUILD
            UIMgr:getInstance():openUI(UITYPE.PROP_BOX, {type=PROP_BOX_TYPE.MONEY_ACCELERATION,text=title,timeText=title2,
                callback=handler(self, function()
                local soldierJob = ArmsData:getInstance():getSoldierJobByBuildingType(buildingType)
                local soldierAnmationTempleType = ArmsData:getInstance():getDefaultSoldierAnmationTempleTypeByBuildingType(buildingType)
                UseGoldMakeSoldierAcceService:sendAccelerationMakeSoldierReq(castGold,AccelerationMakeSoldierAction.rightNowGold,buildingPos,soldierJob,info.lv,num,soldierAnmationTempleType,info.name)
            end),sureBtnText=CommonStr.YES,cancelBtnText=CommonStr.NO,buildingPos=buildingPos
            })
    end
end

--UI离开舞台后都会调用这个接口
--返回值(无)
function MakeSoldierView:onExit()
    --MyLog("MakeSoldierView onExit()")
    UICommon:getInstance():setMapTouchAable(true)
    TimeMgr:getInstance():removeTypeInfoByIndex(TimeType.UPDATE_SOLDIER_TRAINING_TIME,1,1)
end

--析构函数(此时已经从内存中释放掉资源了)
--返回值(无)
function MakeSoldierView:onDestroy()
    --MyLog("MakeSoldierView:onDestroy")
end

--关闭按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function MakeSoldierView:closeCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        UIMgr:getInstance():openUI(UITYPE.BUILDING_MENU, {building=self.data.building})
        UIMgr:getInstance():closeUI(self.uiType)
    end
end

