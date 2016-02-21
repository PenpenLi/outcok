--
-- Author: Your Name
-- Date: 2016-01-06 22:00:58
--科技 开始研究提示框
ResearchView = class("ResearchView")

--构造
--uiType UI类型
--data 数据
function ResearchView:ctor(theSelf)
    self.parent = theSelf
    self.view = Common:seekNodeByName(self.parent.root,"Panel_research")
    self.view:setTouchEnabled(true)
    self:init()
end

--初始化
--返回值(无)
function ResearchView:init()
    self.lbl_time = Common:seekNodeByName(self.parent.root,"lbl_time")
    self.lbl_level2 = Common:seekNodeByName(self.parent.root,"lbl_level2")
    self.lbl_level1 = Common:seekNodeByName(self.parent.root,"lbl_level1")
    --描述文本
    self.lbl_synopsis = Common:seekNodeByName(self.parent.root,"lbl_synopsis")
    --标题
    self.lbl_title = Common:seekNodeByName(self.parent.root,"lbl_title")
    --加速按钮
    self.btn_k_research = Common:seekNodeByName(self.parent.root,"btn_k_research")
    self.btn_k_research:addTouchEventListener(handler(self,self.onKResearchBack))
    --研究按钮
    self.btn_research = Common:seekNodeByName(self.parent.root,"btn_research")
    self.btn_research:addTouchEventListener(handler(self,self.onResearchBack))
    --触摸边缘关闭界面
    self.imgBg = Common:seekNodeByName(self.parent.root,"img_research")
    self.clickAreaCheck = MMUIClickAreaCheck.new(self.imgBg,self.hideView,self)
    self.view:addChild(self.clickAreaCheck)
end

function ResearchView:setData(info,arr)

    self.btn_research:setBright(true)
    self.btn_k_research:setBright(true)
    self.theInfo = info
    self.beforeArr = info.beforeArr
    self.theArr = arr
    self.lbl_level1:setString("当前等级：" .. info.gain)
    self.lbl_level2:setString("下一等级：" .. info.nextLevelGain)
    local time = Common:getFormatTime(info.nextLevelTime)
    self.lbl_time:setString(time)
    self.lbl_title:setString(info.name)
    self.lbl_synopsis:setString(info.des)
    --删除图片
    if self.imgBg:getChildByTag(100) ~= nil then
        self.imgBg:removeChildByTag(100)
    end
    if self.view:getChildByTag(101) ~= nil then
        self.view:removeChildByTag(101)
    end
    --等级
    local processBg = MMUIProcess:getInstance():create("citybuilding/processbg.png","citybuilding/process.png",self.view, info.level, info.maxlv,0.5)
    processBg:setTag(101)
    processBg:setPosition(self.view:getContentSize().width / 2 - 180, self.view:getContentSize().height / 2 + 50)

    --头像
    local img = MMUISprite:getInstance():create("#" .. info.icon .. ".png")
    img:setTag(100)
    img:setAnchorPoint(0.5, 0.5)
    img:setPosition(150, self.imgBg:getContentSize().height - 150)
    img:addTo(self.imgBg)

    --条件列表
    self:createResearchConditionList(info.beforeArr)
end

--创建研究条件列表
--返回值(无)
function ResearchView:createResearchConditionList(arr)
    if self.listView ~= nil then
        self.listView:removeFromParent()
    end


    --列表背景
    self.listView = cc.ui.UIListView.new {
        bgColor = cc.c4b(0, 0, 0, 0),
        viewRect = cc.rect(0, 0, 600, 300),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
    }
    --总背景
    self.gainListBG = Common:seekNodeByName(self.view,"list")
    self.gainListBG:addChild(self.listView,0)
    --
    local myCell = Common:seekNodeByName(self.parent.root,"img")

    for i=1,#arr do
        local v = arr[i]

        local copyCell = myCell:clone()

        --单项
        local cell = self.listView:newItem()
        cell:setItemSize(10, 60)
        cell:setPosition(0, 10)
        self.listView:addItem(cell)
        cell:addContent(copyCell)

        local lbl_condition = display.newTTFLabel({
            text = "",
            font = "Arial",
            size = 26,
            color = cc.c3b(255, 255, 255),
            align = cc.TEXT_ALIGNMENT_LEFT,
        })
        cell:addChild(lbl_condition)
        lbl_condition:setAnchorPoint(0,0)
        lbl_condition:setPosition(40, 15)

        local picName = "ui/build_details/finish.png"


        if i == 1 then
            lbl_condition:setString("学院 等级" .. v.techLevel)

            local buildInfo = CityBuildingModel:getInstance():getBuildInfo(self.parent.pos)
            if buildInfo.level < v.techLevel then
                lbl_condition:setTextColor(cc.c3b(255, 0, 0))
                self.btn_research:setBright(false)
                self.btn_k_research:setBright(false)
                picName = "ui/build_details/unfinish.png"
            end
        else
            if v.id ~= 0 then
                lbl_condition:setString("需要科技：" .. v.name ..  "lv." ..v.level)
                local techInfo = TechData:getInstance():getInfoByID(self.theArr, v.id)

                if techInfo.level < v.level then
                    lbl_condition:setTextColor(cc.c3b(255, 0, 0))
                    self.btn_research:setBright(false)
                    self.btn_k_research:setBright(false)
                    picName = "ui/build_details/unfinish.png"
                end
            else
                local str = ""
                local resValue = 0
                if v.kind == RESOURCES.food then
                    resValue = PlayerData:getInstance().food
                    str = "粮食："
                elseif v.kind == RESOURCES.wood then
                    resValue = PlayerData:getInstance().wood
                    str = "木材："
                elseif v.kind == RESOURCES.iron then
                    resValue = PlayerData:getInstance().iron
                    str = "铁矿："
                elseif v.kind == RESOURCES.mithril then
                    resValue = PlayerData:getInstance().mithril
                    str = "秘银："
                end
                lbl_condition:setString(str .. resValue .. "/" .. v.value)
                if resValue < v.value then
                    lbl_condition:setTextColor(cc.c3b(255, 0, 0))
                    picName = "ui/build_details/unfinish.png"
                end

            end
        end
        local sprite = display.newSprite(picName)
        sprite:setPosition(550,30)
        cell:addChild(sprite)
    end
    self.listView:setTouchEnabled(true)
    self.listView:reload()
