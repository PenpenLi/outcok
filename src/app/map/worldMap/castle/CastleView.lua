

--[[
	jinyan.zhang
	城堡管理器
--]]

CastleView = class("CastleView",function()
	return display.newLayer()
end)

--构造
--返回值(无)
function CastleView:ctor(parent)
	self.parent = parent
	self:init()
end

--初始化
--返回值(无)
function CastleView:init() 
	self.castleMgr = {}
	self.curShowMenuBtnList = {}
end

function CastleView:delAllCastle()
	for k,v in pairs(self.castleMgr) do
		HeroMgr:getInstance():delSolider(v.sprite)
		v.labName:removeFromParent()
	end
	self.castleMgr = {}
end

--创建地图上的所有城堡
--data 城堡数据
--返回值(无)
function CastleView:createCastlelList(data)
	for k,v in pairs(data) do
    	local gridPos = cc.p(v.x,v.y)
    	if self:isClickMyCastle(gridPos) then
    		self:createCastle(v.level,gridPos,CommonStr.MY_CASTLE)
    	else
    		self:createCastle(v.level,gridPos,v.name)
    	end
	end
end

--创建城堡
--worldMap 世界地图
--lv 等级
--gridPos 网格坐标
--返回值(无)
function CastleView:createCastle(lv,gridPos,name)
	local pos = self.parent:worldGridPosToScreenPos(gridPos)
	local castle = AICastle.new(lv,pos,CAMP.DEFER)
	self:addChild(castle,WORLDE_MAP_ZORDER.BUILDING)
	HeroMgr:getInstance():addSoldier(castle,SOLDIER_TYPE.CASTLE,CAMP.DEFER)

	local nameLab = display.newTTFLabel({
	    text = name,
	    font = "Arial",
	    size = 24,
	    color = cc.c3b(255, 255, 0),
	    align = cc.TEXT_ALIGNMENT_LEFT,
	})
	nameLab:setPosition(pos.x, pos.y-100)
	self:addChild(nameLab,WORLDE_MAP_ZORDER.BUILDING)

	local castleInfo = {}
	castleInfo.sprite = castle
	castleInfo.lv = lv
	castleInfo.gridPos = gridPos
	castleInfo.pos = pos
	castleInfo.labName = nameLab
	table.insert(self.castleMgr,castleInfo)
end

--是否点击在城堡上
--clickGridPos 点击的网格坐标
function CastleView:isClickCastle(clickGridPos)
	self:delCurShowMenu()

	for k,v in pairs(self.castleMgr) do
		if v.gridPos.x == clickGridPos.x and v.gridPos.y == clickGridPos.y then
			if self:isClickMyCastle(clickGridPos) then  --点击在我的城堡上
				self:showMyCastleMenu(v)
			else
				self:showOtherCastleMenu(v)
			end
			return true
		end
	end
	return false
end

--显示我的城堡菜单
--info 城堡信息
--返回值(无)
function CastleView:showMyCastleMenu(info)
	--详情按钮
	local pos = cc.p(info.pos.x-150,info.pos.y - 10)
	local detailsBtn = self:createBtn("citybuilding/castleDetailBtn.png",pos)
	self:myCastleDetailsCallbackEvent(detailsBtn,info)
	table.insert(self.curShowMenuBtnList,detailsBtn)

	--增益按钮
	local pos = cc.p(info.pos.x+150,info.pos.y - 10)
	local addBtn = self:createBtn("citybuilding/addBtn.png",pos)
	self:myCastleAddCallbackEvent(addBtn,info)
	table.insert(self.curShowMenuBtnList,addBtn)

	--进入按钮
	local pos = cc.p(info.pos.x,info.pos.y + 130)
	local intoBtn = self:createBtn("citybuilding/intoCityBtn.png",pos)
	self:myCastleIntoCityCallbackEvent(intoBtn,info)
	table.insert(self.curShowMenuBtnList,intoBtn)

	--创建城堡坐标信息菜单
	self:createCastlePosMenu(info)
