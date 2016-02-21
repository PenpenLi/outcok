
--[[
	jinyan.zhang
	制造陷进中
--]]

MakeingTrap = class("MakeingTrap")

--构造
--parent 父结点UI
function MakeingTrap:ctor(parent)
	self.parent = parent
	self:init()
end

--初始化
function MakeingTrap:init()
	self.MakeingTrapPan = Common:seekNodeByName(self.parent.root,"trainingInfoPan")
	self.titleLab = Common:seekNodeByName(self.MakeingTrapPan,"titleLab")
	self.titleLab:setString(CommonStr.NOW_MAKEING_TRAP)
	self.nameLab = Common:seekNodeByName(self.MakeingTrapPan,"nameLab")
	self.processBar = Common:seekNodeByName(self.MakeingTrapPan,"processBar")
	self.timeLab = Common:seekNodeByName(self.MakeingTrapPan,"timeLab")
end

--更新UI
--data 数据
function MakeingTrap:updateUI(data)
	if self.MakeingTrapPan:isVisible() then
		return
	end

	local buildingPos = self.parent.data.building:getTag()
	local info = TimeInfoData:getInstance():getTimeInfoByBuildingPos(buildingPos)
	if info == nil then
		return
	end

	self.MakeingTrapPan:setVisible(true)
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

--更新制造陷井数量
function MakeingTrap:updatedNum()
	local buildingPos = self.parent.data.building:getTag()
	local info = MakeSoldierModel:getInstance():getReadyArmsInfo(buildingPos)
	if info ~= nil then
		self.nameLab:setString(info.name .. "  " .. info.num)
	end
	self.titleLab:setString(CommonStr.FINISH_MAKE_TRAP)
	self.processBar:setPercent(100)
	self.timeLab:setString(Common:getFormatTime(0))
end

--更新时间
--info 数据
function MakeingTrap:updateTime(info)
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

