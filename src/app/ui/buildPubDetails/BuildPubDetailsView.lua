
--[[
    hejun
    酒吧详情界面
--]]

BuildPubDetailsView = class("BuildPubDetailsView",UIBaseView)

--构造
--uiType UI类型
--data 数据
--返回值(无)
function BuildPubDetailsView:ctor(uiType,data)
    self.data = data
    self.super.ctor(self,uiType)
    self:adapterSize()
end

--初始化
--返回值(无)
function BuildPubDetailsView:init()
    self.root = Common:loadUIJson(BUILDE_DETAILS_HEAD)
    self:addChild(self.root)
    --self.root:setTouchEnabled(true)

    --关闭按钮
    self.closeBtn = Common:seekNodeByName(self.root,"closeBtn")
    self.closeBtn:addTouchEventListener(handler(self,BuildPubDetailsView.closeCallback))

    --左侧建筑图片
    self.buildingImg = Common:seekNodeByName(self.root,"buildingimg")

    --左侧建筑名字
    self.buildingNameLab = Common:seekNodeByName(self.root,"namelab")

    --左侧建筑等级
    self.buildingLvLab = Common:seekNodeByName(self.root,"lvlab")

    --建筑描述
    self.deStrLab = Common:seekNodeByName(self.root,"qiLab")

    --效果描述
    self.condition1Lab = Common:seekNodeByName(self.root,"condition1Lab")
    self.condition2Lab = Common:seekNodeByName(self.root,"condition2Lab")
    self.condition2Lab:setVisible(true)

    --显示拆除按钮
    self.panel_2 = Common:seekNodeByName(self.root,"Panel_2")
    self.panel_3 = Common:seekNodeByName(self.root,"Panel_3")

    --拆除建筑按钮
    self.demolitionBtn = Common:seekNodeByName(self.root,"demolitionBtn")
    self.demolitionBtn:addTouchEventListener(handler(self,BuildPubDetailsView.demolitionBtnCallback))

    --更多信息按钮
    self.moreInfoBtn = Common:seekNodeByName(self.root,"infoBtn")
    self.moreInfo2Btn = Common:seekNodeByName(self.root,"info2Btn")
    self.moreInfo2Btn:addTouchEventListener(handler(self,BuildPubDetailsView.moreInfoBtnCallback))
    self.moreInfoBtn:addTouchEventListener(handler(self,BuildPubDetailsView.moreInfoBtnCallback))

    --创建更多信息列表界面
    self:createMoreInfoList()
end

--UI加到舞台后会调用这个接口
--返回值(无)
function BuildPubDetailsView:onEnter()
    UICommon:getInstance():setMapTouchAable(false)

    --建筑描述
    local buildingPos = self:getBuildingPos()
    local buildingType = CityBuildingModel:getInstance():getBuildType(buildingPos)
    local detailsTypeInfo = BuildingTypeConfig:getInstance():getConfigInfo(buildingType)
    self.deStrLab:setString(detailsTypeInfo.bt_detaileddescription)

    --显示城外建筑详情按钮
    if detailsTypeInfo.bt_position == 2 then
        self.panel_2:setVisible(false)
        self.panel_3:setVisible(true)
    end

    --判断建筑是否在拆除中
    local buildingState = CityBuildingModel:getInstance():getBuildingState(buildingPos)
    if BuildingState.removeBuilding == buildingState  or BuildingState.uplving == buildingState then
        self.panel_2:setVisible(true)
        self.panel_3:setVisible(false)
    end

    --建筑图片
    local buildingInfo = CityBuildingModel:getInstance():getBuildInfo(buildingPos)
    if buildingInfo == nil then
        buildingInfo = {}
        buildingInfo.level = 1
    end
    self.buildingLvLab:setString(CommonStr.GRADE .. " " .. buildingInfo.level)

    local builingUpInfo = BuildingUpLvConfig:getInstance():getConfigInfo(buildingType,buildingInfo.level)
    local resPath = BuildingUpLvConfig:getBuildingResPath2(buildingType,buildingInfo.level)
    self.buildingImg:loadTexture(resPath,ccui.TextureResType.plistType)

     --建筑名字
    local buildingName = BuildingTypeConfig:getInstance():getBuildingNameByType(buildingType)
    self.buildingNameLab:setString(buildingName)

    --资源描述
    if buildingInfo ~= nil then
        local buildingPos = self:getBuildingPos()
        local lv = CityBuildingModel:getInstance():getBuildingLv(buildingPos)
        local pubInfo = PubEffectConfig:getInstance():getPubEffectByLv(lv)
        if pubInfo ~= nil then
            self.condition1Lab:setString(CommonStr.RECRUIT_REFRESH ..  "      -" .. pubInfo.pe_resource_reducetime)
            self.condition2Lab:setString(CommonStr.JUXIAN_REFRESH ..  "      -" .. pubInfo.pe_gold_reducetime)
        end
    end
