
--[[
    jinyan.zhang
    场景管理器
--]]

SceneMgr = class("SceneMgr")
local instance = nil

--构造 
--返回值(无)
function SceneMgr:ctor()

end

--初始化场景
--scene 场景
--返回值(无)
function SceneMgr:init(scene)
    if scene == nil then
        return
    end

    self.gameLayer = display.newLayer()
    self.uiLayer = display.newLayer()
    self.mapLayer = display.newLayer()
    self.battlerLayer = display.newLayer()
    self.effectLayer = EffectMgr:getInstance()
    self.timeMgrLayer = TimeMgr:getInstance()
    self.specialTimeMgr = SpecialTimeMgr:getInstance()
    self.heroMgrLayer = HeroMgr:getInstance()

    scene:addChild(self.gameLayer,GAME_ZORDER.GAME)
    self.gameLayer:addChild(self.uiLayer, GAME_ZORDER.UI)
    self.gameLayer:addChild(self.mapLayer, GAME_ZORDER.MAP)
    self.gameLayer:addChild(self.battlerLayer, GAME_ZORDER.BATTLE)
    self.gameLayer:addChild(self.effectLayer, GAME_ZORDER.EFFECT)
    self.gameLayer:addChild(self.timeMgrLayer,GAME_ZORDER.GAME)
    self.gameLayer:addChild(self.specialTimeMgr,GAME_ZORDER.GAME)
    self.gameLayer:addChild(self.heroMgrLayer,GAME_ZORDER.GAME)
    
    WorldMapPosData:getInstance():calWorldMapPos()
end

--获取单例
--返回值(单例)
function SceneMgr:getInstance()
    if instance == nil then
        instance = SceneMgr.new()
    end
    return instance
end

--获取UI层
--返回值(UI层)
function SceneMgr:getUILayer()
    return self.uiLayer
end

function SceneMgr:getGameLayer()
    return self.gameLayer
end

--运行场景
--scene 场景
--返回值(无)
function SceneMgr:runScene(scene)
	local runScene = cc.Director:getInstance():getRunningScene()
	if nil == runScene then
		cc.Director:getInstance():runWithScene(scene)
	else
		cc.Director:getInstance():replaceScene(scene)
	end
end

--跳转到欢迎界面(目前是logo界面)
--返回值(无)
function SceneMgr:goToWelcomeScene()
    local scene = display.newScene()
    self:init(scene)
    UIMgr:getInstance():openUI(UITYPE.LOGO)
    -- if 1==1 then
    --     local worldMap = MapMgr:getInstance():loadWorldMap()
    --     self.mapLayer:addChild(worldMap)
    --     display.addSpriteFrames("common/common_1" .. ".plist", "common/common_1" .. ".png", function()
    --         local v = "outsidebuilding/wildbuild"
    --         display.addSpriteFrames(v .. ".plist", v .. ".png", function()
    --         local level = 1
    --         local buildingType = BuildType.castle
    --         local buildingSprite = MMUIDrapBuilding.new()
    --         worldMap:getBgMap():addChild(buildingSprite,1)
    --         --占用格子数
    --         local girdCount = BuildingTypeConfig:getInstance():getConfigInfo(buildingType).bt_wildmaphold
    --         girdCount = 4
    --         buildingSprite:setGridCount(girdCount)
    --         --建筑图片路径
    --         local resPath = BuildingUpLvConfig:getInstance():getBuildingResPath2(buildingType,level)
    --         buildingSprite:setSpritePath("B2701.png")
    --         --计算坐标列表
    --         buildingSprite:calPosByGridPos(cc.p(2,4))
    --         buildingSprite:create()
    --         buildingSprite:setSureCallback(self.onSure,self)
    --         end)
    --     end)
    -- end 
    self:runScene(scene)
end

function SceneMgr:onSure()
    print("callback..")
end

--跳转到登录界面
--返回值(无)
function SceneMgr:goToLoginScene()
    UIMgr:getInstance():setIsCanOpenView(false)
    self:clearCache()
    UIMgr:getInstance():setIsCanOpenView(true)
    UIMgr:getInstance():openUI(UITYPE.LOGIN)
end 

--跳转到城内界面
--account 账号
--pwd 密码
--返回值(无)
function SceneMgr:goToCity(account,pwd)
    self:clearCache()
    if account ~= nil and pwd ~= nil then
        UIMgr:getInstance():openUI(UITYPE.LOADING,{type=LoadingType.LOGIN})
        CalLoadingTime:getInstance():setBeginEnterGameTime()
        CalLoadingTime:getInstance():setBeginLoginConfigTime()
    else
        CalLoadingTime:getInstance():setBeginCityMapConfigTime()
        CalLoadingTime:getInstance():setBeginCityMapTime()
        UIMgr:getInstance():openUI(UITYPE.LOADING,{type=LoadingType.ENTER_CITY})
    end
end

--从PVP跳转到城内界面
--返回值(无)
function SceneMgr:fromPvpGoToCity()
    CalLoadingTime:getInstance():setBeginCityMapConfigTime()
    CalLoadingTime:getInstance():setBeginCityMapTime()
    self:clearCache()
    UIMgr:getInstance():openUI(UITYPE.LOADING,{type=LoadingType.FROM_PVP_ENTER_CITY})
end 

--从PVP跳转到大地图界面
function SceneMgr:fromPvpGoToWorldMap()
    CalLoadingTime:getInstance():setBeginWorldMapConfigTime()
    self:clearCache()
    UIMgr:getInstance():openUI(UITYPE.LOADING,{type=LoadingType.FROM_PVP_ENTER_WORLD})