end


--研究按钮回调
--返回值(无)
function ResearchView:onResearchBack(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        for i=1,#self.beforeArr do

            local v = self.beforeArr[i]

            if i ~= 1 and v.id == 0 then
                local resValue = 0
                local str = ""
                if v.kind == RESOURCES.food then
                    resValue = PlayerData:getInstance().food
                    str = "粮食"
                    if resValue < v.value then
                        Lan:hintClient(10,"{}不足",{str},2)
                        return
                    end
                elseif v.kind == RESOURCES.wood then
                    resValue = PlayerData:getInstance().wood
                    str = "木材"
                    if resValue < v.value then
                        Lan:hintClient(10,"{}不足",{str},2)
                        return
                    end
                elseif v.kind == RESOURCES.iron then
                    resValue = PlayerData:getInstance().iron
                    str = "铁矿"
                    if resValue < v.value then
                        Lan:hintClient(10,"{}不足",{str},2)
                        return
                    end
                elseif v.kind == RESOURCES.mithril then
                    resValue = PlayerData:getInstance().mithril
                    str = "秘银"
                    if resValue < v.value then
                        Lan:hintClient(10,"{}不足",{str},2)
                        return
                    end
                end
            end
        end
        -- 是否是立即研究的科技
        TechnologyModel:getInstance().isQuickTech = false
        -- 科技升级 pos id level  done
        TechnologyService:getInstance():sentUpgradeTech(self.parent.pos, self.theInfo.id, self.theInfo.level + 1, 2)
    end
end

--立即研究按钮回调
--返回值(无)
function ResearchView:onKResearchBack(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        for i=1,#self.beforeArr do

            local v = self.beforeArr[i]

            if i ~= 1 and v.id == 0 then
                local resValue = 0
                local str = ""
                if v.kind == RESOURCES.food then
                    resValue = PlayerData:getInstance().food
                    str = "粮食"
                    if resValue < v.value then
                        Lan:hintClient(10,"{}不足",{str},2)
                        return
                    end
                elseif v.kind == RESOURCES.wood then
                    resValue = PlayerData:getInstance().wood
                    str = "木材"
                    if resValue < v.value then
                        Lan:hintClient(10,"{}不足",{str},2)
                        return
                    end
                elseif v.kind == RESOURCES.iron then
                    resValue = PlayerData:getInstance().iron
                    str = "铁矿"
                    if resValue < v.value then
                        Lan:hintClient(10,"{}不足",{str},2)
                        return
                    end
                elseif v.kind == RESOURCES.mithril then
                    resValue = PlayerData:getInstance().mithril
                    str = "秘银"
                    if resValue < v.value then
                        Lan:hintClient(10,"{}不足",{str},2)
                        return
                    end
                end
            end
        end
        -- 是否是立即研究的科技
        TechnologyModel:getInstance().isQuickTech = true
        -- 科技升级 pos id level  done
        TechnologyService:getInstance():sentUpgradeTech(self.parent.pos, self.theInfo.id, self.theInfo.level + 1, 1)
    end
end

-- 显示界面
function ResearchView:showView()
    self.view:setVisible(true)
    self.clickAreaCheck:setTouchEnabled(true)
end

-- 隐藏界面
function ResearchView:hideView()
    self.view:setVisible(false)
    self.clickAreaCheck:setTouchEnabled(false)
end
