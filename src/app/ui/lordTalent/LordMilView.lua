--
-- Author: Your Name
-- Date: 2016-01-11 20:22:23
-- 军事列表
LordMilView = class("LordMilView")

--构造
--uiType UI类型
--data 数据
function LordMilView:ctor(theSelf)
    self.parent = theSelf
    self.view = Common:seekNodeByName(self.parent.root,"List_battle")
    -- self.view:setTouchEnabled(false)
    -- self.view:getParent():setTouchEnabled(false)
end

--初始化
--返回值(无)
function LordMilView:init()

end

function LordMilView:setData()
    for i=1,41 do
        self:createTech(LordModel:getInstance().milTechArr,i)
    end
end

--
function LordMilView:createTech(arr, id)
    local info = TalentData:getInstance():getInfoByID(arr, id)
    if info == nil then
        print("错误")
        return
    end
    -- 图片背景
    local bg_img = Common:seekNodeByName(self.parent.root,"btn_"..id)
    bg_img:removeAllChildren()
    -- 图片
    local img = nil
    if info.level == 0 then
        img = MMUISprite:getInstance():createGray("#"..info.icon..".png")
    else
        img = MMUISprite:getInstance():create("#"..info.icon..".png")
    end
    img:setSwallowTouches(false)
    bg_img:setTag(id)
    img:setAnchorPoint(0.5, 0.5)
    img:setPosition(bg_img:getContentSize().width / 2, bg_img:getContentSize().height / 2)
    img:addTo(bg_img)
    -- 名字
    local lbl_name = display.newTTFLabel({
        text = info.name,
        font = "Arial",
        size = 22,
        color = cc.c3b(255, 255, 255),
    })
    lbl_name:setAnchorPoint(0, 0)
    lbl_name:setPosition(0, 24)
    lbl_name:addTo(bg_img)
    lbl_name:setWidth(150)
    lbl_name:setHeight(28)
    -- 等级
    local lbl_lv = cc.ui.UILabel.new(
                {text = info.level.."/"..info.maxlv,
                size = 22,
                align = cc.ui.TEXT_ALIGN_CENTER,
                color = display.COLOR_WHITE})
    lbl_lv:setAnchorPoint(0.5, 0.5)
    lbl_lv:setPosition(bg_img:getContentSize().width / 2 + 68, 35)
    lbl_lv:addTo(bg_img)

    bg_img:addTouchEventListener(handler(self,self.onClickIcon))
end

function LordMilView:onClickIcon(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        local info = TalentData:getInstance():getInfoByID(LordModel:getInstance().milTechArr, sender:getTag())
        self.parent.selectTalent = info
        self.parent.lordSkillOperationView:showView()
        self.parent.lordSkillOperationView:setData(info,LordModel:getInstance().milTechArr)
    end
end

-- 显示界面
function LordMilView:showView()
    self.view:setVisible(true)
end

-- 隐藏界面
function LordMilView:hideView()
    self.view:setVisible(false)
end
