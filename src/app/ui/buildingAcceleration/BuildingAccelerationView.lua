
--[[
    hejun
    加速建筑界面
--]]

BuildingAccelerationView = class("BuildingAccelerationView",UIBaseView)

AccelerationType = {
    upBuildingLv_gold = 1,  --使用金币加速建筑升级
    upBuildingLv_prop = 2, --使用道具加速升级
    res_gold = 3,    --使用金币进行资源加速
    res_prop = 4,    --使用道具进行资源加速
    removeBuilding_gold = 5,  --使用金币加速移除建筑
    makeSoldier_gold = 6,     --使用金币加速造兵
    treatment_gold = 7,     --使用金币加速治疗
    trap_gold = 8,          --使用金币加速制造陷井
}

--构造
--uiType UI类型
--data 数据
--返回值(无)
function BuildingAccelerationView:ctor(uiType,data)
    self.data = data
    self.super.ctor(self,uiType)
    self:adapterSize()
end

--初始化
--返回值(无)
function BuildingAccelerationView:init()
    self.root = Common:loadUIJson(ACCELERATION_BUILDING)
    self:addChild(self.root)
    self.root:setTouchEnabled(false)

    self.pan1 = Common:seekNodeByName(self.root,"Panel_1")
    self.propTitleLab = Common:seekNodeByName(self.pan1,"propTitleLab")
    self.propTitleLab:setString(CommonStr.PROP_SPEED)
    self.propDescrpLab = Common:seekNodeByName(self.pan1,"propDescrpLab")

    --关闭按钮
    self.closeBtn = Common:seekNodeByName(self.root,"closeBtn")
    self.closeBtn:addTouchEventListener(handler(self,BuildingAccelerationView.closeCallback))

    --标题
    self.titleLab = Common:seekNodeByName(self.root,"titleLab")

    --使用金币描述
    self.goldLab = Common:seekNodeByName(self.root,"goldLab")

    --金币加速按钮
    self.goldAccelerationBtn = Common:seekNodeByName(self.root,"gold_AccelerationBtn")
    --道具加速按钮
    self.propAccelerationBtn = Common:seekNodeByName(self.root,"prop_AccelerationBtn")
    self.propAccelerationBtn:addTouchEventListener(handler(self,self.propAccelerationBtnCallBack))

    if self.data.accSpeedType == AccelerationType.res_gold then  --金币加速资源产量
        self.propDescrpLab:setString(CommonStr.USE_PROP_SPEED_RES_SPEED)
        self.useGoldAcceResProduceView = UseGoldAcceResProduceView.new(self)
        self.propAccelerationBtn:setVisible(false)
        self.propDescrpLab:setVisible(false)
        self.propTitleLab:setVisible(false)
    elseif self.data.accSpeedType == AccelerationType.upBuildingLv_gold then   --金币加速建筑升级
        self.propDescrpLab:setString(CommonStr.USE_PROP_SPEED_BUILDING_SPEED)
        self.useGoldAcceBuildingUpLvView = UseGoldAcceBuildingUpLvView.new(self)
        if UsePropAcceBuildingUpLvModel:getInstance():getPropNum() == 0 then
            self.propAccelerationBtn:setVisible(false)
            self.propDescrpLab:setVisible(false)
            self.propTitleLab:setVisible(false)
        end
    elseif self.data.accSpeedType == AccelerationType.removeBuilding_gold then --金币加速建筑移除
        self.propDescrpLab:setString(CommonStr.USE_PROP_SPEED_REMOVE_SPEED)
        self.useGoldAcceRemoveBuildingView = UseGoldAcceRemoveBuildingView.new(self)
        if UsePropAcceBuildingUpLvModel:getInstance():getPropNum() == 0 then
            self.propAccelerationBtn:setVisible(false)
            self.propDescrpLab:setVisible(false)
            self.propTitleLab:setVisible(false)
        end
    elseif self.data.accSpeedType == AccelerationType.makeSoldier_gold then   --金币加速造兵
        self.propDescrpLab:setString(CommonStr.USE_PROP_SPEED_MAKESOLDIER_SPEED)
        self.useGoldMakeSoldierAcceView = UseGoldMakeSoldierAcceView.new(self)
        if UsePropAcceMakeSoldierModel:getInstance():getPropNum() == 0 then
            self.propAccelerationBtn:setVisible(false)
            self.propDescrpLab:setVisible(false)
            self.propTitleLab:setVisible(false)
        end
    elseif self.data.accSpeedType == AccelerationType.treatment_gold then   --金币加速治疗
        self.propDescrpLab:setString(CommonStr.USE_PROP_SPEED_TREAMENT_SPEED)
        self.useGoldAcceTreatmentView = UseGoldAcceTreatmentView.new(self)
        if UsePropAcceTreatmentModel:getInstance():getPropNum() == 0 then
            self.propAccelerationBtn:setVisible(false)
            self.propDescrpLab:setVisible(false)
            self.propTitleLab:setVisible(false)
        end
    elseif self.data.accSpeedType == AccelerationType.trap_gold then   --金币加速制造陷井
        self.propDescrpLab:setString(CommonStr.USE_PROP_SPEED_MAKETRAP_SPEED)
        self.useGoldAcceMakeTrapView = UseGoldAcceMakeTrapView.new(self)
        if UsePropAcceMakeTrapModel:getInstance():getPropNum() == 0 then
            self.propAccelerationBtn:setVisible(false)
            self.propDescrpLab:setVisible(false)
            self.propTitleLab:setVisible(false)
        end
    end
