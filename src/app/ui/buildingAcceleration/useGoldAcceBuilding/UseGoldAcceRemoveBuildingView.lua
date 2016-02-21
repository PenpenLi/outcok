
--[[
    jinyan.zhang
    使用金币加速移除建筑
--]]

UseGoldAcceRemoveBuildingView = class("UseGoldAcceRemoveBuildingView")

--构造
--parent 父结点UI
function UseGoldAcceRemoveBuildingView:ctor(parent)
	self.parent = parent
	self:init()
end

--初始化
function UseGoldAcceRemoveBuildingView:init()
    self.parent.titleLab:setString(CommonStr.REMOVE_BUILDING_SPEED)
    local pos = self.parent:getBuildingPos()
    self.parent.goldAccelerationBtn:addTouchEventListener(handler(self,self.useGoldAccelerationRemoveBuildingBtnCallback))
    local leftTime = CityBuildingModel:getInstance():getBuildingLeftProcessTime(pos)
    if leftTime == nil or leftTime == 0 then
        self.parent.goldLab:setString(CommonStr.YOUR_CAN .. 0 .. CommonStr.GOLD_RIGHTNOW_REMOVE_BUILDING)
        return
    end

    local castGold = CommonConfig:getInstance():getBuildingAccelerationCastGold(leftTime)
    self.parent.goldLab:setString(CommonStr.YOUR_CAN .. castGold .. CommonStr.GOLD_RIGHTNOW_REMOVE_BUILDING)
    local timeInfo = TimeMgr:getInstance():findTypeInfoByIndex(TimeType.ACC_SPEED_UP_BUILDING_TIME,1,1)
    if not timeInfo then
        local info = {}
        info.index = 1
        info.leftTime = leftTime
        TimeMgr:getInstance():addInfo(TimeType.ACC_SPEED_UP_BUILDING_TIME, info, 1,self.updateUseGoldAcceRemoveBuildingTime, self)
    else
        timeInfo.pause = false
        timeInfo.leftTime = leftTime
    end
end

--使用金币加速移除建筑回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function UseGoldAcceRemoveBuildingView:useGoldAccelerationRemoveBuildingBtnCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        local pos = self.parent:getBuildingPos()
        local leftTime = CityBuildingModel:getInstance():getBuildingLeftProcessTime(pos)
        if leftTime == nil or leftTime == 0 then
            Prop:getInstance():showMsg(CommonStr.REMOVE_NO_NEED_SPEED)
            TimeMgr:getInstance():removeTypeInfoByIndex(TimeType.ACC_SPEED_UP_BUILDING_TIME,1,1)
            return
        end

        local castGold = CommonConfig:getInstance():getBuildingAccelerationCastGold(leftTime)
        local title2 = CommonStr.LEFT_TIME .. Common:getFormatTime(leftTime)
        local title = CommonStr.SURECAST .. castGold .. CommonStr.GOLD_RIGHTNOW_REMOVE_BUILDING
            UIMgr:getInstance():openUI(UITYPE.PROP_BOX, {type=PROP_BOX_TYPE.MONEY_ACCELERATION,text=title,timeText=title2,
                    callback=handler(self, self.sendUseGoldAccelerationRemoveBuildingReq),sureBtnText=CommonStr.YES,cancelBtnText=CommonStr.NO,buildingPos=pos
            })

        self.parent.goldLab:setString(CommonStr.YOUR_CAN .. castGold .. CommonStr.GOLD_ACCELERATING_BUILDING)
    end
end

--发送使用金币加速移除建筑请求
--返回值(无)
function UseGoldAcceRemoveBuildingView:sendUseGoldAccelerationRemoveBuildingReq()
    local pos = self.parent:getBuildingPos()
    local leftTime = CityBuildingModel:getInstance():getBuildingLeftProcessTime(pos)
    local castGold = CommonConfig:getInstance():getBuildingAccelerationCastGold(leftTime)
    if castGold > PlayerData:getInstance().gold then
        Prop:getInstance():showMsg(CommonStr.NO_GOLD_RIGHTNOW_REMOVE_BUILDING)
        return
    end

    local buildingType = CityBuildingModel:getInstance():getBuildType(pos)
    BuildingAccelerationService:sendAccelerationGoldReq(pos,castGold,buildingType,AccelerationAction.RIGHT_NOW_REMOVE)
end

--更新使用金币加速移除建筑时间
--info 数据
--返回值(无)
function UseGoldAcceRemoveBuildingView:updateUseGoldAcceRemoveBuildingTime(info)
    info.leftTime = info.leftTime - 1
    if info.leftTime < 0 then
        info.leftTime = 0
        TimeMgr:getInstance():removeTypeInfoByIndex(TimeType.ACC_SPEED_UP_BUILDING_TIME,1,1)
        UIMgr:getInstance():closeUI(self.parent.uiType)
        UIMgr:getInstance():closeUI(UITYPE.BUILDING_MENU)
        UIMgr:getInstance():closeUI(UITYPE.PROP_BOX)
        return
    end

    local castGold = CommonConfig:getInstance():getBuildingAccelerationCastGold(info.leftTime)
    self.parent.goldLab:setString(CommonStr.YOUR_CAN .. castGold .. CommonStr.GOLD_RIGHTNOW_REMOVE_BUILDING)
    local propCommand = UIMgr:getInstance():getUICtrlByType(UITYPE.PROP_BOX)
    if propCommand ~= nil then
        propCommand.view.title4Lab:setString(CommonStr.SURECAST .. castGold .. CommonStr.GOLD_RIGHTNOW_REMOVE_BUILDING)
        propCommand.view.time4Lab:setString(CommonStr.LEFT_TIME .. Common:getFormatTime(info.leftTime))
    end
end










