
--[[
	jinyan.zhang
	精灵缓存
--]]

SpriteCache = class("SpriteCache")
local instance = nil

local cityCache = require("app.config.common.Citycache")
local worldCache = require("app.config.common.WorldMapCache")


--构造
--返回值(无)
function SpriteCache:ctor()
	
end

--初始化
--返回值(无)
function SpriteCache:init()
	self.loginCache = {}
	self.battleCache = {}
	self.worldMapCache = {}
	self.copyMapCache = {}
	self:setLoginCache()
	self:setBattleCache()
	self:setWorldCache()
	self:setCopyMapCache()
end

--从内存释放后会调用这个接口
--返回值(无)
function SpriteCache:onDestroy()
	MyLog("SpriteCache onDestroy()")
end

--获取单例
--返回值(单例)
function SpriteCache:getInstance()
	if instance == nil then
		instance = SpriteCache.new()
	end
	return instance
end

--设置登录时要加载的图片缓存
--返回值(无)
function SpriteCache:setLoginCache()
	table.insert(self.loginCache,"battle/gonbin/gonjianshou")
	table.insert(self.loginCache,"battle/qibin/qibin_move")
	table.insert(self.loginCache,"battle/qibin/qibinidle")
	for k,v in pairs(cityCache) do
		table.insert(self.loginCache,v.path)
	end
end

--获取登录时的图片缓存
--返回值(图片缓存)
function SpriteCache:getLoginCache()
	return self.loginCache
end

--设置战斗时加载的图片缓存
--返回值(无)
function SpriteCache:setBattleCache()
	table.insert(self.battleCache,"battle/gonbin/gonjianshou")
	table.insert(self.battleCache,"battle/qibin/qibin_att1")
	table.insert(self.battleCache,"battle/qibin/qibin_att1")
	table.insert(self.battleCache,"battle/qibin/qibin_att2")
	table.insert(self.battleCache,"battle/qibin/qibin_death")
	table.insert(self.battleCache,"battle/qibin/qibin_effect_att1")
	table.insert(self.battleCache,"battle/qibin/qibin_effect_att2")
	table.insert(self.battleCache,"battle/qibin/qibin_effect_hurt")
	table.insert(self.battleCache,"battle/qibin/qibin_hurt")
	table.insert(self.battleCache,"battle/qibin/qibin_move")
	table.insert(self.battleCache,"battle/qibin/qibinidle")
	table.insert(self.battleCache,"battle/arrowTower/arrowTower")
	table.insert(self.battleCache,"battle/magicTower/magicTower")
	table.insert(self.battleCache,"battle/turretTower/turetTower")
	table.insert(self.battleCache,"battle/fallingRocks/fallingRocks")
	table.insert(self.battleCache,"battle/bowling/bowling")
	table.insert(self.battleCache,"battle/rocket/rocket")
end

--设置世界地图加载的图片缓存
function SpriteCache:setWorldCache()
	table.insert(self.worldMapCache,"battle/gonbin/gonjianshou")
	table.insert(self.worldMapCache,"battle/lineAnimation")
	table.insert(self.worldMapCache,"battle/redlineAnimation")
	table.insert(self.worldMapCache,"battle/qibin/qibin_att1")
	table.insert(self.worldMapCache,"battle/qibin/qibin_att1")
	table.insert(self.worldMapCache,"battle/qibin/qibin_att2")
	table.insert(self.worldMapCache,"battle/qibin/qibin_death")
	table.insert(self.worldMapCache,"battle/qibin/qibin_effect_att1")
	table.insert(self.worldMapCache,"battle/qibin/qibin_effect_att2")
	table.insert(self.worldMapCache,"battle/qibin/qibin_effect_hurt")
	table.insert(self.worldMapCache,"battle/qibin/qibin_hurt")
	table.insert(self.worldMapCache,"battle/qibin/qibin_move")
	table.insert(self.worldMapCache,"battle/qibin/qibinidle")

	for k,v in pairs(worldCache) do
		table.insert(self.worldMapCache,v.path)
	end
end

--设置进入副本时加载的图片缓存
--返回值(无)
function SpriteCache:setCopyMapCache()
	table.insert(self.copyMapCache,"battle/gonbin/gonjianshou")
	table.insert(self.copyMapCache,"battle/qibin/qibin_att1")
	table.insert(self.copyMapCache,"battle/qibin/qibin_att1")
	table.insert(self.copyMapCache,"battle/qibin/qibin_att2")
	table.insert(self.copyMapCache,"battle/qibin/qibin_death")
	table.insert(self.copyMapCache,"battle/qibin/qibin_effect_att1")
	table.insert(self.copyMapCache,"battle/qibin/qibin_effect_att2")
	table.insert(self.copyMapCache,"battle/qibin/qibin_effect_hurt")
	table.insert(self.copyMapCache,"battle/qibin/qibin_hurt")
	table.insert(self.copyMapCache,"battle/qibin/qibin_move")
	table.insert(self.copyMapCache,"battle/qibin/qibinidle")
	table.insert(self.battleCache,"battle/arrowTower/arrowTower")
	table.insert(self.battleCache,"battle/magicTower/magicTower")
	table.insert(self.battleCache,"battle/turretTower/turetTower")
	table.insert(self.battleCache,"battle/fallingRocks/fallingRocks")
	table.insert(self.battleCache,"battle/bowling/bowling")
	table.insert(self.battleCache,"battle/rocket/rocket")
end

--获取战斗时加载的缓存
--返回值(缓存)
function SpriteCache:getBattleCache()
	return self.battleCache
end

--获取世界地图加载时缓存
--返回值(缓存)
function SpriteCache:getWorldMapCache()
	return self.worldMapCache
end

--获取副本地图加载时缓存
--返回值(缓存)
function SpriteCache:getCopyMapCache()
	return self.copyMapCache
end

--移除所有的缓存图片
--返回值(无)
function SpriteCache:removeAllCache()
	for k,v in pairs(self.battleCache) do
		display.removeSpriteFrameByImageName(v)
	end

	for k,v in pairs(self.loginCache) do
		display.removeSpriteFrameByImageName(v)
	end

	for k,v in pairs(self.worldMapCache) do
		display.removeSpriteFrameByImageName(v)
	end

	for k,v in pairs(self.copyMapCache) do
		display.removeSpriteFrameByImageName(v)
	end

	display.removeUnusedSpriteFrames()
end

--清理缓存数据
--返回值(无)
function SpriteCache:clearCache()
	self:init()
end 




