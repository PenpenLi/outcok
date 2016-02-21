
--[[
	jinyan.zhang
	计算加载时间
--]]

CalLoadingTime = class("CalLoadingTime")

local instance = nil

function CalLoadingTime:ctor()
	self:init()
end

function CalLoadingTime:init()
	self.enterGameTime = 0
	self.connectHttpTime = 0
	self.loginServerTime = 0
	self.logicServerTime = 0
	self.loginConfigTime = 0
	self.enterWorldTime = 0
	self.loadWorldMapConfigTime = 0
	self.enterCityMapTime = 0
	self.loadCityMapConfigTime = 0
	self.getHurtListTime = 0
	self.getItemListTime = 0
	self.getWallEffectTime = 0
	self.loadBattleConfigTime = 0
	self.getCastListTime = 0
end

--获取单例
--返回值(单例)
function CalLoadingTime:getInstance()
    if instance == nil then
        instance = CalLoadingTime.new()
    end
    return instance
end

--设置获取城堡列表时间
function CalLoadingTime:setBeginGetCastleListTime()
	self.getCastListTime = Common:getOSTime()
end

--计算获取城堡列表花费时间
function CalLoadingTime:calGetCastleListTime()
	local time = Common:getOSTime() - self.getCastListTime
	print("获取城堡列表花费时间为：",time,"秒")
end

--计算加载战斗配置花费时间
function CalLoadingTime:calBattleConfigTime()
	local time = Common:getOSTime() - self.loadBattleConfigTime
	print("加载战斗配置花费时间为：",time,"秒")
end

--设置开始加载战斗配置时间
function CalLoadingTime:setBeginBattleConfigTime()
	self.loadBattleConfigTime = Common:getOSTime()
end

--计算加载战斗配置花费时间
function CalLoadingTime:calBattleConfigTime()
	local time = Common:getOSTime() - self.loadBattleConfigTime
	print("加载战斗配置花费时间为：",time,"秒")
end

--设置开始获取伤兵列表时间
function CalLoadingTime:setBeginGetHurtListTime()
	self.getHurtListTime = Common:getOSTime()
end

--计算获取伤兵列表花费时间
function CalLoadingTime:calGetHurtListTime()
	local time = Common:getOSTime() - self.getHurtListTime
	print("获取伤兵列表花费时间为：",time,"秒")
end

--设置开始获取物品列表时间
function CalLoadingTime:setBeginGetItemListTime()
	self.getItemListTime = Common:getOSTime()
end

--计算获取物品列表花费时间
function CalLoadingTime:calGetItemListTime()
	local time = Common:getOSTime() - self.getItemListTime
	print("获取物品列表花费时间为：",time,"秒")
end

--设置开始获取城墙效果列表时间
function CalLoadingTime:setBeginGetWallEffectTime()
	self.getWallEffectTime = Common:getOSTime()
end

--计算获取城墙效果花费时间
function CalLoadingTime:calGetWallEffectTime()
	local time = Common:getOSTime() - self.getWallEffectTime
	print("获取城墙效果花费时间为：",time,"秒")
end

--设置开始进入游戏时间
function CalLoadingTime:setBeginEnterGameTime()
	self.enterGameTime = Common:getOSTime()
end

--计算进入游戏花费时间
function CalLoadingTime:calFinishEnterGameTime()
	local time = Common:getOSTime() - self.enterGameTime
	print("登录到游戏花费时间为：",time,"秒")
end

--设置连接Http花费时间
function CalLoadingTime:setBeginConnectHttpTime()
	self.connectHttpTime = Common:getOSTime() 
end

--计算连接HTTP花费时间
function CalLoadingTime:calConnectHttpTime()
	local time = Common:getOSTime() - self.connectHttpTime
	print("连接http花费时间为：",time,"秒")
end

--设置开始连接登录服时间
function CalLoadingTime:setBeginLoginTime()
	self.loginServerTime = Common:getOSTime() 
end

--计算连接登录服时间
function CalLoadingTime:calLoginTime()
	local time = Common:getOSTime() - self.loginServerTime
	print("连接登录服花费时间为：",time,"秒")
end

--设置开始连接逻辑服时间
function CalLoadingTime:setBeginLogicTime()
	self.logicServerTime = Common:getOSTime() 
end

--计算连接逻辑服时间
function CalLoadingTime:calLogicTime()
	local time = Common:getOSTime() - self.logicServerTime
	print("连接逻辑服花费时间为：",time,"秒")
end

--设置加载登录配置时间
function CalLoadingTime:setBeginLoginConfigTime()
	self.loginConfigTime = Common:getOSTime() 
end

--计算加载登录配置时间
function CalLoadingTime:calLoginConfigTime()
	local time = Common:getOSTime() - self.loginConfigTime
	print("加载登录配置花费时间为：",time,"秒")
end

--设置进入世界地图时间
function CalLoadingTime:setEnterWorldTime()
	self.enterWorldTime = Common:getOSTime() 
end

--计算进入世界地图时间
function CalLoadingTime:calEnterWorldTime()
	local time = Common:getOSTime() - self.enterWorldTime
	print("进入世界地图花费时间为：",time,"秒")
end

--设置加载进入世界地图配置时间
function CalLoadingTime:setBeginWorldMapConfigTime()
	self.loadWorldMapConfigTime = Common:getOSTime() 
end

--计算加载世界地图配置时间
function CalLoadingTime:calLoadWorldMapConfigTime()
	local time = Common:getOSTime() - self.loadWorldMapConfigTime
	print("加载世界地图配置花费时间为：",time,"秒")
end

--设置进入城内地图时间
function CalLoadingTime:setBeginCityMapTime()
	self.enterCityMapTime = Common:getOSTime() 
end

--计算进入城内地图时间
function CalLoadingTime:calLoadCityMapTime()
	local time = Common:getOSTime() - self.enterCityMapTime
	print("加载城内地图花费时间为：",time,"秒")
end

--设置加载城内地图配置时间
function CalLoadingTime:setBeginCityMapConfigTime()
	self.loadCityMapConfigTime = Common:getOSTime() 
end

--计算加载进入城内地图配置时间
function CalLoadingTime:calLoadCityMapConfigTime()
	local time = Common:getOSTime() - self.loadCityMapConfigTime
	print("加载城内地图配置花费时间为：",time,"秒")
end








