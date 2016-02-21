--
-- Author: oyhc
-- Date: 2015-11-04 15:08:01
--

ArmsData = class("ArmsData")

local instance = nil

--构造
--返回值(无)
function ArmsData:ctor(data)
	self:init(data)
end

--获取单例
--返回值(单例)
function ArmsData:getInstance()
	if instance == nil then
		instance = ArmsData.new()
	end
	return instance
end

--初始化
--返回值(无)
function ArmsData:init(data)
	--军队列表
	self.armsList = {}
end

function ArmsData:clearCache()
	self:init()
end

--获取军队列表(包括陷井)
function ArmsData:getList()
	return self.armsList
end

--获取士兵列表(5种职业士兵)
function ArmsData:getSoldierArmsList()
	local arry = {}
	for k,v in pairs(self.armsList) do
		if v.type <= 5 then 
			table.insert(arry,v)
		end
	end
	return arry
end

--军队列表
-- list 服务器下发的列表
function ArmsData:createArmsList(list)
	for k,v in pairs(list) do
		local info = self:createInfo(v)
		-- 添加到self.armsList
		self:addInfo(info)
	end
end

-- 军队列表数据
-- content 服务器下发json解析出来的数据（table）
-- 返回值 军队数据
function ArmsData:createInfo(content)
	local info = {}
	-- 类型ID （配置表ID）
	info.type = content.type
	-- 兵等级
	info.level = content.level
	-- 兵数量
	info.number = content.number
	-- 消耗粮食
	info.consumption = content.consumption
	-- 增加多少战力
	info.fightforce = content.fightforce
	-- 添加到self.armsList
	-- table.insert(self.armsList,info)
	return info
end

-- 根据士兵类型和等级获取军队
-- type 士兵类型
-- level 等级
-- 返回值 军队数据
function ArmsData:getInfoByTypeAndLevel(type,level)
	for k,v in pairs(self.armsList) do
		-- 判断军队的类型和等级
		if type == v.type and level == v.level then
			return v
		end
	end
end

-- 根据士兵类型和等级获取军队
-- index 数组索引
-- info 军队
function ArmsData:getInfoByIndex(index)
	for k,v in pairs(self.armsList) do
		if index == k then
			return v
		end
	end
end

-- 根据士兵类型和等级添加数量
-- info 军队
function ArmsData:addInfo(info)
	table.insert(self.armsList,info)
end

-- 替换单个军队信息
-- info 军队
function ArmsData:replaceInfo(info)
	for k,v in pairs(self.armsList) do
		-- 判断军队的类型和等级
		if info.type == v.type and info.level == v.level then
			self.armsList[k] = info
			local config = ArmsAttributeConfig:getInstance():getArmyTemplate(info.type,info.level)
			if config ~= nil then
				local addForce = config.aa_fightforce*v.number
				PlayerData:getInstance():increaseBattleForce(addForce)
			end
			return
		end
	end
	-- 如果arms里面找不到就添加
	self:addInfo(info)
  local config = ArmsAttributeConfig:getInstance():getArmyTemplate(info.type,info.level)
  if config ~= nil then
      local addForce = config.aa_fightforce*info.number
      PlayerData:getInstance():increaseBattleForce(addForce)
  end
end

-- 替换单个军队信息
-- info 军队
function ArmsData:replaceInfoNoIncreaseBattle(info)
	for k,v in pairs(self.armsList) do
		-- 判断军队的类型和等级
		if info.type == v.type and info.level == v.level then
			self.armsList[k] = info
			return
		end
	end
	-- 如果arms里面找不到就添加
	self:addInfo(info)
end

-- 替换多个军队信息
-- arms 部队
-- 返回值(无)
function ArmsData:replaceArmsData(arms)
	for k,v in pairs(arms) do
		self:replaceInfo(v)
	end
end

--添加部队
--arms 部队数据
--返回值(无)
function ArmsData:addArmsNoChangeForce(arms)
	for k,v in pairs(arms) do
		self:addInfoOrChangeNumber(v)
	end
end

