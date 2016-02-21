
--[[
    jinyan.zhang
    建筑菜单界面
--]]

Build_menuView = class("Build_menuView",UIBaseView)

--构造
--uiType UI类型
--data 数据
--返回值(无)
function Build_menuView:ctor(uiType,data)
    self.data = data
    self.super.ctor(self,uiType)
    self:adapterSize()
end

--初始化
--返回值(无)
function Build_menuView:init()
    self.root = Common:loadUIJson(BUILDING_MENU)
    self:addChild(self.root)

    --关闭按钮
    self.closeBtn = Common:seekNodeByName(self.root,"backbtn")
    self.closeBtn:addTouchEventListener(handler(self,self.closeCallback))

    --左侧建筑图片
    self.buildingImg = Common:seekNodeByName(self.root,"buildingimg")

    --左侧建筑名字
    self.buildingNameLab = Common:seekNodeByName(self.root,"buildingnameLab")

    --左侧建筑等级
    self.buildingLvLab = Common:seekNodeByName(self.root,"lvlab")

    --描述
    self.descrpLab = Common:seekNodeByName(self.root,"descrplab")

    --详情按钮
    self.detailsBtn = Common:seekNodeByName(self.root,"detailbtn")
    self.detailsBtn:addTouchEventListener(handler(self,self.detailsCallback))

    --升级按钮
    self.secondbtn = Common:seekNodeByName(self.root,"uplvbtn")
    self.secondbtn:addTouchEventListener(handler(self,self.upLvCallback))

    --出征或者是征兵按钮，取决于选中的建筑类型
    self.thirdbtn = Common:seekNodeByName(self.root,"btn")

    --加速按钮
    self.fourbtn = Common:seekNodeByName(self.root,"fourBtn")
    self.fourbtn:addTouchEventListener(handler(self,self.accelerationCallback))
end

--获取建筑物位置
--返回值(建筑位置)
function Build_menuView:getBuildingPos()
    return self.data.building:getTag()
end

