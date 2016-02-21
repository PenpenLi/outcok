
--[[
	jinyan.zhang
	玩家数据
--]]

PlayerData = class("PlayerData")
local instance = nil

--构造
--返回值(无)
function PlayerData:ctor()
	self:init()
end

--获取单例
--返回值(单例)
function PlayerData:getInstance()
	if instance == nil then
		instance = PlayerData.new()
	end
	return instance
end

--初始化
--返回值(无)
function PlayerData:init()
	self.heroList = {} --英雄列表
	self.x = 10
	self.y = 10
	-- 金币
	self.gold = 0
	-- 食物
	self.food = 0
	--木材
	self.wood = 0
	-- 铁矿
	self.iron = 0
	-- 秘银
	self.mithril = 0
	-- 战斗力
	self.fightforce = 0
	-- 等级
	self.level = 1
	-- 经验
	self.exp = 0
	-- 地图id
	self.map_id = 1
	-- 添加的英雄训练个数
	self.addheroTrainNum = 0
	-- 体力
	self.lordPower = 0
	-- 添加的出征数量
	self.addBattleNum = 0
	-- 天赋点数
	self.talentPoint = 0
end

-- 获取天赋点数
function PlayerData:getTalentPoint()
	return self.talentPoint
end

-- 设置天赋点数
-- num 最终值
function PlayerData:setTalentPoint(num)
	self.talentPoint = num
end

-- 改变天赋点数
-- num 添加传正数 减少传负数
function PlayerData:changeTalentPoint(num)
	self.talentPoint = self.talentPoint + num
end

-- 获取出征数量
function PlayerData:getBattleNum()
	return CommonConfig:getInstance():getBattleNum() + self.addBattleNum
end

-- 设置出征数量
-- num 添加传正数 减少传负数
function PlayerData:changeBattleNum(num)
	self.addBattleNum = self.addBattleNum + num
end

-- 获取领主体力
function PlayerData:getLordPower()
	return self.lordPower
end

-- 设置领主体力
-- num 最终值
function PlayerData:setLordPower(num)
	self.lordPower = num
end

-- 设置领主体力
-- num 添加传正数 减少传负数
function PlayerData:changeLordPower(num)
	self.lordPower = self.lordPower + num
end

-- 获取英雄训练个数
function PlayerData:getHeroTrainNum()
	local num = 0
	-- 根据建筑类型获取建筑信息
	local buildInfo = CityBuildingModel:getInstance():getBuildInfoByType(BuildType.trainingCamp)
	if buildInfo ~= nil then
		-- 根据建筑等级获取英雄训练个数
		local trainNum = TrainEffectConfig:getInstance():getTrainNumByLevel(buildInfo.level)
		num = trainNum + self.addheroTrainNum
	else
		num = self.addheroTrainNum
	end
	return num
end

-- 设置英雄训练个数
-- num 添加传正数 减少传负数
function PlayerData:changeHeroTrainNum(num)
	self.addheroTrainNum = self.addheroTrainNum + num
end

--保存服务端下发的角色信息
--data 数据
--返回值(无)
function PlayerData:setData(data)
	self.account = data.account  --账号
	self.name = data.name   --角色名
	self.image_id = data.image_id  --游戏角色头像
	self.level = data.level  --角色等级
	self.exp = data.exp  --角色经验
	self.map_id = data.map_id  --角色地图位置
	self.x = data.x  --角色X坐标
	self.y = data.y  --角色y坐标
	self.food = data.food  --角色食物资源
	self.wood = data.wood --角色木材资源
	self.iron = data.iron  --角色铁矿资源
	self.mithril = data.mithril  --角色秘银资源
	self.gold = data.gold  --角色金币（充值货币)
	self.talentPoint = data.talent_point -- 天赋点数
	self.lordPower = data.power -- 领主体力
	self.fightforce = data.fightforce
	TimeInfoData:getInstance():setData(data.timeouts)
	PlayerMarchModel:getInstance():setData(data.marchingGroup)
	CityBuildingModel:getInstance():setBuildingData(data)
	MakeSoldierModel:getInstance():setData(data.readyArmsList)
	TreatmentModel:getInstance():setData()
	ArmsData:getInstance():createArmsList(data.arms) --新军队
	UseGoldAcceResProduceModel:getInstance():addResInfo(data.resource)
	CopyModel:getInstance():setData(data.attribute.duplicatePass)
	MoveCastleAniModel:getInstance():setMoveCastleData(data.moveKingdom)
	UnLockAreaModel:getInstance():setUnLockList(data.attribute.unlockArea)

	for i=1,#data.heroes do
		local hero = HeroData.new(data.heroes[i],i)
		self:addHero(hero)
	end

  	local mailid = data.mail_ids
	MailsModel:getInstance():setUnReadMailCount(data.unopened_count)
end

-- 设置等级
function PlayerData:setPlayerLevel(level)
	self.level = level
end

-- 获取等级
function PlayerData:getPlayerLevel()
	return self.level
end

-- 设置名字
function PlayerData:setPlayerName(name)
	self.name = name
end

-- 获取名字
function PlayerData:getPlayerName()
	return self.name
