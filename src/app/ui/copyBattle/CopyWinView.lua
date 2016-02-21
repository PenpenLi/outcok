
--[[
	jinyan.zhang
	副本战斗胜利界面
--]]

CopyWinView = class("CopyWinView",function()
	return display.newLayer()
end)

function CopyWinView:ctor(parent)
	self.parent = parent
	self:init()
end

function CopyWinView:init()
    self.view = Common:seekNodeByName(self.parent.root,"pan_win")
    --返回副本列表按钮
    self.btnClose = Common:seekNodeByName(self.view,"btn_close")
    self.btnClose:addTouchEventListener(handler(self,self.onClose))
    self.btnClose:setTitleText(Lan:lanText(122, "返回副本地图"))
    --英雄列表
    self.panHeroList = Common:seekNodeByName(self.view,"pan_herolist")
    --掉落物品列表背景
    self.imgDropGoodBg = Common:seekNodeByName(self.view,"img_goodsbg")
    --掉落标题
    self.labDropTitle = Common:seekNodeByName(self.imgDropGoodBg,"lab_title")
    self.labDropTitle:setString(Lan:lanText(123, "掉落物品"))
    --掉落物品列表
    self.listGoods = Common:seekNodeByName(self.imgDropGoodBg,"list_goods")
end

function CopyWinView:showView()
	self.view:setVisible(true)
end

function CopyWinView:updateUI()
    --创建掉落物品列表
    self:createDropItmes()

    self.uiAddExp = MMUIAddExp.new()
    self.view:addChild(self.uiAddExp)
    self.uiAddExp:setOldHeroList(CopyBattleModel:getInstance():getGoBattleHeros())
    self.uiAddExp:setNewHeroList(CopyBattleModel:getInstance():getAfterBattleHeros())
    local data = self.uiAddExp:calData()
    local addExp = CopyBattleModel:getInstance():getAddExp()

    --计算头像大小
    local scale = 0.8
    local imgHead = MMUIHead:getInstance():getHeadById(1)
    imgHead:setScale(scale)
    local imgHeadSize =imgHead:getBoundingBox()

	local count = #data
    local arryPos = self:calHeroPos(count,imgHeadSize)
    for i=1,count do
        local pos = arryPos[i]
        local info = data[i]
        local hero = info.hero
        --英雄头像
        local imgHead = MMUIHead:getInstance():getHead(hero)
        self.panHeroList:addChild(imgHead)
        imgHead:setScale(scale)
        imgHead:setPosition(pos)

        --英雄名字
        local labName = display.newTTFLabel({
            text = "",
            font = "Arial",
            size = 26,
            color = cc.c3b(255, 255, 255),
        })
        labName:setAnchorPoint(0.5,0)
        self.panHeroList:addChild(labName)
        local x = pos.x - imgHead:getBoundingBox().width/2 + 80
        local y =  pos.y - imgHead:getBoundingBox().height/2 + 6
        labName:setPosition(x,y)
        labName:setString(hero.name)

        --英雄等级
        local labLevel = display.newTTFLabel({
            text = "",
            font = "Arial",
            size = 26,
            color = cc.c3b(255, 255, 255),
        })
        labLevel:setAnchorPoint(0,0)
        self.panHeroList:addChild(labLevel)
        local x = pos.x - imgHead:getBoundingBox().width/2 + 6
        local y =  pos.y + imgHead:getBoundingBox().height/2 - 34
        labLevel:setPosition(x,y)
        labLevel:setString("lv" .. info.curLevel)

        local processBg,processBar,labProcess = MMUIProcess:getInstance():create("citybuilding/processbg.png",
            "citybuilding/process.png",self.panHeroList, info.curExp, info.curMaxExp,0.4)
        processBg:setPosition(pos.x,pos.y-imgHead:getBoundingBox().height/2-30)
        labProcess:setString("+" .. addExp .. "EXP")

        info.labLevel = labLevel
        info.processBar = processBar
    end
    self.uiAddExp:setData(data)
    self.uiAddExp:openTime()
end

