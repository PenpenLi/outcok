--
-- Author: oyhc
-- Date: 2015-12-02 23:51:22
--
PubHeroInfoView = class("PubHeroInfoView")

--构造
--uiType UI类型
--data 数据
function PubHeroInfoView:ctor(theSelf)
	self.parent = theSelf
    self.model = self.parent.model
	self.view = Common:seekNodeByName(self.parent.root,"PubHeroInfo")
	-- self:init()
end

--初始化
--返回值(无)
function PubHeroInfoView:init(hero,panel)
    -- 英雄数据
    self.hero = hero
    self.panel = panel
	-- 返回按钮
    self.btn_back = Common:seekNodeByName(self.view,"btn_back")
    self.btn_back:addTouchEventListener(handler(self,self.onBack))
    -- 英雄名字
    local lbl_name = Common:seekNodeByName(self.view,"lbl_name")
    lbl_name:setString(self.hero.name)
    -- 设置颜色
    lbl_name:setColor(Common:getQualityColor(self.hero.quality))
    -- 战斗力
    local lbl_fight = Common:seekNodeByName(self.view,"lbl_fight")
    lbl_fight:setString("战斗力："..self.hero.fightforce)
    -- 头像
    local head = MMUISimpleUI:getInstance():getHead(self.hero)
    head:setPosition(200,1050)
    self.view:addChild(head)
    -- 性格
    local lbl_character = Common:seekNodeByName(self.view,"lbl_character")
    lbl_character:setString("性格："..self.hero.characterStr)
    -- 技能
    local lbl_skill = Common:seekNodeByName(self.view,"lbl_skill")
    lbl_skill:setString("技能："..hero.skill.name)
    -- 等级
    local lbl_level = Common:seekNodeByName(self.view,"lbl_level")
    lbl_level:setString("等级："..self.hero.level)
    -- 生命
    local lbl_hp = Common:seekNodeByName(self.view,"lbl_hp")
    lbl_hp:setString("最大生命："..self.hero.maxhp)
    -- 生命成长
    local lbl_hpGrowUp = Common:seekNodeByName(self.view,"lbl_hpGrowUp")
    print("···",self.hero.character, self.hero.level)
    lbl_hpGrowUp:setString("生命成长："..CharacterUpdataConfig:getInstance():getHPUpdata(self.hero.character, self.hero.level))
    -- 攻击
    local lbl_attack = Common:seekNodeByName(self.view,"lbl_attack")
    lbl_attack:setString("攻击："..self.hero.attack)
    -- 攻击成长
    local lbl_attackGrowUp = Common:seekNodeByName(self.view,"lbl_attackGrowUp")
    lbl_attackGrowUp:setString("攻击成长："..CharacterUpdataConfig:getInstance():getAttackUpdata(self.hero.character,self.hero.level))
    -- 防御
    local lbl_def = Common:seekNodeByName(self.view,"lbl_def")
    lbl_def:setString("防御："..self.hero.defence)
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
    -- 招募条件
    local pubConditions = Common:seekNodeByName(self.view,"PubConditions")
    -- 招募条件
    local lbl_title = Common:seekNodeByName(pubConditions,"lbl_title")
    lbl_title:setString("招募条件")
    -- 粮食 金币
    local lbl_food = Common:seekNodeByName(pubConditions,"lbl_food")
    -- 木头
    local lbl_wood = Common:seekNodeByName(pubConditions,"lbl_wood")
    --
    if self.panel == TavernPanelType.TAVERN_PANEL_HALL then
        lbl_wood:setVisible(true)
        lbl_food:setString("粮食："..(self.hero.fightforce * CommonConfig:getInstance():getHireGrain()))
        lbl_wood:setString("木头："..(self.hero.fightforce * CommonConfig:getInstance():getHireWood()))
    else
        lbl_wood:setVisible(false)
        lbl_food:setString("金币："..(self.hero.fightforce * CommonConfig:getInstance():getHireGold()))
    end

    -- 招募按钮
    self.btn_recruit = Common:seekNodeByName(self.view,"btn_recruit")
    self.btn_recruit:addTouchEventListener(handler(self,self.onRecruit))
    self.btn_recruit:setTitleText("招募")
end

--招募按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function PubHeroInfoView:onRecruit(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        UIMgr:getInstance():openUI(UITYPE.PROP_BOX, {type=PROP_BOX_TYPE.COMMON,text="确认招募该英雄？",
            callback=handler(self, self.onSureRecruit),sureBtnText=CommonStr.SURE,cancelBtnText=CommonStr.CANCEL
        })
    end
end

-- 确认招募英雄回调
function PubHeroInfoView:onSureRecruit()
    print("确认招募英雄",self.panel, self.model:getHeroIndex(self.hero.id))
    PubService:getInstance():sendHireHero(self.panel, self.model:getHeroIndex(self.hero.id))
end

-- 返回到英雄列表按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function PubHeroInfoView:onBack(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self:hideView()
        self.parent.heroListView:showView()
    end
end

-- 显示界面
function PubHeroInfoView:showView()
	self.view:setVisible(true)
end

-- 隐藏界面
function PubHeroInfoView:hideView()
	self.view:setVisible(false)
end