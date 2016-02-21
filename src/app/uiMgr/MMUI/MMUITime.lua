
--[[
	jinyan.zhang
	倒计时
--]]

MMUITime = class("MMUITime",function()
	return display.newLayer()
end)

function MMUITime:ctor()
	self:setNodeEventEnabled(true)
	self:init()
end

function MMUITime:init()
	self.bgPath = "citybuilding/processbg.png"
	self.processPath = "citybuilding/process.png"
	self.iconPath = "test/loading_juhua.png"
	self.scaleX = 1
	self.labText = ""
	self.time = 5
	self.maxTime = 10
	self.timeType = TimeType.time
	self.timeId = 100
	self.isHaveCreate = false
end

function MMUITime:onEnter()

end

function MMUITime:onExit()
	TimeMgr:getInstance():removeTypeInfoByIndex(self.timeType,1,self.timeId)
end

--显示
function MMUITime:show()
	if self.isHaveCreate then
		return
	end
	self.isHaveCreate = true

	--进度条背景
	self.processBg = display.newSprite(self.bgPath)
	self:addChild(self.processBg)
    self.processBg:setScaleX(self.scaleX)

	--进度条
	self.processBar = ccui.LoadingBar:create()
    self.processBar:loadTexture(self.processPath)
    self.processBar:setAnchorPoint(0,0)
    self.processBg:addChild(self.processBar)
    local per = self.time/self.maxTime*100
    if per <= 0 then
    	per = 0
    elseif per >= 100 then
    	per = 100
    end
    self.processBar:setPercent(per)

    --icon
    self.imgIcon = display.newSprite(self.iconPath)
    self.imgIcon:setAnchorPoint(0,1)
    self.imgIcon:setPosition(0,80)
    self.imgIcon:setScaleX(1/self.scaleX)
    self.processBg:addChild(self.imgIcon)

    --时间
    self.labTime = display.newTTFLabel({
	    text = "",
	    font = "Arial",
	    size = 24,
	    color = cc.c3b(255, 255, 255),
	    align = cc.TEXT_ALIGNMENT_LEFT,
	})
	self.processBg:addChild(self.labTime)
	self.labTime:setAnchorPoint(0.5,0)
	self.labTime:setPosition(self.processBg:getContentSize().width/2,self.processBar:getContentSize().height+10)
    self.labTime:setScaleX(1/self.scaleX)
    self.labTime:setString(Common:getFormatTime(self.time))

    --显示文本内容
    self.labContent = display.newTTFLabel({
	    text = "",
	    font = "Arial",
	    size = 26,
	    color = cc.c3b(255, 255, 255),
	    align = cc.TEXT_ALIGNMENT_LEFT,
	})
	self.processBg:addChild(self.labContent)
	self.labContent:setAnchorPoint(0.5,1)
	self.labContent:setPosition(self.processBg:getContentSize().width/2,-5)
    self.labContent:setScaleX(1/self.scaleX)
    self.labContent:setString(self.labText)

    --打开定时器
    TimeMgr:getInstance():createTime(self.time,self.updateTime,self,self.timeType,self.timeId)
end

function MMUITime:updateTime(info)
	local passTime = self.maxTime - info.time
	local per = passTime/self.maxTime*100
	if per >= 100 then
		per = 100
	elseif per <= 0 then
		per = 0
	end
	self.processBar:setPercent(per)

	self.labTime:setString("" .. Common:getFormatTime(info.time))
	if info.time <= 0 then
		TimeMgr:getInstance():removeTypeInfoByIndex(self.timeType,1,self.timeId)
	end
end

--设置定时器类型
function MMUITime:setTimeType(type)
	self.timeType = type
end

--设置定时器id
function MMUITime:setTimeId(id)
	self.timeId = id
end

--设置剩余时间
function MMUITime:setTime(time)
	self.time = time
end

--设置总时间
function MMUITime:setMaxTime(time)
	self.maxTime = time
end

--设置进度条背景图片路径
function MMUITime:setBgPath(path)
	self.bgPath = path
end

--设置进度条图片路径
function MMUITime:setProcessPath(path)
	self.processPath = path
end

--设置进度条放大倍数
function MMUITime:setScaleX(scaleX)
	self.scaleX = scaleX
end

--设置显示文本内容
function MMUITime:setLabText(content)
	self.labText = content
end

--设置icon路径
function MMUITime:setIconPath(path)
	self.iconPath = path
end

function MMUITime:setPos(x,y)
	self.processBg:setPosition(x,y)
end

function MMUITime:upLevel(timeId_h,timeId_l)
	local timeInfo = TimeInfoData:getInstance():getTimeInfoById(timeId_h,timeId_l)
	if timeInfo == nil then
		return
	end

	local id = "" .. timeId_h .. timeId_l
	self:setTimeId(id)
	local leftTime = Common:getLeftTime(timeInfo.start_time,timeInfo.interval)
	--设置剩余时间
	self:setTime(leftTime)
	--设置总时间
	self:setMaxTime(timeInfo.interval)
	self:setScaleX(0.5)
	self:show()
end




