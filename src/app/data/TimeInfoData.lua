
--[[
	jinyan.zhang
	定时器数据
--]]

TimeInfoData = class("TimeInfoData")

local instance = nil

--构造
--返回值(无)
function TimeInfoData:ctor()
	self:init()
end

--初始化
--返回值(无)
function TimeInfoData:init()
	self.timeouts = {}
end

--获取单例
--返回值(单例)
function TimeInfoData:getInstance()
	if instance == nil then
		instance = TimeInfoData.new()
	end
	return instance
end

--添加定时器信息
--timeData 定时器信息
--armId_l 和定时器相关的ID
--armsId_h 和定时器相关的ID
--buildingPos 建筑位置
--返回值(无)
function TimeInfoData:addTimeInfo(timeData)
	if timeData == nil then
		return
	end
	if timeData.id_h == 0 and timeData.id_l == 0 then
		return
	end
	--
	local info = self:getTimeInfoById(timeData.id_h,timeData.id_l)
	-- 判断有没有这个定时器 如果有就替换时间
	if info ~= nil then
		self:setIntervalAndStartTime(timeData.id_h,timeData.id_l,Common:getOSTime(),timeData.interval)
		return info
	end
	--
	local timeInfo = {}
	timeInfo.id_h = timeData.id_h
	timeInfo.id_l = timeData.id_l
	timeInfo.start_time = Common:getOSTime()
	timeData.start_time = Common:getOSTime()
	timeInfo.interval = timeData.interval
	timeInfo.finished = timeData.finished
	timeInfo.action = timeData.action
	timeInfo.markId = timeData.markId
	table.insert(self.timeouts,timeInfo)
	return timeInfo
end

--保存定时器数据
--data 数据
--返回值(无)
function TimeInfoData:setData(data)
	for k,v in pairs(data) do
		self:addTimeInfo(v)
	end
end

--获取定时器列表
--返回值(定时器列表)
function TimeInfoData:getData()
	return self.timeouts
end

--获取定时器信息通过id
--id_h id高位
--id_l id低位
--返回值(定时器信息)
function TimeInfoData:getTimeInfoById(id_h,id_l)
	for k,v in pairs(self.timeouts) do
		if v.id_h == id_h and v.id_l == id_l then
			return v
		end
	end
end

--删除定时器信息通过id
--id_h id高位
--id_l id低位
--返回值(无)
function TimeInfoData:detTimeInfoById(id_h,id_l)
	for k,v in pairs(self.timeouts) do
		if v.id_h == id_h and v.id_l == id_l then
			self.timeouts[k] = nil
			break
		end
	end
end

--删除定时器信息通过部队id
--id_h id高位
--id_l id低位
--返回值(无)
function TimeInfoData:delTimeInfoByArmsId(id_h,id_l)
	for k,v in pairs(self.timeouts) do
		if v.armsId_l == id_l and v.armsId_h == id_h then
			self.timeouts[k] = nil
			break
		end
	end
end

--建筑是否在造兵中
--buildingPos 建筑位置
--返回值(true:是，false:否)
function TimeInfoData:isMakeingSoldier(buildingPos)
	for k,v in pairs(self.timeouts) do
        if v.buildingPos == buildingPos and v.finished == BuidState.UN_FINISH then
            return true
        end
    end
    return false
end

--删除定时器通过建筑位置
--buildingPos 建筑位置
--返回值(无)
function TimeInfoData:delTimeInfoByBuildingPos(buildingPos)
	for k,v in pairs(self.timeouts) do
		if v.buildingPos == buildingPos then
			self.timeouts[k] = nil
			break
		end
	end
end

--获取定时器信息通过建筑位置
--buildingPos 建筑位置
--返回值(定时器信息)
function TimeInfoData:getTimeInfoByBuildingPos(buildingPos)
	for k,v in pairs(self.timeouts) do
		if v.buildingPos == buildingPos then
			return v
		end
	end
end

--获取剩余时间
--buildingPos 建筑位置
--返回值(剩余时间)
function TimeInfoData:getLeftTimeByBuildingPos(buildingPos)
	local info = self:getTimeInfoByBuildingPos(buildingPos)
	if info == nil then
		return
	end

	local passTime = Common:getOSTime() - info.start_time
	local leftTime = info.interval - passTime
	if leftTime < 0 then
		leftTime = 0
	end
	return leftTime
end

--获取剩余时间通过定时器id
function TimeInfoData:getLeftTimeById(id_h,id_l)
	local info = self:getTimeInfoById(id_h,id_l)
	if info == nil then
		return
	end
	local passTime = Common:getOSTime() - info.start_time
	local leftTime = info.interval - passTime
	if leftTime < 0 then
		leftTime = 0
	end
	return leftTime
