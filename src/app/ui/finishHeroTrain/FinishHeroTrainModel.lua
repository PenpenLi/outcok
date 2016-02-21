
--[[
	jinyan.zhang
	完成英雄训练数据
--]]

FinishHeroTrainModel = class("FinishHeroTrainModel")
local instance = nil

--构造
--返回值(无)
function FinishHeroTrainModel:ctor()
	self:init()
end

--初始化
--返回值(空)
function FinishHeroTrainModel:init()

end

--获取单例
--返回值(单例)
function FinishHeroTrainModel:getInstance()
	if instance == nil then
		instance = FinishHeroTrainModel.new()
	end
	return instance
end

--领取英雄结果
--data 数据
function FinishHeroTrainModel:getHeroRes(data)
    local battle = 0
    local tab = {}
    for k,v in pairs(data) do
        local hero = v.hero
        battle = v.fightForce + battle
        local id = hero.heroid.id_h .. hero.heroid.id_l
        local preHero = PlayerData:getInstance():getHeroByID(id)
        local upLvTimer = hero.level - preHero.level
        local curPer =  preHero.exp/preHero.maxexp*100
        local curLevel = preHero.level
        if curPer < 0 then
          curPer = 0
        end
        
        PlayerData:getInstance():delHero(id)
        local newHero = HeroData.new(hero)
        PlayerData:getInstance():addHero(newHero)
        local per = newHero.exp/newHero.maxexp*100
        if per < 0 then
           per = 99
        end

        local info = {}
        info.upLvTimer = upLvTimer
        info.per = per
        info.addPer = 15
        info.name = hero.name
        info.level = hero.level
        info.curLevel = curLevel
        info.curPer = curPer
        info.hero = newHero
        table.insert(tab,info)
    end

    local command = UIMgr:getInstance():getUICtrlByType(UITYPE.HERO_TRAIN)
    if command ~= nil then
        command:createList()
    end

    --更新英雄训练时间UI
    local cityBuildingListCtrl = MapMgr:getInstance():getCityBuildingListCtrl()
    if cityBuildingListCtrl ~= nil then
        cityBuildingListCtrl:updateHeroTrainTime()
    end

    UIMgr:getInstance():openUI(UITYPE.FINISH_HERO_TRAIN,{battle=battle,info=tab})
end

--清理缓存
--返回值(无)
function FinishHeroTrainModel:clearCache()
	self:init()
end





