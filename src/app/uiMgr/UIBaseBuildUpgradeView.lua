--
-- Author: Your Name
-- Date: 2016-01-11 15:20:55
--
UIBaseBuildUpgradeView = class("UIBaseBuildUpgradeView",function()
    return display.newLayer()
end)

--构造
--uiType UI类型
--data 数据
--返回值(无)
function UIBaseBuildUpgradeView:ctor(uiType,data)
    self.baseView = BaseView.new(self,uiType,data)
    self.pos = data
end

--初始化
--返回值(无)
function UIBaseBuildUpgradeView:init()
    self.root = Common:loadUIJson(BUILDE_UPGRADE_HEAD)
    self:addChild(self.root)
    self.root:setTouchEnabled(false)

    --关闭按钮
    self.closeBtn = Common:seekNodeByName(self.root,"closeBtn")
    self.closeBtn:addTouchEventListener(handler(self,self.onClose))

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
    --列表
    self.listPan = Common:seekNodeByName(self.conditionListBox,"list_pan")

    --建造时间
    self.buildingTimeLab = Common:seekNodeByName(self.root,"timeLab")

    --立即升级按钮
    self.rightUpLvBtn = Common:seekNodeByName(self.root,"immediatelyBtn")
    self.rightUpLvBtn:addTouchEventListener(handler(self,self.rightNowUpLvBtnCallback))
    self.rightUpLab = Common:seekNodeByName(self.rightUpLvBtn,"immediatelyLab")
    self.rightUpLab:setString(CommonStr.RIGHT_NOW_UP)
    self.castGoldLab = Common:seekNodeByName(self.rightUpLvBtn,"goldLab")
end

--立即升级按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function UIBaseBuildUpgradeView:rightNowUpLvBtnCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        local leftTime = self:getBuildingUpTime()
        if leftTime == 0 then
            Prop:getInstance():showMsg(CommonStr.BUILDING_HAVE_FULL_LEVEL)
            return
        end
        local buildingGold = CommonConfig:getInstance():getBuildingAccelerationCastGold(leftTime)
        local title2 = CommonStr.LEFT_TIME .. Common:getFormatTime(leftTime)
        local title = CommonStr.SURECAST .. buildingGold .. CommonStr.GOLD_FINISH_BUILD
            UIMgr:getInstance():openUI(UITYPE.PROP_BOX, {type=PROP_BOX_TYPE.MONEY_ACCELERATION,text=title,timeText=title2,
                    callback=handler(self, self.sendAccelerationUpLvReq),sureBtnText=CommonStr.YES,cancelBtnText=CommonStr.NO,buildingPos=self.pos
            })
    end
end

--是否有建筑正在升级
function UIBaseBuildUpgradeView:isHaveBuildingUp()
    if CityBuildingModel:getInstance():isHaveBuildingUp(true) then
        return true
    end
    return false
end

--是否可以升级建筑
function UIBaseBuildUpgradeView:isCanUpBuilding()
    --建筑描述
    local info = BuildingUpLvConfig:getInstance():getConfigInfo(self.buildingType,self.level+1)
    if info == nil then
        Lan:hintClient(18, "建筑已经满级了,无法再进行升级")
        return false
    end

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
function UIBaseBuildUpgradeView:sendAccelerationUpLvReq()
    if self:isHaveBuildingUp() then
        return
    end

    if not self:isCanUpBuilding() then
        return
    end

    local leftTime = self:getBuildingUpTime()
    local castGold = CommonConfig:getInstance():getBuildingAccelerationCastGold(leftTime)
    if castGold > PlayerData:getInstance().gold then
        Prop:getInstance():showMsg(CommonStr.NO_GOLD_RIGHTNOW_UP_BUILDING)
        return
    end

    BuildingAccelerationService:sendAccelerationGoldReq(self.pos,castGold,self.buildingType,AccelerationAction.RIGHT_NOW_UP)
end

--获取建筑升级时间
--返回值(升级时间)
function UIBaseBuildUpgradeView:getBuildingUpTime()
    local upInfo = BuildingUpLvConfig:getInstance():getConfigInfo(self.buildingType,self.level+1)
    if upInfo == nil then  --满级了
        return 0
    end
    return upInfo.bu_time
end

--升级按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function UIBaseBuildUpgradeView:upgradeInfoBtnCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
       if self:isHaveBuildingUp() then
            return
        end

        if not self:isCanUpBuilding() then
            return
        end

        CityBuildingService:upLvBuildingSeq(self.pos)
    end
end

