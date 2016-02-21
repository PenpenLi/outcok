
--[[
    jinyan.zhang
    城外领土界面
--]]

TerritoryView = class("TerritoryView",function()
	return display.newLayer()
end)

--构造
--uiType UI类型
--data 数据
--返回值(无)
function TerritoryView:ctor(uiType,data)
    self.baseView = BaseView.new(self,uiType,data)
end

--初始化
--返回值(无)
function TerritoryView:init(baseView)
    self.root = Common:loadUIJson(TERRITORY_PATH)
    self:addChild(self.root)

    --列表层
    self.panList = Common:seekNodeByName(self.root,"pan_list")
    --标题
    self.labTitle = Common:seekNodeByName(self.panList,"lab_title")
    self.labTitle:setString(Lan:lanText(174, "城外领土"))

    --关闭按钮
    self.btnClose = Common:seekNodeByName(self.panList,"btn_close")
    self.btnClose:addTouchEventListener(handler(self,self.onClose))

    --滚动列表
    self.scrollList = Common:seekNodeByName(self.panList,"scroll_pan")
    self.panContent = Common:seekNodeByName(self.scrollList,"pan_content")

    --资源标题图片
    self.imgResTitle = Common:seekNodeByName(self.panContent,"img_restitle")
    --资源标题
    self.labRestitle = Common:seekNodeByName(self.imgResTitle,"lab_title")
    self.labRestitle:setString(Lan:lanText(166, "资源建筑"))

    --农田
    self.imgFarmland = Common:seekNodeByName(self.panContent,"img_frambg")
    self.imgFarmland:addTouchEventListener(handler(self,self.onFramLand))

    --伐木场
    self.imgLogging = Common:seekNodeByName(self.panContent,"img_loggingbg")
    self.imgLogging:addTouchEventListener(handler(self,self.onLogging))

    --铁矿
    self.imgIron = Common:seekNodeByName(self.panContent,"img_ironbg")
    self.imgIron:addTouchEventListener(handler(self,self.onIron))

    --秘银
    self.imgMithril = Common:seekNodeByName(self.panContent,"img_mithril")
    self.imgMithril:addTouchEventListener(handler(self,self.onMithril))

    --金矿
    self.imgGold = Common:seekNodeByName(self.panContent,"img_goldbg")
    self.imgGold:addTouchEventListener(handler(self,self.onGold))

    --防御塔标题图片
    self.imgDefTitle = Common:seekNodeByName(self.panContent,"img_deftitle")
    --防御塔标题
    self.labRestitle = Common:seekNodeByName(self.imgDefTitle,"lab_title")
    self.labRestitle:setString(Lan:lanText(167, "防御塔"))

    --箭塔
    self.imgArrow = Common:seekNodeByName(self.panContent,"img_arrowbg")
    self.imgArrow:addTouchEventListener(handler(self,self.onArrow))

    --炮塔
    self.imgTurret = Common:seekNodeByName(self.panContent,"img_turretbg")
    self.imgTurret:addTouchEventListener(handler(self,self.onTurret))

    --魔法塔
    self.imgMagic = Common:seekNodeByName(self.root,"img_magicbg")
    self.imgMagic:addTouchEventListener(handler(self,self.onMagic))

    --守军设置标题
    self.imgArmsTitle = Common:seekNodeByName(self.panContent,"img_armstitle")
    self.imgArmsTitle:addTouchEventListener(handler(self,self.onArms))
    --守军设置标题
    self.labtitle = Common:seekNodeByName(self.imgArmsTitle,"lab_title")
    self.labtitle:setString(Lan:lanText(169, "守军设置"))

    --城墙标题图片
    self.imgWallTitle = Common:seekNodeByName(self.panContent,"img_walltitle")
    --城墙标题
    self.labWalltitle = Common:seekNodeByName(self.imgWallTitle,"lab_title")
    self.labWalltitle:setString(Lan:lanText(168, "城墙"))
end

