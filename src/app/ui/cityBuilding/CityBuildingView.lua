
--[[
	jinyan.zhang
	城内建筑
--]]

CityBuildingView = class("CityBuildingView",function()
    return display.newLayer()
end)

local scheduler = require("framework.scheduler")  --定时器

local MAX_OFFSET = 50 --拖动建筑物的最大偏移值
local debug = false

local trainBtnPath = "test/trainbtn.png"  --训练按钮资源路径

local buildAnmationTag = 2311      --建造动画Tag
local upBuildingAnmationTag = 2310 --升级建筑动画Tag
local upAndCreateProcessTag = 2222  --升级或建造建筑的进度条tag
local makeSoldirsTag = 1222 		--制造士兵动画tag
local headTrainBtnTag = 2543 	    --头顶的造兵tag
local buildAnmationZordr = 3       --建造动画层级
local upAnmationBuildingZorder = 3  --升级建筑动画层级
local upAndCreateProcessZorder = 4   --升级或者建筑的进度条层级
local makeSoldierZorder = 4         --制造士兵

local upAndCreateProcessBgPath = "test/expbase.png"  --升级或者创建建筑的进度背景路径
local upAndCreateProcessPath = "test/expbar.png"     --升级或者创建建筑的进度条路径
local makeSoldiersProcessBgPath = "test/expbase.png"  --造兵的进度背景路径
local makeSoldiersProcessPath = "test/expbar.png"     --造兵的进度条路径

--构造
--CityMap 城内地图类
--返回值(无)
function CityBuildingView:ctor(CityMap)
	self.cityMap = CityMap
	self.buildingNodeList = {}  --建筑结点列表
	self.processLabList = {}      --进度条lab列表
	self.floorList = {} 		 --地板列表
	self:setNodeEventEnabled(true)
	self:init()
	CityMap:getBgMap():addChild(self)
end

--开关建筑触摸
--able(开启触摸,false:关闭触摸)
function CityBuildingView:setBuilgingTouchAble(able)
	for k,v in pairs(self.floorList) do
		local checkRectLayer = v:getChildByTag(v:getTag())
		if checkRectLayer ~= nil then
			checkRectLayer:setTouchEnabled(able)
		end
	end

	for k,v in pairs(self.buildingNodeList) do
		local checkRectLayer = v.buildingImg:getChildByTag(v.buildingImg:getTag())
		if checkRectLayer ~= nil then
			checkRectLayer:setTouchEnabled(able)
		end
	end
end

--建筑加到舞台后会调用这个接口
--返回值(无)
function CityBuildingView:onEnter()
	--MyLog("CityBuildingView:onEnter()")
	self:updateWallPic()
	self:openTime()
	self:showArms()
end

--建筑离开舞台后会调用这个接口
--返回值(无)
function CityBuildingView:onExit()
	--MyLog("CityBuildingView:onExit()")
	self:stopTime()
	TimeMgr:getInstance():removeInfo(TimeType.TREATMENT,1)
	TimeMgr:getInstance():removeInfo(TimeType.TRAIN_HERO,1)
	TimeMgr:getInstance():removeInfo(TimeType.TRAP,1)
	TimeMgr:getInstance():removeInfo(TimeType.COMMON,1)
end

--建筑释放内存后会调用个接口
--返回值(无)
function CityBuildingView:onDestroy()
	--MyLog("CityBuildingView:onDestroy")
end

--更新治疗时间
--返回值(无)
function CityBuildingView:updateTreatmentTime()
	local buildingList = self:getBuildingInfoListByType(BuildType.firstAidTent)
	self.treatmentTime:updateUI(buildingList)
end

--完成治疗时间
--返回值(无)
function CityBuildingView:finishTreatmentTime()
	self.treatmentTime:delTime()
end

--更新英雄训练时间
function CityBuildingView:updateHeroTrainTime()
	self.heroTrainTime:updateUI()
end

--更新解锁区域
function CityBuildingView:updateUnLockArea()
	self.unLockArea:updateUI()
end

--初始化建筑
--返回值(无)
function CityBuildingView:init()
	self.trapTime = TrapTime.new(self)
	local buildingPosList = BuildPosConfig:getInstance():getConfigInfo()
	for k,v in pairs(buildingPosList) do
		self:createBuilding(v)
	end
	self.curShowMenuInfo = {}
	--治疗
	self.treatmentTime = TreatmentTime.new(self)
	self:updateTreatmentTime()
	--训练英雄
	self.heroTrainTime = HeroTrainTime.new(self)
	self:updateHeroTrainTime()
	--解锁区
	self.unLockArea = UnLockArea.new(self)
	--升级科技
	self:upGradeTechnology()

	--大方阵间的坐标
	local beginPos = cc.p(253,924)
	self.armsList = {}
	for i=1,13 do
		self.armsList[i] = {}
		self.armsList[i].count = 0
		self.armsList[i].index = index
	end
	self.armsList[1].pos = cc.p(253,924)
	self.armsList[2].pos = cc.p(410,850)
	self.armsList[3].pos = cc.p(570,780)
	self.armsList[4].pos = cc.p(730,710)
	self.armsList[5].pos = cc.p(120,850)
	self.armsList[6].pos = cc.p(280,780)
	self.armsList[7].pos = cc.p(440,700)
	self.armsList[8].pos = cc.p(610,630)
	self.armsList[9].pos = cc.p(100,720)
	self.armsList[10].pos = cc.p(260,640)
	self.armsList[11].pos = cc.p(450,560)
	self.armsList[12].pos = cc.p(120,560)
	self.armsList[13].pos = cc.p(310,480)

	--方阵内部的坐标
	self.armsBeginPos = {}
	local xDis = 18
	local yDis = 8
	for i=1,AMRS_MAX_ROW do
		self.armsBeginPos[i] = {}
		local x = 0-(i-1)*xDis
		local y = 0-(i-1)*yDis
		self.armsBeginPos[i].pos = cc.p(x,y)
	end

	self.armsPos = {}
	for row=1,AMRS_MAX_ROW do
		for col=1,ARMS_MAX_COL do
			local index = (row-1)*ARMS_MAX_COL+col
			self.armsPos[index] = {}
			local x = self.armsBeginPos[row].pos.x + (col-1)*xDis
			local y = self.armsBeginPos[row].pos.y - (col-1)*yDis
			self.armsPos[index].pos = cc.p(x,y)
		end
	end
end

