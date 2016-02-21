
--[[
    hejun
    使用道具加速制造陷井消息处理
--]]

UsePropAcceMakeTrapService = {}

local P_CMD_C_QUICKFINISH_TRAP_BY_ITEMS = 61 --道具加速建造陷阱


--初初化
function UsePropAcceMakeTrapService:initialize()
    NetMsgMgr:getInstance():registerMsg(P_CMD_C_QUICKFINISH_TRAP_BY_ITEMS, UsePropAcceMakeTrapService, UsePropAcceMakeTrapService.acceRes)
end

--发送道具加速制造陷井请求
--number 物品数量
--buildingPos 建筑位置
--返回值(无)
function UsePropAcceMakeTrapService:sendAcceReq(templateId,objId,number,buildingPos)
    local items = {}
    items.templateId = templateId
    items.number = number
    items.objId = objId
    local data = {
        pos = buildingPos,
        items = items
    }
    dump(data)

    NetWorkMgr:getInstance():sendData("game.QuickCreateArmsByItems",data,P_CMD_C_QUICKFINISH_TRAP_BY_ITEMS)
    MyLog("发送使用道具加速制造陷井请求")
    MessageProp:apper()
end

--加速结果
function UsePropAcceMakeTrapService:acceRes(msg)
    MessageProp:dissmis()
    MyLog("使用道具加速制造陷井结果 msg.result=",msg.result)
    if msg.result <= 0 then
        Lan:hintService(msg.result)
        return
    end

    local data = Protobuf.decode("game.QuickCreateArmsByItemsResult", msg.data)
    UsePropAcceMakeTrapModel:getInstance():acceRes(data)
end

UsePropAcceMakeTrapService:initialize()

