
--[[
    hejun
    瞭望塔界面
--]]

WatchTowerCommand = class("WatchTowerCommand")
local instance = nil

--构造
--返回值(无)
function WatchTowerCommand:ctor()

end

--打开集结界面
--uiType UI类型
--data 数据
--返回值(无)
function WatchTowerCommand:open(uiType,data)
    self.view = WatchTowerView.new(uiType,data)
    self.view:addToLayer(GAME_ZORDER.UI)
end

--关闭瞭望塔界面
--返回值(无)
function WatchTowerCommand:close()
    if self.view ~= nil then
        self.view:removeFromLayer()
        self.view = nil
    end
end

--更新瞭望塔详情界面
--data 详情数据
--返回值(无)
function WatchTowerCommand:updateWatchtowerList()
    if self.view ~= nil then
        self.view:updateWatchtowerList()
    end
end

--获取瞭望塔详情界面
--data 详情数据
--返回值(无)
function WatchTowerCommand:getWatchtowerDetail(info)
    if self.view ~= nil then
        self.view:getWatchtowerDetail(info)
    end
end

--获取单例
--返回值(单例)
function WatchTowerCommand:getInstance()
    if instance == nil then
        instance = WatchTowerCommand.new()
    end
    return instance
end

