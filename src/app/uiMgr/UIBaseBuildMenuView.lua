
--[[
    jinyan.zhang
    建筑菜单界面
--]]

UIBaseBuildMenuView = class("UIBaseBuildMenuView",function()
	return display.newLayer()
end)

--构造
--uiType UI类型
--data 数据
--返回值(无)
function UIBaseBuildMenuView:ctor(uiType,data)
    self.baseView = BaseView.new(self,uiType,data)
    self.baseView.menu = self
    if data ~= nil then
        self.pos = data.building:getTag()
        self.building = data.building
    end
end

--初始化
--返回值(无)
function UIBaseBuildMenuView:init()
    self.root = Common:loadUIJson(BUILDING_MENU)
    self:addChild(self.root)
    --关闭按钮
    self.closeBtn = Common:seekNodeByName(self.root,"backbtn")
    self.closeBtn:addTouchEventListener(handler(self,self.onClose))
    --左侧建筑图片
    self.buildingImg = Common:seekNodeByName(self.root,"buildingimg")
    --左侧建筑名字
    self.buildingNameLab = Common:seekNodeByName(self.root,"buildingnameLab")
    --左侧建筑等级
    self.buildingLvLab = Common:seekNodeByName(self.root,"lvlab")
    --描述
    self.descrpLab = Common:seekNodeByName(self.root,"descrplab")
    --详情按钮
    self.btn_first = Common:seekNodeByName(self.root,"detailbtn")
    --升级按钮
    self.btn_second = Common:seekNodeByName(self.root,"uplvbtn")
    --出征或者是征兵按钮，取决于选中的建筑类型
    self.btn_third = Common:seekNodeByName(self.root,"btn")
    --加速按钮
    self.btn_four = Common:seekNodeByName(self.root,"fourBtn")
end

--UI加到舞台后会调用这个接口
--返回值(无)
function UIBaseBuildMenuView:onEnter()
end

-- 设置建筑基础信息
function UIBaseBuildMenuView:setBuildBaseData()
    -- 建筑类型
    local buildingType = CityBuildingModel:getInstance():getBuildType(self.pos)
    -- 建筑类型配置表
    local info = BuildingTypeConfig:getInstance():getConfigInfo(buildingType)
    --建筑名字
    self.buildingNameLab:setString(info.bt_name)
    --建筑描述
    self.descrpLab:setString(info.bt_description)
    --建筑等级
    local buildingInfo = CityBuildingModel:getInstance():getBuildInfo(self.pos)
    if buildingInfo == nil then
        buildingInfo = {}
        buildingInfo.level = 1
    end
    self.buildingLvLab:setString(CommonStr.GRADE .. " " .. buildingInfo.level)
    --建筑图片
    local builingUpInfo = BuildingUpLvConfig:getInstance():getConfigInfo(buildingType,buildingInfo.level)
    local resPath = BuildingUpLvConfig:getBuildingResPath2(buildingType,buildingInfo.level)
    self.buildingImg:loadTexture(resPath,ccui.TextureResType.plistType)
    -- 建筑状态（升级中之类的）
    local buildingState = CityBuildingModel:getInstance():getBuildingState(self.pos)
    if BuildingState.uplving == buildingState then --升级中
        self.btn_second:setTitleText("取消升级")
        self.btn_third:setTitleText("建筑加速")
        self.btn_second:setVisible(true)
        self.btn_third:setVisible(true)
        self.btn_four:setVisible(false)
        self.btn_second:addTouchEventListener(handler(self,self.cancelCallback))
        self.btn_third:addTouchEventListener(handler(self,self.buildingAccelerationCallback))
    elseif BuildingState.createBuilding == buildingState then  --创建建筑中
        self.btn_third:setVisible(false)
        self.btn_four:setVisible(false)
        self.btn_second:setVisible(true)
        self.btn_second:setTitleText("建筑加速")
        self.btn_second:addTouchEventListener(handler(self,self.buildingAccelerationCallback))
    end
end

--取消按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function UIBaseBuildMenuView:cancelCallback(sender,eventType)
    UIMgr:getInstance():openUI(UITYPE.PROP_BOX, {type=PROP_BOX_TYPE.COMMON,text=CommonStr.SURE_RETURN_HALF_RESOURCE,
    callback=handler(self, self.sendCancelUpLvBuildingReq),sureBtnText=CommonStr.SURE,cancelBtnText=CommonStr.CANCEL,buildingPos=self.pos
    })
end

--发送取消升级建筑请求
--返回值(无)
function UIBaseBuildMenuView:sendCancelUpLvBuildingReq()
    CityBuildingService:cancelUpBuildingReq(self.pos)
end

--金币加速按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function UIBaseBuildMenuView:buildingAccelerationCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        -- UIMgr:getInstance():openUI(UITYPE.BUILDING_ACCELERATION,{pos=self.pos,building=self.building,accSpeedType=AccelerationType.upBuildingLv_gold})
        -- UIMgr:getInstance():closeUI(self.uiType)
        if self.speedUpView == nil then
            -- 科技界面
            self.speedUpView = AccelerationBase.new(self.uiType, self.pos)
            -- 添加到这个模块的ui组里
            self.baseView:addView(self.speedUpView)
            -- 加速建筑升级通过建筑位置
            self.speedUpView:upLevelByPos(self.pos)
            -- 添加
            self:addChild(self.speedUpView)
        end
        -- 显示界面
        self.baseView:showView(self.speedUpView)
    end
end

--关闭按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function UIBaseBuildMenuView:onClose(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        UIMgr:getInstance():closeUI(self.uiType)
    end
end

-- 显示界面
function UIBaseBuildMenuView:showView()
    self.root:setVisible(true)
end

-- 隐藏界面
function UIBaseBuildMenuView:hideView()
    self.root:setVisible(false)
end

--UI离开舞台后会调用这个接口
--返回值(无)
function UIBaseBuildMenuView:onExit()
    --MyLog("Build_menuView onExit()")
end

--析构函数(此时已经从内存中释放掉资源了)
--返回值(无)
function UIBaseBuildMenuView:onDestroy()
    --MyLog("Build_menuView:onDestroy")
end