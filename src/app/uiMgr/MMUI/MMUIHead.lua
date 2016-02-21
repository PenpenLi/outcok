--
-- Author: oyhc
-- Date: 2015-12-16 21:40:16
-- 头像ui
MMUIHead = class("MMUIHead")

local instance = nil

-- 获取单例
-- 返回值(单例)
function MMUIHead:getInstance()
	if instance == nil then
		instance = MMUIHead.new()
	end
	return instance
end
--构造
--返回值(无)
function MMUIHead:ctor()
	-- self:init()
end

--初始化
--返回值(无)
function MMUIHead:init()

end

function MMUIHead:getHeadByHeadId(headID,quality)
    local img_head = display.newSprite(ResPath:getInstance():getHeroHeadPath(headID))
    -- 头像背景
    local headBG = display.newSprite(ResPath:getInstance():getHeadQualityPath(quality))
    headBG:setAnchorPoint(0,0)
    img_head:addChild(headBG)

    return img_head
end

-- hero hero
function MMUIHead:getHead(hero)
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

--获取英雄头像
function MMUIHead:getHeadById(id)
    local headID = HeroFaceConfig:getInstance():getHeroFaceByID(id)
    local img_head = display.newSprite(ResPath:getInstance():getHeroHeadPath(headID))

    return img_head
end

--领主头像
function MMUIHead:getMailLordHead(id)
    local info = LordHeadConfig:getInstance():getConfig(id)
    if info == nil then
        print("读取领主头像失败")
        return
    end

    local bg = display.newSprite("#propWin_itembox.png")
    local img = display.newSprite("#" .. info.lh_head .. ".png")
    img:setAnchorPoint(0,0)
    img:setPosition(15,15)
    bg:addChild(img)
    img:setScale(0.6)
    
    return bg
end 



