

InWallBuildingInfo = class("InWallBuildingInfo",UIBaseView)

--构造
--uiType UI类型
--data 数据
--返回值(无)
function InWallBuildingInfo:ctor(parent)
    self.parent = parent
    self:init()
end

--初始化
--返回值(无)
function InWallBuildingInfo:init()
    --关闭按钮
    self.closeBtn = Common:seekNodeByName(self.root,"closeBtn")
    self.closeBtn:addTouchEventListener(handler(self,self.closeCallback))

    --建筑描述
    self.desLab = Common:seekNodeByName(self.root,"qiLab")

    --升级按钮
    self.upgradeInfoBtn = Common:seekNodeByName(self.root,"upgradeBtn")
    self.upgradeInfoBtn:addTouchEventListener(handler(self,self.upgradeInfoBtnCallback))
    self.upgradeInfoLab = Common:seekNodeByName(self.root,"upgradeLab")
    self.upgradeInfoLab:setString(CommonStr.UPLV)

    --左侧建筑图片
    self.buildingImg = Common:seekNodeByName(self.root,"buildingimg")

    --左侧建筑图片名字
    self.buildingNameLab = Common:seekNodeByName(self.root,"namelab")

    --左侧建筑图片下一等级
    self.buildingNextLvLab = Common:seekNodeByName(self.root,"lvlab")

    --建筑条件列表框
    self.conditionListBox = Common:seekNodeByName(self.root,"listinfoImg")

    --建造时间
    self.buildingTimeLab = Common:seekNodeByName(self.root,"timeLab")

    --立即升级按钮
    self.rightUpLvBtn = Common:seekNodeByName(self.root,"immediatelyBtn")
    self.rightUpLvBtn:addTouchEventListener(handler(self,self.rightNowUpLvBtnCallback))
    self.rightUpLab = Common:seekNodeByName(self.rightUpLvBtn,"immediatelyLab")
    self.rightUpLab:setString(CommonStr.RIGHT_NOW_UP)
    self.castGoldLab = Common:seekNodeByName(self.rightUpLvBtn,"goldLab")

    local leftTime = self:getBuildingUpTime()
    if leftTime == nil or leftTime == 0 then
        self.castGoldLab:setString("" .. 0 .. CommonStr.GOLD)
        return
    end

    local buildingGold = CommonConfig:getInstance():getBuildingAccelerationCastGold(leftTime)
    self.castGoldLab:setString("" .. buildingGold .. CommonStr.GOLD)

    --创建升级建筑条件列表
    self:createUpBuildingConditionList()
end

--立即升级按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function InWallBuildingInfo:rightNowUpLvBtnCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        local pos = self:getBuildingPos()
        local leftTime = self:getBuildingUpTime()
        if leftTime == nil or leftTime == 0 then
            Prop:getInstance():showMsg(CommonStr.BUILDING_HAVE_FULL_LEVEL)
            return
        end
        local buildingGold = CommonConfig:getInstance():getBuildingAccelerationCastGold(leftTime)
        local title2 = CommonStr.LEFT_TIME .. Common:getFormatTime(leftTime)
        local title = CommonStr.SURECAST .. buildingGold .. CommonStr.GOLD_FINISH_BUILD
            UIMgr:getInstance():openUI(UITYPE.PROP_BOX, {type=PROP_BOX_TYPE.MONEY_ACCELERATION,text=title,timeText=title2,
                    callback=handler(self, self.sendAccelerationUpLvReq),sureBtnText=CommonStr.YES,cancelBtnText=CommonStr.NO,buildingPos=pos
            })
    end
end

