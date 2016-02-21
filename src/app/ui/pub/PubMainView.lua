--
-- Author: oyhc
-- Date: 2015-11-27 17:03:54
--
PubMainView = class("PubMainView",UIBaseView)

--构造
--uiType UI类型
--data 数据
function PubMainView:ctor(uiType,data)
    self.pos = data
	--父类构造
	self.super.ctor(self,uiType)
	--适配屏幕
    self:adapterSize()
end

--初始化
--返回值(无)
function PubMainView:init()
	self.root = Common:loadUIJson(PUB_PATH)
	self.root:setTouchEnabled(false)
    self:addChild(self.root)
    --数据层
    self.model = PubModel:getInstance()
    self.model.pos = self.pos
    --英雄列表类型 1是招贤馆 2是聚贤馆
	self.heroListKind = 0
    --主界面层容器
    self.pubMain = Common:seekNodeByName(self.root,"PubMain")
    --英雄列表界面
    self.heroListView = PubHeroListView.new(self)
    -- 隐藏英雄列表界面
    self.heroListView:hideView()
    -- 英雄详情层容器
    self.heroInfoView = PubHeroInfoView.new(self)
    -- 隐藏英雄详情界面
    self.heroInfoView:hideView()
    --创建酒吧主界面
    self:createPubMain()
    --创建酒吧英雄列表
    -- self:createPubHeroList()
end

--创建酒吧主界面
function PubMainView:createPubMain()
	--标题
	local lbl_title = Common:seekNodeByName(self.pubMain,"lbl_title")
    lbl_title:setString("酒馆")
    --关闭按钮
    self.closeBtn = Common:seekNodeByName(self.pubMain,"closeBtn")
    self.closeBtn:addTouchEventListener(handler(self,self.onClose))
    --招贤馆按钮
    self.btn_heroRes = Common:seekNodeByName(self.pubMain,"btn_heroRes")
    self.btn_heroRes:addTouchEventListener(handler(self,self.onHeroList))
    --名字
    self.lbl_heroResName = Common:seekNodeByName(self.btn_heroRes,"lbl_name")
    self.lbl_heroResName:setString("招贤馆")
    --说明
    self.lbl_heroResDes = Common:seekNodeByName(self.btn_heroRes,"lbl_title")
    self.lbl_heroResDes:setString("花资源招募英雄")
    --聚贤馆按钮
    self.btn_heroGold = Common:seekNodeByName(self.pubMain,"btn_heroGold")
    self.btn_heroGold:addTouchEventListener(handler(self,self.onHeroList))
    --名字
    self.lbl_heroGoldName = Common:seekNodeByName(self.btn_heroGold,"lbl_name")
    self.lbl_heroGoldName:setString("聚贤馆")
    --说明
    self.lbl_heroGoldDes = Common:seekNodeByName(self.btn_heroGold,"lbl_title")
    self.lbl_heroGoldDes:setString("花金币招募英雄")
end

--招贤馆按钮回调
--sender 按钮本身
--eventType 事件类型
--返回值(无)
function PubMainView:onHeroList(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
    	if self.btn_heroRes == sender then
            PubService:getInstance():sendEnterPub(TavernPanelType.TAVERN_PANEL_HALL, self.pos)
    	elseif self.btn_heroGold == sender then
            PubService:getInstance():sendEnterPub(TavernPanelType.TAVERN_PANEL_MANOR, self.pos)
    	end
    end
end

--关闭按钮回调
--sender 关闭按钮本身
--eventType 事件类型
--返回值(无)
function PubMainView:onClose(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        UIMgr:getInstance():closeUI(self.uiType)
    end
end

function PubMainView:onEnter()
    UICommon:getInstance():setMapTouchAable(false)
end

function PubMainView:onExit()
	UICommon:getInstance():setMapTouchAable(true)
    TimeMgr:getInstance():removeInfo(TimeType.COMMON,1)
end

function PubMainView:onDestroy()

end