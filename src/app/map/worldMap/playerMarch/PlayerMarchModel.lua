
--[[
	jinyan.zhang
	玩家行军数据
--]]

PlayerMarchModel = class("PlayerMarchModel")

local instance = nil

--构造
--返回值(无)
function PlayerMarchModel:ctor()
	self:init()
end

--初始化
--返回值(无)
function PlayerMarchModel:init()
	self.marchList = {}
end

--获取单例
--返回值(单例)
function PlayerMarchModel:getInstance()
	if instance == nil then
		instance = PlayerMarchModel.new()
	end
	return instance
end

--添加行军信息
--data 数据
--返回值(无)
function PlayerMarchModel:addMarchInfo(data)
	local info = {}
	info.id_h = data.marchingId.id_h
	info.id_l = data.marchingId.id_l
	info.start_time = Common:getOSTime()
	info.mapId = data.mapId
	info.posx = data.posx
	info.posy = data.posy
	info.status = data.status
	info.type = data.type
	info.timeoutid_h = data.timeoudId.timeoutid_h
	info.timeoutid_l = data.timeoudId.timeoutid_l

	info.processIndex = -100
	if info.type == MarchOperationType.reconnaissance then
		local arms = {}
		local armsInfo = {}
		armsInfo.type = OCCUPATION.archer
		armsInfo.level = 1
		armsInfo.number = 1
		table.insert(arms,armsInfo)
		info.arms = arms
	else
		local marchingData =  data.marchingGroup
		local curMarchArms = self:getMarchArms(marchingData.marching)
		local curMarchHeros = PlayerMarchModel:getMarchHero(marchingData.marching)
		self:setHeroState(curMarchHeros,HeroState.battle)
		info.arms = curMarchArms
	end
	self:modifMarchTime(info)

	table.insert(self.marchList,info)
end

--修改行军时间
--marchData 行军数据
--返回值(无)
function PlayerMarchModel:modifMarchTime(marchData)
	local speed = 0
	if marchData.type == MarchOperationType.reconnaissance then
		speed = ArmsData:getInstance():getLookArmsMoveSpeed()
	elseif marchData.type == MarchOperationType.attack then
		speed = ArmsAttributeConfig:getInstance():getMarchMinSpeed(marchData.arms)
	end

	local marchTimeInfo = TimeInfoData:getInstance():getTimeInfoById(marchData.timeoutid_h,marchData.timeoutid_l)
	local dis = Common:calMarchDis(cc.p(marchData.posx,marchData.posy),cc.p(PlayerData:getInstance().x,PlayerData:getInstance().y))
	local marhcTotalTime = dis/speed
	marhcTotalTime = math.floor(marhcTotalTime)
	local passTime = marhcTotalTime - marchTimeInfo.interval
	local startTime = Common:getOSTime() - passTime
	local intervalTime = marhcTotalTime

	TimeInfoData:getInstance():setIntervalAndStartTime(marchData.timeoutid_h,marchData.timeoutid_l,startTime,intervalTime)
end

--保存行军数据
--data 数据 
--返回值(无)
function PlayerMarchModel:setData(data)
	for k,v in pairs(data) do
		self:addMarchInfo(v)
	end
end

--获取行军部队
function PlayerMarchModel:getMarchArms(marchingArms)
	if marchingArms == nil then
		return
	end

	local arry = {}
	for k,v in pairs(marchingArms) do
		--英雄id
		local heroId = v.heroId
		--士兵
		local armsList = v.arms
		for k,arms in pairs(armsList) do
			table.insert(arry,arms)
		end
	end
	return arry
end

--获取行军英雄列表
function PlayerMarchModel:getMarchHero(marchingArms)
	if marchingArms == nil then
		return
	end

	local arry = {}
	for k,v in pairs(marchingArms) do
		--英雄id
		local heroId = v.heroId
		local id = "" .. heroId.id_h .. heroId.id_l
		--士兵
		local armsList = v.arms
		table.insert(arry,id)
	end
	return arry
end

--设置行军英雄状态
function PlayerMarchModel:setHeroState(heroList,state)
	if heroList == nil then
		return
	end

	for k,v in pairs(heroList) do
		local hero = PlayerData:getInstance():getHeroByID(v) 
		if hero ~= nil then
			hero:setState(state)
		end
	end