--是否可以升级建筑
function InWallBuildingInfo:isCanUpBuilding()
    if CityBuildingModel:getInstance():isHaveBuildingUp(true) then
        return
    end

    local pos = self:getBuildingPos()
    --建筑描述
    local building = self.data.building
    local buildingPos = building:getTag()
    local buildingType = CityBuildingModel:getInstance():getBuildType(buildingPos)
    local buildingInfo = CityBuildingModel:getInstance():getBuildInfo(buildingPos)
    local info = BuildingUpLvConfig:getInstance():getConfigInfo(buildingType,buildingInfo.level+1)
    --粮食判断
    if info.bu_grain > PlayerData:getInstance():getFood() then
        print("粮食不足")
        Prop:getInstance():showMsg(CommonStr.NOT_ENOUGH_FOOD)
        return
    end
    --木头判断
    if info.bu_wood > PlayerData:getInstance().wood then
        print("木头不足")
        Prop:getInstance():showMsg(CommonStr.NOT_ENOUGH_WOOD)
        return
    end
    --铁矿判断
    if info.bu_iron > PlayerData:getInstance().iron then
        print("铁矿不足")
        Prop:getInstance():showMsg(CommonStr.NOT_ENOUGH_IRON)
        return
    end
    --秘银判断
    if info.bu_mithril > PlayerData:getInstance().mithril then
        print("秘银不足")
        Prop:getInstance():showMsg(CommonStr.NOT_ENOUGH_MITHRIL)
        return
    end
    --道具数量
    if info.bu_prop > 0 then
        local propId = CommonConfig:getInstance():getDefTowerPropID()
        local itemConfig = ItemTemplateConfig:getInstance():getItemTemplateByID(propId)
        if itemConfig == nil then
            print("读取物品配置失败")
            return
        end
        local item = ItemData:getInstance():getItemByID(propId)
        if item == nil or item.number < info.bu_prop then
            Lan:hintClient(6,"身上{}不够",{itemConfig.it_name})
            return
        end
    end

    return true
end

--发送加速建筑升级请求
--返回值(无)
function InWallBuildingInfo:sendAccelerationUpLvReq()
    if not self:isCanUpBuilding() then
        return
    end

    local pos = self:getBuildingPos()
    local leftTime = self:getBuildingUpTime()
    local castGold = CommonConfig:getInstance():getBuildingAccelerationCastGold(leftTime)
    if castGold > PlayerData:getInstance().gold then
        Prop:getInstance():showMsg(CommonStr.NO_GOLD_RIGHTNOW_UP_BUILDING)
        return
    end

    local buildingType = CityBuildingModel:getInstance():getBuildType(pos)
    BuildingAccelerationService:sendAccelerationGoldReq(self:getBuildingPos(),castGold,buildingType,AccelerationAction.RIGHT_NOW_UP)
end

--获取建筑物位置
--返回值(建筑位置)
function InWallBuildingInfo:getBuildingPos()
    return self.data.building:getTag()
end

--获取建筑升级时间
--返回值(升级时间)
function InWallBuildingInfo:getBuildingUpTime()
    local buildingPos = self:getBuildingPos()
    local buildingType = CityBuildingModel:getInstance():getBuildType(buildingPos)
    local buildingInfo = CityBuildingModel:getInstance():getBuildInfo(buildingPos)
    if buildingInfo == nil then
        buildingInfo = {}
        buildingInfo.level = 1
    end
    local upInfo = BuildingUpLvConfig:getInstance():getConfigInfo(buildingType,buildingInfo.level+1)
    if upInfo == nil then  --满级了
        return
    end
    return upInfo.bu_time
end

