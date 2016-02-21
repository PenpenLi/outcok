

HeroData = class("HeroData")

--英雄状态
HeroState = {
	normal = 0,  	--正常
	train = 1,  	--训练
	def = 2,  		--驻扎城墙
	battle = 3,   	--出征
	finish_train = 4, --完成训练
	garrison = 6,    --城外驻守
}

--构造
--返回值(无)
function HeroData:ctor(data)
	self:init(data,type)
end

--初始化
--返回值(无)
function HeroData:init(data)
	--英雄实例ID
	self.heroid = {}
	self.heroid.id_h = data.heroid.id_h
	self.heroid.id_l = data.heroid.id_l
	-- print("高位",data.heroid.id_h,"低位",data.heroid.id_l)
	--唯一id
	self.id = data.heroid.id_h .. data.heroid.id_l
	-- 英雄所在的位置（在酒馆就是酒馆的位置，雇佣后就是玩家所在的位置）
	self.pos = data.pos
	-- 英雄头像
	self.image = data.image
	-- 英雄名字
	self.name = data.name
	-- 英雄性别
	self.gender = data.gender
	-- 英雄战斗力
	self.fightforce = data.fightforce
	-- 英雄性格
	self.character = data.character
	-- 英雄性格值
	self.characterStr = CharacterListConfig:getInstance():getCharacterByID(data.character)
	-- 英雄品质
	self.quality = data.quality
	-- 英雄等级
	self.level = data.level
	-- 英雄经验
	self.exp = data.exp
	-- 英雄最大经验值(经验槽值)
	self.maxexp = data.maxexp

	-- 英雄当前血量
	self.hp = data.hp
	-- 英雄最大血量(血槽值）
	self.maxhp = data.maxhp
	-- 英雄攻击力
	self.attack = data.attack
	-- 英雄防御力
	self.defence = data.defence
	-- 英雄步兵适应性
	self.infantry = data.infantry
	self.infantryStr = self:getSuitableNameByValue(data.infantry)
	-- 英雄骑兵适应性
	self.cavalry = data.cavalry
	self.cavalryStr = self:getSuitableNameByValue(data.cavalry)
	-- 英雄弓兵适应性
	self.archer = data.archer
	self.archerStr = self:getSuitableNameByValue(data.archer)
	-- 英雄法师适应性
	self.mage = data.mage
	self.mageStr = self:getSuitableNameByValue(data.mage)
	-- 英雄战车适应性
	self.chariot = data.chariot
	self.chariotStr = self:getSuitableNameByValue(data.chariot)
	--英雄身上的装备列表
	self.equips = {}
	-- 创建装备列表
	self:createEquips(data.equips)
	--英雄状态
	self.state = data.status
	--技能
	self.skill = SkillData.new(data.skills[1])

	-- 出征携带的军队
	self.army = {}
	-- 英雄携带出征军队的职业
	self.occupation = 0
	-- 英雄最好的适性职业
	self.bestOccupation = 0
	self:setBestOccupation()
	-- 英雄是否已经被招募， 1 已招募 0 未招募
	self.hired = 0
	--训练剩余时间
	self.trainTime = 0
	--训练开始时间点
	self.trainBeginTime = 0
	--英雄训练时长
	self.trainHour = 0
end

function HeroData:setHp(hp)
	self.hp = hp
end

--
function HeroData:delEquipByID(id)
	for k,v in pairs(self.equips) do
		if v.id == id then
			-- self.equips[k] = nil
			table.remove(self.equips,k)
			break
		end
	end
end

-- 创建英雄身上的装备列表
function HeroData:createEquips(arr)
	for k,v in pairs(arr) do
		local info = EquipData:getInstance():createEquip(v, 2)
		self:addInfo(self.equips,info)
	end
end

-- 根据装备类型获取英雄身上的装备
-- equipType 装备类型
function HeroData:getEquipsByType(equipType)
	for k,v in pairs(self.equips) do
		if equipType == v.type then
			return v
		end
	end
end

function HeroData:getHeroCurExp()
	local totalExp = 0
	for i=1,self.level-1 do
		local exp = CharacterUpdataConfig:getInstance():getMaxhp(self.character,i)
		print("exp=",exp)
		totalExp = totalExp + exp
	end
	return self.exp - totalExp
end

--训练剩余时间
function HeroData:setTrainTime(value,trainHour)
	self.trainHour = trainHour
	self.trainTime = value
	self.trainBeginTime = Common:getOSTime()
end

--减少训练时间
function HeroData:minusLeftTime(time)
	self.trainTime = self.trainTime - time
	if self.trainTime <= 0 then
		self.trainTime = 0
		self:setState(HeroState.finish_train)
	end
	self.trainBeginTime = Common:getOSTime()
end

--获取训练剩余时间
function HeroData:getTrainTime()
	local passTime = Common:getOSTime() - self.trainBeginTime
	return self.trainTime - passTime
end

-- 获取适应性名字（ABCDS）
-- suitable 适性
function HeroData:getSuitableNameByValue(suitable)
	local str = ""
	if suitable == 12 then
		str = "S"
	elseif suitable == 10 then
		str = "A"
	elseif suitable == 9 then
		str = "B"
	elseif suitable == 8 then
		str = "C"
	elseif suitable == 7 then
		str = "D"
	elseif suitable == 5 then
		str = "E"
	end
	return str
end

function HeroData:getSuitStr(job)
	if job == OCCUPATION.footsoldier then
		return Lan:lanText(228, "步兵适性:") .. self.infantryStr
	elseif job == OCCUPATION.cavalry then
		return Lan:lanText(229, "骑兵适性:") .. self.cavalryStr
	elseif job == OCCUPATION.archer then
		return Lan:lanText(232, "弓兵适性:") .. self.archerStr
	elseif job == OCCUPATION.tank then
		return Lan:lanText(230, "战车兵适性:") .. self.chariotStr
	elseif job == OCCUPATION.master then
		return Lan:lanText(231, "法师兵适性:") .. self.mageStr
	end
end

--获取实例id
function HeroData:getObjId()
	return self.heroid
end

--获取英雄头像路径
function HeroData:getHeadPath()
	UICommon:getInstance():getHeadImg(self.image)
end

--获取英雄名字
function HeroData:getName()
	return self.name
end

--获取英雄状态
function HeroData:getState()
	return self.state
end

--设置英雄状态
function HeroData:setState(state)
	self.state = state
end

--获取英雄最好的适性职业
function HeroData:getBestOccupation()
	return self.bestOccupation
end

--设置英雄最好的适性职业
function HeroData:setBestOccupation()
    local arr = {}
    arr[1] = {occupation = OCCUPATION.footsoldier, value = self.infantry}
    arr[2] = {occupation = OCCUPATION.cavalry, value = self.cavalry}
    arr[3] = {occupation = OCCUPATION.archer, value = self.archer}
    arr[4] = {occupation = OCCUPATION.master, value = self.mage}
    arr[5] = {occupation = OCCUPATION.tank, value = self.chariot}
    --排序
    table.sort(arr,function(a,b) return a.value > b.value end )
    --设置英雄最好的适性职业
    self.bestOccupation = arr[1].occupation
end

--获取携带的军队
function HeroData:getArmy()
	return self.army
end

--设置携带的军队
function HeroData:setArmy()
	self.army = {}
end

--获取英雄唯一id
function HeroData:getHeroID()
	return self.id
end

--获取英雄等级
function HeroData:getHeroLevel()
	return self.level
end

--设置英雄携带出征军队的职业
function HeroData:setHeroOcupation(occupation)
	self.occupation = occupation
end

--获取英雄携带出征军队的职业
function HeroData:getHeroOcupation()
	return self.occupation
end

--重置出征军队
function HeroData:resetHeroArmy()
	self:setHeroOcupation(0)
	self.army = {}
end

--获取英雄当前士兵的总量
function HeroData:getCurSoldiers()
	local num = 0
	for k,v in pairs(self.army) do
		num = v.number + num
	end
	return num
end

--获取英雄携带最大士兵数量
function HeroData:getHeroMaxSoldiers()
    return self.level * CommonConfig:getInstance():getSoldierMaxnumber()
end

--根据等级和类型查找士兵的数量
--type 士兵类型
--level 等级
function HeroData:getSoldiersByOne(type,level)
	for k,v in pairs(self.army) do
		if type == v.type and level == v.level then
			return v.number
		end
	end
	return 0
end

--根据等级和类型删除士兵的数量
--type 士兵类型
--level 等级
function HeroData:delSoldiersByOne(type,level)
	for k,v in pairs(self.army) do
		if type == v.type and level == v.level then
			table.remove(self.army,k)
			--如果army是空的 把携带的职业耶制空
			if #self.army == 0 then
				self:setHeroOcupation(0)
			end
			return
		end
	end
end

--根据等级和类型添加或更改士兵的数量
--type 士兵类型
--level 等级
function HeroData:changeSoldiersByOne(type,level,number)
	for k,v in pairs(self.army) do
		if type == v.type and level == v.level then
			v.number = number
			return
		end
	end
	--找不到就添加
	table.insert(self.army, {type = type, level = level, number = number})
	self:setHeroOcupation(type)
end

-- 添加数据
-- list 数组
-- info 数据
function HeroData:addInfo(list,info)
	table.insert(list,info)
end

