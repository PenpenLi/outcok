--
-- Author: Your Name
-- Date: 2015-11-04 22:10:18
--
NetworkHandler_SyncArmsData = {}

local P_CMD_C_BURNING_FOOD = 109 --消耗粮食

--初初化
function NetworkHandler_SyncArmsData:initialize()
	-- 同步士兵数据 P_CMD_S_DEFENSE_REPORT
	NetMsgMgr:getInstance():registerMsg(MESSAGE_TYPE.P_CMD_S_DEFENSE_REPORT, NetworkHandler_SyncArmsData, NetworkHandler_SyncArmsData.synchronousArmsData)
	NetMsgMgr:getInstance():registerMsg(P_CMD_C_BURNING_FOOD, NetworkHandler_SyncArmsData, NetworkHandler_SyncArmsData.recvCastFoodRes)
end

--士兵消耗粮食请求
function NetworkHandler_SyncArmsData:armsCastFoodReq()
	NetWorkMgr:getInstance():sendData("",nil,P_CMD_C_BURNING_FOOD)
	MyLog("发送士兵消耗粮食请求")
end

--收到士兵消耗粮食结果
function NetworkHandler_SyncArmsData:recvCastFoodRes(msg)
	MyLog("收到士兵消耗粮食结果=",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end
	local data = Protobuf.decode("game.ArmsBurningFoodPacket", msg.data)
	ArmsCastFood:getInstance():recvArmsCastFoodRes(data)
end

-- 同步士兵数据
-- msg 数据
function NetworkHandler_SyncArmsData:synchronousArmsData(msg)
	MyLog("同步士兵数据=",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end
	local data = Protobuf.decode("game.DefendReportPacket", msg.data)
	-- 受损兵力
	local arms = data.arms
	--受损英雄
	local heros = data.heros
	--损失粮食数量
	local loseFood = data.loseFood
	--损失木材数量
	local loseWood = data.loseWood
	--损失铁矿数量
	local loseIron = data.loseIron
	--损失秘银数量
	local loseMithril = data.loseMithril
	--被掠夺的未收集资源
	local unRes = data.unRes

	--资源
	PlayerData:getInstance():setPlayerFood(loseFood)
	PlayerData:getInstance():setPlayerWood(loseWood)
	PlayerData:getInstance():setPlayerIron(loseIron)
	PlayerData:getInstance():setPlayerMithril(loseMithril)

	--受损兵力
	for k,v in pairs(arms) do
		ArmsData:getInstance():delInfoOrChangeNumber(v.type,v.level,v.dieNumber)
	end

	--受损英雄
	for k,v in pairs(heros) do
		local heroId = v.heroid
		local id = "" .. heroId.id_h .. heroId.id_l
 		local hp = v.hp
		local hero = PlayerData:getInstance():getHeroByID(id)
		if hero ~= nil then
			hero:setHp(hp)
		end
	end
end

NetworkHandler_SyncArmsData:initialize()