
--[[
jinyan.zhang
UI公共方法
--]]

UICommon = class("UICommon")
local instance = nil

--构造
--返回值(无)
function UICommon:ctor()
	self:init()
end

--初始化
--返回值(无)
function UICommon:init()

end

--获取单例
--返回值(单例)
function UICommon:getInstance()
	if instance == nil then
		instance = UICommon.new()
	end
	return instance
end

--根据建筑物的位置，放大移动地图
--building 建筑结点
--targetNode 要移动到的目标结点
--parent 父结点
--返回值(无)
function UICommon:moveMapToDest(building,targetNode,parent)
	local cityMap = MapMgr:getInstance():getCity()
	local map = cityMap:getBgMap()
	cityMap:setTouchAble(false,map)
	cityMap:stopScrollingTime()
	self.preMapPos = Common:getPosition(map)

	self.time = 0.2
	self.scale = 1.2
	map:setScale(self.scale)

	local nSp1x, nSp1y = building:getPosition()
	if parent.data.floor ~= nil then
		local floorX, floorY = building:getParent():getPosition()
		floorX = floorX - building:getParent():getAnchorPoint().x*building:getParent():getBoundingBox().width
		floorY = floorY - building:getParent():getAnchorPoint().y*building:getParent():getBoundingBox().height
		nSp1x = nSp1x + floorX - building:getAnchorPoint().x*building:getBoundingBox().width
		nSp1y = nSp1y + floorY - building:getAnchorPoint().y*building:getBoundingBox().height
	end
	local nSp2x, nSp2y = targetNode:getPosition()

	local tSp1XY = map:convertToWorldSpace(cc.p(nSp1x, nSp1y))
	local tSp2XY = parent:convertToWorldSpace(cc.p(nSp2x, nSp2y))

	local x = tSp1XY.x - tSp2XY.x
	local y = tSp1XY.y - tSp2XY.y

	local nBg2X, nBg2Y = map:getPosition()
	local movePos = cc.p(nBg2X - x, nBg2Y - y)

	local moveAction = cc.MoveTo:create(self.time, movePos)
	local scaleToAction = cc.ScaleTo:create(self.time,self.scale)
	local actions = cca.spawn({moveAction,scaleToAction})
	map:setScale(1)

	map:runAction(actions)
end

--地图移回原位
--返回值(无)
function UICommon:moveBackMapToDest()
	if self.preMapPos == nil then
		return
	end

	local cityMap = MapMgr:getInstance():getCity()
	if cityMap == nil then
	   return
	end

	local map = cityMap:getBgMap()
	local moveAction = cc.MoveTo:create(self.time, self.preMapPos)
	local scaleToAction = cc.ScaleTo:create(self.time,cityMap:getMapScale())
	local actions = cca.spawn({moveAction,scaleToAction})
	map:runAction(actions)
	self.preMapPos = nil
	cityMap:setTouchAble(true,map)
end

--显示内存信息
--memInfoStr 内存信息
--返回值(无)
function UICommon:showMemInfoLab(memInfoStr)
	local runScene = cc.Director:getInstance():getRunningScene()
	if runScene ~= nil then
		local lab = runScene:getChildByTag(10231)
		if lab == nil then
			lab = display.newTTFLabel({
		    text = "",
		    font = "Arial",
		    size = 22,
		    color = cc.c3b(255, 255, 0), -- 使用纯红色
		    align = cc.TEXT_ALIGNMENT_LEFT,
			})
			lab:setAnchorPoint(0,0)
			runScene:addChild(lab, 10000, 10231)
		end
		lab:setString(memInfoStr)
		MyLog("info=",memInfoStr)
		lab:setPosition(0,400)
	end
end

--加载进度条
function UICommon:loadLoadingProcess()
	local loadingCtrl = UIMgr:getInstance():getUICtrlByType(UITYPE.LOADING)
	if loadingCtrl ~= nil then
		loadingCtrl:loadMsgProcess()
	end
end

--加载进度条文本
function UICommon:loadProcessText(text)
	local loadingCtrl = UIMgr:getInstance():getUICtrlByType(UITYPE.LOADING)
	if loadingCtrl ~= nil then
		loadingCtrl:loadText(text)
	end
end

--创建进度条
--time 时间
--parent 父结点
--bgPath 背景图片路径
--picPath 图片路径
--bgPos  背景坐标
--processPos 进度条坐标
--zorder 层级
--tag
--返回值(进度条)
function UICommon:createProgress(time,parent,bgPath,picPath,bgPos,processPos,zorder,tag)
	--进度条背景框
	local bg = display.newSprite(bgPath)
    bg:setPosition(bgPos)
    parent:addChild(bg,zorder,tag)

    --进度条
	local action = cc.ProgressTo:create(time, 100)
    local process= cc.ProgressTimer:create(cc.Sprite:create(picPath))
    process:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    process:setMidpoint(cc.p(0, 0))
    process:setBarChangeRate(cc.p(1, 0))
    process:setPosition(processPos)
    process:runAction(action)
    bg:addChild(process)
    return bg
