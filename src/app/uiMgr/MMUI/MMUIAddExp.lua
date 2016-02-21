
--[[
	jinyan.zhang
	增加经验
--]]

MMUIAddExp = class("MMUIAddExp",function()
	return display.newLayer()
end)

local scheduler = require("framework.scheduler")

function MMUIAddExp:ctor()
	self:setNodeEventEnabled(true)
	self:init()
end

function MMUIAddExp:init()
	self.oldHeroList = {}
	self.newHeros = {}
	self.data = {}
end

function MMUIAddExp:onEnter()

end

function MMUIAddExp:onExit()
	self:stopTime()
end

--设置旧英雄列表
function MMUIAddExp:setOldHeroList(heros)
	self.oldHeroList = heros
end

--设置新英雄列表
function MMUIAddExp:setNewHeroList(heros)
	self.newHeros = heros
end

--根据唯一id查找英雄
--id 唯一id
function MMUIAddExp:getHeroByID(id,heroList)
	for k,v in pairs(heroList) do
		if v.id == id then
			return v
		end
	end
	print("找不到唯一id为"..id.."的英雄")
end

--获取计算后的数据
function MMUIAddExp:calData()
    local tab = {}
    for k,v in pairs(self.newHeros) do
        local hero = v
        local id = hero.heroid.id_h .. hero.heroid.id_l
        local preHero = self:getHeroByID(id,self.oldHeroList)
        local upLvTimer = hero.level - preHero.level
        local curPer =  preHero.exp/preHero.maxexp*100
        local curLevel = preHero.level
        if curPer < 0 then
           curPer = 0
        end
        
        local per = hero.exp/hero.maxexp*100
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
        info.curExp = preHero.exp
        info.curMaxExp = preHero.maxexp
        info.hero = hero
        table.insert(tab,info)
    end

    return tab
end

--设置数据
function MMUIAddExp:setData(data)
	self.data = data
end

--打开定时器
--返回值(无)
function MMUIAddExp:openTime()
    if self.handle ~= nil then
        return
    end
    self:stopTime()
    self.handle = scheduler.scheduleGlobal(handler(self, self.updateTime), 0.05)
end

--停止定时器
--返回值(无)
function MMUIAddExp:stopTime()
    if self.handle ~= nil then
        scheduler.unscheduleGlobal(self.handle)
        self.handle = nil
    end
end

--更新定时器
function MMUIAddExp:updateTime(dt)
    local per = 0
    for k,v in pairs(self.data) do
        local del = false
        v.curPer = v.curPer + v.addPer
        per = v.curPer
        if v.upLvTimer == 0 then
            if v.curPer >= v.per then
                v.curPer = v.per
                per = v.curPer
                del = true
            end
        else
            if v.curPer >= 100 then
                 v.curPer = 0
                 per = 100
                 v.upLvTimer = v.upLvTimer - 1
                 v.curLevel = v.curLevel + 1 
                 v.labLevel:setString("lv" .. v.curLevel)
            end 
        end
        v.processBar:setPercent(per)

        if del then
            self.data[k] = nil
        end     
    end
end