end

-- 减少剩余时间通过建筑位置
function TimeInfoData:minusLeftTimeByPos(buildingPos,changeTime)
	local info = self:getTimeInfoByBuildingPos(buildingPos)
	if info == nil then
		return
	end
	info.interval = info.interval - changeTime
	if info.interval < 0 then
		info.interval = 0
	end
	return info
end

--设置定时器开始和间隔时间
--id_h id高位
--id_l id低位
--startTime 开始时间
--intervalTime 间隔时间
--返回值(无)
function TimeInfoData:setIntervalAndStartTime(id_h,id_l,startTime,intervalTime)
	local info = self:getTimeInfoById(id_h,id_l)
	if info == nil then
		return
	end

	info.start_time = startTime
	info.interval = intervalTime
end

--设置建筑位置
--id_h id高位
--id_l id低位
--buildingPos 建筑位置
--返回值(无)
function TimeInfoData:setBuildingPos(id_h,id_l,buildingPos)
	local info = self:getTimeInfoById(id_h,id_l)
	if info == nil then
		return
	end

	info.buildingPos = buildingPos
end

--设置建筑类型
--id_h id高位
--id_l id低位
--buildingType 建筑类型
--返回值(无)
function TimeInfoData:setBuildingType(id_h,id_l,buildingType)
	local info = self:getTimeInfoById(id_h,id_l)
	if info == nil then
		return
	end

	info.buildingType = buildingType
end

--设置军队数据通过建筑类型
--arms 军队
--buildingType 建筑类型
--返回值(无)
function TimeInfoData:setArmsByBuildingType(arms,buildingType)
	local info = self:getTimeInfoByType(buildingType)
	if info == nil then
		return
	end

	info.arms = arms
end

--获取定时器根据建筑类型
--buildingType 建筑类型
--返回值(无)
function TimeInfoData:getTimeInfoByType(buildingType)
	for k,v in pairs(self.timeouts) do
		if v.buildingType == buildingType then
			return v
		end
	end
end

--删除定时器根据建筑类型
--buildingType 建筑类型
--返回值(无)
function TimeInfoData:delTimeInfoByType(buildingType)
	for k,v in pairs(self.timeouts) do
		if v.buildingType == buildingType then
			self.timeouts[k] = nil
			break
		end
	end
end

--设置定时器根据定时器类型
--action 定时器类型
--buildingType 建筑类型
--返回值(定时器)
function TimeInfoData:setTimeInfoByActron(action,buildingType)
	for k,v in pairs(self.timeouts) do
		if v.action == action then
		   v.buildingType = buildingType
		   break
		end
	end
end

--设置定时器部队id
--id_h 定时器id
--id_l 定时器id
--armId_l 部队id
--armsId_h 部队id
--返回值(无)
function TimeInfoData:setArmsId(id_h,id_l,armId_h,armsId_l)
	local info = self:getTimeInfoById(id_h,id_l)
	if info == nil then
		return
	end

	info.armsId_l = armId_l
	info.armsId_h = armsId_h
end

--设置造兵数据
--id_h id高位
--id_l id低位
--buildingPos 建筑位置
--soldierType 士兵类型
--level 等级
--num 数量
--name 名称
--soldierAnmationTempleType 士兵动画模板类型
--返回值(无)
function TimeInfoData:setMakeSoldierInfo(id_h,id_l,buildingPos,soldierType,level,num,name,soldierAnmationTempleType)
	local info = self:getTimeInfoById(id_h,id_l)
	if info == nil then
		return
	end

	info.buildingPos = buildingPos
	info.soldierType = soldierType
	info.level = level
	info.num = num
	info.name = name
	info.soldierAnmationTempleType = soldierAnmationTempleType
end

--设置造兵数据
--buildingPos 建筑位置
--soldierType 士兵类型
--level 等级
--num 数量
--name 名称
--soldierAnmationTempleType 士兵动画模板类型
--返回值(无)
function TimeInfoData:setMakeSoldierInfoByPos(buildingPos,soldierType,level,num,name,soldierAnmationTempleType)
	local info = self:getTimeInfoByBuildingPos(buildingPos)
	if info == nil then
		return
	end

	info.soldierType = soldierType
	info.level = level
	info.num = num
	info.name = name
	info.soldierAnmationTempleType = soldierAnmationTempleType
end

--设置实例id列表
--id_h 定时器id
--id_l 定时器id
--instanceId 实例id
--返回值(无)
function TimeInfoData:setInstanceIdList(id_h,id_l,arryInstanceId)
	local info = self:getTimeInfoById(id_h,id_l)
	if info == nil then
		return
	end

	info.arryInstanceId = arryInstanceId