--创建掉落物品列表
function CopyWinView:createDropItmes()
    self.listGoods:removeAllChildren()
    self.listGoods:setItemsMargin(50)
    local dropitems = CopyBattleModel:getInstance():getDropItems()
    for i=1,#dropitems do
        local info = dropitems[i]
        local node =  MMUISimpleUI:getInstance():getItmeById(info.itemId)
        node:setScale(0.6)
        local custom_item = ccui.Layout:create()
        custom_item:setContentSize(node:getBoundingBox())
        custom_item:addChild(node)
        self.listGoods:pushBackCustomItem(custom_item)
        node:setPosition(cc.p(custom_item:getBoundingBox().width/2.0, 0))

        --数量
        local labNumber = display.newTTFLabel({
            text = "",
            font = "Arial",
            size = 24,
            color = cc.c3b(255, 255, 255),
        })
        labNumber:setAnchorPoint(0.5,0)
        custom_item:addChild(labNumber)
        labNumber:setString("X" .. info.num)
        local x = node:getPositionX() + node:getBoundingBox().width/2
        local y = node:getPositionY()-30
        labNumber:setPosition(x,y)
    end
end

function CopyWinView:calHeroPos(count,imgHeadSize)
    local size = self.panHeroList:getBoundingBox()
    local arryPos = {}
    if count == 1 then
        local x = size.width/2
        local y = size.height/2
        local pos = cc.p(x,y)
        table.insert(arryPos,pos)
    elseif count == 2 then
        local beginX = (size.width-imgHeadSize.width*count)/2
        local endX = beginX + imgHeadSize.width+150
        local y = size.height/2
        local pos = cc.p(beginX,y)
        local endPos = cc.p(endX,y)
        table.insert(arryPos,pos)
        table.insert(arryPos,endPos)
    elseif count == 3 then
        local beginX = (size.width-imgHeadSize.width*count)/2-20
        local twoX = beginX + imgHeadSize.width+100
        local threeX = twoX + imgHeadSize.width+100
        local y = size.height/2
        local pos = cc.p(beginX,y)
        local twoPos = cc.p(twoX,y)
        local threePos = cc.p(threeX,y)
        table.insert(arryPos,pos)
        table.insert(arryPos,twoPos)
        table.insert(arryPos,threePos)
    elseif count == 4 then
        local beginX = (size.width-imgHeadSize.width*2)/2
        local beinY = (size.height - imgHeadSize.height)/2+250
        local endX = beginX + imgHeadSize.width+150
        local endY = beinY - imgHeadSize.height-150
        local pos = cc.p(beginX,beinY)
        local endPos = cc.p(endX,beinY)
        table.insert(arryPos,pos)
        table.insert(arryPos,endPos)
        local pos = cc.p(beginX,endY)
        local endPos = cc.p(endX,endY)
        table.insert(arryPos,pos)
        table.insert(arryPos,endPos)
    elseif count == 5 then
        local beginX = (size.width-imgHeadSize.width*count)/2+130
        local twoX = beginX + imgHeadSize.width+100
        local threeX = twoX + imgHeadSize.width+100
        local beinY = (size.height - imgHeadSize.height)/2+250
        local endY = beinY - imgHeadSize.height-150
        local pos = cc.p(beginX,beinY)
        local twoPos = cc.p(twoX,beinY)
        local threePos = cc.p(threeX,beinY)
        table.insert(arryPos,pos)
        table.insert(arryPos,twoPos)
        table.insert(arryPos,threePos)
        local beginX = (size.width-imgHeadSize.width*2)/2
        local endX = beginX + imgHeadSize.width+150
        local pos = cc.p(beginX,endY)
        local endPos = cc.p(endX,endY)
        table.insert(arryPos,pos)
        table.insert(arryPos,endPos)
    end

    return arryPos
end

--返回副本列表钮回调
--sender按钮本身
--eventType 事件类型
--返回值(无)
function CopyWinView:onClose(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        UIMgr:getInstance():closeUI(self.uiType)
        SceneMgr:getInstance():fromCopyGoToCity()
    end
end
