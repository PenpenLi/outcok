--[[
    jinyan.zhang
    堡垒UI
--]]

FortressView = class("FortressView",UIBaseView)

--构造
--uiType UI类型
--data 数据
--返回值(无)
function FortressView:ctor(uiType,data)
    self.data = data
    self.super.ctor(self,uiType)
    self:adapterSize()
end

--初始化
--返回值(无)
function FortressView:init()
    self.root = Common:loadUIJson(FORTRESS_PATH)
    self:addChild(self.root)

    --关闭按钮
    self.closeBtn = Common:seekNodeByName(self.root,"closeBtn")
    self.closeBtn:addTouchEventListener(handler(self,self.closeCallback))

    self.pointBuildListPosWin = Common:seekNodeByName(self.root,"frame")
    self.trapListPan = Common:seekNodeByName(self.root,"Panel_1")

    --陷井图片
    self.trapImg = Common:seekNodeByName(self.root,"soldierimg")
    self.trapImg:setVisible(false)
    self.trapImg:setTouchEnabled(true)
    self.trapImg:addTouchEventListener(handler(self,self.trapBtnCallBack))
    self.trapImg:setScale(2)

    --陷井名字
    self.trapNameLab = Common:seekNodeByName(self.root,"namelab")

    --陷井数量
    self.trapNumLab = Common:seekNodeByName(self.root,"numlab")
    self.trapMaxNumLab = Common:seekNodeByName(self.root,"trapnumLab")
    local curTrapNum = ArmsData:getInstance():getAllTrapCount()
    local maxTrapCount = FortressModel:getInstance():getMaxTrapCount()
    self.trapMaxNumLab:setString(CommonStr.TRAP_NUM .. ": " .. curTrapNum .. "/" .. maxTrapCount)

    --添加陷井数量
    self.addTrapNumLab = Common:seekNodeByName(self.root,"num_lab")

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
                                    count=self:getTrapListCount(),
                                    pointBoxNode=self.pointBuildListPosWin,
        parent=self})
    self.root:addChild(self.buildinglist)
    self.buildinglist:registerMsg(0,self,self.finishSelTrapCallback)

    --建造按钮
    self.buildBtn = Common:seekNodeByName(self.root,"trainingBtn")
    self.buildBtn:addTouchEventListener(handler(self,self.makeTrainBtnCallback))
    self.buildLab = Common:seekNodeByName(self.buildBtn,"trainingLab")
    local text = Lan:lanText(1,"训练")
    self.buildLab:setString(text)
    self.trainTimeLab = Common:seekNodeByName(self.buildBtn,"timelab")

    --立即建造按钮
    self.rightNowBuildBtn = Common:seekNodeByName(self.root,"immediateTrainingBtn")
    self.rightNowBuildBtn:addTouchEventListener(handler(self,self.rightNowMakeTrapBtnCallback))
    self.rightNowBuildLab = Common:seekNodeByName(self.rightNowBuildBtn,"immediateTrainingLab")
    self.rightNowBuildLab:setString(CommonStr.RIGHTNOW_TRAIN)
    self.castLab = Common:seekNodeByName(self.rightNowBuildBtn,"goldLab")

    --下侧面板
    self.downPan = Common:seekNodeByName(self.root,"Panel_35")

    --创建滑动条
    self.maxTrapCount = maxTrapCount - curTrapNum
    local str = tostring(self.maxTrapCount)
    local len = string.len(str)
    self.offsetSliderValue = 1/math.pow(10,len)

    self:createSlider()

    --创建陷井信息层
    self.trapInfoView = TrapInfoView.new(self)
    --创建制造陷井信息层
    self.makeingTrap = MakeingTrap.new(self)
end

