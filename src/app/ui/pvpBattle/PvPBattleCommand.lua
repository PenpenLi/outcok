
--[[
    jinyan.zhang
    战斗PVP
--]]

PVPBattleCommand = class("PVPBattleCommand")
local instance = nil

--构造
--返回值(无)
function PVPBattleCommand:ctor()
    
end

--uiType UI类型
--data 数据
--返回值(无)
function PVPBattleCommand:open(uiType,data)
    self.view = PVPBattleView.new(uiType,data)
    self.view:addToLayer(GAME_ZORDER.UI)
end 

--关闭登录界面
--返回值(无)
function PVPBattleCommand:close()
    if self.view ~= nil then
        self.view:removeFromLayer()
        self.view = nil
    end
end

--获取单例
--返回值(单例)
function PVPBattleCommand:getInstance()
    if instance == nil then
        instance = PVPBattleCommand.new()
    end
    return instance
end

--设置兵力
--camp 阵营
--power 兵力
--返回值(无)
function PVPBattleCommand:setPower(camp,power)
    if camp == CAMP.ATTER then
        self.view:setAtterPower(power)
    elseif camp == CAMP.DEFER then
        self.view:setDeferPower(power)
    end
end

--关闭PVP界面
--返回值(无)
function PVPBattleCommand:closePvpView()
    if self.view ~= nil then
        self.view:close()
    end
end