end

--获取总伤兵容量
--返回值()
function BuildPubDetailsView:getAllCapacity()
    local buildingPos = self:getBuildingPos()
    local buildingType = CityBuildingModel:getInstance():getBuildType(buildingPos)
    local num = 0
    local arr = CityBuildingModel:getInstance():getBuildListByType(buildingType)
    for k,v in pairs(arr) do
        num = AidEffectConfig:getInstance():getConfigInfo(v.level).ae_capacity + num
    end
    return num
end

--获取总治疗速度
--返回值()
function BuildPubDetailsView:getAllTurbo()
    local buildingPos = self:getBuildingPos()
    local buildingType = CityBuildingModel:getInstance():getBuildType(buildingPos)
    local num = 0
    local arr = CityBuildingModel:getInstance():getBuildListByType(buildingType)
    for k,v in pairs(arr) do
        num = AidEffectConfig:getInstance():getConfigInfo(v.level).ae_turbo + num
    end
    return num
end

--获取建筑物位置
--返回值(建筑位置)
function BuildPubDetailsView:getBuildingPos()
    return self.data.building:getTag()
end

--更多信息按钮回调
--sender 登录按钮本身
--eventType 事件类型
--返回值(无)
function BuildPubDetailsView:moreInfoBtnCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self.moreInfoBg:setVisible(true)
        self:setSomeImgVisible(false)
    end
end

--拆除按钮回调
--eventType 事件类型
--返回值(无)
function BuildPubDetailsView:demolitionBtnCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        local buildingPos = self:getBuildingPos()
        local buildingInfo = CityBuildingModel:getInstance():getBuildInfo(buildingPos)
        local buildingType = CityBuildingModel:getInstance():getBuildType(buildingPos)
        local builingUpInfo = BuildingUpLvConfig:getInstance():getConfigInfo(buildingType,buildingInfo.level)
        local removeTime = math.ceil(builingUpInfo.bu_time)

        UIMgr:getInstance():openUI(UITYPE.PROP_BOX, {type=PROP_BOX_TYPE.REMOVE_BUILDING,text=CommonStr.SURE_REMOVE_BUILDING,
                callback=handler(self, self.sendRemoveReq),time=removeTime,buildingPos=self:getBuildingPos()})
    end
end

--发送移除建筑请求
--返回值(无)
function BuildPubDetailsView:sendRemoveReq()
    CityBuildingService:removeBuildingReq(self:getBuildingPos())
end

--显示城外建筑详情按钮
--返回值(无)
function BuildPubDetailsView:displayRemovalButton()
    self.moreInfoBtn:setVisible(false)
    self.moreInfo2Btn:setVisible(true)
    self.demolitionBtn:setVisible(true)
end

--隐藏/显示一些图片
--visible(true:显示,false:否)
--返回值(无)
function BuildPubDetailsView:setSomeImgVisible(visible)
    self.closeBtn:setVisible(visible)
    self.moreInfoBtn:setVisible(visible)
end

