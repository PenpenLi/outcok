
--[[
	jinyan.zhang
	城内界面
--]]

CityCommand = class("CityCommand")
local instance = nil

--构造
--返回值(无)
function CityCommand:ctor()

end

--打开城内UI
--uiType UI类型
--data 数据
--返回值(无)
function CityCommand:open(uiType,data)
	self.view = CityView.new(uiType,data)
	self.view:addToLayer(GAME_ZORDER.UI)
end 

--关闭城内UI
function CityCommand:close()
	if self.view ~= nil then
		self.view:removeFromLayer()
		self.view = nil
	end
end

--获取单例
--返回值(单例)
function CityCommand:getInstance()
	if instance == nil then
		instance = CityCommand.new()
	end
	return instance
end

--开关按钮触摸
--able(true:开启,false:关闭)
function CityCommand:setBtnTouchAble(able)
	if self.view ~= nil then
		self.view:setBtnTouchAble(able)
	end
end

--更新邮件数量
--num 数量
--返回值(无)
function CityCommand:updateMailNum(num)
	if self.view ~= nil then
		self.view:updateMailNum(num)
	end
end

--更新物质(造兵)
--data 详情数据
--数量 
--返回值(无)
function CityCommand:updateBymakeSoldier(data,number)
    if self.view ~= nil then
        self.view:updateBymakeSoldier(data,number)
    end
end

--更新战斗力
function CityCommand:updateBattlePower()
	if self.view ~= nil then
        self.view:updateBattlePower()
    end
end

--更新UI
--返回值(无)
function CityCommand:updateUI()
    if self.view ~= nil then
        self.view:updateUI()
    end
end

--获取UI
function CityCommand:getView()
	return self.view
end

--创建第一个锤子的建造时间
--leftTime 剩余建造时间
--返回值(无)
function CityCommand:createFirstHammerBuildTime(leftTime)
	if self.view ~= nil then
        self.view:createFirstHammerBuildTime(leftTime)
    end
end

--删除第一个锤子的建造时间
--返回值(无)
function CityCommand:delFirstHammerBuildTime()
   	if self.view ~= nil then
        self.view:delFirstHammerBuildTime()
    end
end

--更新粮食UI 
function CityCommand:updateFoodUI()
    if self.view ~= nil then
        self.view:updateFoodUI()
    end
end





