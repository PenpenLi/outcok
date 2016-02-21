
--[[
	jinyan.zhang
	士兵信息
--]]

SoldierInfoView = class("SoldierInfoView")

--构造
--parent 父结点UI
function SoldierInfoView:ctor(parent)
	self.parent = parent
	self:init()
end

--初始化
function SoldierInfoView:init()
	--士兵信息面板
	self.infoPan = Common:seekNodeByName(self.parent.root,"infoPan")
	--士兵名称
	self.nameLab = Common:seekNodeByName(self.infoPan,"nameLab")
	--士兵图片
	self.soldierImg = Common:seekNodeByName(self.infoPan,"soliderImg")
	--返回
	self.closeBtn = Common:seekNodeByName(self.infoPan,"closeBtn")
  self.closeBtn:addTouchEventListener(handler(self,self.closeBtnCallBack))
  --信息层
  self.boxLayer = Common:seekNodeByName(self.infoPan,"boxLayer")
  --攻击
  self.attLab = Common:seekNodeByName(self.boxLayer,"attLab")
  --防御
  self.defLab = Common:seekNodeByName(self.boxLayer,"defLab")
  --生命
  self.lifeLab = Common:seekNodeByName(self.boxLayer,"lifeLab")
  --攻击距离
  self.attDis = Common:seekNodeByName(self.boxLayer,"attdisLab")
  --攻击速度
  self.attSpeed = Common:seekNodeByName(self.boxLayer,"speedLab")
  --负重
  self.weightLab = Common:seekNodeByName(self.boxLayer,"weightLab")
  --消耗
 	self.castLab = Common:seekNodeByName(self.boxLayer,"castLab")
 	--战斗力
 	self.battleLab = Common:seekNodeByName(self.boxLayer,"battleLab")
 	--拥有的士兵数量
 	self.soldierNumLab = Common:seekNodeByName(self.infoPan,"numberLab")
 	--解雇按钮
 	self.fireBtn = Common:seekNodeByName(self.infoPan,"fireBtn")
 	self.fireBtn:addTouchEventListener(handler(self,self.fireBtnCallBack))
 	self.fireBtn:setTitleText(CommonStr.FIRE)
 	--解雇层
 	self.firePan = Common:seekNodeByName(self.infoPan,"firePan")
 	--解雇数量
 	self.fireNumLab = Common:seekNodeByName(self.firePan,"fireNumLab")
 	--解雇士兵按钮
 	self.fireSoldierBtn = Common:seekNodeByName(self.firePan,"fireBtn")
 	self.fireSoldierBtn:addTouchEventListener(handler(self,self.fireSoldierBtnCallBack))
 	self.fireSoldierBtn:setTitleText(CommonStr.FIRE)
  self.fireSoldierBtn:setTouchEnabled(false)
  self.fireNum = 0

 	self:createSlider()
end

--创建滑动条
--返回值(无)
function SoldierInfoView:createSlider()
    sliderResPath =
    {
        bar = "ui/build_training/sliderBar.png",
        button = "ui/build_training/sliderButton.png",
    }

    local barHeight = 40
    local barWidth = 400
    self.slider = cc.ui.UISlider.new(display.LEFT_TO_RIGHT, sliderResPath, {scale9 = true})
    self.slider:onSliderValueChanged(function(event)
        local curNum = self.soldierNum*event.value/100
        curNum = math.floor(curNum)
		self.fireNumLab:setString(CommonStr.SELECT_FIRE_NUM .. ": " .. curNum)
		if curNum == 0 then
			self.fireSoldierBtn:setTouchEnabled(false)
		else
			self.fireSoldierBtn:setTouchEnabled(true)
		end
		self.fireNum = curNum
    end)
    self.slider:setSliderSize(barWidth, barHeight)
    self.slider:addTo(self.firePan)
    self.slider:setPosition(80, 100)
end

--设置滑动条数值
--number 数值
function SoldierInfoView:setSliderValue(number)
	if self.soldierNum == 0 then
		self.slider:setSliderValue(0)
		self.slider:setTouchEnabled(false)
		return
	end

    local tmpValue = 100/self.soldierNum
    local per = tmpValue*number + self.offsetSliderValue
    if per > 100 then
        per = 100
    end
    self.slider:setSliderValue(per)
end

--解雇士兵按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function SoldierInfoView:fireSoldierBtnCallBack(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        local buildingPos = self.parent.data.building:getTag()
    	local text = CommonStr.IS_SURE_FIRE .. self.fireNum .. CommonStr.GE .. self.curSelSoliderInfo.name .. "? " .. CommonStr.FIRE_MINUS_BATTLE_POWER
    	UIMgr:getInstance():openUI(UITYPE.PROP_BOX, {type=PROP_BOX_TYPE.COMMON,text=text,
        	callback=handler(self, self.sendFireSoldierReq),sureBtnText=CommonStr.SURE,cancelBtnText=CommonStr.CANCEL,buildingPos=buildingPos
            })
    end
end

--发送解雇士兵请求
function SoldierInfoView:sendFireSoldierReq()
	local arms = {}
	arms.type = self.curSelSoliderInfo.templeteInfo.aa_typeid
	arms.level = self.curSelSoliderInfo.templeteInfo.aa_level
	arms.number = self.fireNum
	local buildingPos = self.parent.data.building:getTag()
	MakeSoldierService:sendFireSoldierReq(arms,buildingPos)
end

--解雇按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function SoldierInfoView:fireBtnCallBack(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
    	if self.firePan:isVisible() then
    		self.firePan:setVisible(false)
    	else
    		self.firePan:setVisible(true)
    	end
    end
end

--关闭按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function SoldierInfoView:closeBtnCallBack(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
    	self.infoPan:setVisible(false)
    	self.parent.trainPan:setVisible(true)
    	self.parent.buildinglist:setVisible(true)
    end
end

--更新UI
--info 信息
function SoldierInfoView:updateUI(info)
	self.curSelSoliderInfo = info
	self.nameLab:setString(info.name)
	self.soldierImg:loadTexture(info.bigPicName,ccui.TextureResType.plistType)
	self.attLab:setString(CommonStr.ATT .. ":  " .. info.templeteInfo.aa_attack)
	self.defLab:setString(CommonStr.DEF .. ":  " .. info.templeteInfo.aa_defense)
	self.lifeLab:setString(CommonStr.LIFE .. ":  " .. info.templeteInfo.aa_hp)
	self.attDis:setString(CommonStr.ATTDIS .. ":  " .. info.templeteInfo.aa_range)
	self.attSpeed:setString(CommonStr.ATTSPEED .. ":  " .. info.templeteInfo.aa_speed)
	self.weightLab:setString(CommonStr.WEIGHT .. ":  " .. info.templeteInfo.aa_weight)
	self.castLab:setString(CommonStr.CASTPOWER .. ":  " .. info.templeteInfo.aa_burning)
	self.battleLab:setString(CommonStr.BATTLE .. ":  " .. info.templeteInfo.aa_fightforce)
	self.soldierNumLab:setString(CommonStr.HAVE_NUM .. ": " .. info.soldierNum)
	self.fireNumLab:setString(CommonStr.SELECT_FIRE_NUM .. ": " .. 0)
	self.soldierNum = info.soldierNum
	if self.soldierNum > 0 then
		local str = tostring(self.soldierNum)
	    local len = string.len(str)
	    self.offsetSliderValue = 1/math.pow(10,len)
		  self:setSliderValue(0)
	else
		self.offsetSliderValue = 0
		self:setSliderValue(0)
	end
end




