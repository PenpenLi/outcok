
--[[
    jinyan.zhang
    使用金币加速制造陷井
--]]

UseGoldAcceMakeTrapView = class("UseGoldAcceMakeTrapView")

--构造
--parent 父结点UI
function UseGoldAcceMakeTrapView:ctor(parent)
	self.parent = parent
	self:init()
end

--初始化
function UseGoldAcceMakeTrapView:init()
	self.parent.titleLab:setString(CommonStr.MAKE_TRAP_SPEED)
	self.parent.goldAccelerationBtn:addTouchEventListener(handler(self,self.accelerationMakeTrapBtnCallback))
    local leftTime = TimeInfoData:getInstance():getLeftTimeByBuildingPos(self.parent.data.pos)
    if leftTime == nil or leftTime == 0 then
        self.parent.goldLab:setString(CommonStr.YOUR_CAN .. 0 .. CommonStr.RIGHTNOW_FINISH_MAKE_TRAP)
        return
    end

    local castGold = CommonConfig:getInstance():getAccelerationMakeTrapCastGold(leftTime)
    self.parent.goldLab:setString(CommonStr.YOUR_CAN .. castGold .. CommonStr.RIGHTNOW_FINISH_MAKE_TRAP)
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

--加速回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function UseGoldAcceMakeTrapView:accelerationMakeTrapBtnCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
    	local leftTime = TimeInfoData:getInstance():getLeftTimeByBuildingPos(self.parent.data.pos)
        if leftTime == nil or leftTime == 0 then
            Prop:getInstance():showMsg(CommonStr.NO_NEED_SPEDD_MAKE_TRAP)
            TimeMgr:getInstance():removeTypeInfoByIndex(TimeType.ACC_MAKE_SOLDIER,1,1)
            return
        end

        local castGold = CommonConfig:getInstance():getAccelerationMakeTrapCastGold(leftTime)
        local title2 = CommonStr.LEFT_TIME .. Common:getFormatTime(leftTime)
        local title = CommonStr.SURECAST .. castGold .. CommonStr.RIGHTNOW_FINISH_MAKE_TRAP
            UIMgr:getInstance():openUI(UITYPE.PROP_BOX, {type=PROP_BOX_TYPE.MONEY_ACCELERATION,text=title,timeText=title2,
                    callback=handler(self, self.sendAccelerationMakeTrapReq),sureBtnText=CommonStr.YES,cancelBtnText=CommonStr.NO,buildingPos=self.parent.data.pos
            })

        self.parent.goldLab:setString(CommonStr.YOUR_CAN .. castGold .. CommonStr.RIGHTNOW_FINISH_MAKE_TRAP)
    end
end

--发送加速制造陷井请求
--返回值(无)
function UseGoldAcceMakeTrapView:sendAccelerationMakeTrapReq()
    local leftTime = TimeInfoData:getInstance():getLeftTimeByBuildingPos(self.parent.data.pos)
    local castGold = CommonConfig:getInstance():getAccelerationMakeSoldierCastGold(leftTime)
    if castGold > PlayerData:getInstance().gold then
        Prop:getInstance():showMsg(CommonStr.NO_GOLD_SPEED_MAKE_SOLDIER)
        return
    end
    UseGoldAcceMakeTrapService:sendAccelerationMakeTrapReq(castGold,AccelerationMakeSoldierAction.commonGold,self.parent.data.pos)
end

--更新使用金币加速制造陷井时间
--info 数据
--返回值(无)
function UseGoldAcceMakeTrapView:updateTime(info)
    info.leftTime = info.leftTime - 1
    if info.leftTime < 0 then
        info.leftTime = 0
        TimeMgr:getInstance():removeTypeInfoByIndex(TimeType.ACC_MAKE_SOLDIER,1,1)
        UIMgr:getInstance():closeUI(self.parent.uiType)
        UIMgr:getInstance():closeUI(UITYPE.BUILDING_MENU)
        UIMgr:getInstance():closeUI(UITYPE.PROP_BOX)
        return
    end

    local castGold = CommonConfig:getInstance():getAccelerationMakeTrapCastGold(info.leftTime)
    self.parent.goldLab:setString(CommonStr.YOUR_CAN .. castGold .. CommonStr.RIGHTNOW_FINISH_MAKE_TRAP)
    local propCommand = UIMgr:getInstance():getUICtrlByType(UITYPE.PROP_BOX)
    if propCommand ~= nil then
        propCommand.view.title4Lab:setString(CommonStr.SURECAST .. castGold .. CommonStr.RIGHTNOW_FINISH_MAKE_TRAP)
        propCommand.view.time4Lab:setString(CommonStr.LEFT_TIME .. Common:getFormatTime(info.leftTime))
    end
end










