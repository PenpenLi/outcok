
--[[
    jinyan.zhang
    使用金币加速治疗
--]]

UseGoldAcceTreatmentService = {}

local P_CMD_C_QUICKFINISH_TREAT = 40 --瞬间完成治疗(金币)

--加速治疗action
AcceTreatmentAction =
{
    commonGold = 0,  --正常加速
    rightNowGold = 1, --立即加速
}

--初初化
function UseGoldAcceTreatmentService:initialize()
    NetMsgMgr:getInstance():registerMsg(P_CMD_C_QUICKFINISH_TREAT, UseGoldAcceTreatmentService, UseGoldAcceTreatmentService.goldAcceTreatmentRes)
end

--发送加速治疗请求
--action 治疗类型
--castGold 花费金币
--arms 部队
--返回值(无)
function UseGoldAcceTreatmentService:sendAccelerationTreatmentReq(action,castGold,arms)
    local info = {}
    info.action = action
    info.castGold = castGold
    info.arms = clone(arms)
    info.buildingType = BuildType.firstAidTent
    UseGoldAcceTreatmentModel:getInstance():saveLocalData(info)

    local data = {
        type = action,
        arms = arms,
    }
    dump(data)
    NetWorkMgr:getInstance():sendData("game.QuickWoundedSoldierPacket",data,P_CMD_C_QUICKFINISH_TREAT)
    MyLog("发送治疗加速请求")
    MessageProp:apper()
end

--收到金币加速治疗结果
--msg 数据
--返回值(无)
function UseGoldAcceTreatmentService:goldAcceTreatmentRes(msg)
    MessageProp:dissmis()
    MyLog("收到加速治疗结果 msg.result=",msg.result)
    if msg.result <= 0 then
        Lan:hintService(msg.result)
        return
    end
    UseGoldAcceTreatmentModel:getInstance():recvGoldAcceTrestmentRes(data)
end

UseGoldAcceTreatmentService:initialize()

