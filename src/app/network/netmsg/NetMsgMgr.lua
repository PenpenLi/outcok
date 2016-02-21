--[[
	jinyan.zhang
	网络消息管理器
--]]

NetMsgMgr = class("NetMsgMgr")
local instance = nil

--构造
--返回值(无)
function NetMsgMgr:ctor()
	self:init()
end

--初始化
--返回值(无)
function NetMsgMgr:init()
	self.networkEventHandlerTable = {}
	self.networkEventObjTable = {}
	self:createMsgList()
end

--注册消息
--messageType 消息类型
--obj 消息回调接口所在的类名
--handler 消息回调接口
--返回值(无)
function NetMsgMgr:registerMsg(messageType, obj, handler)
	--print("messageType=",messageType,"obj=",obj,"handler=",handler)
	self.networkEventHandlerTable[messageType] = handler
	self.networkEventObjTable[messageType] = obj
end

--创建消息列表
function NetMsgMgr:createMsgList()
	self.msgList = {}
	--登录服
	self:createMsg(MESSAGE_TYPE.P_CMD_CTL_LOGIN,Lan:lanText(148, "正在连接登录服务器"))
	--登录逻辑服
	self:createMsg(MESSAGE_TYPE.P_CMD_C_LOGIN,Lan:lanText(147, "正在连接逻辑服务器"))
	--物品列表
	self:createMsg(P_CMD_C_ITEMS_LIST,Lan:lanText(149, "正在获取物品列表"),self.getItmeList)
	--伤兵列表
	self:createMsg(P_CMD_C_WOUNDEDSOLIDER_LIST,Lan:lanText(150, "正在获取伤兵列表"),self.getHurtList)
	--城墙效果
	self:createMsg(P_CMD_C_WALL_EFFECT_INFO,Lan:lanText(151, "正在获取城墙防御值"),self.getWallEffect)
	--英雄训练列表
	self:createMsg(P_CMD_S_TRAINHERO_ENTER,Lan:lanText(152, "正在获取英雄训练列表"),self.getHeroTrainList)
	--增益列表
	self:createMsg(P_CMD_C_CASTLE_EFFECT_LIST,Lan:lanText(153, "正在获取增益列表"),self.getGainList)
	--天赋列表
	self:createMsg(P_CMD_C_ENTER_TALENT,Lan:lanText(154, "正在获取天赋列表"),self.getTalentList)
	--领主技能列表
	self:createMsg(P_CMD_C_LORD_SKILL_LIST,Lan:lanText(155, "正在获取领主技能列表"),self.getLordSkillList)
	--野外建筑列表
	self:createMsg(P_CMD_C_PLAYER_WILDBUILDING_LIST,Lan:lanText(216, "野外建筑列表"),self.getOutBuildingList)
	--野外守军列表
	--self:createMsg(P_CMD_C_PLAYER_GARRISON_LIST,Lan:lanText(225, "野外守军列表"),self.getOutDeferArms)
end 

--创建消息
--msgId 消息id
--callback 收到消息后的回调处理
--text 收到消息后显示的文本内容
--params 参数
function NetMsgMgr:createMsg(msgId,text,callback,params)
	local info = {}
	info.msgId = msgId
	info.text = text
	info.target = self
	info.callback = callback
	info.params = params
	table.insert(self.msgList,info)
end

--获取物品列表
function NetMsgMgr:getItmeList(params)
	BagService:getInstance():sendGetItemList()
end

--获取伤兵列表
function NetMsgMgr:getHurtList(params)
	TreatmentService:getWoundedSoldierSeq()
end

--获取城防值
function NetMsgMgr:getWallEffect(params)
	WallService:getInstance():getWallEffectDataReq()
end

--获取英雄训练列表
function NetMsgMgr:getHeroTrainList(params)
	HeroTrainService:getInstance():sendIntoTraining()
end

--获取增益列表
function NetMsgMgr:getGainList(params)
	GainService:getInstance():sendGetGainList()
end

--获取天赋列表
function NetMsgMgr:getTalentList(params)
	LordService:getInstance():sentEnterTalent()
end

--获取领主技能列表
function NetMsgMgr:getLordSkillList(params)
	LordService:getInstance():sentLordSkillList()
end

--获取科技列表
function NetMsgMgr:getTechList(params)
	TechnologyService:getInstance():sentEnterTech(params)
end

--获取野外建筑列表
function NetMsgMgr:getOutBuildingList(params)
	TerritoryService:getInstance():getOutBuildingList()
end

--获取城外守军列表
function NetMsgMgr:getOutDeferArms()
	TerritoryService:getInstance():getDeferArmsReq()
end

--接收消息
--msg 数据
--len 数据长度
--返回值(无)
function NetMsgMgr:recvMsg(msg,len)
	local data,len = Protobuf.decode(msgPacketName, msg)
	--MyLog("lua recv data=",data,"data.cmd=",data.cmd,"data.userid=",data.userid,"data.result=",data.result,"data.len=",len)
	local messageType = data.cmd
	local func = self.networkEventHandlerTable[messageType]
	local obj = self.networkEventObjTable[messageType]
	if nil == data or nil == func or nil == obj then
		MyLog("data=",data,"func=",func,"obj=",obj,"messageType=",messageType)
		return
	end
	func(obj, data)

	self:sendSomeMsg(messageType)
end

--进入游戏前要发给服务器的消息
function NetMsgMgr:sendSomeMsg(msgId)
	if msgId == MESSAGE_TYPE.P_CMD_CTL_LOGIN then --收到登录服消息
		CalLoadingTime:getInstance():calLoginTime()
	elseif msgId == MESSAGE_TYPE.P_CMD_C_LOGIN then --收到登录逻辑服消息
		--开启定时器
		SpecialTimeMgr:getInstance():openTime()
		--士兵每秒消耗粮食
		ArmsCastFood:getInstance():openCastFoodTime()
	end

	for i=1,#self.msgList do
		local info = self.msgList[i]
		if info.msgId == msgId then
			UICommon:getInstance():loadLoadingProcess()
			local info = self.msgList[i+1]
			if info ~= nil then
				UICommon:getInstance():loadProcessText(info.text)
				if info.callback ~= nil then
					info.callback(info.target,info.params)
				end
			end
			if i == #self.msgList then
				--科技列表
				local bulidInfo = CityBuildingModel:getInstance():getBuildInfoByType(BuildType.COLLEGE)
				if bulidInfo ~= nil then
				   	self:getTechList(bulidInfo.pos)
				end
			end
			break
		end
	end
end

--获取进游戏前发的消息个数
function NetMsgMgr:getBeforeEnterSendGameMsgCount()
	return #self.msgList + 1
end

--获取单例
--返回值(单例)
function NetMsgMgr:getInstance()
	if instance == nil then
		instance = NetMsgMgr.new()
	end
	return instance
end