--UI加到舞台后会调用这个接口
--返回值(无)
function Build_menuView:onEnter()
    --MyLog("Build_menuView onEnter...")
    local buildingPos = self:getBuildingPos()
    local buildingType = CityBuildingModel:getInstance():getBuildType(buildingPos)

    --建筑名字
    local buildingName = BuildingTypeConfig:getInstance():getBuildingNameByType(buildingType)
    self.buildingNameLab:setString(buildingName)

    --建筑等级
    local buildingInfo = CityBuildingModel:getInstance():getBuildInfo(buildingPos)
    if buildingInfo == nil then
        buildingInfo = {}
        buildingInfo.level = 1
    end

    if buildingInfo ~= nil then
        self.buildingLvLab:setString(CommonStr.GRADE .. " " .. buildingInfo.level)
    end

    --建筑图片
    local builingUpInfo = BuildingUpLvConfig:getInstance():getConfigInfo(buildingType,buildingInfo.level)
    local resPath = BuildingUpLvConfig:getBuildingResPath2(buildingType,buildingInfo.level)
    self.buildingImg:loadTexture(resPath,ccui.TextureResType.plistType)

    --建筑描述
    local buildingTypeInfo = BuildingTypeConfig:getInstance():getConfigInfo(buildingType)
    self.descrpLab:setString(buildingTypeInfo.bt_detaileddescription)

    local buildingState = CityBuildingModel:getInstance():getBuildingState(buildingPos)
    if buildingType == BuildType.firstAidTent then  --急救账篷
        local timeInfo = TimeInfoData:getInstance():getTimeInfoByType(BuildType.firstAidTent)
        if timeInfo ~= nil then
            buildingState = timeInfo.action
        end
    elseif buildingType == BuildType.trainingCamp then --训练场
        local heroList = PlayerData:getInstance():getHeroListByState(HeroState.train)
        if #heroList > 0 then
            buildingState = BuildingState.TRAIN_HERO
        end
    end

    if BuildingState.TRAIN_HERO == buildingState then  --训练英雄中
        self.thirdbtn:setVisible(false)
        self.fourbtn:setVisible(false)
        self.secondbtn:setVisible(true)
        local text = Lan:lanText(1,"训练")
        self.secondbtn:setTitleText(text)
        self.secondbtn:addTouchEventListener(handler(self,self.traininCallback))
    elseif BuildingState.removeBuilding == buildingState then --移除建筑
        self.fourbtn:setVisible(false)
        self.thirdbtn:setVisible(true)
        self.secondbtn:setVisible(true)
        self.secondbtn:setTitleText(CommonStr.CANCEL_REMOVE)
        self.thirdbtn:setTitleText(CommonStr.SPEED_REMOVE_BUILDING)
        self.secondbtn:addTouchEventListener(handler(self,self.cancelCallback))
        self.thirdbtn:addTouchEventListener(handler(self,self.goldAccelerationRemoveCallback))
    elseif BuildingState.uplving == buildingState then  --升级建筑
        self.secondbtn:setTitleText(CommonStr.CANCEL_UPLV)
        self.thirdbtn:setTitleText(CommonStr.BUILDING_SPEED)
        self.thirdbtn:setVisible(true)
        self.secondbtn:setVisible(true)
        self.secondbtn:addTouchEventListener(handler(self,self.cancelCallback))
        self.thirdbtn:addTouchEventListener(handler(self,self.buildingAccelerationCallback))
        self.fourbtn:setVisible(false)
    elseif BuildingState.createBuilding == buildingState then  --创建建筑
        self.thirdbtn:setVisible(false)
        self.fourbtn:setVisible(false)
        self.secondbtn:setVisible(true)
        self.secondbtn:setTitleText(CommonStr.BUILDING_SPEED)
        self.secondbtn:addTouchEventListener(handler(self,self.buildingAccelerationCallback))
    elseif BuildingState.makeSoldiers == buildingState and buildingType == BuildType.fortress then --堡垒制造陷井中
        if not MakeSoldierModel:getInstance():isHaveReadyArms(buildingPos)then
            self.fourbtn:setVisible(true)
            self.thirdbtn:setVisible(true)
            self.secondbtn:setVisible(true)
            self.secondbtn:setTitleText(CommonStr.CANCEL_MAKE_TRAP)
            self.thirdbtn:setTitleText(CommonStr.ACC_MAKE_TRAP)
            self.fourbtn:setTitleText(CommonStr.TRAP)
            self.secondbtn:addTouchEventListener(handler(self,self.cancelCallback))
            self.thirdbtn:addTouchEventListener(handler(self,self.trapAccelerationCallback))
            self.fourbtn:addTouchEventListener(handler(self,self.trapBtnCallback))
        else
            self.thirdbtn:setVisible(false)
            self.fourbtn:setVisible(false)
            self.secondbtn:setVisible(true)
            self.secondbtn:setTitleText(CommonStr.TRAP)
            self.secondbtn:addTouchEventListener(handler(self,self.trapBtnCallback))
        end
    elseif BuildingState.makeSoldiers == buildingState then --造兵中
          if not MakeSoldierModel:getInstance():isHaveReadyArms(buildingPos)then
            self.fourbtn:setVisible(true)
            self.thirdbtn:setVisible(true)
            self.secondbtn:setVisible(true)
            self.secondbtn:setTitleText(CommonStr.CANCEL_TRAIN)
            self.thirdbtn:setTitleText(CommonStr.ACC_TRAIN)

            local text = Lan:lanText(1,"训练")
            self.fourbtn:setTitleText(text)
            self.secondbtn:addTouchEventListener(handler(self,self.cancelCallback))
            self.thirdbtn:addTouchEventListener(handler(self,self.trainAccelerationCallback))
            self.fourbtn:addTouchEventListener(handler(self,self.trainCallback))
        else
            self.thirdbtn:setVisible(false)
            self.fourbtn:setVisible(false)
            self.secondbtn:setVisible(true)
            local text = Lan:lanText(1,"训练")
            self.secondbtn:setTitleText(text)
            self.secondbtn:addTouchEventListener(handler(self,self.trainCallback))
        end
    elseif BuildingState.TREATMENT == buildingState then --治疗中
            self.fourbtn:setVisible(false)
            self.thirdbtn:setVisible(true)
            self.secondbtn:setVisible(true)
            self.secondbtn:addTouchEventListener(handler(self,self.cancelTreatmentCallback))
            self.thirdbtn:addTouchEventListener(handler(self,self.accelerationTreatmentCallback))
            self.secondbtn:setTitleText(CommonStr.CANCEL_TREATMENT)
            self.thirdbtn:setTitleText(CommonStr.ACCELERATED_TREATMENT)
    elseif BuildingState.buildOk == buildingState then --正常状态
        if UseGoldAcceResProduceModel:getInstance():getProcduResSpeedTimeInfo(buildingPos) == nil and
             (buildingType == BuildType.farmland or buildingType == BuildType.loggingField
               or buildingType == BuildType.ironOre or buildingType == BuildType.illithium) then
            self.fourbtn:setVisible(true)
            self.fourbtn:setTitleText(CommonStr.RES_SPEED)
        else
            self.fourbtn:setVisible(false)
        end

        if buildingType == BuildType.castle then  --城堡
            self.fourbtn:setVisible(true)
            self.thirdbtn:addTouchEventListener(handler(self,self.castleCallback))
            local text = Lan:lanText(11,"城堡信息")
            self.thirdbtn:setTitleText(text)
            self.fourbtn:setTitleText(CommonStr.GAIN)
            self.fourbtn:addTouchEventListener(handler(self,self.castleAddCallback))
        elseif buildingType == BuildType.infantryBattalion or buildingType == BuildType.cavalryBattalion or  --兵营
            buildingType == BuildType.archerCamp or buildingType == BuildType.chariotBarracks
            or buildingType == BuildType.masterBarracks then
            local text = Lan:lanText(1,"训练")
            self.thirdbtn:setTitleText(text)
            self.thirdbtn:addTouchEventListener(handler(self,self.trainCallback))
        elseif buildingType == BuildType.wathchTower then  --瞭望塔
            self.thirdbtn:setTitleText(CommonStr.MILITARY_INTELLIGENCE)
            self.thirdbtn:addTouchEventListener(handler(self,self.watchTowerCallback))
        elseif buildingType == BuildType.farmland or buildingType == BuildType.loggingField
               or buildingType == BuildType.ironOre or buildingType == BuildType.illithium then
            self.thirdbtn:setTitleText(CommonStr.COLLECT)
            self.thirdbtn:addTouchEventListener(handler(self,self.CollectCallback))
        elseif buildingType == BuildType.firstAidTent then  --治疗账篷
            --治疗按钮
            self.thirdbtn:setVisible(true)
            self.thirdbtn:setTitleText(CommonStr.TREATMENT_HERO)
            self.thirdbtn:addTouchEventListener(handler(self,self.heroTreatmentCallback))
            self.fourbtn:setVisible(true)
            self.fourbtn:setTitleText(CommonStr.TREATMENT_UNIT)
            self.fourbtn:addTouchEventListener(handler(self,self.soldierTreatmentCallback))
        elseif buildingType == BuildType.fortress then  --堡垒
            self.fourbtn:setVisible(false)
            self.thirdbtn:setVisible(true)
            self.secondbtn:setVisible(true)
            self.thirdbtn:setTitleText(CommonStr.TRAP)
            self.thirdbtn:addTouchEventListener(handler(self,self.trapBtnCallback))
        elseif buildingType == BuildType.wall then  --城墙
            self.thirdbtn:setVisible(true)
            self.fourbtn:setVisible(true)
            self.thirdbtn:setTitleText(CommonStr.DEFS)
            self.fourbtn:setTitleText(CommonStr.STATE_ARMS)
            self.thirdbtn:addTouchEventListener(handler(self,self.defBtnCallback))
            self.fourbtn:addTouchEventListener(handler(self,self.stateArmsBtnCallback))
        elseif buildingType == BuildType.trainingCamp then
            self.thirdbtn:setVisible(true)
            local text = Lan:lanText(1,"训练")
            self.thirdbtn:setTitleText(text)
            self.thirdbtn:addTouchEventListener(handler(self,self.traininCallback))
        elseif buildingType == BuildType.PUB then  --酒錧
            self.thirdbtn:setVisible(true)
            self.thirdbtn:setTitleText(CommonStr.RECRUIT)
            self.thirdbtn:addTouchEventListener(handler(self,self.pubBtnCallback))
        else
            self.thirdbtn:setVisible(false)
        end
    end
    self:updateWallPic()
