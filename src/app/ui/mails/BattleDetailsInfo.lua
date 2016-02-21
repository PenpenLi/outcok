
--[[
	战斗详情数据UI
	jinyan.zhang
--]]

BattleDetailsInfo = class("BattleDetailsInfo")

function BattleDetailsInfo:ctor(parent)
	self.parent = parent
	self:init()
end

function BattleDetailsInfo:init()
	self.view = Common:seekNodeByName(self.parent.root,"pan_battleDetails")
	--背景
	self.imgBg = Common:seekNodeByName(self.view,"imgbg")
	--标题
	self.labTitle = Common:seekNodeByName(self.imgBg,"lab_title")
	self.labTitle:setString(Lan:lanText(72, "战斗详情"))
	--滚动列表
	self.panScrollView = Common:seekNodeByName(self.imgBg,"scrollView_batDetails")
    self.clickAreaCheck = MMUIClickAreaCheck.new(self.imgBg,self.hide,self)
    self.view:addChild(self.clickAreaCheck)
end

--显示
function BattleDetailsInfo:show()
    self.view:setVisible(true)
    self.clickAreaCheck:setTouchEnabled(true)
end

--隐藏
function BattleDetailsInfo:hide()
    self.view:setVisible(false)
    self.clickAreaCheck:setTouchEnabled(false)
end

--更新UI
function BattleDetailsInfo:updateUI(data,atterName,deferName)
    self.panScrollView:removeAllChildren()

    self.data = data
    self.atterName = atterName
    self.deferName = deferName

    local scrollListSize = self.panScrollView:getContentSize()
    local newHigh = self:calScrollViewSize()
    local offsetY = newHigh - scrollListSize.height

    local y = scrollListSize.height+offsetY
	local beginY = self:createList(y-6,true)
    beginY = self:createList(beginY-30,false)
end

--计算滚动列表大小
function BattleDetailsInfo:calScrollViewSize()
    local totalHigh = 0

    local function calHigh(count)
        --标题背景
        local imgTitle = display.newSprite("#propWin_line.png",ccui.TextureResType.plistType)
        local high = imgTitle:getBoundingBox().height
        totalHigh = totalHigh + high

        --领主名称背景
        local imgNameBg = display.newSprite("#propWin_listtitle.png",ccui.TextureResType.plistType)
        high = imgNameBg:getBoundingBox().height
        totalHigh = totalHigh + high + 60

        --列表背景
        local imgBg = display.newSprite("#propWin_listbox.png",ccui.TextureResType.plistType)
        high = imgBg:getBoundingBox().height * count
        totalHigh = totalHigh + high
    end

    local deferCount = self.data.deferArmsCount
    local atterCount = self.data.atterArmsCount
    calHigh(atterCount)
    calHigh(deferCount)
    totalHigh = totalHigh

    local innerLayer = self.panScrollView:getInnerContainer()
    local oldSize = self.panScrollView:getContentSize()
    if totalHigh < oldSize.height then
        totalHigh = oldSize.height
    end
    innerLayer:setContentSize(cc.size(oldSize.width,totalHigh))
    self.panScrollView:jumpToTop()

    return totalHigh
end

