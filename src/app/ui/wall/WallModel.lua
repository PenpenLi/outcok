
--[[
	jinyan.zhang
	城墙数据
--]]

WallModel = class("WallModel")
local instance = nil

--城墙状态
WallState = 
{
	normal = 1, -- 正常
	fire = 2,  --着火
	bad = 3,   --破损
}

--构造
--返回值(无)
function WallModel:ctor()
	self:init()
end

--初始化
--返回值(空)
function WallModel:init()
	self.state = WallState.normal
end

--获取单例
--返回值(单例)
function WallModel:getInstance()
	if instance == nil then
		instance = WallModel.new()
	end
	return instance
end

--获取城墙等级
function WallModel:getWallLevel()
	local buiodingInfo = CityBuildingModel:getInstance():getBuildInfoByType(BuildType.wall)
    if buildingInfo == nil then
        buildingInfo = {}
        buildingInfo.level = 1
    end
    return buildingInfo.level
end

--获取修复城墙冷却时间
function WallModel:getCoolTime()
	return CommonConfig:getInstance():getRepairWallColdTime()
end

--获取灭火需要消耗的金币 
function WallModel:getDelFireCastGold()
	return CommonConfig:getInstance():getDelFireGold()
end

--获取城墙状态
function WallModel:getState()
	return self.state
end

--获取剩余城防值
function WallModel:getDef()
	return self.leftDef
end

--获取城防上限值
function WallModel:getMaxDef()
	local config = WallEffectConfig:getInstance():getConfigByLevel(self:getWallLevel())
    return config.we_defend
end

--获取修复城墙剩余冷却时间
function WallModel:getRepairLeftCoolTime()
	return self.repairLeftTime
end

--打开城墙着火定时器
--leftTime  --剩余时间
function WallModel:openWallFireTime(leftTime)
    local timeInfo = SpecialTimeMgr:getInstance():findTypeInfoByIndex(TimeType.wallFireTime,1,1)
    if not timeInfo then
        local info = {}
        info.index = 1
        info.leftTime = leftTime
        SpecialTimeMgr:getInstance():addInfo(TimeType.wallFireTime, info, 1,self.updateFireTime, self)
    else
        timeInfo.pause = false
        timeInfo.leftTime = leftTime
    end
end

--更新着火时间
--info 数据
function WallModel:updateFireTime(info)
	info.leftTime = info.leftTime - 1
	if info.leftTime <= 0 then
		print("着火剩余时间等于0")
		info.leftTime = 0
		SpecialTimeMgr:getInstance():removeInfo(TimeType.wallFireTime,1)
		self.fire = 0
		--更新城墙UI
		UICommon:getInstance():updateWallUI()
	end
	self.fireLeftTime = info.leftTime

	local config = WallEffectConfig:getInstance():getConfigByLevel(self:getWallLevel())
	self.leftDef = self.leftDef - config.we_firedefend
	if self.leftDef <= 0 then
		self.leftDef = 0
		WallService:getInstance():sendMoveCastleReq()
	end

	local command = UIMgr:getInstance():getUICtrlByType(UITYPE.WALL)
	if command ~= nil then
		command:updateDefValueUI()
	end
end

--打开修复城墙冷却时间定时器
--leftTime  --剩余时间
function WallModel:openRepairWallColdTime(leftTime)
    local timeInfo = SpecialTimeMgr:getInstance():findTypeInfoByIndex(TimeType.wallRepairCoolTime,1,1)
    if not timeInfo then
        local info = {}
        info.index = 1
        info.leftTime = leftTime
        SpecialTimeMgr:getInstance():addInfo(TimeType.wallRepairCoolTime, info, 1,self.updateRepairColdTime, self)
    else
        timeInfo.pause = false
        timeInfo.leftTime = leftTime
    end
end

--更新修复城墙冷却时间
--info 数据
function WallModel:updateRepairColdTime(info)
	info.leftTime = info.leftTime - 1
	if info.leftTime <= 0 then
		print("修复冷却剩余时间等于0")
		info.leftTime = 0
		SpecialTimeMgr:getInstance():removeInfo(TimeType.wallRepairCoolTime,1)
	end
	self.repairLeftTime = info.leftTime

	local command = UIMgr:getInstance():getUICtrlByType(UITYPE.WALL)
	if command ~= nil then
		command:updateRepairCoolTimeUI()
	end
end

