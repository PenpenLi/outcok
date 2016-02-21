
--[[
    jinyan.zhang
    治疗消息处理
--]]

TreatmentService = {}

local P_CMD_C_TREATMENT_ARMS = 35     --治疗伤兵
local P_CMD_S_TREATMENT_ARMS_FINISH = 36     --伤兵治疗完成
local P_CMD_C_CANCEL_TREATE_ARMS = 50 --取消治疗伤兵

--初初化
function TreatmentService:initialize()
    NetMsgMgr:getInstance():registerMsg(P_CMD_C_TREATMENT_ARMS, TreatmentService, TreatmentService.woundedSoldierRes)
    NetMsgMgr:getInstance():registerMsg(P_CMD_S_TREATMENT_ARMS_FINISH, TreatmentService, TreatmentService.completeTreatmentResult)
    NetMsgMgr:getInstance():registerMsg(P_CMD_C_WOUNDEDSOLIDER_LIST, TreatmentService, TreatmentService.getWoundedSoldierResult)
    NetMsgMgr:getInstance():registerMsg(P_CMD_C_CANCEL_TREATE_ARMS, TreatmentService, TreatmentService.cancelTreatmentResult)
end

--伤兵请求
--arms 伤兵数据
--返回值(无)
function TreatmentService:woundedSoldierSeq(arms,buildingType)
    local info = {}
    info.arms = clone(arms)
    info.buildingType = buildingType
    TreatmentModel:getInstance():saveLocalData(info)

    local woundedSoldierData = {
        arms = arms,
        markId = info.markId,
    }
    dump(woundedSoldierData)

    NetWorkMgr:getInstance():sendData("game.WoundedSoldierPacket",woundedSoldierData,P_CMD_C_TREATMENT_ARMS)
    MessageProp:apper()
end

--伤兵治疗定时器
--msg 数据包
--返回值(无)
function TreatmentService:woundedSoldierRes(msg)
    MessageProp:dissmis()
    MyLog("伤兵治疗定时器 result=",msg.result)
    if msg.result <= 0 then
        Lan:hintService(msg.result)
        return
    end

    local data = Protobuf.decode("game.TimeoutPacket", msg.data)
    TreatmentModel:getInstance():woundedSoldierRes(data)
end

--完成治疗结果
--msg 数据
--返回值(无)
function TreatmentService:completeTreatmentResult(msg)
    MyLog("完成治疗数据 msg.result=",msg.result)
    if msg.result <= 0 then
        Lan:hintService(msg.result)
        return
    end

    local data = Protobuf.decode("game.WoundedSoldierFinishedResult", msg.data)
    TreatmentModel:getInstance():syncCompleteTreatmentData(data)
end

--请求伤兵列表
--arms 伤兵数据
--返回值(无)
function TreatmentService:getWoundedSoldierSeq(arms)
    local woundedSoldierData = {
        arms = {},
    }

    NetWorkMgr:getInstance():sendData("game.WoundedSoldierListResult",woundedSoldierData,P_CMD_C_WOUNDEDSOLIDER_LIST)
    MyLog("发送伤兵列表请求")
end

--获取伤兵列表结果
--msg 数据
--返回值(无)
function TreatmentService:getWoundedSoldierResult(msg)
    MyLog("收到伤兵列表数据 msg.result=",msg.result)
    if msg.result <= 0 then
        Lan:hintService(msg.result)
        return
    end
    local data = Protobuf.decode("game.WoundedSoldierListResult", msg.data)
    HurtArmsData:getInstance():init()
    HurtArmsData:getInstance():createArmsList(data.arms)
end

--请求取消治疗
--返回值(无)
function TreatmentService:cancelTreatmentSeq()
    NetWorkMgr:getInstance():sendData("",nil,P_CMD_C_CANCEL_TREATE_ARMS)
    print("发送取消治疗消息",buildingPos)
    MessageProp:apper()
end

--收到取消治疗结果
--msg 数据
--返回值(无)
function TreatmentService:cancelTreatmentResult(msg)
    MessageProp:dissmis()
    MyLog("收到取消治疗结果 msg.result=",msg.result)
    if msg.result <= 0 then
        Lan:hintService(msg.result)
        return
    end
    local data = Protobuf.decode("game.WoundedSoldierListResult", msg.data)

    TreatmentModel:getInstance():cancelTreatmentResult(data)
end

TreatmentService:initialize()