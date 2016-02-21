--
-- Author: oyhc
-- Date: 2015-12-02 20:21:39
--
GatherHeroInfoView = class("GatherHeroInfoView")

--构造
--uiType UI类型
--data 数据
function GatherHeroInfoView:ctor(theSelf)
	self.parent = theSelf
	self.view = Common:seekNodeByName(self.parent.root,"heroInfo")
    self.view:setTouchEnabled(false)
	-- self:init()
end

--初始化
--返回值(无)
function GatherHeroInfoView:init(hero)
    GatherService:getInstance():sendEquipList()
    -- 英雄数据
    self.hero = hero
    -- 返回按钮
    self.btn_back = Common:seekNodeByName(self.view,"btn_back")
    self.btn_back:addTouchEventListener(handler(self,self.onBack))
    -- 英雄名字
    local lbl_name = Common:seekNodeByName(self.view,"lbl_name")
    lbl_name:setString(self.hero.name)
    -- 设置颜色
    lbl_name:setColor(Common:getQualityColor(self.hero.quality))
    -- 战斗力
    self.lbl_fight = Common:seekNodeByName(self.view,"lbl_fight")
    self.lbl_fight:setString("战斗力："..self.hero.fightforce)
    -- 头像
    local head = MMUISimpleUI:getInstance():getHead(hero)
    head:setPosition(367,1050)
    self.view:addChild(head)
    -- 性格
    local lbl_character = Common:seekNodeByName(self.view,"lbl_character")
    lbl_character:setString("性格："..self.hero.characterStr)
    -- 技能
    self.lbl_skill = Common:seekNodeByName(self.view,"lbl_skill")
    self.lbl_skill:setString("技能："..hero.skill.name)
    -- 等级
    local lbl_level = Common:seekNodeByName(self.view,"lbl_level")
    lbl_level:setString("等级："..self.hero.level)

    local processBg = MMUIProcess:getInstance():create("citybuilding/processbg.png","citybuilding/process.png",self.view, self.hero.hp, self.hero.maxhp)
    processBg:setPosition(self.view:getContentSize().width / 2,780)
    -- 生命
    self.lbl_hp = Common:seekNodeByName(self.view,"lbl_hp")
    self.lbl_hp:setString("最大生命："..self.hero.maxhp)
    -- 生命成长
    local lbl_hpGrowUp = Common:seekNodeByName(self.view,"lbl_hpGrowUp")
    lbl_hpGrowUp:setString("生命成长："..CharacterUpdataConfig:getInstance():getHPUpdata(self.hero.character,self.hero.level))
    -- 攻击
    self.lbl_attack = Common:seekNodeByName(self.view,"lbl_attack")
    self.lbl_attack:setString("攻击："..self.hero.attack)
    -- 攻击成长
    local lbl_attackGrowUp = Common:seekNodeByName(self.view,"lbl_attackGrowUp")
    lbl_attackGrowUp:setString("攻击成长："..CharacterUpdataConfig:getInstance():getAttackUpdata(self.hero.character,self.hero.level))
    -- 防御
    self.lbl_def = Common:seekNodeByName(self.view,"lbl_def")
    self.lbl_def:setString("防御："..self.hero.defence)
    -- 防御成长
    local lbl_defGrowUp = Common:seekNodeByName(self.view,"lbl_defGrowUp")
    lbl_defGrowUp:setString("防御成长："..CharacterUpdataConfig:getInstance():getDefenceUpdata(self.hero.character,self.hero.level))
    -- 步兵适性
    local lbl_footsoldier = Common:seekNodeByName(self.view,"lbl_footsoldier")
    lbl_footsoldier:setString("步兵适性："..self.hero.infantryStr)
    -- 骑兵适性
    local lbl_cavalry = Common:seekNodeByName(self.view,"lbl_cavalry")
    lbl_cavalry:setString("骑兵适性："..self.hero.cavalryStr)
    -- 弓兵适性
    local lbl_archer = Common:seekNodeByName(self.view,"lbl_archer")
    lbl_archer:setString("弓兵适性："..self.hero.archerStr)
    -- 法师适性
    local lbl_master = Common:seekNodeByName(self.view,"lbl_master")
    lbl_master:setString("法师适性："..self.hero.mageStr)
    -- 战车适性
    local lbl_tank = Common:seekNodeByName(self.view,"lbl_tank")
    lbl_tank:setString("战车适性："..self.hero.chariotStr)
    -- 解雇按钮
    self.btn_fire = Common:seekNodeByName(self.view,"btn_fire")
    self.btn_fire:addTouchEventListener(handler(self,self.onFire))
    self.btn_fire:setTitleText("解雇")
    -- 技能按钮
    self.btn_skill = Common:seekNodeByName(self.view,"btn_skill")
    self.btn_skill:addTouchEventListener(handler(self,self.onSkill))
    self.btn_skill:setTitleText("技能")
    --
    self:setData()
end