end

--科技列表按钮回调
--返回值(无)
function Build_menuView:collegeCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        UIMgr:getInstance():openUI(UITYPE.COLLEGE_PATH,self.data.building:getTag())
        UIMgr:getInstance():closeUI(self.uiType)
    end
end

--更新城墙图片
function Build_menuView:updateWallPic()
    local buildingPos = self:getBuildingPos()
    local buildingType = CityBuildingModel:getInstance():getBuildType(buildingPos)
    if buildingType ~= BuildType.wall then
        return
    end

    self.buildingImg:removeChildByTag(10212)

    local picPath = nil
    local wallState = WallModel:getInstance():getState()
    if wallState == WallState.fire then  --着火
        picPath = "citybuilding/fireBomb.png"
    elseif wallState == WallState.bad then  --破损
        picPath = "citybuilding/broken.png"
    end

    if picPath == nil then
        return
    end

    local wall = display.newSprite(picPath)
    wall:setPosition(0, 0)
    self.buildingImg:addChild(wall,1,10212)
end

--酒馆按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function Build_menuView:pubBtnCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        UIMgr:getInstance():openUI(UITYPE.PUB,self.data.building:getTag())
        UIMgr:getInstance():closeUI(self.uiType)
    end
end

--防御按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function Build_menuView:defBtnCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        UIMgr:getInstance():openUI(UITYPE.WALL, {building=self.data.building,subViewType=WallSubViewType.def})
        UIMgr:getInstance():closeUI(self.uiType)
    end
