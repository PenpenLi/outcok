
--[[
	jinyan.zhang
	造兵数据
--]]

MakeSoldierModel = class("MakeSoldierModel")
local instance = nil

local _markId = 0

--创建一个标记id
--返回值(id)
function MakeSoldierModel:createMarkId()
	_markId = _markId + 1
	if _markId > 9999 then
		_markId = 1
	end
	return _markId
end

--构造
--返回值(无)
function MakeSoldierModel:ctor()
	self:init()
end

--初始化
--返回值(空)
function MakeSoldierModel:init()
	self.makeSoldierLocalData = {}
	self.readyGetArmsList = {}
end

--获取单例
--返回值(单例)
function MakeSoldierModel:getInstance()
	if instance == nil then
		instance = MakeSoldierModel.new()
	end
	return instance
end

--保存造兵数据
--data 数据
--返回值(无)
function MakeSoldierModel:setData(data)
	for k,v in pairs(data) do
		self:addReadyArmsInfo(v)
	end
end

--保存造兵本地数据
--data 数据
--返回值(无)
function MakeSoldierModel:saveMakeSoldierLocalData(data)
	data.markId = self:createMarkId()
	table.insert(self.makeSoldierLocalData,data)
end

--获取造兵本地数据
--markId 标记id
--返回值(造兵本地数据)
function MakeSoldierModel:getMakeSoldierLocalData(markId)
	for k,v in pairs(self.makeSoldierLocalData) do
		if v.markId == markId then
			return v
		end
	end
end

--删除造兵本地数据
--markId 标记id
--返回值(无)
function MakeSoldierModel:delMakeSoldierLocalData(markId)
	for k,v in pairs(self.makeSoldierLocalData) do
		if v.markId == markId then
			self.makeSoldierLocalData[k] = nil
			break
		end
	end
end

--造兵
--data 数据
--info 之前保存的本地数据
--返回值(无)
function MakeSoldierModel:syncMakeSoldiersData(data,info)
	TimeInfoData:getInstance():detTimeInfoById(data.id_h,data.id_l)
	TimeInfoData:getInstance():addTimeInfo(data)
	TimeInfoData:getInstance():setMakeSoldierInfo(data.id_h,data.id_l,info.buildingPos,info.soldierType,info.lv,info.num,info.name,info.soldierAnmationTempleType)

	local buildingType = CityBuildingModel:getInstance():getBuildType(info.buildingPos)
	if buildingType == BuildType.fortress then  --堡垒
		FortressModel:getInstance():castResource(info.soldierType,info.lv)
		UIMgr:getInstance():closeUI(UITYPE.FORTRESS)
		UIMgr:getInstance():closeUI(UITYPE.BUILDING_MENU)
	else
		--士兵需要消耗的材料
		self:makeSoldierCost(info.soldierType,info.lv,info.num)
		UIMgr:getInstance():closeUI(UITYPE.TRAINING_CITY)
		UIMgr:getInstance():closeUI(UITYPE.BUILDING_MENU)
	end	

	--刷新地图上的建筑
	local cityBuildingListCtrl = MapMgr:getInstance():getCityBuildingListCtrl()
	if cityBuildingListCtrl ~= nil then
		if buildingType == BuildType.fortress then  --堡垒
			cityBuildingListCtrl:createFortressTimeUI(info.buildingPos)
		else
			cityBuildingListCtrl:createMakeSoilderUI(info.buildingPos,data.start_time,data.interval,info.soldierAnmationTempleType)
		end
	end
	UICommon:getInstance():updatePlayerDataUI()
end

--士兵需要消耗的材料
function MakeSoldierModel:makeSoldierCost(arms_type,level,num)
	-- 根据等级和类型获取士兵配置模板
	local armyTemplate = ArmsAttributeConfig:getInstance():getArmyTemplate(arms_type, level)

	local cityCtrl = UIMgr:getInstance():getUICtrlByType(UITYPE.CITY)
	if cityCtrl ~= nil then
		cityCtrl:updateBymakeSoldier(armyTemplate, num)
	end
end

--完成造兵
--data 数据
--返回值(无)
function MakeSoldierModel:syncMakeSoldiersFinishData(data)
	local buildingPos = data.buildingPos
	local info = TimeInfoData:getInstance():getTimeInfoByBuildingPos(buildingPos)
	if info ~= nil then
		self:setHaveReadyArms(data.buildingPos,1,info.typeId,info.level,info.num,info.name,info.soldierAnmationTempleType)
	else
		self:setHaveReadyArms(data.buildingPos,1)
	end
	TimeInfoData:getInstance():delTimeInfoByBuildingPos(buildingPos)
	
	--刷新地图上的建筑
	local cityBuildingListCtrl = MapMgr:getInstance():getCityBuildingListCtrl()
	if cityBuildingListCtrl ~= nil then
		local buildingType = CityBuildingModel:getInstance():getBuildType(buildingPos)
		if buildingType == BuildType.fortress then  --堡垒
			cityBuildingListCtrl:finishFortressMakeTrap(buildingPos)
		else
			cityBuildingListCtrl:finishMakeSoldiers(buildingPos)
		end
	end
end

--添加准备读取部队信息
--data 数据
--返回值(无)
function MakeSoldierModel:addReadyArmsInfo(data)
	local info = {}
	info.buildingPos = data.pos
	info.finish = data.finish
	info.soldierType = data.arms.type
	info.level = data.arms.level
	info.num = data.arms.number
	local buildingType = CityBuildingModel:getInstance():getBuildType(info.buildingPos)
	info.soldierAnmationTempleType = ArmsData:getInstance():getDefaultSoldierAnmationTempleTypeByBuildingType(buildingType)
	if info.soldierType <= OCCUPATION.master then
		info.name = ArmsData:getInstance():getSoldierNameByTypeAndLv(info.soldierType,info.level)
	else
		info.name = ArmsData:getInstance():getOccupatuinName(info.soldierType,info.level)
	end
	table.insert(self.readyGetArmsList,info)
	TimeInfoData:getInstance():setMakeSoldierInfoByPos(info.buildingPos,info.soldierType,info.level,info.num,info.name,info.soldierAnmationTempleType)
