--
-- Author: oyhc
-- Date: 2015-12-02 16:55:23
--

GatherSkillView = class("GatherSkillView")

--构造
--uiType UI类型
--data 数据
function GatherSkillView:ctor(theSelf)
	self.parent = theSelf
	self.view = Common:seekNodeByName(self.parent.root,"skill")
	self:init()
end

--初始化
--返回值(无)
function GatherSkillView:init()
    self.model = GatherModel:getInstance()
    -- 返回按钮
    self.btn_back = Common:seekNodeByName(self.view,"btn_back")
    self.btn_back:addTouchEventListener(handler(self,self.onBack))
    -- 标题
    local lbl_name = Common:seekNodeByName(self.view,"lbl_name")
    lbl_name:setString("技能")
    -- 技能名称
    self.lbl_skillName = Common:seekNodeByName(self.view,"lbl_skillName")
    self.lbl_skillName:setString("技能：")
    -- 技能介绍
    self.lbl_description = Common:seekNodeByName(self.view,"lbl_description")
    self.lbl_description:setString("技能介绍")
    -- 刷新按钮
    self.btn_refresh = Common:seekNodeByName(self.view,"btn_refresh")
    self.btn_refresh:addTouchEventListener(handler(self,self.onRefresh))
    self.btn_refresh:setTitleText("刷新技能")
    -- 新技能文本
    local lbl_newSkill = Common:seekNodeByName(self.view,"lbl_newSkill")
    lbl_newSkill:setString("新技能：")
    --新技能
    self.newSkill = Common:seekNodeByName(self.view,"newSkill")
    self.newSkill:setVisible(false)
    self:createNewSkill()
end

-- 创建新技能
function GatherSkillView:createNewSkill()
    -- 技能名称
    self.lbl_newSkillName = Common:seekNodeByName(self.newSkill,"lbl_skillName")
    self.lbl_newSkillName:setString("技能：新狂暴")
    -- 技能介绍
    self.lbl_newDescription = Common:seekNodeByName(self.newSkill,"lbl_description")
    self.lbl_newDescription:setString("新技能介绍")
    -- 替换按钮
    self.btn_replace = Common:seekNodeByName(self.newSkill,"btn_replace")
    self.btn_replace:addTouchEventListener(handler(self,self.onReplace))
    self.btn_replace:setTitleText("替换技能")
end

function GatherSkillView:setData(hero)
    self.hero = hero
    local skill = self.hero.skill
    local icon = MMUISimpleUI:getInstance():addSkill(skill.icon)
    icon:setPosition(123,display.height - 280)
    self.view:addChild(icon)
    -- 技能名称
    self.lbl_skillName:setString("技能："..skill.name)
    -- 技能介绍
    self.lbl_description:setString(skill.des)
end

function GatherSkillView:setNewSkillData()
    -- 显示刷新的技能
    self.newSkill:setVisible(true)
    -- 删除技能头像
    local oldIcon = self.newSkill:getChildByTag(100)
    if oldIcon ~= nil then
        oldIcon:removeFromParent()
    end
    local skill = self.model.newSkill
    local icon = MMUISimpleUI:getInstance():addSkill(skill.icon)
    icon:setPosition(123,450)
    self.newSkill:addChild(icon)
    self.newSkill:setVisible(true)
    -- 技能名称
    self.lbl_newSkillName:setString("技能："..skill.name)
    -- 技能介绍
    self.lbl_newDescription:setString(skill.des)
end

function GatherSkillView:setOldSkillData()
    -- 隐藏刷新的技能
    self.newSkill:setVisible(false)
    -- 删除技能头像
    local oldIcon = self.newSkill:getChildByTag(100)
    if oldIcon ~= nil then
        oldIcon:removeFromParent()
    end
    local skill = self.hero.skill
    local icon = MMUISimpleUI:getInstance():addSkill(skill.icon)
    icon:setPosition(123,display.height - 280)
    self.view:addChild(icon)
    -- 技能名称
    self.lbl_skillName:setString("技能："..skill.name)
    -- 技能介绍
    self.lbl_description:setString(skill.des)
end

--替换技能按钮回调
--sender 按钮本身
--eventType 事件类型
function GatherSkillView:onReplace(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
    	UIMgr:getInstance():openUI(UITYPE.PROP_BOX, {type=PROP_BOX_TYPE.COMMON,text="是否确定替换技能？",
            callback=handler(self, self.onSureReplace),sureBtnText=CommonStr.SURE,cancelBtnText=CommonStr.CANCEL
        })
    end
end

-- 确定刷新技能回调
function GatherSkillView:onSureReplace()
    GatherService:getInstance():sendChangeSkill(self.hero.heroid)
end

--刷新技能按钮回调
--sender 按钮本身
--eventType 事件类型
function GatherSkillView:onRefresh(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
    	UIMgr:getInstance():openUI(UITYPE.PROP_BOX, {type=PROP_BOX_TYPE.COMMON,text="刷新技能需要花费金币"..CommonConfig:getInstance():refreshHeroSkill().."，确定要刷新？",
            callback=handler(self, self.onSureRefresh),sureBtnText=CommonStr.SURE,cancelBtnText=CommonStr.CANCEL
        })
    end
end

-- 确定刷新技能回调
function GatherSkillView:onSureRefresh()
    local pos = CityBuildingModel:getInstance():getBuildInfoByType(BuildType.PUB).pos
    GatherService:getInstance():sendRefreshSkill(pos,self.hero.heroid)
end

--返回到英雄详情按钮回调
--sender 按钮本身
--eventType 事件类型
function GatherSkillView:onBack(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
    	self:hideView()
        self.parent.heroInfoView:setData()
        self.parent.heroInfoView:showView()
    end
end

-- 显示界面
function GatherSkillView:showView()
	self.view:setVisible(true)
end

-- 隐藏界面
function GatherSkillView:hideView()
	self.view:setVisible(false)
end