
--[[
    hejun
    英雄训练界面
--]]

HeroTrainCommand = class("HeroTrainCommand")
 local instance = nil

--构造
--返回值(无)
function HeroTrainCommand:ctor()

end

--打开logo界面
--uiType UI类型
--data 数据
--返回值(无)
function HeroTrainCommand:open(uiType,data)
    self.view = HeroTrainView.new(uiType,data)
    self.view:addToLayer(GAME_ZORDER.UI)
end

--关闭logo界面
--返回值(无)
function HeroTrainCommand:close()
    if self.view ~= nil then
        self.view:removeFromLayer()
        self.view = nil
    end
end

--获取单例
--返回值(单例)
function HeroTrainCommand:getInstance()
    if instance == nil then
        instance = HeroTrainCommand.new()
    end
    return instance
end

--打开英雄训练列表
function HeroTrainCommand:createList()
    if self.view ~= nil then
        self.view:createList()
    end
end

--打开英雄训练列表
function HeroTrainCommand:showHeroList()
    if self.view ~= nil then
        self.view.newHeroTrain:showHeroList()
    end
end