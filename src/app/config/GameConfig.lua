
--[[
	jinyan.zhang
	游戏配置
--]]

OpenAutoUpdate  = false  	-- 是否开启自动更新
OpenLimitGuide  = true  	-- 非强制引导
OpenGuide       = true		-- 引导
LogDebug 		= true      -- log开关，打包需关闭

--渠道相关与搜索路径
SDK_PLAMFORM_CODE =
{
	MAC       = 1000,
	APPSTORE  = 123456,
}

--语言
ENUM_LANGUAGE =
{
	Chinese	  = 1,			--中文
	English   = 2, 			--英文
}

--连接的服务器地址
ENUM_URL =
{
	--LOCAL = "http://api.nlnl.net/game/login/clientLogin?equipmentId=02000000000016446714-ef9e-4865-93fe-de91a6720710&type=2&username=moxiaobai&password=622124&authKey=db71384415c3532ff0b333d4e9bc2728",   --内网

	 LOCAL = "http://cok.5y.com.cn/game/login/clientLogin?",   --内网（服务器）
		-- LOCAL = "http://cok.5y.com.cn/dev/login/clientLogin?",   --内网（成杰）
	-- LOCAL = "http://cok.5y.com.cn/Loc/login/clientLogin?",   --内网（启秀）
	   -- LOCAL = "http://cok.5y.com.cn/igg/login/clientLogin?",   --外网
}

LANGUAGE_TYPE   = ENUM_LANGUAGE.Chinese  --语言

SERVER_URL 		= ENUM_URL.LOCAL 		 --服务器地址

SDK_PLAMCODE    = SDK_PLAMFORM_CODE.MAC  --SDK平台类型

CLIEN_VERSION   = 1 					 --客户端当前版本号

SIGNAL = true   --是否是单机版(true:是,false:否)






