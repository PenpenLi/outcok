
--[[
	jinyan.zhang
	资源建筑升级
--]]

ResBuildingUpLevel = class(ResBuildingUpLevel,UIBaseBuildUpgradeView)

function ResBuildingUpLevel:ctor(uiType)
	self.super.ctor(self,uiType)
end

function ResBuildingUpLevel:onEnter()

end

function ResBuildingUpLevel:updateUI(buildingType,level,name,configType)
	self:getParent().baseView:showView(self)

	self:init()
	self:setBuildingType(buildingType)
	self:setLevel(level)
	self:updateImgAndName()
	self:calRightNowUpCastGold()
	self:createUpBuildingConditionList()
	local config = OutResBuildingEffectConfig:getInstance():getConfig(configType,level+1)
	if config ~= nil then
		self:setDescrp(config.wre_des)
		self:setNextLevelTitle(name,level+1)
	else
		self:setDescrp("")
		self:setNextLevelTitle(name,Lan:lanText(202, "无"))
	end
end

--更新完成升级UI
function ResBuildingUpLevel:updateFinishUpLevelUI(buildingType,level)
	self:finishUpLevelUI()
	local parent = self:getParent()
	self:updateUI(buildingType,level,parent.detailsTitle,parent.configType)
end

--关闭按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function ResBuildingUpLevel:onClose(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        TimeMgr:getInstance():removeInfoByType(TimeType.upLevel)
        self:getParent():getParent().baseView:showView(self:getParent())
    end
end

--升级按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function ResBuildingUpLevel:upgradeInfoBtnCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
    	local instanceId = OutBuildingData:getInstance():getInfoByType(self.buildingType).id
    	local arry = {}
    	table.insert(arry,instanceId)
        self:upgradeOutBuildingReq(arry)
    end
end

--立即升级按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function ResBuildingUpLevel:rightNowUpLvBtnCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        local leftTime = self:getBuildingUpTime()
        if leftTime == 0 then
            Prop:getInstance():showMsg(CommonStr.BUILDING_HAVE_FULL_LEVEL)
            return
        end
        local buildingGold = self:calRightNowUpCastGold()
        local title2 = CommonStr.LEFT_TIME .. Common:getFormatTime(leftTime)
        local title = CommonStr.SURECAST .. buildingGold .. CommonStr.GOLD_FINISH_BUILD
            UIMgr:getInstance():openUI(UITYPE.PROP_BOX, {type=PROP_BOX_TYPE.MONEY_ACCELERATION,text=title,timeText=title2,
                    callback=handler(self, self.rightNowUpLevelReq),sureBtnText=CommonStr.YES,cancelBtnText=CommonStr.NO
            })
    end
end

--立即升级请求
function ResBuildingUpLevel:rightNowUpLevelReq()
	local instanceId = OutBuildingData:getInstance():getInfoByType(self.buildingType).id
	local arry = {}
	table.insert(arry,instanceId)
	self:rightNowUpLevelOutBuildingReq(arry)
end




