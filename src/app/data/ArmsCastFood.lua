
--[[
	jinyan.zhang
	士兵每秒消耗粮食
--]]

ArmsCastFood = class("ArmsCastFood")

local instance = nil
local callTime = 60    --每隔60秒调用一次
local minTime = 5      --最小误差时间(秒)

--获取单例
--返回值(单例)
function ArmsCastFood:getInstance()
	if instance == nil then
		instance = ArmsCastFood.new()
	end
	return instance
end

function ArmsCastFood:ctor()
	self:init()
end

function ArmsCastFood:init()
	self.beginTime = Common:getOSTime()
end

--每分钟消耗粮食
function ArmsCastFood:updateCastFood(info)
	local castFood = self:getCastFood()
	self.beginTime = Common:getOSTime()
	PlayerData:getInstance():setPlayerFood(castFood)
	UICommon:getInstance():updateFoodUI()
	NetworkHandler_SyncArmsData:armsCastFoodReq()
	print("前端算的消耗粮食为",castFood,"剩余粮食为:",PlayerData:getInstance():getFood())
end

function ArmsCastFood:getCastFood()
	if self.beginTime == nil then
		return 0
	end

	local total = 0
	local passTime = Common:getOSTime() - self.beginTime
	local arms = ArmsData:getInstance():getSoldierArmsList()
	for k,v in pairs(arms) do
		local config = ArmsAttributeConfig:getInstance():getArmyTemplate(v.type,v.level)
		if config ~= nil then
			total = total + config.aa_burning*v.number*passTime
		end
	end

	return total
end

--收到士兵消耗粮食结果
function ArmsCastFood:recvArmsCastFoodRes(data)
	--时间
	local time = data.time
	--剩余粮食
	local leftFood = data.burnFood
	if time <= 0 then
		PlayerData:getInstance():setLeftFood(leftFood)
		UICommon:getInstance():updateFoodUI()
		print("服务端下发的剩余粮食:",leftFood)
	else
		--暂停消耗粮食定时器
		SpecialTimeMgr:getInstance():pauseTimeTypeInfoByIndex(TimeType.castRes,1,1)
		--修正定时器时间,重新从0开始计时
		SpecialTimeMgr:getInstance():modifTime(TimeType.castRes,1,0)
		--创建修正误差定时器
		SpecialTimeMgr:getInstance():createTime(0,self.upDataModifTime,self,TimeType.castRes,3,time)
		--修正时间值
		self.beginTime = self.beginTime - time
		print("服务端下发的消耗粮食误差时间:",time)

		-- --定时器和服务端的误差时间在某个范围内,就刷新粮食
		-- if time <= minTime then
		-- 	--更新粮食
		-- 	PlayerData:getInstance():setLeftFood(leftFood)
		-- 	UICommon:getInstance():updateFoodUI()
		-- 	--创建修正误差定时器	
		-- 	SpecialTimeMgr:getInstance():createTime(0,self.upDataModifTime2,self,TimeType.castRes,2,time)
		-- else  					--误差太大的情况
		-- 	--创建修正误差定时器
		-- 	SpecialTimeMgr:getInstance():createTime(0,self.upDataModifTime,self,TimeType.castRes,3,time)
		-- end
	end
end

--修正误差时间定时器
function ArmsCastFood:upDataModifTime()
	--删除定时器自己
	SpecialTimeMgr:getInstance():removeTypeInfoByIndex(TimeType.castRes,1,3)
	--恢复每分钟消耗粮食定时器
	SpecialTimeMgr:getInstance():resumeTimeTypeInfoByIndex(TimeType.castRes,1,1)
	--发送消耗粮食请求
	NetworkHandler_SyncArmsData:armsCastFoodReq()
end

--修正误差时间定时器
function ArmsCastFood:upDataModifTime2()
	--删除定时器自己
	SpecialTimeMgr:getInstance():removeTypeInfoByIndex(TimeType.castRes,1,2)
	--恢复每分钟消耗粮食定时器
	SpecialTimeMgr:getInstance():resumeTimeTypeInfoByIndex(TimeType.castRes,1,1)
end

--打开消耗粮食定时器 
function ArmsCastFood:openCastFoodTime()
	SpecialTimeMgr:getInstance():createTime(0,self.updateCastFood,self,TimeType.castRes,1,callTime)
end


