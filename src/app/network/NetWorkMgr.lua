
--[[
	jinyan.zhang
	网络管理器
--]]

NetWorkMgr = class("NetWorkMgr")
local instance = nil

--构造
--返回值(无)
function NetWorkMgr:ctor()
	self:init()
end

--初始化
--返回值(空)
function NetWorkMgr:init()
	self.isHaveConnectLogin = false
end

--设置是否连接过登录服
--connect 连接标记(true:连接过,false：未连接)
--返回值(无)
function NetWorkMgr:setHaveConnectLogin(connect)
	self.isHaveConnectLogin = connect
end

--连接服务器
--ip ip地址
--port 端口
--返回值(无)
function NetWorkMgr:connect(ip,port)
	NetWork:getIntance():connect(ip,port)
end

--再次连接服务器
--返回值(无)
function NetWorkMgr:againConnect()
	NetWork:getIntance():connect()
end

--主动与服务器断开连接
--返回值(无)
function NetWorkMgr:disconnect()
	NetWork:getIntance():disconnect()
end

--连接服务器失败
--arg 失败原因
--返回值(无)
function NetWorkMgr:connectFail(arg)
	if arg == CONNECT_FAIL.CONNECT_SERVER_FAIL then    --主动连接失败
		MyLog("connectFail lua")
	elseif arg == CONNECT_FAIL.CONNECT_DISCONNECT then  --与服务器断开连接了
		MyLog("disconnect server...")
	elseif arg == CONNECT_FAIL.CONNECT_DATA_ERROR then   --收到的数据包有错
		MyLog("recv err Packe")
	end
end

--连接服务器成功
--返回值(无)
function NetWorkMgr:connectSccu()
	MyLog("connect Sccu lua")
	if not instance.isHaveConnectLogin then
		local httpData = LoginModel:getInstance():getHttpData()
		LoginService:sendLoginReq(httpData.account,httpData.key)
	else
		local loginData = LoginModel:getInstance():getData()
		LoginService:sendLoginGameReq(loginData.account,loginData.key,CLIEN_VERSION,MESSAGE_TYPE.P_CMD_C_LOGIN,loginData.userId)
	end
end

--发送消息到服务器
--packName 包名
--packData 数据
--cmd 消息类型
--userId 用户id
--返回值(无)
function NetWorkMgr:sendData(packName,packData,cmd,userId)
	local data = nil
	if packData ~= nil then
		data = Protobuf.encode(packName, packData)
	end

	local DataPacket = {
		cmd = cmd,
		data = data,
	}
	local packet,len = Protobuf.encode(msgPacketName, DataPacket)
	Protobuf.decode(msgPacketName,packet)

	NetWork:getIntance():sendData(packet,len)
end

--收到服务器下发的消息
--data 数据
--len  数据长度
--返回值(无)
function NetWorkMgr:recvData(data,len)
	NetMsgMgr:getInstance():recvMsg(data,len)
end

--连接HTTP服务器
--account 账号
--pwd 密码
--返回值(无)
function NetWorkMgr:connectHttpServer(account,pwd)
	local key = "android123" .. 2 .. account .. pwd .. "qmsj2035^@@!@$"
	local result = crypto.md5(key)
	print("key=",key,"加密结果=",result)

	local url = Common:getServerUrl()
	local data = url .. "equipmentId=" .. "android123" .. "&type=2" .. "&username=" .. account .. "&password=" .. pwd .. "&authKey=" .. result
    print("连接地址："..data)
    local request = network.createHTTPRequest(function(event)
        self:connectHttpServerResult(event)
    end, data, "GET")

    request:setTimeout(20)
    request:start()
end

--连接HTTP服务器结果
--event 事件类型
--返回值(无)
function NetWorkMgr:connectHttpServerResult(event)
	local request = event.request
    if event.name ~= "completed" then -- 當為completed表示正常結束此事件
        --MyLog("request:getErrorCode(), request:getErrorMessage() ", request:getErrorCode(), request:getErrorMessage())
        return
    end

    local code = request:getResponseStatusCode()
    if code ~= 200 then -- 成功
        --MyLog("fail code ", code)
        return
    end

    local strResponse = request:getResponseString()
	local data = json.decode(strResponse)
    if data == nil then
    	Prop:getInstance():showMsg("无法连接http服务")
    	return
    end
	
	print("data.code=",data.code)
	if data.code == 1 then
		local pos = string.find(data.loginIp,":")
		local ip = string.sub(data.loginIp,1,pos-1)
		local port = string.sub(data.loginIp,pos+1)
		
		LoginModel:getInstance():saveHttpData(data.accountId,data.sessionKey,ip,port)
    	MyLog("connect http sccu,data.accountId=",data.accountId,"data.sessionKey=",data.sessionKey,"ip=",ip,
    		"port=",port)
    	self:connect(ip,port)
    	--Prop:getInstance():showMsg("成功连上了Http服务器,正在连接登录服....")
    	UICommon:getInstance():loadLoadingProcess()
    	UICommon:getInstance():loadProcessText(CommonStr.CONNECT_LOGIN_SERVER)
    	CalLoadingTime:getInstance():calConnectHttpTime()
    	CalLoadingTime:getInstance():setBeginLoginTime()
	end
end

--获取单例
--返回值(单例)
function NetWorkMgr:getInstance()
	if instance == nil then
		instance = NetWorkMgr.new()
	end
	return instance
end

function NetWorkMgr:clearCache()
	self:init()
end