-- 根据士兵类型和等级添加数量（如果要减数量要传负数）
-- info 军队数据
function ArmsData:addInfoOrChangeNumber(info)
	for k,v in pairs(self.armsList) do
		-- 判断军队的类型和等级
		if info.type == v.type and info.level == v.level then
			v.number = v.number + info.number
			return
		end
	end
	-- self.armsList 里面找不到就添加
	self:addInfo(info)
end

--添加部队
--arms 部队数据
--返回值(无)
function ArmsData:addArms(arms)
	for k,v in pairs(arms) do
		self:addInfoByType(v)
	end
end

-- 根据士兵类型和等级添加军队
-- type 士兵类型
-- level 等级
-- number 数量（要减多少数量）
function ArmsData:addInfoByType(info)
	for k,v in pairs(self.armsList) do
		-- 判断军队的类型和等级
		if info.type == v.type and info.level == v.level then
			local config = ArmsAttributeConfig:getInstance():getArmyTemplate(info.type,info.level)
			if config ~= nil then
				local addForce = config.aa_fightforce*info.number
				PlayerData:getInstance():increaseBattleForce(addForce)
			end
			v.number = v.number + info.number
			return
		end
	end

   	-- 如果arms里面找不到就添加
  	self:addInfo(info)
  local config = ArmsAttributeConfig:getInstance():getArmyTemplate(info.type,info.level)
  if config ~= nil then
      local addForce = config.aa_fightforce*info.number
      PlayerData:getInstance():increaseBattleForce(addForce)
  end
end

-- 根据士兵类型和等级删除军队
-- type 士兵类型
-- level 等级
function ArmsData:delInfoByTypeAndLevel(type,level)
	for k,v in pairs(self.armsList) do
		-- 判断军队的类型和等级
		if type == v.type and level == v.level then
			table.remove(self.armsList,k)
			break
		end
	end
end 

--删除部队
--arms 部队数据
--返回值(无)
function ArmsData:delArms(arms)
	for k,v in pairs(arms) do
		self:delInfoOrChangeNumber(v.type,v.level,v.number)
	end
end

-- 根据士兵类型和等级删除军队
-- type 士兵类型
-- level 等级
-- number 数量（要减多少数量）
function ArmsData:delInfoOrChangeNumber(type,level,number)
	for k,v in pairs(self.armsList) do
		-- 判断军队的类型和等级
		if type == v.type and level == v.level then
			local config = ArmsAttributeConfig:getInstance():getArmyTemplate(type,level)
			if config ~= nil then
				local loseForce = config.aa_fightforce*number
				PlayerData:getInstance():minusBattleForce(loseForce)
			end

			if number >= v.number then
				table.remove(self.armsList,k)
			else
				v.number = v.number - number
			end
			break
		end
	end
end

-- 根据士兵类型和等级删除军队
-- index 数组索引
function ArmsData:delInfoByIndex(index)
	for k,v in pairs(self.armsList) do
		if index == k then
			table.remove(self.armsList,k)
			break
		end
	end
end

-- 获取军队所有士兵的数量
-- 返回值 军队所有士兵的数量
function ArmsData:getTotalNumber()
	local num = 0
	for k,v in pairs(self.armsList) do
		num = num + v.number
	end
	return num
end

-- 根据士兵类型和等级获取军队数量
-- type 士兵类型
-- level 等级
-- 返回值 士兵的数量
function ArmsData:getNumberByTypeAndLevel(type,level)
	for k,v in pairs(self.armsList) do
		-- 判断军队的类型和等级
		if type == v.type and level == v.level then
			return v.number
		end
	end
	return 0
end

--获取职业名称
--occupation 士兵职业类型
--level 等级
--返回值(职业名称)
function ArmsData:getOccupatuinName(occupation,level)
	if level == nil then
		return CommonStr.OCCUPATION_NAME[occupation].name
	end
	return "" .. level .. CommonStr.LEVEL .. CommonStr.OCCUPATION_NAME[occupation].name
end