--创建列表
function BattleDetailsInfo:createList(y,isAtter)
	local size = self.imgBg:getContentSize()
	--标题背景
	local imgTitle = display.newSprite("#propWin_line.png",ccui.TextureResType.plistType)
	imgTitle:setAnchorPoint(0.5,1)
	self.panScrollView:addChild(imgTitle)
	imgTitle:setPosition(size.width/2, y)

	--标题
	local labTitle = display.newTTFLabel({
        text = "",
        font = "Arial",
        size = 26,
        color = cc.c3b(0, 0, 0), 
    })
    imgTitle:addChild(labTitle)
    labTitle:setAnchorPoint(0.5,0)
    labTitle:setPosition(imgTitle:getContentSize().width/2, imgTitle:getContentSize().height/2-15)
    if isAtter then
        labTitle:setString(Lan:lanText(81, "进攻方"))
    else
        labTitle:setString(Lan:lanText(82, "防守方"))
    end

    local beginX = 20
    --领主名称背景
    local imgNameBg = display.newSprite("#propWin_listtitle.png",ccui.TextureResType.plistType)
    self.panScrollView:addChild(imgNameBg)
    imgNameBg:setAnchorPoint(0,1)
    imgNameBg:setPosition(beginX,imgTitle:getPositionY()-imgTitle:getContentSize().height/2-60)

    --领主名字
	local labName = display.newTTFLabel({
        text = "",
        font = "Arial",
        size = 26,
        color = cc.c3b(0, 0, 0), 
    })
    imgNameBg:addChild(labName)
    labName:setAnchorPoint(0,0)
    labName:setPosition(10, 10)
    if isAtter then
        labName:setString(self.atterName)
    else
        labName:setString(self.deferName) 
    end

    local beginY = imgNameBg:getPositionY() - imgNameBg:getContentSize().height
    if isAtter then
        --创建英雄列表
        beginY = self:createHeroList(beginX,beginY,self.data.atterHeros)
        --创建士兵列表
        beginY = self:createArmsList(beginX,beginY,self.data.atterArms)
    else
        --创建英雄列表
        beginY = self:createHeroList(beginX,beginY,self.data.deferHeros)
        --创建士兵列表
        beginY = self:createArmsList(beginX,beginY,self.data.deferArms)
        --创建陷井列表
        beginY = self:createArmsList(beginX,beginY,self.data.deferTraps)
        --创建防御塔列表
        beginY = self:createArmsList(beginX,beginY,self.data.deferTowers)
    end

    return beginY
end

--创建英雄列表
function BattleDetailsInfo:createHeroList(beginX,beginY,data)
    local outY = beginY
    local count = #data
    for i=1,count do
        local info = data[i]
        --背景
        local imgBg = display.newSprite("#propWin_listbox.png",ccui.TextureResType.plistType)
        self.panScrollView:addChild(imgBg)
        imgBg:setAnchorPoint(0,1)
        local y = beginY - (i-1)*imgBg:getContentSize().height
        imgBg:setPosition(beginX, y)

        outY = y
        if i == count then
            outY = outY - imgBg:getBoundingBox().height
        end

        --头像
        local imgHead = MMUIHead:getInstance():getHeadByHeadId(info.img,info.quality)
        local imgHead = MMUIHead:getInstance():getHeadByHeadId("hero1001",1)

        imgBg:addChild(imgHead)
        imgHead:setScale(0.5)
        local x = imgHead:getBoundingBox().width/2 + 10
        local y = imgHead:getBoundingBox().height/2 + 
        (imgBg:getBoundingBox().height - imgHead:getBoundingBox().height)/2
        imgHead:setPosition(x, y)

        --英雄名称
        local labName = display.newTTFLabel({
            text = "",
            font = "Arial",
            size = 26,
            color = cc.c3b(0, 0, 0), 
        })
        imgBg:addChild(labName)
        labName:setAnchorPoint(0,0)
        labName:setPosition(x+imgHead:getBoundingBox().width-10, y+imgHead:getBoundingBox().height/2-30)
        labName:setString(info.name)

        --击杀
        local labKill = display.newTTFLabel({
            text = "",
            font = "Arial",
            size = 26,
            color = cc.c3b(0, 0, 0), 
        })
        imgBg:addChild(labKill)
        labKill:setAnchorPoint(0,0)
        labKill:setPosition(labName:getPositionX()+200, labName:getPositionY())
        labKill:setString(Lan:lanText(73, "击杀: {}", {info.kill}))

        --hp
        local labHp = display.newTTFLabel({
            text = "",
            font = "Arial",
            size = 28,
            color = cc.c3b(0, 0, 0), 
        })
        imgBg:addChild(labHp)
        labHp:setAnchorPoint(0,0)
        labHp:setPosition(labName:getPositionX(),imgHead:getPositionY()-imgHead:getBoundingBox().height/2+10)
        labHp:setString("hp")

        --血条
        local processBg = MMUIProcess:getInstance():create("citybuilding/processbg.png","citybuilding/process.png",
            imgBg, info.hp, info.maxHp,0.9,false)
        processBg:setPosition(labHp:getPositionX()+processBg:getBoundingBox().width/2+40,labHp:getPositionY()+10)
    end

    return outY
