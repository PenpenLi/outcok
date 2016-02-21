--
-- Author: oyhc
-- Date: 2016-01-15 14:28:02
--
LordService = class("LordService")

local instance = nil

-- 修改玩家头像
local P_CMD_C_PLAYER_CHG_AVATA = 96
-- 增加一点体力值
local P_CMD_S_PLAYER_ADD_A_POWER  = 97
-- 天赋升级
local P_CMD_C_UPGRADE_TALENT  = 99
-- 服务端主动推送天赋升级
local P_CMD_S_UPGRADE_TALENT  = 100
-- 重置天赋点数
local P_CMD_C_RESET_TALENTPOINT  = 101
-- 使用领主技能
local P_CMD_C_USE_LORD_SKILL  = 103
-- 领主技能持续时间结束
local P_CMD_S_DUARTION_TIMEOUT  = 104

--获取单例
--返回值(单例)
function LordService:getInstance()
	if instance == nil then
		instance = LordService.new()
	end
	return instance
end

--构造
--返回值(无)
function LordService:ctor()
	self:init()
end

--初始化
function LordService:init()
	-- 返回修改玩家头像
	NetMsgMgr:getInstance():registerMsg(P_CMD_C_PLAYER_CHG_AVATA, self, self.reChangeHead)
	-- 增加一点体力值
	NetMsgMgr:getInstance():registerMsg(P_CMD_S_PLAYER_ADD_A_POWER, self, self.onAddPower)
	-- 进入领主天赋界面
	NetMsgMgr:getInstance():registerMsg(P_CMD_C_ENTER_TALENT, self, self.reEnterTalent)
	-- 天赋升级
	NetMsgMgr:getInstance():registerMsg(P_CMD_C_UPGRADE_TALENT, self, self.reUpgradeTalent)
	-- 重置天赋点数
	NetMsgMgr:getInstance():registerMsg(P_CMD_C_RESET_TALENTPOINT, self, self.reResetTalentPoint)
	-- 获得领主技能列表
	NetMsgMgr:getInstance():registerMsg(P_CMD_C_LORD_SKILL_LIST, self, self.reLordSkillList)
	-- 使用领主技能
	NetMsgMgr:getInstance():registerMsg(P_CMD_C_USE_LORD_SKILL, self, self.reUseLordSkill)
	-- 领主技能持续时间结束
	NetMsgMgr:getInstance():registerMsg(P_CMD_S_DUARTION_TIMEOUT, self, self.reLordSkillEnd)
end

-- 修改玩家头像
-- image 要修改形象配置表ID值
-- cost_type 花费类型, 1 金币， 2 物品
function LordService:sentChangeHead(image, cost_type)
	MyLog("修改玩家头像",image, cost_type)
	local package = {
		image = image,
		cost_type = cost_type,
	}
	NetWorkMgr:getInstance():sendData("game.PlayerChgAvatarPacket", package, P_CMD_C_PLAYER_CHG_AVATA)
	MessageProp:apper()
end

-- 返回修改玩家头像
function LordService:reChangeHead(msg)
	MyLog("返回修改玩家头像", msg.result)
	MessageProp:dissmis()
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end
	local data = Protobuf.decode("game.PlayerChgAvatarResult", msg.data)
	LordModel:getInstance():changeHeadSuccess(data)
end

-- 添加体力值（服务器主动推送）
function LordService:onAddPower(msg)
	MyLog("添加体力值（服务器主动推送）", msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end
	local data = Protobuf.decode("game.TypeAttribPacket", msg.data)
	LordModel:getInstance():onAddPower(data)
end

-- 进入领主天赋界面
function LordService:sentEnterTalent()
	MyLog("进入领主天赋界面")
	NetWorkMgr:getInstance():sendData("", nil, P_CMD_C_ENTER_TALENT)
end

-- 返回进入领主天赋界面
function LordService:reEnterTalent(msg)
	MyLog("返回进入领主天赋界面", msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end
	local data = Protobuf.decode("game.EnterTalentResult", msg.data)
	LordModel:getInstance():getListSuccess(data)
end

-- 天赋升级
-- template_id 天赋模板ID（配置表ID）
-- cost_type 需要升的等级,第一次升级设置为1
function LordService:sentUpgradeTalent(template_id,level)
	MyLog("天赋升级",template_id,level)
	local package = {
		template_id = template_id,
		level = level,
	}
	NetWorkMgr:getInstance():sendData("game.UpgradeTalentPacket", package, P_CMD_C_UPGRADE_TALENT)
end

-- 返回天赋升级
function LordService:reUpgradeTalent(msg)
	MyLog("返回天赋升级", msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end
	local data = Protobuf.decode("game.UpgradeTalentResult", msg.data)
	LordModel:getInstance():upgradeTelentSuccess(data)
end

-- 重置天赋点数
function LordService:sentResetTalentPoint()
	MyLog("重置天赋点数")
	NetWorkMgr:getInstance():sendData("", nil, P_CMD_C_RESET_TALENTPOINT)
end

-- 返回重置天赋点数
function LordService:reResetTalentPoint(msg)
	MyLog("返回重置天赋点数", msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end
	local data = Protobuf.decode("game.ResetTalentResult", msg.data)
	LordModel:getInstance():resetTalentPointSuccess(data)
end

-- 获得领主技能列表
function LordService:sentLordSkillList()
	MyLog("获得领主技能列表")
	NetWorkMgr:getInstance():sendData("", nil, P_CMD_C_LORD_SKILL_LIST)
end

-- 返回获得领主技能列表
function LordService:reLordSkillList(msg)
	MyLog("返回获得领主技能列表", msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end
	local data = Protobuf.decode("game.LordSkillListResult", msg.data)
	LordModel:getInstance():getLordSkillListSuccess(data)
end

-- 使用领主技能
function LordService:sentUseLordSkill(skillid)
	MyLog("使用领主技能")
	local package = {
		skillid = skillid,
	}
	NetWorkMgr:getInstance():sendData("game.UseLordSkillPacket", package, P_CMD_C_USE_LORD_SKILL)
end

-- 返回使用领主技能
function LordService:reUseLordSkill(msg)
	MyLog("返回使用领主技能", msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end
	local data = Protobuf.decode("game.UseLordSkillResult", msg.data)
	LordModel:getInstance():useLordSkillSuccess(data)
end

-- 领主技能持续时间结束
function LordService:reLordSkillEnd(msg)
	MyLog("领主技能持续时间结束", msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end
	local data = Protobuf.decode("game.TimeoutLordSkillResult", msg.data)
	LordModel:getInstance():lordSkillEnd(data)
end