--
-- Author: oyhc
-- Date: 2015-11-30 15:47:18
--
PubModel = class("PubModel")

-- 酒馆面板类型
TavernPanelType =
{
    -- “招贤馆”
    TAVERN_PANEL_HALL = 1,
    -- “聚贤庄”
    TAVERN_PANEL_MANOR = 2,
}

local instance = nil

--构造
--返回值(无)
function PubModel:ctor(data)
	self:init(data)
end

--获取单例
--返回值(单例)
function PubModel:getInstance()
	if instance == nil then
		instance = PubModel.new()
	end
	return instance
end

--初始化
--返回值(无)
function PubModel:init(data)
	self.pubGoldArr = {}
	self.pos = 0
	-- self:createData()
end

function PubModel:createData(panel, heroes, refresh_time, state)
	self.pubGoldArr = {}
	for k,v in pairs(heroes) do
		local hero = HeroData.new(v.hero)
		-- 英雄是否已经被招募， 1 已招募 0 未招募
		hero.hired = v.hired
		self:addHero(self.pubGoldArr,hero)
	end
	local uiCommand = UIMgr:getInstance():getUICtrlByType(UITYPE.PUB)
	if uiCommand ~= nil then
		uiCommand:showPubList(panel)
		uiCommand:getRefreshTime(refresh_time, state)
	end
end

function PubModel:getHeroIndex(id)
	for i=1,#self.pubGoldArr do
		local info = self.pubGoldArr[i]
		if id == info.id then
			return i - 1
		end
	end
	print("找不到英雄")
	return 0
end

-- 刷新英雄列表成功操作
function PubModel:refreshListSuccess(panel, heroes)
    local configTime = 0
    local level = CityBuildingModel:getInstance():getBuildingLv(self.pos)
    if panel == TavernPanelType.TAVERN_PANEL_HALL then
        configTime = CommonConfig:getInstance():getResHeroTime() - PubEffectConfig:getInstance():getResCost(level)
    else
        configTime = CommonConfig:getInstance():getGoldHeroTime() - PubEffectConfig:getInstance():getGoldCost(level)
    end
	self:createData(panel, heroes, configTime, 2)
	local str = ""
	-- 计算消耗
    if data.panel == TavernPanelType.TAVERN_PANEL_HALL then
    	PlayerData:getInstance():setPlayerMithrilGold(CommonConfig:getInstance():getResHeroRefreshGold())
    	str = "招贤馆"
    else
    	PlayerData:getInstance():setPlayerMithrilGold(CommonConfig:getInstance():getGoldHeroRefreshGold())
    	str = "聚贤馆"
    end
	Prop:getInstance():showMsg("成功刷新"..str)
    -- 刷新所有资源
	UICommon:getInstance():updatePlayerDataUI()
end

-- 招募英雄成功操作
function PubModel:hireHeroSuccess(data)
	local hero = self:getPubHeroInfo(data.pos + 1)
	hero.hired = 1
	-- 计算消耗
    if data.panel == TavernPanelType.TAVERN_PANEL_HALL then
    	local food = hero.fightforce * CommonConfig:getInstance():getHireGrain()
    	local wood = hero.fightforce * CommonConfig:getInstance():getHireWood()
    	PlayerData:getInstance():setPlayerFood(food)
    	PlayerData:getInstance():setPlayerWood(wood)
    	print("招募英雄消耗掉的：",food,wood)
    else
    	local gold = hero.fightforce * CommonConfig:getInstance():getHireGold()
    	PlayerData:getInstance():setPlayerMithrilGold(gold)
    	print("招募英雄消耗掉的：",gold)
    end
    -- 添加战斗力
    PlayerData:getInstance():increaseBattleForce(hero.fightforce)
	Prop:getInstance():showMsg("成功招募了新英雄")
    -- 刷新所有资源
	UICommon:getInstance():updatePlayerDataUI()
    -- 添加英雄
    PlayerData:getInstance():addHero(hero)
    -- 关闭详情会到列表界面
	local uiCommand = UIMgr:getInstance():getUICtrlByType(UITYPE.PUB)
	if uiCommand ~= nil then
		uiCommand:showPubListFromInfo(data.panel)
	end
end

-- 添加数据
-- list 数组
-- info 数据
function PubModel:addHero(list,info)
	table.insert(list,info)
end

function PubModel:getPubHeroInfo(index)
	local info = self.pubGoldArr[index]
	return info
end

function PubModel:getClickedHeroID()
	return self.clickedHeroID
end

--清理缓存
function PubModel:clearCache()
	self:init()
end


