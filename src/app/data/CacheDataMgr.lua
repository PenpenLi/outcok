

--[[
	jinyan.zhang
	缓存数据管理器
--]]

CacheDataMgr = class("CacheDataMgr")

local instance = nil

--构造
--返回值(无)
function CacheDataMgr:ctor()
end

--初始化
--返回值(无)
function CacheDataMgr:init()

end

--获取单例
--返回值(单例)
function CacheDataMgr:getInstance()
	if instance == nil then
		instance = CacheDataMgr.new()
	end
	return instance
end

--清理缓存数据
--返回值(无)
function CacheDataMgr:clearCache()
	AllPlayerMarchModel:getInstance():clearCache()
	BattleData:getInstance():clearCachData()
	CityBuildingModel:getInstance():clearCache()
	CopyBattleModel:getInstance():clearCache()
	MailsModel:getInstance():clearCache()
	PlayerData:getInstance():clearCache()
	LoginModel:getInstance():clearCache()
	WatchTowerModel:getInstance():clearCache()
	NetWorkMgr:getInstance():clearCache()
	ArmsData:getInstance():clearCache()
	TimeInfoData:getInstance():clearCache()
	PlayerMarchModel:getInstance():clearCache()
	MakeSoldierModel:getInstance():clearCache()
	CastleModel:getInstance():clearCache()
	CopyModel:getInstance():clearCache()
	BuildingAccelerationModel:getInstance():clearCache()
	UseGoldAcceResProduceModel:getInstance():clearCache()
	UseGoldMakeSoldierAcceModel:getInstance():clearCache()
	BagModel:getInstance():clearCache()
	BuildingMarchDetailsModel:getInstance():clearCache()
	GatherModel:getInstance():clearCache()
	GoBattleModel:getInstance():clearCache()
	PubModel:getInstance():clearCache()
	TreatmentModel:getInstance():clearCache()
	WallModel:getInstance():clearCache()
	HeroTrainModel:getInstance():clearCache()
	UnLockAreaModel:getInstance():clearCache()
	TechnologyModel:getInstance():clearCache()
	OutBuildingData:getInstance():clearCachData()
	TerritoryModel:getInstance():clearCache()
	OutBuildingMgr:getInstance():clearCache()
	--关掉一直开的定时器(此时是断线重连了)
	SpecialTimeMgr:getInstance():destroyTime()
end


