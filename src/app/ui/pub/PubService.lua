--
-- Author: Your Name
-- Date: 2015-12-09 16:55:33
--
PubService = class("PubService")

local instance = nil

-- 进入酒馆界面
local P_CMD_C_ENTER_TAVERN = 51
-- 离开界面
local P_CMD_C_LEAVE_TAVERN = 52
-- 刷新英雄列表
local P_CMD_C_REFRESH_TAVERN = 53
-- 招募英雄
local P_CMD_C_HIRE_HERO = 54
-- 服务端主动推送英雄列表
local P_CMD_S_REFRESH_TAVERN = 63

--获取单例
--返回值(单例)
function PubService:getInstance()
	if instance == nil then
		instance = PubService.new()
	end
	return instance
end

--构造
--返回值(无)
function PubService:ctor(data)
	self:init(data)
end

--初始化
--返回值(无)
function PubService:init(data)
	-- 返回进入酒馆界面
	NetMsgMgr:getInstance():registerMsg(P_CMD_C_ENTER_TAVERN, self, self.reEnterPub)
	-- 离开界面消息
	NetMsgMgr:getInstance():registerMsg(P_CMD_C_LEAVE_TAVERN, self, self.reLevelList)
	-- 刷新英雄列表消息
	NetMsgMgr:getInstance():registerMsg(P_CMD_C_REFRESH_TAVERN, self, self.reRefreshList)
	-- 返回招募英雄消息
	NetMsgMgr:getInstance():registerMsg(P_CMD_C_HIRE_HERO, self, self.reHireHero)
	-- 服务端主动推送英雄列表
	NetMsgMgr:getInstance():registerMsg(P_CMD_S_REFRESH_TAVERN, self, self.reRefreshList)
end

-- 进入酒馆发送的消息包
function PubService:sendEnterPub(panel,pos)
	MyLog("进入酒馆发送的消息包",panel,pos)
	local package = {
		panel = panel,
		pos = pos,
	}
	NetWorkMgr:getInstance():sendData("game.EnterTavernPacket", package, P_CMD_C_ENTER_TAVERN)
	MessageProp:apper()
end

-- 返回进入酒馆的消息包
function PubService:reEnterPub(msg)
	MessageProp:dissmis()
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end
	local data = Protobuf.decode("game.EnterTavernResult", msg.data)
	-- 
	print("返回进入酒馆",data.panel, #data.heroes)
	PubModel:getInstance():createData(data.panel, data.heroes, data.refresh_time, 1)
end

-- 酒馆刷新英雄消息包
function PubService:sendRefreshList(panel,pos)
	MyLog("酒馆刷新英雄消息包",panel,pos)
	local package = {
		panel = panel,
		pos = pos,
	}
	NetWorkMgr:getInstance():sendData("game.RefreshTavernPacket", package, P_CMD_C_REFRESH_TAVERN)
	MessageProp:apper()
end

-- 返回酒馆刷新英雄消息包
function PubService:reRefreshList(msg)
	MessageProp:dissmis()
	MyLog("返回酒馆刷新英雄消息包", msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end
	local data = Protobuf.decode("game.RefreshTavernResult", msg.data)
	-- 
	PubModel:getInstance():refreshListSuccess(data.panel, data.heroes)
end

-- 招募英雄消息包
function PubService:sendHireHero(panel,pos)
	MyLog("招募英雄消息包",panel,pos)
	local package = {
		panel = panel,
		pos = pos,
	}
	NetWorkMgr:getInstance():sendData("game.HireHeroPacket", package, P_CMD_C_HIRE_HERO)
	MessageProp:apper()
end

-- 返回招募英雄消息包
function PubService:reHireHero(msg)
	MessageProp:dissmis()
	MyLog("返回招募英雄消息包", msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end
	local data = Protobuf.decode("game.HireHeroResult", msg.data)
	PubModel:getInstance():hireHeroSuccess(data)
end

-- 离开酒馆发送的消息包
function PubService:sentLevelList(panel)
	MyLog("离开酒馆发送的消息包",panel)
	local package = {
		panel = panel,
	}
	NetWorkMgr:getInstance():sendData("game.LeaveTavernPacket", package, P_CMD_C_LEAVE_TAVERN)
	MessageProp:apper()
end

-- 返回离开酒馆消息包
function PubService:reLevelList(msg)
	MessageProp:dissmis()
	-- MyLog("返回离开酒馆消息包", msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end
	MyLog("成功离开酒馆")
end