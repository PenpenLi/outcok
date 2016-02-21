--
-- Author: Your Name
-- Date: 2015-11-11 22:21:58
--
GoBattleModel = class("GoBattleModel")

local instance = nil

--构造
--返回值(无)
function GoBattleModel:ctor(data)
	self:init(data)
end

--获取单例
--返回值(单例)
function GoBattleModel:getInstance()
	if instance == nil then
		instance = GoBattleModel.new()
	end
	return instance
end

--初始化
--返回值(无)
function GoBattleModel:init(data)
	--军队列表
	self.armsList = {}
    self.clickedHeroID = 0 --被点击的英雄id
end

function GoBattleModel:getClickedHeroID()
	return self.clickedHeroID
end

--清理缓存
function GoBattleModel:clearCache()
	self:init()
end

