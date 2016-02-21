--
-- Author: oyhc
-- Date: 2015-12-04 20:22:32
--
BagService = class("BagService")

local instance = nil
-- 购买物品
local P_CMD_C_BUY_ITEMS = 44
-- 使用物品
local P_CMD_C_USE_ITEMS = 46

--获取单例
--返回值(单例)
function BagService:getInstance()
	if instance == nil then
		instance = BagService.new()
	end
	return instance
end

--构造
--返回值(无)
function BagService:ctor(data)
	self:init(data)
end

--初始化
--返回值(无)
function BagService:init(data)
	-- 返回物品列表消息
	NetMsgMgr:getInstance():registerMsg(P_CMD_C_ITEMS_LIST, self, self.receiveItemList)
	-- 返回购买消息
	NetMsgMgr:getInstance():registerMsg(P_CMD_C_BUY_ITEMS, self, self.receiveBuyItem)
	-- 返回使用物品消息
	NetMsgMgr:getInstance():registerMsg(P_CMD_C_USE_ITEMS, self, self.receiveUseItem)
end

--请求物品列表
--返回值(无)
function BagService:sendGetItemList()
	MyLog("请求物品列表")
	NetWorkMgr:getInstance():sendData("", nil, P_CMD_C_ITEMS_LIST)
end

--返回物品列表消息
--返回值(无)
function BagService:receiveItemList(msg)
	MyLog("返回物品列表",msg.result)
	local data = Protobuf.decode("game.ItemsListPacket", msg.data)
	--
	ItemData:getInstance():init()
	-- 创建物品列表
	ItemData:getInstance():createItemList(data.items)
	-- ItemData:getInstance():createShopList()
end

--请求购买物品
--返回值(无)
function BagService:sendBuyItem(id,number)
    local data = {
		templateId = id,
		num = number,
	}
	MyLog("请求购买物品")
	NetWorkMgr:getInstance():sendData("game.BuyItemsPacket", data, P_CMD_C_BUY_ITEMS)
	MessageProp:apper()
end

--返回购买消息
--返回值(无)
function BagService:receiveBuyItem(msg)
	MessageProp:dissmis()
	MyLog("返回购买消息",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end
	local data = Protobuf.decode("game.BuyItemsResult", msg.data)
	-- print("aavbb",data.items.templateId)
	local itemTemp = ItemTemplateConfig:getInstance():getItemTemplateByID(data.items.templateId)
	Prop:getInstance():showMsg("恭喜您成功购买"..itemTemp.it_name.."商品"..BagModel:getInstance().buyNum.."个")
	-- 金币
	PlayerData:getInstance():setPlayerMithrilGold(itemTemp.it_price * BagModel:getInstance().buyNum)
	-- 刷新所有资源
	UICommon:getInstance():updatePlayerDataUI()
	-- 购买物品
	BagModel:getInstance():bugItem(data.items)
end

--请求使用物品
--返回值(无)
function BagService:sendUseItem(objId,templateId,number)
	-- print("···",objId,templateId,number)
	-- print("使用物品实例高位id：",objId.id_h)
	-- print("使用物品实例低位id：",objId.id_l)
	local item = {}
	item.objId = objId
	item.templateId = templateId
	item.number = number
    local data = {
		items = item,
	}
	MyLog("请求使用物品")
	NetWorkMgr:getInstance():sendData("game.UseItemsPacket", data, P_CMD_C_USE_ITEMS)
	MessageProp:apper()
end

--返回使用物品消息
--返回值(无)
function BagService:receiveUseItem(msg)
	MessageProp:dissmis()
	MyLog("返回使用消息",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end

	local data = Protobuf.decode("game.UseItemsResult", msg.data)
	-- 使用物品
	BagModel:getInstance():useItem(data.items)
end

BagService:getInstance():init()
