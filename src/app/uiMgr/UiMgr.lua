
--[[
    jinyan.zhang
    UI管理器
--]]

UIMgr = class("UIMgr")
local instance = nil

--UI等级表
local UI_LEVEL =
{
    [UITYPE.BUILDING_MENU] = {level=1},  --建筑菜单是一级界面
    [UITYPE.CITY_BUILD_LIST] = {level=1}, --空地建筑列表是一级界面
    [UITYPE.CITY_BUILD_MAIL] = {level=1}, --邮件界面是一级界面
}

--构造
--返回值(无)
function UIMgr:ctor()
    self:init()
end

--初始化
--返回值(无)
function UIMgr:init()
    self.uiInfo = {}
    self.lastUIType = -1
    self.isCanOpenView = true
end

--是否打开了UI
--uiType UI类型
--返回值(true:是,false:否)
function UIMgr:isOpenByUIType(uiType)
    if self.uiInfo[uiType] ~= nil then
        return true
    end

    for k,v in pairs(UI_LEVEL) do
        if k == uiType then
            return false
        end
    end

    return false
end

--获取UI
--uiType UI类型
--返回值(UI)
function UIMgr:getUICtrlByType(uiType)
    return self.uiInfo[uiType]
end

--打开UI
--uiTYpe UI类型
--data 数据
--返回值(true:打开成功,false:打开失败)
function UIMgr:openUI(uiType,data)
    if self:isOpenByUIType(uiType) then
        MyLog("have open uiTYpe=",uiType)
        return false
    end

    if not self.isCanOpenView then
        MyLog("isCanOpenView=",uiType)
        return false
    end

    MyLog("open uiType=",uiType)

    local ctrl = nil
    if uiType == UITYPE.CITY_BUILD_LIST then    --城内建筑列表界面
        ctrl = InWallBuildingListCommand:getInstance()
    elseif uiType == UITYPE.LOGIN then           --登录界面
        ctrl = LoginCommand:getInstance()
    elseif uiType == UITYPE.LOADING then   --loading界面
        ctrl = LoadingCommand:getInstance()
    elseif uiType == UITYPE.LOGO then    --logo界面（欢迎进入游戏）
        ctrl = LogoCommand:getInstance()
    elseif uiType == UITYPE.CITY then   --城内主界面
        ctrl = CityCommand:getInstance()
    elseif uiType == UITYPE.CITY_BUILD_DETAILS then --详情界面
        ctrl = BuildingDetailsCommand:getInstance()
    elseif uiType == UITYPE.CITY_BUILD_UPGRADE then --升级界面
        ctrl = BuildingUpLvCommand:getInstance()
    elseif uiType == UITYPE.CITY_BUILD_MAIL then --邮件界面
        ctrl = MailsCommand:getInstance()
    elseif uiType == UITYPE.PVP_BATTLE then  --打开PVP战斗界面
        ctrl = PVPBattleCommand:getInstance()
    elseif uiType == UITYPE.OUT_CITY then --打开城外主界面
        ctrl = CityOutCommand:getInstance()
    elseif uiType == UITYPE.TRAINING_CITY then --打开训练界面
        ctrl = MakeSoldierCommand:getInstance()
    elseif uiType == UITYPE.AGGREGATION_CITY then --打开集结界面
        ctrl = AggregationCommand:getInstance()
    elseif uiType == UITYPE.GO_BATTLE_CITY then --打开出征界面
        ctrl = GoBattleCommand:getInstance()
    elseif uiType == UITYPE.INSTANCE_CITY then --打开副本界面
        ctrl = CopyCommand:getInstance()
    elseif uiType == UITYPE.INSTANCE_BATTLE_CITY then --打开副本战斗界面
        ctrl = CopyBattleCommand:getInstance()
    elseif uiType == UITYPE.BUILDING_MENU then --打开建筑菜单界面
        ctrl = Build_menuCommand:getInstance()
    elseif uiType == UITYPE.PVP_BATTLE_RESULT then --打开pvp战斗结果界面
        ctrl = PvPBattleResultCommand:getInstance()
    elseif uiType == UITYPE.LOOK then  --打开侦察界面
        ctrl = LookCommand:getInstance()
    elseif uiType == UITYPE.CITY_WATCHTOWER then --打开瞭望塔界面
        ctrl = WatchTowerCommand:getInstance()
    elseif uiType == UITYPE.PROP_BOX then --打开瞭望塔界面
        ctrl = PropBoxCommand:getInstance()
    elseif uiType == UITYPE.OUT_WALL_BUILDINGLIST then --打开墙外建筑列表界面
        ctrl = OutWallBuildingListCommand:getInstance()
    elseif uiType == UITYPE.TOWER_DEFENSE_LIST then --打开防御塔列表界面
        ctrl = TowerBuildingListCommand:getInstance()
    elseif uiType == UITYPE.BUILDING_ACCELERATION then --打开加速建筑界面
        ctrl = BuildingAccelerationCommand:getInstance()
    elseif uiType == UITYPE.PUB then --酒馆
        ctrl = PubCommand:getInstance()
    elseif uiType == UITYPE.BUILDING_RES_DETAILS then --打开资源详情界面
        ctrl = BuildingResDetailsCommand:getInstance()
    elseif uiType == UITYPE.GATHER then --打开集结处界面
        ctrl = GatherCommand:getInstance()
    elseif uiType == UITYPE.BUILDING_AID_DETAILS then  --打开急救帐篷详情界面
        ctrl = BuildingAidDetailsCommand:getInstance()
    elseif uiType == UITYPE.BUILDING_MARCH_DETAILS then --打开行军帐篷详情界面
        ctrl = BuildingMarchDetailsCommand:getInstance()
    elseif uiType == UITYPE.TREATMENT then              --打开治疗界面
        ctrl = TreatmentCommand:getInstance()
    elseif uiType == UITYPE.WAREHOUSE_DETAILS then      --打开仓库详情界面
        ctrl = WarehouseDetailsCommand:getInstance()
    elseif uiType == UITYPE.BAG then      --打开背包界面
        ctrl = BagCommand:getInstance()
    elseif uiType == UITYPE.FORTRESS then   --打开堡垒界面
        ctrl = FortressCommand:getInstance()
    elseif uiType == UITYPE.WALL_DETAILS then --打开城墙详情界面
        ctrl = BuildWallDetailsCommand:getInstance()
    elseif uiType == UITYPE.TOWER_DETAILS then --打开防御塔详情界面
        ctrl = BuildTowerDetailsCommand:getInstance()
    elseif uiType == UITYPE.WALL then  --打开城墙界面
        ctrl = WallCommand:getInstance()
    elseif uiType == UITYPE.TRAINING_DETAILS then  --打开训练场详情界面
        ctrl = BuildTrainingDetailsCommand:getInstance()
    elseif uiType == UITYPE.HERO_TRAIN then  --打开英雄训练界面
        ctrl = HeroTrainCommand:getInstance()
    elseif uiType == UITYPE.MOVE_CASTLE then  --迁城
        ctrl = MoveCastleAniCommand:getInstance()
    elseif uiType == UITYPE.FINISH_HERO_TRAIN then  --完成英雄训练
        ctrl = FinishHeroTrainCommand:getInstance()
    elseif uiType == UITYPE.PUB_DETAILS then  --酒吧详情界面
        ctrl = BuildPubDetailsCommand:getInstance()
    elseif uiType == UITYPE.GAIN then  --增益界面
        ctrl = GainCommand:getInstance()
    elseif uiType == UITYPE.CASTLE_INFORMATION then  --城堡信息界面
        ctrl = CastleInformationCommand:getInstance()
    elseif uiType == UITYPE.COLLEGE then  --科技界面
        ctrl = TechnologyCommand:getInstance()
    elseif uiType == UITYPE.LORD then  --领主界面
        ctrl = LordCommand:getInstance()
    elseif uiType == UITYPE.LAIRD_SKILL then  --领主天赋界面
        ctrl = LordSkillCommand:getInstance()
    elseif uiType == UITYPE.TERRITORY then  --野外领地界面
        ctrl = TerritoryCommand:getInstance()
    end

    if ctrl == nil then
        MyLog("ctrl == nil")
        return false
    end

    self.uiInfo[uiType] = ctrl
    ctrl:open(uiType,data)

    return true
