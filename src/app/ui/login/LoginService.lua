
--[[
	jinyan.zhang
	登录消息处理
--]]

LoginService = {}

--初初化
function LoginService:initialize()
	NetMsgMgr:getInstance():registerMsg(MESSAGE_TYPE.P_CMD_CTL_LOGIN, LoginService, LoginService.loginResHandle)
	NetMsgMgr:getInstance():registerMsg(MESSAGE_TYPE.P_CMD_C_LOGIN, LoginService, LoginService.loginAgentGameResHandle)
	NetMsgMgr:getInstance():registerMsg(MESSAGE_TYPE.P_CMD_C_LOGOUT, LoginService, LoginService.loginOutResHandle)
end

--发送登录请求
--account 账号
--key 索引
--返回值(无)
function LoginService:sendLoginReq(account,key)
	local LoginRequest = {
		account = account,
		sessionkey = key,	
	}
	MyLog("account=",account,"key=",key)
	NetWorkMgr:getInstance():sendData("login.LoginRequest",LoginRequest,MESSAGE_TYPE.P_CMD_CTL_LOGIN)
	MyLog("send Login Req")
		NetWorkMgr:getInstance():sendData("login.LoginRequest",LoginRequest,MESSAGE_TYPE.P_CMD_CTL_LOGIN)
end

--登录结果
--msg 数据
--返回值(无)
function LoginService:loginResHandle(msg)
	MyLog("loginResHandle msg.result=",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end
	UICommon:getInstance():loadLoadingProcess()
	NetWorkMgr:getInstance():disconnect()
	NetWorkMgr:getInstance():setHaveConnectLogin(true)

	local data = Protobuf.decode("login.LoginResponse", msg.data)
	MyLog("data loginRes=",data)
	local pos = string.find(data.endpoint,":")
	local ip = string.sub(data.endpoint,1,pos-1)
	local port = string.sub(data.endpoint,pos+1)
	LoginModel:getInstance():saveData(data.account,data.sessionkey,data.userid,ip,port)
	MyLog("connect login sccu data=",data,"data.account=",data.account,"data.endpoint=",data.endpoint,
		"data.sessionkey=",data.sessionkey,"data.userid=",data.userid)
	NetWorkMgr:getInstance():connect(ip, port)
	--Prop:getInstance():showMsg("成功连上了登录服,正在连接逻辑服...")
end

--发送登录游戏服请求
--account 账号
--key 索引
--version 版本号
--cmd 消息类型
--userid 用户id
--返回值(无)
function LoginService:sendLoginGameReq(account,key,version,cmd,userid)
	local LoginGameRequest = {
		account = account,
		sessionkey = key,	
		version = version,
		userid = userid,
	}
	NetWorkMgr:getInstance():sendData("agent.LoginRequest",LoginGameRequest,cmd)
	MyLog("sendEnterGameReq...")
end

--登录游戏服结果
--msg 数据包
--返回值(无)
function LoginService:loginAgentGameResHandle(msg)
	MyLog("loginAgentGame result=",msg.result)
	if msg.result <= 0 then
		Lan:hintService(msg.result)
		return
	end
	MyLog("enterGame sccu")

	local data = Protobuf.decode("game.PlayerPacket", msg.data)
	PlayerData:getInstance():setData(data)
end

--登出结果
--msg 数据包
--返回值(无)
function LoginService:loginOutResHandle(msg)
	MyLog("loginOutResHandle result=",msg.result)
	UIMgr:getInstance():openUI(UITYPE.PROP_BOX, {type=PROP_BOX_TYPE.DIS_CONNECT,text=CommonStr.BE_LOGIN,
				callback=function()
		CacheDataMgr:getInstance():clearCache()
		SceneMgr:getInstance():goToLoginScene()
	end})	
end

LoginService:initialize()