--士兵类型转职业类型
--soldierType 士兵类型
--返回值(职业类型)
function ArmsData:soldierTypeToOccupation(soldierType)
    if soldierType == SOLDIER_TYPE.shieldSoldier or soldierType == SOLDIER_TYPE.marines then
        return OCCUPATION.footsoldier
    elseif soldierType == SOLDIER_TYPE.knight or soldierType == SOLDIER_TYPE.bowCavalry then
        return OCCUPATION.cavalry
    elseif soldierType == SOLDIER_TYPE.archer or soldierType == SOLDIER_TYPE.crossbowmen then
        return OCCUPATION.archer
    elseif soldierType == SOLDIER_TYPE.tank or soldierType == SOLDIER_TYPE.catapult then
        return OCCUPATION.tank
    elseif soldierType == SOLDIER_TYPE.master or soldierType == SOLDIER_TYPE.warlock then
        return OCCUPATION.master
    elseif soldierType == SOLDIER_TYPE.arrowTower then
    	return OCCUPATION.arrowTower
    elseif soldierType == SOLDIER_TYPE.magicTower then
    	return OCCUPATION.magicPagoda
    elseif soldierType == SOLDIER_TYPE.turretTower then
    	return OCCUPATION.turret
    end
    --print("error:士兵类型转职业类型失败",soldierType)
end

--获取士兵职业通过建筑类型
--buildingType 建筑类型
--返回值(士兵职业)
function ArmsData:getSoldierJobByBuildingType(buildingType)
	if buildingType == BuildType.infantryBattalion then
		return OCCUPATION.footsoldier
	elseif buildingType == BuildType.cavalryBattalion then
		return OCCUPATION.cavalry
	elseif buildingType == BuildType.archerCamp then
		return OCCUPATION.archer
	elseif buildingType == BuildType.chariotBarracks then
		return OCCUPATION.tank
	elseif buildingType == BuildType.masterBarracks then
		return OCCUPATION.master
	end
end

--获取默认的造兵类型通过职业
--job 士兵职业
--返回值(士兵类型)
function ArmsData:getDefaultMakeSoldierTypeByJob(job)
	local config = ArmsAttributeConfig:getInstance():getArmyTemplate(job,1)
  if config ~= nil then
    	return config.aa_subtype
  end
end

--获取默认的造兵动画模板类型通过建筑类型
--buildingType 建筑类型
--返回值(士兵类型)
function ArmsData:getDefaultSoldierAnmationTempleTypeByBuildingType(buildingType)
	local job = self:getSoldierJobByBuildingType(buildingType)
	return self:getDefaultMakeSoldierTypeByJob(job)
end

--获取建筑类型通过士兵职业
--job 士兵职业
--返回值(建筑类型)
function ArmsData:getBuildingTypeBySoldierJob(job)
	if job == OCCUPATION.footsoldier then
		return BuildType.infantryBattalion
	elseif job == OCCUPATION.cavalry then
		return BuildType.cavalryBattalion
	elseif job == OCCUPATION.archer then
		return BuildType.archerCamp
	elseif job == OCCUPATION.tank then
		return BuildType.chariotBarracks
	elseif job == OCCUPATION.master then
		return BuildType.masterBarracks
	end
end

--获取士兵名称
--soldierType --士兵类型
--lv 等级
--返回值(士兵名称)
function ArmsData:getSoldierName(soldierType,lv)
	if soldierType == nil then
		return
	end

	local info = CommonStr.SOLDIER_NAME[soldierType]
	if info ~= nil then
		if lv ~= nil then
			return "" .. lv .. CommonStr.LEVEL .. info.name
		else
			return info.name
		end
	end
end

--获取侦察部队移动速度
--返回值(移动速度)
function ArmsData:getLookArmsMoveSpeed()
	return 50*3
end

--获取士兵名称
--type 士兵类型
--level 等级
function ArmsData:getSoldierNameByTypeAndLv(type,level)
	local tempeleInfo = ArmsAttributeConfig:getInstance():getArmyTemplate(type,level)
	if tempeleInfo ~= nil then
		return self:getSoldierName(tempeleInfo.aa_subtype,tempeleInfo.aa_level)
	end
end