--创建建筑
--info 建筑信息
--返回值无
function CityBuildingView:createBuilding(info)
	local buildingType = CityBuildingModel:getInstance():getBuildType(info.pos)
	if buildingType == BuildType.OTHER then  --不存在的建筑类型
		return
	end

	if buildingType == BuildType.emptyFloor then  --空地
		local resPath = BuildPosConfig:getFloorResPath(info.posType)
		self:createEmptyFloor(resPath,info.x,info.y,info.pos,info.posType)
	elseif buildingType == BuildType.activityCenter or buildingType == BuildType.bulletinBoard
		or buildingType == BuildType.forest then  --活动中心，公告栏，森林
		--todo
	elseif buildingType == BuildType.flag then --旗子
		self:createSpecialBuilding("test/military_flag_2.png",info.x,info.y,info.pos,buildingType)
	else --建筑
		--有的建筑有底板
		local floor = nil
		local isNeedCreateFloor = BuildPosConfig:getInstance():isNeedCreateFloor(buildingType)
		if isNeedCreateFloor then
			local floorResPath = BuildPosConfig:getInstance():getFloorResPath(info.posType)
			floor = self:createFloor(floorResPath,info.x,info.y,info.pos,info.posType)
		end
		local parent = self
		--有底板的话，建筑就加在底板上，否则直接加到地图上(一般建筑都会有底板，读配置的)
		if floor ~= nil then
			local floorCheckRectLayer = floor:getChildByTag(floor:getTag())
			self:setTouchAble(false,floorCheckRectLayer)
			--parent = floor
		end

		local buildingInfo = CityBuildingModel:getInstance():getBuildInfo(info.pos)
		local builingUpInfo = BuildingUpLvConfig:getInstance():getConfigInfo(buildingType,buildingInfo.level)
		local buildingTypeInfo = BuildingTypeConfig:getInstance():getConfigInfo(buildingType)
		local resPath = BuildingUpLvConfig:getInstance():getBuildingResPath2(buildingType,buildingInfo.level)
		--判断丰收状态
		local isHarvest = CityBuildingModel:getInstance():isBuildingHarvest(info.pos)
		if isHarvest then
		   if BuildType.farmland  == buildingType or buildingType == BuildType.loggingField then
		   		resPath = BuildingUpLvConfig:getInstance():getBuildingResPath2(buildingType,buildingInfo.level,"_002.png")
		   end
		end

		local building = self:createBuild(resPath,parent,buildingTypeInfo.bt_deviationXY[1],buildingTypeInfo.bt_deviationXY[2],info.pos)
		local tab = {}
		tab.buildingImg = building
		table.insert(self.buildingNodeList,tab)

		if isHarvest then
		   self:createHavestImg(info.pos)
		end

		local producSpeedTimeInfo = UseGoldAcceResProduceModel:getInstance():getProcduResSpeedTimeInfo(info.pos)
		if producSpeedTimeInfo ~= nil then
			self:createProducSpeedLab(info.pos)
		end

		local buildingName = BuildingTypeConfig:getInstance():getBuildingNameByType(buildingType)

		local anmationParent = building
		if building:getParent() == floor then
			--anmationParent = floor
		end
		local buildingState = CityBuildingModel:getInstance():getBuildingState(info.pos)
		if buildingState == BuildingState.createBuilding then  --在正建造中
			MyLog("create building... buildingType=",buildingType,"pos=",info.pos,"buildingName=",buildingName)
			self:createBuildingAnmation(tab,buildingType)
			local leftPrcessTime = CityBuildingModel:getInstance():getBuildingLeftProcessTime(info.pos)
			self:createProcess(tab,buildingType,info.pos,leftPrcessTime)
			CityBuildingModel:getInstance():createHammerBuildTime(info.pos)
		elseif buildingState == BuildingState.uplving then  --正在升级中
			MyLog("upLv building... buildingType=",buildingType,"pos=",info.pos,"buildingName=",buildingName)
			self:createUpLvBuildingAnmation(tab,buildingType)
			local leftPrcessTime = CityBuildingModel:getInstance():getBuildingLeftProcessTime(info.pos)
			print("leftPrcessTime=",leftPrcessTime,"buildingPos=",info.pos)
			self:createProcess(tab,buildingType,info.pos,leftPrcessTime)
			CityBuildingModel:getInstance():createHammerBuildTime(info.pos)
		elseif buildingState == BuildingState.removeBuilding then --移除建筑
			self:createUpLvBuildingAnmation(tab,buildingType)
			local leftPrcessTime = CityBuildingModel:getInstance():getBuildingLeftProcessTime(info.pos)
			print("leftPrcessTime=",leftPrcessTime,"buildingPos=",info.pos)
			self:createProcess(tab,buildingType,info.pos,leftPrcessTime)
			CityBuildingModel:getInstance():createHammerBuildTime(info.pos)
		elseif buildingState == BuildingState.makeSoldiers then  --正在产兵
			if buildingType == BuildType.fortress then --堡垒
				self.trapTime:updateUI(info.pos)
				return
			end

			if TimeInfoData:getInstance():isMakeingSoldier(info.pos) then
				local info = TimeInfoData:getInstance():getTimeInfoByBuildingPos(info.pos)
				if info == nil then
					return
				end
				self:createMakeSoilderUI(info.buildingPos,info.start_time,info.interval,info.soldierAnmationTempleType)
			else
				if MakeSoldierModel:getInstance():isHaveReadyArms(info.pos) then
				   self:createHeadTrainFinishBtn(tab)
				    local readyArmsInfo = MakeSoldierModel:getInstance():getReadyArmsInfo(info.pos)
				   	self:createMakeSoldiersAnmation(anmationParent,readyArmsInfo.soldierAnmationTempleType)
		        end
			end
			MyLog("make soldiers... buildingType=",buildingType,"pos=",info.buildingPos,"buildingName=",buildingName)
		end
	end
end

--更新城墙图片
function CityBuildingView:updateWallPic()
	local info = self:getBuildingInfoListByType(BuildType.wall)
	local wallImg = info[1].buildingImg
	wallImg:removeChildByTag(12133)

	local picPath = nil
    local wallState = WallModel:getInstance():getState()
    if wallState == WallState.fire then  --着火
        picPath = "citybuilding/fireBomb.png"
    elseif wallState == WallState.bad then  --破损
        picPath = "citybuilding/broken.png"
    end

    if picPath == nil then
        return
    end

    local wall = display.newSprite(picPath)
    wall:setPosition(0, 0)
    wallImg:addChild(wall,1,12133)
end

--创建堡垒定时器UI
--buildingPos 建筑位置
--返回值(无)
function CityBuildingView:createFortressTimeUI(buildingPos)
	self.trapTime:createTimeUI(buildingPos)
end

--完成堡垒制造陷井
function CityBuildingView:finishFortressMakeTrap(buildingPos)
	self.trapTime:finishMakeTrap(buildingPos)
end

--取消制造陷井
--返回值(无)
function CityBuildingView:cancelMakeTrap()
	self.trapTime:cancelMakeTrap(buildingPos)
end

--领取堡垒制造的陷井
--pos 建筑位置
--soldierType 士兵类型
--num 士兵数量
--lv 士兵等级
function CityBuildingView:getMakeTrapUI(pos,soldierType,num,lv)
	self.trapTime:getMakeTrap()
	--self:getMakeSoldiers(pos,soldierType,num,lv)
end

--创建特殊建筑
--path 资源路径
--x 坐标
--y 坐标
--pos 建筑位置
--buildingType 建筑类型
--返回值(特称建筑)
function CityBuildingView:createSpecialBuilding(path,x,y,pos,buildingType)
	local buildingImg = display.newSprite(path)
	buildingImg:setAnchorPoint(0.5,0.5)
	buildingImg:setPosition(x,y)
	buildingImg:setTag(pos)
	self:addChild(buildingImg)

	local tab = {}
	tab.buildingImg = buildingImg
	table.insert(self.buildingNodeList,tab)

	local checkRect = {x=30,y=20,wide=180,high=100}
	if buildingType == BuildType.flag then
		checkRect = {x=0,y=0,wide=120,high=200}
	end

	local size = cc.size(checkRect.wide,checkRect.high)
	local checkRectLayer = display.newCutomColorLayer(cc.c4b(255,255,0,0),size.width,size.height)
	checkRectLayer:setContentSize(size)
	buildingImg:addChild(checkRectLayer)
	checkRectLayer:setTag(pos)
	checkRectLayer:setPosition(checkRect.x, checkRect.y)
	self:setTouchAble(true,checkRectLayer)
	return buildingImg
end

--创建建筑
--resPath 资源路径
--parent 父结点
--x,y 坐标
--pos 建筑位置
--floorX,floorY 底板X,Y坐标
--返回值(无)
function CityBuildingView:createBuild(resPath,parent,x,y,pos)
	local configInfo = BuildPosConfig:getInstance():getConfigInfoByPos(pos)
	local building = ccui.ImageView:create("")
	building:loadTexture(resPath,ccui.TextureResType.plistType)
	building:setPosition(x+configInfo.x,y+configInfo.y)
	building:setTag(pos)
	self:addChild(building,1)
	self:createTextLab(building,pos)
	building:setTouchEnabled(false)

	local buildingInfo = CityBuildingModel:getInstance():getBuildInfo(pos)
	if buildingInfo == nil then
		buildingInfo = {}
		buildingInfo.level = 1
	end
	local buildingType = CityBuildingModel:getInstance():getBuildType(pos)
	local builingUpInfo = BuildingUpLvConfig:getInstance():getConfigInfo(buildingType,buildingInfo.level)

	local size = building:getContentSize()
	size.width = size.width*0.7
	size.height = size.height*0.7
	local checkRect = {x=building:getContentSize().width/2-size.width/2,y=building:getContentSize().height/2-size.height/2,wide=size.width,high=size.height}

	local size = cc.size(checkRect.wide,checkRect.high)
	local checkRectLayer = display.newCutomColorLayer(cc.c4b(255,255,0,0),size.width,size.height)
	checkRectLayer:setContentSize(size)
	building:addChild(checkRectLayer)
	checkRectLayer:setTag(pos)
	checkRectLayer:setPosition(checkRect.x, checkRect.y)
	self:setTouchAble(true,checkRectLayer)

	local levelLabel = display.newTTFLabel({
	    text = "LV:" .. buildingInfo.level,
	    font = "Arial",
	    size = 20,
	    color = cc.c3b(255, 0, 0), -- 使用纯红色
	    align = cc.TEXT_ALIGNMENT_LEFT,
	})
	levelLabel:setPosition(building:getContentSize().width/2,building:getContentSize().height/2)
	building:addChild(levelLabel,0,1235)

	---[[
	if buildingType == BuildType.castle then
		local label = display.newTTFLabel({
		    text = PlayerData:getInstance().name,
		    font = "Arial",
		    size = 32,
		    color = cc.c3b(255, 0, 0), -- 使用纯红色
		    align = cc.TEXT_ALIGNMENT_LEFT,
		})
		building:addChild(label)
		label:setPosition(100,100)
	end
	--]]

	return building