end

--从PVP界面进入世界地图
--返回值(无)
function SceneMgr:fromPvpEnterWorldMap()
    self:enterWorld()
    UICommon:getInstance():openMailDetailsView()
    CalLoadingTime:getInstance():calLoadWorldMapConfigTime()
end

--进入城内界面
--返回值(无)
function SceneMgr:enterCity()
    local city = MapMgr:getInstance():loadCity()
    self.mapLayer:addChild(city,MAP_ZORDER.CITY)
    UIMgr:getInstance():openUI(UITYPE.CITY, data)
    self:setLastOpenScene(SCENE_TYPE.CITY)
    TimeMgr:getInstance():openTime()
    HeartbeatCheckCommand:getInstance():openHeartbeatCheck()
    if self.first == nil then
        CalLoadingTime:getInstance():calFinishEnterGameTime()
        self.first = false
    else
        CalLoadingTime:getInstance():calLoadCityMapTime()
    end
end 

--从副本进入城内界面
--返回值(无)
function SceneMgr:fromCopyEnterCity()
    self:enterCity()
    UIMgr:getInstance():openUI(UITYPE.INSTANCE_CITY)
end

--跳转到世界地图
--返回值(无)
function SceneMgr:goToWorld()
    CalLoadingTime:getInstance():setEnterWorldTime()
    CalLoadingTime:getInstance():setBeginWorldMapConfigTime()
    self:clearCache()
    UIMgr:getInstance():openUI(UITYPE.LOADING,{type=LoadingType.ENTER_WORLD_MAP})
end

--进入世界地图
--返回值(无)
function SceneMgr:enterWorld()
    local worldMap = MapMgr:getInstance():loadWorldMap()
    self.mapLayer:addChild(worldMap,MAP_ZORDER.WORLD)
    UIMgr:getInstance():openUI(UITYPE.OUT_CITY)
    TimeMgr:getInstance():openTime()
    HeroMgr:getInstance():openTime()
    CastleModel:getInstance():clearCache()
    self:setLastOpenScene(SCENE_TYPE.WORLD)
    HeartbeatCheckCommand:getInstance():openHeartbeatCheck()
    CalLoadingTime:getInstance():calEnterWorldTime()
    CalLoadingTime:getInstance():setBeginGetCastleListTime()
end

--跳转到副本地图
--返回值(无)
function SceneMgr:goToCopyMap()
    self:clearCache()
    UIMgr:getInstance():openUI(UITYPE.LOADING,{type=LoadingType.ENTER_COPY})
end

--进入副本地图
--返回值(无)
function SceneMgr:enterCopyMap()
    local logic = BattleLogic:getInstance()
    logic:setBattleType(BattleType.copy)
    self.battlerLayer:addChild(logic)
    UIMgr:getInstance():openUI(UITYPE.INSTANCE_BATTLE_CITY)
    TimeMgr:getInstance():openTime()
    self:setLastOpenScene(SCENE_TYPE.COPY)
    HeartbeatCheckCommand:getInstance():openHeartbeatCheck()
end

--从副本跳转到城内界面
--返回值(无)
function SceneMgr:fromCopyGoToCity()
    self:clearCache()
    UIMgr:getInstance():openUI(UITYPE.LOADING,{type=LoadingType.FROM_COPY_ENTER_CITY})
end 

--跳转到战斗界面
--返回值(无)
function SceneMgr:goToBattle()
    CalLoadingTime:getInstance():setBeginBattleConfigTime()
    self:clearCache()
    UIMgr:getInstance():openUI(UITYPE.LOADING,{type=LoadingType.GOTO_BATTLE})
end

--进入战斗界面
--返回值(无)
function SceneMgr:enterBattle()
    local logic = BattleLogic:getInstance()
    logic:setBattleType(BattleType.pvpBattle)
    self.battlerLayer:addChild(logic)
    UIMgr:getInstance():openUI(UITYPE.PVP_BATTLE)
    TimeMgr:getInstance():openTime()
    HeartbeatCheckCommand:getInstance():openHeartbeatCheck()
end

--清理缓存
--返回值(无)
function SceneMgr:clearCache()
    HeroMgr:getInstance():delAllSoldier()
    MapMgr:getInstance():clearData()
    AllPlayerMarchModel:getInstance():clearCache()
    self.battlerLayer:removeAllChildren()
    self.effectLayer:removeAllChildren()
    UIMgr:getInstance():closeAll()
    self.mapLayer:removeAllChildren()
    HeartbeatCheckCommand:getInstance():closeHeartbeatCheck()
    TimeMgr:getInstance():destroyTime()
    self.heroMgrLayer:stopTime()
    self.heroMgrLayer:clearData()
    AnmationCache:getInstance():removeAllAnimationCache()
    --SpriteCache:getInstance():removeAllCache()
end

--是否在副本地图中
--返回值(true:是,false:否)
function SceneMgr:isAtCopyMap()
    if MapMgr:getInstance():getCopyMap() then
        return true
    end
end

--是否在战斗中
function SceneMgr:isAtBattle()
    if MapMgr:getInstance():getWorldMap() then
        return false
    end

    if MapMgr:getInstance():getCityMap() then
        return false
    end
    
    return true
end

--记录上次打开的场景
--sceneType 场景类型
--返回值(无)
function SceneMgr:setLastOpenScene(sceneType)
    self.lastOpenSceneType = sceneType
end

--获取上次打开的场景类型
--返回值(无)
function SceneMgr:getLastOpenSceneType()
    return self.lastOpenSceneType
end








