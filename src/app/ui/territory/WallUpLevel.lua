
--[[
	jinyan.zhang
	城墙升级
--]]

WallUpLevel = class(WallUpLevel,UIBaseBuildUpgradeView)

function WallUpLevel:ctor(uiType,data)
	self.super.ctor(self,uiType)
end

function WallUpLevel:onEnter()
	self.panSlider = Common:seekNodeByName(self.root,"pan_slider")
	self.panSlider:setVisible(true)
	--标题
	self.labTitle = Common:seekNodeByName(self.panSlider,"lab_title")
	self.labTitle:setString(Lan:lanText(205, "升级数量"))

	--滑动条
	self.slider = Common:seekNodeByName(self.panSlider,"slider_num")
	self.slider:addEventListener(handler(self,self.onSlider))

	--增加按钮
	self.btnPlus = Common:seekNodeByName(self.panSlider,"btn_plus")
    self.btnPlus:addTouchEventListener(handler(self,self.onPlus))
    --减少按钮
	self.btnMinus = Common:seekNodeByName(self.panSlider,"btn_minus")
    self.btnMinus:addTouchEventListener(handler(self,self.onMinus))
    --数量
    self.labNum = Common:seekNodeByName(self.panSlider,"lab_num")
    self.labNum:setString("0")
end

--滑动事件
function WallUpLevel:onSlider(sender,eventType)
	local per = sender:getPercent()
	local count = math.ceil(per*self.maxWallCount/100)
	self.curWallCount = count
	self:updateSliderNum()
end

--更新滑动进度
function WallUpLevel:updatePer()
	local per = self.curWallCount/self.maxWallCount*100
    self.slider:setPercent(per)
    self:updateSliderNum()
end

--更新滑动数量值
function WallUpLevel:updateSliderNum()
	self.labNum:setString("" .. self.curWallCount)
	self:calRightNowUpCastGold(self.curWallCount)
	self:calRightNowUpLevelTime(self.curWallCount)
	self:createUpBuildingConditionList(self.curWallCount)
end

--增加按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function WallUpLevel:onPlus(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
    	self.curWallCount = self.curWallCount + 1
    	if self.curWallCount > self.maxWallCount then
    		self.curWallCount = self.maxWallCount
    	end
    	self:updatePer()
    end
end

--减少按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function WallUpLevel:onMinus(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
    	self.curWallCount = self.curWallCount - 1
    	if self.curWallCount < 0 then
    		self.curWallCount = 0
    	end
    	self:updatePer()
    end
end

function WallUpLevel:updateUI(buildingType,level,name,wallCount)
    self.baseView:showView(self)

	self:init()
	self:onEnter()
	self:setBuildingType(buildingType)
	self:setLevel(level)
	self:updateImgAndName()
	self:calRightNowUpCastGold()
	self:createUpBuildingConditionList()
	local config = OutWallConfig:getInstance():getConfig(level+1)
	if config ~= nil then
		local def = Lan:lanText(204, "防御值: {}", {config.wwe_defence})
		self:setDescrp(def)
		self:setNextLevelTitle(name,level+1)
	else
		self:setDescrp("")
		self:setNextLevelTitle(name,Lan:lanText(202, "无"))
	end
	self.maxWallCount = wallCount
	self.curWallCount = 1
	self:updatePer()
end

--更新完成升级UI
function WallUpLevel:updateFinishUpLevelUI(buildingType,level)
	self:finishUpLevelUI()
	local parent = self:getParent()
	self:updateUI(buildingType,level,parent.detailsTitle,parent.wallCount)
end

--关闭按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function WallUpLevel:onClose(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        TimeMgr:getInstance():removeInfoByType(TimeType.upLevel)
        self:getParent():getParent().baseView:showView(self:getParent())
    end
end

--升级按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function WallUpLevel:upgradeInfoBtnCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
    	if self.curWallCount == 0 then
    		Lan:hintClient(16,"升级的城墙数量不能为0")
    		return
    	end

    	local count = 0
    	local arry = {}
    	local arryWall = self:getParent().arryWall
    	for k,v in pairs(arryWall) do
    		table.insert(arry,v)
    		count = count + 1
    		if count >= self.curWallCount then
    			break
    		end
    	end
        self:upgradeOutBuildingReq(arry)
    end
end

--立即升级按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function WallUpLevel:rightNowUpLvBtnCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
    	if self.curWallCount == 0 then
    		Lan:hintClient(16,"升级的城墙数量不能为0")
    		return
    	end

        local leftTime = self:getBuildingUpTime()
        if leftTime == 0 then
            Prop:getInstance():showMsg(CommonStr.BUILDING_HAVE_FULL_LEVEL)
            return
        end

        local buildingGold = self:calRightNowUpCastGold(self.curWallCount)
        local title2 = CommonStr.LEFT_TIME .. Common:getFormatTime(leftTime)
        local title = CommonStr.SURECAST .. buildingGold .. CommonStr.GOLD_FINISH_BUILD
            UIMgr:getInstance():openUI(UITYPE.PROP_BOX, {type=PROP_BOX_TYPE.MONEY_ACCELERATION,text=title,timeText=title2,
                    callback=handler(self, self.rightNowUpLevelReq),sureBtnText=CommonStr.YES,cancelBtnText=CommonStr.NO
            })
    end
end

--立即升级请求
function WallUpLevel:rightNowUpLevelReq()
	local count = 0
	local arry = {}
	local arryWall = self:getParent().arryWall
	for k,v in pairs(arryWall) do
		table.insert(arry,v)
		count = count + 1
		if count >= self.curWallCount then
			break
		end
	end
	self:rightNowUpLevelOutBuildingReq(arry)
end

function WallUpLevel:isAtWorldMap()
    return false
end