end

function CityBuildingView:updateLevel(pos)
  --建筑信息
	local buildingInfo = CityBuildingModel:getInstance():getBuildInfo(pos)
	if buildingInfo == nil then
	 	return
	end

	for k,v in pairs(self.buildingNodeList) do
		if v.buildingImg ~= nil and v.buildingImg:getTag() == pos then
	  		local lab = v.buildingImg:getChildByTag(1235)
	      	if lab ~= nil then
	        	lab:setString("LV:".. buildingInfo.level)
	      	end
			return
		end
	end
end

--创建底板
--path 资源路径
--x 坐标
--y 坐标
--pos 建筑位置
--posType 位置类型
--返回值(底板)
function CityBuildingView:createFloor(path,x,y,pos,posType)
	local floor = display.newSprite(path)
	floor:setAnchorPoint(0.5,0.5)
	floor:setPosition(x,y)
	floor:setTag(pos)
	self:addChild(floor)
	self:createTextLab(floor,pos)
	table.insert(self.floorList,floor)

	local checkRect = {x=30,y=20,wide=180,high=100}
	if posType == 2 then
		checkRect = {x=45,y=20,wide=100,high=80}
	end
	local size = cc.size(checkRect.wide,checkRect.high)
	local checkRectLayer = display.newCutomColorLayer(cc.c4b(255,255,0,0),size.width,size.height)
	checkRectLayer:setContentSize(size)
	floor:addChild(checkRectLayer)
	checkRectLayer:setTag(pos)
	checkRectLayer:setPosition(checkRect.x, checkRect.y)
	self:setTouchAble(true,checkRectLayer)

	return floor
end

--创建空地
--path 资源路径
--x 坐标
--y 坐标
--pos 建筑位置
--posType 位置类型
--返回值(无)
function CityBuildingView:createEmptyFloor(path,x,y,pos,posType)
	self:createFloor(path,x,y,pos,posType)
end

--调整坐标用的(测试)
--parent 父结点
--pos 建筑位置
--返回值(无)
function CityBuildingView:createTextLab(parent,pos)
	if not debug then
		return
	end

	local label = display.newTTFLabel({
	    text = "index=" .. pos,
	    font = "Arial",
	    size = 32,
	    color = cc.c3b(255, 0, 0), -- 使用纯红色
	    align = cc.TEXT_ALIGNMENT_LEFT,
	})
	parent:addChild(label)
end

--打开定时器(1秒钟调用一次)
--返回值(无)
function CityBuildingView:openTime()
	if self.handle  ~= nil then
		return
	end
    self:stopTime()
    self.handle = scheduler.scheduleGlobal(handler(self, self.updateTime), 1)
end

--停止定时器
--返回值(无)
function CityBuildingView:stopTime()
	if self.handle ~= nil then
		scheduler.unscheduleGlobal(self.handle)
		self.handle = nil
	end
end

--使能/禁止触摸
--able 使能(true:使能,false:禁止)
--node 目标结点
--返回值(无)
function CityBuildingView:setTouchAble(able,node)
	node:setTouchEnabled(able)
	if able == true then
		node:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)
		node:setTouchSwallowEnabled(false)
	    node:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
	        if event.name == "began" then
	        	self:touchBegin(event,node)
	        	self.isCanClick = true
	        elseif event.name == "moved" then
	           self:touchMove(event,node)
	        elseif event.name == "ended" then
	        	if self.isCanClick then
	        		self:touchEnd(event,node)
	        		self.isCanClick = false
	        	end
	        end
	        return true
	    end)
	end
end

--开始触摸
--event 事件
--node 目标结点
--返回值(无)
function CityBuildingView:touchBegin(event,node)
	self.beginPos = cc.p(event.x,event.y)
end

--是否点击到资源田
--返回值(true:点到了,false:未点到)
function CityBuildingView:isClickResAtTouchBegin()
	return self.isClickRes
end

--设置是否点击到资源
--isClickRes(true:点到了,false:未点到)
--返回值(无)
function CityBuildingView:setIsClickRes(isClickRes)
	self.isClickRes = isClickRes
end

--触摸拖动
--event 事件
--node 目标结点
--返回值(无)
function CityBuildingView:touchMove(event,node)
end

--拖动收集资源
--clickPos 点击坐标
--返回值(无)
function CityBuildingView:drapCollectRes(clickPos)
	for k,v in pairs(self.buildingNodeList) do
		if v.harvestImg ~= nil and self:isClickResAtTouchBegin() then
			local buildingPos = v.harvestImg:getTag()
			local worldPos = Common:converToWorldPos(v.harvestImg)
			local size = v.harvestImgSize
			--print("worldPos=",worldPos.x,"y=",worldPos.y,"wide=",size.width,"high=",size.height)
			worldPos.x = worldPos.x - v.harvestImg:getAnchorPoint().x*size.width
		    worldPos.y = worldPos.y - v.harvestImg:getAnchorPoint().y*size.height
		    if clickPos.x >= worldPos.x and clickPos.x <= worldPos.x + size.width and
		        clickPos.y >= worldPos.y and clickPos.y <= worldPos.y + size.height then
		        if v.clickResTime == nil or Common:getOSTime() - v.clickResTime >= 4 then
		        	CityBuildingService:sendCollectingResourcesReq(buildingPos)
		        	v.clickResTime = Common:getOSTime()
		        end
	    	end
		end
	end
end

--触摸结点
--event 事件
--node 目标结点
--返回值(无)
function CityBuildingView:touchEnd(event,node)
	MyLog("click building..")
    self:clickBuild(node)
end

  --是否拖动了建筑
  --beginPos 开始坐标
  --endPos 结束坐标点
  --返回值(true:拖动了，false:未拖动)
function CityBuildingView:isHaveDrapBuild(beginPos,endPos)
	if math.abs(beginPos.x-endPos.x) > MAX_OFFSET or math.abs(beginPos.y-endPos.y) > MAX_OFFSET then
		return true
	end
	return false
end

--点击建筑物回调
--node 建筑物
--返回值(无)
function CityBuildingView:clickBuild(building)
	if self.clickRes then
		return
	end

    local pos = building:getTag()
	local buildType = CityBuildingModel:getInstance():getBuildType(pos)
	local buildingName = BuildingTypeConfig:getInstance():getBuildingNameByType(buildType)
	MyLog("click build... pos=",pos,"buildType=",buildType,"buildingName=",buildingName,"pos=",pos)
	if buildType == BuildType.OTHER then
		return
	end

	local cityMap = MapMgr:getInstance():getCity()
	if cityMap ~= nil and cityMap:isDrapMap() then
		return
	end

	local posType = BuildPosConfig:getInstance():getConfigInfoByPos(pos).posType

	if buildType == BuildType.activityCenter then  --活动中心
		--todo
	elseif buildType == BuildType.bulletinBoard then  --公告栏
		--todo
	elseif buildType == BuildType.forest then  --森林
		--todo
	elseif buildType == BuildType.flag then --旗子
		UIMgr:getInstance():openUI(UITYPE.GATHER, {building=building})
		--todo
	elseif buildType == BuildType.COLLEGE then --科技学院
		UIMgr:getInstance():openUI(UITYPE.COLLEGE, {building=building})

	elseif buildType == BuildType.emptyFloor then  --空地
		if posType == BuildingPosType.CITY then  --城内建筑空地
			--todo
            if InWallBuildingListCommand:getEmbtyFloorCount()==0 then
                Prop:getInstance():showMsg(CommonStr.NO_EMPTYFLOOR_CREATE_BUILDING,2)
                return
            end
		   UIMgr:getInstance():openUI(UITYPE.CITY_BUILD_LIST,{building=building,
                                                    type=buildType,
                                                    pos=pos,
                                                    floor=nil})
		elseif posType == BuildingPosType.OUT then  --城外建筑空地
			if CityBuildingModel:getInstance():getOutWallLeftEmptyCount()==0 then
				Prop:getInstance():showMsg(CommonStr.NO_EMPTYFLOOR_CREATE_BUILDING,2)
                return
			end
			UIMgr:getInstance():openUI(UITYPE.OUT_WALL_BUILDINGLIST,{building=building,
                                                    type=buildType,
                                                    pos=pos,
                                                    floor=nil})
		elseif posType == BuildingPosType.CITY_DEF_TOWER then --城内防御塔
			if TowerBuildingListCommand:getEmbtyFloorCount()==0 then
				Prop:getInstance():showMsg(CommonStr.NO_EMPTYFLOOR_CREATE_BUILDING,2)
                return
			end
			UIMgr:getInstance():openUI(UITYPE.TOWER_DEFENSE_LIST,{building=building,
                                                    type=buildType,
                                                    pos=pos,
                                                    floor=nil})
		end
	else  --建筑
		if posType == BuildingPosType.CITY then  --城内建筑
			--兵营
			if CityBuildingModel:getInstance():isBarracks(buildType)
				and MakeSoldierModel:getInstance():isHaveReadyArms(pos) then
				MakeSoldierService:getMakeSoldiersSeq(pos)
				return
			end

			--训练场
			if buildType == BuildType.trainingCamp then
				local heroiList = PlayerData:getInstance():getHeroListByState(HeroState.finish_train)
				if #heroiList > 0 then
					HeroTrainService:getInstance():getHeroReq()
					return
				end
			end

			self:createBuildMenu(building,pos,buildType)
		elseif posType == BuildingPosType.OUT then  --城外建筑
			local isHarvest = CityBuildingModel:getInstance():isBuildingHarvest(pos)
			if isHarvest then
				CityBuildingService:sendCollectingResourcesReq(pos)
			else
				self:createBuildMenu(building,pos,buildType)
			end
		elseif posType == BuildingPosType.CITY_DEF_TOWER then --城内防御塔
			self:createBuildMenu(building,pos,buildType)
		end
	end
