
--[[
	jinyan.zhang
	城外界面
--]]

CityOutCommand = class("CityOutCommand")
local instance = nil

--构造
--返回值(无)
function CityOutCommand:ctor()

end

--打开城内UI
--uiType UI类型
--data 数据
--返回值(无)
function CityOutCommand:open(uiType,data)
	self.view = CityOutView.new(uiType,data)
	self.view:addToLayer(GAME_ZORDER.UI)
end 

--关闭城内UI
function CityOutCommand:close()
	if self.view ~= nil then
		self.view:removeFromLayer()
		self.view = nil
	end
end

--获取单例
--返回值(单例)
function CityOutCommand:getInstance()
	if instance == nil then
		instance = CityOutCommand.new()
	end
	return instance
end

--更新行军UI
--data 数据
--返回值(无)
function CityOutCommand:updateMarchUI(data)
	if self.view ~= nil then
		self.view:updateMarchProcess(data)
		if data.type == MarchOperationType.reconnaissance then
			self.view:addMarchArms(data,true)
		else
			self.view:addMarchArms(data,false)
		end
	end
end

--行军返回
--data 数据
--marchArmsInfo 行军中的部队信息
--返回值(无)
function CityOutCommand:marchReturnResult(data,marchArmsInfo)
	if self.view ~= nil then
		self.view:marchReturnResult(data,marchArmsInfo)
	end
end

--完成行军
--data 数据
--返回值(无)
function CityOutCommand:finishMarchingResult(data)
	if self.view ~= nil then
		self.view:finishMarchingResult(data)
	end
end

--更新邮件数量
--num 数量
--返回值(无)
function CityOutCommand:updateMailNum(num)
	if self.view ~= nil then
		self.view:updateMailNum(num)
	end
end

--开关按钮触摸
--able(true:开启,false:关闭)
function CityOutCommand:setBtnTouchAble(able)
	if self.view ~= nil then
		self.view:setBtnTouchAble(able)
	end
end

--更新战斗力
function CityOutCommand:updateBattlePower()
	if self.view ~= nil then
        self.view:updateBattlePower()
    end
end

--更新UI
--返回值(无)
function CityOutCommand:updateUI()
    if self.view ~= nil then
        self.view:updateUI()
    end
end

--更新粮食UI 
function CityOutCommand:updateFoodUI()
    if self.view ~= nil then
        self.view:updateFoodUI()
    end
end



