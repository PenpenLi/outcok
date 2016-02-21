
--[[
    jinyan.zhang
    野外领地基类菜单
--]]

TerritoryMenuBaseView = class("TerritoryMenuBaseView",function()
	return display.newLayer()
end)

--构造
--uiType UI类型
--data 数据
--返回值(无)
function TerritoryMenuBaseView:ctor(uiType)
    self.baseView = BaseView.new(self,uiType,data)
    self:hideView()
end

--初始化
--返回值(无)
function TerritoryMenuBaseView:init()
    self.root = Common:loadUIJson(BUILDING_MENU)
    self:addChild(self.root)
    --关闭按钮
    self.btnClose = Common:seekNodeByName(self.root,"backbtn")
    self.btnClose:addTouchEventListener(handler(self,self.onClose))
    --左侧建筑图片
    self.imgBuilding = Common:seekNodeByName(self.root,"buildingimg")
    --左侧建筑名字
    self.labName = Common:seekNodeByName(self.root,"buildingnameLab")
    --左侧建筑等级
    self.labLevel = Common:seekNodeByName(self.root,"lvlab")
    --描述
    self.labDescrp = Common:seekNodeByName(self.root,"descrplab")
    --详情按钮
    self.btn_first = Common:seekNodeByName(self.root,"detailbtn")
    --升级按钮
    self.btn_second = Common:seekNodeByName(self.root,"uplvbtn")
    --放置按钮
    self.btn_third = Common:seekNodeByName(self.root,"btn")
    --加速按钮
    self.btn_four = Common:seekNodeByName(self.root,"fourBtn")
    --标题
    self.labTitle = Common:seekNodeByName(self.root,"lab_title")
    --效果描述标题
    self.labEffect = Common:seekNodeByName(self.root,"lab_effect")

    self.labName:setVisible(false)
    self.labLevel:setVisible(false)
    self.labTitle:setVisible(true)
    self.labEffect:setVisible(true)
    self.labEffect:setString(Lan:lanText(175, "当前等级建筑效果"))

    self:normal()
end

--正常
function TerritoryMenuBaseView:normal()
    self.btn_first:setTitleText(Lan:lanText(171, "详情"))
    self.btn_first:addTouchEventListener(handler(self,self.onDetails))
    self.btn_second:setTitleText(Lan:lanText(172, "升级"))
    self.btn_second:addTouchEventListener(handler(self,self.onUpLevel))
    self.btn_third:setTitleText(Lan:lanText(173, "放置"))
    self.btn_third:addTouchEventListener(handler(self,self.onPlace))
    self.btn_third:setVisible(true)
end

--升级中
function TerritoryMenuBaseView:upLevel()
    self.btn_second:setTitleText(Lan:lanText(203, "建造加速"))
    self.btn_second:addTouchEventListener(handler(self,self.onAccele))
    self.btn_third:setVisible(false)
end

--建造加速按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function TerritoryMenuBaseView:onAccele(sender,eventType)
    if eventType == ccui.TouchEventType.ended then

    end
end

--设置建筑类型
function TerritoryMenuBaseView:setBuildingType(buildingType)
    self.buildingType = buildingType
end

--设置建筑等级
function TerritoryMenuBaseView:setLevel(level)
    self.level = level
end

--设置详情标题
function TerritoryMenuBaseView:setDetailsTitle(title)
    self.detailsTitle = title
end

--获取建筑类型
function TerritoryMenuBaseView:getBuildingType()
    return self.buildingType
end

--设置建筑实例ID
function TerritoryMenuBaseView:setInstanceIds(arryId)
    self.arryId = arryId
end

--关闭按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function TerritoryMenuBaseView:onClose(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self:hideView()
    end
end

--详情按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function TerritoryMenuBaseView:onDetails(sender,eventType)
end

--升级按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function TerritoryMenuBaseView:onUpLevel(sender,eventType)
end

--放置按钮
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function TerritoryMenuBaseView:onPlace(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
       DrapBuildingMgr:getInstance():createImg(self.buildingType,self.level,self.arryId)
       UIMgr:getInstance():closeUI(self.uiType)
    end
end

--更新建筑图片
function TerritoryMenuBaseView:updateBuildingPic()
    local builingUpInfo = BuildingUpLvConfig:getInstance():getConfigInfo(self.buildingType,self.level)
    local resPath = BuildingUpLvConfig:getBuildingResPath2(self.buildingType,self.level)
    self.imgBuilding:loadTexture(resPath,ccui.TextureResType.plistType)
end

--关闭按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function TerritoryMenuBaseView:onClose(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self.labLevel:setVisible(false)
        self:getParent().baseView:showTopView()
    end
end

-- 显示界面
function TerritoryMenuBaseView:showView()
    self.root:setVisible(true)
    self.isShow = true
end

-- 隐藏界面
function TerritoryMenuBaseView:hideView()
    self.root:setVisible(false)
    self.isShow = false
end

--界面是否在显示中
function TerritoryMenuBaseView:isShowVew()
    return self.isShow
end

--UI加到舞台后会调用这个接口
--返回值(无)
function TerritoryMenuBaseView:onEnter()
end

--UI离开舞台后会调用这个接口
--返回值(无)
function TerritoryMenuBaseView:onExit()
    --MyLog("Build_menuView onExit()")
end
