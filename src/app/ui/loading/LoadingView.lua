
--[[
	jinyan.zhang
	加载进度条界面
--]]

LoadingView = class("LoadingView",UIBaseView)

--构造
--uiType UI类型
--data 数据
--返回值(无)
function LoadingView:ctor(uiType,data)
	self.data = data
	self.super.ctor(self,uiType,0.2)
	self:adapterSize()
end

--初始化
--返回值(无)
function LoadingView:init() 
	self.root = Common:loadUIJson(LOADIN_HEAD)
	self:addChild(self.root)

	self.processBar = Common:seekNodeByName(self.root,"processbar")
	self.processLab = Common:seekNodeByName(self.root,"processlab")
	self:setPercent(0)

	--加载内容
	self.loadTextLab = Common:seekNodeByName(self.root,"lab_text")
	self:setLoadText(CommonStr.LOADING_CONING)
end

--设置加载内容
function LoadingView:setLoadText(text)
	text = text or ""
	self.loadTextLab:setString(text)
end

--UI加到舞台后，会调用这个接口
--返回值(无)
function LoadingView:onEnter()
	--MyLog("LoadingView onEnter...")
	if self.data.type == LoadingType.LOGIN then
		self:loadLoginRes()
	elseif self.data.type == LoadingType.GOTO_BATTLE then
		self:loadBattleRes()
	elseif self.data.type == LoadingType.ENTER_WORLD_MAP then
		self:loadWorldMapRes()
	elseif self.data.type == LoadingType.ENTER_CITY then
		self:loadCityRes()
	elseif self.data.type == LoadingType.FROM_PVP_ENTER_CITY then
		self:loadCityRes()
	elseif self.data.type == LoadingType.ENTER_COPY then
		--self:loadCopyMapRes()
		self:loadBattleRes()
	elseif self.data.type == LoadingType.FROM_COPY_ENTER_CITY then
		self:loadCityRes()
	elseif self.data.type == LoadingType.FROM_PVP_ENTER_WORLD then
		self:loadWorldMapRes()
	end
end

--UI离开舞台后，会调用这个接口
--返回值(无)
function LoadingView:onExit()
	--MyLog("LoadingView onExit()")
end

--析构函数(此时已经从内存中释放掉资源了)
--返回值(无)
function LoadingView:onDestroy()
	--MyLog("--LoadingView:onDestroy")
end

--设置loading百分比
--per 百分比
--返回值(无)
function LoadingView:setPercent(per)
	self.processBar:setPercent(per)
	per = math.floor(per)
	local str = "进度" .. per .. "%"
	self.processLab:setString(str)
end

--加载登录资源
--返回值(无)
function LoadingView:loadLoginRes()
	self.curCount = 0
	local loginRes = SpriteCache:getInstance():getLoginCache()
	self.imgCount = #loginRes
	self.resCount = self.imgCount + NetMsgMgr:getInstance():getBeforeEnterSendGameMsgCount()  --登录消息
	for k,v in pairs(loginRes) do
		display.addSpriteFrames(v .. ".plist", v .. ".png", function()
			self:loadResProcess()
			if self.curCount == self.imgCount then
				CalLoadingTime:getInstance():calLoginConfigTime()
				local account = LoginModel:getInstance():getAccount()
				local pwd = LoginModel:getInstance():getPwd()
				print("account=",account,"pwd=",pwd)
				Common:loginHttpServer(account,pwd)
        		CalLoadingTime:getInstance():setBeginConnectHttpTime()
			end
		end)
	end
end

--加载战斗资源
--返回值(无)
function LoadingView:loadBattleRes()
	local battleRes = SpriteCache:getInstance():getBattleCache()
	local battleAnimationRes = AnmationCache:getInstance():getBattleCache()
	self.resCount = #battleRes + #battleAnimationRes
	self.curCount = 0

	for k,v in pairs(battleRes) do
		display.addSpriteFrames(v .. ".plist", v .. ".png", function()
			self:loadResProcess()
			if self.curCount == #battleRes then
				for k,v in pairs(battleAnimationRes) do
					AnmationHelp:getInstance():createAnmation(v.animationName,v.begin,v.count,v.time)
					self:loadResProcess()
				end
				CalLoadingTime:getInstance():calBattleConfigTime()
			end
		end)
	end
