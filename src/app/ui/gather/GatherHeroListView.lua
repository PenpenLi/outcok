--
-- Author: oyhc
-- Date: 2015-12-02 20:59:31
--
GatherHeroListView = class("GatherHeroListView",function()
    return display.newLayer()
end)
--构造
--uiType UI类型
--data 数据
function GatherHeroListView:ctor(uiType,data)
    self.baseView = BaseView.new(self,uiType,data)
end

--初始化
--返回值(无)
function GatherHeroListView:init()
    -- 
    self.root = Common:loadUIJson(GATHER_PATH)
    self.root:setTouchEnabled(false)
    self:addChild(self.root)
    -- --数据层
    -- self.model = GatherModel:getInstance()
    -- --英雄列表界面
    self.view = Common:seekNodeByName(self.root,"panelHeroList")
    self:createHeroList()
end


function GatherHeroListView:createHeroList()
    if self.listView ~= nil then
        self.listView:removeFromParent()
    end
    --列表背景
    self.listView = cc.ui.UIListView.new {
        -- bgColor = cc.c4b(100, 100, 100, 255),
        bgColor = cc.c4b(0, 0, 0, 0),
        viewRect = cc.rect(0, 0, 700, 1200),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
    }
    --总背景
    self.heroListBG = Common:seekNodeByName(self.view,"heroList")
    self.heroListBG:addChild(self.listView,0)
    -- 返回按钮
    self.btn_back = Common:seekNodeByName(self.view,"btn_back")
    self.btn_back:addTouchEventListener(handler(self,self.onBack))
    -- 英雄
    local lbl_name = Common:seekNodeByName(self.view,"lbl_name")
    lbl_name:setString("英雄")
    -- 
    local myCell = Common:seekNodeByName(self.root,"heroCell")
    --
    for i=1,#PlayerData:getInstance().heroList do
        local copyCell = myCell:clone()
        --单项
        local cell = self.listView:newItem()
        cell:setItemSize(700, 200)
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

function GatherHeroListView:onEnter()

    if self.skillView == nil then
        -- 技能界面
        self.skillView = GatherSkillView.new(self)
        -- 添加到这个模块的ui组里
        self:getParent().baseView:addView(self.skillView)
    end
    if self.weaponView == nil then
        -- 装备界面
        self.weaponView = GatherWeaponView.new(self)
        -- 添加到这个模块的ui组里
        self:getParent().baseView:addView(self.weaponView)
    end
end

function GatherHeroListView:setCellInfo(cell,index)
    local info =  PlayerData:getInstance().heroList[index]
    if info == nil then
        return
    end
    --头像
    local head = MMUISimpleUI:getInstance():getHead(info)
    head:setPosition(150,100)
    cell:addChild(head)
    --名字
    local lbl_name = Common:seekNodeByName(cell,"lbl_name")
    lbl_name:setString(info.name)
    lbl_name:setColor(Common:getQualityColor(info.quality))
    --等级
    local lbl_level = Common:seekNodeByName(cell,"lbl_level")
    lbl_level:setString("等级：" .. info.level)
    --战斗力
    local lbl_fight = Common:seekNodeByName(cell,"lbl_fight")
    lbl_fight:setString("战斗力：" .. info.fightforce)
end

--点击英雄列表项按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function GatherHeroListView:onClickCell(event)
    local listView = event.listView
    if "clicked" == event.name then
        -- print("clicked",event.itemPos)
        local clickInfo = PlayerData:getInstance().heroList[event.itemPos]
        -- print("点击英雄的id",clickInfo.id)
        if self.heroInfoView == nil then
            -- 科技界面
            self.heroInfoView = GatherHeroInfoView.new(self)
            -- 添加到这个模块的ui组里
            self:getParent().baseView:addView(self.heroInfoView)
        end
        -- 显示界面
        self:getParent().baseView:showView(self.heroInfoView)
        -- 加载英雄信息
        self.heroInfoView:init(clickInfo)
    elseif "moved" == event.name then
        -- 
    elseif "ended" == event.name then
        -- 
    else
    -- print("event name:" .. event.name)
    end
end

--返回按钮回调
--sender 按钮本身
--eventType 事件类型
function GatherHeroListView:onBack(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        -- 显示菜单 隐藏自己
        self:getParent().baseView:showTopView()
    end
end

-- 显示界面
function GatherHeroListView:showView()
	self.view:setVisible(true)
end

-- 隐藏界面
function GatherHeroListView:hideView()
	self.view:setVisible(false)
end