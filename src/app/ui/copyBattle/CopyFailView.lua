
--[[
	jinyan.zhang
	副本失败界面
--]]

CopyFailView = class("CopyFailView",function()
	return display.newLayer()
end)

function CopyFailView:ctor(parent)
	self.parent = parent
	self:init()
end

function CopyFailView:init()
    self.view = Common:seekNodeByName(self.parent.root,"pan_fail")
    --返回副本列表按钮
    self.btnClose = Common:seekNodeByName(self.view,"btn_close")
    self.btnClose:addTouchEventListener(handler(self,self.onClose))
    self.btnClose:setTitleText(Lan:lanText(122, "返回副本地图"))
   	--建议
    self.labAdvice = Common:seekNodeByName(self.view,"adviceLab")
    self.labAdvice:setString(Lan:lanText(124, "建议"))
    --培养英雄
    self.labHero = Common:seekNodeByName(self.view,"cultureHeroLab")
    self.labHero:setString(Lan:lanText(128, "培养英雄"))
     --培养英雄详情
    self.military_suggestionLab = Common:seekNodeByName(self.view,"military_suggestionLab")
    self.military_suggestionLab:setString(Lan:lanText(126, "更新英雄装备，带领合适兵种和刷出天赋更好的英雄进行培养。"))
    --高级士兵
    self.labArms = Common:seekNodeByName(self.view,"seniorSoldiersLab")
    self.labArms:setString(Lan:lanText(127, "高级士兵"))
    --高级士兵详情
    self.labPrivates_suggestion = Common:seekNodeByName(self.view,"privates_suggestionLab")
    self.labPrivates_suggestion:setString("训练高级士兵，提升部队战斗力。")
    --强化材料
    self.labStrengthen = Common:seekNodeByName(self.view,"strengthenLab")
    self.labStrengthen:setString(Lan:lanText(125, "强化材料"))
    --强化材料详情
    self.labHero_suggestion = Common:seekNodeByName(self.view,"hero_suggestionLab")
    self.labHero_suggestion:setString(Lan:lanText(129, "强化军事相关的科技树，提升部队战斗力。"))
end

function CopyFailView:showView()
	self.view:setVisible(true)
end

function CopyFailView:updateUI()
	
end

--返回副本列表钮回调
--sender按钮本身
--eventType 事件类型
--返回值(无)
function CopyFailView:onClose(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        UIMgr:getInstance():closeUI(self.uiType)
        SceneMgr:getInstance():fromCopyGoToCity()
    end
end


