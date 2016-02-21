
--[[
	jinyan.zhang
	动画类
]]

AnmationHelp = class("AnmationHelp")
local instance = nil

--构造
--返回值(无)
function AnmationHelp:ctor()
	self:init()
end

--初始化
--返回值(无)
function AnmationHelp:init()
	self.cachAnmation = {}
end

--获取单例
--返回值(单例)
function AnmationHelp:getInstance()
	if instance == nil then
		instance = AnmationHelp.new()
	end
	return instance
end

--保存动画到缓存中
--anmation 动画
--name 动画名称
--返回值(无)
function AnmationHelp:addAnamtionToCache(anmation,name)
	display.setAnimationCache(name, anmation)
	table.insert(self.cachAnmation,name)
end

--获取缓存中的动画
--name 动画名
--返回值(动画)
function AnmationHelp:getAnmationByName(name)
	return display.getAnimationCache(name)
end

--删除缓存中的动画
--返回值(无)
function AnmationHelp:removeCacheAnmation()
	for k,v in pairs(self.cachAnmation) do
		display.removeAnimationCache(v)
	end
	self.cachAnmation = {}
end

--创建序列帧动画
--anmationName 动画名
--begin 动画从第几帧开始播放
--count 动画帧数
--time 播放时长
--pngName 
--返回值(动画)
function AnmationHelp:createAnmation(anmationName,begin,count,time,pngName)
	pngName = pngName or "%05d.png"
	local anmation = self:getAnmationByName(anmationName)
	if anmation == nil then
		local fileName = anmationName .. pngName
		local frames = display.newFrames(fileName, begin, count)
		anmation = display.newAnimation(frames, time/count)
		self:addAnamtionToCache(anmation,anmationName)
	end
	return anmation
end

--循环播放动画
--anmation 动画
--sprite 播放动画的精灵
--返回值(无)
function AnmationHelp:playAnmationForver(anmation,sprite)
  	sprite:playAnimationForever(anmation)
end

--播放动画
--anmation 动画
--sprite 播放动画的精灵
--返回值(无)
function AnmationHelp:playAnmationOnce(anmation,sprite)
  	sprite:playAnimationOnce(anmation)
end