end

--创建部队列表
function BattleDetailsInfo:createArmsList(beginX,beginY,data)
    local outY = beginY
    local count = #data
    for i=1,count do
        local info = data[i]
         --背景
        local imgBg = display.newSprite("#propWin_listbox.png",ccui.TextureResType.plistType)
        self.panScrollView:addChild(imgBg)
        imgBg:setAnchorPoint(0,1)
        local y = beginY - (i-1)*imgBg:getContentSize().height
        imgBg:setPosition(beginX, y)

        outY = y
        if i == count then
            outY = outY - imgBg:getBoundingBox().height
        end

        --头像背景
        local imgHead = display.newSprite("#propWin_itembox.png")
        imgBg:addChild(imgHead)
        local x = imgHead:getBoundingBox().width/2 + 10
        local y = imgHead:getBoundingBox().height/2 + 
        (imgBg:getBoundingBox().height - imgHead:getBoundingBox().height)/2
        imgHead:setPosition(x, y)

        local imgIcon = display.newSprite(info.img)
        imgIcon:setAnchorPoint(0.5,0.5)
        imgHead:addChild(imgIcon)
        local x1 = (imgHead:getBoundingBox().width-imgIcon:getBoundingBox().width)/2+imgIcon:getBoundingBox().width/2
        local y1 = (imgHead:getBoundingBox().height-imgIcon:getBoundingBox().height)/2+imgIcon:getBoundingBox().height/2
        imgIcon:setPosition(x1, y1)
        imgIcon:setScale(info.imgScale)

        --存活
        local labLive = display.newTTFLabel({
            text = "",
            font = "Arial",
            size = 26,
            color = cc.c3b(0, 0, 0), 
        })
        imgBg:addChild(labLive)
        labLive:setAnchorPoint(0,0)
        labLive:setPosition(x+imgHead:getBoundingBox().width-10, y+imgHead:getBoundingBox().height/2-40)
        labLive:setString(Lan:lanText(83, "存活: {}", {info.live}))

        --损失
        local labLose = display.newTTFLabel({
            text = "",
            font = "Arial",
            size = 26,
            color = cc.c3b(0, 0, 0), 
        })
        imgBg:addChild(labLose)
        labLose:setAnchorPoint(0,0)
        labLose:setPosition(labLive:getPositionX()+200, labLive:getPositionY())
        labLose:setString(Lan:lanText(84, "损失: {}", {info.lose}))

        --击杀
        local labKill = display.newTTFLabel({
            text = "",
            font = "Arial",
            size = 28,
            color = cc.c3b(0, 0, 0), 
        })
        imgBg:addChild(labKill)
        labKill:setAnchorPoint(0,0)
        labKill:setPosition(labLive:getPositionX(),imgHead:getPositionY()-imgHead:getBoundingBox().height/2+10)
        labKill:setString(Lan:lanText(85, "击杀: {}", {info.kill}))

        --受伤
        local labHurt = display.newTTFLabel({
            text = "",
            font = "Arial",
            size = 26,
            color = cc.c3b(0, 0, 0), 
        })
        imgBg:addChild(labHurt)
        labHurt:setAnchorPoint(0,0)
        labHurt:setPosition(labKill:getPositionX()+200, labKill:getPositionY())
        labHurt:setString(Lan:lanText(86, "受伤: {}", {info.hurt}))
    end

    return outY
end