end

--获取建筑物位置
--返回值(建筑位置)
function BuildingAccelerationView:getBuildingPos()
    return self.data.building:getTag()
end

--UI加到舞台后会调用这个接口
--返回值(无)
function BuildingAccelerationView:onEnter()
    UICommon:getInstance():setMapTouchAable(false)
end

--UI离开舞台后会调用这个接口
--返回值(无)
function BuildingAccelerationView:onExit()
    UICommon:getInstance():setMapTouchAable(true)
    TimeMgr:getInstance():removeTypeInfoByIndex(TimeType.ACC_SPEED_UP_BUILDING_TIME,1,1)
    TimeMgr:getInstance():removeTypeInfoByIndex(TimeType.ACC_MAKE_SOLDIER,1,1)
    TimeMgr:getInstance():removeInfo(TimeType.COMMON,1)
end

--析构函数(此时已经从内存中释放掉资源了)
--返回值(无)
function BuildingAccelerationView:onDestroy()
    --构造
end

--关闭按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function BuildingAccelerationView:closeCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        MyLog("close click...")
        UIMgr:getInstance():openUI(UITYPE.BUILDING_ACCELERATION, {building=self.data.building})
        UIMgr:getInstance():closeUI(self.uiType)
    end
end

--道具加速按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function BuildingAccelerationView:propAccelerationBtnCallBack(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        if AccelerationType.upBuildingLv_gold == self.data.accSpeedType then  --使用道具加速建筑升级
            self.usePropAcceBuildingUpLvView = UsePropAcceBuildingUpLvView.new(self,UpLvPropActionType.create)
        elseif AccelerationType.removeBuilding_gold == self.data.accSpeedType then --使用道具加速移除建筑
            self.usePropAcceBuildingUpLvView = UsePropAcceBuildingUpLvView.new(self,UpLvPropActionType.remove)
        elseif AccelerationType.makeSoldier_gold == self.data.accSpeedType then  --使用道具加速造兵
           self.usePropAcceMakeSoldierView = UsePropAcceMakeSoldierView.new(self)
        elseif AccelerationType.trap_gold == self.data.accSpeedType then  --使用道具加速制造陷井
           self.usePropAcceMakeTrapView = UsePropAcceMakeTrapView.new(self)
        elseif AccelerationType.treatment_gold == self.data.accSpeedType then  --使用道具加速治疗
           self.usePropAcceTreatmentView = UsePropAcceTreatmentView.new(self)
        end
    end
end

