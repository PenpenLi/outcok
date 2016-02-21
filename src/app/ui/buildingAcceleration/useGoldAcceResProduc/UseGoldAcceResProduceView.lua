
--[[
    jinyan.zhang
    使用金币加速资源产量
--]]

UseGoldAcceResProduceView = class("UseGoldAcceResProduceView")

--构造
--parent 父结点UI
function UseGoldAcceResProduceView:ctor(parent)
	self.parent = parent
	self:init()
end

--初始化
function UseGoldAcceResProduceView:init()
    self.parent.goldAccelerationBtn:addTouchEventListener(handler(self,self.useGoldAccelerationResourcesBtnCallback))
    local pos = self.parent:getBuildingPos()
    local buildingType = CityBuildingModel:getInstance():getBuildType(pos)
    local buildingLv = CityBuildingModel:getInstance():getBuildingLv(pos)
    if buildingLv == nil then
        buildingLv = 1
    end

    self.procduResSpeedCastGold = CommonConfig:getInstance():getAccelerationResourceCastGold(buildingLv,buildingType)
    self.parent.titleLab:setString(CommonStr.RESOURCE_ACCELERATING)
    self.parent.goldLab:setString(CommonStr.YOUR_CAN ..  self.procduResSpeedCastGold .. CommonStr.GOLD_ACCELERATING_ONE_DAY)
end

--使用金币资源加速按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function UseGoldAcceResProduceView:useGoldAccelerationResourcesBtnCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        local pos = self.parent:getBuildingPos()
        local title = CommonStr.SURE2 ..  self.procduResSpeedCastGold .. CommonStr.ACCELERATING_RESOURCE
            UIMgr:getInstance():openUI(UITYPE.PROP_BOX, {type=PROP_BOX_TYPE.COMMON,text=title,
                    callback=handler(self, self.sendUseGoldAccelerationResourcesReq),sureBtnText=CommonStr.SURE,cancelBtnText=CommonStr.CANCEL,buildingPos=pos
            })
    end
end

--发送使用金币资源加速请求
--返回值(无)
function UseGoldAcceResProduceView:sendUseGoldAccelerationResourcesReq()
    local pos = self.parent:getBuildingPos()
    if self.procduResSpeedCastGold > PlayerData:getInstance().gold then
        Prop:getInstance():showMsg(CommonStr.GOLD_NO_ENOUGH_SPEED_RES)
        return
    end
    UseGoldAcceResProduceService:sendProcduAccelerationReqByGold(pos,self.procduResSpeedCastGold)
end










