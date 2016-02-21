--
-- Author: oyhc
-- Date: 2015-12-16 21:40:16
-- 头像ui
MMUISimpleUI = class("MMUISimpleUI")

local instance = nil

-- 获取单例
-- 返回值(单例)
function MMUISimpleUI:getInstance()
	if instance == nil then
		instance = MMUISimpleUI.new()
	end
	return instance
end
--构造
--返回值(无)
function MMUISimpleUI:ctor()
	-- self:init()
end

--初始化
--返回值(无)
function MMUISimpleUI:init()

end

function MMUISimpleUI:getItmeById(id)
    local config = ItemTemplateConfig:getInstance():getItemTemplateByID(id)
    print("config=",config)
    return self:getItem(config.it_quality,config.it_icon) 
end

-- 获取物品ui
-- quality 物品品质
-- resName 装备在资源中的名字
function MMUISimpleUI:getItem(quality,resName)
    -- 物品背景
    local itemBox = MMUISprite:getInstance():create("#item_box.png")
    itemBox:setAnchorPoint(0,0)
    -- 装备图标
    local icon = nil
    if quality == QUALITY.white then --白色
        icon = display.newSprite("#tool_1.png",ccui.TextureResType.plistType)
    elseif quality == QUALITY.green then --绿色
        icon = display.newSprite("#tool_2.png",ccui.TextureResType.plistType)
    elseif quality == QUALITY.blue then --蓝色
        icon = display.newSprite("#tool_3.png",ccui.TextureResType.plistType)
    elseif quality == QUALITY.purple then --紫色
        icon = display.newSprite("#tool_4.png",ccui.TextureResType.plistType)
    elseif quality == QUALITY.orange then --橙色
        icon = display.newSprite("#tool_5.png",ccui.TextureResType.plistType)
    else
        print(quality .. "没有这个品质")
        return
    end
    -- icon:setScale(1.5)
    icon:setAnchorPoint(0,0)
    icon:setTag(100)
    icon:setPosition(itemBox:getContentSize().width / 2 - icon:getContentSize().width / 2, itemBox:getContentSize().height / 2 - icon:getContentSize().height / 2)
    itemBox:addChild(icon)
    -- 物品图标
    if resName ~= nil then
        local item = display.newSprite("#" .. resName..".png",ccui.TextureResType.plistType)
        item:setAnchorPoint(0,0)
        item:setTag(101)
        item:setPosition(itemBox:getContentSize().width / 2 - item:getContentSize().width / 2, itemBox:getContentSize().height / 2 - item:getContentSize().height / 2)
        itemBox:addChild(item)
    else
        print("物品资源名字为空")
    end
    return itemBox
end

-- 获取头像ui
function MMUISimpleUI:getHead(hero)
    -- 头像id
    local headID = HeroFaceConfig:getInstance():getHeroFaceByID(hero.image)
    -- 头像
    local img_head = display.newSprite(ResPath:getInstance():getHeroHeadPath(headID))

    -- 头像背景
    local headBG = display.newSprite(ResPath:getInstance():getHeadQualityPath(hero.quality))
    headBG:setAnchorPoint(0,0)
    img_head:addChild(headBG)

    return img_head
end

-- 获取装备框ui
-- equipType 装备类型
-- resName 装备在资源中的名字
function MMUISimpleUI:getEquipBox(equipType,resName,target,callback)
    -- 装备背景
    local equipBG = MMUISprite:getInstance():create("#lord_icon_box.png",callback,target)
    equipBG:setAnchorPoint(0,0)
    if resName ~= nil then
        -- 获取装备ui
        self:getEquip(equipBG,resName)
    else
        -- 装备图标
        local icon = nil
        if equipType == EQUIP.weapon then --武器
            icon = display.newSprite("#icon_weapons.png",ccui.TextureResType.plistType)
        elseif equipType == EQUIP.clothes then --衣服
            icon = display.newSprite("#icon_clothes.png",ccui.TextureResType.plistType)
        elseif equipType == EQUIP.belt then --腰带
            icon = display.newSprite("#icon_belt.png",ccui.TextureResType.plistType)
        elseif equipType == EQUIP.gauntlet then --护腕
            icon = display.newSprite("#icon_gauntlet.png",ccui.TextureResType.plistType)
        elseif equipType == EQUIP.trousers then --裤子
            icon = display.newSprite("#icon_trousers.png",ccui.TextureResType.plistType)
        elseif equipType == EQUIP.shoes then --鞋子
            icon = display.newSprite("#icon_shoes.png",ccui.TextureResType.plistType)
        else
            print(equipType .. "装备类型不对")
            return
        end
        icon:setAnchorPoint(0,0)
        icon:setTag(100)
        icon:setPosition(equipBG:getContentSize().width / 2 - icon:getContentSize().width / 2, equipBG:getContentSize().height / 2 - icon:getContentSize().height / 2)
        equipBG:addChild(icon)
    end
    return equipBG