end

--创建建筑菜单
--building 建筑结点
--pos 建筑位置
--buildingType 建筑类型
--返回值(无)
function CityBuildingView:createBuildMenu(building,pos,buildingType)
	local buildInfo = CityBuildingModel:getInstance():getBuildInfo(pos)
	if buildInfo == nil then
		MyLog("click building info is empty error")
		--return
	end
    UIMgr:getInstance():openUI(UITYPE.BUILDING_MENU, {building=building})
end

--[[
	建造，升级，移除建筑等相关操作处理
--]]

--创建建造动画
--tab 数据
--buildingType 建筑类型
--返回值(无)
function CityBuildingView:createBuildingAnmation(tab,buildingType)
	self:delBuildAnmation(tab)

	--[[
	local buildingResInfo = CityBuildingModel:getInstance():getCityBuildingViewResInfo(buildingType)
	local spine = Common:createSpienAnmation(buildingResInfo.buildAnmation .. ".json",buildingResInfo.buildAnmation .. ".atlas" ,buildingResInfo.buildScale)
	spine:setPosition(buildingResInfo.upX,buildingResInfo.upY)
	parent:addChild(spine,buildAnmationZordr,buildAnmationTag)
	Common:playSpineAnmation(spine,"eff_10400", true)
	--]]
end

--删除建造建筑动画
--tab 数据
--返回值(无)
function CityBuildingView:delBuildAnmation(tab)
	if tab.buildingAnmation ~= nil then
		tab.buildingAnmation:removeFromParent()
		tab.buildingAnmation = nil
	end
end

--创建升级建筑动画
--tab 数据
--buildingType 建筑类型
--返回值(无)
function CityBuildingView:createUpLvBuildingAnmation(tab,buildingType)
	self:delUpLvBuildingAnmation(tab)

	--[[
	local buildingResInfo = CityBuildingModel:getInstance():getCityBuildingViewResInfo(buildingType)
	local spine = Common:createSpienAnmation(buildingResInfo.upAnmation .. ".json",buildingResInfo.upAnmation .. ".atlas" ,buildingResInfo.upScale)
	spine:setPosition(buildingResInfo.buildX,buildingResInfo.buildY)
	parent:addChild(spine,upAnmationBuildingZorder,upBuildingAnmationTag)
	Common:playSpineAnmation(spine,"eff_3004_explosion", true)
	--]]
end

--删除升级建筑动画
--tab 数据
--返回值(无)
function CityBuildingView:delUpLvBuildingAnmation(tab)
	if tab.upbuildingAnmation ~= nil then
		tab.upbuildingAnmation:removeFromParent()
		tab.upbuildingAnmation = nil
	end
end

--删除建筑上的动画
--building 建筑
--anmationTag tag
--返回值(无)
function CityBuildingView:delBuildingAnmation(building,anmationTag)
	local pos = building:getTag()
	local buildingType = CityBuildingModel:getInstance():getBuildType(pos)
	building:removeChildByTag(anmationTag)
	local isNeedCreateFloor = BuildPosConfig:getInstance():isNeedCreateFloor(buildingType)
	-- if isNeedCreateFloor then
	-- 	building:getParent():removeChildByTag(anmationTag)
	-- else
	-- 	building:removeChildByTag(anmationTag)
	-- end
end

--创建进度条
--tab 数据
--buildingType 建筑类型
--buildingPos 建筑位置
--time 进度时间
--isMakeSoldier 是否在造兵(true:是,false:否)
--返回值(进度条)
function CityBuildingView:createProcess(tab,buildingType,buildingPos,time,isMakeSoldier)
	self:delProcess(tab,buildingPos)

	local buildingInfo = CityBuildingModel:getInstance():getBuildInfo(buildingPos)
	if buildingInfo == nil then
		buildingInfo = {}
		buildingInfo.level = 1
	end

	local builingUpInfo = BuildingUpLvConfig:getInstance():getConfigInfo(buildingType,buildingInfo.level)
	local size = tab.buildingImg:getContentSize()
	local x = tab.buildingImg:getPositionX()
	local y = tab.buildingImg:getPositionY()
	local pos = cc.p(x,y+30)

	local picPath = ""
	local processBg = nil
	if not isMakeSoldier then
		processBg = UICommon:getInstance():createProgress(time,self,upAndCreateProcessBgPath,upAndCreateProcessPath,pos,cc.p(37,3),upAndCreateProcessZorder,upAndCreateProcessTag)
		picPath = "test/loading_juhua.png"
	else
		processBg = UICommon:getInstance():createProgress(time,self,makeSoldiersProcessBgPath,makeSoldiersProcessPath,pos,cc.p(37,3),upAndCreateProcessZorder,upAndCreateProcessTag)
		picPath = "test/jumqinbtn.png"
	end
	tab.process = processBg

	local spr = display.newSprite(picPath)
	processBg:addChild(spr)
	spr:setPosition(0, 0)

	local label = display.newTTFLabel({
	    text = "",
	    font = "Arial",
	    size = 24,
	    color = cc.c3b(255, 255, 255), -- 使用纯红色
	    align = cc.TEXT_ALIGNMENT_LEFT,
	})
	label:setPosition(50, 30)
	processBg:addChild(label)
	local info = {}
	info.lab = label
	info.leftTime = time
	info.buildingPos = buildingPos
	info.isMakeSoldier = isMakeSoldier
	table.insert(self.processLabList,info)
end

--创建陷井进度条
--tab 数据
--buildingType 建筑类型
--buildingPos 建筑位置
--time 进度时间
--isMakeSoldier 是否在造兵(true:是,false:否)
--返回值(进度条)
function CityBuildingView:createTrapProcess(tab,buildingType,buildingPos,time,isMakeSoldier)
	self:delProcess(tab,buildingPos)

	local x,y = tab.buildingImg:getPosition()
	local pos = cc.p(x,y)

	local picPath = ""
	local processBg = nil
	if not isMakeSoldier then
		processBg = UICommon:getInstance():createProgress(time,self,upAndCreateProcessBgPath,upAndCreateProcessPath,pos,cc.p(37,3),upAndCreateProcessZorder,upAndCreateProcessTag)
		picPath = "test/loading_juhua.png"
	else
		processBg = UICommon:getInstance():createProgress(time,self,makeSoldiersProcessBgPath,makeSoldiersProcessPath,pos,cc.p(37,3),upAndCreateProcessZorder,upAndCreateProcessTag)
		picPath = "test/jumqinbtn.png"
	end
	tab.process = processBg

	local spr = display.newSprite(picPath)
	processBg:addChild(spr)
	spr:setPosition(0, 0)

	local label = display.newTTFLabel({
	    text = "",
	    font = "Arial",
	    size = 24,
	    color = cc.c3b(255, 255, 255), -- 使用纯红色
	    align = cc.TEXT_ALIGNMENT_LEFT,
	})
	label:setPosition(50, 30)
	processBg:addChild(label)
	local info = {}
	info.lab = label
	info.leftTime = time
	info.buildingPos = buildingPos
	info.isMakeSoldier = isMakeSoldier
	table.insert(self.processLabList,info)
end

--删除进度条
--tab 信息
--buildingPos 建筑位置
--返回值(无)
function CityBuildingView:delProcess(tab,buildingPos)
	if tab.process ~= nil then
		tab.process:removeFromParent()
		tab.process = nil
	end

	for k,v in pairs(self.processLabList) do
		if v.buildingPos == buildingPos then
			self.processLabList[k] = nil
			break
		end
	end
end

