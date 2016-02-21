
--[[
	jinyan.zhang
	加速基类
--]]

AccelerationBase = class("AccelerationBase",function()
    return display.newLayer()
end)

UpLvPropActionType =
{
    create = 1,  --加速建造
    remove = 2,  --加速移除
}

--设置头顶标题
function AccelerationBase:setTitle(title)
    self.labTitle:setString(title)
    self.accelerationProp:setTitle(title)
end

--设置道具描述
function AccelerationBase:setPropDes(descrp)
    self.labPropDes:setString(descrp)
end

--添加金币加速消息回调
function AccelerationBase:addGoldAcceMsgCallback(callback,target)
    self.callback = callback
    self.target = target
end

--设置花费金币系数
function AccelerationBase:setCoeff(coeff)
    self.coeff = coeff
end

--设置加速剩余时间
function AccelerationBase:setLeftTime(leftTime)
    self.leftTime = leftTime or 0
    self.beginTime = Common:getOSTime()
end

--设置花费金币描述id
function AccelerationBase:setCastGoldDesId(id)
    self.castGoldDesId = id
end

--设置剩余时间到了的提示
function AccelerationBase:setTimeProp(content)
    self.popTimeContent = content or ""
end

--设置金币提示框标题
function AccelerationBase:setGoldPropTitleId(id)
    self.goldPropTitleId = id
end

--设置建筑位置
function AccelerationBase:setBuildingPos(pos)
    self.buildingPos = pos
end

function AccelerationBase:ctor(uiType,data)
	self.baseView = BaseView.new(self,uiType,data)
end

function AccelerationBase:init()
	self.root = Common:loadUIJson(ACCELERATION_BUILDING)
    self:addChild(self.root)
    self.root:setTouchEnabled(false)

    self.view = Common:seekNodeByName(self.root,"Panel_1")

    --关闭按钮
    self.btnClose = Common:seekNodeByName(self.view,"closeBtn")
    self.btnClose:addTouchEventListener(handler(self,self.onClose))

    --头顶标题
    self.labTitle = Common:seekNodeByName(self.view,"titleLab")

    --金币标题
   	self.titleLab = Common:seekNodeByName(self.view,"titleLab")
   	self.titleLab:setString(Lan:lanText(106, "金币加速"))

    --金币描述
    self.labGoldDes = Common:seekNodeByName(self.view,"goldLab")

    --金币加速按钮
    self.btnGoldAcceleration = Common:seekNodeByName(self.view,"gold_AccelerationBtn")
    self.btnGoldAcceleration:addTouchEventListener(handler(self,self.onGold))

    --道具标题
    self.labpropTitle = Common:seekNodeByName(self.view,"propTitleLab")
    self.labpropTitle:setString(Lan:lanText(107, "道具加速"))

    --道具描述
    self.labPropDes = Common:seekNodeByName(self.view,"propDescrpLab")

      --道具加速按钮
    self.btnAcceProp = Common:seekNodeByName(self.root,"prop_AccelerationBtn")
    self.btnAcceProp:addTouchEventListener(handler(self,self.onAcceProp))

    --道具加速UI
    self.accelerationProp = AccelerationProp.new(self)
end

--隐藏道具按钮
function AccelerationBase:hidePropBtn()
    local count = self.accelerationProp:getPropCount()
    if count == 0 then
        self.btnAcceProp:setVisible(false)
        self.labPropDes:setVisible(false)
        self.labpropTitle:setVisible(false)
    end
end

