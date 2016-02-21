
--[[
    hejun
    副本战斗界面
--]]

CopyBattleCommand = class("CopyBattleCommand")
local instance = nil

--构造
--返回值(无)
function CopyBattleCommand:ctor()

end

--打开副本战斗界面
--uiType UI类型
--data 数据
--返回值(无)
function CopyBattleCommand:open(uiType,data)
    self.view = CopyBattleView.new(uiType,data)
    self.view:addToLayer(GAME_ZORDER.UI)
end 

--关闭集结界面
--返回值(无)
function CopyBattleCommand:close()
    if self.view ~= nil then
        self.view:removeFromLayer()
        self.view = nil
    end
end

--获取单例
--返回值(单例)
function CopyBattleCommand:getInstance()
    if instance == nil then
        instance = CopyBattleCommand.new()
    end
    return instance
end

--显示胜利界面
--返回值(无)
function CopyBattleCommand:showWinView()
    self.view:showWinView()
end

--显示失败界面
--返回值(无)
function CopyBattleCommand:showFailView()
    self.view:showFailView()
end

--设置兵力
--camp 阵营
--power 兵力
--返回值(无)
function CopyBattleCommand:setPower(camp,power)
    if camp == CAMP.ATTER then
        self.view:setAtterPower(power)
    elseif camp == CAMP.DEFER then
        self.view:setDeferPower(power)
    end
end