--UI加到舞台后都会调用这个接口
--返回值(无)
function FortressView:onEnter()
    --MyLog("FortressView onEnter...")
    UICommon:getInstance():setMapTouchAable(false)
    local tempData = {}

    local buildingBtnList = self.buildinglist:getBuildingList()
    for i=1,#buildingBtnList do
        buildingBtnList[i]:setTag(i)

        local sprite = display.newSprite(self.trapListData[i].smallPicName)
        sprite:setPosition(cc.p(sprite:getContentSize().width/2+50, 100))
        buildingBtnList[i]:addChild(sprite)

        local nameLab = display.newTTFLabel({
            text = self.trapListData[i].name,
            font = "Arial",
            size = 24,
            color = cc.c3b(255, 255, 0),
            align = cc.TEXT_ALIGNMENT_LEFT,
        })
        buildingBtnList[i]:addChild(nameLab)
        nameLab:setPosition(130, 100)

        if not self.trapListData[i].isCanBuild then
            sprite:setOpacity(128)
            self:setDownPanVisible(false)
            local unlockLab = display.newTTFLabel({
                text = self.trapListData[i].unlockDesStr,
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
            table.insert(tempData,self.trapListData[i])
        end
    end

    self.buildinglist:moveBuildToPos(self:getBuildIndex(tempData))
end

--完成选择陷井回调
--idx 第几个陷井被选中
--返回值(无)
function FortressView:finishSelTrapCallback(idx)
    local curSelTrapBtn = self:getCurSelTrapType()
    local index = curSelTrapBtn:getTag()
    local info = self.trapListData[index]
    print("idx=",idx,"curSelTrapBtn=",curSelTrapBtn,"index=",index)
    self.trapNameLab:setString(info.name)
    self.trapNumLab:setString(CommonStr.HAVE .. ": " .. info.trapNum)
    self.trapImg:loadTexture(info.bigPicName,ccui.TextureResType.plistType)
    self.trainTimeLab:setString(Common:getFormatTime(info.createTime))
    self.foodLab:setString(CommonStr.FOOD .. ": " ..  info.food)
    self.woodLab:setString(CommonStr.WOOD .. ": " .. info.wood)
    self.ironLab:setString(CommonStr.IRON .. ": " .. info.iron)
    self.metialLab:setString(CommonStr.MITHRIL .. ": " .. info.mithril)

    local buildingPos = self.data.building:getTag()
    local buildingState = CityBuildingModel:getInstance():getBuildingState(buildingPos)
    if info.isCanBuild and buildingState ~= BuildingState.makeSoldiers then
        self:setDownPanVisible(true)
    else
        self:setDownPanVisible(false)
        self.makeingTrap:updateUI(info)
    end

    self.trapImg:setVisible(true)
    self:setSliderValue(1)
end

--陷井按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function FortressView:trapBtnCallBack(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        local curSelTrapBtn = self:getCurSelTrapType()
        local index = curSelTrapBtn:getTag()
        local info = self.trapListData[index]
        self.trapInfoView:updateUI(info)
        self.trapListPan:setVisible(false)
        self.buildinglist:setVisible(false)
        self.trapInfoView.infoPan:setVisible(true)
    end
end

--设置滑动条数值
--number 数值
function FortressView:setSliderValue(number)
    local tmpValue = 100/self.maxTrapCount
    local per = tmpValue*number + self.offsetSliderValue
    if per > 100 then
        per = 100
    end
    self.slider:setSliderValue(per)
end

--创建滑动条
--返回值(无)
function FortressView:createSlider()
    sliderResPath =
    {
        bar = "ui/build_training/sliderBar.png",
        button = "ui/build_training/sliderButton.png",
    }

    local barHeight = 40
    local barWidth = 400
    self.slider = cc.ui.UISlider.new(display.LEFT_TO_RIGHT, sliderResPath, {scale9 = true})
    self.slider:onSliderValueChanged(function(event)
        local curNum = self.maxTrapCount*event.value/100
        curNum = math.floor(curNum)
        self.addTrapNumLab:setString("" .. curNum)
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
function FortressView:plusCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        local num = tonumber(self.addTrapNumLab:getString())
        if num < self.maxTrapCount then
            num = num + 1
            self:setSliderValue(num)
        end
    end
end

--减按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function FortressView:minusCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        local num = tonumber(self.addTrapNumLab:getString())
        if num > 0 then
            num = num - 1
            self:setSliderValue(num)
        end
    end
end

--根据陷井数量,刷新UI
--number 陷井数量
function FortressView:updateUIByNum(number)
    local curSelTrapBtn = self:getCurSelTrapType()
    local index = curSelTrapBtn:getTag()
    local info = self.trapListData[index]

    --建造时间
    local makeTime = self:getCreateTrapTime(info.createTime,number)
    self.trainTimeLab:setString(Common:getFormatTime(makeTime))
    local castGold = CommonConfig:getInstance():getAccelerationMakeTrapCastGold(makeTime)
    self.castLab:setString("" .. castGold .. CommonStr.GOLD)

    --粮食
    self.foodLab:setString(CommonStr.FOOD .. ": " ..  info.food * number)
    --木材
    self.woodLab:setString(CommonStr.WOOD .. ": " .. info.wood * number)
    --铁矿
    self.ironLab:setString(CommonStr.IRON .. ": " .. info.iron * number)
    --秘银
    self.metialLab:setString(CommonStr.MITHRIL .. ": " .. info.mithril * number)

    --粮食判断
    local color = cc.c3b(255, 255, 255)
    if info.food * number > PlayerData:getInstance():getFood() then
        color = cc.c3b(255, 0, 0) 
    end

    --木头判断
    if info.wood * number > PlayerData:getInstance().wood then
        color = cc.c3b(255, 0, 0) 
    end

    --铁矿判断
    if info.iron * number > PlayerData:getInstance().iron then
        color = cc.c3b(255, 0, 0) 
    end

    --秘银判断
    if info.mithril * number > PlayerData:getInstance().mithril then
        color = cc.c3b(255, 0, 0) 
    end
end

--获取创建陷井时间
--time 单个兵的训练时间
--num 兵的数量
function FortressView:getCreateTrapTime(time,num)
    local totalTime = time*num
    totalTime = math.ceil(totalTime)
    if totalTime <= 0 then
        totalTime = 0
    end
    return totalTime
end

--设置底下那个面板的隐藏/显示
--返回值(无)
function FortressView:setDownPanVisible(visible)
    self.downPan:setVisible(visible)
end

function FortressView:getBuildIndex(arr)
    table.sort(arr,function(a,b) return a.lv > b.lv end )
    local info = arr[1]
    for k,v in pairs(self.trapListData) do
        if info.lv == v.lv then
            return k - 1
        end
    end
    return 0
end

--获取当前选择的陷井类型
--返回值(当前选择的建筑)
function FortressView:getCurSelTrapType()
    return self.buildinglist:getCurSelBuilding()
end

--获取陷井间隔
--返回值(建筑间距)
function FortressView:getBuildingDis()
    return 20
end

--获取陷井列表个数
--返回值(建筑列表个数)
function FortressView:getTrapListCount()
    local buildingPos = self.data.building:getTag()
    self.trapListData = FortressModel:getInstance():getTrapListData(buildingPos)
    return #self.trapListData
end

--能否创建陷井
--返回值(true:可以,false:不可以)
function FortressView:isCanMakeingTrap()
    local curSelTrapBtn = self:getCurSelTrapType()
    local index = curSelTrapBtn:getTag()
    local info = self.trapListData[index]
    local num = tonumber(self.addTrapNumLab:getString())
    if num == 0 then
        Prop:getInstance():showMsg(CommonStr.MAKE_TRAP_NUM_IS_EMPTY)
        return false
    end
    
    local playerData = PlayerData:getInstance()
    --粮食判断
    if info.food * num > PlayerData:getInstance():getFood()then
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

--制造陷井按钮回调
--sender按钮本身
--eventType 事件类型
--返回值(无)
function FortressView:makeTrainBtnCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        if not self:isCanMakeingTrap() then
            return
        end

        local building = self.data.building
        local buildingPos = building:getTag()
        local buildingType = CityBuildingModel:getInstance():getBuildType(buildingPos)

        local curSelTrapBtn = self:getCurSelTrapType()
        local index = curSelTrapBtn:getTag()
        local info = self.trapListData[index]
        local num = tonumber(self.addTrapNumLab:getString())

        FortressService:makeTrapSeq(buildingPos,info.trapType,info.lv,num,info.name)
    end
end

--立即制造陷井按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function FortressView:rightNowMakeTrapBtnCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        if not self:isCanMakeingTrap() then
            return
        end

        local building = self.data.building
        local buildingPos = building:getTag()
        local buildingType = CityBuildingModel:getInstance():getBuildType(buildingPos)

        local curSelTrapBtn = self:getCurSelTrapType()
        local index = curSelTrapBtn:getTag()
        local info = self.trapListData[index]
        local num = tonumber(self.addTrapNumLab:getString())
        local leftTime = self:getCreateTrapTime(info.createTime,num)
        local castGold = CommonConfig:getInstance():getAccelerationMakeTrapCastGold(leftTime)
        if castGold > PlayerData:getInstance().gold then
            Prop:getInstance():showMsg(CommonStr.NO_GOLD_SPEDD_MAKE_TRAP)
            return
        end

        local title2 = CommonStr.LEFT_TIME .. Common:getFormatTime(leftTime)
        local title = CommonStr.SURECAST .. castGold .. CommonStr.GOLD_FINISH_MAKE_TRAP
            UIMgr:getInstance():openUI(UITYPE.PROP_BOX, {type=PROP_BOX_TYPE.MONEY_ACCELERATION,text=title,timeText=title2,
                callback=handler(self, function()
                UseGoldAcceMakeTrapService:sendAccelerationMakeTrapReq(castGold,AccelerationMakeSoldierAction.rightNowGold,buildingPos,info.trapType,info.lv,num,info.name)
            end),sureBtnText=CommonStr.YES,cancelBtnText=CommonStr.NO,buildingPos=buildingPos
            })
    end
end

--UI离开舞台后都会调用这个接口
--返回值(无)
function FortressView:onExit()
    --MyLog("FortressView onExit()")
    UICommon:getInstance():setMapTouchAable(true)
    TimeMgr:getInstance():removeTypeInfoByIndex(TimeType.UPDATE_SOLDIER_TRAINING_TIME,1,1)
end

--析构函数(此时已经从内存中释放掉资源了)
--返回值(无)
function FortressView:onDestroy()
    --MyLog("FortressView:onDestroy")
end

--关闭按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function FortressView:closeCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        UIMgr:getInstance():openUI(UITYPE.BUILDING_MENU, {building=self.data.building})
        UIMgr:getInstance():closeUI(self.uiType)
    end
end