end

--我的城堡详情按钮回调事件
--btn 详情按钮
--info 我的城堡详细信息
--返回值(无)
function CastleView:myCastleDetailsCallbackEvent(btn,info)
    btn:onButtonPressed(function(event)

    end)
    btn:onButtonRelease(function(event)

    end)
    btn:onButtonClicked(function(event)
    	--todo
    	self:delCurShowMenu()
    end)
end

--我的城堡增益按钮回调事件
--btn 增益按钮
--info 我的城堡详细信息
--返回值(无)
function CastleView:myCastleAddCallbackEvent(btn,info)
    btn:onButtonPressed(function(event)

    end)
    btn:onButtonRelease(function(event)

    end)
    btn:onButtonClicked(function(event)
    	--todo
    	self:delCurShowMenu()
    end)
end

--我的城堡进入按钮回调事件
--btn 进入按钮
--info 我的城堡详细信息
--返回值(无)
function CastleView:myCastleIntoCityCallbackEvent(btn,info)
    btn:onButtonPressed(function(event)

    end)
    btn:onButtonRelease(function(event)

    end)
    btn:onButtonClicked(function(event)
    	SceneMgr:getInstance():goToCity()
    end)
end

--显示其它人城堡菜单
--info 城堡信息
--返回值(无)
function CastleView:showOtherCastleMenu(info)
	--详情按钮
	local pos = cc.p(info.pos.x-150,info.pos.y - 10)
	local detailsBtn = self:createBtn("citybuilding/castleDetailBtn.png",pos)
	self:castleDetailsCallbackEvent(detailsBtn,info)
	table.insert(self.curShowMenuBtnList,detailsBtn)

	--侦察按钮
	local pos = cc.p(info.pos.x+150,info.pos.y - 10)
	local lookBtn = self:createBtn("citybuilding/lookbtn.png",pos)
	self:castleLookCallbackEvent(lookBtn,info)
	table.insert(self.curShowMenuBtnList,lookBtn)

	--进攻按钮
	local pos = cc.p(info.pos.x-80,info.pos.y + 130)
	local attBtn = self:createBtn("citybuilding/attCastleBtn.png",pos)
	self:castlAttCallbackEvent(attBtn,info)
	table.insert(self.curShowMenuBtnList,attBtn)

	--宣战按钮
	local pos = cc.p(info.pos.x+80,info.pos.y + 130)
	local warBtn = self:createBtn("citybuilding/warbtn.png",pos)
	self:castlWarCallbackEvent(warBtn,info)
	table.insert(self.curShowMenuBtnList,warBtn)

	--创建城堡坐标信息菜单
	self:createCastlePosMenu(info)
end

--创建城堡坐标信息菜单
--info 信息
--返回值(无)
function CastleView:createCastlePosMenu(info)
	--圈
	local quan = display.newSprite("citybuilding/menu_quan.png")
	self:addChild(quan)
	quan:setPosition(info.pos.x,info.pos.y-20)
	table.insert(self.curShowMenuBtnList,quan)

	--坐标背景
	local posBg = display.newScale9Sprite("citybuilding/castle_menu_quan.png", 0, 0, cc.size(250,64))
	posBg:setPosition(info.pos.x,info.pos.y-150)
	self:addChild(posBg,2)
	table.insert(self.curShowMenuBtnList,posBg)

	--书
	local book = display.newScale9Sprite("citybuilding/castle_book.png")
	posBg:addChild(book)
	book:setPosition(0,30)

	--按钮
	local btn = cc.ui.UIPushButton.new("citybuilding/castle_menu_btn.png")
	posBg:addChild(btn)
	btn:setPosition(220, 30)

	--坐标
	local posLab = display.newTTFLabel({
	    text = "x:" .. info.gridPos.x .. ", Y:" .. info.gridPos.y,
	    font = "Arial",
	    size = 22,
	    color = cc.c3b(255, 255, 0),
	    align = cc.TEXT_ALIGNMENT_LEFT,
	})
	posBg:addChild(posLab)
	posLab:setPosition(110, 30)