--创建造兵动画
--parent 父结点
--soldierAnmationTempleType 士兵动画模板类型
--返回值(无)
function CityBuildingView:createMakeSoldiersAnmation(parent,soldierAnmationTempleType)
	if parent:getChildByTag(makeSoldirsTag) ~= nil then
		parent:removeChildByTag(makeSoldirsTag)
	end

	local hero = self:createSoliderByType(soldierAnmationTempleType,ANMATION_DIR.RIGHT_DOWN,parent,0)
	hero:setPosition(100, 100)
	hero:setTag(makeSoldirsTag)

	local hero2 = self:createSoliderByType(soldierAnmationTempleType,ANMATION_DIR.RIGHT_DOWN,hero,0)
	hero2:setPosition(30, 0)

	local hero3 = self:createSoliderByType(soldierAnmationTempleType,ANMATION_DIR.RIGHT_DOWN,hero,0)
	hero3:setPosition(0, -30)

	local hero4 = self:createSoliderByType(soldierAnmationTempleType,ANMATION_DIR.RIGHT_DOWN,hero3,0)
	hero4:setPosition(30, 0)
end

--删除造兵动画
--building 建筑
--返回值(无)
function CityBuildingView:delMakeSoldiersAnmation(building)
	self:delBuildingAnmation(building,makeSoldirsTag)
end

--创建建筑头顶上的训练完成按钮
--tab 表格
--返回值(无)
function CityBuildingView:createHeadTrainFinishBtn(tab)
	if tab.headTrainImg ~= nil then
		self:delHeadTrainBtn(tab.headTrainImg)
	end

	local headTrainBtn = cc.ui.UIPushButton.new(trainBtnPath)
	self:addChild(headTrainBtn,1000,headTrainBtnTag)
	local x,y = tab.buildingImg:getPosition()
	headTrainBtn:setPosition(x,y+100)
	headTrainBtn:onButtonClicked(function(event)
		MakeSoldierService:getMakeSoldiersSeq(tab.buildingImg:getTag())
	end)
	tab.headTrainImg = headTrainBtn
end

--删除建筑物头顶上的造兵按钮
--headImg 图片
--返回值(无)
function CityBuildingView:delHeadTrainBtn(headImg)
	if headImg == nil then
		return
	end
	headImg:removeFromParent()
end

--更新创建建筑UI
--pos 建筑位置
--buildingType 建筑类型
--state 建筑状态
--beginTime 开始创建建筑的时间
--createNeedTime 创建建筑需要的时间
--返回值(无)
function CityBuildingView:updateCreateBuildingUI(pos,buildingType,state,beginTime,createNeedTime)
	if state == BuidState.UN_FINISH then  --在创建中
		self:createBuildingByPos(pos,buildingType,beginTime,createNeedTime)
	elseif state == BuidState.FINISH then --完成创建
		self:finishBuild(pos,buildingType)
	end
end

--创建建筑
--buildingPos 建筑位置
--buildingType 建筑类型
--beginUpTime 开始创建的时间
--createNeedTime 创建需要的时间
function CityBuildingView:createBuildingByPos(buildingPos,buildingType,beginUpTime,createNeedTime)
	MyLog("buildingPos=",buildingPos,"buildingType=",buildingType,"beginUpTime=",beginUpTime,"createNeedTime=",createNeedTime)
	for k,v in pairs(self.buildingNodeList) do
		if v.buildingImg ~= nil and v.buildingImg:getTag() == buildingPos then
			return
		end
	end

	local floor = nil
	local isNeedCreateFloor = BuildPosConfig:getInstance():isNeedCreateFloor(buildingType)
	if isNeedCreateFloor then
		for k,v in pairs(self.floorList) do
			if v:getTag() == buildingPos then
				floor = v
				break
			end
		end
		if floor == nil then
			local config = BuildPosConfig:getInstance():getConfigInfoByPos(buildingPos)
			local floorResPath = BuildPosConfig:getInstance():getFloorResPath(config.posType)
			local info = BuildPosInfo:getBuildInfo(buildingPos)
			floor = self:createFloor(floorResPath,info.x,info.y,buildingPos,config.posType)
		end
	end

	local parent = self
	--有底板的话，建筑就加在底板上，否则直接加到地图上(一般建筑都会有底板，读配置的)
	if floor ~= nil then
		local floorCheckRectLayer = floor:getChildByTag(floor:getTag())
		self:setTouchAble(false,floorCheckRectLayer)
		--parent = floor
	end

	--创建建筑
	local builingUpInfo = BuildingUpLvConfig:getInstance():getConfigInfo(buildingType,1)
	local buildingTypeInfo = BuildingTypeConfig:getInstance():getConfigInfo(buildingType)
	local resPath = BuildingUpLvConfig:getInstance():getBuildingResPath2(buildingType,1)
	local building = self:createBuild(resPath,parent,buildingTypeInfo.bt_deviationXY[1],buildingTypeInfo.bt_deviationXY[2],buildingPos)
	local info = {}
	info.buildingImg = building
	table.insert(self.buildingNodeList,info)

	if beginUpTime ~= nil then
		--创建建造动画
		self:createBuildingAnmation(info,buildingType)
		--创建进度条
		local leftUpLvTime = CityBuildingModel:getInstance():getLeftUpBuildingTime(beginUpTime,createNeedTime)
		self:createProcess(info,buildingType,buildingPos,leftUpLvTime)
	end
end

--完成建造
--pos 建筑位置
--buildingType 建筑类型
--返回值(无)
function CityBuildingView:finishBuild(pos,buildingType)
	for k,v in pairs(self.buildingNodeList) do
		if v.buildingImg ~= nil and v.buildingImg:getTag() == pos then
			--删除创建建筑动画
			self:delBuildAnmation(v)
			--删了进度条
			self:delProcess(v,pos)
			break
		end
	end
end

--更新拆除建筑UI
--pos 建筑位置
--type 建筑类型
--state 建筑状态
--beginUpTime 开始升级建筑的时间
--upNeedTime 升级需要时间
--返回值(无)
function CityBuildingView:updateRemoveBuildingUI(pos,type,state,beginUpTime,upNeedTime)
	if state == BuidState.UN_FINISH then  --在升级中
		self:createUpBuildingUI(pos,type,beginUpTime,upNeedTime)
	elseif state == BuidState.FINISH then --完成升级
		self:removeBuilding(pos)
	end
end

--删除建筑
--buildingPos 建筑位置
--返回值(无)
function CityBuildingView:removeBuilding(buildingPos)
	self:finishUpBuilding(buildingPos)
	for k,v in pairs(self.buildingNodeList) do
		if v.buildingImg ~= nil and v.buildingImg:getTag() == buildingPos then
			self:delProcess(v,buildingPos)
			v.buildingImg:removeFromParent()
			if v.harvestImg ~= nil then
				v.harvestImg:removeFromParent()
			end
			self:delProducSpeedLab(v)
			self.buildingNodeList[k] = nil
			break
		end
	end
end

--更新升级建筑UI
--pos 建筑位置
--type 建筑类型
--state 建筑状态
--beginUpTime 开始升级建筑的时间
--upNeedTime 升级需要时间
--返回值(无)
function CityBuildingView:updateUpBuildingUI(pos,type,state,beginUpTime,upNeedTime)
	local buildingType = CityBuildingModel:getInstance():getBuildType(pos)
	if state == BuidState.UN_FINISH then  --在升级中
		self:createUpBuildingUI(pos,type,beginUpTime,upNeedTime)
	elseif state == BuidState.FINISH then --完成升级
		self:finishUpBuilding(pos)
	end
end

--创建升级建筑UI
--pos 建筑位置
--buildingType 建筑类型
--beginUpTime 开始升级建筑的时间
--upNeedTime 升级需要时间
--返回值(无)
function CityBuildingView:createUpBuildingUI(pos,buildingType,beginUpTime,upNeedTime)
	local info = {}
	for k,v in pairs(self.buildingNodeList) do
		if v.buildingImg ~= nil and v.buildingImg:getTag() == pos then
			info = v
			break
		end
	end
	if info.buildingImg == nil then
		return
	end

	self:createUpLvBuildingAnmation(info,buildingType)

	--创建进度条
	local leftUpLvTime = CityBuildingModel:getInstance():getLeftUpBuildingTime(beginUpTime,upNeedTime)
	self:createProcess(info,buildingType,pos,leftUpLvTime)
end

