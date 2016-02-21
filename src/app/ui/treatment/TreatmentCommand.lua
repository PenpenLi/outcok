
--[[
    hejun
    治疗界面
--]]

TreatmentCommand = class("TreatmentCommand")
local instance = nil

--构造
--返回值(无)
function TreatmentCommand:ctor()

end

--uiType UI类型
--data 数据
--返回值(无)
function TreatmentCommand:open(uiType,data)
    self.view = TreatmentView.new(uiType,data)
    self.view:addToLayer(GAME_ZORDER.UI)
end

--关闭登录界面
--返回值(无)
function TreatmentCommand:close()
    if self.view ~= nil then
        self.view:removeFromLayer()
        self.view = nil
    end
end

--获取单例
--返回值(单例)
function TreatmentCommand:getInstance()
    if instance == nil then
        instance = TreatmentCommand.new()
    end
    return instance
end

--设置兵力
--camp 阵营
--power 兵力
--返回值(无)
function TreatmentCommand:setPower(camp,power)
    if camp == CAMP.ATTER then
        self.view:setAtterPower(power)
    elseif camp == CAMP.DEFER then
        self.view:setDeferPower(power)
    end
end

