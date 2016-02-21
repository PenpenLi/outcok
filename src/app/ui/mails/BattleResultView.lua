
--[[
	jinyan.zhang
	战斗结果
--]]

BattleResultView = class("BattleResultView")

function BattleResultView:ctor(parent)
	self.parent = parent
	self:init()
end

function BattleResultView:init()
   	self.view = Common:seekNodeByName(self.parent.root,"pan_battleReport")

 	--关闭按钮
	self.btnClose = Common:seekNodeByName(self.view,"btn_close")
    self.btnClose:addTouchEventListener(handler(self,self.onClose))

    --标题
    self.labTitle = Common:seekNodeByName(self.view,"lab_title")
    self.labTitle:setString("--")

    --攻击
    self.labAttContent = Common:seekNodeByName(self.view,"lab_attcontent")
    self.labAttContent:setString("--")

    --战斗地点
    self.labPos = Common:seekNodeByName(self.view,"lab_warPos")
    self.labPos:setString("--")

    --时间
    self.labTime = Common:seekNodeByName(self.view,"lab_time")
    self.labTime:setString("--")

    --滚动层
    self.panListView = Common:seekNodeByName(self.view,"scrollpan_list")

    --滚动列表上的内容层
    self.panContent = Common:seekNodeByName(self.panListView,"pan_list")
end

--显示
function BattleResultView:show()
	self.view:setVisible(true)
end

--隐藏
function BattleResultView:hide()
	self.view:setVisible(false)
    self.panContent:removeAllChildren()
    self.parent:onBattleReport()
end

--计算滚动列表大小
function BattleResultView:calScrollViewSize()
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