--获取排序后的部队列表
--返回值(部队列表)
function ArmsData:getAfterSortArms()
	local soldierList = {}
	for k,v in pairs(ArmsData:getInstance():getList()) do
		-- 根据等级和类型获取士兵配置模板
		local armyTemplate = ArmsAttributeConfig:getInstance():getArmyTemplate(v.type,v.level)
		if armyTemplate ~= nil then
			soldierList[k] = {}
			soldierList[k].type = armyTemplate.aa_subtype
			soldierList[k].number = v.number
		else
			--todo 临时处理一下
			-- soldierList[k] = {}
			-- soldierList[k].type = 6
			-- soldierList[k].number = v.number
		end
	end
	return soldierList
end

--是否有某种类型的士兵
--arms 行军中的部队
--soldierJob 士兵职业
--返回值(true:有,false:没有)
function ArmsData:isHaveSomeTypeSolider(arms,soldierJob)
	for k,v in pairs(arms) do
		if v.type == soldierJob then
			return true
		end
	end
	return false
end

--获取排序后的士兵类型
--arms 行军中的部队
--返回值(排序后的士兵类型列表)
function ArmsData:getSortSoldier(arms)
	local index = 1
	tab = {}

	local isHaveBuBin = self:isHaveSomeTypeSolider(arms,OCCUPATION.footsoldier)
	if isHaveBuBin then
		tab[index] = {}
		tab[index].soldierType = SOLDIER_TYPE.shieldSoldier
		tab[index].count = 4
		index = index + 1
	end

	local isHaveQiBin = self:isHaveSomeTypeSolider(arms,OCCUPATION.cavalry)
	if isHaveQiBin then
		tab[index] = {}
		tab[index].soldierType = SOLDIER_TYPE.bowCavalry
		tab[index].count = 4
		index = index + 1
	end

	local isHaveGonBin = self:isHaveSomeTypeSolider(arms,OCCUPATION.archer)
	if isHaveGonBin then
		tab[index] = {}
		tab[index].soldierType = SOLDIER_TYPE.archer
		tab[index].count = 3
		index = index + 1
	end

	local isHaveFaShiBin = self:isHaveSomeTypeSolider(arms,OCCUPATION.master)
	if isHaveFaShiBin then
		tab[index] = {}
		tab[index].soldierType = SOLDIER_TYPE.warlock
		tab[index].count = 3
		index = index + 1
	end

	local isHaveZhanCheBin = self:isHaveSomeTypeSolider(arms,OCCUPATION.tank)
	if isHaveZhanCheBin then
		tab[index] = {}
		tab[index].soldierType = SOLDIER_TYPE.catapult
		tab[index].count = 2
		index = index + 1
	end

	return tab
end

--获取所有的陷井数量
function ArmsData:getAllTrapCount()
	local total = 0
	for k,v in pairs(self.armsList) do
		if v.type > OCCUPATION.master then
			total = total + v.number
		end
	end
	return total
end

--获取士兵每个小时消耗掉总量
function ArmsData:getAllCost()
	local total = 0
	for k,v in pairs(self.armsList) do
		local num = ArmsAttributeConfig:getInstance():getArmyCost(v.type,v.level) * 60 * 60
		total = total + num
	end
	return total
end

--职业
OCCUPATION =
{
	footsoldier = 1,   --步兵
	cavalry = 2,       --骑兵
	archer = 3,        --弓兵
	tank = 4,          --战车兵
	master = 5,        --法师
	arrowTower = 6,    --箭塔类
	turret = 7, 	   --炮塔
	magicPagoda = 8,   --魔法塔
	fallingRocks = 9,  --落石
	rocket = 10, 		--火箭
	bowling = 11,      --滚木

	trap = 12,          --陷井
}

--士兵类型
SOLDIER_TYPE =
{
	shieldSoldier = 1,  --盾兵
	tank = 2,           --冲车
	marines = 3,        --枪兵
	knight = 4,         --骑士
	crossbowmen = 5,    --弩兵
	archer = 6,         --弓兵
	bowCavalry = 7,     --弓骑兵
	master = 8,         --法师
	warlock = 9,        --术士
	catapult = 10,      --投石车

	arrowTower = 11,    --箭塔
	magicTower = 12,    --魔法塔
	turretTower = 13,   --炮塔
	trap = 14,		    --陷井
	CASTLE = 15, 		--城堡
}