end

--设置玩家城堡位置
function PlayerData:setCastlePos(x,y)
	self.x = x  --角色X坐标
	self.y = y  --角色y坐标
end

--获取玩家城堡位置
function PlayerData:getCastlePos()
	return self.x,self.y
end

-- 获取英雄列表
function PlayerData:getHeroList()
	return self.heroList
end

--设置战斗力
function PlayerData:setFightForce(battleForce)
	self.fightforce = battleForce
end

--获取战斗力
function PlayerData:getFightForce()
	return self.fightforce
end

--增加战斗力
--battleForce 战斗力
--返回值(无)
function PlayerData:increaseBattleForce(battleForce)
	self.fightforce = self.fightforce + battleForce
end

--减少战斗力
--battleForce 战斗力
--返回值(无)
function PlayerData:minusBattleForce(battleForce)
	self.fightforce = self.fightforce - battleForce
end

--设置木材
function PlayerData:setPlayerWood(wood)
	self.wood = self.wood - wood
end

--设置粮食
function PlayerData:setPlayerFood(food)
	self.food = self.food - food
	if self.food <= 0 then
		self.food = 0
	end
end

--设置剩余粮食
function PlayerData:setLeftFood(food)
	self.food = food
end

--获取粮食
function PlayerData:getFood()
	return self.food
end

--设置铁矿
function PlayerData:setPlayerIron(iron)
	self.iron = self.iron - iron
end

--设置秘银
function PlayerData:setPlayerMithril(mithril)
	self.mithril = self.mithril - mithril
end

--设置金币
function PlayerData:setPlayerMithrilGold(gold)
	self.gold = self.gold - gold
end

--设置金币
function PlayerData:setPlayerGold(gold)
	self.gold = gold
end

--增加食物
--food 食物
function PlayerData:increaseFood(food)
	self.food = self.food + food
end

--增加木材
--wood 木材
function PlayerData:increaseWood(wood)
	self.wood = self.wood + wood
end

--增加铁矿
--iron 铁矿
function PlayerData:increaseIron(iron)
	self.iron = self.iron + iron
end

--增加秘银
--mithril 秘银
function PlayerData:increaseMithril(mithril)
	self.mithril = self.mithril + mithril
end

--根据唯一id查找英雄
--id 唯一id
function PlayerData:getHeroByID(id)
	for k,v in pairs(self.heroList) do
		if v.id == id then
			return v
		end
	end
	print("找不到唯一id为"..id.."的英雄")
end

--根据唯一id查找英雄索引
--id 唯一id
function PlayerData:getHeroIndexByID(id)
	for i=1,#self.heroList do
		local v = self.heroList[i]
		if v.id == id then
			return i
		end
	end
end

-- 添加英雄
function PlayerData:addHero(info)
	table.insert(self.heroList,info)
end

-- 根据唯一id删除英雄
-- 唯一id
function PlayerData:delHero(id)
	for k,v in pairs(self.heroList) do
		if id == v.id then
			table.remove(self.heroList,k)
			break
		end
	end
end

--重置所有英雄出征军队
function PlayerData:resetAllHeroArmy()
	for k,v in pairs(self.heroList) do
		v:resetHeroArmy()
	end
end

-- 获取所有的士兵
function PlayerData:getAllArms()
	local allArms = {}
	for k,v in pairs(self.heroList) do
		for k1,v1 in pairs(v:getArmy()) do
			table.insert(allArms,v1)
		end
	end
	return allArms
end

-- 获取所有的士兵数量
function PlayerData:getAllArmsNum()
	local num = 0
	local allArms = self:getAllArms()
	for k,v in pairs(allArms) do
		num = num + v.number
	end
	return num
end

-- 获取所有的士兵负重
function PlayerData:getAllArmsWeight()
	local num = 0
	local allArms = self:getAllArms()
	for k,v in pairs(allArms) do
		local template = ArmsAttributeConfig:getInstance():getArmyTemplate(v.type,v.level)
		local weight = template.aa_weight * v.number
		num = num + weight
	end
	return num
end

--获取驻守中的英雄列表
function PlayerData:getDefHeroList()
	local tab = {}
	for k,v in pairs(self.heroList) do
		if v.state == HeroState.def then
			table.insert(tab,v)
		end
	end
	return tab
end

--获取空闲英雄列表
function PlayerData:getIdleHeroList()
	local tab = {}
	for k,v in pairs(self.heroList) do
		if v.state == HeroState.normal and v.hp > 0 then
			table.insert(tab,v)
		end
	end
	return tab
end

--获取英雄列表通过状态
function PlayerData:getHeroListByState(state)
	local tab = {}
	for k,v in pairs(self.heroList) do
		if v.state == state and v.hp > 0 then
			table.insert(tab,v)
		end
	end
	return tab
end

--获取英雄通过实例id
function PlayerData:getHeroById(objId)
	for k,v in pairs(self.heroList) do
		local id = v:getObjId()
		if id.id_h == objId.id_h and id.id_l == objId.id_l then
			return v
		end
	end
end

--清理缓存数据
--返回值(无)
function PlayerData:clearCache()
	self:init()
end