function WallModel:setData(data)
	--剩余城防值
	self.leftDef = data.defenseValue
	--最大城防值
	--self.maxDef = data.maxDefense
	--修复剩余时间(秒)
	self.repairLeftTime = data.repairTime
	--燃烧剩余时间(秒)
	self.fireLeftTime = data.fireTime

	local stateDes = "正常"
	if self.fireLeftTime > 0 then  --燃烧
		self.state = WallState.fire
		stateDes = "燃烧"
	elseif self.leftDef < self:getMaxDef() then --破损
		self.state = WallState.bad
		stateDes = "破损"
	else  --正常
		self.state = WallState.normal
		stateDes = "正常"
	end

	print("状态=",stateDes,"城防值",self.leftDef,"修复剩余时间=",self.repairLeftTime,
		"燃烧剩余时间=",self.fireLeftTime,"最大城防值",self:getMaxDef())

	--打开城墙着火定时器(每秒钟扣除城防值)
	if self.fireLeftTime > 0 then
		self:openWallFireTime(self.fireLeftTime)
	else
		SpecialTimeMgr:getInstance():removeInfo(TimeType.wallFireTime,1)
	end

	--打开修复城墙冷却时间定时器(减少冷却时间)
	if self.repairLeftTime > 0 then
		self:openRepairWallColdTime(self.repairLeftTime)
	else
		SpecialTimeMgr:getInstance():removeInfo(TimeType.wallRepairCoolTime,1)
	end
	--更新城墙UI
	UICommon:getInstance():updateWallUI()

	if self.leftDef <= 0 then
		--WallService:getInstance():sendMoveCastleReq()
	end
end

--收到迁城结果
function WallModel:recvMoveCastleRes(data)
	local leftDef = data.defenseValue
	local leftRepairTime = data.repairTime
	local leftFireTime = data.fireTime
	local x = data.posX
	local y = data.posY

	self.leftDef = leftDef
	self.repairLeftTime = leftRepairTime
	self.fireLeftTime = leftFireTime

  --打开城墙着火定时器(每秒钟扣除城防值)
	if self.fireLeftTime > 0 then
		self:openWallFireTime(self.fireLeftTime)
	else
		SpecialTimeMgr:getInstance():removeInfo(TimeType.wallFireTime,1)
	end

	--打开修复城墙冷却时间定时器(减少冷却时间)
	if self.repairLeftTime > 0 then
		self:openRepairWallColdTime(self.repairLeftTime)
	else
		SpecialTimeMgr:getInstance():removeInfo(TimeType.wallRepairCoolTime,1)
	end
	--更新城墙UI
	UICommon:getInstance():updateWallUI()

	if leftDef == 0 then
		print("收到迁城坐标 x=",x,"y=",y)
		PlayerData:getInstance():setCastlePos(x,y)
		MoveCastleAniModel:getInstance():setMoveCastle(true)
	end
end

--收到灭火结果
--data 数据
--返回值(无)
function WallModel:recvDelFireRes(data)
	self:setData(data)

	local castGold = WallModel:getInstance():getDelFireCastGold()
	PlayerData:getInstance():setPlayerMithrilGold(castGold)

	local command = UIMgr:getInstance():getUICtrlByType(UITYPE.WALL)
	if command ~= nil then
		command:delFireRes()
	end
end

--收到修补结果
--data 数据
--返回值(无)
function WallModel:recvRepairRes(data)
	self:setData(data)

	local command = UIMgr:getInstance():getUICtrlByType(UITYPE.WALL)
	if command ~= nil then
		command:repairRes()
	end
end

--获取城墙效果数据
function WallModel:getWallEffectDataRes(data)
	self:setData(data)
end

--收到城墙起火消息
function WallModel:recvNoticeWallFireRes(data)
	self:setData(data)
	
	local command = UIMgr:getInstance():getUICtrlByType(UITYPE.WALL)
	if command ~= nil then
		command:recvNoticeWallFireRes()
	end
end

--添加驻守英雄结果
function WallModel:recvAddHeroRes(data)
	--英雄id
	local heroId = data.obj
	local heroData = PlayerData:getInstance():getHeroById(heroId)
	if heroData ~= nil then
		heroData:setState(HeroState.def)
	end

	local command = UIMgr:getInstance():getUICtrlByType(UITYPE.WALL)
	if command ~= nil then
		command:addHeroRes()
	end
end

--移除驻守英雄结果
function WallModel:recvRemoveHeroRes(data)
	--英雄id
	local heroId = data.obj
	local heroData = PlayerData:getInstance():getHeroById(heroId)
	if heroData ~= nil then
		heroData:setState(HeroState.normal)
	end

	local command = UIMgr:getInstance():getUICtrlByType(UITYPE.WALL)
	if command ~= nil then
		command:delHeroRes()
	end
end

--清理缓存
--返回值(无)
function WallModel:clearCache()
	self:init()
end