end

--驻军按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function Build_menuView:stateArmsBtnCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        UIMgr:getInstance():openUI(UITYPE.WALL, {building=self.data.building,subViewType=WallSubViewType.garrison})
        UIMgr:getInstance():closeUI(self.uiType)
    end
end

--陷井按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function Build_menuView:trapBtnCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        UIMgr:getInstance():openUI(UITYPE.FORTRESS, {building=self.data.building})
        UIMgr:getInstance():closeUI(self.uiType)
    end
end

--加速制造陷井按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function Build_menuView:trapAccelerationCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        UIMgr:getInstance():openUI(UITYPE.BUILDING_ACCELERATION,{pos=self:getBuildingPos(),building=self.data.building,accSpeedType=AccelerationType.trap_gold})
        UIMgr:getInstance():closeUI(self.uiType)
    end
end


--训练加速按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function Build_menuView:trainAccelerationCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        UIMgr:getInstance():openUI(UITYPE.BUILDING_ACCELERATION,{pos=self:getBuildingPos(),building=self.data.building,accSpeedType=AccelerationType.makeSoldier_gold})
        UIMgr:getInstance():closeUI(self.uiType)
    end
end

--英雄训练按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function Build_menuView:traininCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        UIMgr:getInstance():openUI(UITYPE.HERO_TRAIN, {building=self.data.building})
        UIMgr:getInstance():closeUI(self.uiType)
    end
end

--收集按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function Build_menuView:CollectCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self:sendCollectingResourcesReq()
    end
end

--训练英雄按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function Build_menuView:defBtnCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        UIMgr:getInstance():openUI(UITYPE.WALL, {building=self.data.building,subViewType=WallSubViewType.def})
        UIMgr:getInstance():closeUI(self.uiType)
    end
end

--UI离开舞台后会调用这个接口
--返回值(无)
function Build_menuView:onExit()
    --MyLog("Build_menuView onExit()")
end

--析构函数(此时已经从内存中释放掉资源了)
--返回值(无)
function Build_menuView:onDestroy()
    --MyLog("Build_menuView:onDestroy")
end

--关闭按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function Build_menuView:closeCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        MyLog("close click...")
        UIMgr:getInstance():closeUI(self.uiType)
    end
end

--军情按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function Build_menuView:watchTowerCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        UIMgr:getInstance():openUI(UITYPE.CITY_WATCHTOWER,{pos=self:getBuildingPos(),building=self.data.building})
        UIMgr:getInstance():closeUI(self.uiType)
    end
end

--金币加速按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function Build_menuView:buildingAccelerationCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        UIMgr:getInstance():openUI(UITYPE.BUILDING_ACCELERATION,{pos=self:getBuildingPos(),building=self.data.building,accSpeedType=AccelerationType.upBuildingLv_gold})
        UIMgr:getInstance():closeUI(self.uiType)
    end
end

