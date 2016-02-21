
--[[
	jinyan.zhang
	城墙消息
--]]

WallService = class("WallService")

local instance = nil

local P_CMD_C_WALL_REPAIR = 72 --修复城墙
local P_CMD_C_WALL_OUT_FIRE = 73 --城墙灭火
local P_CMD_C_WALL_HERO_LIST = 74 --获取城墙驻守英雄数据
local P_CMD_C_WALL_ADD_HERO = 75 --城墙驻守英雄
local P_CMD_C_WALL_REMOVE_HERO = 76 --城墙移除驻守英雄
local P_CMD_S_WALL_FIRE = 77        --通知客户端城墙起火 
local P_CMD_C_WALLEFFECT_SYNC = 82 --同步城防值（为0时迁城）

--初始化
--返回值(无)
function WallService:initialize()   
    NetMsgMgr:getInstance():registerMsg(P_CMD_C_WALL_EFFECT_INFO, self, self.recvWallEffectDataRes) 
	NetMsgMgr:getInstance():registerMsg(P_CMD_C_WALL_OUT_FIRE, self, self.recvDelFireRes)
	NetMsgMgr:getInstance():registerMsg(P_CMD_C_WALL_REPAIR, self, self.recvRepairRes)
    NetMsgMgr:getInstance():registerMsg(P_CMD_S_WALL_FIRE, self, self.recvNoticeWallFireRes)
    NetMsgMgr:getInstance():registerMsg(P_CMD_C_WALL_ADD_HERO, self, self.recvAddHeroRes)
    NetMsgMgr:getInstance():registerMsg(P_CMD_C_WALL_REMOVE_HERO, self, self.recvRemoveHeroRes)
    NetMsgMgr:getInstance():registerMsg(P_CMD_C_WALLEFFECT_SYNC, self, self.recvMoveCastleRes)
end

--获取城墙效果数据请求
function WallService:getWallEffectDataReq()
    NetWorkMgr:getInstance():sendData("",nil,P_CMD_C_WALL_EFFECT_INFO)
    MyLog("获取城墙效果数据请求")
end

--获取城墙效果数据结果
function WallService:recvWallEffectDataRes(msg)
    MyLog("收到城墙效果数据结果 msg.result=",msg.result)
    if msg.result <= 0 then
        Lan:hintService(msg.result)
        return
    end

    local data = Protobuf.decode("game.WallEffectPacket", msg.data)
    WallModel:getInstance():getWallEffectDataRes(data)
end

--发送灭火请求
--返回值(无)
function WallService:sendDelFireSeq()
    NetWorkMgr:getInstance():sendData("",nil,P_CMD_C_WALL_OUT_FIRE)
    MyLog("发送城墙灭火请求")
    MessageProp:apper()
end

--收到灭火结果
--msg 数据
--返回值(无)
function WallService:recvDelFireRes(msg)
    MessageProp:dissmis()
    MyLog("收到灭火结果 msg.result=",msg.result)
    if msg.result <= 0 then
        Lan:hintService(msg.result)
        return
    end

    local data = Protobuf.decode("game.WallEffectPacket", msg.data)
    WallModel:getInstance():recvDelFireRes(data)
end

--发送修补请求
--返回值(无)
function WallService:sendRepairSeq()
    NetWorkMgr:getInstance():sendData("",nil,P_CMD_C_WALL_REPAIR)
    MyLog("发送修补城墙请求")
    MessageProp:apper()
end

--收到修补结果
--msg 数据
--返回值(无)
function WallService:recvRepairRes(msg)
    MessageProp:dissmis()
    MyLog("收到修补结果 msg.result=",msg.result)
    if msg.result <= 0 then
        Lan:hintService(msg.result)
        return
    end

    local data = Protobuf.decode("game.WallEffectPacket", msg.data)
    WallModel:getInstance():recvRepairRes(data)
end

--收到城墙起火消息
--msg 数据
--返回值(无)
function WallService:recvNoticeWallFireRes(msg)
    MyLog("收到城墙起火结果 msg.result=",msg.result)
    if msg.result <= 0 then
        Lan:hintService(msg.result)
        return
    end

    local data = Protobuf.decode("game.WallEffectPacket", msg.data)
    WallModel:getInstance():recvNoticeWallFireRes(data)
end

--添加驻守英雄请求
--返回值(无)
function WallService:addHeroReq(objId)
    local id = {}
    id.id_h = objId.id_h
    id.id_l = objId.id_l
    local data ={
        obj = id
    }
    dump(data)

    NetWorkMgr:getInstance():sendData("game.WallHeroControlPacket",data,P_CMD_C_WALL_ADD_HERO)
    MyLog("发送添加驻守英雄请求")
    MessageProp:apper()
end

--收到添加驻守英雄结果
--msg 数据
--返回值(无)
function WallService:recvAddHeroRes(msg)
    MessageProp:dissmis()
    MyLog("收到添加驻守英雄结果 msg.result=",msg.result)
    if msg.result <= 0 then
        Lan:hintService(msg.result)
        return
    end

    local data = Protobuf.decode("game.WallHeroControlPacket", msg.data)
    WallModel:getInstance():recvAddHeroRes(data)
end

--移除驻守英雄请求
--返回值(无)
function WallService:removeHeroReq(objId)
    local id = {}
    id.id_h = objId.id_h
    id.id_l = objId.id_l
    local data ={
        obj = id
    }
    dump(data)

    NetWorkMgr:getInstance():sendData("game.WallHeroControlPacket",data,P_CMD_C_WALL_REMOVE_HERO)
    MyLog("发送移除驻守英雄请求")
    MessageProp:apper()
end

--收到移除驻守英雄结果
--msg 数据
--返回值(无)
function WallService:recvRemoveHeroRes(msg)
    MessageProp:dissmis()
    MyLog("收到移除驻守英雄结果 msg.result=",msg.result)
    if msg.result <= 0 then
        Lan:hintService(msg.result)
        return
    end

    local data = Protobuf.decode("game.WallHeroControlPacket", msg.data)
    WallModel:getInstance():recvRemoveHeroRes(data)
end

--发送迁城请求
--返回值(无)
function WallService:sendMoveCastleReq()
    NetWorkMgr:getInstance():sendData("",nil,P_CMD_C_WALLEFFECT_SYNC)
    MyLog("发送迁城请求")
end

--收到迁城结果
function WallService:recvMoveCastleRes(msg)
    MyLog("收到迁城结果 msg.result=",msg.result)
    if msg.result <= 0 then
        Lan:hintService(msg.result)
        return
    end

    local data = Protobuf.decode("game.WallEffectSyncPacket", msg.data)
    WallModel:getInstance():recvMoveCastleRes(data)
end

--获取单例
--返回值(单例)
function WallService:getInstance()
    if instance == nil then
        instance = WallService.new()
    end
    return instance
end

WallService:getInstance():initialize()
