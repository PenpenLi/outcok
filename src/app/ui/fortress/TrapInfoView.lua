
--[[
	jinyan.zhang
	陷井信息
--]]

TrapInfoView = class("TrapInfoView")

--构造
--parent 父结点UI
function TrapInfoView:ctor(parent)
	self.parent = parent
	self:init()
end

--初始化
function TrapInfoView:init()
	--陷井信息面板
	self.infoPan = Common:seekNodeByName(self.parent.root,"infoPan")
	--陷井名称
	self.nameLab = Common:seekNodeByName(self.infoPan,"nameLab")
	--陷井图片
	self.trapImg = Common:seekNodeByName(self.infoPan,"soliderImg")
	--返回
	self.closeBtn = Common:seekNodeByName(self.infoPan,"closeBtn")
  self.closeBtn:addTouchEventListener(handler(self,self.closeBtnCallBack))
  --信息层
  self.boxLayer = Common:seekNodeByName(self.infoPan,"boxLayer")
  --攻击
  self.attLab = Common:seekNodeByName(self.boxLayer,"attLab")
  --防御
  self.defLab = Common:seekNodeByName(self.boxLayer,"defLab")
 	--拥有的陷井数量
 	self.trapNumLab = Common:seekNodeByName(self.infoPan,"numberLab")
 	--销毁按钮
 	self.destroyBtn = Common:seekNodeByName(self.infoPan,"fireBtn")
 	self.destroyBtn:addTouchEventListener(handler(self,self.destroyBtnCallBack))
 	self.destroyBtn:setTitleText(CommonStr.FIRE)
 	--销毁层
 	self.destroyPan = Common:seekNodeByName(self.infoPan,"firePan")
 	-- 销毁数量
 	self.destroyNumLab = Common:seekNodeByName(self.destroyPan,"fireNumLab")
 	--销毁陷井按钮
 	self.destroyTrapBtn = Common:seekNodeByName(self.destroyPan,"fireBtn")
 	self.destroyTrapBtn:addTouchEventListener(handler(self,self.destroyTrapBtnCallBack))
 	self.destroyTrapBtn:setTitleText(CommonStr.FIRE)
  self.destroyNum = 0
  self.destroyTrapBtn:setTouchEnabled(false)
 	self:createSlider()
end

--创建滑动条
--返回值(无)
function TrapInfoView:createSlider()
    sliderResPath =
    {
        bar = "ui/build_training/sliderBar.png",
        button = "ui/build_training/sliderButton.png",
    }

    local barHeight = 40
    local barWidth = 400
    self.slider = cc.ui.UISlider.new(display.LEFT_TO_RIGHT, sliderResPath, {scale9 = true})
    self.slider:onSliderValueChanged(function(event)
        local curNum = self.trapNum*event.value/100
        curNum = math.floor(curNum)
    		self.destroyNumLab:setString(CommonStr.SELECT_FIRE_NUM .. ": " .. curNum)
    		if curNum == 0 then
    			self.destroyTrapBtn:setTouchEnabled(false)
    		else
    			self.destroyTrapBtn:setTouchEnabled(true)
    		end
    		self.destroyNum = curNum
    end)
    self.slider:setSliderSize(barWidth, barHeight)
    self.slider:addTo(self.destroyPan)
    self.slider:setPosition(80, 100)
end

--设置滑动条数值
--number 数值
function TrapInfoView:setSliderValue(number)
  if self.trapNum == 0 then
    self.slider:setSliderValue(0)
    self.slider:setTouchEnabled(false)
    return
  end

    local tmpValue = 100/self.trapNum
    local per = tmpValue*number + self.offsetSliderValue
    if per > 100 then
        per = 100
    end
    self.slider:setSliderValue(per)
end

--销毁按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function TrapInfoView:destroyBtnCallBack(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
      if self.destroyPan:isVisible() then
        self.destroyPan:setVisible(false)
      else
        self.destroyPan:setVisible(true)
      end
    end
end

--销毁陷井按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function TrapInfoView:destroyTrapBtnCallBack(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        local buildingPos = self.parent.data.building:getTag()
      local text = CommonStr.IS_SURE_FIRE .. self.destroyNum .. CommonStr.GE .. self.curSelSoliderInfo.name .. "? " .. CommonStr.DESTROY_MINUS_BATTLE_POWER
      UIMgr:getInstance():openUI(UITYPE.PROP_BOX, {type=PROP_BOX_TYPE.COMMON,text=text,
          callback=handler(self, self.sendDestroyTrapReq),sureBtnText=CommonStr.SURE,cancelBtnText=CommonStr.CANCEL,buildingPos=buildingPos
            })
    end
end

--发送销毁陷井请求
function TrapInfoView:sendDestroyTrapReq()
  local arms = {}
  arms.type = self.curSelSoliderInfo.templeteInfo.tl_armstypeid
  arms.level = self.curSelSoliderInfo.templeteInfo.tl_level
  arms.number = self.destroyNum
  local buildingPos = self.parent.data.building:getTag()
  FortressService:sendDestroyTrapReq(arms,buildingPos)
end

--关闭按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function TrapInfoView:closeBtnCallBack(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
      self.infoPan:setVisible(false)
      self.parent.trapListPan:setVisible(true)
      self.parent.buildinglist:setVisible(true)
    end
end

--更新UI
--info 信息
function TrapInfoView:updateUI(info)
	self.curSelSoliderInfo = info
	self.nameLab:setString(info.name)
	self.trapImg:loadTexture(info.bigPicName,ccui.TextureResType.plistType)
	self.attLab:setString(CommonStr.ATT .. ":  " .. info.templeteInfo.tl_attack)
	self.defLab:setString(CommonStr.DEF .. ":  " .. info.templeteInfo.tl_attack)
	self.trapNumLab:setString(CommonStr.HAVE_NUM .. ": " .. info.trapNum)
	self.destroyNumLab:setString(CommonStr.SELECT_DESTORY_NUM .. ": " .. 0)
	self.trapNum = info.trapNum
	if self.trapNum > 0 then
		local str = tostring(self.trapNum)
	    local len = string.len(str)
	    self.offsetSliderValue = 1/math.pow(10,len)
		self:setSliderValue(0)
	else
		self.offsetSliderValue = 0
		self:setSliderValue(0)
	end
end




