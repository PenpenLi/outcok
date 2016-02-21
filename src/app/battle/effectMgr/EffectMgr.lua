
--[[
	jinyan.zhang
	特效管理器
--]]

EffectMgr = class("EffectMgr",function()
	return display.newLayer()
end)

local instance = nil

local scheduler = require("framework.scheduler")

--构造
--返回值(无)
function EffectMgr:ctor()
	self:init()
end

--初始化
--返回值(无)
function EffectMgr:init()
	self.list = {}
end

--加入到舞台后会调用这个接口
--返回值(无)
function EffectMgr:onEnter()
	--MyLog("EffectMgr onEnter()")
end

--离开舞台后会调用这个接口
--返回值(无)
function EffectMgr:onExit()
	--MyLog("EffectMgr onExit()")
end

--从内存释放后会调用这个接口
--返回值(无)
function EffectMgr:onDestroy()
	--MyLog("EffectMgr onDestroy()")
end 

--获取单例
--返回值(单例)
function EffectMgr:getInstance()
	if instance == nil then
		instance = EffectMgr.new()
	end
	return instance
end

--添加特效
--atker 攻击方
--effect 特效
--delayCheckTime 延迟检测碰撞时间
--effectSize 特效大小
--enemyCamp 受击方阵营
--atkAnimationIndex 攻击动画下标
--返回值(无)
function EffectMgr:addEffect(atker,effect,delayCheckTime,effectSize,enemyCamp,atkAnimationIndex)
	local info = {}
	info.effect = effect
	info.delayCheckTime = delayCheckTime
	info.effectSize = effectSize
	info.camp = enemyCamp
	info.animationIndex = atkAnimationIndex
	info.owner = atker
	info.soldierInfoConfig = atker.params
	table.insert(self.list,info)

	local sequence = transition.sequence({
		cc.DelayTime:create(delayCheckTime),
    	cc.CallFunc:create(function()
    		self:removeEffect(atker)
    		self:checkCollision(info)
    	end),
	})
	effect:runAction(sequence)
end

--检测碰撞
--info 待检测特效信息
--返回值(无)
function EffectMgr:checkCollision(info)
	local x,y = info.effect:getPosition()
	local size = info.effectSize
	local atkRect = cc.rect(x-size.width/2,y-size.height/2,size.width,size.height)
	BattleCommon:getInstance():checkCollision(info.owner,atkRect,info.camp,info.animationIndex,info.soldierInfoConfig)
end

--移除特效
--owner 特效拥有者
--返回值(无)
function EffectMgr:removeEffect(owner)
	for k,v in pairs(self.list) do
		if v.owner == owner then
			table.remove(self.list,k)
			v.effect:removeFromParent()
			break
		end
	end
end

--更新特效
--返回值(无)
function EffectMgr:updateEffect()
	
end





