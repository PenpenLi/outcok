
--[[
	jinyan.zhang
	动画缓存
--]]

AnmationCache = class("AnmationCache")
local instance = nil

--构造
--返回值(无)
function AnmationCache:ctor()
	
end

--初始化
--返回值(无)
function AnmationCache:init()
	self.battleCache = {}
	self.worldMapCache = {}
	self.copyMapCache = {}
	self:setBattleCache()
	self:setWorldMapCache()
	self:setCopyMapCache()
end

--从内存释放后会调用这个接口
--返回值(无)
function AnmationCache:onDestroy()
	--MyLog("AnmationCache onDestroy()")
end

--获取单例
--返回值(单例)
function AnmationCache:getInstance()
	if instance == nil then
		instance = AnmationCache.new()
	end
	return instance
end

--设置进入世界地图时加载的动画缓存
--返回值(无)
function AnmationCache:setWorldMapCache()
	local soldConfigInfo = BATTLE_CONFIG[SOLDIER_TYPE.archer]
	self:addConfigCache(soldConfigInfo.idle,self.worldMapCache)
	self:addConfigCache(soldConfigInfo.move,self.worldMapCache)
	self:addConfigCache(soldConfigInfo.hurt,self.worldMapCache)
	self:addConfigCache(soldConfigInfo.death,self.worldMapCache)
	self:addConfigCache(soldConfigInfo.att1,self.worldMapCache)
	self:addConfigCache(soldConfigInfo.att2,self.worldMapCache)
	self:addConfigCache(soldConfigInfo.effect.att1,self.worldMapCache)
	self:addConfigCache(soldConfigInfo.effect.att2,self.worldMapCache)
	self:addConfigCache(soldConfigInfo.effect.hurt1,self.worldMapCache)
	self:addConfigCache(soldConfigInfo.effect.hurt2,self.worldMapCache)
end

--设置战斗时加载的动画缓存
--返回值(无)
function AnmationCache:setBattleCache()
	for i=1,#BATTLE_CONFIG do
		local soldConfigInfo = BATTLE_CONFIG[i]
		self:addConfigCache(soldConfigInfo.idle,self.battleCache)
		self:addConfigCache(soldConfigInfo.move,self.battleCache)
		self:addConfigCache(soldConfigInfo.hurt,self.battleCache)
		self:addConfigCache(soldConfigInfo.death,self.battleCache)
		self:addConfigCache(soldConfigInfo.att1,self.battleCache)
		self:addConfigCache(soldConfigInfo.att2,self.battleCache)
		self:addConfigCache(soldConfigInfo.effect.att1,self.battleCache)
		self:addConfigCache(soldConfigInfo.effect.att2,self.battleCache)
		self:addConfigCache(soldConfigInfo.effect.hurt1,self.battleCache)
		self:addConfigCache(soldConfigInfo.effect.hurt2,self.battleCache)
	end
end

--设置进入副本时加载的动画缓存x
--返回值(无)
function AnmationCache:setCopyMapCache()
	for i=1,#BATTLE_CONFIG do
		local soldConfigInfo = BATTLE_CONFIG[i]
		self:addConfigCache(soldConfigInfo.idle,self.copyMapCache)
		self:addConfigCache(soldConfigInfo.move,self.copyMapCache)
		self:addConfigCache(soldConfigInfo.hurt,self.copyMapCache)
		self:addConfigCache(soldConfigInfo.death,self.copyMapCache)
		self:addConfigCache(soldConfigInfo.att1,self.copyMapCache)
		self:addConfigCache(soldConfigInfo.att2,self.copyMapCache)
		self:addConfigCache(soldConfigInfo.effect.att1,self.copyMapCache)
		self:addConfigCache(soldConfigInfo.effect.att2,self.copyMapCache)
		self:addConfigCache(soldConfigInfo.effect.hurt1,self.copyMapCache)
		self:addConfigCache(soldConfigInfo.effect.hurt2,self.copyMapCache)
	end
end

--添加配置信息至缓存
--configInfo 配置
--cache 缓存
--返回值(无)
function AnmationCache:addConfigCache(configInfo,cache)
	if configInfo == nil then
		return
	end

	for i=1,8 do
		self:pushback(configInfo[i],configInfo.begin,configInfo.count,configInfo.time,cache)
	end

	self:pushback(configInfo.path,configInfo.begin,configInfo.count,configInfo.time,cache)
end

--压入动画配置到缓存
--animationName 动画名字
--begin 开始帧数
--count 动画帧数
--time  动画时间
--返回值(无)
function AnmationCache:pushback(animationName,begin,count,time,cache)
	if animationName == nil or begin == nil or count == nil or time == nil then
		return 
	end

	local info = {}
	info.begin = begin
	info.count = count
	info.time = time
	info.animationName = animationName
	table.insert(cache,info)
end

--获取战斗时加载的动画缓存
--返回值(缓存)
function AnmationCache:getBattleCache()
	return self.battleCache
end

--获取世界地图加载的动画缓存
--返回值(缓存)
function AnmationCache:getWorldMapCache()
	return self.worldMapCache
end

--获取副本地图加载的动画缓存
--返回值(缓存)
function AnmationCache:getCopyMapCache()
	return self.copyMapCache
end

--删除所有的动画缓存
--返回值(无)
function AnmationCache:removeAllAnimationCache()
	AnmationHelp:getInstance():removeCacheAnmation()
end

--清理缓存数据
--返回值(无)
function AnmationCache:clearCache()
	self:init()
end 





