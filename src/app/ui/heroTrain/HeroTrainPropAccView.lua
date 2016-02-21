
--[[
    hejun
    使用道具加速训练
--]]

HeroTrainPropAccView = class("HeroTrainPropAccView")

--构造
--parent 父结点UI
function HeroTrainPropAccView:ctor(parent,action)
    self.parent = parent
    self.propPan = Common:seekNodeByName(self.parent.root,"panelProp")
    self:init()
end

--初始化
function HeroTrainPropAccView:init()
    self.items = {}
    --标题
    self.titleLab = Common:seekNodeByName(self.propPan,"titleLab")
    self.titleLab:setString(CommonStr.BUILD_SPEED)
    --时间
    self.timeLab = Common:seekNodeByName(self.propPan,"timeLab")
    --进度条
    self.processBar = Common:seekNodeByName(self.propPan,"ProgressBar_7")
    --标题2
    self.title2Lab = Common:seekNodeByName(self.propPan,"title2Lab")
    self.title2Lab:setString(CommonStr.SELECT_SPEED_PROP)

    --向前翻页按钮
    self.forWardBtn = Common:seekNodeByName(self.propPan,"leftBtn")
    self.forWardBtn:addTouchEventListener(handler(self,self.forWardBtnCallBack))

    --向后翻页按钮
    self.backwardBtn = Common:seekNodeByName(self.propPan,"rightBtn")
    self.backwardBtn:addTouchEventListener(handler(self,self.backwardBtnCallBack))

    --数量
    self.numLab = Common:seekNodeByName(self.propPan,"numLab")
    self.numLab:setString(CommonStr.NUM .. ": " .. 0)
    --滑动条
    self.slider = Common:seekNodeByName(self.propPan,"sliderBar")
    self.slider:addEventListener(handler(self,self.changeNumCallback))

    --减少按钮
    self.minusBtn = Common:seekNodeByName(self.propPan,"minusBtn")
    self.minusBtn:addTouchEventListener(handler(self,self.minusBtnCallBack))
    --增加按钮
    self.plusBtn = Common:seekNodeByName(self.propPan,"plusBtn")
    self.plusBtn:addTouchEventListener(handler(self,self.plusBtnCallBack))

    --关闭按钮
    self.closeBtn = Common:seekNodeByName(self.propPan,"closeBtn")
    self.closeBtn:addTouchEventListener(handler(self,self.closeBtnCallBack))

    --加速时间
    self.speedTimeLab = Common:seekNodeByName(self.propPan,"speedTimeLab")
    self.speedTimeLab:setString(CommonStr.SPEED_TIME .. ": " .. 0)

    --加速按钮
    self.speedBtn = Common:seekNodeByName(self.propPan,"speedBtn")
    self.speedBtn:addTouchEventListener(handler(self,self.accelerationBtnCallBack))
    self.speedBtn:setTouchEnabled(false)

    --翻页层
    self.pageView = Common:seekNodeByName(self.propPan,"pageView")


end

--更新UI
function HeroTrainPropAccView:updateUI()
    local leftTime = self.parent.curSelHero:getTrainTime()
    self.timeLab:setString(CommonStr.SPEED_TIME .. ": " .. Common:getFormatTime(leftTime))
    self.needTime = leftTime
    local per = (self.needTime-leftTime)/self.needTime*100
    self.processBar:setPercent(per)

    TimeMgr:getInstance():createTime(leftTime,self.updateTime,self,nil,1001)

    --获取加速道具
    local total = 0
    self.items = {}
    local itemlist = ItemData:getInstance():getQuickItemList()
    for k,v in pairs(itemlist) do
        if v.speedType == ItemSpeedType.heroTrain or v.speedType == ItemSpeedType.all then
            table.insert(self.items,v)
            total = total + v.number
        end
    end

    if total == 0 then
        self.slider:setTouchEnabled(false)
        self.plusBtn:setTouchEnabled(false)
        self.minusBtn:setTouchEnabled(false)
        self.forWardBtn:setTouchEnabled(false)
        self.backwardBtn:setTouchEnabled(false)
    else
        self:selItmeByIndex(1)
    end

    self:createPropList()
end

--改变数量回调
function HeroTrainPropAccView:changeNumCallback(sender,event)
    local curNum = sender:getPercent()/100*self.itemCount
    self.curNum = math.floor(curNum)
    self:updateNum()
end

--更新数量
function HeroTrainPropAccView:updateNum()
    self.numLab:setString(CommonStr.NUM .. ": " .. self.curNum)
    local time = self.itemData.speedTime*self.curNum
    self.speedTimeLab:setString(CommonStr.SPEED_TIME .. ": " .. time)
    local per = self.curNum/self.itemCount*100
    self.slider:setPercent(per)
    if self.curNum == 0 then
        self.speedBtn:setTouchEnabled(false)
    else
        self.speedBtn:setTouchEnabled(true)
    end
end