--道具加速按钮回调
function AccelerationBase:onAcceProp(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self:hide()
        self.accelerationProp:showView()
        self.accelerationProp:updateUI()
    end
end

function AccelerationBase:show()
    self.view:setVisible(true)
end

function AccelerationBase:hide()
    self.view:setVisible(false)
    self:onExit()
end

--显示
function AccelerationBase:showView()
	self:setVisible(true)
end

--隐藏
function AccelerationBase:hideView()
	self:setVisible(false)
    self:onExit()
end

--设置金币描述
function AccelerationBase:setGoldDes(time)
    local castGold = CommonConfig:getInstance():getCastGold(time,self.coeff)
    local descrp = Lan:lanText(self.castGoldDesId, "", {castGold})
	self.labGoldDes:setString(descrp)
end

--关闭按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function AccelerationBase:onClose(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
    	self.baseView:showTopView()
        self:onExit()
    end
end

function AccelerationBase:onEnter()
    UICommon:getInstance():setMapTouchAable(false)
end

function AccelerationBase:onExit()
    TimeMgr:getInstance():removeInfo(TimeType.goldAcceTime,1)
    TimeMgr:getInstance():removeInfo(TimeType.propAcceTime,1)
end

function AccelerationBase:onDestroy()

end

--获取剩余时间
function AccelerationBase:getLeftTime()
    return Common:getLeftTime(self.beginTime,self.leftTime)
end

--获取剩余时间描述
function AccelerationBase:getTimeDes(time)
    return Lan:lanText(110, "剩余时间: {}", {Common:getFormatTime(time)})
end

--更新使用金币加速升级时间
--info 数据
--返回值(无)
function AccelerationBase:updateTime(info)
    if info.time <= 0 then
        info.time = 0
        TimeMgr:getInstance():removeInfo(info.timeType,1)
        UIMgr:getInstance():closeUI(UITYPE.PROP_BOX)
        self:closeAllUI()
        return
    end

    --花费金币描述
    self:setGoldDes(info.time)
    local propCommand = UIMgr:getInstance():getUICtrlByType(UITYPE.PROP_BOX)
    if propCommand ~= nil then
        local castGold = CommonConfig:getInstance():getCastGold(info.time,self.coeff)
        propCommand.view.title4Lab:setString(Lan:lanText(111, "", {castGold}))
        local timeContent = self:getTimeDes(info.time)
        propCommand.view.time4Lab:setString(timeContent)
    end
end

--使用金币加速按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function AccelerationBase:onGold(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        local leftTime = self:getLeftTime()
        --花费金币描述
        self:setGoldDes(leftTime)
        if leftTime == 0 then
            TimeMgr:getInstance():removeInfo(TimeType.goldAcceTime,1)
            Prop:getInstance():showMsg(self.popTimeContent)

            local command = UIMgr:getInstance():getUICtrlByType(UITYPE.TERRITORY)
            if command ~= nil then
                command:updateFinishAcceUI()
            end
            return
        end

        --开启定时器
        TimeMgr:getInstance():createTime(leftTime,self.updateTime,self,TimeType.goldAcceTime,1)
        
        --弹出提示框
        local timeContent = self:getTimeDes(leftTime)
        local yes = Lan:lanText(112, "是")
        local no = Lan:lanText(113, "否")
            UIMgr:getInstance():openUI(UITYPE.PROP_BOX, {type=PROP_BOX_TYPE.MONEY_ACCELERATION,text=self.goldPropTitle,timeText=timeContent,
                    callback=handler(self, self.onGoldAcceReq),sureBtnText=yes,cancelBtnText=no,buildingPos=self.buildingPos
            })
    end
end

--发送金币加速消息
function AccelerationBase:onGoldAcceReq()
    if self.callback ~= nil then
        self.callback(self.target,self.buildingPos)
    end
end

--关掉所有的UI
function AccelerationBase:closeAllUI()
    self:onExit()
    self:hideView()
end

--加速建筑升级通过建筑位置
function AccelerationBase:upLevelByPos(pos)
    --设置建筑位置
    self:setBuildingPos(pos)
    --设置建筑加速升级系数
    self:setCoeff(CommonConfig:getInstance():getBuildingAccelerationCoefficient())
    --设置标题
    self:setTitle(Lan:lanText(109, "建造加速"))
    -- 设置道具描述
    self:setPropDes(Lan:lanText(130, "你可以使用道具来加速建造速度", arry))
    --设置剩余时间
    local leftTime = CityBuildingModel:getInstance():getBuildingLeftProcessTime(pos)
    self:setLeftTime(leftTime)
    --设置时间到了提示文字
    self:setTimeProp(Lan:lanText(108,"已经完成建造,无需进行加速"))
    --设置描述id
    local castGold = CommonConfig:getInstance():getCastGold(self.leftTime,self.coeff)
    self:setGoldPropTitleId(111,"确定花{}金币,瞬间完成建造？")
    --设置金币加速消息回调
    self:addGoldAcceMsgCallback(self.onUpLevelReq,self)

    --设置总时间
    local timeInfo = CityBuildingModel:getInstance():getBuilderInfo(pos)
    if timeInfo ~= nil then
       self.accelerationProp:setTotalTime(timeInfo.interval)
    else
       self.accelerationProp:setTotalTime(leftTime)
    end
    --设置时间文本id
    self.accelerationProp:setTimeContentId(116,"建造时间: {}")
    --设置加速道具类型
    self.accelerationProp:setPropType(ItemSpeedType.build)
    --文本提示
    self.accelerationProp:setPropTimeOverText(Lan:lanText(121, "您所要进行的加速时间超过了建造时间,确定要加速?"))
    --设置道具加速消息回调
    self.accelerationProp:setCallback(self.accelerationProp.onUpLevelReq,self.accelerationProp)
    --隐藏道具按钮
    self:hidePropBtn()
end

--升级建筑请求
function AccelerationBase:onUpLevelReq()
    local pos = self.buildingPos
    local leftTime = self:getLeftTime()
    local castGold = CommonConfig:getInstance():getBuildingAccelerationCastGold(leftTime)
    if castGold > PlayerData:getInstance().gold then
        Prop:getInstance():showMsg(Lan:lanText(142, "身上金币不够无法升级建筑"))
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

--加速野外建筑升级通过实例id
function AccelerationBase:upLevelById()
    --设置建筑加速升级系数
    self:setCoeff(CommonConfig:getInstance():getBuildingAccelerationCoefficient())
    --设置标题
    self:setTitle(Lan:lanText(109, "建造加速"))
    -- 设置道具描述
    self:setPropDes(Lan:lanText(130, "你可以使用道具来加速建造速度", arry))
    --设置剩余时间
    local leftTime = TimeInfoData:getInstance():getLeftTimeByInstanceIdList(self.instanceIds)
    self:setLeftTime(leftTime)
    --设置时间到了提示文字
    self:setTimeProp(Lan:lanText(108,"已经完成建造,无需进行加速"))
    --设置描述id
    local castGold = CommonConfig:getInstance():getCastGold(self.leftTime,self.coeff)
    self:setGoldPropTitleId(111,"确定花{}金币,瞬间完成建造？")
    --设置金币加速消息回调
    self:addGoldAcceMsgCallback(self.onUpLevelReqOfOut,self)

    --设置总时间
    local timeInfo = TimeInfoData:getInstance():getInfoByInstanceIdList(self.instanceIds)
    if timeInfo ~= nil then
       self.accelerationProp:setTotalTime(timeInfo.interval)
    else
       self.accelerationProp:setTotalTime(leftTime)
    end
    --设置时间文本id
    self.accelerationProp:setTimeContentId(116,"建造时间: {}")
    --设置加速道具类型
    self.accelerationProp:setPropType(ItemSpeedType.build)
    --文本提示
    self.accelerationProp:setPropTimeOverText(Lan:lanText(121, "您所要进行的加速时间超过了建造时间,确定要加速?"))
    --设置道具加速消息回调
    self.accelerationProp:setCallback(self.accelerationProp.onUpLevelReqOfOut,self.accelerationProp)
    --隐藏道具按钮
    self:hidePropBtn()
end

--设置野外建筑实例ID列表
function AccelerationBase:setBuildingIds(instanceId)
    self.instanceIds = instanceId
end

--升级野外建筑请求
function AccelerationBase:onUpLevelReqOfOut()
    local leftTime = self:getLeftTime()
    local castGold = CommonConfig:getInstance():getBuildingAccelerationCastGold(leftTime)
    if castGold > PlayerData:getInstance().gold then
        Prop:getInstance():showMsg(Lan:lanText(142, "身上金币不够无法升级建筑"))
        return
    end
    TerritoryAcceService:getInstance():useGoldUpLevelReq(self.instanceIds,castGold)
end



