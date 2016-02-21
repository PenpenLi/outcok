--
-- Author: oyhc
-- Date: 2015-12-10 17:46:14
--
GatherService = class("GatherService")

local instance = nil

-- 解聘英雄
local P_CMD_C_DISMISS_HERO = 55
-- 装备列表
local P_CMD_C_EQUIP_LIST  = 78
-- 穿装备
local P_CMD_C_LOADING_EQUIP  = 79
-- 脱装备
local P_CMD_C_UNLOADING_EQUIP  = 80
-- 刷新英雄技能
local P_CMD_C_REFRESH_HERO_SKILL  = 87
-- 获得装备在英雄的装备
local P_CMD_C_HERO_EQUIP_SLOT  = 88
-- 替换刷新的英雄技能
local P_CMD_C_CHANGE_HERO_SKILL  = 90

--获取单例
--返回值(单例)
function GatherService:getInstance()
	if instance == nil then
		instance = GatherService.new()
	end
	return instance
end

--构造
--返回值(无)
function GatherService:ctor(data)
	self:init(data)
end

--初始化
--返回值(无)
function GatherService:init(data)
	-- 返回解雇英雄消息
	NetMsgMgr:getInstance():registerMsg(P_CMD_C_DISMISS_HERO, self, self.reFireHero)
	-- 装备列表消息
	NetMsgMgr:getInstance():registerMsg(P_CMD_C_EQUIP_LIST, self, self.reEquipList)
	-- 穿装备消息
	NetMsgMgr:getInstance():registerMsg(P_CMD_C_LOADING_EQUIP, self, self.reDress)
	-- 脱装备消息
	NetMsgMgr:getInstance():registerMsg(P_CMD_C_UNLOADING_EQUIP, self, self.reUndress)
	-- 刷新英雄技能消息
	NetMsgMgr:getInstance():registerMsg(P_CMD_C_REFRESH_HERO_SKILL, self, self.reRefreshSkill)
	-- 替换刷新的英雄技能
	NetMsgMgr:getInstance():registerMsg(P_CMD_C_CHANGE_HERO_SKILL, self, self.reChangeSkill)
end

-- 解雇英雄消息包
function GatherService:sendFireHero(heroid)
	MyLog("解雇英雄消息包")
	local package = {
		heroid = heroid,
	}
	NetWorkMgr:getInstance():sendData("game.DismissHeroPacket", package, P_CMD_C_DISMISS_HERO)
	MessageProp:apper()
end

-- 返回解雇英雄消息包
function GatherService:reFireHero(msg)
	MessageProp:dissmis()
	MyLog("返回解雇英雄消息包", msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end
	local data = Protobuf.decode("game.DismissHeroResult", msg.data)
	GatherModel:getInstance():fireHeroSuccess(data)
end

-- 请求装备列表
function GatherService:sendEquipList()
	MyLog("请求装备列表")
	NetWorkMgr:getInstance():sendData("", nil, P_CMD_C_EQUIP_LIST)
	MessageProp:apper()
end

-- 返回装备列表
function GatherService:reEquipList(msg)
	MessageProp:dissmis()
	MyLog("返回装备列表", msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end
	local data = Protobuf.decode("game.EquipListResult", msg.data)
	GatherModel:getInstance():createEquipList(data)
end

-- 穿装备
-- equip_id 装备实例id
-- hero_id 英雄实例id
function GatherService:sendDress(equip_id,hero_id)
	MyLog("穿装备消息包")
	local package = {
		equip_id = equip_id,
		hero_id = hero_id,
	}
	NetWorkMgr:getInstance():sendData("game.ShiftEquipPacket", package, P_CMD_C_LOADING_EQUIP)
	MessageProp:apper()
end

-- 返回穿装备
function GatherService:reDress(msg)
	MessageProp:dissmis()
	MyLog("返回穿装备", msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end
	local data = Protobuf.decode("game.ShiftEquipResult", msg.data)
	GatherModel:getInstance():equipOperationSuccess(data,1)
end

-- 脱装备
function GatherService:sendUndress(equip_id,hero_id)
	MyLog("脱装备消息包")
	local package = {
		equip_id = equip_id,
		hero_id = hero_id,
	}
	NetWorkMgr:getInstance():sendData("game.ShiftEquipPacket", package, P_CMD_C_UNLOADING_EQUIP)
	MessageProp:apper()
end

-- 返回脱装备
function GatherService:reUndress(msg)
	MessageProp:dissmis()
	MyLog("返回脱装备", msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end
	local data = Protobuf.decode("game.ShiftEquipResult", msg.data)
	GatherModel:getInstance():equipOperationSuccess(data,2)
end

-- 刷新英雄技能
function GatherService:sendRefreshSkill(pos,heroid)
	MyLog("刷新技能",pos)
	local package = {
		pos = pos,
		heroid = heroid,
	}
	NetWorkMgr:getInstance():sendData("game.RefreshSkillPacket", package, P_CMD_C_REFRESH_HERO_SKILL)
	MessageProp:apper()
end

-- 返回刷新英雄技能
function GatherService:reRefreshSkill(msg)
	MessageProp:dissmis()
	MyLog("返回刷新英雄技能", msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end
	local data = Protobuf.decode("game.RefreshSkillResult", msg.data)
	GatherModel:getInstance():refreshSkillSuccess(data)
end

-- 替换英雄技能
function GatherService:sendChangeSkill(heroid)
	MyLog("替换英雄技能")
	local package = {
		-- pos = pos,
		heroid = heroid,
	}
	NetWorkMgr:getInstance():sendData("game.ChangeSkillPacket", package, P_CMD_C_CHANGE_HERO_SKILL)
	MessageProp:apper()
end

-- 返回替换英雄技能
function GatherService:reChangeSkill(msg)
	MessageProp:dissmis()
	MyLog("返回替换英雄技能", msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end
	local data = Protobuf.decode("game.ChangeSkillResult", msg.data)
	GatherModel:getInstance():changeSkillSuccess(data)
end