end

--城堡详情按钮回调事件
--btn 进入按钮
--info 城堡详细信息
--返回值(无)
function CastleView:castleDetailsCallbackEvent(btn,info)
    btn:onButtonPressed(function(event)

    end)
    btn:onButtonRelease(function(event)

    end)
    btn:onButtonClicked(function(event)
    	self:delCurShowMenu()
    end)
end

--城堡侦察按钮回调事件
--btn 侦察按钮
--info 城堡详细信息
--返回值(无)
function CastleView:castleLookCallbackEvent(btn,info)
    btn:onButtonPressed(function(event)

    end)
    btn:onButtonRelease(function(event)

    end)
    btn:onButtonClicked(function(event)
    	self:delCurShowMenu()

    	local targetData = {}
    	targetData.lv = info.lv
    	targetData.gridPos = info.gridPos
    	targetData.pos = info.pos

    	local playerGridPos = cc.p(PlayerData:getInstance().x,PlayerData:getInstance().y)

		local data = {}
		data.castTime = Common:calMarchTime(playerGridPos,targetData.gridPos)
		data.castTime = math.floor(data.castTime/100)

		data.castFood = Common:calCastFood(playerGridPos,targetData.gridPos,targetData.lv)
		data.targetPos = targetData.pos
		data.targetGridPos = targetData.gridPos

    	UIMgr:getInstance():openUI(UITYPE.LOOK,data)
    end)
end

--城堡进攻按钮回调事件
--btn 侦察按钮
--info 城堡详细信息
--返回值(无)
function CastleView:castlAttCallbackEvent(btn,info)
    btn:onButtonPressed(function(event)

    end)
    btn:onButtonRelease(function(event)

    end)
    btn:onButtonClicked(function(event)
    	 self:delCurShowMenu()

    	 local playerGridPos = cc.p(PlayerData:getInstance().x,PlayerData:getInstance().y)
         info.castTime = math.floor(Common:calMarchTime(playerGridPos,info.gridPos)/100)
    	 info.castTime = Common:getFormatTime(info.castTime)

    	 UIMgr:getInstance():openUI(UITYPE.GO_BATTLE_CITY,info)
    end)
end

--城堡宣战按钮回调事件
--btn 宣战按钮
--info 城堡详细信息
--返回值(无)
function CastleView:castlWarCallbackEvent(btn,info)
    btn:onButtonPressed(function(event)

    end)
    btn:onButtonRelease(function(event)

    end)
    btn:onButtonClicked(function(event)
    	self:delCurShowMenu()
    end)
end

--是否点击了我的城堡
--clickGridPos 点击的网格坐标
--返回值(true:是,false:否)
function CastleView:isClickMyCastle(clickGridPos)
	if PlayerData:getInstance().x == clickGridPos.x and PlayerData:getInstance().y == clickGridPos.y then
		return true
	end
end

--创建按钮
--path 文件路径
--parent 父结点
--pos 坐标
--返回值(按钮)
function CastleView:createBtn(path,pos)
	local btn = cc.ui.UIPushButton.new(path)
	self:addChild(btn,1)
	btn:setPosition(pos)
    return btn
end

--删除当前显示的菜单
--返回值(无)
function CastleView:delCurShowMenu()
	for k,v in pairs(self.curShowMenuBtnList) do
		v:removeFromParent()
	end
	self.curShowMenuBtnList = {}
end

--通过网格坐标获取攻击目标
--gridPos 网格坐标
--返回值(攻击目标)
function CastleView:getAttTargetByGridPos(gridPos)
	for k,v in pairs(self.castleMgr) do
		if v.gridPos.x == gridPos.x and v.gridPos.y == gridPos.y then
			return v.sprite
		end
	end
end


