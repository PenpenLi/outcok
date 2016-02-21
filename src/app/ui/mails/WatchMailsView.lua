
--[[
	jinyan.zhang
	侦察邮件UI
--]]

WatchMailsView = class("WatchMailsView")

function WatchMailsView:ctor(parent)
	self.parent = parent
	self:init()
end

function WatchMailsView:init()
	self.view = Common:seekNodeByName(self.parent.root,"pan_watch")

 	--关闭按钮
	self.btnClose = Common:seekNodeByName(self.view,"btn_close")
    self.btnClose:addTouchEventListener(handler(self,self.onClose))

    --标题
    self.labTitle = Common:seekNodeByName(self.view,"lab_title")
    self.labTitle:setString("--")

    --侦察内容
    self.labWatchContent = Common:seekNodeByName(self.view,"lab_watchcontent")
    self.labWatchContent:setString("--")

    --侦察目标
    self.labTarget = Common:seekNodeByName(self.view,"lab_target")
    self.labTarget:setString(Lan:lanText(91, "目标"))

    --时间
    self.labTime = Common:seekNodeByName(self.view,"lab_time")
    self.labTime:setString("--")

    --滚动层
    self.panListView = Common:seekNodeByName(self.view,"scrollpan_list")

    --滚动列表上的内容层
    self.panContent = Common:seekNodeByName(self.panListView,"pan_list")
end