--完成升级建筑
--pos 建筑位置
--返回值(无)
function CityBuildingView:finishUpBuilding(pos)
	for k,v in pairs(self.buildingNodeList) do
		if v.buildingImg ~= nil and v.buildingImg:getTag() == pos then
			local buildingType = CityBuildingModel:getInstance():getBuildType(pos)
			local buildingInfo = CityBuildingModel:getInstance():getBuildInfo(pos)
			if buildingInfo ~= nil then
				local resPath = BuildingUpLvConfig:getInstance():getBuildingResPath2(buildingType,buildingInfo.level)
				v.buildingImg:loadTexture(resPath,ccui.TextureResType.plistType)
				local buildingTypeInfo = BuildingTypeConfig:getInstance():getConfigInfo(buildingType)
				local configInfo = BuildPosConfig:getInstance():getConfigInfoByPos(pos)
				v.buildingImg:setPosition(buildingTypeInfo.bt_deviationXY[1]+configInfo.x,buildingTypeInfo.bt_deviationXY[2]+configInfo.y)
			end
			--删除升级建筑动画
			self:delUpLvBuildingAnmation(v)
			--删了进度条
			self:delProcess(v,pos)
			self:updateLevel(pos)
			break
		end
	end
end

--修改造兵时间UI
--pos 建筑位置
--beginTime 开始造兵时间
--needTime 需要时间
function CityBuildingView:modifMakeSoldierTimeUI(pos,beginTime,needTime)
	local info = {}
	for k,v in pairs(self.buildingNodeList) do
		if v.buildingImg ~= nil and v.buildingImg:getTag() == pos then
			info = v
			break
		end
	end
	if info.buildingImg == nil then
		return
	end

	local buildingType = CityBuildingModel:getInstance():getBuildType(pos)
	if beginTime ~= nil and needTime ~= nil then
		--创建进度条
		local leftUpLvTime = CityBuildingModel:getInstance():getLeftUpBuildingTime(beginTime,needTime)
		local buildingType = CityBuildingModel:getInstance():getBuildType(pos)
		self:createProcess(info,buildingType,pos,leftUpLvTime,true)
	end
end

--创建造兵UI
--pos 建筑位置
--beginTime 开始造兵时间
--needTime 需要时间
--soldierAnmationTempleType 士兵动画模板类型
--返回值(无)
function CityBuildingView:createMakeSoilderUI(pos,beginTime,needTime,soldierAnmationTempleType)
	local info = {}
	for k,v in pairs(self.buildingNodeList) do
		if v.buildingImg ~= nil and v.buildingImg:getTag() == pos then
			info = v
			break
		end
	end
	if info.buildingImg == nil then
		return
	end

	--获取造兵动画父结点
	local anmationParent = info.buildingImg
	self:createMakeSoldiersAnmation(anmationParent,soldierAnmationTempleType)

	if beginTime ~= nil and needTime ~= nil then
		--创建进度条
		local leftUpLvTime = CityBuildingModel:getInstance():getLeftUpBuildingTime(beginTime,needTime)
		local buildingType = CityBuildingModel:getInstance():getBuildType(pos)
		self:createProcess(info,buildingType,pos,leftUpLvTime,true)
	end
end

--立即完成造兵结果
--buildingPos 建筑位置
--soldierAnmationTempleType 士兵动画模型类型
--返回值(无)
function CityBuildingView:rightNowFinishTrainRes(buildingPos,soldierAnmationTempleType)
	local info = {}
	for k,v in pairs(self.buildingNodeList) do
		if v.buildingImg ~= nil and v.buildingImg:getTag() == buildingPos then
			info = v
			break
		end
	end
	if info.buildingImg == nil then
		return
	end

	self:createMakeSoldiersAnmation(info.buildingImg,soldierAnmationTempleType)
	self:createHeadTrainFinishBtn(info)
end

--取消训练结果
--buildingPos 建筑位置
--返回值(无)
function CityBuildingView:cancelTrainRes(buildingPos)
	for k,v in pairs(self.buildingNodeList) do
		if v.buildingImg ~= nil and v.buildingImg:getTag() == buildingPos then
			--删了进度条
			self:delProcess(v,buildingPos)
			--删除造兵动画
			self:delMakeSoldiersAnmation(v.buildingImg)
			break
		end
	end
end

--完成造兵
--pos 建筑位置
--返回值(无)
function CityBuildingView:finishMakeSoldiers(pos)
	for k,v in pairs(self.buildingNodeList) do
		if v.buildingImg ~= nil and v.buildingImg:getTag() == pos then
			--删了进度条
			self:delProcess(v,pos)
			self:createHeadTrainFinishBtn(v)
			break
		end
	end
end

--完成取兵
--pos 建筑位置
--soldierType 士兵类型
--num 士兵数量
--lv 士兵等级
--返回值(无)
function CityBuildingView:getMakeSoldiers(pos,soldierType,num,lv)
	for k,v in pairs(self.buildingNodeList) do
		if v.buildingImg ~= nil and v.buildingImg:getTag() == pos then
			--获取父结点
			local processParent = v.buildingImg
			--删除头顶上的训练完成按钮
			if v.headTrainImg ~= nil then
				self:delHeadTrainBtn(v.headTrainImg)
				v.headTrainImg = nil
			end
			--删除造兵动画
			self:delMakeSoldiersAnmation(v.buildingImg)

			--创建待移动到空地的士兵
			local beginPos = Common:getPosition(processParent)
			beginPos.y = beginPos.y + 20
			beginPos.x = beginPos.x - 50
			local midPos = cc.p(183,968)
			local moveY = beginPos.y - midPos.y

			local colDis = 25
			local rowDis = 40
			local count = self:getModeCount(num)
			local index = 0
			local max = ARMS_MAX_COL*AMRS_MAX_ROW
			local rowCount = Common:getRowCountByCount(count,ARMS_MAX_COL)
			for row=1,rowCount do
				for col=1,ARMS_MAX_COL do
					index = index + 1
					if index > count then
						return
					end

					local armsList = self:createSoldier(soldierType,ANMATION_DIR.DOWN)
					if armsList == nil then
						return
					end

					local num = armsList.count
					local hero = armsList[num].hero
					local endPos = Common:getPosition(hero)
					local x = (col-1)*colDis + beginPos.x
					local y = beginPos.y - (row-1)*rowDis
					hero:setPosition(x, y)

					hero.acitonPos = {}
					hero.acitonPos.doTimer = 1
					hero.acitonPos[1] = {}
					hero.acitonPos[1].pos = endPos

					local function callback()
						hero:setStateAndDir(AI_STATE.IDLE, ANMATION_DIR.RIGHT_UP)
						--self:sortArmsList(armsList)
					end
					self:createSoldierMoveAction(cc.p(x,y),hero.acitonPos[hero.acitonPos.doTimer].pos,1,hero,callback)
				end
			end
			break
		end
	end
end

--创建士兵移动ACTION
--beginPos 起始坐标
--endPos 结束坐标
--delayTime 延迟时间
--hero 士兵
--callback 回调函数
--返回值(无)
function CityBuildingView:createSoldierMoveAction(beginPos,endPos,delayTime,hero,callback)
	local angle =  BattleCommon:getInstance():getTwoPosAngle(beginPos,endPos)
    local dir = BattleCommon:getInstance():getDirection(angle)
    local dis = cc.pGetDistance(beginPos,endPos)
	local time = dis/(hero.moveSpeed + 200)

	local sequence = transition.sequence({
		cc.DelayTime:create(delayTime),
		cc.CallFunc:create(function()
			hero:setStateAndDir(AI_STATE.MOVE, dir)
		end),
		cc.MoveTo:create(time,endPos),
		cc.CallFunc:create(function()
		    callback(self)
		end)
	})
	hero:runAction(sequence)
end

--对方阵进行排序
--armlist 方阵列表
--返回值(无)
function CityBuildingView:sortArmsList(armlist)
	local function resetArmsPos(heroList,index)
		for k,v in pairs(heroList) do
			local pos = self:getSoliderPosByIndex(armlist,index)
			print("index=",index,"x=",pos.x,"y=",pos.y,"armlist.pos x=",armlist.pos.x,"armlist.y=",armlist.pos.y)
			v:setPosition(pos)
			v:setStateAndDir(AI_STATE.IDLE, ANMATION_DIR.RIGHT_UP)
			index = index + 1
		end
		return index
	end

	local type1 = nil
	local type2 = nil
	if armlist.soldierType == OCCUPATION.cavalry then
		type1 = SOLDIER_TYPE.knight
		type2 = SOLDIER_TYPE.bowCavalry
	elseif armlist.soldierType == OCCUPATION.footsoldier then
		type1 = SOLDIER_TYPE.shieldSoldier
		type2 = SOLDIER_TYPE.marines
	elseif armlist.soldierType == OCCUPATION.archer then
		type1 = SOLDIER_TYPE.archer
		type2 = SOLDIER_TYPE.crossbowmen
	elseif armlist.soldierType == OCCUPATION.master then
		type1 = SOLDIER_TYPE.master
		type2 = SOLDIER_TYPE.warlock
	elseif armlist.soldierType == OCCUPATION.tank then
		type1 = SOLDIER_TYPE.tank
		type2 = SOLDIER_TYPE.catapult
	end

	local tab1 = {}
	local tab2 = {}
	for i=1,#armlist do
		if armlist[i].hero ~= nil then
			if armlist[i].hero.soldierType == type1 then
				table.insert(tab1,armlist[i].hero)
			elseif armlist[i].hero.soldierType == type2 then
				table.insert(tab2,armlist[i].hero)
			end
		end
	end

	local index = 1
	if #tab1 > #tab2 then
		index = resetArmsPos(tab1,index)
		resetArmsPos(tab2,index)
	else
		index = resetArmsPos(tab2,index)
		resetArmsPos(tab1,index)
	end
