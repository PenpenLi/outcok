
--[[
    jinyan.zhang
    城堡类
--]]

AICastle = class("AICastle",Monomer)

--构造
--lv 城堡等级
--pos 位置
--camp 阵营
--返回值(无)
function AICastle:ctor(lv,pos,camp)
    self.lv = lv
    self:setPosition(pos)
    self.super.ctor(self,nil,SOLDIER_TYPE.CASTLE,nil,camp)
end

--初始化
--返回值(无)
function AICastle:init()
    self.sprite = display.newSprite("citybuilding/chenbao01.png")
    self:addChild(self.sprite)
    self.attack_distance = 0
    self.moveSpeed = 0
    self.beRectSize = self.sprite:getContentSize()
end

--加入到舞台后会调用这个接口
--返回值(无)
function AICastle:onEnter()
    --MyLog("AICastle onEnter()")
end

--离开舞台后会调用这个接口
--返回值(无)
function AICastle:onExit()
    --MyLog("AICastle onExit()")
end

--从内存释放后会调用这个接口
--返回值(无)
function AICastle:onDestroy()
    --MyLog("AICastle onDestroy()")
end 

--每帧更新城堡逻辑
--dt 时间
--返回值(无)
function AICastle:update(dt)
   
end











