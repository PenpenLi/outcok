
--[[
    hejun
    增益道具详情界面
--]]

 GainDetailsView = class("GainDetailsView")


--构造
--uiType UI类型
--data 数据
function GainDetailsView:ctor(theSelf)
    self.parent = theSelf
    self.view = Common:seekNodeByName(self.parent.root,"Panel_2")
    self:init()
end

--初始化
--返回值(无)
function GainDetailsView:init()
    -- 关闭按钮
    self.btn_close = Common:seekNodeByName(self.view,"btn_close")
    self.btn_close:addTouchEventListener(handler(self,self.onBack))

    --标题
    self.lbl_title = Common:seekNodeByName(self.view,"lbl_title2")
    --详情
    self.lbl_details = Common:seekNodeByName(self.view,"lbl_details")


end

function GainDetailsView:setData(info)
    self.info = info
    self.list = PlusItemConfig:getInstance():getPlusItemByType(info.cl_id)

    self.lbl_details:setString(info.cl_tips)
    self.lbl_title:setString(info.cl_plusname)

    self:createList()
    self:updataTimeUI()
end

--增益列表
function GainDetailsView:createList()
    if self.listView ~= nil then
        self.listView:removeFromParent()
    end

    --列表背景
    self.listView = cc.ui.UIListView.new {
        bgColor = cc.c4b(0, 0, 0, 0),
        viewRect = cc.rect(0, 0, 700, 1100),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
    }
    --总背景
    self.gainListBG = Common:seekNodeByName(self.view,"detailsList")
    self.gainListBG:addChild(self.listView,0)
    --
    local myCell = Common:seekNodeByName(self.parent.root,"Item")


    --排序
    -- table.sort(heroList,function(a,b) return a.state < b.state end )

    for i=1,#self.list do
        local copyCell = myCell:clone()
        local v = self.list[i]
        --单项
        local cell = self.listView:newItem()
        cell:setItemSize(700, 180)
        cell:setPosition(0, 1100)
        self.listView:addItem(cell)
        cell:addContent(copyCell)
        --
        self:setCellInfo(copyCell,i,v)
    end
    self.listView:setTouchEnabled(true)
    self.listView:reload()
end

function GainDetailsView:setCellInfo(cell,index,v)
    --物品模板表
    local itemTemplate = ItemTemplateConfig:getInstance():getItemTemplateByID(v.pi_itemid)
    --头像
    local img_item = MMUISimpleUI:getInstance():getItem(itemTemplate.it_quality,itemTemplate.it_icon)
    img_item:setPosition(0,cell:getContentSize().height/2-img_item:getContentSize().height/2)
    cell:addChild(img_item)

    --使用按钮
    local btn_use = Common:seekNodeByName(cell,"btn_use")
    btn_use:addTouchEventListener(handler(self,self.onUse))
    btn_use:setTag(index)
    local lbl_use = Common:seekNodeByName(cell,"lbl_use")
    local lbl_gold = Common:seekNodeByName(cell,"lbl_gold")
    btn_use:setVisible(true)
    lbl_use:setVisible(true)
    lbl_gold:setVisible(true)
    local num = ItemData:getInstance():getItemNumber(itemTemplate.it_id)
    if num ~= 0 then
        local use = Lan:lanText(9,"使用")
        lbl_use:setString(use)
        local text2 = Lan:lanText(7,"拥有")
        lbl_gold:setString(text2 .. " " .. num)
    else
        local buy = Lan:lanText(5,"购买&使用")
        lbl_use:setString(buy)
        local gold = Lan:lanText(6,"金币")
        lbl_gold:setString(itemTemplate.it_price .. gold)
    end

    --名字
    local lbl_name = Common:seekNodeByName(cell,"lbl_name")
    lbl_name:setString(itemTemplate.it_name)
    --简介
    local lbl_synopsis = Common:seekNodeByName(cell,"lbl_synopsis")
    local lbl_synopsis2 = Common:seekNodeByName(cell,"lbl_synopsis2")
    lbl_synopsis:setVisible(false)
    lbl_synopsis2:setVisible(true)
    lbl_synopsis2:setString(itemTemplate.it_description)
end

--使用&购买道具按钮回调
--sender 按钮本身
--eventType 事件类型
function GainDetailsView:onUse(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        local index = sender:getTag()
        local v = self.list[index]
        --物品模板表
        local itemTemplate = ItemTemplateConfig:getInstance():getItemTemplateByID(v.pi_itemid)
        local num = ItemData:getInstance():getItemNumber(itemTemplate.it_id)
        if num ~= 0 then
            local item = ItemData:getInstance():getItemByID(itemTemplate.it_id)
            BagService:getInstance():sendUseItem(item.objId,itemTemplate.it_id,1)
        else
            self.template = itemTemplate.it_id
            local buy = Lan:lanText(8,"我的领主，你确定购买并使用此件物品吗?")
            local buy1 = Lan:lanText(5,"购买&使用")
            local gold = Lan:lanText(6,"金币")
            UIMgr:getInstance():openUI(UITYPE.PROP_BOX, {type=PROP_BOX_TYPE.BUY,text=buy,
                callback=handler(self, self.sendRemoveReq),sureBtnText=buy1,cancelBtnText=itemTemplate.it_price .. gold})
        end
    end
end

function GainDetailsView:autoUseItem(tempeleID)
    local item = ItemData:getInstance():getItemByID(tempeleID)
    BagService:getInstance():sendUseItem(item.objId,tempeleID,1)
    GainModel:getInstance().buyFrom = 0
end

--更新时间UI
function GainDetailsView:updataTimeUI()
    self:createList()
    MMUIProcess:getInstance():closeTimeByType(TimeType.GAIN)
    if self.view:getChildByTag(100) ~= nil then
        self.view:removeChildByTag(100)
    end
    print("self.info.cl_id=",self.info.cl_id)
    local info = GainData:getInstance():getInfoByType(self.info.cl_id)
    print("info=",info)
    print("GainData:getInstance()",#GainData:getInstance().gainList)

    if info ~= nil then
        local leftTime = Common:getLeftTime(info.beginTime,info.time)
        if leftTime > 0 then
            local processBg = MMUIProcess:getInstance():createWidthTime("citybuilding/processbg.png","citybuilding/process.png",self.view,leftTime,info.totalTime,nil,TimeType.GAIN,self.info.cl_id)
            processBg:setPosition(display.width / 2,display.height - 100)
            processBg:setTag(100)
        end
    end
end

--确定购买按钮回调
function GainDetailsView:sendRemoveReq(sender,eventType)
    GainModel:getInstance().buyFrom = 1
    BagService:getInstance():sendBuyItem(self.template,1)
end


--关闭按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function GainDetailsView:onBack(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        self:hideView()
        self.parent.view:setVisible(true)
        MMUIProcess:getInstance():closeTimeByType(TimeType.GAIN)
        if self.view:getChildByTag(100) ~= nil then
            self.view:removeChildByTag(100)
        end
        self.parent:createList()
    end
end

-- 显示界面
function GainDetailsView:showView()
    self.view:setVisible(true)
end

-- 隐藏界面
function GainDetailsView:hideView()
    self.view:setVisible(false)
end