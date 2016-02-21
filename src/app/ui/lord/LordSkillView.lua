--
-- Author: Your Name
-- Date: 2016-01-19 19:44:05
--

LordSkillView = class("LordSkillView",function()
    return display.newLayer()
end)

--构造
--uiType UI类型
--data 数据
--返回值(无)
function LordSkillView:ctor(uiType,data)
    self.baseView = BaseView.new(self,uiType,data)
end

--初始化
--返回值(无)
function LordSkillView:init()
    self.root = Common:loadUIJson(ACTIVE_SKILLS)
    self:addChild(self.root)
    --界面
    self.view = Common:seekNodeByName(self.root,"Panel_1")
    self.view:addTouchEventListener(handler(self,self.onClose))
    --
    self.img_skill = Common:seekNodeByName(self.root,"img_skill")
    --详情背景
    self.img_use = Common:seekNodeByName(self.root,"img_use")
    -- self.img_use:setVisible(true)
    --弹窗标题
    self.lbl_title2 = Common:seekNodeByName(self.root,"lbl_title2")
    --弹窗详情文本
    self.lbl_detail = Common:seekNodeByName(self.root,"lbl_detail")
    --弹窗时间文本或提示文本
    self.lbl_text = Common:seekNodeByName(self.root,"lbl_text")
    --弹窗使用按钮
    self.btn_use = Common:seekNodeByName(self.root,"btn_use")
    self.btn_use:addTouchEventListener(handler(self,self.onUseSkill))
    --技能列表
    self.skillList = Common:seekNodeByName(self.root,"skillList")
    --技能标题
    self.lbl_title = Common:seekNodeByName(self.root,"lbl_title")
    -- 创建列表
    self:createList()
end

-- 创建列表
function LordSkillView:createList()
    local len = #LordSkillData:getInstance().lordSkillList
    for i=1,#LordSkillData:getInstance().lordSkillList do
        local v = LordSkillData:getInstance().lordSkillList[i]
        -- 图片
        local img = nil
        if v.id == nil then
            img = MMUISprite:getInstance():createGray("#"..v.icon..".png",self.onClickIcon,self)
        else
            img = MMUISprite:getInstance():create("#"..v.icon..".png",self.onClickIcon,self)
        end
        img:setTag(i)
        img:setPosition(130 * (i - 1) + img:getContentSize().width / 2, self.skillList:getContentSize().height / 2)
        self.skillList:addChild(img)
        -- 添加倒计时
        if v.timeInfoID ~= nil then
            -- 倒计时
            local lbl_time = display.newTTFLabel({
                text = "",
                font = "Arial",
                size = 26,
                color = cc.c3b(255, 255, 255),
            })
            lbl_time:setPosition(130 * (i - 1) + img:getContentSize().width / 2, 30)
            self.skillList:addChild(lbl_time)
            local lastTime = TimeInfoData:getInstance():getLeftTimeById(v.timeInfoID.id_h,v.timeInfoID.id_l)
            TimeMgr:getInstance():createTime(lastTime,self.timeCallBack,self,UITYPE.LORD,i,lbl_time)
        end
    end
    local innerLayer = self.skillList:getInnerContainer()
    innerLayer:setContentSize(cc.size(130 * len, innerLayer:getContentSize().height))
end

function LordSkillView:timeCallBack(info)
    local lbl = info.data
    lbl:setString(Common:getFormatTime(info.time))
    if info.time <= 0 then
        TimeMgr:getInstance():removeTypeInfoByIndex(info.timeType,info.index,info.id)
        lbl:removeFromParent()
    end

end

function LordSkillView:onClickIcon(sender)
    self.selectInfo = LordSkillData:getInstance():getLordSkillInfoByIndex(sender:getTag())
    self.img_use:setVisible(true)
    self:setLordSkillInfo()
end

-- 设置天赋技能详情
function LordSkillView:setLordSkillInfo()
    if self.img_use:getChildByTag(100) ~= nil then
        self.img_use:removeChildByTag(100)
    end
    local img = MMUISprite:getInstance():create("#"..self.selectInfo.icon..".png")
    img:setPosition(130, 250)
    img:setTag(100)
    self.img_use:addChild(img)
    -- 名字
    self.lbl_title2:setString(self.selectInfo.name)
    -- 详情
    self.lbl_detail:setString(self.selectInfo.des)
    -- 判断是否拥有这个技能
    if self.selectInfo.id == nil then
        self.lbl_text:setVisible(true)
        self.lbl_text:setString(Lan:lanText(213,"还没有学会这个技能"))
        self.lbl_text:setColor(cc.c3b(255, 0, 0))
        --
        self.btn_use:setTitleText(Lan:lanText(214,"去看看"))
    else
        self.lbl_text:setVisible(false)
        --
        self.btn_use:setTitleText(Lan:lanText(9,"使用"))
    end
end

-- 使用技能
function LordSkillView:onUseSkill(sender,eventType)
   if eventType == ccui.TouchEventType.ended then
        -- 判断是否拥有这个技能
        if self.selectInfo.id == nil then
            print("去看看",self.selectInfo.name)
        else
            print("使用",self.selectInfo.name,self.selectInfo.cdStartTime)
            LordService:getInstance():sentUseLordSkill(self.selectInfo.objId)
            self:removeFromParent()
        end
    end
end

function LordSkillView:onClose(sender,eventType)
   if eventType == ccui.TouchEventType.ended then
        self:getParent().lordSkillView = nil
        self:removeFromParent()
    end
end

--UI加到舞台后会调用这个接口
--返回值(无)
function LordSkillView:onEnter()
    UICommon:getInstance():setMapTouchAable(false)
end

--UI离开舞台后会调用这个接口
--返回值(无)
function LordSkillView:onExit()
    TimeMgr:getInstance():removeInfoByType(UITYPE.LORD)
    UICommon:getInstance():setMapTouchAable(true)
end

--析构函数(此时已经从内存中释放掉资源了)
--返回值(无)
function LordSkillView:onDestroy()
    --MyLog("Build_menuView:onDestroy")
end