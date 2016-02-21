
--[[
    jinyan.zhang
    使用道具加速建筑升级
--]]

AccelerationProp = class("AccelerationProp")

--设置发送消息回调
function AccelerationProp:setCallback(callback,obj)
    self.callback = callback
    self.obj = obj
end

--设置总时间
function AccelerationProp:setTotalTime(needTime)
    self.totalTime = needTime
end

--设置时间文本id
function AccelerationProp:setTimeContentId(id)
    self.timeContentId = id
end

--设置加速道类型
function AccelerationProp:setPropType(type)
    self.propType = type
end

--设置道具加速时间超过当前时间的提示内容
function AccelerationProp:setPropTimeOverText(propTime)
    self.propTimeOverText = propTime
end

--构造
--parent 父结点UI
function AccelerationProp:ctor(parent)
	self.parent = parent
    self.items = {}
	self:init()
end

--初始化
function AccelerationProp:init()
    self.view = Common:seekNodeByName(self.parent.root,"propPan")
    self.view:setTouchEnabled(false)

    --标题
    self.labTitle = Common:seekNodeByName(self.view,"titleLab")
    --时间
    self.labTime = Common:seekNodeByName(self.view,"timeLab")
    --进度条
    self.processBar = Common:seekNodeByName(self.view,"processBar")
    --标题2
    self.labTitle2 = Common:seekNodeByName(self.view,"title2Lab")
    self.labTitle2:setString(Lan:lanText(115, "请选择加速道具"))

    --向前翻页按钮
    self.btnForward = Common:seekNodeByName(self.view,"leftBtn")
    self.btnForward:addTouchEventListener(handler(self,self.onForward))

    --向后翻页按钮
    self.btnBackward = Common:seekNodeByName(self.view,"rightBtn")
    self.btnBackward:addTouchEventListener(handler(self,self.onBackward))

    --数量
    self.labNum = Common:seekNodeByName(self.view,"numLab")
    self.labNum:setString(Lan:lanText(118, "数量: {}", {0}))
    --滑动条
    self.slider = Common:seekNodeByName(self.view,"sliderBar")
    self.slider:addEventListener(handler(self,self.onChangeNum))

    --减少按钮
    self.btnMinus = Common:seekNodeByName(self.view,"minusBtn")
    self.btnMinus:addTouchEventListener(handler(self,self.onMinus))
    --增加按钮
    self.btnPlus = Common:seekNodeByName(self.view,"plusBtn")
    self.btnPlus:addTouchEventListener(handler(self,self.onPlus))

    --关闭按钮
    self.btnClose = Common:seekNodeByName(self.view,"closeBtn")
    self.btnClose:addTouchEventListener(handler(self,self.onClose))

    --加速时间
    self.labSpeedTime = Common:seekNodeByName(self.view,"speedTimeLab")
    self.labSpeedTime:setString(Lan:lanText(131, "加速时间: {}", {0}))

    --加速按钮
    self.btnSpeed = Common:seekNodeByName(self.view,"speedBtn")
    self.btnSpeed:addTouchEventListener(handler(self,self.onAcceleration))
    self.btnSpeed:setTouchEnabled(false)
    self.btnSpeed:setTitleText(Lan:lanText(117, "加速"))

    --翻页层
    self.pageView = Common:seekNodeByName(self.view,"pageView")
end

--更新UI
function AccelerationProp:updateUI()
    local leftTime = self.parent:getLeftTime()
    if leftTime == 0 then
        TimeMgr:getInstance():removeInfo(TimeType.propAcceTime,1)
        Prop:getInstance():showMsg(self.parent.popTimeContent)
        self.parent:show()
        self:hideView()
        return
    end

    --更新时间
    self:updateTimeString(leftTime)
    --开启定时器
    TimeMgr:getInstance():createTime(leftTime,self.updateTime,self,TimeType.propAcceTime,1)

    --获取加速道具
    local total = 0
    self.items = {}
    local itemlist = ItemData:getInstance():getQuickItemList()
    for k,v in pairs(itemlist) do
        if v.speedType == self.propType or v.speedType == ItemSpeedType.all then
            table.insert(self.items,v)
            total = total + v.number
        end
    end

    if total == 0 then
        self.slider:setTouchEnabled(false)
        self.btnPlus:setTouchEnabled(false)
        self.btnMinus:setTouchEnabled(false)
        self.btnForward:setTouchEnabled(false)
        self.btnBackward:setTouchEnabled(false)
    else
        self:selItmeByIndex(1)
    end    

    self:createPropList()
end

--获取加速道具数量
function AccelerationProp:getPropCount()
    local total = 0
    local itemlist = ItemData:getInstance():getQuickItemList()
    for k,v in pairs(itemlist) do
        if v.speedType == self.propType or v.speedType == ItemSpeedType.all then
            total = total + v.number
        end
    end
    return total
