
--进度条

MMUIProcess = class("MMUIProcess")

local instance = nil

-- 获取单例
-- 返回值(单例)
function MMUIProcess:getInstance()
	if instance == nil then
		instance = MMUIProcess.new()
	end
	return instance
end

--构造
--返回值(无)
function MMUIProcess:ctor()
	self:init()
end

--初始化
--返回值(无)
function MMUIProcess:init()

end

--创建不带时间的进度条
function MMUIProcess:create(bgPath,path,parent,exp,maxExp,scaleX,isShowLab)
	if bgPath == nil or path == nil then
		return
	end
	exp = exp or 0
	maxExp = maxExp or 100
    scaleX = scaleX or 1
    if isShowLab == nil then
    	isShowLab = true
    end
	local per = exp/maxExp*100
	if per >= 100 then
		per = 100
	elseif per <= 0 then
		per = 0
	end

	local proceeBg = display.newSprite(bgPath)
	if parent ~= nil then
		parent:addChild(proceeBg)
	end

    proceeBg:setScaleX(scaleX)
    local processBar = ccui.LoadingBar:create()
    processBar:loadTexture(path)
    processBar:setAnchorPoint(0,0)
    proceeBg:addChild(processBar)
    processBar:setPercent(per)

    local label = nil
    if isShowLab then
    	label = display.newTTFLabel({
		    text = "" .. exp .. "/" .. maxExp,
		    font = "Arial",
		    size = 24,
		    color = cc.c3b(255, 255, 255),
		    align = cc.TEXT_ALIGNMENT_LEFT,
		})
		proceeBg:addChild(label)
		label:setAnchorPoint(0.5,0)
		label:setPosition(proceeBg:getContentSize().width/2,0)
	    label:setScaleX(1/scaleX)
    end

    return proceeBg,processBar,label
end

--内部使用
function MMUIProcess:createTimeProcess(bgPath,path,parent,leftTime,maxTime,scaleX)
	if bgPath == nil or path == nil then
		return
	end

	maxTime = maxTime or 100
	leftTime = leftTime or 10
	scaleX = scaleX or 1
	local passTime = maxTime - leftTime
	local per = passTime/maxTime*100
	per = 100 - per
	if per >= 100 then
		per = 100
	elseif per <= 0 then
		per = 0
	end

	local processBg = display.newSprite(bgPath)
	if parent ~= nil then
		parent:addChild(processBg)
	end
	self.processBg = processBg

    processBg:setScaleX(scaleX)
    local processBar = ccui.LoadingBar:create()
    processBar:loadTexture(path)
    processBar:setAnchorPoint(0,0)
    processBg:addChild(processBar)
    processBar:setPercent(per)
    --processBar:setDirection(1)
    self.processBar = processBar

    local label = display.newTTFLabel({
	    text = "",
	    font = "Arial",
	    size = 24,
	    color = cc.c3b(255, 255, 255),
	    align = cc.TEXT_ALIGNMENT_LEFT,
	})
	processBg:addChild(label)
	label:setAnchorPoint(0.5,0)
	label:setPosition(processBg:getContentSize().width/2,0)
    label:setScaleX(1/scaleX)
    local leftTimeStr = Lan:lanText(20,"{}后结束",{Common:getFormatTime(leftTime)})
    label:setString(leftTimeStr)
    self.label = label

    return processBg
end

--创建带时间的进度条
function MMUIProcess:createWidthTime(bgPath,path,parent,leftTime,maxTime,scaleX,timeType,id)
	if timeType == nil or id == nil then
		return
	end

	local timeInfo = TimeMgr:getInstance():findTypeInfoByIndex(timeType,1,id)
	if timeInfo == nil then
		self:createTimeProcess(bgPath,path,parent,leftTime,maxTime,scaleX)
		local info = {}
		info.timeType = timeType
		info.id = id
		info.maxTime = maxTime
		info.leftTime = leftTime
		info.processBar = self.processBar
		info.timeLab = self.label
		info.processBg = self.processBg
		TimeMgr:getInstance():createTime(leftTime,self.updateTime,self,timeType,id,info)
		return info.processBg
	else 
		timeInfo = TimeMgr:getInstance():createTime(leftTime,self.updateTime,self,timeType,id)
		if timeInfo ~= nil and timeInfo.info ~= nil and timeInfo.info.data ~= nil then
			timeInfo.info.data.exp = exp
			timeInfo.info.data.maxExp = maxExp
			return timeInfo.info.data.processBg
		end
	end
end

--刷新时间和进度
function MMUIProcess:updateTime(info)
	local data = info.data
	if data == nil then
		return
	end

	local passTime = data.maxTime - info.time
	local per = passTime/data.maxTime*100
	per = 100 - per
	if per >= 100 then
		per = 100
	elseif per <= 0 then
		per = 0
	end
	data.processBar:setPercent(per)
	local leftTimeStr = Lan:lanText(20,"{}后结束",{Common:getFormatTime(info.time)})
	data.timeLab:setString(leftTimeStr)
	if info.time <= 0 then
		TimeMgr:getInstance():removeInfo(info.timeType,info.id)
		data.processBg:removeFromParent()
	end
end

--关闭进度条定时器
function MMUIProcess:closeTimeByType(timeType)
	TimeMgr:getInstance():removeInfoByType(timeType)
end