end

-- 获取装备ui
-- equipBox 装备框
-- resName 装备在资源中的名字
function MMUISimpleUI:getEquip(equipBox,resName)
    -- display.addSpriteFrames("equip/equip.plist", "equip/equip.png", function()
        if resName ~= nil then
            local icon = equipBox:getChildByTag(100)
            if icon ~= nil then
                icon:removeFromParent()
            end
            -- 装备
            local equip = display.newSprite("#" .. resName..".png",ccui.TextureResType.plistType)
            equip:setAnchorPoint(0,0)
            equip:setTag(101)
            equip:setPosition(equipBox:getContentSize().width / 2 - equip:getContentSize().width / 2, equipBox:getContentSize().height / 2 - equip:getContentSize().height / 2)
            equipBox:addChild(equip)
        else
            local icon1 = equipBox:getChildByTag(101)
            if icon1 ~= nil then
                icon1:removeFromParent()
            end
        end
    -- end)
end

-- 添加武器小图标
-- equipBox 装备框
-- equipType 装备类型
function MMUISimpleUI:addEquipIcon(equipBox,equipType)
    -- 装备图标
    local icon = nil
    if equipType == EQUIP.weapon then --武器
        icon = display.newSprite("#icon_weapons.png",ccui.TextureResType.plistType)
    elseif equipType == EQUIP.clothes then --衣服
        icon = display.newSprite("#icon_clothes.png",ccui.TextureResType.plistType)
    elseif equipType == EQUIP.belt then --腰带
        icon = display.newSprite("#icon_belt.png",ccui.TextureResType.plistType)
    elseif equipType == EQUIP.gauntlet then --护腕
        icon = display.newSprite("#icon_gauntlet.png",ccui.TextureResType.plistType)
    elseif equipType == EQUIP.trousers then --裤子
        icon = display.newSprite("#icon_trousers.png",ccui.TextureResType.plistType)
    elseif equipType == EQUIP.shoes then --鞋子
        icon = display.newSprite("#icon_shoes.png",ccui.TextureResType.plistType)
    else
        print(equipType .. "装备类型不对")
        return
    end
    icon:setAnchorPoint(0,0)
    icon:setTag(100)
    icon:setPosition(equipBox:getContentSize().width / 2 - icon:getContentSize().width / 2, equipBox:getContentSize().height / 2 - icon:getContentSize().height / 2)
    equipBox:addChild(icon)
end

-- 获取技能ui
-- resName 技能资源中的名字
function MMUISimpleUI:addSkill(resName)
    local skillIcon = nil
    if resName ~= nil then
        skillIcon = display.newSprite("#" .. resName..".png",ccui.TextureResType.plistType)
    else
        print("技能图标资源名字是空的")
        return
    end
    if skillIcon == nil then
        print("找不到名字为"..resName.."的技能")
        return
    end
    skillIcon:setAnchorPoint(0,0)
    skillIcon:setTag(100)
    return skillIcon
end

--获取领主技能icon
function MMUISimpleUI:getLordSkillIcon(skillId)
    local config = LordSkillConfig:getInstance():getConfig(skillId)
    if config ~= nil then
        local icon = display.newSprite("#" .. config.ls_icon .. ".png")
        return icon
    end
    print("找不到领主技能图标")
end

