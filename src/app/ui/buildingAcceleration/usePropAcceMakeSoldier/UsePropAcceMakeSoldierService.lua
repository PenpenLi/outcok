
--[[
    hejun
    使用道具加速造兵消息处理
--]]

UsePropAcceMakeSoldierService = {}

local P_CMD_C_QUICKFINISH_TRAIN_BY_ITEMS = 47  --道具加速训练士兵

--初初化
function UsePropAcceMakeSoldierService:initialize()
    NetMsgMgr:getInstance():registerMsg(P_CMD_C_QUICKFINISH_TRAIN_BY_ITEMS, UsePropAcceMakeSoldierService, UsePropAcceMakeSoldierService.acceRes)
end

--发送道具加速造兵请求
--number 物品数量
--buildingPos 建筑位置
--返回值(无)
function UsePropAcceMakeSoldierService:sendPropAccelerationMakeSoldierReq(templateId,objId,number,buildingPos)
    local items = {}
    items.templateId = templateId
    items.number = number
    items.objId = objId
    local data = {
        pos = buildingPos,
        items = items
    }
    dump(data)

    NetWorkMgr:getInstance():sendData("game.QuickCreateArmsByItems",data,P_CMD_C_QUICKFINISH_TRAIN_BY_ITEMS)
    MyLog("发送使用道具加速造兵请求")
    MessageProp:apper()
end

--加速结果
function UsePropAcceMakeSoldierService:acceRes(msg)
    MessageProp:dissmis()
    MyLog("使用道具加速造兵结果 msg.result=",msg.result)
    if msg.result <= 0 then
        Lan:hintService(msg.result)
        return
    end

    local data = Protobuf.decode("game.QuickCreateArmsByItemsResult", msg.data)
    UsePropAcceMakeSoldierModel:getInstance():acceRes(data)
end

UsePropAcceMakeSoldierService:initialize()

