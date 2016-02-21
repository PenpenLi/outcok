
--[[
	jinyan.zhang
	英雄管理类
--]]

HeroMgr = class("HeroMgr",function()
	return display.newLayer()
end)

local instance = nil

local scheduler = require("framework.scheduler")

--构造
--返回值(无)
function HeroMgr:ctor()
	self:setNodeEventEnabled(true)
	self:init()
end

--初始化
--返回值(无)
function HeroMgr:init()
	self.atterList = {}  --攻击阵营列表
	self.deferList = {}  --防守阵营列表
	self.marchList = {}  --行军列表
end

--更新定时器
--dt 时间
--返回值(无)
function HeroMgr:update(dt)
	for k,v in pairs(self.atterList) do
		v.hero:update(dt)
	end

	for k,v in pairs(self.deferList) do
		v.hero:update(dt)
	end
end

--打开定时器
--返回值(无)
function HeroMgr:openTime()
	if self.handle  ~= nil then
		return
	end
    self:stopTime()
    self.handle = scheduler.scheduleGlobal(handler(self, self.update), 0)
end

--停止定时器
--返回值(无)
function HeroMgr:stopTime()
	if self.handle ~= nil then
		scheduler.unscheduleGlobal(self.handle)
		self.handle = nil
	end
end

--获取单例
--返回值(单例)
function HeroMgr:getInstance()
	if instance == nil then
		instance = HeroMgr.new()
	end
	return instance
end

--查找士兵
--hero 士兵
--返回值(士兵)
function HeroMgr:findSoldier(hero)
	local soldierlist = {}
	if hero.camp == CAMP.ATTER then
		soldierlist = self.atterList
	elseif hero.camp == CAMP.DEFER then
		soldierlist = self.deferList
	end

	for k,v in pairs(soldierlist) do
		if v.hero == hero then
			return v
		end
	end
end

--添加士兵
--hero 士兵
--soldierType 士兵类型
--camp 阵营(1:攻方士兵,0:守方士兵)
--row 行
--col 列
--返回值(无)
function HeroMgr:addSoldier(hero,soldierType,camp,row,col)
	if not self:findSoldier(hero) then
		local info = {}
		info.hero = hero
		info.row = row
		info.col = col
		info.camp = camp
		info.soldierType = soldierType
		if camp == CAMP.ATTER then
			table.insert(self.atterList,info)
		elseif camp == CAMP.DEFER then
			table.insert(self.deferList,info)
		end
	end
end

--获取士兵列表
--camp 阵营
--返回值(士兵列表)
function HeroMgr:getSoldierList(camp)
	if camp == CAMP.ATTER then
		return self.atterList
	elseif camp == CAMP.DEFER then
		return self.deferList
	end
end

--删除士兵
--hero 士兵
--返回值(无)
function HeroMgr:delSolider(hero)
	local soldierlist = {}
	if hero.camp == CAMP.ATTER then
		soldierlist = self.atterList
	elseif hero.camp == CAMP.DEFER then
		soldierlist = self.deferList
	end

	for k,v in pairs(soldierlist) do
		if v.hero == hero then
			soldierlist[k] = nil
			v.hero:removeFromParent()
			break
		end
	end
end

--删除所有士兵
--返回值(无)
function HeroMgr:delAllSoldier()
	local atterList = HeroMgr:getInstance():getSoldierList(CAMP.ATTER)
    for k,v in pairs(atterList) do
    	v.hero:remove()
    end

    local deferList = HeroMgr:getInstance():getSoldierList(CAMP.DEFER)
    for k,v in pairs(deferList) do
    	v.hero:remove()
   	end

    self:clearData()
end

--清理数据
--返回值(无)
function HeroMgr:clearData()
	self:init()
end

--查找英雄通过id
--id 英雄id
--heroList 英雄列表
--返回值(英雄)
function HeroMgr:findHeroById(heroList,id)
	for k,v in pairs(heroList) do
		if v.id == id then
			return v
		end
	end
end

--获取英雄
--id 英雄id
--camp 阵营
--返回值(英雄)
function HeroMgr:getHeroById(id,camp)
	if camp == CAMP.ATTER then
		return self:findHeroById(self.atterList,id)
	elseif camp == CAMP.DEFER then
		return self:findHeroById(self.deferList,id)
	end
end

--加入到舞台后会调用这个接口
--返回值(无)
function HeroMgr:onEnter()
	MyLog("HeroMgr onEnter()")
end

--离开舞台后会调用这个接口
--返回值(无)
function HeroMgr:onExit()
	--MyLog("HeroMgr onExit()")
	self:stopTime()
	instance = nil
end

--从内存释放后会调用这个接口
--返回值(无)
function HeroMgr:onDestroy()
	--MyLog("HeroMgr onDestroy()")
end 

--创建
function HeroMgr:createArms()
	
end




