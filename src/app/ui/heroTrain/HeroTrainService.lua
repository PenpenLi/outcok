--
-- Author: oyhj
-- Date: 2015-12-17
--
HeroTrainService = class("HeroTrainService")

local instance = nil

--训练英雄
local P_CMD_C_TRAINHERO_CREATE = 65
--训练英雄完成
local P_CMD_S_TRAINHERO_CREATE = 66
--取出训练完成的英雄
local P_CMD_C_GET_TRAIN_FINISH_HERO = 67
--金币加速训练英雄
local P_CMD_C_QUICKFINISH_TRAINHERO = 68
--道具加速训练英雄
local P_CMD_C_QUICKFINISH_TRAINHERO_BY_ITEMS = 69
--取消训练英雄
local P_CMD_C_TRAINHERO_CANCEL_CREATE = 70

--获取单例
--返回值(单例)
function HeroTrainService:getInstance()
    if instance == nil then
        instance = HeroTrainService.new()
    end
    return instance
end

--构造
--返回值(无)
function HeroTrainService:ctor()
    self:init()
end

--初始化
--返回值(无)
function HeroTrainService:init()
    -- 进入训练场消息
    NetMsgMgr:getInstance():registerMsg(P_CMD_S_TRAINHERO_ENTER, self, self.receiveIntoTraining)
    -- 训练英雄消息
    NetMsgMgr:getInstance():registerMsg(P_CMD_C_TRAINHERO_CREATE, self, self.reTrainingHero)
    --完成训练英雄
    NetMsgMgr:getInstance():registerMsg(P_CMD_S_TRAINHERO_CREATE, self, self.finishTrainingHero)
    -- 金币加速训练英雄
    NetMsgMgr:getInstance():registerMsg(P_CMD_C_QUICKFINISH_TRAINHERO, self, self.reGoldTrainingHero)
    -- 道具加速训练英雄
    NetMsgMgr:getInstance():registerMsg(P_CMD_C_QUICKFINISH_TRAINHERO_BY_ITEMS, self, self.sendPropTrainingHero)
    --领取英雄
    NetMsgMgr:getInstance():registerMsg(P_CMD_C_GET_TRAIN_FINISH_HERO, self, self.getHeroRes)
    --道具加速消息
    NetMsgMgr:getInstance():registerMsg(P_CMD_C_QUICKFINISH_TRAINHERO_BY_ITEMS, self, self.rePropTrainingHero)
    --取消训练英雄
    NetMsgMgr:getInstance():registerMsg(P_CMD_C_TRAINHERO_CANCEL_CREATE, self, self.cancelTrainHeroRes)
end

--请求进入训练场
--返回值(无)
function HeroTrainService:sendIntoTraining()
    MyLog("请求进入训练场")
    NetWorkMgr:getInstance():sendData("", nil, P_CMD_S_TRAINHERO_ENTER)
end

--返回进入训练场消息
--返回值(无)
function HeroTrainService:receiveIntoTraining(msg)
    MyLog("返回进入训练场消息",msg.result)
    if msg.result <= 0 then
        Lan:hintService(msg.result)
        return
    end
    local data = Protobuf.decode("game.TrainHeroListResult", msg.data)
    HeroTrainModel:getInstance():successIntoTraining(data)
end

--请求训练英雄
--heroid 英雄id
--hour 小时
--markId 英雄所在数组位置
--返回值(无)
function HeroTrainService:sendTrainingHero(heroid,hour,markId,level)
    local info = {}
    info.id = markId
    info.time = hour
    info.level = level
    HeroTrainModel:getInstance():saveLocalTrain(info)

    MyLog("请求训练英雄",heroid,hour,markId)
    local package = {
        obj = heroid,
        hour = hour,
        markId = markId
    }
    NetWorkMgr:getInstance():sendData("game.HeroToTrainPacket", package, P_CMD_C_TRAINHERO_CREATE)
    MessageProp:apper()
end

--收到训练英雄
--msg 数据包
--返回值(无)
function HeroTrainService:reTrainingHero(msg)
    MessageProp:dissmis()
    MyLog("收到训练英雄 result=",msg.result)
    if msg.result <= 0 then
        Lan:hintService(msg.result)
        return
    end

    local data = Protobuf.decode("game.TimeoutPacket", msg.data)
    HeroTrainModel:getInstance():successTrainHero(data)
end