--UI加到舞台后会调用这个接口
--返回值(无)
function UIBaseBuildUpgradeView:onEnter()
    --MyLog("Build_detailsView onEnter...")
    --UICommon:moveMapToDest(self.data.building,self.buildWin,self)

    --设置数据
    local buildingType = CityBuildingModel:getInstance():getBuildType(self.pos)
    self:setBuildingType(buildingType)
    local buildingInfo = CityBuildingModel:getInstance():getBuildInfo(self.pos)
    if buildingInfo == nil then
        buildingInfo = {}
        buildingInfo.level = 1
    end
    self:setLevel(buildingInfo.level)

    self:calRightNowUpCastGold()

    --创建升级建筑条件列表
    self:createUpBuildingConditionList()

    UICommon:getInstance():setMapTouchAable(false)

    --建筑描述
    local buildingTypeInfo = BuildingTypeConfig:getInstance():getConfigInfo(self.buildingType)
    self.desLab:setString(buildingTypeInfo.bt_description)

    --建筑图片和名字
    self:updateImgAndName()

    --建筑等级
    local upInfo = BuildingUpLvConfig:getInstance():getConfigInfo(self.buildingType,self.level+1)
    if upInfo == nil then  --满级了
        self.buildingNextLvLab:setString(CommonStr.NEXTLV .. " " .. CommonStr.WU)
    else
        self.buildingNextLvLab:setString(CommonStr.NEXTLV .. " " .. self.level+1)
    end
end

--UI离开舞台后会调用这个接口
--返回值(无)
function UIBaseBuildUpgradeView:onExit()
    --MyLog("Build_detailsView onExit()")
    --UICommon:getInstance():moveBackMapToDest()
    UICommon:getInstance():setMapTouchAable(true)
    TimeMgr:getInstance():removeTypeInfoByIndex(TimeType.RIGHTNOW_UP_BUILDING,1,1)
    TimeMgr:getInstance():removeInfoByType(TimeType.upLevel)
end

--析构函数(此时已经从内存中释放掉资源了)
--返回值(无)
function UIBaseBuildUpgradeView:onDestroy()
    --MyLog("--Build_detailsView:onDestroy")
end

