
--[[
    jinyan.zhang
    使用金币加速建筑升级
--]]

UseGoldAcceBuildingUpLvView = class("UseGoldAcceBuildingUpLvView")

--构造
--parent 父结点UI
function UseGoldAcceBuildingUpLvView:ctor(parent)
	self.parent = parent
	self:init()
end

--初始化
function UseGoldAcceBuildingUpLvView:init()
    self.parent.titleLab:setString(CommonStr.BUILD_SPEED)
	self.parent.goldAccelerationBtn:addTouchEventListener(handler(self,self.useGoldAccelerationBtnCallback))
    local pos = self.parent:getBuildingPos()
    local leftTime = CityBuildingModel:getInstance():getBuildingLeftProcessTime(pos)
    if leftTime == nil or leftTime == 0 then
        self.parent.goldLab:setString(CommonStr.YOUR_CAN .. 0 .. CommonStr.GOLD_ACCELERATING_BUILDING)
        return
    end

    local buildingGold = CommonConfig:getInstance():getBuildingAccelerationCastGold(leftTime)
    self.parent.goldLab:setString(CommonStr.YOUR_CAN .. buildingGold .. CommonStr.GOLD_ACCELERATING_BUILDING)
    local timeInfo = TimeMgr:getInstance():findTypeInfoByIndex(TimeType.ACC_SPEED_UP_BUILDING_TIME,1,1)
    if not timeInfo then
        local info = {}
        info.index = 1
        info.leftTime = leftTime
        TimeMgr:getInstance():addInfo(TimeType.ACC_SPEED_UP_BUILDING_TIME, info, 1,self.updateUseGoldAcceSpeedUpLvTime, self)
    else
        timeInfo.pause = false
        timeInfo.leftTime = leftTime
    end
end

--使用金币加速按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function UseGoldAcceBuildingUpLvView:useGoldAccelerationBtnCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        local pos = self.parent:getBuildingPos()
        local leftTime = CityBuildingModel:getInstance():getBuildingLeftProcessTime(pos)
        if leftTime == nil or leftTime == 0 then
            Prop:getInstance():showMsg(CommonStr.BUILDING_NO_NEED_SPEED)
            TimeMgr:getInstance():removeTypeInfoByIndex(TimeType.ACC_SPEED_UP_BUILDING_TIME,1,1)
            return
        end

        local buildingGold = CommonConfig:getInstance():getBuildingAccelerationCastGold(leftTime)
        local title2 = CommonStr.LEFT_TIME .. Common:getFormatTime(leftTime)
        local title = CommonStr.SURECAST .. buildingGold .. CommonStr.GOLD_FINISH_BUILD
            UIMgr:getInstance():openUI(UITYPE.PROP_BOX, {type=PROP_BOX_TYPE.MONEY_ACCELERATION,text=title,timeText=title2,
                    callback=handler(self, self.sendUseGoldAccelerationUpLvBuildingReq),sureBtnText=CommonStr.YES,cancelBtnText=CommonStr.NO,buildingPos=pos
            })

        self.parent.goldLab:setString(CommonStr.YOUR_CAN .. buildingGold .. CommonStr.GOLD_ACCELERATING_BUILDING)
    end
end

--发送使用金币加速升级建筑请求
--返回值(无)
function UseGoldAcceBuildingUpLvView:sendUseGoldAccelerationUpLvBuildingReq()
    local pos = self.parent:getBuildingPos()
    local leftTime = CityBuildingModel:getInstance():getBuildingLeftProcessTime(pos)
    local castGold = CommonConfig:getInstance():getBuildingAccelerationCastGold(leftTime)
    if castGold > PlayerData:getInstance().gold then
        Prop:getInstance():showMsg(CommonStr.NO_GOLD_RIGHTNOW_UP_BUILDING)
        return
    end

    local buildingType = CityBuildingModel:getInstance():getBuildType(pos)
    local buildingState = CityBuildingModel:getInstance():getBuildingState(pos)
    if buildingState == BuildingState.createBuilding then  --创建建筑中
        BuildingAccelerationService:sendAccelerationGoldReq(pos,castGold,buildingType,AccelerationAction.RIGHT_NOW_BUILDING)
    else
        BuildingAccelerationService:sendAccelerationGoldReq(pos,castGold,buildingType,AccelerationAction.RIGHT_NOW_UP)
    end
end

--更新使用金币加速升级时间
--info 数据
--返回值(无)
function UseGoldAcceBuildingUpLvView:updateUseGoldAcceSpeedUpLvTime(info)
    info.leftTime = info.leftTime - 1
    if info.leftTime < 0 then
        info.leftTime = 0
        TimeMgr:getInstance():removeTypeInfoByIndex(TimeType.ACC_SPEED_UP_BUILDING_TIME,1,1)
        UIMgr:getInstance():closeUI(self.parent.uiType)
        UIMgr:getInstance():closeUI(UITYPE.BUILDING_MENU)
        UIMgr:getInstance():closeUI(UITYPE.PROP_BOX)
        return
    end

    local buildingGold = CommonConfig:getInstance():getBuildingAccelerationCastGold(info.leftTime)
    self.parent.goldLab:setString(CommonStr.YOUR_CAN .. buildingGold .. CommonStr.GOLD_ACCELERATING_BUILDING)
    local propCommand = UIMgr:getInstance():getUICtrlByType(UITYPE.PROP_BOX)
    if propCommand ~= nil then
        propCommand.view.title4Lab:setString(CommonStr.SURECAST .. buildingGold .. CommonStr.GOLD_FINISH_BUILD)
        propCommand.view.time4Lab:setString(CommonStr.LEFT_TIME .. Common:getFormatTime(info.leftTime))
    end
end