--金币加速拆除按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function Build_menuView:goldAccelerationRemoveCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        UIMgr:getInstance():openUI(UITYPE.BUILDING_ACCELERATION,{pos=self:getBuildingPos(),building=self.data.building,accSpeedType=AccelerationType.removeBuilding_gold})
        UIMgr:getInstance():closeUI(self.uiType)
    end
end

--资源加速按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function Build_menuView:accelerationCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        UIMgr:getInstance():openUI(UITYPE.BUILDING_ACCELERATION,{pos=self:getBuildingPos(),building=self.data.building,accSpeedType=AccelerationType.res_gold})
        UIMgr:getInstance():closeUI(self.uiType)
    end
end

--详情按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function Build_menuView:detailsCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        local buildingPos = self:getBuildingPos()
        local buildingType = CityBuildingModel:getInstance():getBuildType(buildingPos)
        if buildingType == BuildType.farmland or buildingType == BuildType.loggingField
           or buildingType == BuildType.ironOre or buildingType == BuildType.illithium then
            UIMgr:getInstance():openUI(UITYPE.BUILDING_RES_DETAILS, {building=self.data.building})
            UIMgr:getInstance():closeUI(self.uiType)
        elseif buildingType == BuildType.firstAidTent then
            UIMgr:getInstance():openUI(UITYPE.BUILDING_AID_DETAILS, {building=self.data.building})
            UIMgr:getInstance():closeUI(self.uiType)
        elseif buildingType == BuildType.marchTent then
            UIMgr:getInstance():openUI(UITYPE.BUILDING_MARCH_DETAILS, {building=self.data.building})
            UIMgr:getInstance():closeUI(self.uiType)
        elseif buildingType == BuildType.warehouse then
            UIMgr:getInstance():openUI(UITYPE.WAREHOUSE_DETAILS, {building=self.data.building})
            UIMgr:getInstance():closeUI(self.uiType)
        elseif buildingType == BuildType.wall then
            UIMgr:getInstance():openUI(UITYPE.WALL_DETAILS, {building=self.data.building})
            UIMgr:getInstance():closeUI(self.uiType)
        elseif buildingType == BuildType.arrowTower or buildingType == BuildType.turret or buildingType == BuildType.magicTower then
            UIMgr:getInstance():openUI(UITYPE.TOWER_DETAILS, {building=self.data.building})
            UIMgr:getInstance():closeUI(self.uiType)
        elseif buildingType == BuildType.trainingCamp then
            UIMgr:getInstance():openUI(UITYPE.TRAINING_DETAILS, {building=self.data.building})
            UIMgr:getInstance():closeUI(self.uiType)
        elseif buildingType == BuildType.PUB then
            UIMgr:getInstance():openUI(UITYPE.PUB_DETAILS, {building=self.data.building})
            UIMgr:getInstance():closeUI(self.uiType)
        else
            UIMgr:getInstance():openUI(UITYPE.CITY_BUILD_DETAILS, {building=self.data.building})
            UIMgr:getInstance():closeUI(self.uiType)
            print("建筑详情")
        end
    end
end

--升级按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function Build_menuView:upLvCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        UIMgr:getInstance():openUI(UITYPE.CITY_BUILD_UPGRADE, {building=self.data.building})
        UIMgr:getInstance():closeUI(self.uiType)
    end
end

--取消按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function Build_menuView:cancelCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        local pos = self:getBuildingPos()
        local buildingState = CityBuildingModel:getInstance():getBuildingState(pos)
        if buildingState == BuildingState.removeBuilding then  --移除中
            UIMgr:getInstance():openUI(UITYPE.PROP_BOX, {type=PROP_BOX_TYPE.COMMON,text=CommonStr.SURE_CANCEL_REMOVE_BUILDING,
                    callback=handler(self, self.sendCancelRemoveBuildingReq),sureBtnText=CommonStr.YES,cancelBtnText=CommonStr.NO,buildingPos=pos
            })
        elseif buildingState == BuildingState.uplving then --升级中
            UIMgr:getInstance():openUI(UITYPE.PROP_BOX, {type=PROP_BOX_TYPE.COMMON,text=CommonStr.SURE_RETURN_HALF_RESOURCE,
            callback=handler(self, self.sendCancelUpLvBuildingReq),sureBtnText=CommonStr.SURE,cancelBtnText=CommonStr.CANCEL,buildingPos=pos
            })
        elseif BuildingState.makeSoldiers == buildingState then --造兵中
            local buildingType = CityBuildingModel:getInstance():getBuildType(pos)
            if buildingType == BuildType.fortress then  --堡垒
                UIMgr:getInstance():openUI(UITYPE.PROP_BOX, {type=PROP_BOX_TYPE.COMMON,text=CommonStr.SURE_RETURN_HALF_RESOURCE,
                callback=handler(self, self.sendCancelMakeTrapReq),sureBtnText=CommonStr.SURE,cancelBtnText=CommonStr.CANCEL,buildingPos=pos
                })
            else
                UIMgr:getInstance():openUI(UITYPE.PROP_BOX, {type=PROP_BOX_TYPE.COMMON,text=CommonStr.SURE_RETURN_HALF_RESOURCE,
                callback=handler(self, self.sendCancelTrainReq),sureBtnText=CommonStr.SURE,cancelBtnText=CommonStr.CANCEL,buildingPos=pos
                })
            end
        end
    end