--关闭按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function WatchMailsView:onClose(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
    	self:hide()
    end
end

--显示
function WatchMailsView:show()
	self.view:setVisible(true)
end

--隐藏
function WatchMailsView:hide()
	self.view:setVisible(false)
	self.panContent:removeAllChildren()
	self.labTitle:setString("")
	self.labTime:setString("")
	self.labWatchContent:setString("")
	self.parent:onBattleReport()
end

--计算滚动列表大小
function WatchMailsView:calScrollViewSize()
	--总高度
    local totalHigh = self.panContent:getContentSize().height - self.beginY
    local innerLayer = self.panListView:getInnerContainer()
    local oldSize = self.panContent:getContentSize()
    if totalHigh < oldSize.height then
        totalHigh = oldSize.height
    end
    innerLayer:setContentSize(cc.size(oldSize.width,totalHigh))
    self.panListView:jumpToTop()

    local offsetY = totalHigh - oldSize.height
    print("totalHigh=",totalHigh,"offsetY=",offsetY,"oldSize.high=",oldSize.height)
    self.panContent:setPositionY(offsetY)
end 

--更新UI
function WatchMailsView:updateUI(data)
	self.panContent:removeAllChildren()
	if data.subType == MailSubType.watch then  --侦查
		self:updateSccuUI(data)
	elseif data.subType == MailSubType.beWatch then  --被侦查
		self:updateBeWatchUI(data)
	end
	self:calScrollViewSize()
end

--更新侦察成功UI
function WatchMailsView:updateSccuUI(data)
	local info = data.reportInfo
	--标题
	self.labTitle:setString(Lan:lanText(89, "侦查成功"))
	--时间
	self.labTime:setString("" .. data.time)
	--侦察简要内容
	self.labWatchContent:setString(info.brif)
	--大小
	local size = self.panContent:getContentSize()
	--创建领主信息
	local beginY = self:createLordInfo(size.height,info.lordInfo)
	--有消耗资源
	if info.haveCastRes then
		--创建资源标题
		beginY = self:createTitleImg(beginY-55,"资源") - 30
		--消耗资源
		local castArry = {}
		castArry[1] = {name=Lan:lanText(92, "仓库"),x=150}
		castArry[2] = {name=Lan:lanText(93, "城内未收取"),x=280}
		--castArry[3] = {name=Lan:lanText(94, "城外未收取"),x=480}
		for i=1,#castArry do
			local info = castArry[i]
			local labCast = display.newTTFLabel({
		        text = "",
		        font = "Arial",
		        size = 26,
		        color = cc.c3b(0, 0, 0),
    		})
		    labCast:setString(info.name)
		    labCast:setAnchorPoint(0,0)
		    self.panContent:addChild(labCast)
		   	labCast:setPosition(info.x,beginY)
		end
		beginY = beginY - 35

	    local function getCastResArry(arryCast)
	        local arryCastRes = {}
	        for i=1,#arryCast do
	            local info = arryCast[i]
	            if info.warehouse > 0 or info.unGetCity > 0 or info.unGetOut > 0 then
	                table.insert(arryCastRes,info)
	            end
	        end
	        return arryCastRes
	    end

		local castResArry = {}
		castResArry[1] = {name=Lan:lanText(95, "粮食"),warehouse=info.foodInfo.depotNum,unGetCity=info.foodInfo.inUncoll,unGetOut=0}
		castResArry[2] = {name=Lan:lanText(96, "木材"),warehouse=info.woodInfo.depotNum,unGetCity=info.woodInfo.inUncoll,unGetOut=0}
		castResArry[3] = {name=Lan:lanText(97, "铁矿"),warehouse=info.ironInfo.depotNum,unGetCity=info.ironInfo.inUncoll,unGetOut=0}
		castResArry[4] = {name=Lan:lanText(98, "秘银"),warehouse=info.mithrilInfo.depotNum,unGetCity=info.mithrilInfo.inUncoll,unGetOut=0}
		local castRes = getCastResArry(castResArry)
		local count = #castRes
    	for i=1,count do
    		local info = castRes[i]
    		--标题
    		local labTitle = display.newTTFLabel({
		        text = "",
		        font = "Arial",
		        size = 26,
		        color = cc.c3b(0, 0, 0),
    		})
		    labTitle:setAnchorPoint(0,0)
		    self.panContent:addChild(labTitle)
		    local y = beginY - (i-1)*50
		   	labTitle:setPosition(40,y)
		   	labTitle:setString(info.name)

		   	--仓库资源
    		local labHouseRes = display.newTTFLabel({
		        text = "",
		        font = "Arial",
		        size = 26,
		        color = cc.c3b(0, 0, 0),
    		})
		    labHouseRes:setAnchorPoint(0.5,0)
		    self.panContent:addChild(labHouseRes)
		    local x = castArry[1].x + 26
		   	labHouseRes:setPosition(x,labTitle:getPositionY())
		   	labHouseRes:setString("" .. info.warehouse)

		   	--城内未领取资源
    		local labCityRes = display.newTTFLabel({
		        text = "",
		        font = "Arial",
		        size = 26,
		        color = cc.c3b(0, 0, 0),
    		})
		    labCityRes:setAnchorPoint(0.5,0)
		    self.panContent:addChild(labCityRes)
		    local x = castArry[2].x + 60
		   	labCityRes:setPosition(x,labTitle:getPositionY())
		   	labCityRes:setString("" .. info.unGetCity)

		   	-- --城外未领取资源
    		-- local labOutCityRes = display.newTTFLabel({
		    --     text = "",
		    --     font = "Arial",
		    --     size = 26,
		    --     color = cc.c3b(0, 0, 0),
    		-- })
		    -- labOutCityRes:setAnchorPoint(0.5,0)
		    -- self.panContent:addChild(labOutCityRes)
		    -- local x = castArry[3].x + 60
		   	-- labOutCityRes:setPosition(x,labTitle:getPositionY())
		   	-- labOutCityRes:setString("" .. info.unGetOut)
		   	if i == count then
		   		beginY = y
		   	end
    	end
    	beginY = beginY - 20
	end
	--防御
	beginY = self:createDefAttr(beginY-40,info)
	--英雄列表
	beginY = self:createHeroInfo(beginY,true,info.arrHero)
	--部队
	beginY = self:createArms(beginY,true,info.arrArms)
	--领主技能
	beginY = self:createLordSkill(beginY,info.arrLordSkill)
	--部队属性
	beginY = self:createArmsAttr(beginY,info.arrArmsAttr)
	--援助部队
	--beginY = self:createHelpArms(beginY,info)
	self.beginY = beginY
end

--创建领主技能
function WatchMailsView:createLordSkill(beginY,skills)
	if skills == nil or #skills == 0 then
		return beginY
	end

	beginY = self:createTitleImg(beginY,Lan:lanText(104, "领主技能"))-10
	local count = #skills
	local index = 0
	local rowCount,yu = count/5
	if yu ~= 0 then
		rowCount = rowCount + 1
	end
	for row=1,rowCount do
		--背景
		local signHigh = 175
	    local imgBg = display.newScale9Sprite("#mail_floor.png", 0, 0, cc.size(display.width,signHigh))
	    imgBg:setAnchorPoint(0,1)
	    self.panContent:addChild(imgBg)
	    local y = beginY - (row-1)*imgBg:getBoundingBox().height
	   	imgBg:setPosition(0,y)

		for col=1,5 do
			local info = skills[index+1]
			--技能框
			local imgSkillBg = display.newSprite("#propWin_itembox.png")
			imgSkillBg:setAnchorPoint(0,0)
			imgBg:addChild(imgSkillBg)
			local x = 10 + (col-1)*(imgSkillBg:getBoundingBox().width+45)
			local y = (imgBg:getBoundingBox().height-imgSkillBg:getBoundingBox().height)/2+12
			imgSkillBg:setPosition(x,y)

			local imgSkill = MMUISimpleUI:getLordSkillIcon(info.skillId)
			imgSkill:setAnchorPoint(0,0)
			local x = (imgSkillBg:getBoundingBox().width-imgSkill:getBoundingBox().width)/2
			local y = (imgSkillBg:getBoundingBox().height-imgSkill:getBoundingBox().height)/2
			imgSkill:setPosition(x, y)
			imgSkillBg:addChild(imgSkill)

			--技能名称
			local labSkillName = display.newTTFLabel({
		        text = "",
		        font = "Arial",
		        size = 24,
		        color = cc.c3b(0, 0, 0),
			})
		    labSkillName:setAnchorPoint(0.5,1)
		    imgSkillBg:addChild(labSkillName)
		   	labSkillName:setPosition(imgSkillBg:getBoundingBox().width/2,0)
		   	labSkillName:setString(info.name)
		   	index = index + 1
		   	if index == count then
		   		beginY = beginY - row*imgBg:getBoundingBox().height - 45
		   		break
		   	end
		end
	end

	return beginY
end

--创建援助部队
function WatchMailsView:createHelpArms(beginY,info)
	beginY = self:createTitleImg(beginY,Lan:lanText(103, "援助部队"))-10
	beginY = self:createLordInfo(beginY)
	beginY = self:createHeroInfo(beginY,info) + 10
	beginY = self:createArms(beginY,info)
	return beginY
end

--创建部队属性
function WatchMailsView:createArmsAttr(beginY,attrList)
	if attrList == nil or #attrList == 0 then
		return beginY
	end

	beginY = self:createTitleImg(beginY,Lan:lanText(105, "部队属性"))-40

	local count = #attrList
	for i=1,count do
		local info = attrList[i]
		--属性
		local labTitle = display.newTTFLabel({
	        text = "",
	        font = "Arial",
	        size = 26,
	        color = cc.c3b(0, 0, 0),
		})
	    labTitle:setAnchorPoint(0,0)
	    self.panContent:addChild(labTitle)
	    local y = beginY-(i-1)*40
	   	labTitle:setPosition(20,y)
	   	labTitle:setString(info.name)
	   	--加成
	   	local labValue = display.newTTFLabel({
	        text = "",
	        font = "Arial",
	        size = 26,
	        color = cc.c3b(0, 0, 0),
		})
	    labValue:setAnchorPoint(0,0)
	    self.panContent:addChild(labValue)
	   	labValue:setPosition(300,labTitle:getPositionY())
	   	labValue:setString("+" .. info.value .. "%")
	   	if i == count then
	   		beginY = y-60
	   	end
	end

	return beginY
end

--创建部队
function WatchMailsView:createArms(beginY,isHaveTitle,armsList)
	if armsList == nil or #armsList == 0 then
		return beginY
	end

	if isHaveTitle then
		beginY = self:createTitleImg(beginY,Lan:lanText(102, "部队"))-40
	end

	local count = #armsList
	for i=1,count do
		local info = armsList[i]
		--标题
		local labTitle = display.newTTFLabel({
	        text = "",
	        font = "Arial",
	        size = 26,
	        color = cc.c3b(0, 0, 0),
		})
	    labTitle:setAnchorPoint(0,0)
	    self.panContent:addChild(labTitle)
	    local y = beginY-(i-1)*40
	   	labTitle:setPosition(20,y)
	   	labTitle:setString(info.name)
	   	--兵力
		local labValue = display.newTTFLabel({
	        text = "",
	        font = "Arial",
	        size = 26,
	        color = cc.c3b(0, 0, 0),
		})
	    labValue:setAnchorPoint(0,0)
	    self.panContent:addChild(labValue)
	   	labValue:setPosition(300,labTitle:getPositionY())
	   	labValue:setString("" .. info.number)
	   	if i == count then
	   		beginY = y-60
	   	end
	end

	return beginY
end

--创建英雄信息
function WatchMailsView:createHeroInfo(beginY,isHaveTitle,heroList)
	if heroList == nil or #heroList == 0 then
		return beginY
	end

	if isHaveTitle then
		beginY = self:createTitleImg(beginY,Lan:lanText(101, "英雄"))-10
	end

	local count = #heroList
	for i=1,count do
		local info = heroList[i]
		local signHigh = 150
		--背景
	    local imgBg = display.newScale9Sprite("#mail_floor.png", 0, 0, cc.size(display.width,signHigh))
	    imgBg:setAnchorPoint(0,1)
	    self.panContent:addChild(imgBg)
	    local y = beginY - (i-1)*imgBg:getBoundingBox().height
	   	imgBg:setPosition(0,y)

		--英雄头像背景
		local imgHeadBg = display.newSprite("#propWin_itembox.png")
		imgHeadBg:setAnchorPoint(0,0)
		imgBg:addChild(imgHeadBg)
		local y = (imgBg:getBoundingBox().height-imgHeadBg:getBoundingBox().height)/2
		imgHeadBg:setPosition(10,y)

		--英雄头像
		local imgHead = MMUIHead:getInstance():getHeadById(info.img)
		imgHead:setAnchorPoint(0,0)
		imgHead:setScale(0.5)
		local y = (imgHeadBg:getBoundingBox().height-imgHead:getBoundingBox().height)/2
		local x = (imgHeadBg:getBoundingBox().width-imgHead:getBoundingBox().width)/2
		imgHead:setPosition(x,y)
		imgHeadBg:addChild(imgHead)

		--名字
	    local labName = display.newTTFLabel({
	        text = "",
	        font = "Arial",
	        size = 26,
	        color = cc.c3b(0, 0, 0),
	    })
	    labName:setAnchorPoint(0,0)
	    local x = imgHeadBg:getPositionX()+imgHeadBg:getBoundingBox().width + 60
	    local y = imgHeadBg:getPositionY()+imgHeadBg:getBoundingBox().height - 35
	    labName:setPosition(x, y)
	    imgBg:addChild(labName)
	    labName:setString(info.name)

	    --等级
	    local labLevel = display.newTTFLabel({
	        text = "",
	        font = "Arial",
	        size = 26,
	        color = cc.c3b(0, 0, 0),
	    })
	    labLevel:setAnchorPoint(0,0)
	    local x = labName:getPositionX()+220
	    local y = labName:getPositionY()
	    labLevel:setPosition(x, y)
	    imgBg:addChild(labLevel)
	    labLevel:setString(Lan:lanText(136, "英雄等级: LV{}", {info.level}))

	    --技能
	    local labSkill = display.newTTFLabel({
	        text = "",
	        font = "Arial",
	        size = 26,
	        color = cc.c3b(0, 0, 0),
	    })
	    labSkill:setAnchorPoint(0,0)
	    local x = labName:getPositionX()
	    local y = imgHeadBg:getPositionY() + 10
	    labSkill:setPosition(x, y)
	    imgBg:addChild(labSkill)
	    labSkill:setString(Lan:lanText(137, "技能: {}", {info.skillname}))

	    --战斗力
	    local labBattle = display.newTTFLabel({
	        text = "",
	        font = "Arial",
	        size = 26,
	        color = cc.c3b(0, 0, 0),
	    })
	    labBattle:setAnchorPoint(0,0)
	    local x = labLevel:getPositionX()
	    local y = labSkill:getPositionY()
	    labBattle:setPosition(x, y)
	    imgBg:addChild(labBattle)
	    labBattle:setString(Lan:lanText(74, "战斗力: {}", {info.fight}))

	   	if i == count then
	   		beginY = beginY - i*imgBg:getBoundingBox().height-55
	   	end
	end

    return beginY
end

--创建防御属性
function WatchMailsView:createDefAttr(beginY,info)
	if info == nil then
		return beginY
	end
	beginY = self:createTitleImg(beginY,Lan:lanText(99, "防御"))-40

	--城墙防御
	local labWall = display.newTTFLabel({
        text = "",
        font = "Arial",
        size = 26,
        color = cc.c3b(0, 0, 0),
	})
    labWall:setAnchorPoint(0,0)
    self.panContent:addChild(labWall)
   	labWall:setPosition(20,beginY)
   	labWall:setString(Lan:lanText(100, "城墙防御值"))
   	--城墙防御
	local labWallValue = display.newTTFLabel({
        text = "",
        font = "Arial",
        size = 26,
        color = cc.c3b(0, 0, 0),
	})
    labWallValue:setAnchorPoint(0,0)
    self.panContent:addChild(labWallValue)
   	labWallValue:setPosition(300,labWall:getPositionY())
   	labWallValue:setString("" .. info.wallVal .. "/" .. info.maxWallVal)
   	beginY = labWallValue:getPositionY() - 40

   	--陷井
   	local count = #info.arryTrap
   	for i=1,count do
   		local trapInfo = info.arryTrap[i]
   		local labTrap = display.newTTFLabel({
	        text = "",
	        font = "Arial",
	        size = 26,
	        color = cc.c3b(0, 0, 0),
		})
	    labTrap:setAnchorPoint(0,0)
	    self.panContent:addChild(labTrap)
	    local y = labWallValue:getPositionY()-i*40
	   	labTrap:setPosition(labWall:getPositionX(),y)
	   	labTrap:setString(trapInfo.name)

		local labTrapValue = display.newTTFLabel({
	        text = "",
	        font = "Arial",
	        size = 26,
	        color = cc.c3b(0, 0, 0),
		})
	    labTrapValue:setAnchorPoint(0,0)
	    self.panContent:addChild(labTrapValue)
	   	labTrapValue:setPosition(labWallValue:getPositionX(),labTrap:getPositionY())
	   	labTrapValue:setString("" .. trapInfo.number)
	   	if i == count then
	   		beginY = y - 40
	   	end
   	end
   	beginY = beginY - 20

   	return beginY
end

--创建分隔标题图片
function WatchMailsView:createTitleImg(beginY,strTitle)
	--分隔图片
    local imgReportTitle = display.newScale9Sprite("#mail_bg2.png", 0, 0, cc.size(display.width,50))
    imgReportTitle:setAnchorPoint(0,0)
    self.panContent:addChild(imgReportTitle)
    imgReportTitle:setPosition(0, beginY)

    --分隔标题
    local labTitle = display.newTTFLabel({
        text = "",
        font = "Arial",
        size = 28,
        color = cc.c3b(0, 0, 0),
    })
    labTitle:setString(strTitle)
    labTitle:setAnchorPoint(0.5,0)
    labTitle:setPosition(display.width/2, 10)
    imgReportTitle:addChild(labTitle)

    return imgReportTitle:getPositionY()
end

--创建领主信息
function WatchMailsView:createLordInfo(beginY,info)
	if info == nil then
		return beginY
	end

	local signHigh = 150
	--背景
    local imgBg = display.newScale9Sprite("#mail_floor.png", 0, 0, cc.size(display.width,signHigh))
    imgBg:setAnchorPoint(0,1)
    imgBg:setPosition(0,beginY)
    self.panContent:addChild(imgBg)

	--领主头像
	local imgHead = MMUIHead:getInstance():getMailLordHead(info.imgId)
	imgHead:setAnchorPoint(0,0)
	local y = (imgBg:getBoundingBox().height-imgHead:getBoundingBox().height)/2
	imgHead:setPosition(10,y)
	imgBg:addChild(imgHead)

	--领主名字
    local labName = display.newTTFLabel({
        text = "",
        font = "Arial",
        size = 26,
        color = cc.c3b(0, 0, 0),
    })
    labName:setAnchorPoint(0,0)
    local x = imgHead:getPositionX()+imgHead:getBoundingBox().width + 60
	local imgHead = MMUIHead:getInstance():getMailLordHead(1)
    local y = imgHead:getPositionY()+imgHead:getBoundingBox().height - 10
    labName:setPosition(x, y)
    imgBg:addChild(labName)
    labName:setString(info.name)

    --领主等级
    local labLevel = display.newTTFLabel({
        text = "",
        font = "Arial",
        size = 26,
        color = cc.c3b(0, 0, 0),
    })
    labLevel:setAnchorPoint(0,0)
    local x = labName:getPositionX()+220
    local y = labName:getPositionY()
    labLevel:setPosition(x, y)
    imgBg:addChild(labLevel)
    labLevel:setString(Lan:lanText(134, "领主等级: LV{}", {info.level}))

    --坐标
    local labPos = display.newTTFLabel({
        text = "",
        font = "Arial",
        size = 26,
        color = cc.c3b(0, 0, 0),
    })
    labPos:setAnchorPoint(0,0)
    local x = labName:getPositionX()
    local y = imgHead:getPositionY()+30
    labPos:setPosition(x, y)
    imgBg:addChild(labPos)
    labPos:setString("X:" .. info.x .. " Y:" .. info.y)

    --城堡等级
    local labCastleLevel = display.newTTFLabel({
        text = "",
        font = "Arial",
        size = 26,
        color = cc.c3b(0, 0, 0),
    })
    labCastleLevel:setAnchorPoint(0,0)
    local x = labLevel:getPositionX()
    local y = labPos:getPositionY()
    labCastleLevel:setPosition(x, y)
    imgBg:addChild(labCastleLevel)
    labCastleLevel:setString(Lan:lanText(135, "城堡等级: LV{}", {info.castleLv}))

    return beginY-imgBg:getBoundingBox().height
end

--更新侦察失败UI
function WatchMailsView:updateFailUI(data)
	--标题
	self.labTitle:setString(Lan:lanText(90, "侦查失败"))
	--时间
	self.labTime:setString("2011-30")
	--侦察简要内容
	self.labWatchContent:setString("111111")
	--大小
	local size = self.panContent:getContentSize()
	--创建领主信息
	local beginY = self:createLordInfo(size.height)
	self.beginY = beginY
end

--其它人侦查了你的城堡
function WatchMailsView:updateBeWatchUI(data)
	local info = data.reportInfo
	--标题
	self.labTitle:setString(Lan:lanText(139, "侦查报告"))
	--时间
	self.labTime:setString("" .. data.time)
	--侦察简要内容
	self.labWatchContent:setString(Lan:lanText(140, "你的城市被侦查"))
	--大小
	local size = self.panContent:getContentSize()
	--领主头像
	local imgHead = MMUIHead:getInstance():getMailLordHead(info.img)
	imgHead:setAnchorPoint(0,1)
	local x = (display.width-imgHead:getBoundingBox().width)/2
	local y = size.height-30
	imgHead:setPosition(x,y)
	self.panContent:addChild(imgHead)
	--领主名字
	local labName = display.newTTFLabel({
        text = "",
        font = "Arial",
        size = 26,
        color = cc.c3b(0, 0, 0),
    })
    labName:setAnchorPoint(0.5,1)
    local x = imgHead:getBoundingBox().width/2
    labName:setPosition(x,-5)
    imgHead:addChild(labName)
 	labName:setString(info.name)
   	--侦察内容
	local labContent = display.newTTFLabel({
        text = "",
        font = "Arial",
        size = 26,
        color = cc.c3b(0, 0, 0),
    })
    labContent:setAnchorPoint(0.5,1)
    local x = imgHead:getBoundingBox().width/2
    labContent:setPosition(x,-40)
    imgHead:addChild(labContent)
    labContent:setString(info.content)
    self.beginY = size.height
end




