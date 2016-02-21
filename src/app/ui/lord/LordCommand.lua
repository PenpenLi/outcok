--
-- Author: hejun
-- Date: 2016-01-11 16:38:07
--领主界面

LordCommand = class("LordCommand")
local instance = nil

--构造
--返回值(空)
function LordCommand:ctor()

end

--打开loading界面
--uiType UI类型
--data 数据
function LordCommand:open(uiType,data)
    self.view = LordView.new(uiType,data)
    self.view.baseView:addToLayer(GAME_ZORDER.UI)
end

--关闭Loading界面
function LordCommand:close()
    if self.view ~= nil then
        self.view.baseView:removeFromLayer()
        self.view = nil
    end
end

-- 更新天赋ui
function LordCommand:updataTalentUI()
    if self.view ~= nil then
        self.view.lordTalentView:updataTalentUI()
    end
end

-- 重置天赋
function LordCommand:resetTalentPoint()
    if self.view ~= nil then
        self.view.lordTalentView:resetTalentPoint()
    end
end

--获取单例
--返回值(单例)
function LordCommand:getInstance()
    if instance == nil then
        instance = LordCommand.new()
    end
    return instance
end