--关闭按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function BattleResultView:onClose(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
    	self:hide()
    end
end

--更新UI
function BattleResultView:updateUI(data)
	self.panContent:removeAllChildren()

    local reportInfo = data.reportInfo        --战斗报告数据
    local atterInfo = reportInfo.atterInfo    --攻方数据
    local deferInfo = reportInfo.deferInfo    --防守方数据
    local battleResInfo = data.battleResInfo  --战斗结果数据

    self.data = data
    --战斗数据
    self.battleData = data.battle  
    --战斗成员数据           
    self.battleMemInfo = data.battleMemInfo
    --攻击方领主名称
    self.atterName = atterInfo.name
    --防守方领主名称
    self.deferName = deferInfo.name

    --标题
    self.labTitle:setString(battleResInfo.title)
    --战斗地点
    self.labPos:setString(Lan:lanText(80, "战斗发生在(X:{} Y:{})", {atterInfo.x,atterInfo.y}))
    --时间
    self.labTime:setString("" .. data.time)
    --攻击内容
    self.labAttContent:setString(battleResInfo.attContent)

	local iconHigh = 150
	local size = self.panContent:getContentSize()

    local iconPath = ""
    if battleResInfo.isWin then
        iconPath = "#Mail_zhaying_succeed.png"
    else
        iconPath = "#Mail_gongcheng_Failure.png"
    end

    --成功/失败图片
	local imgIcon = display.newScale9Sprite("#Mail_gongcheng_Failure.png", 0, 0, cc.size(display.width,iconHigh))
	imgIcon:setAnchorPoint(0,1)
	imgIcon:setPosition(0, size.height)
	self.panContent:addChild(imgIcon)

	  --分隔图片
    local imgReportTitle = display.newScale9Sprite("#mail_bg2.png", 0, 0, cc.size(display.width,50))
    imgReportTitle:setAnchorPoint(0,0)
    self.panContent:addChild(imgReportTitle)
    local y = imgIcon:getPositionY() - 80 - imgIcon:getBoundingBox().height
    imgReportTitle:setPosition(0, y)

    --分隔标题
    local labTitle = display.newTTFLabel({
        text = "",
        font = "Arial",
        size = 28,
        color = cc.c3b(0, 0, 0),
    })
    labTitle:setString(Lan:lanText(54, "资源"))
    labTitle:setAnchorPoint(0.5,0)
    labTitle:setPosition(display.width/2, 10)
    imgReportTitle:addChild(labTitle)

    --获取消耗大于0的资源
    local function getCastResArry(arryCast)
        local arryCastRes = {}
        for i=1,#arryCast do
            local info = arryCast[i]
            if info.value > 0 then
                table.insert(arryCastRes,info)
            end
        end
        return arryCastRes
    end

    local arryCast = {}
    arryCast[1] = {name=Lan:lanText(62, "粮食"),value=reportInfo.grain}
    arryCast[2] = {name=Lan:lanText(63, "木材"),value=reportInfo.wood}
    arryCast[3] = {name=Lan:lanText(64, "铁矿"),value=reportInfo.iron}
    arryCast[4] = {name=Lan:lanText(65, "秘银"),value=reportInfo.mithril}
    local arryCastRes = getCastResArry(arryCast)
    local count = #arryCastRes

    --资源消耗
    local beginY = imgReportTitle:getPositionY() - imgReportTitle:getContentSize().height - 30
    for i=1,count do
    	local labResource = display.newTTFLabel({
	        text = "",
	        font = "Arial",
	        size = 26,
	        color = cc.c3b(0, 0, 0),
    	})
	    labResource:setAnchorPoint(0,0)
	    self.panContent:addChild(labResource)
	    local y = beginY - (i-1)*50
	   	labResource:setPosition(40,y)
	   	labResource:setString(arryCastRes[i].name)
        --资源消耗
        local labCast = display.newTTFLabel({
            text = "",
            font = "Arial",
            size = 26,
            color = cc.c3b(0, 0, 0),
        })
        labCast:setAnchorPoint(0,0)
        labCast:setPosition(400,y)
        labCast:setString("" .. arryCastRes[i].value)
        self.panContent:addChild(labCast)
    end

    --创建属性面板
    -- if count <= 0 then
    --     count = 1
    -- end
    local y = beginY - (count-1)*50 - 30
    local bgWide = 350
    local bgHigh = 350
    local imgLeftBg = display.newScale9Sprite("#mail_bg2.png", 0, 0, cc.size(bgWide,bgHigh))
    imgLeftBg:setAnchorPoint(0,1)
   	self.panContent:addChild(imgLeftBg)
   	imgLeftBg:setPosition(4,y)
   	self:createAttr(imgLeftBg,atterInfo)

   	local imgRightBg = display.newScale9Sprite("#mail_bg2.png", 0, 0, cc.size(bgWide,bgHigh))
    imgRightBg:setAnchorPoint(0,1)
   	self.panContent:addChild(imgRightBg)
   	imgRightBg:setPosition(bgWide+40,y)
   	self:createAttr(imgRightBg,deferInfo)

    --创建部队属性
    -- local leftArmsBg = self:createArmsAttr(6,bgWide,imgLeftBg:getPositionX(),y-bgHigh-30)
    -- local rightArmsBg = self:createArmsAttr(1,bgWide,imgRightBg:getPositionX(),y-bgHigh-30)

    -- local maxHigh = 0
    -- if leftArmsBg ~= nil then
    --     maxHigh = leftArmsBg:getContentSize().height
    --     y = leftArmsBg:getPositionY()
    -- end
    -- if rightArmsBg ~= nil then
    --     local high = rightArmsBg:getContentSize().height
    --     if high > maxHigh then
    --         maxHigh = high
    --         y = rightArmsBg:getPositionY()
    --     end
    -- end
    -- local btnY = y-maxHigh-30

    local btnY = y-bgHigh-30

    --详情按钮
    local btnDetails = ccui.Button:create("btn_blue.png","","",ccui.TextureResType.plistType)
    btnDetails:setAnchorPoint(0,1)
    btnDetails:setTouchEnabled(true)
    self.panContent:addChild(btnDetails)
    btnDetails:setPosition(100, btnY)
    btnDetails:addTouchEventListener(handler(self,self.onDetails))
    btnDetails:setTitleText(Lan:lanText(66, "详细数据"))
    btnDetails:setTitleFontSize(28)

    --战斗动画按钮
    local btnBattle = ccui.Button:create("btn_blue.png","","",ccui.TextureResType.plistType)
    btnBattle:setAnchorPoint(0,1)
    btnBattle:setTouchEnabled(true)
    self.panContent:addChild(btnBattle)
    btnBattle:setPosition(400, btnY)
    btnBattle:addTouchEventListener(handler(self,self.onBattle))
    btnBattle:setTitleText(Lan:lanText(67, "战斗动画"))
    btnBattle:setTitleFontSize(28)
    self.beginY = btnBattle:getPositionY() - btnBattle:getBoundingBox().height

    self:calScrollViewSize()
end

--战斗详情按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function BattleResultView:onDetails(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        print("战斗详情")
        self.parent.battleDetailsInfo:show()
        self.parent.battleDetailsInfo:updateUI(self.battleMemInfo,self.atterName,self.deferName)
    end
end

--战斗动画按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function BattleResultView:onBattle(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        print("战斗动画")
        MailsModel:getInstance():setLastOpenMailDetailsData(self.data)
        BattleData:getInstance():goToBattle(self.battleData)
    end
end

--创建属性
function BattleResultView:createAttr(parent,data)
	local size = parent:getContentSize()
	--名称
	local labName = display.newTTFLabel({
	        text = "",
	        font = "Arial",
	        size = 28,
	        color = cc.c3b(0, 0, 0),
    	})
    labName:setAnchorPoint(0.5,1)
    parent:addChild(labName)
   	labName:setPosition(size.width/2,size.height+35)
   	labName:setString(data.name)

   	--头像
   	local imgHead = MMUIHead:getInstance():getHeadByHeadId("hero1001",1)
   	imgHead:setScale(0.5)
   	parent:addChild(imgHead)
   	imgHead:setPosition(imgHead:getBoundingBox().width/2+10, size.height-imgHead:getBoundingBox().height/2-10)

   	--坐标
   	local labPos = display.newTTFLabel({
        text = "",
        font = "Arial",
        size = 26,
        color = cc.c3b(0, 0, 0),
    })
    labPos:setAnchorPoint(0,0)
    parent:addChild(labPos)
    labPos:setPosition(imgHead:getPositionX()+imgHead:getBoundingBox().width/2+10, 
    	imgHead:getPositionY()+10)
    labPos:setString("x:" .. data.x .. " y:" .. data.y)

    --战斗力
   	local labBattle = display.newTTFLabel({
        text = "",
        font = "Arial",
        size = 26,
        color = cc.c3b(0, 0, 0),
    })
    labBattle:setAnchorPoint(0,0)
    parent:addChild(labBattle)
    labBattle:setPosition(labPos:getPositionX(), 
    	labPos:getPositionY()-50)
    if data.minusFightForce == 0 then
        labBattle:setString(Lan:lanText(75, "战斗力:无损失",{}))
    else
        labBattle:setString(Lan:lanText(74, "战斗力:{}",{data.minusFightForce}))
    end

    local arryAttr = {}
    arryAttr[1] = {name=Lan:lanText(57, "消灭"),lose=data.kill}
    arryAttr[2] = {name=Lan:lanText(59, "损失"),lose=data.loss}
    arryAttr[3] = {name=Lan:lanText(61, "受伤"),lose=data.hurt}
    arryAttr[4] = {name=Lan:lanText(58, "存活"),lose=data.live}
    arryAttr[5] = {name=Lan:lanText(60, "陷井损失"),lose=data.lsTrap}

    --属性
    local beginY = imgHead:getPositionY()-imgHead:getBoundingBox().height/2-30
    for i=1,5 do
    	local labHurt = display.newTTFLabel({
	        text = "",
	        font = "Arial",
	        size = 26,
	        color = cc.c3b(0, 0, 0),
    	})
	    labHurt:setAnchorPoint(0,0)
	    parent:addChild(labHurt)
	    local y = beginY - (i-1)*40
	    labHurt:setPosition(20,y)
	    labHurt:setString(arryAttr[i].name)
        --损失
        local lablose = display.newTTFLabel({
            text = "",
            font = "Arial",
            size = 26,
            color = cc.c3b(0, 0, 0),
        })
        lablose:setAnchorPoint(0,0)
        parent:addChild(lablose)
        lablose:setPosition(200,y)
        lablose:setString("" .. arryAttr[i].lose)
	end
end

--创建部队属性
function BattleResultView:createArmsAttr(count,bgWide,x,y,attrList)
    local bgHigh = count*40+45
    --背景
    local imgBg = display.newScale9Sprite("#mail_bg2.png", 0, 0, cc.size(bgWide,bgHigh))
    imgBg:setAnchorPoint(0,1)
    self.panContent:addChild(imgBg)
    imgBg:setPosition(x,y)

    --标题
    local labTitle = display.newTTFLabel({
            text = "",
            font = "Arial",
            size = 26,
            color = cc.c3b(0, 0, 0),
        })
    labTitle:setAnchorPoint(0.5,1)
    imgBg:addChild(labTitle)
    labTitle:setPosition(bgWide/2,bgHigh-4)
    labTitle:setString(Lan:lanText(68, "部队属性"))

    --部队属性
    local beginY = labTitle:getPositionY() - 70
    for i=1,count do
        --属性
        local labAttr = display.newTTFLabel({
            text = "",
            font = "Arial",
            size = 26,
            color = cc.c3b(0, 0, 0),
        })
        labAttr:setAnchorPoint(0,0)
        imgBg:addChild(labAttr)
        local y = beginY - (i-1)*40
        labAttr:setPosition(20,y)
        labAttr:setString("abc")
        --属性值
        local labValue = display.newTTFLabel({
            text = "",
            font = "Arial",
            size = 26,
            color = cc.c3b(0, 0, 0),
        })
        labValue:setAnchorPoint(0,0)
        imgBg:addChild(labValue)
        labValue:setPosition(200,y)
        labValue:setString("+" .. "1%")
    end

    return imgBg
end