end

--设置实例id列表
--id_h 定时器id
--id_l 定时器id
--instanceId 实例id
--返回值(无)
function TimeInfoData:setInstanceIds(id_h,id_l,instanceId)
	local info = self:getTimeInfoById(id_h,id_l)
	if info == nil then
		return
	end

	if info.arryInstanceId == nil then
		info.arryInstanceId = {}
	end
	table.insert(info.arryInstanceId,instanceId)
end

--获取定时器通过实例id列表
function TimeInfoData:getInfoByInstanceIdList(arryInstanceId)
	if arryInstanceId == nil or #arryInstanceId == 0 then
		return
	end
	local instanceId = arryInstanceId[1]

	for k,v in pairs(self.timeouts) do
		if v.arryInstanceId ~= nil then
			for i,id in pairs(v.arryInstanceId) do
				if id.id_h == instanceId.id_h and id.id_l == instanceId.id_l then
					return v
				end
			end
		else
			print("找不到定时器实例")
		end
	end
end

--删除定时器通过实例id列表
function TimeInfoData:delInfoByInstanceIdList(arryInstanceId)
	if arryInstanceId == nil or #arryInstanceId == 0 then
		return
	end
	local instanceId = arryInstanceId[1]
	for k,v in pairs(self.timeouts) do
		if v.arryInstanceId ~= nil then
			for i,id in pairs(v.arryInstanceId) do
				if id.id_h == instanceId.id_h and id.id_l == instanceId.id_l then
					self.timeouts[k] = nil
					print("删除了定时器....")
					return
				end
			end
		else
			print("找不到删除的定时器...")
		end
	end
end

--获取剩余时间通过实例ID列表
function TimeInfoData:getLeftTimeByInstanceIdList(arryInstanceId)
	local info = self:getInfoByInstanceIdList(arryInstanceId)
	if info ~= nil then
		local passTime = Common:getOSTime() - info.start_time
		local leftTime = info.interval - passTime
		if leftTime < 0 then
			leftTime = 0
		end
		return leftTime
	end
	return 0
end

--减少剩余时间通过实例id
function TimeInfoData:minusTimeByInstanceIdList(arryInstanceId,changeTime)
	local info = self:getInfoByInstanceIdList(arryInstanceId)
	if info == nil then
		return
	end
	info.interval = info.interval - changeTime
	if info.interval < 0 then
		info.interval = 0
		self:delInfoByInstanceIdList(arryInstanceId)
		return
	end
	return info
end

--设置实例id
--id_h 定时器id
--id_l 定时器id
--instanceId 实例id
--返回值(无)
function TimeInfoData:setInstanceId(id_h,id_l,instanceId)
	local info = self:getTimeInfoById(id_h,id_l)
	if info == nil then
		return
	end

	info.instanceId = instanceId
end

--获取定时器通过实例id
function TimeInfoData:getInfoByInstanceId(instanceId)
	if instanceId == nil then
		return
	end

	for k,v in pairs(self.timeouts) do
		if v.instanceId.id_h == instanceId.id_h and v.instanceId.id_l == instanceId.id_l then
			return v
		end
	end
end

--删除定时器通过实例id
function TimeInfoData:delInfoByInstanceId(instanceId)
	if instanceId == nil then
		return
	end

	for k,v in pairs(self.timeouts) do
		if v.instanceId.id_h == instanceId.id_h and v.instanceId.id_l == instanceId.id_l then
			self.timeouts[k] = nil
			break
		end
	end
end

--获取剩余时间通过实例ID
function TimeInfoData:getLeftTimeByInstanceId(instanceId)
	local info = self:getInfoByInstanceId(instanceId)
	if info ~= nil then
		local passTime = Common:getOSTime() - info.start_time
		local leftTime = info.interval - passTime
		if leftTime < 0 then
			leftTime = 0
		end
		return leftTime
	end
	return 0
end

--减少剩余时间通过实例id
function TimeInfoData:minusTimeByInstanceId(instanceId,changeTime)
	local info = self:getInfoByInstanceId(instanceId)
	if info == nil then
		return
	end
	info.interval = info.interval - changeTime
	if info.interval < 0 then
		info.interval = 0
		self:delInfoByInstanceId(instanceId)
		return
	end
	return info
end

--获取定时器通过action
function TimeInfoData:getTimeByAction(action)
	local arry = {}
    for k,v in pairs(self.timeouts) do
        if v.action == action then
        	table.insert(arry,v)
        end
    end
    return arry
end

--清理缓存数据
--返回值(无)
function TimeInfoData:clearCache()
	self:init()
end



