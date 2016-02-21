
--[[
	jinyan.zhang
	副本战斗数据
--]]

CopyBattleModel = class("CopyBattleModel")
local instance = nil

local _markId = 0

--创建一个标记id
--返回值(id)
function CopyBattleModel:createMarkId()
	_markId = _markId + 1
	if _markId > 9999 then
		_markId = 1
	end
	return _markId
end

--构造
--返回值(无)
function CopyBattleModel:ctor()
	self:init()
end

--初始化
--返回值(无)
function CopyBattleModel:init()
	self.localBattleArms = {} --本地出征部队数据
	self.battleHeros = {}
	self.heros = {}
	self.addExp = 0
end

--获取单例
--返回值(单例)
function CopyBattleModel:getInstance()
	if instance == nil then
		instance = CopyBattleModel.new()
	end
	return instance
end

--保存本地出征部队数据
--data 数据
--返回值(无)
function CopyBattleModel:saveLocalBattleArmsData(data)
	data.markId = self:createMarkId()
	local arryArms = {}
	local arryHero = {}
	for k,v in pairs(data.marching) do
		local heroId = v.heroId
		local id = "" .. heroId.id_h .. heroId.id_l
		local hero = clone(PlayerData:getInstance():getHeroByID(id))
		hero.pos = k
		table.insert(arryHero,hero)
        local arms = v.arms
        for k,v in pairs(arms) do
        	table.insert(arryArms,v)
        end
	end
	data.heros = arryHero
	data.arms = arryArms
	table.insert(self.localBattleArms,data)
end

--获取本地出征部队数据
--返回值(本地出征部队数据)
function CopyBattleModel:getLocalBattleArmsData(markId)
	for k,v in pairs(self.localBattleArms) do
		if v.markId == markId then
			return v
		end
	end
end

--删除本地出征部队数据
--返回值(无)
function CopyBattleModel:delLocalBattleArmsData(markId)
	for k,v in pairs(self.localBattleArms) do
		if v.markId == markId then
			table.remove(self.localBattleArms,k)
			break
		end
	end
end

--删除参加战斗的士兵
function CopyBattleModel:delGoBattleArms(marchinArms)
	for k,v in pairs(marchinArms) do
		local heroId = v.heroId
		local id = "" .. heroId.id_h .. heroId.id_l
		PlayerData:getInstance():delHero(id)
        local arms = v.arms
        ArmsData:getInstance():delArms(arms)
	end
end

--设置参加战斗的英雄
function CopyBattleModel:setGoBattleHeros(heros)
	self.battleHeros = heros
end

--设置掉落的物品
function CopyBattleModel:setDropItems(items)
	self.dropitems = items
end

--设置战斗后剩下的英雄
function CopyBattleModel:setAfterBattleHeros(heros)
	self.heros = heros
end

--获取参加战斗的英雄列表
function CopyBattleModel:getGoBattleHeros()
	return self.battleHeros
end

--获取战斗后剩下的英雄列表
function CopyBattleModel:getAfterBattleHeros()
	return self.heros
end

--设置增加的英雄经验
function CopyBattleModel:setAddExp(exp)
	self.addExp = exp
end

--获取增加的经验
function CopyBattleModel:getAddExp()
	return self.addExp
end

--获取掉落物品
function CopyBattleModel:getDropItems()
	return self.dropitems
end

--保存服务端下发的副本战斗信息
--data 数据
--返回值(无)
function CopyBattleModel:setData(data)
	--怪物列表
	local monsters = data.monsters
	--战斗序列
	local sequence = data.sequence
	--是否胜利  1:胜利  0:失败 
	local winFlag = data.winFlag
	--英雄
	local heroes = data.heroes
	--伤兵数据
	local woundedSolider = data.woundedSolider
	--存活士兵
	local arms = data.arms
	--单个英雄获取取经
	local exp = data.exp
	--掉落道具
	local spoils = data.spoils
	--标记id
	local markId = data.markId
	--战斗力
	local fightForce = data.fightForce

	--获取本地保存的出征部队
	local localArmsData = self:getLocalBattleArmsData(markId)
	--出征部队
	local localData = clone(localArmsData)
	--删除本地保存的数据
	self:delLocalBattleArmsData(markId)

	self:setGoBattleHeros(localData.heros)
	self:setAfterBattleHeros(heroes)
	self:setAddExp(exp)

	print("剩余英雄数据............. 个数=",#heroes)
	--英雄处理
	for k,v in pairs(heroes) do
		local hero = HeroData.new(v)
		PlayerData:getInstance():addHero(hero)
		print("hero hp=",hero.hp)
	end
	
	print("剩余部队数据.......个数=",#arms)
	for k,v in pairs(arms) do
         print("level：",v.level,"士兵类型：",ArmsData:getInstance():getOccupatuinName(v.type),"数量：",v.number)
	end
	ArmsData:getInstance():addArms(arms)

	print("伤兵数据........个数=",#woundedSolider)
	for k,v in pairs(woundedSolider) do
        print("level：",v.level,"士兵类型：",ArmsData:getInstance():getOccupatuinName(v.type),"数量：",v.number)
	end
	--伤兵处理
	HurtArmsData:getInstance():init()
	HurtArmsData:getInstance():createArmsList(woundedSolider)
	--道具处理
	local arryDropItems = {}
	for k,v in pairs(spoils) do
		--物品模板id
		local templateId = v.itemId
		--物品数量
		local number = v.num
		--实例id
		local objId = v.objId
		ItemData:getInstance():addItmeById(templateId,number,objId)
		local info = {}
		info.templateId = templateId
		info.number = number
		info.objId = objId
		table.insert(arryDropItems,info)
	end
	self:setDropItems(arryDropItems)
	print("副本物品掉落个数=",#arryDropItems)

	--战斗力
	PlayerData:getInstance():setFightForce(fightForce)

	--处理战斗序列
	BattleData:getInstance():setCopyBattleData(localArmsData.arms,localArmsData.heros,monsters,sequence,localArmsData.copyIndex,winFlag)
end

--清理缓存数据
--返回值(无)
function CopyBattleModel:clearCache()
	self:init()
end


