
--[[
    jinyan.zhang
    建筑菜单界面
--]]

Build_menuCommand = class("Build_menuCommand")
local instance = nil

--构造
--返回值(无)
function Build_menuCommand:ctor()

end

--uiType UI类型
--data 数据
--返回值(无)
function Build_menuCommand:open(uiType,data)
    self.view = Build_menuView.new(uiType,data)
    self.view:addToLayer(GAME_ZORDER.UI)
end

--关闭登录界面
--返回值(无)
function Build_menuCommand:close()
    if self.view ~= nil then
        self.view:removeFromLayer()
        self.view = nil
    end
end

--获取单例
--返回值(单例)
function Build_menuCommand:getInstance()
    if instance == nil then
        instance = Build_menuCommand.new()
    end
    return instance
end

--获取建筑位置
--返回值(建筑位置)
function Build_menuCommand:getBuildingPos()
    if self.view ~= nil then
        return self.view:getBuildingPos()
    end
end

--更新生产资源加速UI
--返回值(无)
function Build_menuCommand:updateProcduResSpeed()
    if self.view ~= nil then
        self.view:updateProcduResSpeed()
    end
end

--更新城墙UI
--返回值(无)
function Build_menuCommand:updateWallPic()
    if self.view ~= nil then
        self.view:updateWallPic()
    end
end


