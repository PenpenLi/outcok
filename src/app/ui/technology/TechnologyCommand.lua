
--[[
    hejun
    科技界面
--]]

TechnologyCommand = class("TechnologyCommand")
local instance = nil

--获取单例
--返回值(单例)
function TechnologyCommand:getInstance()
    if instance == nil then
        instance = TechnologyCommand.new()
    end
    return instance
end

--构造
--返回值(无)
function TechnologyCommand:ctor()

end

--uiType UI类型
--data 数据
--返回值(无)
function TechnologyCommand:open(uiType,data)
    self.view = TechnologyMenuView.new(uiType,data)
    self.view.baseView:addToLayer(GAME_ZORDER.UI)
end

--
function TechnologyCommand:updataTechUI()
    if self.view ~= nil then
        self.view.technologyView:updataTechUI()
    end
end

--关闭登录界面
--返回值(无)
function TechnologyCommand:close()
    if self.view ~= nil then
        self.view.baseView:removeFromLayer()
        self.view = nil
    end
end