end

--行军
--data 数据
--返回值(无)
function PlayerMarchModel:syncMarchData(data)
	--定时器
	local timeouts = data.timeouts
	--行军数据
	local marchingData =  data.marchingGroup

	--行军实例id
	local marchingId = marchingData.marchingId
	--地图id
	local mapId = marchingData.mapId
	--x点
	local posx = marchingData.posx
	--y点
	local posy = marchingData.posy
	--状态 0:行军中 1:返回中 2:集结 3:驻扎
	local state = marchingData.status
	--类型 1:驻扎 2:侦查 3:攻击
	local type = marchingData.type
	--定时器ID
	local timeoudId = marchingData.timeoudId
	--行军部队数据
	local marching = marchingData.marching

	local armsId = {}
	armsId.id_h = marchingId.id_h
	armsId.id_l = marchingId.id_l
	local curMarchArms = self:getMarchArms(marching)
	local curMarchHeros = self:getMarchHero(marching)
	self:setHeroState(curMarchHeros,HeroState.battle)

	local timeId = {}
	timeId.id_h = timeouts.id_h
	timeId.id_l = timeouts.id_l

	TimeInfoData:getInstance():delTimeInfoByArmsId(armsId.id_h,armsId.id_l)
	TimeInfoData:getInstance():addTimeInfo(timeouts)
	TimeInfoData:getInstance():setArmsId(timeId.id_h,timeId.id_l,armsId.id_h,armsId.id_l)

  	local arms = {}
	if type == MarchOperationType.attack then  --攻击
		arms = clone(curMarchArms)
	  	--删除部队中的行军部队
		ArmsData:getInstance():delArms(curMarchArms)
		--关闭出征界面
		UIMgr:getInstance():closeUI(UITYPE.GO_BATTLE_CITY)
	elseif type == MarchOperationType.reconnaissance then --侦察
		local armsInfo = {}
		armsInfo.type = OCCUPATION.archer
		armsInfo.level = 1
		armsInfo.number = 1
		table.insert(arms,armsInfo)

    	local playerGridPos = cc.p(PlayerData:getInstance().x,PlayerData:getInstance().y)
    	local targetGridPos = cc.p(posx,posy)
    	local castleInfo = CastleModel:getInstance():getCastleLvByPos(posx,posy,1)
    	local castFood = Common:calCastFood(playerGridPos,targetGridPos,castleInfo.level)
    	local info = {}
    	info.bu_grain = castFood
    	CityBuildingModel:getInstance():castResource(info)
 	end 

	--添加行军数据到行军队伍列表中
	local marchArms = self:addDataToMarchList(marchingData,arms,timeId)
	self:modifMarchTime(marchArms)

	--添加行军队伍表现
	local outCityCtrl = UIMgr:getInstance():getUICtrlByType(UITYPE.OUT_CITY)
	if outCityCtrl ~= nil then
		outCityCtrl:updateMarchUI(marchArms)
	end
end

--行军返回
--data 数据
--返回值(无)
function PlayerMarchModel:marchReturnData(data)
	--定时器
	local timeouts = data.timeouts
	--行军数据
	local marchingData =  data.marchingGroup

	--行军实例id
	local marchingId = marchingData.marchingId
	--地图id
	local mapId = marchingData.mapId
	--x点
	local posx = marchingData.posx
	--y点
	local posy = marchingData.posy
	--状态 0:行军中 1:返回中 2:集结 3:驻扎
	local state = marchingData.status
	--类型 1:驻扎 2:侦查 3:攻击
	local type = marchingData.type
	--定时器ID
	local timeoudId = marchingData.timeoudId
	--行军部队数据
	local marching = marchingData.marching

	local armsId = {}
	armsId.id_h = marchingId.id_h
	armsId.id_l = marchingId.id_l
	local curMarchArms = self:getMarchArms(marching)
	local curMarchHeros = self:getMarchHero(marching)
	self:setHeroState(curMarchHeros,HeroState.battle)

	local timeId = {}
	timeId.id_h = timeouts.id_h
	timeId.id_l = timeouts.id_l

	TimeInfoData:getInstance():delTimeInfoByArmsId(armsId.id_h,armsId.id_l)
	TimeInfoData:getInstance():addTimeInfo(timeouts)
	TimeInfoData:getInstance():setArmsId(timeId.id_h,timeId.id_l,armsId.id_h,armsId.id_l)

  	local arms = {}
	if type == MarchOperationType.attack then   --攻击
		arms = curMarchArms
	elseif type == MarchOperationType.reconnaissance then  --侦察
		local armsInfo = {}
		armsInfo.type = OCCUPATION.archer
		armsInfo.level = 1
		armsInfo.number = 1
		table.insert(arms,armsInfo)
 	end 

  	--添加行军数据到行军队伍列表中
	local marchArms = self:addDataToMarchList(marchingData,arms,timeId)
	self:modifMarchTime(marchArms)

	--添加行军返回表现
	local outCityCtrl = UIMgr:getInstance():getUICtrlByType(UITYPE.OUT_CITY)
	if outCityCtrl ~= nil then
		outCityCtrl:marchReturnResult(marchArms)
	end