end

--设置是否有造兵完成后未点击的部队
--buildingPos 建筑位置
--result 结果(1:有未读取,0:没有未读取)
--typeId 士兵类型
--level 等级
--num 数量
--name 名字
--soldierAnmationTempleType 士兵动画模板类型
--返回值(无)
function MakeSoldierModel:setHaveReadyArms(buildingPos,result,soldierType,level,num,name,soldierAnmationTempleType)
	if result == 1 then
		for k,v in pairs(self.readyGetArmsList) do
			if v.buildingPos == buildingPos then
				self.readyGetArmsList[k] = nil
				break
			end
		end
		local info = {}
		info.finish = BuidState.FINISH
		info.buildingPos = buildingPos
		info.soldierType = soldierType
		info.level = level
		info.num = num
		info.name = name
		info.soldierAnmationTempleType = soldierAnmationTempleType
		table.insert(self.readyGetArmsList,info)
	else
		for k,v in pairs(self.readyGetArmsList) do
			if v.buildingPos == buildingPos then
				self.readyGetArmsList[k] = nil
				break
			end
		end
	end
end

--获取待取兵数据
--buildingPos 建筑位置
--返回值(数据)
function MakeSoldierModel:getReadyArmsInfo(buildingPos)
	for k,v in pairs(self.readyGetArmsList) do
		if v.buildingPos == buildingPos then
			return v
		end
	end
end

--是否有造完后未点击的部队
--buildingPos 建筑位置
--返回值(true:是,false:否)
function MakeSoldierModel:isHaveReadyArms(buildingPos)
	for k,v in pairs(self.readyGetArmsList) do
		if v.buildingPos == buildingPos and v.finish == BuidState.FINISH then
			return true
		end
	end
	return false
end

--获取造兵
--data 数据
--返回值(无)
function MakeSoldierModel:syncGetMakeSoldiersData(data)
	local arms = data.arms
	-- 替换单个军队信息
	ArmsData:getInstance():replaceInfoNoIncreaseBattle(arms)

	local buildingType = ArmsData:getInstance():getBuildingTypeBySoldierJob(arms.type)
	if arms.type > OCCUPATION.master then
		buildingType = BuildType.fortress
	end

	local buildingPos = CityBuildingModel:getInstance():getBuildingPos(buildingType)
	self:setHaveReadyArms(buildingPos,0)
	local makeAnmationType = 6
  	local config = ArmsAttributeConfig:getInstance():getArmyTemplate(arms.type,1)	
  	if config ~= nil then
  		makeAnmationType = config.aa_subtype
    end	

	if data.fightforce ~= 0 then
		PlayerData:getInstance():increaseBattleForce(data.fightforce)
	end

	--刷新地图上的建筑
	local cityBuildingListCtrl = MapMgr:getInstance():getCityBuildingListCtrl()
	if cityBuildingListCtrl ~= nil then
		if buildingType == BuildType.fortress then  --堡垒
			cityBuildingListCtrl:getMakeTrapUI(buildingPos,makeAnmationType,arms.number,arms.level)
		else
			cityBuildingListCtrl:getMakeSoldiers(buildingPos,makeAnmationType,arms.number,arms.level)
		end
	end
	UICommon:getInstance():updatePlayerDataUI()
end

--取消训练结果
--data 数据
--返回值(无)
function MakeSoldierModel:cancelTrainRes(data)
	local food = data.food
	local wood = data.wood	
	local iron = data.iron
	local mithril = data.mithril
	local buildingPos = data.pos
	TimeInfoData:getInstance():delTimeInfoByBuildingPos(buildingPos)

	PlayerData:getInstance():increaseFood(food)
    PlayerData:getInstance():increaseWood(wood)
    PlayerData:getInstance():increaseIron(iron)
    PlayerData:getInstance():increaseMithril(mithril)
    UIMgr:getInstance():closeUI(UITYPE.BUILDING_MENU)

    --刷新地图上的建筑
	local cityBuildingListCtrl = MapMgr:getInstance():getCityBuildingListCtrl()
	if cityBuildingListCtrl ~= nil then
		local buildingType = CityBuildingModel:getInstance():getBuildType(buildingPos)
		if buildingType == BuildType.fortress then  --堡垒
			cityBuildingListCtrl:cancelMakeTrap()
		else
			cityBuildingListCtrl:cancelTrainRes(buildingPos)
		end
	end
	UICommon:getInstance():updatePlayerDataUI()
end

--解雇士兵结果
--data 数据
--返回值(无)
function MakeSoldierModel:fireSoldierRes(data)
	local fightForce = data.fightForce
	local arms = data.arms
	ArmsData:getInstance():replaceInfoNoIncreaseBattle(arms)
	PlayerData:getInstance():minusBattleForce(fightForce)

	if arms.type > OCCUPATION.master then  --堡垒
		UIMgr:getInstance():closeUI(UITYPE.FORTRESS)
		UIMgr:getInstance():closeUI(UITYPE.BUILDING_MENU)
	else
		UIMgr:getInstance():closeUI(UITYPE.TRAINING_CITY)
		UIMgr:getInstance():closeUI(UITYPE.BUILDING_MENU)
	end
	UICommon:getInstance():updatePlayerDataUI()
end

--清理缓存
--返回值(无)
function MakeSoldierModel:clearCache()
	self:init()
end





