
--[[
	jinyan.zhang
	保存服务器数据
--]]

LoginModel = class("LoginModel")
local instance = nil

--构造
--返回值(无)
function LoginModel:ctor()
	self:init()
end

--初始化
--返回值(空)
function LoginModel:init()
	self.httpData = {}
	self.data = {}
end

--获取单例
--返回值(单例)
function LoginModel:getInstance()
	if instance == nil then
		instance = LoginModel.new()
	end
	return instance
end

--保存http数据
--account 账号
--key 索引
--ip ip地址
--port 端口
--返回值(无)
function LoginModel:saveHttpData(account,key,ip,port)
	self.httpData.account = account
	self.httpData.key = key
	self.httpData.loginIp = ip
	self.httpData.port = port
end

--保存服务器数据
--account 账号
--key 索引
--userId 用户id
--ip ip地址
--port 端口
--返回值(无)
function LoginModel:saveData(account,key,userId,ip,port)
	self.data.account = account
	self.data.key = key
	self.data.userId = userId
	self.data.ip = ip
	self.data.port = port
end

--获取HTTP数据
--返回值(http数据)
function LoginModel:getHttpData()
	return self.httpData
end

--获取服务器数据
--返回值(服务器数据)
function LoginModel:getData()
	return self.data
end

--设置玩家登录账号
function LoginModel:setAccount(account)
	self.account = account
end

--设置玩家登录密码
function LoginModel:setPwd(pwd)
	self.pwd = pwd
end

function LoginModel:getAccount()
	return self.account
end

function LoginModel:getPwd()
	return self.pwd
end


--清理缓存数据
--返回值(无)
function LoginModel:clearCache()
	self:init()
end


