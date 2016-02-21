
--[[
    hejun
    使用道具加速治疗消息处理
--]]

UsePropAcceTreatmentService = {}

local P_CMD_C_QUICKFINISH_TREAT_BY_ITEMS = 49  --道具加速治疗伤兵

--初初化
function UsePropAcceTreatmentService:initialize()
    NetMsgMgr:getInstance():registerMsg(P_CMD_C_QUICKFINISH_TREAT_BY_ITEMS, UsePropAcceTreatmentService, UsePropAcceTreatmentService.acceRes)
end

--发送道具加速治疗请求
--number 物品数量
--buildingPos 建筑位置
--返回值(无)
function UsePropAcceTreatmentService:sendAcceReq(templateId,objId,number)
    local items = {}
    items.templateId = templateId
    items.number = number
    items.objId = objId
    local data = {
        items = items
    }
    dump(data)

    NetWorkMgr:getInstance():sendData("game.QuickCreatekWoundedSoldierByItems",data,P_CMD_C_QUICKFINISH_TREAT_BY_ITEMS)
    MyLog("发送使用道具加速制造治疗请求")
    MessageProp:apper()
end

--加速结果
function UsePropAcceTreatmentService:acceRes(msg)
    MessageProp:dissmis()
    MyLog("使用道具加速治疗结果 msg.result=",msg.result)
    if msg.result <= 0 then
        Lan:hintService(msg.result)
        return
    end

    local data = Protobuf.decode("game.QuickCreatekWoundedSoldierByItems", msg.data)
    UsePropAcceTreatmentModel:getInstance():acceRes(data)
end

UsePropAcceTreatmentService:initialize()

