
--[[
    jinyan.zhang
    使用金币加速治疗
--]]

UseGoldAcceTreatmentView = class("UseGoldAcceTreatmentView")

--构造
--parent 父结点UI
function UseGoldAcceTreatmentView:ctor(parent)
    self.parent = parent
    self:init()
end

--初始化
function UseGoldAcceTreatmentView:init()
    self.parent.titleLab:setString(CommonStr.ACCELERATED_TREATMENT)
    self.parent.goldAccelerationBtn:addTouchEventListener(handler(self,self.useGoldAcceTreatmentBtnCallback))
    local timeInfo = TimeInfoData:getInstance():getTimeInfoByType(BuildType.firstAidTent)
    if timeInfo == nil then
        self.parent.goldLab:setString(CommonStr.YOUR_CAN .. 0 .. CommonStr.IMMEDIATE_COMPLETION_TREATMENT)
        return
    end

    local leftTime = Common:getLeftTime(timeInfo.start_time,timeInfo.interval)
    if leftTime == 0 then
        self.parent.goldLab:setString(CommonStr.YOUR_CAN .. 0 .. CommonStr.IMMEDIATE_COMPLETION_TREATMENT)
        return
    end

    local castGold = CommonConfig:getInstance():getAccelerationTreatmentCastGold(leftTime)
    self.parent.goldLab:setString(CommonStr.YOUR_CAN .. castGold .. CommonStr.IMMEDIATE_COMPLETION_TREATMENT)
    local timeInfo = TimeMgr:getInstance():findTypeInfoByIndex(TimeType.ACC_MAKE_SOLDIER,1,1)
    if not timeInfo then
        local info = {}
        info.index = 1
        info.leftTime = leftTime
        TimeMgr:getInstance():addInfo(TimeType.ACC_MAKE_SOLDIER, info, 1,self.updateTime, self)
    else
        timeInfo.pause = false
        timeInfo.leftTime = leftTime
    end
end

--使用金币加速治疗回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function UseGoldAcceTreatmentView:useGoldAcceTreatmentBtnCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        local timeInfo = TimeInfoData:getInstance():getTimeInfoByType(BuildType.firstAidTent)
        if timeInfo == nil then
            self.parent.goldLab:setString(CommonStr.YOUR_CAN .. 0 .. CommonStr.IMMEDIATE_COMPLETION_TREATMENT)
            TimeMgr:getInstance():removeTypeInfoByIndex(TimeType.ACC_MAKE_SOLDIER,1,1)
            Prop:getInstance():showMsg(CommonStr.NO_NEED_SPEED_TREATMENT)
            return
        end

        local leftTime = Common:getLeftTime(timeInfo.start_time,timeInfo.interval)
        if leftTime == 0 then
            self.parent.goldLab:setString(CommonStr.YOUR_CAN .. 0 .. CommonStr.IMMEDIATE_COMPLETION_TREATMENT)
            TimeMgr:getInstance():removeTypeInfoByIndex(TimeType.ACC_MAKE_SOLDIER,1,1)
            Prop:getInstance():showMsg(CommonStr.NO_NEED_SPEED_TREATMENT)
            return
        end

        local castGold = CommonConfig:getInstance():getAccelerationTreatmentCastGold(leftTime)
        local title2 = CommonStr.LEFT_TIME .. Common:getFormatTime(leftTime)
        local title = CommonStr.SURECAST .. castGold .. CommonStr.IMMEDIATE_COMPLETION_TREATMENT
            UIMgr:getInstance():openUI(UITYPE.PROP_BOX, {type=PROP_BOX_TYPE.MONEY_ACCELERATION,text=title,timeText="",
                    callback=handler(self, self.sendAccelerationTreatmentReq),sureBtnText=CommonStr.YES,cancelBtnText=CommonStr.NO,buildingPos=self.parent.data.pos
            })

        self.parent.goldLab:setString(CommonStr.YOUR_CAN .. castGold .. CommonStr.IMMEDIATE_COMPLETION_TREATMENT)
    end
end

--发送加速治疗请求
--返回值(无)
function UseGoldAcceTreatmentView:sendAccelerationTreatmentReq()
    local leftTime = TreatmentModel:getInstance():getleftTime()
    local castGold = CommonConfig:getInstance():getAccelerationTreatmentCastGold(leftTime)
    if castGold > PlayerData:getInstance().gold then
        Prop:getInstance():showMsg(CommonStr.NO_GOLD_SPEED_TREATMENT)
        return
    end
    local info = TimeInfoData:getInstance():getTimeInfoByType(BuildType.firstAidTent)
    if info ~= nil then
        UseGoldAcceTreatmentService:sendAccelerationTreatmentReq(AcceTreatmentAction.commonGold,castGold,info.arms)
    end
end

--更新使用金币加速升级时间
--info 数据
--返回值(无)
function UseGoldAcceTreatmentView:updateTime(info)
    info.leftTime = info.leftTime - 1
    if info.leftTime < 0 then
        info.leftTime = 0
        TimeMgr:getInstance():removeTypeInfoByIndex(TimeType.ACC_MAKE_SOLDIER,1,1)
        UIMgr:getInstance():closeUI(self.parent.uiType)
        UIMgr:getInstance():closeUI(UITYPE.BUILDING_MENU)
        UIMgr:getInstance():closeUI(UITYPE.PROP_BOX)
        return
    end

    local castGold = CommonConfig:getInstance():getAccelerationTreatmentCastGold(info.leftTime)
    self.parent.goldLab:setString(CommonStr.YOUR_CAN .. castGold .. CommonStr.IMMEDIATE_COMPLETION_TREATMENT)
    local propCommand = UIMgr:getInstance():getUICtrlByType(UITYPE.PROP_BOX)
    if propCommand ~= nil then
        propCommand.view.title4Lab:setString(CommonStr.SURECAST .. castGold .. CommonStr.IMMEDIATE_COMPLETION_TREATMENT)
        propCommand.view.time4Lab:setString(CommonStr.LEFT_TIME .. Common:getFormatTime(info.leftTime))
    end
end