--创建更多信息列表
--返回值(无)
function BuildPubDetailsView:createMoreInfoList()
    --背景图片
    self.moreInfoBg = display.newSprite("ui/build_details/BG1.jpg")
    self:addChild(self.moreInfoBg, 100)
    self.moreInfoBg:setVisible(false)
    self.moreInfoBg:setAnchorPoint(0,0)
    self.moreInfoBg:setPosition(0, 0)
    local size = self.moreInfoBg:getContentSize()

    --标题栏底
    local titleBg = display.newSprite("ui/build_details/di.png")
    self.moreInfoBg:addChild(titleBg)
    titleBg:setPosition(375, 1285)

    --关闭按钮
    local closeBtn = cc.ui.UIPushButton.new("ui/build_details/btn_close.png")
    self.moreInfoBg:addChild(closeBtn)
    closeBtn:setPosition(50, size.height-50)
    closeBtn:onButtonClicked(function(event)
        self.moreInfoBg:setVisible(false)
        self:setSomeImgVisible(true)
    end)

    local buildingPos = self:getBuildingPos()
    local buildingType = CityBuildingModel:getInstance():getBuildType(buildingPos)
    local buildingLv = CityBuildingModel:getInstance():getBuildingLv(buildingPos)
    --建造中等级空硬设
    if buildingLv == nil then
        buildingLv = 1
    end
    local detailsTypeInfo = BuildingTypeConfig:getInstance():getConfigInfo(buildingType)

    local rowBgImg = display.newSprite("ui/build_details/bg.png")
    local rowBgSize = rowBgImg:getContentSize()
    local rowBgSize1 = titleBg:getContentSize()

    --更多信息标题
    local titleLab = display.newTTFLabel({
        text = "",
        font = "Arial",
        size = 28,
        color = cc.c3b(255, 255, 255),
        align = cc.TEXT_ALIGNMENT_LEFT,
    })
    titleBg:addChild(titleLab)
    titleLab:setPosition(rowBgSize1.width/2,50)
    local name = BuildingTypeConfig:getInstance():getBuildingNameByType(buildingType)
    titleLab:setString(name .. " " .. CommonStr.GRADE .. buildingLv)


    self.listView = cc.ui.UIListView.new {
        bgColor = cc.c4b(200, 200, 200, 0),
        viewRect = cc.rect(0, -28, size.width, size.height-28),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
    }
    self.moreInfoBg:addChild(self.listView)

    --建筑描述
    local desLayer = display.newCutomColorLayer(cc.c4b(0,255,0,0),size.width,90)
    desLayer:setContentSize(size.width, 90)
    local item = self.listView:newItem()
    item:setItemSize(size.width, 90)
    item:addContent(desLayer)
    self.listView:addItem(item)

    --资源说明
    local explainLayer = display.newCutomColorLayer(cc.c4b(0,255,255,0),rowBgSize.width,rowBgSize.height)
    explainLayer:setAnchorPoint(0,0)
    explainLayer:setContentSize(rowBgSize.width, rowBgSize.height)

    local item = self.listView:newItem()
    item:setItemSize(rowBgSize.width, rowBgSize.height)
    item:addContent(explainLayer)
    self.listView:addItem(item)

    local explainImg = display.newSprite("ui/build_details/bg2.png")
    explainImg:setAnchorPoint(0,0)
    explainImg:setPosition(-1, -2)
    explainLayer:addChild(explainImg)
    explainImg:setContentSize(rowBgSize.width,rowBgSize.height)

    local explainLab = display.newTTFLabel({
        text = "",
        font = "Arial",
        size = 28,
        color = cc.c3b(255, 255, 0),
        align = cc.TEXT_ALIGNMENT_LEFT,
    })
    explainImg:addChild(explainLab)
    explainLab:setPosition(80,20)
    explainLab:setString(detailsTypeInfo.bt_detaileddescription)

    --标题
    local titleLayer = display.newCutomColorLayer(cc.c4b(0,255,255,0),rowBgSize.width,rowBgSize.height)
    titleLayer:setAnchorPoint(0,0)
    titleLayer:setContentSize(rowBgSize.width, rowBgSize.height)

    local item = self.listView:newItem()
    item:setItemSize(rowBgSize.width, rowBgSize.height)
    item:addContent(titleLayer)
    self.listView:addItem(item)

    local titleImg = display.newSprite("ui/build_details/bg.png")
    titleImg:setAnchorPoint(0,0)
    titleImg:setPosition(-1, -2)
    titleLayer:addChild(titleImg)
    titleImg:setContentSize(rowBgSize.width,rowBgSize.height)

    local title2Lab = display.newTTFLabel({
        text = "",
        font = "Arial",
        size = 28,
        color = cc.c3b(0, 0, 0),
        align = cc.TEXT_ALIGNMENT_LEFT,
    })
    titleImg:addChild(title2Lab)
    title2Lab:setPosition(rowBgSize.width/2,20)
    local descrp = BuildingTypeConfig:getInstance():getBuildingDesByType(buildingType)
    title2Lab:setString(descrp)

    --字段名
    local fontNameLayer = display.newCutomColorLayer(cc.c4b(0,255,255,0),rowBgSize.width,rowBgSize.height)
    fontNameLayer:setAnchorPoint(0,0)
    fontNameLayer:setContentSize(rowBgSize.width, rowBgSize.height)

    local item = self.listView:newItem()
    item:setItemSize(rowBgSize.width, rowBgSize.height)
    item:addContent(fontNameLayer)
    self.listView:addItem(item)

    local fontBgImg = display.newSprite("ui/build_details/bg2.png")
    fontBgImg:setAnchorPoint(0,0)
    fontBgImg:setPosition(-1, -2)
    fontNameLayer:addChild(fontBgImg)
    fontBgImg:setContentSize(rowBgSize.width,rowBgSize.height)

    local pos1 = cc.p(50,18)
    local lvLab = display.newTTFLabel({
        text = CommonStr.GRADE,
        font = "Arial",
        size = 24,
        color = cc.c3b(255, 0, 0),
        align = cc.TEXT_ALIGNMENT_LEFT,
    })
    fontBgImg:addChild(lvLab)
    lvLab:setAnchorPoint(0.5,0.5)
    lvLab:setPosition(pos1)

    local pos2 = cc.p(230,18)
    local effectLab = display.newTTFLabel({
        text = CommonStr.RECRUIT_REFRESH,
        font = "Arial",
        size = 24,
        color = cc.c3b(255, 0, 0),
        align = cc.TEXT_ALIGNMENT_LEFT,
    })
    fontBgImg:addChild(effectLab)
    effectLab:setAnchorPoint(0.5,0.5)
    effectLab:setPosition(pos2)

    local pos3 = cc.p(440,18)
    local battleLab = display.newTTFLabel({
        text = CommonStr.JUXIAN_REFRESH,
        font = "Arial",
        size = 24,
        color = cc.c3b(255, 0, 0),
        align = cc.TEXT_ALIGNMENT_LEFT,
    })
    fontBgImg:addChild(battleLab)
    battleLab:setAnchorPoint(0.5,0.5)
    battleLab:setPosition(pos3)

    local pos4 = cc.p(580,18)
    local battleLab = display.newTTFLabel({
        text = CommonStr.BATTLE,
        font = "Arial",
        size = 24,
        color = cc.c3b(255, 0, 0),
        align = cc.TEXT_ALIGNMENT_LEFT,
    })
    fontBgImg:addChild(battleLab)
    battleLab:setAnchorPoint(0,0.5)
    battleLab:setPosition(pos4)

    local detailsInfoList = PubEffectConfig:getInstance():getTrainConfigInfo(buildingType)
    for i=1,#detailsInfoList do
        local item = self.listView:newItem()
        local content = display.newCutomColorLayer(cc.c4b(0,255,255,0),rowBgSize.width,rowBgSize.height)
        content:setContentSize(rowBgSize.width,rowBgSize.height)
        item:addContent(content)
        item:setItemSize(rowBgSize.width, rowBgSize.height)
        self.listView:addItem(item)

        local bgPath = ""
        if math.mod(i,2) ~= 0 then
            bgPath = "ui/build_details/bg.png"
        else
            bgPath = "ui/build_details/bg2.png"
        end

        if detailsInfoList[i].pe_level == buildingLv then
            bgPath = "ui/build_details/bg2.jpg"
        end

        local rowBgImg = display.newSprite(bgPath)
        rowBgImg:setAnchorPoint(0,0)
        rowBgImg:setPosition(-1, -2)
        content:addChild(rowBgImg)
        rowBgImg:setContentSize(rowBgSize.width,rowBgSize.height)

        local lvLab = display.newTTFLabel({
            text = "" .. detailsInfoList[i].pe_level,
            font = "Arial",
            size = 24,
            color = cc.c3b(255, 0, 0),
            align = cc.TEXT_ALIGNMENT_LEFT,
        })
        rowBgImg:addChild(lvLab)
        lvLab:setAnchorPoint(0.5,0.5)
        lvLab:setPosition(pos1.x,pos1.y)

        local turboLab = display.newTTFLabel({
            text = "-" .. detailsInfoList[i].pe_resource_reducetime,
            font = "Arial",
            size = 24,
            color = cc.c3b(255, 0, 0),
            align = cc.TEXT_ALIGNMENT_LEFT,
        })
        rowBgImg:addChild(turboLab)
        turboLab:setAnchorPoint(0,0.5)
        turboLab:setPosition(pos2.x-30,pos2.y)

        local capacityLab = display.newTTFLabel({
            text = "-" .. detailsInfoList[i].pe_gold_reducetime,
            font = "Arial",
            size = 24,
            color = cc.c3b(255, 0, 0),
            align = cc.TEXT_ALIGNMENT_LEFT,
        })
        rowBgImg:addChild(capacityLab)
        capacityLab:setAnchorPoint(0,0.5)
        capacityLab:setPosition(pos3.x-30,pos3.y)

        local fightLab = display.newTTFLabel({
            text = "" .. detailsInfoList[i].bu_fightforce,
            font = "Arial",
            size = 24,
            color = cc.c3b(255, 0, 0),
            align = cc.TEXT_ALIGNMENT_LEFT,
        })
        rowBgImg:addChild(fightLab)
        fightLab:setAnchorPoint(0.5,0.5)
        fightLab:setPosition(pos4.x+30,pos4.y)
    end
    self.listView:reload()
end

--UI离开舞台后会调用这个接口
--返回值(无)
function BuildPubDetailsView:onExit()
    UICommon:getInstance():setMapTouchAable(true)
end

--析构函数(此时已经从内存中释放掉资源了)
--返回值(无)
function BuildPubDetailsView:onDestroy()
    --MyLog("BuildPubDetailsView:onDestroy")
end

--关闭按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function BuildPubDetailsView:closeCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        MyLog("close click...")
        UIMgr:getInstance():openUI(UITYPE.BUILDING_MENU, {building=self.data.building})
        UIMgr:getInstance():closeUI(self.uiType)
    end
end