end

--关闭UI
--uiType UI类型
--返回值(无)
function UIMgr:closeUI(uiType)
    -- MyLog("close uiType=",uiType,"self.uiInfo[uiType]=",self.uiInfo[uiType])
    if self.uiInfo[uiType] ~= nil then
        self.uiInfo[uiType]:close()
        self.uiInfo[uiType] = nil
        -- MyLog("close sccu..")
    end
end

--清理上次打开的UI记录
--返回值(无)
function UIMgr:clearLastOpenUI()
    self.lastUIType = -1
end

--保存上次打开的UI记录
--uiType UI类型
--返回值(无)
function UIMgr:setLastOpenUI(uiType)
    self.lastUIType = uiType
end

--获取UI管理器(单例模式)
--返回值(UI管理器)
function UIMgr:getInstance()
    if instance == nil then
        instance = UIMgr.new()
    end
    return instance
end

--添加UI到场景中显示
--child 要添加的UI
--zorder 层级
--tag tag
--返回值(无)
function UIMgr:addToLayer(child,zorder,tag)
    if zorder == nil then
        zorder = 0
    end
    if tag == nil then
        tag = 0
    end

    local parent = SceneMgr:getInstance():getUILayer()
    parent:addChild(child,zorder,tag)
end

--关闭掉所有UI
--返回值(无)
function UIMgr:closeAll()
    for k,v in pairs(self.uiInfo) do
        self:closeUI(k)
    end
end

--设置能否的开界面
--isCanOpen(true:可以,false:否)
--返回值(无)
function UIMgr:setIsCanOpenView(isCanOpen)
    self.isCanOpenView = isCanOpen
end