function GatherHeroInfoView:setData()
    print("英雄详情刷新")
    --装备
    --武器
    self.img_weapon = self:createEquip(EQUIP.weapon,self.onWeapon)
    self.img_weapon:setPosition(100,display.height - self.img_weapon:getContentSize().height - 100)
    self.view:addChild(self.img_weapon)
    -- 衣服
    self.img_clothes = self:createEquip(EQUIP.clothes,self.onClothes)
    self.img_clothes:setPosition(100,display.height - self.img_weapon:getContentSize().height - 220)
    self.view:addChild(self.img_clothes)
    -- 腰带
    self.img_belt = self:createEquip(EQUIP.belt,self.onBelt)
    self.img_belt:setPosition(100,display.height - self.img_belt:getContentSize().height - 340)
    self.view:addChild(self.img_belt)
    -- 护腕
    self.img_bracer = self:createEquip(EQUIP.gauntlet,self.onBracer)
    self.img_bracer:setPosition(530,display.height - self.img_bracer:getContentSize().height - 100)
    self.view:addChild(self.img_bracer)
    -- 裤子
    self.img_pants = self:createEquip(EQUIP.trousers,self.onPants)
    self.img_pants:setPosition(530,display.height - self.img_pants:getContentSize().height - 220)
    self.view:addChild(self.img_pants)
    -- 鞋子
    self.img_shoes = self:createEquip(EQUIP.shoes,self.onShoes)
    -- self.img_shoes = MMUISimpleUI:getInstance():getEquipBox(EQUIP.shoes,nil,self,self.onShoes)
    self.img_shoes:setPosition(530,display.height - self.img_shoes:getContentSize().height - 340)
    self.view:addChild(self.img_shoes)
    self.lbl_fight:setString("战斗力："..self.hero.fightforce)
    self.lbl_hp:setString("最大生命："..self.hero.maxhp)
    self.lbl_def:setString("防御："..self.hero.defence)
    self.lbl_attack:setString("攻击："..self.hero.attack)
    local processBg = MMUIProcess:getInstance():create("citybuilding/processbg.png","citybuilding/process.png",self.view, self.hero.hp, self.hero.maxhp)
    processBg:setPosition(self.view:getContentSize().width / 2,780)
    -- 技能
    self.lbl_skill:setString("技能："..self.hero.skill.name)
end

-- 获取装备资源名称
-- equipType 装备类型
function GatherHeroInfoView:getEquipIcon(equipType)
    local equipName = nil
    local equip = self.hero:getEquipsByType(equipType)
    if equip ~= nil then
        equipName = equip.icon
    end
    return equipName
end

-- 创建装备
-- equipType 装备类型
function GatherHeroInfoView:createEquip(equipType,callback)
    local equipName = self:getEquipIcon(equipType)
    local equipBox =  MMUISimpleUI:getInstance():getEquipBox(equipType,equipName,self,callback)
    return equipBox
end

--解雇按钮回调
--sender 按钮本身
--eventType 事件类型
function GatherHeroInfoView:onFire(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        UIMgr:getInstance():openUI(UITYPE.PROP_BOX, {type=PROP_BOX_TYPE.COMMON,text="确认解雇该英雄？",
            callback=handler(self, self.onSureRecruit),sureBtnText=CommonStr.SURE,cancelBtnText=CommonStr.CANCEL
        })
    end
end

-- 确认解雇该英雄回调
function GatherHeroInfoView:onSureRecruit()
    print("确认解雇该英雄")
    GatherService:getInstance():sendFireHero(self.hero.heroid)
end

--招募按钮回调
--sender 按钮本身
--eventType 事件类型
function GatherHeroInfoView:onSkill(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self:hideView()
        -- 显示英雄技能界面
        self.parent.skillView:showView()
        -- 加载英雄技能信息
        self.parent.skillView:setData(self.hero)
    end
end

--武器按钮回调
--sender 按钮本身
--eventType 事件类型
function GatherHeroInfoView:onWeapon(sender,eventType)
    print("武器按钮回调")
    self:hideView()
    -- 显示武器界面
    self.parent.weaponView:showView()
    -- 加载武器界面信息
    self.parent.weaponView:setData(EQUIP.weapon, self.hero)
end

--衣服按钮回调
--sender 按钮本身
--eventType 事件类型
function GatherHeroInfoView:onClothes(sender,eventType)
    print("衣服按钮回调")
    self:hideView()
    -- 显示武器界面
    self.parent.weaponView:showView()
    -- 加载武器界面信息
    self.parent.weaponView:setData(EQUIP.clothes, self.hero)
end

--腰带按钮回调
--sender 按钮本身
--eventType 事件类型
function GatherHeroInfoView:onBelt(sender,eventType)
    print("腰带按钮回调")
    self:hideView()
    -- 显示武器界面
    self.parent.weaponView:showView()
    -- 加载武器界面信息
    self.parent.weaponView:setData(EQUIP.belt, self.hero)
end

--护腕按钮回调
--sender 按钮本身
--eventType 事件类型
function GatherHeroInfoView:onBracer(sender,eventType)
    print("护腕按钮回调")
    self:hideView()
    -- 显示武器界面
    self.parent.weaponView:showView()
    -- 加载武器界面信息
    self.parent.weaponView:setData(EQUIP.gauntlet, self.hero)
end

--裤子按钮回调
--sender 按钮本身
--eventType 事件类型
function GatherHeroInfoView:onPants(sender,eventType)
    print("裤子按钮回调")
    self:hideView()
    -- 显示武器界面
    self.parent.weaponView:showView()
    -- 加载武器界面信息
    self.parent.weaponView:setData(EQUIP.trousers, self.hero)
end

--鞋子按钮回调
--sender 按钮本身
--eventType 事件类型
function GatherHeroInfoView:onShoes(sender,eventType)
    print("鞋子按钮回调")
    self:hideView()
    -- 显示武器界面
    self.parent.weaponView:showView()
    -- 加载武器界面信息
    self.parent.weaponView:setData(EQUIP.shoes, self.hero)
end

--返回到英雄列表按钮回调
--sender 按钮本身
--eventType 事件类型
function GatherHeroInfoView:onBack(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
    	self:hideView()
        self.parent:showView()
    end
end

-- 显示界面
function GatherHeroInfoView:showView()
	self.view:setVisible(true)
end

-- 隐藏界面
function GatherHeroInfoView:hideView()
	self.view:setVisible(false)
end