--
-- Author: oyhc
-- Date: 2015-12-02 22:27:30
--
GatherWeaponView = class("GatherWeaponView")

--构造
--uiType UI类型
--data 数据
function GatherWeaponView:ctor(theSelf)
	self.parent = theSelf
	self.view = Common:seekNodeByName(self.parent.root,"weapon")
    self.model = GatherModel:getInstance()
	self:init()
end

--初始化
function GatherWeaponView:init()
    -- 返回按钮
    self.btn_back = Common:seekNodeByName(self.view,"btn_back")
    self.btn_back:addTouchEventListener(handler(self,self.onBack))
    -- 标题
    self.lbl_title = Common:seekNodeByName(self.view,"lbl_title")
    -- 标题
    self.lbl_name = Common:seekNodeByName(self.view,"lbl_name")
    -- 刷新按钮
    self.btn_unload = Common:seekNodeByName(self.view,"btn_unload")
    self.btn_unload:addTouchEventListener(handler(self,self.onUnload))
    self.btn_unload:setTitleText("卸下")
    --武器属性列表容器
    self.attributeList = Common:seekNodeByName(self.view,"attributeList")
    -- self.attributeList:setVisible(false)
    --武器列表容器
    self.weaponList = Common:seekNodeByName(self.view,"weaponList")
    -- self.weaponList:setVisible(false)
    -- 没有装备时候的提示文本
    self.lbl_notice = cc.ui.UILabel.new(
            {text = "暂无装备",
            size = 26,
            align = cc.ui.TEXT_ALIGN_LEFT,
            color = display.COLOR_WHITE})
    self.lbl_notice:setPosition(self.view:getContentSize().width / 2 - self.lbl_notice:getContentSize().width / 2, self.btn_unload:getPositionY() + 300)
    self.lbl_notice:addTo(self.view)
end

-- 装备界面设置数据
-- equipType 装备类型
-- hero 英雄数据
function GatherWeaponView:setData(equipType,hero)
    -- 英雄数据
    self.hero = hero
    -- 装备类型
    self.equipType = equipType
    -- 刷选的装备列表
    self.equipArr = EquipData:getInstance():getEquipByType(equipType)
    -- 装备图标
    local title = ""
    if equipType == EQUIP.weapon then --武器
        title = "武器"
    elseif equipType == EQUIP.clothes then --衣服
        title = "衣服"
    elseif equipType == EQUIP.belt then --腰带
        title = "腰带"
    elseif equipType == EQUIP.gauntlet then --护腕
        title = "护腕"
    elseif equipType == EQUIP.trousers then --裤子
        title = "裤子"
    elseif equipType == EQUIP.shoes then --鞋子
        title = "鞋子"
    else
        print(equipType .. "装备类型不对")
        return
    end
    -- 装备
    local equip = self.hero:getEquipsByType(equipType)
    self.lbl_title:setString(title)
    if equip ~= nil then
        self.lbl_name:setString(equip.name)
        -- 装备图片
        self.img_equip = MMUISimpleUI:getInstance():getEquipBox(equipType, equip.icon)
        -- 创建装备属性列表
        self:createEquipAttribute(equip)
        -- 显示卸下装备按钮
        self.btn_unload:setVisible(true)
        -- 隐藏没有装备时候的提示文本
        self.lbl_notice:setVisible(false)
    else
        -- 隐藏卸下装备按钮
        self.btn_unload:setVisible(false)
        -- 显示没有装备时候的提示文本
        self.lbl_notice:setVisible(true)
        self.lbl_name:setString("")
        -- 装备图片
        self.img_equip = MMUISimpleUI:getInstance():getEquipBox(equipType)
    end
    local x = display.width / 2 - self.img_equip:getContentSize().width / 2
    self.img_equip:setPosition(x ,display.height - self.img_equip:getContentSize().height - 150)
    self.view:addChild(self.img_equip)
    --装备列表
    self:createEquipList()
end

