
--[[
	jinyan.zhang
	训练中的士兵信息
--]]

TrainingInfo = class("TrainingInfo")

--构造
--parent 父结点UI
function TrainingInfo:ctor(parent)
	self.parent = parent
	self:init()
end

--初始化
function TrainingInfo:init()
	self.trainingInfoPan = Common:seekNodeByName(self.parent.root,"trainingInfoPan")
	self.titleLab = Common:seekNodeByName(self.trainingInfoPan,"titleLab")
	self.titleLab:setString(CommonStr.NOW_TRAINING)
	self.nameLab = Common:seekNodeByName(self.trainingInfoPan,"nameLab")
	self.processBar = Common:seekNodeByName(self.trainingInfoPan,"processBar")
	self.timeLab = Common:seekNodeByName(self.trainingInfoPan,"timeLab")
end

--更新UI
--data 数据
function TrainingInfo:updateUI(data)
	if self.trainingInfoPan:isVisible() then
		return
	end

	local buildingPos = self.parent.data.building:getTag()
	local info = TimeInfoData:getInstance():getTimeInfoByBuildingPos(buildingPos)
	if info == nil then
		--self:updatedNum()
		--self.trainingInfoPan:setVisible(true)
		return
	end

	self.trainingInfoPan:setVisible(true)
	local leftTime = CityBuildingModel:getInstance():getLeftUpBuildingTime(info.start_time,info.interval)
	self.timeLab:setString(Common:getFormatTime(leftTime))
	self.needTime = info.interval
	local per = (self.needTime-leftTime)/self.needTime*100
	self.processBar:setPercent(per)
	self.nameLab:setString(info.name .. "  " .. info.num)

	local timeInfo = TimeMgr:getInstance():findTypeInfoByIndex(TimeType.UPDATE_SOLDIER_TRAINING_TIME,1,1)
    if not timeInfo then
        local info = {}
        info.index = 1
        info.leftTime = leftTime
        TimeMgr:getInstance():addInfo(TimeType.UPDATE_SOLDIER_TRAINING_TIME, info, 1,self.updateTime, self)
    else
        timeInfo.pause = false
        timeInfo.leftTime = leftTime
    end
end

--更新造兵数量
function TrainingInfo:updatedNum()
	local buildingPos = self.parent.data.building:getTag()
	local info = MakeSoldierModel:getInstance():getReadyArmsInfo(buildingPos)
	if info ~= nil then
		self.nameLab:setString(info.name .. "  " .. info.num)
	end
	self.titleLab:setString(CommonStr.FINISH_MAKESOLDIER)
	self.processBar:setPercent(100)
	self.timeLab:setString(Common:getFormatTime(0))
end

--更新时间
--info 数据
function TrainingInfo:updateTime(info)
	info.leftTime = info.leftTime - 1
	if info.leftTime <= 0 then
		info.leftTime = 0
		TimeMgr:getInstance():removeTypeInfoByIndex(TimeType.UPDATE_SOLDIER_TRAINING_TIME,1,1)
		self:updatedNum()
	end
	self.timeLab:setString(Common:getFormatTime(info.leftTime))
	local per = (self.needTime-info.leftTime)/self.needTime*100
	self.processBar:setPercent(per)
end




