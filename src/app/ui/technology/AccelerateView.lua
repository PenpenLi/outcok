--
-- Author: Your Name
-- Date: 2016-01-07 21:35:47
--科技 加速研究提示框
AccelerateView = class("AccelerateView")

--构造
--uiType UI类型
--data 数据
function AccelerateView:ctor(theSelf)
    self.parent = theSelf
    self.view = Common:seekNodeByName(self.parent.root,"Panel_accelerate")
    self.view:setTouchEnabled(true)
    self:init()
end

--初始化
--返回值(无)
function AccelerateView:init()
    self.lbl_level2 = Common:seekNodeByName(self.view,"lbl_level2")
    self.lbl_level1 = Common:seekNodeByName(self.view,"lbl_level1")
    --描述文本
    self.lbl_synopsis = Common:seekNodeByName(self.view,"lbl_synopsis")
    --描述背景
    self.bg_content = Common:seekNodeByName(self.view,"Image_550")

    --标题
    self.lbl_title = Common:seekNodeByName(self.view,"lbl_title")
    --加速按钮
    self.btn_k_research = Common:seekNodeByName(self.view,"btn_k_research")
    self.btn_k_research:addTouchEventListener(handler(self,self.onKResearchBack))
    --触摸边缘关闭界面
    self.imgBg = Common:seekNodeByName(self.view,"img_accelerate")
    self.clickAreaCheck = MMUIClickAreaCheck.new(self.imgBg,self.hideView,self)
    self.view:addChild(self.clickAreaCheck)
end

function AccelerateView:setData(info)
    --
    if info.maxlv == info.level then
        self.lbl_level2:setVisible(false)
        self.btn_k_research:setVisible(false)

        local lbl_condition = display.newTTFLabel({
            text = "已达最高级",
            font = "Arial",
            size = 26,
            color = cc.c3b(255, 255, 255),
            align = cc.TEXT_ALIGNMENT_LEFT,
        })
        self.bg_content:addChild(lbl_condition)
        lbl_condition:setAnchorPoint(0.5,0.5)
        lbl_condition:setPosition(self.bg_content:getContentSize().width / 2, self.bg_content:getContentSize().height / 2)
    else
        self.lbl_level2:setVisible(true)
        self.btn_k_research:setVisible(true)
        local timeOutInfo = TimeInfoData:getInstance():getTimeInfoById(TechnologyModel:getInstance().timeID_h,TechnologyModel:getInstance().timeID_l)
        local lastTime = Common:getLeftTime(timeOutInfo.start_time,timeOutInfo.interval)
        --倒计时
        local time = MMUIProcess:getInstance():createWidthTime("citybuilding/processbg.png","citybuilding/process.png",self.view,lastTime,timeOutInfo.interval,nil,TimeType.TECHNOLOGY,1313)
        time:setPosition(self.view:getContentSize().width / 2, self.view:getContentSize().height / 2 - 120)
        time:setTag(111)
    end

    self.theInfo = info
    self.beforeArr = info.beforeArr
    self.lbl_level1:setString("当前等级：" .. info.gain)
    self.lbl_level2:setString("下一等级：" .. info.nextLevelGain)
    self.lbl_title:setString(info.name)
    self.lbl_synopsis:setString(info.des)
    --删除图片
    if self.view:getChildByTag(100) ~= nil then
        self.view:removeChildByTag(100)
    end

    --等级
    local processBg = MMUIProcess:getInstance():create("citybuilding/processbg.png","citybuilding/process.png",self.view, info.level, info.maxlv,0.5)
    processBg:setPosition(self.view:getContentSize().width / 2 - 180, self.view:getContentSize().height / 2 - 60)


    --头像
    local img = MMUISprite:getInstance():create("#" .. info.icon .. ".png")
    img:setTag(100)
    img:setAnchorPoint(0.5, 0.5)
    img:setPosition(100, self.imgBg:getContentSize().height - 100)
    img:addTo(self.imgBg)
end

--立即研究按钮回调
--返回值(无)
function AccelerateView:onKResearchBack(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        print("立即")
    end
end

-- 显示界面
function AccelerateView:showView()
    self.view:setVisible(true)
    self.clickAreaCheck:setTouchEnabled(true)
end

-- 隐藏界面
function AccelerateView:hideView()
    self.view:setVisible(false)
    self.clickAreaCheck:setTouchEnabled(false)
    self.view:removeChildByTag(111)
    MMUIProcess:getInstance():closeTimeByType(TimeType.TECHNOLOGY)
end
