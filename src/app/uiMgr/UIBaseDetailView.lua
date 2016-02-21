--
-- Author: oyhc
-- Date: 2016-01-05 11:09:18
--

UIBaseDetailView = class("UIBaseDetailView",function()
	return display.newLayer()
end)

--构造
--uiType UI类型
--data 数据
--返回值(无)
function UIBaseDetailView:ctor(uiType,data)
    self.baseView = BaseView.new(self,uiType,data)
    self.pos = data
end

--初始化
--返回值(无)
function UIBaseDetailView:init()
    self.root = Common:loadUIJson(DETAILS_PATH)
    self:addChild(self.root)

    --界面
    self.view = Common:seekNodeByName(self.root,"Panel_1")
    -- self.Panel_2 = Common:seekNodeByName(self.root,"Panel_2")
    self.detailListView = UIBaseDetailListView.new(self)
    -- self.detailListView:setData()
    --关闭按钮
    self.closeBtn = Common:seekNodeByName(self.root,"btn_close")
    self.closeBtn:addTouchEventListener(handler(self,self.closeCallback))
    --左侧建筑图片
    self.img_build = Common:seekNodeByName(self.root,"img_build")
    --左侧建筑名字
    self.lbl_name = Common:seekNodeByName(self.root,"lbl_name")
    --左侧建筑等级
    self.lbl_level = Common:seekNodeByName(self.root,"lbl_level")
    --建筑描述
    self.lbl_details = Common:seekNodeByName(self.root,"lbl_details")
    --建筑效果文本
    self.lbl_effect = Common:seekNodeByName(self.root,"lbl_effect")
    --条件详情背景
    self.bg_info = Common:seekNodeByName(self.root,"bg_info")

    --更多信息标题
    self.lbl_title = Common:seekNodeByName(self.root,"lbl_title")


    --拆除建筑按钮
    self.btn_dismantle = Common:seekNodeByName(self.root,"btn_dismantle")
    self.btn_dismantle:addTouchEventListener(handler(self,self.demolitionBtnCallback))
    --更多信息按钮
    self.btn_info = Common:seekNodeByName(self.root,"btn_info")
    self.btn_info:addTouchEventListener(handler(self,self.moreInfoBtnCallback))

end

--UI加到舞台后会调用这个接口
--返回值(无)
function UIBaseDetailView:onEnter()
end

-- 设置建筑基础信息
function UIBaseDetailView:setBuildBaseData(detailArr)
    -- 建筑类型
    self.buildingType = CityBuildingModel:getInstance():getBuildType(self.pos)
    -- 建筑信息
    self.buildInfo = BuildingTypeConfig:getInstance():getConfigInfo(self.buildingType)
    -- 建筑名字
    self.lbl_name:setString(self.buildInfo.bt_name)
    -- 建筑详情
    self.lbl_details:setString(self.buildInfo.bt_detaileddescription)
    -- 服务端下发的建筑信息
    self.buildingInfo = CityBuildingModel:getInstance():getBuildInfo(self.pos)
    if self.buildingInfo == nil then
        self.buildingInfo = {}
        self.buildingInfo.level = 1
    end
    -- 图片路径
    local resPath = BuildingUpLvConfig:getBuildingResPath2(self.buildingType,self.buildingInfo.level)
    -- 建筑图片
    self.img_build:loadTexture(resPath,ccui.TextureResType.plistType)
    -- 建筑等级
    self.lbl_level:setString(CommonStr.GRADE .. " " .. self.buildingInfo.level)

    -- 可拆除建筑
    if self.buildInfo.bt_position ~= 1 then
        if self.buildInfo.bt_position == 2 then

        end

        --判断建筑是否在拆除中
        local buildingState = CityBuildingModel:getInstance():getBuildingState(self.pos)
        if BuildingState.removeBuilding == buildingState  or BuildingState.uplving == buildingState then

        end
    end
    -- 建筑说明
    if detailArr == nil then -- 说明显示单条的情况
        self.lbl_detail = cc.ui.UILabel.new(
                {text = self.buildInfo.bt_description,
                size = 26,
                align = cc.ui.TEXT_ALIGN_LEFT,
                color = display.COLOR_WHITE})
        -- self.lbl_detail:setWidth(self.bg_info:getContentSize().width - 80)
        self.lbl_detail:setAnchorPoint(0.5,0)
        self.lbl_detail:setPosition(self.bg_info:getContentSize().width/2, self.bg_info:getContentSize().height/2)
        self.bg_info:addChild(self.lbl_detail)
    else -- 说明显示多条的情况
        -- {icon,name,value}
        for i=1,#detailArr do
            local v = detailArr[i]
            -- 图标
            local icon = display.newSprite("#"..v.icon..".png",ccui.TextureResType.plistType)
            icon:setPosition(60, self.bg_info:getContentSize().height - (50 * i))
            self.bg_info:addChild(icon)
            -- 名字
            local lbl_detail = cc.ui.UILabel.new(
                    {text = v.name,
                    size = 26,
                    align = cc.ui.TEXT_ALIGN_LEFT,
                    color = display.COLOR_WHITE})
            lbl_detail:setWidth(self.bg_info:getContentSize().width - 80)
            lbl_detail:setPosition(120, self.bg_info:getContentSize().height - (50 * i))
            self.bg_info:addChild(lbl_detail)
            -- 值
            local lbl_value = cc.ui.UILabel.new(
                    {text = v.value,
                    size = 26,
                    align = cc.ui.TEXT_ALIGN_LEFT,
                    color = display.COLOR_WHITE})
            lbl_value:setWidth(self.bg_info:getContentSize().width - 80)
            lbl_value:setPosition(350, self.bg_info:getContentSize().height - (50 * i))
            self.bg_info:addChild(lbl_value)
        end
    end
end

-- 设置仓库详情
function UIBaseDetailView:setWarehouseDetail()
    -- body
end

--拆除按钮回调
--eventType 事件类型
--返回值(无)
function UIBaseDetailView:demolitionBtnCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        local builingUpInfo = BuildingUpLvConfig:getInstance():getConfigInfo(self.buildingType,self.buildingInfo.level)
        local removeTime = math.ceil(builingUpInfo.bu_time/2)

        UIMgr:getInstance():openUI(UITYPE.PROP_BOX, {type=PROP_BOX_TYPE.REMOVE_BUILDING,text=CommonStr.SURE_REMOVE_BUILDING,
                callback=handler(self, self.sendRemoveReq),time=removeTime,buildingPos=self.pos})
    end
end

--更多信息按钮回调
--sender 登录按钮本身
--eventType 事件类型
--返回值(无)
function UIBaseDetailView:moreInfoBtnCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        -- 隐藏自己
        self:hideView()
        -- 显示
        self.detailListView:showView()
        self.detailListView:init()
    end
end

--发送移除建筑请求
--返回值(无)
function UIBaseDetailView:sendRemoveReq()
    CityBuildingService:removeBuildingReq(self.pos)
end

--关闭按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function UIBaseDetailView:closeCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        -- 显示菜单 隐藏自己
        self:getParent().baseView:showTopView()
    end
end

-- 显示界面
function UIBaseDetailView:showView()
    self.view:setVisible(true)
end

-- 隐藏界面
function UIBaseDetailView:hideView()
    self.view:setVisible(false)
end

--UI离开舞台后会调用这个接口
--返回值(无)
function UIBaseDetailView:onExit()
    --MyLog("Build_menuView onExit()")
end

--析构函数(此时已经从内存中释放掉资源了)
--返回值(无)
function UIBaseDetailView:onDestroy()
    --MyLog("Build_menuView:onDestroy")
end