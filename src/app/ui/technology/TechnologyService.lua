--
-- Author: oyhc
-- Date: 2016-01-05 21:16:03
--
TechnologyService = class("TechnologyService")

local instance = nil

-- 科技升级
local P_CMD_C_UPGRADE_TECH  = 92
-- 服务端主动推送科技升级
local P_CMD_S_UPGRADE_TECH  = 93
-- 使用金币快速研究科技
local P_CMD_C_QUICK_UPGRADE_TECH  = 94
-- 使用物品快速研究科技
local P_CMD_C_QUICK_UPGRADE_TECH_BY_ITEM  = 95

--获取单例
--返回值(单例)
function TechnologyService:getInstance()
	if instance == nil then
		instance = TechnologyService.new()
	end
	return instance
end

--构造
function TechnologyService:ctor()
	self:init()
end

--初始化
function TechnologyService:init()
	-- 返回进入科技界面
	NetMsgMgr:getInstance():registerMsg(P_CMD_C_ENTER_COLLEGE, self, self.reEnterTech)
	-- 返回科技升级
	NetMsgMgr:getInstance():registerMsg(P_CMD_C_UPGRADE_TECH, self, self.reUpgradeTech)
	-- 返回服务端主动推送科技升级
	NetMsgMgr:getInstance():registerMsg(P_CMD_S_UPGRADE_TECH, self, self.reCompleteTech)
	-- 返回使用金币快速研究科技
	NetMsgMgr:getInstance():registerMsg(P_CMD_C_QUICK_UPGRADE_TECH, self, self.reUpgradeTechUseGold)
	-- 返回使用物品快速研究科技
	NetMsgMgr:getInstance():registerMsg(P_CMD_C_QUICK_UPGRADE_TECH_BY_ITEM, self, self.reUpgradeTechUseItem)
end

-- 进入科技界面
-- build_pos 学院建筑位置
function TechnologyService:sentEnterTech(build_pos)
	MyLog("进入科技界面",build_pos)
	local package = {
		build_pos = build_pos,
	}
	NetWorkMgr:getInstance():sendData("game.EnterCollegePacket", package, P_CMD_C_ENTER_COLLEGE)
end

-- 返回进入科技界面
function TechnologyService:reEnterTech(msg)
	MyLog("返回进入科技界面", msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end
	local data = Protobuf.decode("game.EnterCollegeResult", msg.data)
	TechnologyModel:getInstance():getListSuccess(data)
end

-- 科技升级
-- build_pos 学院建筑位置
-- type_id 科技类型（配置表ID）
-- level 需要升的等级,第一次升级设置为1
-- done 是否立刻完成， 1为是，其他值为否
function TechnologyService:sentUpgradeTech(build_pos, type_id, level, done)
	MyLog("科技升级",build_pos, type_id, level, done)
	local package = {
		build_pos = build_pos,
		type_id = type_id,
		level = level,
		done = done,
	}
	NetWorkMgr:getInstance():sendData("game.UpgradeTechPacket", package, P_CMD_C_UPGRADE_TECH)
	MessageProp:apper()
end

-- 返回科技升级
function TechnologyService:reUpgradeTech(msg)
	MyLog("返回科技升级", msg.result)
	MessageProp:dissmis()
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end
	local data = Protobuf.decode("game.UpgradeTechResult", msg.data)
	TechnologyModel:getInstance():upgradeTechSuccess(data)
end

-- 返回科技完成
function TechnologyService:reCompleteTech(msg)
	MessageProp:dissmis()
	MyLog("返回科技完成", msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end
	local data = Protobuf.decode("game.TimeoutTechResult", msg.data)
	TechnologyModel:getInstance():completeTech(data)
end

-- 使用金币快速研究科技
-- build_pos 学院建筑位置
-- type_id 科技类型（配置表ID）
function TechnologyService:sentUpgradeTechUseGold(build_pos, type_id)
	MyLog("使用金币快速研究科技",build_pos)
	local package = {
		build_pos = build_pos,
		type_id = type_id,
	}
	NetWorkMgr:getInstance():sendData("game.QuickUpgradePacket", package, P_CMD_C_QUICK_UPGRADE_TECH)
	MessageProp:apper()
end

-- 返回使用金币快速研究科技
function TechnologyService:reUpgradeTechUseGold(msg)
	MessageProp:dissmis()
	MyLog("使用金币快速研究科技", msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end
	local data = Protobuf.decode("game.QuickUpgradeResult", msg.data)
	-- GatherModel:getInstance():refreshSkillSuccess(data)
end

-- 使用物品快速研究科技
-- build_pos 学院建筑位置
-- type_id 科技类型（配置表ID）
function TechnologyService:sentUpgradeTechUseItem(build_pos, type_id)
	MyLog("使用物品快速研究科技",build_pos)
	local package = {
		build_pos = build_pos,
		type_id = type_id,
	}
	NetWorkMgr:getInstance():sendData("game.QuickUpgradeByItemPacket", package, P_CMD_C_QUICK_UPGRADE_TECH_BY_ITEM)
	MessageProp:apper()
end

-- 返回使用物品快速研究科技
function TechnologyService:reUpgradeTechUseItem(msg)
	MessageProp:dissmis()
	MyLog("返回使用物品快速研究科技", msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end
	local data = Protobuf.decode("game.QuickUpgradeByItemResult", msg.data)
	-- GatherModel:getInstance():refreshSkillSuccess(data)
end
-- 服务器有主动有推送加这句话
TechnologyService:getInstance():init()