--创建升级建筑条件列表
--返回值(无)
function InWallBuildingInfo:createUpBuildingConditionList()
    if self.listView ~= nil then
        self.listView:removeFromParent()
    end

    local buildingPos = self:getBuildingPos()
    local buildingType = CityBuildingModel:getInstance():getBuildType(buildingPos)

    --建筑描述
    local buildingTypeInfo = BuildingTypeConfig:getInstance():getConfigInfo(buildingType)
    self.desLab:setString(buildingTypeInfo.bt_detaileddescription)

    --建筑升级时间
    local isCanUp = true
    local buildingInfo = CityBuildingModel:getInstance():getBuildInfo(buildingPos)
    if buildingInfo == nil then
        buildingInfo = {}
        buildingInfo.level = 1
    end
    local upInfo = BuildingUpLvConfig:getInstance():getConfigInfo(buildingType,buildingInfo.level+1)
    if upInfo == nil then  --满级了
        isCanUp = false
    end

    if isCanUp then
        local time = Common:getFormatTime(upInfo.bu_time)
        self.buildingTimeLab:setString(time)
    else
        self.buildingTimeLab:setString("00:00:00")
        return
    end

    local conditionInfolist = CityBuildingModel:getInstance():getUpBuildingCondition(buildingType,buildingInfo.level+1)
    local signHigh = 60
    local totalHigh = (#conditionInfolist)*signHigh

    local size = self.conditionListBox:getContentSize()
    self.listView = cc.ui.UIListView.new {
        bgColor = cc.c4b(255, 255, 0, 0),
        viewRect = cc.rect(0, 15, size.width, size.height-75),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
    }
    self.conditionListBox:addChild(self.listView,200)
    self.listView:setTouchEnabled(true)

    -- add items
    for i=1,#conditionInfolist do
        local item = self.listView:newItem()
        local content = display.newNode()
        if i == 1 then
            content = display.newCutomColorLayer(cc.c4b(0,255,0,0),size.width,signHigh)
        elseif i == 2 then
            content = display.newCutomColorLayer(cc.c4b(255,0,0,0),size.width,signHigh)
        end

        local conditionLab = display.newTTFLabel({
            text = "abc",
            font = "Arial",
            size = 26,
            color = cc.c3b(255, 0, 0), -- 使用纯红色
            align = cc.TEXT_ALIGNMENT_LEFT,
        })
        content:addChild(conditionLab)
        conditionLab:setAnchorPoint(0,0)
        conditionLab:setPosition(40, 15)
        conditionLab:setString(conditionInfolist[i].name)

        local picName = "ui/build_details/unfinish.png"
        if conditionInfolist[i].haveArrive then
            picName = "ui/build_details/finish.png"
            conditionLab:setColor(cc.c3b(255, 255, 255))
        end
        local sprite = display.newSprite(picName)
        sprite:setPosition(300,30)
        content:addChild(sprite)
        if conditionInfolist[i].useProp then
            sprite:setPosition(350,30)
        end

        content:setContentSize(size.width, signHigh)
        item:addContent(content)
        item:setItemSize(size.width, signHigh)
        self.listView:addItem(item)
    end

    self.listView:reload()
end

--升级按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function InWallBuildingInfo:upgradeInfoBtnCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        if not self:isCanUpBuilding() then
            return
        end

        local buildingPos = self:getBuildingPos()
        CityBuildingService:upLvBuildingSeq(buildingPos)
    end
end

--UI加到舞台后会调用这个接口
--返回值(无)
function InWallBuildingInfo:onEnter()
    --MyLog("Build_detailsView onEnter...")
    --UICommon:moveMapToDest(self.data.building,self.buildWin,self)
    UICommon:getInstance():setMapTouchAable(false)

    --建筑描述
    local building = self.data.building
    local buildingPos = building:getTag()
    local buildingType = CityBuildingModel:getInstance():getBuildType(buildingPos)
    local buildingTypeInfo = BuildingTypeConfig:getInstance():getConfigInfo(buildingType)
    self.desLab:setString(buildingTypeInfo.bt_description)

    --建筑图片和名字
    local buildingInfo = CityBuildingModel:getInstance():getBuildInfo(buildingPos)
    local builingUpInfo = BuildingUpLvConfig:getInstance():getConfigInfo(buildingType,buildingInfo.level)
    local resPath = BuildingUpLvConfig:getBuildingResPath2(buildingType,buildingInfo.level)
    self.buildingImg:loadTexture(resPath,ccui.TextureResType.plistType)
    local buildingName = BuildingTypeConfig:getInstance():getBuildingNameByType(buildingType)
    self.buildingNameLab:setString(buildingName)

    --建筑等级
    local buildingInfo = CityBuildingModel:getInstance():getBuildInfo(buildingPos)
    if buildingInfo ~= nil then
        local upInfo = BuildingUpLvConfig:getInstance():getConfigInfo(buildingType,buildingInfo.level+1)
        if upInfo == nil then  --满级了
            self.buildingNextLvLab:setString(CommonStr.NEXTLV .. " " .. CommonStr.WU)
        else
            self.buildingNextLvLab:setString(CommonStr.NEXTLV .. " " .. buildingInfo.level+1)
        end
    end
end

--UI离开舞台后会调用这个接口
--返回值(无)
function InWallBuildingInfo:onExit()
    --MyLog("Build_detailsView onExit()")
    --UICommon:getInstance():moveBackMapToDest()
    UICommon:getInstance():setMapTouchAable(true)
    TimeMgr:getInstance():removeTypeInfoByIndex(TimeType.RIGHTNOW_UP_BUILDING,1,1)
end

--析构函数(此时已经从内存中释放掉资源了)
--返回值(无)
function InWallBuildingInfo:onDestroy()
    --MyLog("--Build_detailsView:onDestroy")
end

--关闭按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function InWallBuildingInfo:closeCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        MyLog("close click...")
        UIMgr:getInstance():openUI(UITYPE.BUILDING_MENU, {building=self.data.building})
        UIMgr:getInstance():closeUI(self.uiType)
    end
end

