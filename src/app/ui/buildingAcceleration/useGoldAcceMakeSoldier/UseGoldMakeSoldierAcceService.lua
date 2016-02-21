
--[[
    jinyan.zhang
    使用金币加速造兵
--]]

UseGoldMakeSoldierAcceService = {}

local P_CMD_C_QUICKFINISH_TRAIN = 42 --金币加速训练士兵

--加速造兵action
AccelerationMakeSoldierAction =
{
    commonGold = 0,  --正常加速
    rightNowGold = 1, --立即加速
}

--初初化
function UseGoldMakeSoldierAcceService:initialize()
    NetMsgMgr:getInstance():registerMsg(P_CMD_C_QUICKFINISH_TRAIN, UseGoldMakeSoldierAcceService, UseGoldMakeSoldierAcceService.accelerationMakeSolierRes)
end

--发送加速造兵请求
--castGold 花费金币
--action 操作类型
--buildingPos 建筑位置
--soldierType 士兵类型
--level 等级
--number 数量
--makeSoldierType 造兵类型(动画表现用的)
--name 名字
--返回值(无)
function UseGoldMakeSoldierAcceService:sendAccelerationMakeSoldierReq(castGold,action,buildingPos,soldierType,level,number,soldierAnmationTempleType,name)
    local info = {}
    info.buildingPos = buildingPos
    info.castGold = castGold
    info.soldierType = soldierType
    info.level = level
    info.number = number
    info.soldierAnmationTempleType = soldierAnmationTempleType
    info.name = name
    info.action = action
    UseGoldMakeSoldierAcceModel:getInstance():saveLocalData(info)

    local data = {
        type = action,
        pos = buildingPos,
        templateId = soldierType,
        level = level,
        number = number,
    }
    dump(data)
    NetWorkMgr:getInstance():sendData("game.QuickCreateArms",data,P_CMD_C_QUICKFINISH_TRAIN)
    MyLog("发送造兵加速请求")
    MessageProp:apper()
end

--收到金币加速结果
--msg 数据
--返回值(无)
function UseGoldMakeSoldierAcceService:accelerationMakeSolierRes(msg)
    MessageProp:dissmis()
    MyLog("收到加速造兵结果 msg.result=",msg.result)
    if msg.result <= 0 then
        Lan:hintService(msg.result)
        return
    end

    local data = Protobuf.decode("game.QuickCreateArmsResult", msg.data)
    UseGoldMakeSoldierAcceModel:getInstance():accelerationMakeSoldierRes(data)
end

UseGoldMakeSoldierAcceService:initialize()