end

--加载世界地图资源
--返回值(无)
function LoadingView:loadWorldMapRes()
	local battleRes = SpriteCache:getInstance():getWorldMapCache()
	local battleAnimationRes = AnmationCache:getInstance():getWorldMapCache()
	self.resCount = #battleRes + #battleAnimationRes
	self.curCount = 0

	for k,v in pairs(battleRes) do
		display.addSpriteFrames(v .. ".plist", v .. ".png", function()
			self:loadResProcess()
			if self.curCount == #battleRes then
				for k,v in pairs(battleAnimationRes) do
					AnmationHelp:getInstance():createAnmation(v.animationName,v.begin,v.count,v.time)
					self:loadResProcess()
				end
				CalLoadingTime:getInstance():calLoadWorldMapConfigTime()
			end
		end)
	end
end

--加载进入主城界面资源
--返回值(无)
function LoadingView:loadCityRes()
	self.curCount = 0
	local loginRes = SpriteCache:getInstance():getLoginCache()
	self.resCount = #loginRes
	for k,v in pairs(loginRes) do
		display.addSpriteFrames(v .. ".plist", v .. ".png", function()
			self:loadResProcess()
			if self.curCount == self.resCount then
				CalLoadingTime:getInstance():calLoadCityMapConfigTime()
			end
		end)
	end

	if self.resCount == 0 then
		self.resCount = 1
		self:loadResProcess()
	end
end

--加载副本地图资源
--返回值(无)
function LoadingView:loadCopyMapRes()
	local battleRes = SpriteCache:getInstance():getCopyMapCache()
	local battleAnimationRes = AnmationCache:getInstance():getCopyMapCache()
	self.resCount = #battleRes + #battleAnimationRes
	self.curCount = 0

	for k,v in pairs(battleRes) do
		display.addSpriteFrames(v .. ".plist", v .. ".png", function()
			self:loadResProcess()
			if self.curCount == #battleRes then
				for k,v in pairs(battleAnimationRes) do
					AnmationHelp:getInstance():createAnmation(v.animationName,v.begin,v.count,v.time)
					self:loadResProcess()
				end
			end
		end)
	end
end


--加载资源进度处理
--返回值(无)
function LoadingView:loadResProcess()
	self.curCount = self.curCount + 1
	local per = (self.curCount/self.resCount)*100
	self:setPercent(per)
	if per == 100 then
		local loadingType = self.data.type
		UIMgr:getInstance():closeUI(self.uiType)
		if loadingType == LoadingType.LOGIN then
			SceneMgr:getInstance():enterCity()
		elseif loadingType == LoadingType.GOTO_BATTLE then
			SceneMgr:getInstance():enterBattle()
		elseif loadingType ==  LoadingType.ENTER_WORLD_MAP then
			SceneMgr:getInstance():enterWorld()
		elseif loadingType == LoadingType.ENTER_CITY then
			SceneMgr:getInstance():enterCity()
		elseif loadingType == LoadingType.FROM_PVP_ENTER_CITY then
			SceneMgr:getInstance():enterCity()
			UICommon:getInstance():openMailDetailsView()
		elseif loadingType == LoadingType.ENTER_COPY then
			SceneMgr:getInstance():enterCopyMap()
		elseif loadingType == LoadingType.FROM_COPY_ENTER_CITY then
			SceneMgr:getInstance():fromCopyEnterCity()
		elseif loadingType == LoadingType.FROM_PVP_ENTER_WORLD then
			SceneMgr:getInstance():fromPvpEnterWorldMap()
		end
	end
end