--关闭按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function UIBaseBuildUpgradeView:onClose(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        -- 显示菜单 隐藏自己
        self:getParent().baseView:showTopView()
    end
end

-- 显示界面
function UIBaseBuildUpgradeView:showView()
    self:setVisible(true)
    self.isShow = true
end

-- 隐藏界面
function UIBaseBuildUpgradeView:hideView()
    self:setVisible(false)
    self.isShow = false
end

--界面是否在显示中
function UIBaseBuildUpgradeView:isShowVew()
    return self.isShow
end

--设置下一个等级标题
function UIBaseBuildUpgradeView:setNextLevelTitle(name,level)
    self.buildingNextLvLab:setString(name .. " " .. Lan:lanText(201, "下一等级 {}", {level}))
end

--设置建筑描述
function UIBaseBuildUpgradeView:setDescrp(descrp)
    self.desLab:setString(descrp)
end

--设置建筑类型
function UIBaseBuildUpgradeView:setBuildingType(buildingType)
    self.buildingType = buildingType
end

--设置建筑等级
function UIBaseBuildUpgradeView:setLevel(level)
    self.level = level
end

--获取建筑类型
function UIBaseBuildUpgradeView:getBuildingType()
    return self.buildingType
end

--更新建筑图片和名称
function UIBaseBuildUpgradeView:updateImgAndName()
    local resPath = BuildingUpLvConfig:getBuildingResPath2(self.buildingType,self.level)
    self.buildingImg:loadTexture(resPath,ccui.TextureResType.plistType)
    local buildingName = BuildingTypeConfig:getInstance():getBuildingNameByType(self.buildingType)
    self.buildingNameLab:setString(buildingName)
end

--计算立刻升级时间
function UIBaseBuildUpgradeView:calRightNowUpLevelTime(upLevelCount)
    upLevelCount = upLevelCount or 1
    local time = self:getBuildingUpTime() * upLevelCount
    if time == 0 then
        self.buildingTimeLab:setString("00:00:00")
        return false     
    end

    local time = Common:getFormatTime(time)
    self.buildingTimeLab:setString(time)

    return true
end

--计算立刻升级花费的金币
function UIBaseBuildUpgradeView:calRightNowUpCastGold(count)
    count = count or 1
    local leftTime = self:getBuildingUpTime()
    if leftTime == 0 then
        self.castGoldLab:setString("" .. 0 .. CommonStr.GOLD)
        return 0
    else
        local castGold = CommonConfig:getInstance():getBuildingAccelerationCastGold(leftTime)
        castGold = castGold * count
        self.castGoldLab:setString("" .. castGold .. CommonStr.GOLD)
        return castGold
    end
end

function UIBaseBuildUpgradeView:createUpBuildingConditionList(buildingCount)
    if self.listView ~= nil then
        self.listView:removeAllItems()
        self.listView:removeFromParent()
        self.listView = nil
    end

    self.listView = MMUIListview.new(nil,nil,self.listPan)
    self.conditionListBox:addChild(self.listView)

    --建筑描述
    local buildingTypeInfo = BuildingTypeConfig:getInstance():getConfigInfo(self.buildingType)
    self.desLab:setString(buildingTypeInfo.bt_detaileddescription)

    --计算立即升级时间
    if not self:calRightNowUpLevelTime(buildingCount) then
        return
    end

    local conditionInfolist = CityBuildingModel:getInstance():getUpBuildingCondition(self.buildingType,self.level+1,buildingCount)

    local size = self.conditionListBox:getContentSize()
    for i=1,#conditionInfolist do
        local content = ccui.Layout:create()
        content:setContentSize(cc.size(size.width,60))
        content:setAnchorPoint(0.5,1)
        content:setPosition(0,0)
        self.listView:pushBackCustomItem(content)

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
    end
end

--更新升级中的UI
function UIBaseBuildUpgradeView:updateUpLevelUI(upLevelTime)
    self.upgradeInfoBtn:setTouchEnabled(false)
    self.rightUpLvBtn:setTouchEnabled(false)
    self.upgradeInfoBtn:setBright(false)
    self.rightUpLvBtn:setBright(false)

    TimeMgr:getInstance():createTime(upLevelTime,self.updateTime,self,TimeType.upLevel,1)

    if self.slider ~= nil then
        self.slider:setTouchEnabled(false)
    end
    if self.btnPlus ~= nil then
        self.btnPlus:setTouchEnabled(false)
    end
    if self.btnMinus ~= nil then
        self.btnMinus:setTouchEnabled(false)
    end
end

--更新时间
function UIBaseBuildUpgradeView:updateTime(info)
    if info.time <= 0 then
        TimeMgr:getInstance():removeInfoByType(info.timeType)
    end
    local time = Common:getFormatTime(info.time)
    self.buildingTimeLab:setString(time)

    if info.time <= 0 then
        local command = UIMgr:getInstance():getUICtrlByType(UITYPE.TERRITORY)
        if command ~= nil then
            command:updateFinishUpLevelUI(self.buildingType,2)
        end
    end
end

--完成升级UI
function UIBaseBuildUpgradeView:finishUpLevelUI()
    self.upgradeInfoBtn:setTouchEnabled(true)
    self.rightUpLvBtn:setTouchEnabled(true)
    self.upgradeInfoBtn:setBright(true)
    self.rightUpLvBtn:setBright(true)

    if self.slider ~= nil then
        self.slider:setTouchEnabled(true)
    end
    if self.btnPlus ~= nil then
        self.btnPlus:setTouchEnabled(true)
    end
    if self.btnMinus ~= nil then
        self.btnMinus:setTouchEnabled(true)
    end
    TimeMgr:getInstance():removeInfoByType(TimeType.upLevel)
end

--是否放置到了世界地图上
function UIBaseBuildUpgradeView:isAtWorldMap()
    local info = OutPlaceBuildingData:getInstance():getInfoByType(self.buildingType)
    if info ~= nil then
        Lan:hintClient(20, "该建筑已经放置到世界地图上,请收回后再进行升级")
        return true
    end
    return false
end

--升级野外建筑请求
function UIBaseBuildUpgradeView:upgradeOutBuildingReq(buildingIds)
    if TerritoryModel:getInstance():isHaveUpLevelBuilding() then
        return
    end

    if not self:isCanUpBuilding() then
        return
    end

    if self:isAtWorldMap() then
        return
    end

    TerritoryService:getInstance():upLevelBuildingReq(buildingIds)
end

--立即升级野外建筑请求
--返回值(无)
function UIBaseBuildUpgradeView:rightNowUpLevelOutBuildingReq(instanceIds)
    if TerritoryModel:getInstance():isHaveUpLevelBuilding() then
        return
    end

    if not self:isCanUpBuilding() then
        return
    end

    if self:isAtWorldMap() then
        return
    end

    local castGold = self:calRightNowUpCastGold(#instanceIds)
    if castGold > PlayerData:getInstance().gold then
        Prop:getInstance():showMsg(CommonStr.NO_GOLD_RIGHTNOW_UP_BUILDING)
        return
    end
    TerritoryAcceService:getInstance():useGoldUpLevelReq(instanceIds,castGold)
end