end

--获取士兵模型个数
--soldierNum 士兵数量
--返回值(模型个数)
function CityBuildingView:getModeCount(soldierNum)
	local modeCount = soldierNum/ARMS_NUM_TO_MODE
    if modeCount > 0 and modeCount < 1 then
       modeCount = modeCount + 1
    end
    return math.floor(modeCount)
end

--显示部队
--返回值(无)
function CityBuildingView:showArms()
	local function createArm(data)
    if data == nil then
      return
    end
		local modeCount = self:getModeCount(data.number)
		for i=1,modeCount do
			self:createSoldier(data.type,ANMATION_DIR.RIGHT_UP)
		end
	end

	local arms = ArmsData:getInstance():getAfterSortArms()
	if arms == nil then
		return
	end

	local dunbin = arms[SOLDIER_TYPE.shieldSoldier]
	local qianbin = arms[SOLDIER_TYPE.marines]
	createArm(dunbin)
	createArm(qianbin)

	local qishi = arms[SOLDIER_TYPE.knight]
	local gonqibin = arms[SOLDIER_TYPE.bowCavalry]
	createArm(qishi)
	createArm(gonqibin)

	local gonbin = arms[SOLDIER_TYPE.archer]
	local lubin = arms[SOLDIER_TYPE.crossbowmen]
	createArm(gonbin)
	createArm(lubin)

	local chonche = arms[SOLDIER_TYPE.tank]
	local toushiche = arms[SOLDIER_TYPE.catapult]
	createArm(chonche)
	createArm(toushiche)

	local fashi = arms[SOLDIER_TYPE.master]
	local shushi = arms[SOLDIER_TYPE.warlock]
	createArm(fashi)
	createArm(shushi)
end

--创建士兵
--soldierType 士兵类型
--dir 方向
--返回值(第N个方阵列表)
function CityBuildingView:createSoldier(soldierType,dir)
	local armsList = self:getArmsListBySoldierType(soldierType)
	if armsList == nil then
		return
	end
	local pos = self:getSoliderPos(armsList)
	local hero = self:createSoliderByType(soldierType,dir,self)
	hero:setPosition(pos)
	armsList.count = armsList.count + 1
	armsList[armsList.count] = {}
	armsList[armsList.count].hero = hero
	armsList[armsList.count].heroType = soldierType
	if armsList.soldierType == nil then
		local job = Common:soldierTypeToOccupation(soldierType)
		armsList.soldierType = job
	end
	return armsList
end

--创建士兵
--soldierType 士兵类型
--dir 方向
--parent 父结点
--zorder 层次
--返回值(士兵)
function CityBuildingView:createSoliderByType(soldierType,dir,parent,zorder)
	local hero = HeroArms.new(BATTLE_CONFIG[soldierType],dir,soldierType,CAMP.ATTER)
	zorder = zorder or 100
	parent:addChild(hero,zorder)
	return hero
end

--获取部队列表
--soldierType 士兵类型
--返回值(部队列表)
function CityBuildingView:getArmsListBySoldierType(soldierType)
	local job = Common:soldierTypeToOccupation(soldierType)
	local max = ARMS_MAX_COL*AMRS_MAX_ROW
	for k,v in pairs(self.armsList) do
		if v.soldierType == job then
			if v.count < max then
				return v
			end
		end
	end

	for i=1,#self.armsList do
		if self.armsList[i].count == 0 then
			return self.armsList[i]
		end
	end
end

--获取士兵站位坐标
--armsList 部队列表
--返回值(士兵站位坐标)
function CityBuildingView:getSoliderPos(armsList)
	local index = armsList.count+1
	local pos = self.armsPos[index].pos
	return cc.pAdd(pos,armsList.pos)
end

--获取士兵站位坐标
--armsList 部队列表
--index 下标
--返回值(士兵站位坐标)
function CityBuildingView:getSoliderPosByIndex(armsList,index)
	local pos = self.armsPos[index].pos
	return cc.pAdd(pos,armsList.pos)
end

--获取建筑信息
--buildingPos 建筑位置
--返回值(建筑信息)
function CityBuildingView:getBuildingInfoByPos(buildingPos)
	for k,v in pairs(self.buildingNodeList) do
		if v.buildingImg ~= nil and v.buildingImg:getTag() == buildingPos then
		    return v
		end
	end
end

--获取建筑信息列表(根据类型)
--buildingType 建筑类型
--返回值(建筑信息列表)
function CityBuildingView:getBuildingInfoListByType(buildingType)
	local tab = {}
	for k,v in pairs(self.buildingNodeList) do
		if v.buildingImg ~= nil then
			if buildingType == CityBuildingModel:getInstance():getBuildType(v.buildingImg:getTag()) then
				table.insert(tab,v)
			end
		end
	end
	return tab
end

--获取建筑信息(根据类型)
--buildingType 建筑类型
function CityBuildingView:getBuildingInfoByType(buildingType)
	for k,v in pairs(self.buildingNodeList) do
		if v.buildingImg ~= nil then
			if buildingType == CityBuildingModel:getInstance():getBuildType(v.buildingImg:getTag()) then
				return v
			end
		end
	end
end

--获取建筑位置通过建筑类型
function CityBuildingView:getBuildingPosByType(buildingType)
	for k,v in pairs(self.buildingNodeList) do
		if v.buildingImg ~= nil then
			if buildingType == CityBuildingModel:getInstance():getBuildType(v.buildingImg:getTag()) then
				return v.buildingImg:getTag()
			end
		end
	end
end

--资源丰收结果
--buildingPos 建筑位置
--返回值(无)
function CityBuildingView:harvestRes(buildingPos)
	local info = self:getBuildingInfoByPos(buildingPos)
	local buildingInfo = CityBuildingModel:getInstance():getBuildInfo(buildingPos)
	local builingUpInfo = BuildingUpLvConfig:getInstance():getConfigInfo(buildingInfo.type,buildingInfo.level)
	local resPath = BuildingUpLvConfig:getInstance():getBuildingResPath2(buildingInfo.type,buildingInfo.level)
	info.buildingImg:loadTexture(resPath,ccui.TextureResType.plistType)
	self:moveResAnmation(info.buildingImg,builingUpInfo.bu_id)
	self:delHeadHarvestImg(buildingPos)
end

--删除头顶上的丰收图片
function CityBuildingView:delHeadHarvestImg(buildingPos)
	local info = self:getBuildingInfoByPos(buildingPos)
	if info == nil or info.harvestImg == nil then
		return
	end
	info.harvestImg:removeFromParent()
	info.harvestImg = nil
end

--创建生产加速lab
--buildingPos 建筑位置
--返回值(无)
function CityBuildingView:createProducSpeedLab(buildingPos)
	local info = self:getBuildingInfoByPos(buildingPos)
	if info == nil then
		return
	end
	self:delProducSpeedLab(info)

	local timeInfo = UseGoldAcceResProduceModel:getInstance():getProcduResSpeedTimeInfo(buildingPos)
	if timeInfo == nil then
		return
	end
	local leftTimeStr = ""
	local leftTime = CityBuildingModel:getInstance():getLeftUpBuildingTime(timeInfo.start_time,timeInfo.interval)
	local time = Common:getHour(leftTime)
	if time < 1 then
		time = Common:getMin(leftTime)
		leftTimeStr = CommonStr.ACC_SPEED .. ": " .. time .. "Min"
	else
		leftTimeStr = CommonStr.ACC_SPEED .. ": " .. time .. "H"
	end

	local label = display.newTTFLabel({
	    text = leftTimeStr,
	    font = "Arial",
	    size = 20,
	    color = cc.c3b(255, 255, 255),
	    align = cc.TEXT_ALIGNMENT_LEFT,
	})
	self:addChild(label,10)
	local x,y = info.buildingImg:getPosition()
	label:setPosition(x, y-50)
	info.resProcduSpeed = label
	info.resProcduSpeedTime = timeInfo.interval