--创建城墙列表
function TerritoryView:createWallList()
    self.arryWall = {}
    --城墙
    self.imgWall = Common:seekNodeByName(self.root,"img_wallbg")
    self.imgWall:addTouchEventListener(handler(self,self.onWall))
    --标题
    self.labTitle = Common:seekNodeByName(self.imgWall,"lab_title")
    self.labTitle:setString(Lan:lanText(170, "城墙 Lv{}",{1}))

    local beginX = self.imgWall:getPositionX()
    local beginY = self.imgWall:getPositionY()
    local newWall = nil
    local data = OutBuildingData:getInstance():getWallList()
    local wallCount = #data
    local count = math.ceil(wallCount/2)
    local index = 1
    for i=1,count do
        local info = data[index]
        local y = beginY-(i-1)*(self.imgWall:getBoundingBox().height+50)
        local wall = self.imgWall:clone()
        wall:addTouchEventListener(handler(self,self.onWall))
        self.panContent:addChild(wall)
        wall:setPosition(beginX,y)
        newWall = wall
        local labTitle = Common:seekNodeByName(wall,"lab_title")
        labTitle:setString(Lan:lanText(170, "城墙 Lv{}",{info.level}))
        wall:setTag(index)
        index = index + 1
        local wallImgInfo = {}
        wallImgInfo.img = wall
        wallImgInfo.level = info.level
        wallImgInfo.id = info.id
        wallImgInfo.tag = wall:getTag()
        table.insert(self.arryWall,wallImgInfo)

        if index >= wallCount then
            break
        end

        local info = data[index]
        local wall = self.imgWall:clone()
        self.panContent:addChild(wall)
        wall:setPosition(beginX+self.imgWall:getBoundingBox().width+50,y)
        wall:addTouchEventListener(handler(self,self.onWall))
        local labTitle = Common:seekNodeByName(wall,"lab_title")
        labTitle:setString(Lan:lanText(170, "城墙 Lv{}",{info.level}))
        wall:setTag(index)
        index = index + 1
        local wallImgInfo = {}
        wallImgInfo.img = wall
        wallImgInfo.level = info.level
        wallImgInfo.id = info.id
        wallImgInfo.tag = wall:getTag()
        table.insert(self.arryWall,wallImgInfo)
    end
    self.imgWall:setVisible(false)

    if newWall ~= nil then
        self:adjustSize(newWall:getPositionY()-newWall:getBoundingBox().height/2)
    else
        self:adjustSize(self.imgArmsTitle:getPositionY()-self.imgArmsTitle:getBoundingBox().height)
    end
end

--调整滚动列表大小
function TerritoryView:adjustSize(endY)
    MMUIAdjustScrollView:setScrollView(self.scrollList)
    MMUIAdjustScrollView:setContentLayer(self.panContent)
    MMUIAdjustScrollView:setEndY(endY)
    MMUIAdjustScrollView:adjustHigh()
end

