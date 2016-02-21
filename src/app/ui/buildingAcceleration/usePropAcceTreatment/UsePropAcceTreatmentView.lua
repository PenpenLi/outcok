
--[[
    jinyan.zhang
    使用道具加速治疗
--]]

UsePropAcceTreatmentView = class("UsePropAcceTreatmentView")

--构造
--parent 父结点UI
function UsePropAcceTreatmentView:ctor(parent)
    self.parent = parent
    self.action = action
    self.items = {}
    self:init()
end

--初始化
function UsePropAcceTreatmentView:init()
    self.propPan = Common:seekNodeByName(self.parent.root,"propPan")
    self.propPan:setVisible(true)
    self.parent.pan1:setVisible(false)
    self.propPan:setTouchEnabled(false)

    --标题
    self.titleLab = Common:seekNodeByName(self.propPan,"titleLab")
    self.titleLab:setString(CommonStr.ACCELERATED_TREATMENT)
    --时间
    self.timeLab = Common:seekNodeByName(self.propPan,"timeLab")
    --进度条
    self.processBar = Common:seekNodeByName(self.propPan,"processBar")
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
    self.speedBtn:setTitleText(CommonStr.ACC_SPEED)

    --翻页层
    self.pageView = Common:seekNodeByName(self.propPan,"pageView")

    local timeInfo = TimeInfoData:getInstance():getTimeInfoByType(BuildType.firstAidTent)
    if timeInfo == nil then
        Prop:getInstance():showMsg(CommonStr.NO_NEED_SPEED_TREATMENT)
        return
    end

    local leftTime = CityBuildingModel:getInstance():getLeftUpBuildingTime(timeInfo.start_time,timeInfo.interval)
    self.timeLab:setString(CommonStr.MAKE_SOLDIER_TIME .. ": " .. Common:getFormatTime(leftTime))
    self.needTime = timeInfo.interval
    local per = (self.needTime-leftTime)/self.needTime*100
    self.processBar:setPercent(per)

    local timeInfo = TimeMgr:getInstance():findTypeInfoByIndex(TimeType.COMMON,1,1)
    if not timeInfo then
        local info = {}
        info.index = 1
        info.leftTime = leftTime
        TimeMgr:getInstance():addInfo(TimeType.COMMON, info, 1,self.updateTime, self)
    else
        timeInfo.pause = false
        timeInfo.leftTime = leftTime
    end

    --获取加速道具
    local total = 0
    local itemlist = ItemData:getInstance():getQuickItemList()
    for k,v in pairs(itemlist) do
        if v.speedType == ItemSpeedType.treatment or v.speedType == ItemSpeedType.all then
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
function UsePropAcceTreatmentView:changeNumCallback(sender,event)
    local curNum = sender:getPercent()/100*self.itemCount
    self.curNum = math.floor(curNum)
    self:updateNum()
end

--更新数量
function UsePropAcceTreatmentView:updateNum()
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
function UsePropAcceTreatmentView:minusBtnCallBack(sender,eventType)
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
function UsePropAcceTreatmentView:plusBtnCallBack(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self.curNum = self.curNum + 1
        if self.curNum > self.itemCount then
            self.curNum = self.itemCount
        end
        self:updateNum()
    end
end

--创建道具列表
function UsePropAcceTreatmentView:createPropList()
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
function UsePropAcceTreatmentView:itemBtnCallBack(sender)
    local index = sender:getTag()
    self:selItmeByIndex(index)
end

--选择物品
function UsePropAcceTreatmentView:selItmeByIndex(index)
    local itemData = self.items[index]
    self.itemData = itemData
    self.itemCount = itemData.number
    local timeInfo = TimeInfoData:getInstance():getTimeInfoByType(BuildType.firstAidTent)
    if timeInfo == nil then
        self.curNum = 0
    else
        local leftTime = CityBuildingModel:getInstance():getLeftUpBuildingTime(timeInfo.start_time,timeInfo.interval)
        self.curNum = leftTime/itemData.speedTime
        self.curNum = math.ceil(self.curNum)
    end
    self:updateNum()
end

--向前翻页按钮回调
--sender 按钮本身
--eventType 事件类型
function UsePropAcceTreatmentView:forWardBtnCallBack(sender,eventType)
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
function UsePropAcceTreatmentView:backwardBtnCallBack(sender,eventType)
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
function UsePropAcceTreatmentView:updateTime(info)
    info.leftTime = info.leftTime - 1
    if info.leftTime <= 0 then
        info.leftTime = 0
        TimeMgr:getInstance():removeInfo(TimeType.COMMON,1)
        UIMgr:getInstance():closeUI(self.parent.uiType)
        UIMgr:getInstance():closeUI(UITYPE.BUILDING_MENU)
        UIMgr:getInstance():closeUI(UITYPE.PROP_BOX)
        return
    end
    self.timeLab:setString(CommonStr.BUILD_TIME .. ": " .. Common:getFormatTime(info.leftTime))
    local per = (self.needTime-info.leftTime)/self.needTime*100
    self.processBar:setPercent(per)
end

--加速按钮回调
--sender 按钮本身
--eventType 事件类型
function UsePropAcceTreatmentView:accelerationBtnCallBack(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        local timeInfo = TimeInfoData:getInstance():getTimeInfoByType(BuildType.firstAidTent)
        if timeInfo == nil then
            return
        end
        local leftTime = CityBuildingModel:getInstance():getLeftUpBuildingTime(timeInfo.start_time,timeInfo.interval)
        if self.itemData.speedTime*self.curNum > leftTime then
            UIMgr:getInstance():openUI(UITYPE.PROP_BOX, {type=PROP_BOX_TYPE.COMMON,text=CommonStr.ACCE_TIME_OVER_TREATMENT_TIME,
            callback=handler(self, self.sendAcceReq),sureBtnText=CommonStr.SURE,cancelBtnText=CommonStr.CANCEL,buildingPos=pos
            })
            return
        end
        self:sendAcceReq()
    end
end

--发送加速请求
function UsePropAcceTreatmentView:sendAcceReq()
    local buildingPos = self.parent.data.pos
    UsePropAcceTreatmentService:sendAcceReq(self.itemData.templateId,self.itemData.objId,self.curNum,buildingPos)
end

--关闭按钮回调
--sender 按钮本身
--eventType 事件类型
function UsePropAcceTreatmentView:closeBtnCallBack(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self.propPan:setVisible(false)
        self.parent.pan1:setVisible(true)
    end
end



