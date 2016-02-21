
--[[
    jinyan.zhang
    使用道具加速建造升级
--]]

UsePropAcceBuildingUpLvService = {}

local P_CMD_C_QUICKFINISH_BUILDING_BY_ITEMS = 48 --道具加速建筑建造

UpLvPropActionType =
{
    create = 1,  --加速建造
    remove = 2,  --加速移除
}

--初初化
function UsePropAcceBuildingUpLvService:initialize()
    NetMsgMgr:getInstance():registerMsg(P_CMD_C_QUICKFINISH_BUILDING_BY_ITEMS, UsePropAcceBuildingUpLvService, UsePropAcceBuildingUpLvService.propAccelerationBuildingUpLvRes)
end

--发送使用道具加速建筑升级请求
--buildingPos 建筑位置
--castGold 花费金币
--buildingType 建筑类型
--返回值(无)
function UsePropAcceBuildingUpLvService:sendPropAccelerationBuildingUpLvReq(templateId,objId,number,buildingPos,buildingType,action)
    local info = {}
    info.buildingPos = buildingPos
    info.castGold = 0
    info.buildingType = buildingType
    info.buildingState = CityBuildingModel:getInstance():getBuildingState(buildingPos)
    info.action = action
    BuildingAccelerationModel:getInstance():saveGoldAccelerationLocalData(info)

    local items = {}
    items.templateId = templateId
    items.number = number
    items.objId = objId
    local data = {
        pos = buildingPos,
        items = items
    }
    dump(data)

    NetWorkMgr:getInstance():sendData("game.QuickCreateBuildingByItems",data,P_CMD_C_QUICKFINISH_BUILDING_BY_ITEMS)
    MessageProp:apper()
end

--收到道具加速升级建筑结果
--msg 数据
--返回值(无)
function UsePropAcceBuildingUpLvService:propAccelerationBuildingUpLvRes(msg)
    MessageProp:dissmis()
    MyLog("收到使用道具加速建造结果 msg.result=",msg.result)
    if msg.result <= 0 then
        Lan:hintService(msg.result)
        return
    end

    local data = Protobuf.decode("game.QuickCreateBuildingByItemsResult", msg.data)
    UsePropAcceBuildingUpLvModel:getInstance():propAccelerationBuildingUpLvRes(data)
end

UsePropAcceBuildingUpLvService:initialize()