--农田按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function TerritoryView:onFramLand(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self.baseView:showView(self.resBuildingMenu)
        local level = OutBuildingData:getInstance():getLevelByType(BuildType.out_farmland)
        self.resBuildingMenu:updateUI(BuildType.out_farmland,level,176,1)
        self.resBuildingMenu:setDetailsTitle(Lan:lanText(189, "大型农田"))
    end
end

--伐木场按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function TerritoryView:onLogging(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self.baseView:showView(self.resBuildingMenu)
        local level = OutBuildingData:getInstance():getLevelByType(BuildType.out_logging)
        self.resBuildingMenu:updateUI(BuildType.out_logging,level,177,2)
        self.resBuildingMenu:setDetailsTitle(Lan:lanText(190, "大型伐木场"))
    end
end

--铁矿
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function TerritoryView:onIron(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self.baseView:showView(self.resBuildingMenu)
        local level = OutBuildingData:getInstance():getLevelByType(BuildType.out_iron)
        self.resBuildingMenu:updateUI(BuildType.out_iron,level,178,3)
        self.resBuildingMenu:setDetailsTitle(Lan:lanText(191, "大型铁矿场"))
    end
end

--秘银
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function TerritoryView:onMithril(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self.baseView:showView(self.resBuildingMenu)
        local level = OutBuildingData:getInstance():getLevelByType(BuildType.out_mithril)
        self.resBuildingMenu:updateUI(BuildType.out_mithril,level,179,4)
        self.resBuildingMenu:setDetailsTitle(Lan:lanText(192, "大型秘银场"))
    end
end

--金矿
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function TerritoryView:onGold(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self.baseView:showView(self.resBuildingMenu)
        local level = OutBuildingData:getInstance():getLevelByType(BuildType.out_goldoreField)
        self.resBuildingMenu:updateUI(BuildType.out_goldoreField,level,180,5)
        self.resBuildingMenu:setDetailsTitle(Lan:lanText(193, "大型金矿场"))
    end
end

--箭塔
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function TerritoryView:onArrow(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self.baseView:showView(self.towerMenu)
        local level = OutBuildingData:getInstance():getLevelByType(BuildType.out_arrowTower)
        self.towerMenu:updateUI(BuildType.out_arrowTower,level,181,1)
        self.towerMenu:setDetailsTitle(Lan:lanText(194, "箭塔"))
    end
end

--炮塔
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function TerritoryView:onTurret(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self.baseView:showView(self.towerMenu)
        local level = OutBuildingData:getInstance():getLevelByType(BuildType.out_turretTower)
        self.towerMenu:updateUI(BuildType.out_turretTower,level,182,2)
        self.towerMenu:setDetailsTitle(Lan:lanText(195, "炮塔"))
    end
end

--魔法塔
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function TerritoryView:onMagic(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self.baseView:showView(self.towerMenu)
        local level = OutBuildingData:getInstance():getLevelByType(BuildType.out_magicTower)
        self.towerMenu:updateUI(BuildType.out_magicTower,level,183,3)
        self.towerMenu:setDetailsTitle(Lan:lanText(196, "魔法塔"))
    end
end

--获取城墙图片信息根据tag
function TerritoryView:getWallImgInfoByTag(tag)
    for k,v in pairs(self.arryWall) do
        if v.tag == tag then
            return v
        end
    end
end

--城墙
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function TerritoryView:onWall(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self.baseView:showView(self.wallMenu)
        local info = self:getWallImgInfoByTag(sender:getTag())
        local arry = OutBuildingData:getInstance():getWallListByLevel(info.level,info.id)
        self.wallMenu:updateUI(BuildType.out_wall,info.level,clone(arry))
        self.wallMenu:setDetailsTitle(Lan:lanText(168, "城墙"))
    end
end

--守军设置
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function TerritoryView:onArms(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self.baseView:showView(self.territoryDefView)
    end
end

--关闭按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function TerritoryView:onClose(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        UIMgr:getInstance():closeUI(self.uiType)
    end
end

-- 显示界面
function TerritoryView:showView()
    self.panList:setVisible(true)
end

-- 隐藏界面
function TerritoryView:hideView()
    self.panList:setVisible(false)
end

--UI加到舞台后会调用这个接口
--返回值(无)
function TerritoryView:onEnter()
    --资源田菜单
    self.resBuildingMenu = TerritoryResBuildingMenu.new(self.uiType,self)
    self:addChild(self.resBuildingMenu)
    self.baseView:addView(self.resBuildingMenu)

    --防御塔菜单
    self.towerMenu = TerritoryTowerMenu.new(self.uiType,self)
    self:addChild(self.towerMenu)
    self.baseView:addView(self.towerMenu)

    --城墙菜单
    self.wallMenu = TerritoryWallMenu.new(self.uiType,self)
    self:addChild(self.wallMenu)
    self.baseView:addView(self.wallMenu)

    --设置守军界面
    self.territoryDefView = TerritoryDefView.new(self)
    self:addChild(self.territoryDefView)
    self.baseView:addView(self.territoryDefView)

    self:createWallList()

    self:updateUI()
end

--UI离开舞台后会调用这个接口
--返回值(无)
function TerritoryView:onExit()
    --MyLog("Build_menuView onExit()")
end

--更新UI
function TerritoryView:updateUI()
    --农田
    local level = OutBuildingData:getInstance():getLevelByType(BuildType.out_farmland)
    self.labTitle = Common:seekNodeByName(self.imgFarmland,"lab_title")
    self.labTitle:setString(Lan:lanText(157, "农田 Lv{}",{level}))

    --伐木场
    local level = OutBuildingData:getInstance():getLevelByType(BuildType.out_logging)
    self.labTitle = Common:seekNodeByName(self.imgLogging,"lab_title")
    self.labTitle:setString(Lan:lanText(158, "伐木场 Lv{}",{level}))

    --铁矿
    local level = OutBuildingData:getInstance():getLevelByType(BuildType.out_iron)
    self.labTitle = Common:seekNodeByName(self.imgIron,"lab_title")
    self.labTitle:setString(Lan:lanText(159, "铁矿 Lv{}",{level}))

    --秘银
    local level = OutBuildingData:getInstance():getLevelByType(BuildType.out_mithril)
    self.labTitle = Common:seekNodeByName(self.imgMithril,"lab_title")
    self.labTitle:setString(Lan:lanText(160, "秘银 Lv{}",{level}))

    --金矿
    local level = OutBuildingData:getInstance():getLevelByType(BuildType.out_goldoreField)
    self.labTitle = Common:seekNodeByName(self.imgGold,"lab_title")
    self.labTitle:setString(Lan:lanText(161, "金矿 Lv{}",{level}))

    --箭塔
    local level = OutBuildingData:getInstance():getLevelByType(BuildType.out_arrowTower)
    self.labTitle = Common:seekNodeByName(self.imgArrow,"lab_title")
    self.labTitle:setString(Lan:lanText(162, "箭塔 Lv{}",{level}))

    --炮塔
    local level = OutBuildingData:getInstance():getLevelByType(BuildType.out_turretTower)
    self.labTitle = Common:seekNodeByName(self.imgTurret,"lab_title")
    self.labTitle:setString(Lan:lanText(163, "炮塔 Lv{}",{level}))

    --魔法塔
    local level = OutBuildingData:getInstance():getLevelByType(BuildType.out_magicTower)
    self.labTitle = Common:seekNodeByName(self.imgMagic,"lab_title")
    self.labTitle:setString(Lan:lanText(164, "魔法塔 Lv{}",{level}))

    --更新城墙列表
    self:updateWallList()
end

--更新城墙列表
function TerritoryView:updateWallList()
    local data = OutBuildingData:getInstance():getWallList()
    for i=1,#self.arryWall do
        local info = data[i]
        if info == nil then
            return
        end

        local wall = self.arryWall[i].img
        local labTitle = Common:seekNodeByName(wall,"lab_title")
        labTitle:setString(Lan:lanText(170, "城墙 Lv{}",{info.level}))
        self.arryWall[i].level = info.level
    end
end

