
--[[
    hejun
    建筑加速消息处理
--]]

BuildingAccelerationService = {}

local P_CMD_C_QUICKFINISH_BUILDING = 33 --瞬间完成建筑建造

--加速action
AccelerationAction =
{
    RIGHT_NOW_BUILDING = 0, --瞬间建造
    RIGHT_NOW_REMOVE = 1,   --瞬间拆除
    RIGHT_NOW_UP = 2,       --瞬间升级
}

--初初化
function BuildingAccelerationService:initialize()
    NetMsgMgr:getInstance():registerMsg(P_CMD_C_QUICKFINISH_BUILDING, BuildingAccelerationService, BuildingAccelerationService.accelerationGoldResult)
end

--发送金币加速建筑请求
--buildingPos 建筑位置
--castGold 花费金币
--buildingType 建筑类型
--action 操作类型
--返回值(无)
function BuildingAccelerationService:sendAccelerationGoldReq(buildingPos,castGold,buildingType,action)
    local info = {}
    info.buildingPos = buildingPos
    info.castGold = castGold
    info.buildingType = buildingType
    info.buildingState = CityBuildingModel:getInstance():getBuildingState(buildingPos)
    BuildingAccelerationModel:getInstance():saveGoldAccelerationLocalData(info)

    local data = {
        pos = buildingPos,
        templateId = buildingType,
        type = action,
    }
    dump(data)
    NetWorkMgr:getInstance():sendData("game.QuickFinishBuilding",data,P_CMD_C_QUICKFINISH_BUILDING)
    MyLog("发送金币加速请求 data.pos=",data.pos,"gold=",castGold,"buildingType=",buildingType,"action=",action)
    MessageProp:apper()
end

--收到金币加速结果
--msg 数据
--返回值(无)
function BuildingAccelerationService:accelerationGoldResult(msg)
    MessageProp:dissmis()
    MyLog("收到金币加速结果 msg.result=",msg.result)
    if msg.result <= 0 then
        Lan:hintService(msg.result)
        return
    end

    local data = Protobuf.decode("game.QuickFinishBuildingResult", msg.data)
    BuildingAccelerationModel:getInstance():goldAccelerationRes(data)
end


BuildingAccelerationService:initialize()

