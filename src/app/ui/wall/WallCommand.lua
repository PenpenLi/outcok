
--[[
    jinyan.zhang
    城墙
--]]

WallCommand = class("WallCommand")
local instance = nil

--构造
--返回值(无)
function WallCommand:ctor()

end

--打开界面
--uiType UI类型
--data 数据
--返回值(无)
function WallCommand:open(uiType,data)
    self.view = WallView.new(uiType,data)
    self.view:addToLayer(GAME_ZORDER.UI)
end 

--关闭界面
--返回值(无)
function WallCommand:close()
    if self.view ~= nil then
        self.view:removeFromLayer()
        self.view = nil
    end
end

--获取单例
--返回值(单例)
function WallCommand:getInstance()
    if instance == nil then
        instance = WallCommand.new()
    end
    return instance
end

--灭火结果
function WallCommand:delFireRes()
    if self.view ~= nil then
        self.view:delFireRes()
    end
end

--修复结果
function WallCommand:repairRes()
    if self.view ~= nil then
        self.view:repairRes()
    end
end

--删除驻守的英雄结果
function WallCommand:delHeroRes()
    if self.view ~= nil and self.view.garrisionView ~= nil then
        self.view.garrisionView:delHeroRes()
    end
end

--添加驻守的英雄结果
function WallCommand:addHeroRes()
    if self.view ~= nil and self.view.garrisionView ~= nil and self.view.garrisionView.addHeroView then
        self.view.garrisionView.addHeroView:addHeroRes()
    end
end

--更新城防值UI
function WallCommand:updateDefValueUI()
    if self.view ~= nil then
        self.view:updateDefValueUI()
    end
end

--更新修复城墙冷却时间UI
function WallCommand:updateRepairCoolTimeUI()
    if self.view ~= nil then
        self.view:updateRepairCoolTimeUI()
    end
end

--收到通知城墙着火
function WallCommand:recvNoticeWallFireRes()
    if self.view ~= nil then
        self.view:recvNoticeWallFireRes()
    end
end



