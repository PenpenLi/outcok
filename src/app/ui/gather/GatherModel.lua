--
-- Author: oyhc
-- Date: 2015-12-01 20:20:19
--
GatherModel = class("GatherModel")

local instance = nil

--构造
--返回值(无)
function GatherModel:ctor(data)
	self:init(data)
end

--获取单例
--返回值(单例)
function GatherModel:getInstance()
	if instance == nil then
		instance = GatherModel.new()
	end
	return instance
end

--初始化
--返回值(无)
function GatherModel:init(data)
	self.heroList = {}
	-- 是否要先脱装备再穿装备
	self.auto = false
	-- 要自动装备的装备实例id
	self.objId = nil
	-- 要自动装备的英雄实例id
	self.heroid = nil
	-- 要脱的装备
	self.unEquip = nil
	-- 要穿的装备
	self.equip = nil
	-- 刷新的技能
	self.newSkill = nil
	-- 是否处于菜单界面
	self.openMenu = false
end

-- 解雇英雄成功操作
function GatherModel:fireHeroSuccess(data)
	--英雄实例ID
	-- local heroid = data.heroid
	local id = data.heroid.id_h .. data.heroid.id_l
	-- hero
	local hero = PlayerData:getInstance():getHeroByID(id)
	-- 减掉战斗力
    PlayerData:getInstance():minusBattleForce(hero.fightforce)

	PlayerData:getInstance():delHero(id)
    -- 刷新所有资源
	UICommon:getInstance():updatePlayerDataUI()

    -- 关闭详情会到列表界面
	local uiCommand = UIMgr:getInstance():getUICtrlByType(UITYPE.GATHER)
	if uiCommand ~= nil then
		uiCommand:showHeroListFromInfo()
	end
end

--装备列表
function GatherModel:createEquipList(data)
	-- 创建装备列表
	EquipData:getInstance():createEquipList(data.equips)
end

-- 穿装备或脱装备
-- data
-- type 1穿装备返回 2脱装备返回
function GatherModel:equipOperationSuccess(data,type)
	-- 装备id
	local equipID = data.equip_id.id_h .. data.equip_id.id_l
	-- 英雄id
	local heroID = data.hero_id.id_h .. data.hero_id.id_l
	local hero = PlayerData:getInstance():getHeroByID(heroID)
	-- 英雄属性变动
	-- max_hp 满血状态的值
	hero.maxhp = data.maxhp
	-- 英雄攻击力
	hero.attack = data.attack
	-- 英雄防御力
	hero.defence = data.defence
	--英雄变化的战斗力
	local changeFightforce = data.fightforce - hero.fightforce
	print("服务器下发的：",data.maxhp,data.attack,data.defence,data.fightforce)
	print("changeFightforce：",changeFightforce)
    -- 添加战斗力
    PlayerData:getInstance():increaseBattleForce(changeFightforce)
	-- Prop:getInstance():showMsg("")
    -- 刷新所有资源
	UICommon:getInstance():updatePlayerDataUI()
	-- 英雄战斗力
	hero.fightforce = data.fightforce

	if type == 1 then -- 穿装备
		--把装备穿到身上
		hero:addInfo(hero.equips, self.equip)
		--装备列表数据处理
		EquipData:getInstance():changeOrDelEquip(equipID,1)
		-- 要穿的装备
		-- self.equip = nil
	else -- 脱装备
		--把装备从身上脱掉
		hero:delEquipByID(equipID)
		--装备列表数据处理
		EquipData:getInstance():changeOrAddEquip(equipID,self.unEquip)
		-- 要脱的装备
		-- self.unEquip = nil
	end
	-- 判断是否需要自动穿装备
	if self.auto == true then
		print("自动穿上的装备：",self.objId, self.heroid)
		self.auto = false
        -- 穿装备 
		GatherService:getInstance():sendDress(self.objId, self.heroid)
		-- 是否要先脱装备再穿装备
		-- 要自动装备的装备实例id
		-- self.objId = nil
		-- 要自动装备的英雄实例id
		-- self.heroid = nil
	end
	local uiCommand = UIMgr:getInstance():getUICtrlByType(UITYPE.GATHER)
	if uiCommand ~= nil then
		uiCommand:updateEquipUI(type)
	end
end

-- 刷新技能成功
function GatherModel:refreshSkillSuccess(data)
	-- 设置金币
    PlayerData:getInstance():setPlayerGold(data.gold)
    -- 刷新所有资源
	UICommon:getInstance():updatePlayerDataUI()
	--技能
	self.newSkill = SkillData.new(data.skill)
	local uiCommand = UIMgr:getInstance():getUICtrlByType(UITYPE.GATHER)
	if uiCommand ~= nil then
		uiCommand:updateNewSkillUI()
	end
end

-- 替换技能成功
function GatherModel:changeSkillSuccess(data)
	-- 英雄数据改变
	--唯一id
	local id = data.heroid.id_h .. data.heroid.id_l
	local hero = PlayerData:getInstance():getHeroByID(id)
	-- 替换技能
	hero.skill = self.newSkill
	-- 英雄攻击力
	hero.attack = data.attack
	-- 英雄防御力
	hero.defence = data.defence
	local uiCommand = UIMgr:getInstance():getUICtrlByType(UITYPE.GATHER)
	if uiCommand ~= nil then
		uiCommand:updateOldSkillUI()
	end
end

--清理缓存
function GatherModel:clearCache()
	self:init()
end