--完成训练英雄
--msg 数据包
--返回值(无)
function HeroTrainService:finishTrainingHero(msg)
    MyLog("完成训练英雄 result=",msg.result)
    if msg.result <= 0 then
        Lan:hintService(msg.result)
        return
    end

    local data = Protobuf.decode("game.HeroTrainFinishResult", msg.data)
    HeroTrainModel:getInstance():finishTrainHero(data)
end

--领取英雄
--返回值(无)
function HeroTrainService:getHeroReq()
    MyLog("请求领取英雄")
    NetWorkMgr:getInstance():sendData("",nil, P_CMD_C_GET_TRAIN_FINISH_HERO)
    MessageProp:apper()
end

--领取英雄结果
function HeroTrainService:getHeroRes(msg)
    MessageProp:dissmis()
    MyLog("领取英雄列表 result=",msg.result)
    if msg.result <= 0 then
        Lan:hintService(msg.result)
        return
    end

    local data = Protobuf.decode("game.GetFinishHeroResult", msg.data)
    FinishHeroTrainModel:getInstance():getHeroRes(data.heros)
end

--请求金币加速训练英雄
--action 操作类型
--heroid 英雄id
--hour 小时
--返回值(无)
function HeroTrainService:sendGoldTrainingHero(action,heroid,hour,castGold,level)
    local info = {}
    info.castGold = castGold
    info.level = level
    info.action = action
    info.time = hour
    HeroTrainModel:getInstance():saveLocalData(info)

    MyLog("请求金币加速训练英雄",heroid,hour,markId)
    local package = {
        type = action,
        obj = heroid,
        hour = hour,
    }
    dump(package)
    NetWorkMgr:getInstance():sendData("game.QuickTrainHeroPacket", package, P_CMD_C_QUICKFINISH_TRAINHERO)
    MessageProp:apper()
end

--收到金币加速训练英雄
--msg 数据包
--返回值(无)
function HeroTrainService:reGoldTrainingHero(msg)
    MessageProp:dissmis()
    MyLog("收到金币加速训练英雄 result=",msg.result)
    if msg.result <= 0 then
        Lan:hintService(msg.result)
        return
    end

    local data = Protobuf.decode("game.QuickTrainHeroResult", msg.data)
    HeroTrainModel:getInstance():reGoldTrainingHero(data)
end

--发送使用道具加速训练
--buildingPos 建筑位置
--castGold 花费金币
--buildingType 建筑类型
--返回值(无)
function HeroTrainService:sendPropTrainHero(templateId,objId,number,heroObj)
    local items = {}
    items.templateId = templateId
    items.number = number
    items.objId = objId
    local data = {
        items = items,
        obj = heroObj
    }
    dump(data)

    NetWorkMgr:getInstance():sendData("game.QuickTrainHweoByItems",data,P_CMD_C_QUICKFINISH_TRAINHERO_BY_ITEMS)
    MessageProp:apper()
end

--收到道具加速训练
--msg 数据
--返回值(无)
function HeroTrainService:rePropTrainingHero(msg)
    MessageProp:dissmis()
    MyLog("收到道具加速训练 msg.result=",msg.result)
    if msg.result <= 0 then
        Lan:hintService(msg.result)
        return
    end

    local data = Protobuf.decode("game.QuickTrainHweoByItemsResult", msg.data)
    HeroTrainModel:getInstance():rePropTrainingHero(data)
end

--取消训练英雄
--heroId 英雄id
--返回值(无)
function HeroTrainService:sendCancelTrainReq(heroId)
    MyLog("发送取消训练英雄请求")
    local data = {
        obj = heroId,
    }
    dump(data)
    NetWorkMgr:getInstance():sendData("game.CancelTrainHeroPacket", data, P_CMD_C_TRAINHERO_CANCEL_CREATE)
    MessageProp:apper()
end

--取消训练英雄结果
--msg 数据
--返回值(无)
function HeroTrainService:cancelTrainHeroRes(msg)
    MessageProp:dissmis()
    MyLog("收到取消训练英雄结果 msg.result=",msg.result)
    if msg.result <= 0 then
        Lan:hintService(msg.result)
        return
    end

    local data = Protobuf.decode("game.CancelTrainHeroResult", msg.data)
    HeroTrainModel:getInstance():cancelTrainHeroRes(data)
end


HeroTrainService:getInstance():init()
