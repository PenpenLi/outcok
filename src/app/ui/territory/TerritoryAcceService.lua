
--[[
	jinyan.zhang
	野外领地加速升级消息
--]]
   
local P_CMD_C_QUICKFINISH_WILDBUILDING = 112 --瞬间完成野外建筑升级（金币）    
local P_CMD_C_QUICKFINISH_WILDBUILDING_BY_ITEMS = 113 --道具加速野外建筑升级 

TerritoryAcceService = class("TerritoryAcceService")

local instance = nil

--获取单例
--返回值(单例)
function TerritoryAcceService:getInstance()
	if instance == nil then
		instance = TerritoryAcceService.new()
	end
	return instance
end

function TerritoryAcceService:init()
	NetMsgMgr:getInstance():registerMsg(P_CMD_C_QUICKFINISH_WILDBUILDING, self, self.useGoldUpLevelRes)
	NetMsgMgr:getInstance():registerMsg(P_CMD_C_QUICKFINISH_WILDBUILDING_BY_ITEMS, self, self.usePropUpLevelRes)
end

--使用金币加速升级请求
function TerritoryAcceService:useGoldUpLevelReq(wildBuildingIds,castGold)
	local info = {}
	info.castGold = castGold
	TerritoryModel:getInstance():saveUseGoldAcceInfo(info)
	local data = {
		wildBuildingId = wildBuildingIds,
		markId = info.markId
	}
	NetWorkMgr:getInstance():sendData("game.QuickUpgradeWildBuilding",data,P_CMD_C_QUICKFINISH_WILDBUILDING)
	MessageProp:apper()
	MyLog("使用金币加速升级野外建筑请求")
end

--使用金币加速升级野外建筑结果
--msg 数据
--返回值(无)
function TerritoryAcceService:useGoldUpLevelRes(msg)
	MessageProp:dissmis()
	MyLog("收到使用金币加速升级野外建筑结果 msg.result=",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end

	local data = Protobuf.decode("game.QuickUpgradeWildBuildingResult", msg.data)
	TerritoryModel:getInstance():useGoldUpLevelRes(data)
end

--使用道具加速升级请求
function TerritoryAcceService:usePropUpLevelReq(wildBuildingIds,templateId,objId,number)
	local info = {}
	info.wildBuildingIds = clone(wildBuildingIds)
	TerritoryModel:getInstance():saveUsePropAcceInfo(info)

	local items = {}
    items.templateId = templateId
    items.number = number
    items.objId = objId

	local data = {
		--wildBuildingId = wildBuildingIds,
		items = items,
		markId = info.markId
	}
	NetWorkMgr:getInstance():sendData("game.QuickUpgradeWildBuildingByItems",data,P_CMD_C_QUICKFINISH_WILDBUILDING_BY_ITEMS)
	MessageProp:apper()
	MyLog("使用道具加速升级野外建筑请求")
end

--使用道具加速升级野外建筑结果
function TerritoryAcceService:usePropUpLevelRes(msg)
	MessageProp:dissmis()
	MyLog("收到使用道具加速升级野外建筑结果 msg.result=",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end

	local data = Protobuf.decode("game.QuickUpgradeWildBuildingByItemsResult", msg.data)
	TerritoryModel:getInstance():usePropUpLevelRes(data)
end

TerritoryAcceService:getInstance():init()



