--[[
    hejun
    增益界面
--]]

GainView = class("GainView",UIBaseView)

--构造
--uiType UI类型
--data 数据
--返回值(无)
function GainView:ctor(uiType,data)
    self.data = data
    self.super.ctor(self,uiType)
    self:adapterSize()
end

--初始化
--返回值(无)
function GainView:init()
    self.root = Common:loadUIJson(GAIN)
    self:addChild(self.root)

    self.cellArr = {}

    self.list = CastleplusListConfig:getInstance():getList()

    --选中的item
    self.curSelGain = nil

    --主界面层容器
    self.view = Common:seekNodeByName(self.root,"Panel_1")
    --增益道具详情界面
    self.GainDetails = GainDetailsView.new(self)

    --关闭按钮
    self.btn_close = Common:seekNodeByName(self.root,"btn_close")
    self.btn_close:addTouchEventListener(handler(self,self.closeCallback))

    --标题
    self.lbl_title = Common:seekNodeByName(self.root,"lbl_title")
    local text = Lan:lanText(4,"城市增益")
    self.lbl_title:setString(text)

    self:createList()
end

--增益列表
function GainView:createList()
    if self.listView ~= nil then
        self.listView:removeFromParent()
    end

    --使用按钮
    self.btn_use = Common:seekNodeByName(self.root,"btn_use")
    self.lbl_use = Common:seekNodeByName(self.root,"lbl_use")
    self.lbl_gold = Common:seekNodeByName(self.root,"lbl_gold")
    self.btn_use:setVisible(false)
    self.lbl_use:setVisible(false)
    self.lbl_gold:setVisible(false)

    --列表背景
    self.listView = cc.ui.UIListView.new {
        bgColor = cc.c4b(0, 0, 0, 0),
        viewRect = cc.rect(0, 0, 700, 1200),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
    }
    --总背景
    self.gainListBG = Common:seekNodeByName(self.view,"gainList")
    self.gainListBG:addChild(self.listView,0)
    --
    local myCell = Common:seekNodeByName(self.root,"Item")

    --排序
    -- table.sort(heroList,function(a,b) return a.state < b.state end )

    for i=1,#self.list do
        local copyCell = myCell:clone()
        --单项
        local cell = self.listView:newItem()
        cell:setItemSize(700, 180)
        cell:setPosition(0, 1200)
        self.listView:addItem(cell)
        cell:addContent(copyCell)
        --
        self:setCellInfo(copyCell,i)
    end
    self.listView:setTouchEnabled(true)
    self.listView:onTouch(handler(self, self.onClickCell))
    self.listView:reload()
end

function GainView:setCellInfo(cell,index)
    --头像
    local castleplus = CastleplusListConfig:getInstance():getCastleplusListByID(index)
    local itemTemplate = ItemTemplateConfig:getInstance():getItemTemplateByID(castleplus.cl_icon)
    local img_item = MMUISimpleUI:getInstance():getItem(itemTemplate.it_quality,itemTemplate.it_icon)
    img_item:setPosition(0,cell:getContentSize().height/2-img_item:getContentSize().height/2)
    cell:addChild(img_item)

    local info = GainData:getInstance():getInfoByType(castleplus.cl_id)
    if info ~= nil then

        local leftTime = Common:getLeftTime(info.beginTime,info.time)
        if leftTime > 0 then
            local processBg = MMUIProcess:getInstance():createWidthTime("citybuilding/processbg.png","citybuilding/process.png",cell,leftTime,info.totalTime,nil,TimeType.GAIN,castleplus.cl_id)
            processBg:setPosition(cell:getContentSize().width/2+50,50)
            processBg:setTag(100)
        end
    end
    table.insert(self.cellArr,cell)
    --名字
    local lbl_name = Common:seekNodeByName(cell,"lbl_name")
    lbl_name:setString(castleplus.cl_plusname)
    --简介
    local lbl_synopsis = Common:seekNodeByName(cell,"lbl_synopsis")
    local lbl_synopsis2 = Common:seekNodeByName(cell,"lbl_synopsis2")
    lbl_synopsis:setString(castleplus.cl_description)

    lbl_synopsis:setVisible(true)
    lbl_synopsis2:setVisible(false)
end

--增益详情按钮回调
function GainView:onClickCell(event)
    if "clicked" == event.name then

        MMUIProcess:getInstance():closeTimeByType(TimeType.GAIN)
        -- local cell = self.cellArr[event.itemPos]
        -- cell:removeChildByTag(100)
        local info = self.list[event.itemPos]
        self.GainDetails:setData(info)
        self:hideView()
        self.GainDetails:showView()
        if self.listView ~= nil then
            self.listView:removeFromParent()
            self.listView = nil
        end
    end
end

--获取建筑物位置
--返回值(建筑位置)
function GainView:getBuildingPos()
    return self.data.building:getTag()
end

--UI加到舞台后都会调用这个接口
--返回值(无)
function GainView:onEnter()

end

--UI离开舞台后都会调用这个接口
--返回值(无)
function GainView:onExit()
    MMUIProcess:getInstance():closeTimeByType(TimeType.GAIN)
end

--析构函数(此时已经从内存中释放掉资源了)
--返回值(无)
function GainView:onDestroy()

end

--关闭按钮回调
--返回值(无)
function GainView:closeCallback(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        UIMgr:getInstance():openUI(UITYPE.BUILDING_MENU, {building=self.data.building})
        UIMgr:getInstance():closeUI(self.uiType)
    end
end

-- 显示界面
function GainView:showView()
    self.view:setVisible(true)
end

-- 隐藏界面
function GainView:hideView()
    self.view:setVisible(false)
end