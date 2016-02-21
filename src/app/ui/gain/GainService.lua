--
-- Author: oyhj
-- Date: 2015-12-24 20:22:32
--
GainService = class("GainService")

local instance = nil
-- 增益效果结束
local P_CMD_S_CASTLE_EFFECT_FINISH = 85

--获取单例
--返回值(单例)
function GainService:getInstance()
    if instance == nil then
        instance = GainService.new()
    end
    return instance
end

--构造
--返回值(无)
function GainService:ctor(data)
    self:init(data)
end

--初始化
--返回值(无)
function GainService:init(data)
    -- 城堡拥有的增益效果列表
    NetMsgMgr:getInstance():registerMsg(P_CMD_C_CASTLE_EFFECT_LIST, self, self.receiveGainList)
    -- 返回结束消息
    NetMsgMgr:getInstance():registerMsg(P_CMD_S_CASTLE_EFFECT_FINISH, self, self.receiveEndItem)
end

--请求增益列表
--返回值(无)
function GainService:sendGetGainList()
    MyLog("请求增益列表")
    NetWorkMgr:getInstance():sendData("", nil, P_CMD_C_CASTLE_EFFECT_LIST)
end

--返回增益列表消息
--返回值(无)
function GainService:receiveGainList(msg)
    MyLog("返回增益列表",msg.result)
    if msg.result <= 0 then
        Lan:hintService(msg.result)
        return
    end
    local data = Protobuf.decode("game.CastleEffectListPacket", msg.data)
    GainData:getInstance():createGainList(data.effects)
end


function GainService:receiveEndItem(msg)
    MyLog("增益倒计时结束",msg.result)
    if msg.result <= 0 then
        Lan:hintService(msg.result)
        return
    end
    local data = Protobuf.decode("game.CastleEffectFinishPacket", msg.data)
    GainData:getInstance():delInfoByType(data.type)
end
