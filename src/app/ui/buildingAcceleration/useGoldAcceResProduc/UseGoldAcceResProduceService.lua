
--[[
    hejun
    资源产量加速消息处理
--]]

UseGoldAcceResProduceService = {}

local P_CMD_C_RES_PRODUC_SPEED = 37 --资源产量加速
local P_CMD_C_RES_PRODUC_SPEDD_END = 38 --资源产量加速结束

--初初化
function UseGoldAcceResProduceService:initialize()
    NetMsgMgr:getInstance():registerMsg(P_CMD_C_RES_PRODUC_SPEED, UseGoldAcceResProduceService, UseGoldAcceResProduceService.resourceAccelerationResult)
    NetMsgMgr:getInstance():registerMsg(P_CMD_C_RES_PRODUC_SPEDD_END, UseGoldAcceResProduceService, UseGoldAcceResProduceService.resourceAccelerationFinishResult)
end

--发送使用金币产量加速请求
--buildingPos 建筑位置
--castGold 花费金币
--返回值(无)
function UseGoldAcceResProduceService:sendProcduAccelerationReqByGold(buildingPos,castGold)
    MyLog("我的位置：",buildingPos)
    local info = {}
    info.buildingPos = buildingPos
    info.castGold = castGold
    UseGoldAcceResProduceModel:getInstance():saveProcduResSpeedLocalData(info)

    local data = {
        pos = buildingPos,
        markId = info.markId,
    }
    NetWorkMgr:getInstance():sendData("game.QuickResouseWithGoldPacket",data,P_CMD_C_RES_PRODUC_SPEED)
    MyLog("发送产量加速请求通过使用金币")
    MessageProp:apper()
end

--产量加速结果
--msg 数据
--返回值(无)
function UseGoldAcceResProduceService:resourceAccelerationResult(msg)
    MessageProp:dissmis()
    MyLog("收到产量加速结果 msg.result=",msg.result)
    if msg.result <= 0 then
        Lan:hintService(msg.result)
        return
    end

    local data = Protobuf.decode("game.TimeoutPacket", msg.data)
    UseGoldAcceResProduceModel:getInstance():resProcduSpeedRes(data)
end

--产量加速完成结果
--msg 数据
--返回值(无)
function UseGoldAcceResProduceService:resourceAccelerationFinishResult(msg)
    MyLog("收到产量加速结果 msg.result=",msg.result)
    if msg.result <= 0 then
        Lan:hintService(msg.result)
        return
    end

    local data = Protobuf.decode("game.QuickResourceFinishedResult", msg.data)
    UseGoldAcceResProduceModel:getInstance():finishResProcduSpeedRes(data)
end

UseGoldAcceResProduceService:initialize()

