
--[[
    jinyan.zhang
    战斗PVP
--]]

PvPBattleResultCommand = class("PvPBattleResultCommand")
local instance = nil

--构造
--返回值(无)
function PvPBattleResultCommand:ctor()
    
end

--uiType UI类型
--data 数据
--返回值(无)
function PvPBattleResultCommand:open(uiType,data)
    self.view = PvPBattleResultView.new(uiType,data)
    self.view:addToLayer(GAME_ZORDER.UI)
end 

--关闭登录界面
--返回值(无)
function PvPBattleResultCommand:close()
    if self.view ~= nil then
        self.view:removeFromLayer()
        self.view = nil
    end
end

--获取单例
--返回值(单例)
function PvPBattleResultCommand:getInstance()
    if instance == nil then
        instance = PvPBattleResultCommand.new()
    end
    return instance
end

--设置兵力
--camp 阵营
--power 兵力
--返回值(无)
function PvPBattleResultCommand:setPower(camp,power)
    if camp == CAMP.ATTER then
        self.view:setAtterPower(power)
    elseif camp == CAMP.DEFER then
        self.view:setDeferPower(power)
    end
end


