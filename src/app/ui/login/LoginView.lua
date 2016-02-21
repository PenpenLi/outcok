--
--[[
	jinyan.zhang
	登录界面
--]]

LoginView = class("LoginView",UIBaseView)

--构造
--uiType UI类型
--data 数据
--返回值(无)
function LoginView:ctor(uiType,data)
	self.data = data
	self.super.ctor(self,uiType)
	self:adapterSize()
end

--初始化
--返回值(无)
function LoginView:init()
	self.root = Common:loadUIJson(LOGIN_HEAD)
	self:addChild(self.root)

	self.accountEdit = Common:seekNodeByName(self.root,"accountedit")
	self.pwdEdit = Common:seekNodeByName(self.root,"pwdedit")
	self.loginRecordFlgCheckBox = Common:seekNodeByName(self.root,"logincheck")
	self.loginBtn = Common:seekNodeByName(self.root,"loginbtn")
	self.loginBtn:addTouchEventListener(handler(self,LoginView.loginCallback))

	self.accountEdit:setString(Common:getLoginAccount())
	self.pwdEdit:setString(Common:getLoginPwd())
	self.loginRecordFlgCheckBox:setSelected(Common:getLoginRecordFlgState())

	-- self.list = MMUIListview.new(500,800)
	-- self:addChild(self.list)
	-- self.list:setPosition(150,200)
	-- --self.list:closeBgColor()
	-- for i=1,10 do
	-- 	local img = display.newSprite("citybuilding/farmlandFloor.png")
	-- 	self.list:pushBackCustomItem(img)

	-- 	local label = display.newTTFLabel({
	--         text = "" .. i,
	--         font = "Arial",
	--         size = 28,
	--         color = cc.c3b(255, 255, 0), -- 使用纯红色
 --    	})
 --    	label:setPosition(img:getBoundingBox().width/2,img:getBoundingBox().height/2)
	--     img:addChild(label)
	-- end
	-- self.list:addTouchEventListener(self.callback,self)

	-- 科技界面
    -- self.speedUpView = AccelerationBase.new(self.uiType, self.pos)
    -- self:addChild(self.speedUpView)
    -- self.speedUpView:upLevelByPos(1)

 --    local v = "outsidebuilding/wildbuild"
 --    display.addSpriteFrames(v .. ".plist", v .. ".png", function()
 --        local worldMap = MapMgr:getInstance():loadWorldMap()
 --        SceneMgr:getInstance().mapLayer:addChild(worldMap)
 --    	OutBuildingData:getInstance():createTestData()
 --    	display.addSpriteFrames("common/common_1" .. ".plist", "common/common_1" .. ".png", function()
 --    		UIMgr:getInstance():openUI(UITYPE.TERRITORY)
 --    		UIMgr:getInstance():closeUI(UITYPE.LOGIN)
 --    	end)
	-- end)
end

function LoginView:callback(sender,eventType,index)
	if eventType == ccui.TouchEventType.ended then
		print("tag=",index)
	end
end

--登录按钮回调
--sender 登录按钮本身
--eventType 事件类型
--返回值(无)
function LoginView:loginCallback(sender,eventType)
	if eventType == ccui.TouchEventType.ended then
		print("点击登录...")
		local account = self.accountEdit:getString()
		local pwd = self.pwdEdit:getString()
		if account == "" then
			Prop:getInstance():showMsg(CommonStr.ACCOUNT_NOT_CAN_EMPTY)
			return
		elseif pwd == "" then
			Prop:getInstance():showMsg(CommonStr.PWD_NOT_EMPYT)
			return
		end

		if self.loginRecordFlgCheckBox:isSelected() == true then
			Common:writeDataToXmlCache("account",account)
			Common:writeDataToXmlCache("pwd",pwd)
			Common:writeBoolDataToXmlCache("loginRecordFlg",true)
		else
			Common:writeDataToXmlCache("account","")
			Common:writeDataToXmlCache("pwd","")
			Common:writeBoolDataToXmlCache("loginRecordFlg",false)
		end
		Common:flushXmlCache()

		MyLog("connect http server....")
		LoginModel:getInstance():setAccount(account)
		LoginModel:getInstance():setPwd(pwd)
		SceneMgr:getInstance():goToCity(account,pwd)
	end
end

--UI加到舞台后会调用这个接口
--返回值(无)
function LoginView:onEnter()
	--MyLog("LoginView onEnter...")
end

--UI离开舞台后会调用这个接口
--返回值(无)
function LoginView:onExit()
	--MyLog("LoginView onExit()")
end

--析构函数(此时已经从内存中释放掉资源了)
--返回值(无)
function LoginView:onDestroy()
	--MyLog("--LoginView:onDestroy")
end


