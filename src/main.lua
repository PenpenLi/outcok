
function __G__TRACKBACK__(errorMessage)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(errorMessage) .. "\n")
    print(debug.traceback("", 2))
    print("----------------------------------------")
end

package.path = package.path .. ";src/"
cc.FileUtils:getInstance():setPopupNotify(false)

require("config")
require("cocos.init")
require("framework.init")
require("app.init.InitSearchPath")
require("app.Head")
require("app.init.Init")

--渠道初始化
function sdkEnter()
	mainEnter()
end

--平台判断是否走渠道
function gotoPlatform()
    if Common:getSdkPlatform() == SDK_PLAMFORM_CODE.MAC then
        mainEnter()
    else
        sdkEnter()
    end
end

--选择加载模块
function mainEnter()
	if Common:getSdkPlatform() == SDK_PLAMFORM_CODE.MAC then
		if Common:isOpenAutoUpdate() == true then  
			--todo
			SceneMgr:getInstance():goToWelcomeScene()
		else
			SceneMgr:getInstance():goToWelcomeScene()
		end
	else
		SceneMgr:getInstance():goToWelcomeScene()
		--todo
	end
end

--渠道登录背景
function createPlatformUI()
	gotoPlatform()
end

function main()
	if Common:getSdkPlatform() == SDK_PLAMFORM_CODE.MAC and device.platform == "ios" then
		SDK_PLAMCODE = SDK_PLAMFORM_CODE.MAC
		createPlatformUI()
	else
		createPlatformUI()
	end
end


main()