end

--显示
function AccelerationProp:showView()
    self.view:setVisible(true)
end

--隐藏 
function AccelerationProp:hideView()
    self.view:setVisible(false)
    TimeMgr:getInstance():removeInfo(TimeType.propAcceTime,1)
end

--设置标题
function AccelerationProp:setTitle(content)
    self.labTitle:setString(content)
end

--更新时间
function AccelerationProp:updateTimeString(time)
    self.labTime:setString(Lan:lanText(self.timeContentId, "", {time}))
    local per = (self.totalTime-time)/self.totalTime*100
    self.processBar:setPercent(per)
end

--改变数量回调
function AccelerationProp:onChangeNum(sender,event)
    local curNum = sender:getPercent()/100*self.itemCount
    self.curNum = math.floor(curNum)
    self:updateNum()
end

--更新数量
function AccelerationProp:updateNum()
    self.labNum:setString(CommonStr.NUM .. ": " .. self.curNum)
    local time = self.itemData.speedTime*self.curNum
    self.labSpeedTime:setString(Lan:lanText(131, "加速时间: {}", {time}))
    local per = self.curNum/self.itemCount*100 
    self.slider:setPercent(per)
    if self.curNum == 0 then
        self.btnSpeed:setTouchEnabled(false)
    else
        self.btnSpeed:setTouchEnabled(true)
    end
end

--减少按钮回调
--sender 按钮本身
--eventType 事件类型
function AccelerationProp:onMinus(sender,eventType)
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
function AccelerationProp:onPlus(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self.curNum = self.curNum + 1
        if self.curNum > self.itemCount then
            self.curNum = self.itemCount
        end
        self:updateNum()
    end
end

--创建道具列表
function AccelerationProp:createPropList()
    if self.propList ~= nil then
        return
    end

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
function AccelerationProp:itemBtnCallBack(sender)
    local index = sender:getTag()
    self:selItmeByIndex(index)
end

--选择物品
function AccelerationProp:selItmeByIndex(index)
    local itemData = self.items[index]
    self.itemData = itemData
    self.itemCount = itemData.number
    local leftTime = self.parent:getLeftTime()
    self.curNum = leftTime/itemData.speedTime
    self.curNum = math.ceil(self.curNum)
    self:updateNum()
end

--向前翻页按钮回调
--sender 按钮本身
--eventType 事件类型
function AccelerationProp:onForward(sender,eventType)
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
function AccelerationProp:onBackward(sender,eventType)
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
function AccelerationProp:updateTime(info)
    if info.time <= 0 then
        info.time = 0
        TimeMgr:getInstance():removeInfo(info.timeType,1)
        UIMgr:getInstance():closeUI(UITYPE.PROP_BOX)
        self.parent:closeAllUI()
        return
    end
    --更新时间
    self:updateTimeString(info.time)
end

--加速按钮回调
--sender 按钮本身
--eventType 事件类型
function AccelerationProp:onAcceleration(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        local leftTime = self.parent:getLeftTime()
        if self.itemData.speedTime*self.curNum > leftTime then
            local sure = Lan:lanText(50, "确定")
            local cancel = Lan:lanText(51, "取消")
            UIMgr:getInstance():openUI(UITYPE.PROP_BOX, {type=PROP_BOX_TYPE.COMMON,text=self.propTimeOverText,
            callback=handler(self, self.onAcceleReq),sureBtnText=sure,cancelBtnText=cancel,buildingPos=self.parent.buildingPos
            })
            return
        end
        self:sendAcceReq()
    end
end

--发送使用道具加速请求
function AccelerationProp:onAcceleReq()
    if self.callback ~= nil then
        self.callback(self.obj)
    end
end

--关闭按钮回调
--sender 按钮本身
--eventType 事件类型
function AccelerationProp:onClose(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self:hideView()
        self.parent:show()
    end
end

--道具升级建筑请求
function AccelerationProp:onUpLevelReq()
    local buildingPos = self.parent.buildingPos
    local buildingType = CityBuildingModel:getInstance():getBuildType(buildingPos)
    UsePropAcceBuildingUpLvService:sendPropAccelerationBuildingUpLvReq(self.itemData.templateId,self.itemData.objId,
        self.curNum,buildingPos,buildingType,UpLvPropActionType.create)
end

--道具升级野外建筑请求
function AccelerationProp:onUpLevelReqOfOut()
    --实例id
    local id = self.parent.instanceIds
    TerritoryAcceService:getInstance():usePropUpLevelReq(id,self.itemData.templateId,
        self.itemData.objId,self.curNum)
end