end

--删除生产加速lab
--tab 数据
--返回值(无)
function CityBuildingView:delProducSpeedLab(tab)
	if tab.resProcduSpeed ~= nil then
		tab.resProcduSpeed:removeFromParent()
		tab.resProcduSpeed = nil
	end
end

--完成生产加速
--buildingPos 建筑位置
--返回值(无)
function CityBuildingView:finishProducSpeed(buildingPos)
	local info = self:getBuildingInfoByPos(buildingPos)
	if info == nil then
		return
	end
	self:delProducSpeedLab(info)
end

--创建头顶上的丰收图片
--buildingPos 建筑位置
--返回值(无)
function CityBuildingView:createHavestImg(buildingPos)
	self:delHeadHarvestImg(buildingPos)
	local info = self:getBuildingInfoByPos(buildingPos)
	if info == nil then
		return
	end

	local buildingType = CityBuildingModel:getInstance():getBuildType(buildingPos)
	local resPath = self:getHeadHarvestImgPath(buildingType)
    local resSprite = cc.ui.UIPushButton.new({normal = resPath})
    resSprite:setTouchSwallowEnabled(false)
    resSprite:onButtonClicked(function()
    	CityBuildingService:sendCollectingResourcesReq(buildingPos)
    end)
    resSprite:onButtonPressed(function()
    	self:setIsClickRes(true)
    end)

    resSprite:setTag(buildingPos)
    resSprite:addTo(self)

	local x,y = info.buildingImg:getPosition()
	resSprite:setPosition(x, y+info.buildingImg:getBoundingBox().height-30)
	info.harvestImg = resSprite
	local sprite = display.newSprite(resPath)
	info.harvestImgSize = cc.size(sprite:getBoundingBox().width,sprite:getBoundingBox().height)

	-- local checkRect = {x=0,y=0,wide=50,high=50}
	-- local size = cc.size(checkRect.wide,checkRect.high)
	-- local checkRectLayer = display.newCutomColorLayer(cc.c4b(255,0,0,128),size.width,size.height)
	-- checkRectLayer:setContentSize(size)
	-- resSprite:addChild(checkRectLayer)
	-- checkRectLayer:setPosition(checkRect.x, checkRect.y)
end

--获取头顶上的丰收图片路径
--buildingType 建筑类型
--返回值(图片路径)
function CityBuildingView:getHeadHarvestImgPath(buildingType)
	local resPath = ""
    if buildingType == BuildType.farmland then
    	resPath = "citybuilding/ui_food.png"
    	--resPath = "ui_food.png"
    elseif buildingType == BuildType.loggingField then
    	resPath = "citybuilding/ui_wood.png"
    elseif buildingType == BuildType.ironOre then
    	resPath = "citybuilding/ui_iron.png"
    elseif buildingType == BuildType.illithium then
    	resPath = "citybuilding/ui_iron.png"
    end
    return resPath
end

--通知建筑丰收
--buildingPos 建筑位置
--返回值(无)
function CityBuildingView:noticeHarvestRes(buildingPos)
	local info = self:getBuildingInfoByPos(buildingPos)
	local buildingInfo = CityBuildingModel:getInstance():getBuildInfo(buildingPos)
	local builingUpInfo = BuildingUpLvConfig:getInstance():getConfigInfo(buildingInfo.type,buildingInfo.level)
	local resPath = ""
	if BuildType.farmland  == builingUpInfo.bu_id or builingUpInfo.bu_id == BuildType.loggingField then
		resPath = BuildingUpLvConfig:getInstance():getBuildingResPath2(buildingInfo.type,buildingInfo.level,"_002.png")
	else
		resPath = BuildingUpLvConfig:getInstance():getBuildingResPath2(buildingInfo.type,buildingInfo.level)
	end
	info.buildingImg:loadTexture(resPath,ccui.TextureResType.plistType)
	self:createHavestImg(buildingPos)
end

--更新时间
--dt 时间
--返回值(无)
function CityBuildingView:updateTime(dt)
	for k,v in pairs(self.processLabList) do
		local lab = v.lab
		v.leftTime = v.leftTime - 1
		if v.leftTime < 0 then
			v.leftTime = 0
		end
		local timeStr = Common:getFormatTime(v.leftTime)
		lab:setString(timeStr)

		if v.leftTime == 0 then
			if v.isMakeSoldier then
				--CityBuildingModel:getInstance():syncMakeSoldiersFinishData(v)
			else

			end
		end
	end

	for k,v in pairs(self.buildingNodeList) do
		local lab = v.resProcduSpeed
		if lab ~= nil then
			v.resProcduSpeedTime = v.resProcduSpeedTime - 1
			if v.resProcduSpeedTime < 0 then
				v.resProcduSpeedTime = 0
			end
			local time = Common:getHour(v.resProcduSpeedTime)
			if time < 1 then
				time = Common:getMin(v.resProcduSpeedTime)
				leftTimeStr = CommonStr.ACC_SPEED .. ": " .. time .. "Min"
			else
				leftTimeStr = CommonStr.ACC_SPEED .. ": " .. time .. "H"
			end
			lab:setString(leftTimeStr)
		end
	end
end

--移动资源动画
--buildingImg 建筑图片
--buildingType 建筑类型
--返回值(无)
function CityBuildingView:moveResAnmation(buildingImg,buildingType)
	local cityCommand = UIMgr:getInstance():getUICtrlByType(UITYPE.CITY)
	if cityCommand ~= nil then
		local view = cityCommand:getView()
		local x = buildingImg:getPositionX()
	    local y = buildingImg:getPositionY()
	    local buildingWorldPos = buildingImg:getParent():convertToWorldSpace(cc.p(x,y))
	    local resPath = self:getHeadHarvestImgPath(buildingType)
	    local targetResNode = nil
	    if buildingType == BuildType.farmland then
	    	targetResNode = view.foodImg
	    elseif buildingType == BuildType.loggingField then
	    	targetResNode = view.woodImg
	    elseif buildingType == BuildType.ironOre then
	    	targetResNode = view.ironImg
	    elseif buildingType == BuildType.illithium then
	    	targetResNode = view.mithrilImg
	    end

	    local x = targetResNode:getPositionX() - targetResNode:getBoundingBox().width
	    local y = targetResNode:getPositionY()
	    local targetWroldPos = targetResNode:getParent():convertToWorldSpace(cc.p(x,y))

	    local function createMoveAction(beginPos,isLast)
	    	local resSprite = display.newSprite(resPath)
		    view:addChild(resSprite,1000)
		    resSprite:setPosition(beginPos)

		    local sequence = transition.sequence({
		    	cc.MoveTo:create(0.7,targetWroldPos),
		    	cc.CallFunc:create(function()
		    		resSprite:removeFromParent()
		    		if isLast then
		    			UICommon:getInstance():updatePlayerDataUI()
		    		end
		    		if targetResNode ~= nil then
		    			targetResNode:setScale(0.2)
		    			local actionTo = cc.ScaleTo:create(0.2, 1)
    					targetResNode:runAction(actionTo)
		    		end
		    	end),
		    })
			resSprite:runAction(sequence)
	    end

	    local delayTime = 0.2
	  	local sequence = transition.sequence({
	  		createMoveAction(buildingWorldPos),
    		cc.DelayTime:create(0.1),
	    	cc.CallFunc:create(function()
	    		createMoveAction(cc.p(buildingWorldPos.x+100,buildingWorldPos.y))
	    	end),
	    	cc.DelayTime:create(delayTime),
	    	cc.CallFunc:create(function()
	    		createMoveAction(buildingWorldPos)
	    	end),
	    	cc.DelayTime:create(0.1),
	    	cc.CallFunc:create(function()
	    		createMoveAction(cc.p(buildingWorldPos.x+100,buildingWorldPos.y),true)
	    	end),
	    })
	    self:runAction(sequence)
	end
end

--升级科技
function CityBuildingView:upGradeTechnology()
	if self.technology ~= nil then
		return
	end

	local timeId_h,timeId_l = TechnologyModel:getInstance():getTimeId()
	if timeId_h == 0 and timeId_l == 0 then
		return
	end

	self.technology = MMUITime.new()
	self:addChild(self.technology,10)

	self.technology:upLevel(timeId_h,timeId_l)
	local info = self:getBuildingInfoByType(BuildType.COLLEGE)
	if info ~= nil then
		local x,y = info.buildingImg:getPosition()
		y = y-info.buildingImg:getBoundingBox().height/2-10
		self.technology:setPos(x,y)
	end
end

--删除科技进度条
function CityBuildingView:delTechnologyProcess()
	if self.technology ~= nil then
		self.technology:removeFromParent()
		self.technology = nil
	end
end