-- 刷新ui
-- type 1穿装备返回 2脱装备返回
function GatherWeaponView:updateUI(type)
    -- 刷选的装备列表
    self.equipArr = EquipData:getInstance():getEquipByType(self.equipType)
    -- 装备
    local equip = nil
    if type == 1 then -- 穿装备
        -- 显示卸下装备按钮
        self.btn_unload:setVisible(true)
        -- 隐藏没有装备时候的提示文本
        self.lbl_notice:setVisible(false)
        -- 装备
        equip = self.model.equip
        if equip == nil then
            print("找不到要穿的装备，请检查代码")
        end
        -- 装备名字
        self.lbl_name:setString(equip.name)
        MMUISimpleUI:getInstance():getEquip(self.img_equip, equip.icon)
        --创建装备属性列表
        self:createEquipAttribute(equip)
    else -- 脱装备
        -- 隐藏卸下装备按钮
        self.btn_unload:setVisible(false)
        -- 显示没有装备时候的提示文本
        self.lbl_notice:setVisible(true)
        -- 删除装备图片
        local equipIcon = self.img_equip:getChildByTag(101)
        if equipIcon ~= nil then
            equipIcon:removeFromParent()
        end
        -- 删除装备小图标
        MMUISimpleUI:getInstance():addEquipIcon(self.img_equip, self.equipType)
        -- 装备名字
        self.lbl_name:setString("")
        if self.equipView ~= nil then
            self.equipView:removeFromParent()
            self.equipView = nil
        end
    end
    print("该类型装备列表长度:",#self.equipArr)
    --装备列表
    self:createEquipList()

end

--创建装备属性列表
--equip 装备数据
function GatherWeaponView:createEquipAttribute(equip)
    if self.equipView ~= nil then
        self.equipView:removeFromParent()
    end
    -- if equip == nil then
    --     return
    -- end
    --列表背景
    self.equipView = cc.ui.UIListView.new {
        -- bgColor = cc.c4b(100, 100, 100, 255),
        bgColor = cc.c4b(0, 0, 0, 0),
        viewRect = cc.rect(0, 0, 700, 200),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
    }
    self.attributeList:addChild(self.equipView,0)
    local equipAttributeArr = EquipConfig:getInstance():getEquipAttributeList(equip.templateId)
    for i=1,#equipAttributeArr do
        local v = equipAttributeArr[i]
        local item = self.equipView:newItem()
        local content = display.newNode()
        --属性名称
        local lbl_name = cc.ui.UILabel.new(
                {text = v.name,
                size = 26,
                align = cc.ui.TEXT_ALIGN_LEFT,
                color = display.COLOR_WHITE})
        lbl_name:setPosition(80, 25)
        lbl_name:addTo(content)
        -- 值
        local lbl_value = cc.ui.UILabel.new(
                {text = v.value,
                size = 26,
                align = cc.ui.TEXT_ALIGN_RIGHT,
                color = display.COLOR_WHITE})
        lbl_value:setPosition(350, 25)
        lbl_value:addTo(content)
        -- if i == #equipAttributeArr then
        --     lbl_name:setColor(cc.c4b(255, 0, 0, 255))
        --     lbl_value:setColor(cc.c4b(255, 0, 0, 255))
        -- end

        content:setContentSize(500, 50)
        item:addContent(content)
        item:setItemSize(700, 50)
        self.equipView:addItem(item)
    end
    self.equipView:reload()
end

-- 装备列表
function GatherWeaponView:createEquipList()
    if self.listView ~= nil then
        self.listView:removeFromParent()
    end
    --列表背景
    self.listView = cc.ui.UIListView.new {
        bgColor = cc.c4b(100, 100, 100, 255),
        -- bgColor = cc.c4b(0, 0, 0, 0),
        viewRect = cc.rect(0, 0, 700, 600),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
    }
    --武器列表总背景
    self.weaponList:addChild(self.listView,0)
    for i=1,#self.equipArr do
        local v = self.equipArr[i]
        local item = self.listView:newItem()
        local content = display.newNode()
        -- 武器附加属性数组
        local equipAttributeArr = EquipConfig:getInstance():getEquipAttributeList(v.templateId)
        -- 装备图片
        local img = MMUISimpleUI:getInstance():getEquipBox(v.type,v.icon)
        content:addChild(img)
        local h = img:getContentSize().height + #equipAttributeArr * 40
        -- 设置长度
        content:setContentSize(700, h)
        -- 装备图片位置
        local y = content:getContentSize().height - img:getContentSize().height
        img:setPosition(0 ,y)
        --装备名称
        local lbl_name = cc.ui.UILabel.new(
                {text = v.name,
                size = 26,
                align = cc.ui.TEXT_ALIGN_LEFT,
                color = display.COLOR_WHITE})
        lbl_name:addTo(content)
        --装备名字位置
        local name_y = content:getContentSize().height - lbl_name:getContentSize().height / 2
        lbl_name:setPosition(img:getContentSize().width + 50 ,name_y)
        --等级
        local lbl_level = cc.ui.UILabel.new(
                {text = "LV:"..v.level,
                size = 26,
                align = cc.ui.TEXT_ALIGN_LEFT,
                color = display.COLOR_WHITE})
        lbl_level:addTo(content)
        --装备等级位置
        lbl_level:setPosition(img:getContentSize().width + 50 ,name_y - 50)
        --
        local btn = ccui.Button:create("")
        btn:loadTextureNormal("btn_blue.png",ccui.TextureResType.plistType)
        btn:setTitleFontSize(26)
        btn:setTitleText("装备")
        btn:setTag(i)
        btn:setPosition(content:getContentSize().width - btn:getContentSize().width / 2, content:getContentSize().height - 50)
        btn:addTo(content)
        btn:addTouchEventListener(handler(self,self.onLoad))

        for j=1,#equipAttributeArr do
            local attribute = equipAttributeArr[j]
            --属性名称
            local lbl_attributeName = cc.ui.UILabel.new(
                    {text = attribute.name,
                    size = 26,
                    align = cc.ui.TEXT_ALIGN_LEFT,
                    color = display.COLOR_WHITE})
            lbl_attributeName:setPosition(150, name_y - 100 - (j - 1)*40)
            lbl_attributeName:addTo(content)
            -- 值
            local lbl_attributeValue = cc.ui.UILabel.new(
                    {text = attribute.value,
                    size = 26,
                    align = cc.ui.TEXT_ALIGN_RIGHT,
                    color = display.COLOR_WHITE})
            lbl_attributeValue:setPosition(450, name_y - 100 - (j - 1)*40)
            lbl_attributeValue:addTo(content)
            -- if j == #equipAttributeArr then
            --     lbl_attributeName:setColor(cc.c4b(255, 0, 0, 255))
            --     lbl_attributeValue:setColor(cc.c4b(255, 0, 0, 255))
            -- end
        end

        item:addContent(content)
        item:setItemSize(700, h)
        self.listView:addItem(item)
    end
    self.listView:reload()
end

--装备按钮回调
--sender 按钮本身
--eventType 事件类型
function GatherWeaponView:onLoad(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        local clickInfo = self.equipArr[sender:getTag()]
        -- 身上装备
        local equip = self.hero:getEquipsByType(self.equipType)
        -- 要穿的装备
        self.model.equip = clickInfo
        if equip == nil then
            -- 穿装备 
            GatherService:getInstance():sendDress(clickInfo.objId, self.hero.heroid)
        else
            -- 是否要先脱装备再穿装备
            self.model.auto = true
            -- 要自动装备的装备实例id
            self.model.objId = clickInfo.objId
            -- 要自动装备的英雄实例id
            self.model.heroid = self.hero.heroid
            -- 要脱的装备
            self.model.unEquip = equip
            -- 拖装备 
            GatherService:getInstance():sendUndress(equip.objId, self.hero.heroid)
        end
        -- print("装备按钮回调"..clickInfo.name)
    end
end

--卸下按钮回调
--sender 按钮本身
--eventType 事件类型
function GatherWeaponView:onUnload(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        -- print("卸下按钮回调")
        -- 身上装备
        local equip = self.hero:getEquipsByType(self.equipType)
        if equip ~= nil then
            -- 要脱的装备
            self.model.unEquip = equip
            -- 拖装备 
            GatherService:getInstance():sendUndress(equip.objId, self.hero.heroid)
        end
    end
end

--返回到英雄详情按钮回调
--sender 按钮本身
--eventType 事件类型
function GatherWeaponView:onBack(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
    	self:hideView()
        self.parent.heroInfoView:setData()
        self.parent.heroInfoView:showView()
    end
end

-- 显示界面
function GatherWeaponView:showView()
	self.view:setVisible(true)
end

-- 隐藏界面
function GatherWeaponView:hideView()
	self.view:setVisible(false)
end