end

--完成行军
--data 数据
--返回值(无)
function PlayerMarchModel:finishMarchingResult(data)
	--定时器
	local timeouts = data.timeouts
	--行军数据
	local marchingData =  data.marchingGroup

	--行军实例id
	local marchingId = marchingData.marchingId
	--地图id
	local mapId = marchingData.mapId
	--x点
	local posx = marchingData.posx
	--y点
	local posy = marchingData.posy
	--状态 0:行军中 1:返回中 2:集结 3:驻扎
	local state = marchingData.status
	--类型 1:驻扎 2:侦查 3:攻击
	local type = marchingData.type
	--定时器ID
	local timeoudId = marchingData.timeoudId
	--行军部队数据
	local marching = marchingData.marching

	local armsId = {}
	armsId.id_h = marchingId.id_h
	armsId.id_l = marchingId.id_l
	TimeInfoData:getInstance():delTimeInfoByArmsId(armsId.id_h,armsId.id_l)

	local curMarchArms = self:getMarchArms(marching)
	local curMarchHeros = self:getMarchHero(marching)
	self:setHeroState(curMarchHeros,HeroState.normal)

	--从行军列表中删除行军数据
	local marchArms = {}
	for k,v in pairs(self.marchList) do
		if v.id_h == armsId.id_h and v.id_l == armsId.id_l then
			marchArms = v
			self.marchList[k] = nil
			break
		end
	end

	--行军部队回到城堡,数据重新加回去
	if marchArms.type == MarchOperationType.attack then  --攻击
		ArmsData:getInstance():init()
		ArmsData:getInstance():createArmsList(curMarchArms)
	end

	--完成行军表现
	local outCityCtrl = UIMgr:getInstance():getUICtrlByType(UITYPE.OUT_CITY)
	if outCityCtrl ~= nil then
		outCityCtrl:finishMarchingResult(marchArms)
	end
end

--添加行军队伍至行军列表队伍中
--data 数据
--返回值(行军队伍数据)
function PlayerMarchModel:addDataToMarchList(data,arms,timeId)
	local processIndex = nil
	for k,v in pairs(self.marchList) do
		if v.id_h == data.marchingId.id_h and v.id_l == data.marchingId.id_l then
			processIndex = v.processIndex
			self.marchList[k] = nil
			break
		end
	end

	local marchingInfo = {}
	marchingInfo.id_h = data.marchingId.id_h
	marchingInfo.id_l = data.marchingId.id_l
	marchingInfo.mapId = data.mapId
	marchingInfo.posx = data.posx
	marchingInfo.posy = data.posy
	marchingInfo.status = data.status
	marchingInfo.type = data.type
	marchingInfo.timeoutid_h = timeId.id_h
	marchingInfo.timeoutid_l = timeId.id_l
	marchingInfo.arms = arms
	marchingInfo.processIndex = processIndex
	table.insert(self.marchList,marchingInfo)

	return marchingInfo
end

--获取行军列表
--返回值(行军列表)
function PlayerMarchModel:getData()
	return self.marchList
end

--是否可以行军
function PlayerMarchModel:isCanMarch()
	if #self.marchList > PlayerData:getInstance():getBattleNum() then
		Lan:hintClient(11,"对不起,出征部队已经到达上限,无法再出征",{},3)
		return
	end
	return true
end

--清理缓存数据
--返回值(无)
function PlayerMarchModel:clearCache()
	self:init()
end




