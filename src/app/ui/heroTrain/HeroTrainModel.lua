--
-- Author: oyhj
-- Date: 2015-12-17
--
HeroTrainModel = class("HeroTrainModel")

local instance = nil

--构造
--返回值(无)
function HeroTrainModel:ctor(data)
    self:init(data)
end

--获取单例
--返回值(单例)
function HeroTrainModel:getInstance()
    if instance == nil then
        instance = HeroTrainModel.new()
    end
    return instance
end

--初始化
--返回值(无)
function HeroTrainModel:init(data)
    self.heroList = {}
    self.localData = nil
    self.localTrain = {}
end

--进入英雄训练列表
function HeroTrainModel:successIntoTraining(data)
    for k,v in pairs(data.heros) do
        local id = v.obj.id_h .. v.obj.id_l
        local hero = PlayerData:getInstance():getHeroByID(id)
        hero:setState(HeroState.train) --设置英雄状态
        hero:setTrainTime(v.timeout,v.trainHour)   --设置英雄训练剩余时间
        print(v.timeout)
    end
    print("···",#data.heros)
    local uiCommand = UIMgr:getInstance():getUICtrlByType(UITYPE.HERO_TRAIN)
    if uiCommand ~= nil then
        uiCommand:createList()
    end
end

--返回英雄训练定时器
function HeroTrainModel:successTrainHero(data)
    local hero = PlayerData:getInstance().heroList[data.markId]
    hero:setState(HeroState.train)

    local info = self:getLocalTrain(data.markId)
    hero:setTrainTime(data.interval,info.time)
    self:castResource(info.level,info.time)
    UICommon:getInstance():updatePlayerDataUI()
    self:delLocalTrain(data.markId)

    local uiCommand = UIMgr:getInstance():getUICtrlByType(UITYPE.HERO_TRAIN)
    if uiCommand ~= nil then
        uiCommand:showHeroList()
    end

    --更新英雄训练时间UI
    local cityBuildingListCtrl = MapMgr:getInstance():getCityBuildingListCtrl()
    if cityBuildingListCtrl ~= nil then
        cityBuildingListCtrl:updateHeroTrainTime()
    end
end

function HeroTrainModel:castResource(level,time)
    local info = TrainEffectConfig:getInstance():getConfigInfo(level)
    PlayerData:getInstance():setPlayerWood(info.te_wood*time)
    PlayerData:getInstance():setPlayerFood(info.te_grain*time)
    PlayerData:getInstance():setPlayerIron(info.te_iron*time)
    PlayerData:getInstance():setPlayerMithril(info.te_mithril*time)
end

--立即训练英雄
--data 数据
function HeroTrainModel:reGoldTrainingHero(data)
    local objId = data.obj
    local id = objId.id_h .. objId.id_l
    local hero = PlayerData:getInstance():getHeroByID(id)
    hero:setState(HeroState.finish_train) --设置英雄状态

    local info = self:getLocalData()
    PlayerData:getInstance():setPlayerMithrilGold(info.castGold)
    if info.action == 1 then --立即加速
        self:castResource(info.level,info.time)
    end

    UIMgr:getInstance():closeUI(UITYPE.HERO_TRAIN)
    UICommon:getInstance():updatePlayerDataUI()

    --更新英雄训练时间UI
    local cityBuildingListCtrl = MapMgr:getInstance():getCityBuildingListCtrl()
    if cityBuildingListCtrl ~= nil then
        cityBuildingListCtrl:updateHeroTrainTime()
    end
end

--完成训练英雄
--data 数据
function HeroTrainModel:finishTrainHero(data)
    local objId = data.obj
    local id = objId.id_h .. objId.id_l
    local hero = PlayerData:getInstance():getHeroByID(id)
    hero:setState(HeroState.finish_train)

    local command = UIMgr:getInstance():getUICtrlByType(UITYPE.HERO_TRAIN)
    if command ~= nil then
        command:createList()
    end

    --更新英雄训练时间UI
    local cityBuildingListCtrl = MapMgr:getInstance():getCityBuildingListCtrl()
    if cityBuildingListCtrl ~= nil then
        cityBuildingListCtrl:updateHeroTrainTime()
    end
end

--统计训练中的英雄
function HeroTrainModel:getTrainHeroCount()
    local list = PlayerData:getInstance():getHeroListByState(HeroState.train)
    return #list
end

--获取加速道具数量
function HeroTrainModel:getAccPropCount()
    local total = 0
    local itemlist = ItemData:getInstance():getQuickItemList()
    for k,v in pairs(itemlist) do
        if v.speedType == ItemSpeedType.heroTrain or v.speedType == ItemSpeedType.all then
            total = total + v.number
        end
    end
    return total
end

--道具加速训练英雄
--data 数据
function HeroTrainModel:rePropTrainingHero(data)
    local items = data.items
    local objId = data.obj
    local id = objId.id_h .. objId.id_l
    local hero = PlayerData:getInstance():getHeroByID(id)

    print("ssssssssssss",items.templateId)
    local config = ItemTemplateConfig:getInstance():getItemTemplateByID(items.templateId)
    local second = config.it_turbotime*60
    hero:minusLeftTime(second)
    BagModel:getInstance():useItem(items)

    UIMgr:getInstance():closeUI(UITYPE.HERO_TRAIN)
    UIMgr:getInstance():closeUI(UITYPE.BUILDING_MENU)

    local command = UIMgr:getInstance():getUICtrlByType(UITYPE.HERO_TRAIN)
    if command ~= nil then
        command:createList()
    end

    --更新英雄训练时间UI
    local cityBuildingListCtrl = MapMgr:getInstance():getCityBuildingListCtrl()
    if cityBuildingListCtrl ~= nil then
        cityBuildingListCtrl:updateHeroTrainTime()
    end
end

--取消训练英雄结果
--data 数据
function HeroTrainModel:cancelTrainHeroRes(data)
    local hero = data.hero
    local food = data.food
    local wood = data.wood
    local iron = data.iron
    local mithril = data.mithril

    local id = hero.heroid.id_h .. hero.heroid.id_l
    PlayerData:getInstance():delHero(id)
    local newHero = HeroData.new(hero)
    PlayerData:getInstance():addHero(newHero)

    PlayerData:getInstance():increaseFood(food)
    PlayerData:getInstance():increaseWood(wood)
    PlayerData:getInstance():increaseIron(iron)
    PlayerData:getInstance():increaseMithril(mithril)
    UICommon:getInstance():updatePlayerDataUI()

    UIMgr:getInstance():closeUI(UITYPE.HERO_TRAIN)
    UIMgr:getInstance():closeUI(UITYPE.BUILDING_MENU)

    --更新英雄训练时间UI
    local cityBuildingListCtrl = MapMgr:getInstance():getCityBuildingListCtrl()
    if cityBuildingListCtrl ~= nil then
        cityBuildingListCtrl:updateHeroTrainTime()
    end
end


function HeroTrainModel:saveLocalData(data)
    if self.localData ~= nil then
        return
    end

    self.localData = data
end

function HeroTrainModel:getLocalData()
    return self.localData
end

function HeroTrainModel:delLocalData()
    self.localData = nil
end

function HeroTrainModel:saveLocalTrain(data)
    for k,v in pairs(self.localTrain) do
        if v.id == data.id then
            return
        end
    end
    table.insert(self.localTrain,data)
end

function HeroTrainModel:getLocalTrain(id)
    for k,v in pairs(self.localTrain) do
        if v.id == id then
            return v
        end
    end
end

function HeroTrainModel:delLocalTrain(id)
    for k,v in pairs(self.localTrain) do
        if v.id == id then
            self.localTrain[k] = nil
            break
        end
    end
end

--清理缓存
function HeroTrainModel:clearCache()
    self:init()
end