end

--设置层级
--node 节点
--zorder 层级
--返回值(无)
function UICommon:setNodeZoder(node,zorder)
    node:setLocalZOrder(zorder)
    --node:setGlobalZOrder(zorder)
end

--设置地图触摸使能与否
--able(true:使能,false:禁用)
function UICommon:setMapTouchAable(able)
	local city = MapMgr:getInstance():getCity()
	if city ~= nil then
		city:setMapBuildingTouchAble(able)
	end

	local wolrdMap = MapMgr:getInstance():getWorldMap()
	if wolrdMap ~= nil then
		wolrdMap:setMapAble(able)
	end
end

--打开邮件详情界面
--返回值(无)
function UICommon:openMailDetailsView()
	local data = MailsModel:getInstance():getLastOpenMailDetailsData()
    if data ~= nil then
        UIMgr:getInstance():openUI(UITYPE.CITY_BUILD_MAIL,{details = data})
    end
end

--删除闪烁图片
--返回值(无)
function UICommon:delBlankPic()
	local layer = SceneMgr:getInstance():getUILayer()
	layer:removeChildByTag(92342)
end

--创建一个带闪烁的效果图片
--返回值(无)
function UICommon:createBlankPic()
	local layer = SceneMgr:getInstance():getUILayer()
	if layer:getChildByTag(92342) ~= nil then
		return
	end

	local blankImg = display.newScale9Sprite("ui/watchtower_1/redBox.png",0,0,cc.size(display.width,display.height))
	layer:addChild(blankImg, 1000, 92342)
	blankImg:setAnchorPoint(0,0)

	local action = cc.RepeatForever:create(cc.Blink:create(1, 2))
	blankImg:runAction(action)
end

--创建闪烁的图片
function UICommon:createBlankNode(path,parent)
	local sprite = ccui.ImageView:create("")
    sprite:loadTexture(path)
    parent:addChild(sprite)
    sprite:setOpacity(128)
    --self:createBlinkAction(sprite)
	return sprite
end

function UICommon:createBlinkAction(sprite)
	local action = cc.RepeatForever:create(cc.Blink:create(1, 1))
	sprite:runAction(action)
end

--刷新玩家数据UI
function UICommon:updatePlayerDataUI()
	local cityCommand = UIMgr:getInstance():getUICtrlByType(UITYPE.CITY)
	if cityCommand ~= nil then
		cityCommand:updateUI()
	end

	local outCityCommand = UIMgr:getInstance():getUICtrlByType(UITYPE.OUT_CITY)
	if outCityCommand ~= nil then
		outCityCommand:updateUI()
	end
end

--刷新粮食
function UICommon:updateFoodUI()
	local cityCommand = UIMgr:getInstance():getUICtrlByType(UITYPE.CITY)
	if cityCommand ~= nil then
		cityCommand:updateFoodUI()
	end

	local outCityCommand = UIMgr:getInstance():getUICtrlByType(UITYPE.OUT_CITY)
	if outCityCommand ~= nil then
		outCityCommand:updateFoodUI()
	end
end

--更新城墙UI
function UICommon:updateWallUI()
	local cityBuildingListCtrl = MapMgr:getInstance():getCityBuildingListCtrl()
	if cityBuildingListCtrl ~= nil then
	 	cityBuildingListCtrl:updateWallPic()
	end

	local command = UIMgr:getInstance():getUICtrlByType(UITYPE.BUILDING_MENU)
	if command ~= nil then
		command:updateWallPic()
	end
end

--获取英雄头像图片
function UICommon:getHeadImg(id)
	return "#" .. "hand_001.png"
end

--是否点击在精灵上
--pos 点击坐标
--返回值(true:是，false:否)
function UICommon:isClickNode(sprite,clickPos)
    if sprite == nil or clickPos == nil then
        return false
    end

    local worldPos = Common:converToWorldPos(sprite)
    local size = sprite:getBoundingBox()
    worldPos.x = worldPos.x - size.width*sprite:getAnchorPoint().x
    worldPos.y = worldPos.y - size.height*sprite:getAnchorPoint().y

    if clickPos.x >= worldPos.x and clickPos.x <= worldPos.x + size.width and
        clickPos.y >= worldPos.y and clickPos.y <= worldPos.y + size.height then
        return true
    end

    return false
end


