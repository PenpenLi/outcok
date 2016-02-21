
--[[
    jinyan.zhang
    完成英雄训练
--]]

FinishHeroTrainCommand = class("FinishHeroTrainCommand")
local instance = nil

--构造
--返回值(无)
function FinishHeroTrainCommand:ctor()

end

--打开界面
--uiType UI类型
--data 数据
--返回值(无)
function FinishHeroTrainCommand:open(uiType,data)
    self.view = FinishHeroTrainView.new(uiType,data)
    self.view:addToLayer(GAME_ZORDER.UI)
end 

--关闭界面
--返回值(无)
function FinishHeroTrainCommand:close()
    if self.view ~= nil then
        self.view:removeFromLayer()
        self.view = nil
    end
end

--获取单例
--返回值(单例)
function FinishHeroTrainCommand:getInstance()
    if instance == nil then
        instance = FinishHeroTrainCommand.new()
    end
    return instance
end