--减少按钮回调
--sender 按钮本身
--eventType 事件类型
function HeroTrainPropAccView:minusBtnCallBack(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self.curNum = self.curNum - 1
        if self.curNum < 0 then
            self.curNum = 0
        end
        self:updateNum()
    end
end

--增加按钮回调
--sender 按钮本身
--eventType 事件类型
function HeroTrainPropAccView:plusBtnCallBack(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self.curNum = self.curNum + 1
        if self.curNum > self.itemCount then
            self.curNum = self.itemCount
        end
        self:updateNum()
    end
end

--创建道具列表
function HeroTrainPropAccView:createPropList()
    local wide = 500
    local high = 200
     self.propList = cc.ui.UIPageView.new {
        bgColor = cc.c4b(255, 0, 0, 255),
        viewRect = cc.rect(0, 0, wide, high),
        column = 3, row = 1,
        padding = {left = 0, right = 0, top = 0, bottom = 0},
        columnSpace = 10, rowSpace = 0}
        :addTo(self.pageView)
    self.pageView:setTouchEnabled(false)
    self.propList:setTouchEnabled(false)

    -- add items
    for k,v in pairs(self.items) do
        local item = self.propList:newItem()
        local content = cc.LayerColor:create(
            cc.c4b(math.random(250),
                math.random(250),
                math.random(250),
                128))
        content:setContentSize(wide/3, high)
        content:setTouchEnabled(false)
        item:addChild(content)
        self.propList:addItem(item)

        local spr = cc.ui.UIPushButton.new("test/cityAddBtn.png")
        content:addChild(spr)
        spr:setPosition(80, 100)
        spr:setTag(k)
        spr:setTouchEnabled(true)
        spr:onButtonClicked(function(event)
            print("clck.......")
            self:itemBtnCallBack(spr)
        end)

        local numLab = display.newTTFLabel({
            text = "" .. v.number,
            font = "Arial",
            size = 24,
            color = cc.c3b(255, 0, 0), -- 使用纯红色
            align = cc.TEXT_ALIGNMENT_LEFT,
        })
        numLab:setPosition(120,20)
        content:addChild(numLab)
    end
    self.propList:reload()
end

--选中道具回调
--sender 按钮本身
--eventType 事件类型
function HeroTrainPropAccView:itemBtnCallBack(sender)
    local index = sender:getTag()
    self:selItmeByIndex(index)
end

--选择物品
function HeroTrainPropAccView:selItmeByIndex(index)
    local itemData = self.items[index]
    self.itemData = itemData
    self.itemCount = itemData.number
    local leftTime = self.parent.curSelHero:getTrainTime()
    self.curNum = leftTime/itemData.speedTime
    self.curNum = math.ceil(self.curNum)
    self:updateNum()
end

--向前翻页按钮回调
--sender 按钮本身
--eventType 事件类型
function HeroTrainPropAccView:forWardBtnCallBack(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        local totalPage = self.propList:getPageCount()
        local curPage = self.propList:getCurPageIdx()
        curPage  = curPage - 1
        if curPage  < 0 then
            curPage = 1
        end
        self.propList:gotoPage(curPage)
    end
end

--向后翻页按钮回调
--sender 按钮本身
--eventType 事件类型
function HeroTrainPropAccView:backwardBtnCallBack(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        local totalPage = self.propList:getPageCount()
        local curPage = self.propList:getCurPageIdx()
        curPage  = curPage + 1
        if curPage > totalPage then
            curPage = totalPage
        end
        self.propList:gotoPage(curPage)
    end
end

--更新时间
--info 数据
--返回值(无)
function HeroTrainPropAccView:updateTime(info)
    if info.time <= 0 then
        info.time = 0
        TimeMgr:getInstance():removeInfo(TimeType.COMMON,1001)
        UIMgr:getInstance():closeUI(self.parent.uiType)
        UIMgr:getInstance():closeUI(UITYPE.BUILDING_MENU)
        UIMgr:getInstance():closeUI(UITYPE.PROP_BOX)
        return
    end
    self.timeLab:setString(CommonStr.SPEED_TIME .. ": " .. Common:getFormatTime(info.time))
    local per = (self.needTime-info.time)/self.needTime*100
    self.processBar:setPercent(per)
end

--加速按钮回调
--sender 按钮本身
--eventType 事件类型
function HeroTrainPropAccView:accelerationBtnCallBack(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        local leftTime = self.parent.curSelHero:getTrainTime()
        if self.itemData.speedTime*self.curNum > leftTime then
            UIMgr:getInstance():openUI(UITYPE.PROP_BOX, {type=PROP_BOX_TYPE.COMMON,text=CommonStr.ACCE_TIME_OVER_BUILD_TIME,
            callback=handler(self, self.sendAcceReq),sureBtnText=CommonStr.SURE,cancelBtnText=CommonStr.CANCEL,buildingPos=pos
            })
            return
        end
        self:sendAcceReq()
    end
end

--发送加速请求
function HeroTrainPropAccView:sendAcceReq()
    HeroTrainService:getInstance():sendPropTrainHero(self.itemData.templateId,self.itemData.objId,self.curNum,self.parent.curSelHero.heroid)
end

--关闭按钮回调
--sender 按钮本身
--eventType 事件类型
function HeroTrainPropAccView:closeBtnCallBack(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self:hideView()
        self.parent.heroTrainDetails:showView()
        TimeMgr:getInstance():removeInfo(TimeType.COMMON,1001)
    end
end

-- 显示界面
function HeroTrainPropAccView:showView()
    self.propPan:setVisible(true)
    self:updateUI()
end

-- 隐藏界面
function HeroTrainPropAccView:hideView()
    self.propPan:setVisible(false)
end