end

--发送取消训练请求
--返回值(无)
function Build_menuView:sendCancelTrainReq()
    MakeSoldierService:cancelTrainReq(self:getBuildingPos())
end

--发送取消建造陷井请求
--返回值(无)
function Build_menuView:sendCancelMakeTrapReq()
    FortressService:cancelMakeTrapReq(self:getBuildingPos())
end

--发送取消拆除建筑请求
--返回值(无)
function Build_menuView:sendCancelRemoveBuildingReq()
    local pos = self:getBuildingPos()
    CityBuildingService:sendCancelRemoveReq(pos)
end

--发送取消升级建筑请求
--返回值(无)
function Build_menuView:sendCancelUpLvBuildingReq()
    local pos = self:getBuildingPos()
    CityBuildingService:cancelUpBuildingReq(pos)
end

--发送收集请求
--返回值(无)
function Build_menuView:sendCollectingResourcesReq()
    local pos = self:getBuildingPos()
    CityBuildingService:sendCollectingResourcesReq(pos)
end

--训练按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function Build_menuView:trainCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        UIMgr:getInstance():openUI(UITYPE.TRAINING_CITY, {building=self.data.building})
        UIMgr:getInstance():closeUI(self.uiType)
    end
end

--城堡增益按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function Build_menuView:castleAddCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        UIMgr:getInstance():openUI(UITYPE.GAIN, {building=self.data.building})
        UIMgr:getInstance():closeUI(self.uiType)
    end
end

--城堡信息按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function Build_menuView:castleCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        UIMgr:getInstance():openUI(UITYPE.CASTLE_INFORMATION, {building=self.data.building})
        UIMgr:getInstance():closeUI(self.uiType)
    end
end

--更新生产资源加速UI
--返回值(无)
function Build_menuView:updateProcduResSpeed()

end

--英雄治疗按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function Build_menuView:heroTreatmentCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        UIMgr:getInstance():openUI(UITYPE.TREATMENT, {building=self.data.building,accTreatmentType=TreatmentType.HERO_THERAPY})
        UIMgr:getInstance():closeUI(self.uiType)
    end
end

--士兵治疗按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function Build_menuView:soldierTreatmentCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        UIMgr:getInstance():openUI(UITYPE.TREATMENT, {building=self.data.building,accTreatmentType=TreatmentType.SOLDIER_TREATMENT})
        UIMgr:getInstance():closeUI(self.uiType)
    end
end

--取消治疗回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function Build_menuView:cancelTreatmentCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        UIMgr:getInstance():openUI(UITYPE.PROP_BOX, {type=PROP_BOX_TYPE.COMMON,text=CommonStr.SURE_RETURN_HALF_RESOURCE,
        callback=handler(self, self.cancelTreatmentReq),sureBtnText=CommonStr.SURE,cancelBtnText=CommonStr.CANCEL,buildingPos=pos
        })
    end
end

--发送取消治疗请求
--返回值(无)
function Build_menuView:cancelTreatmentReq()
    TreatmentService:cancelTreatmentSeq(self:getBuildingPos())
end

--加速治疗回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function Build_menuView:accelerationTreatmentCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        UIMgr:getInstance():openUI(UITYPE.BUILDING_ACCELERATION,{pos=self:getBuildingPos(),building=self.data.building,accSpeedType=AccelerationType.treatment_gold})
        UIMgr:getInstance():closeUI(self.uiType)
    end
end