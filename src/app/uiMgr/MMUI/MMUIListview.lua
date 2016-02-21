
--[[
	jinyan.zhang
	列表
--]]

MMUIListview = class("MMUIListview",function()
	return display.newLayer()
end)

--列表拖动方向
ListDirection =
{
    NONE = 0,        --无
    VERTICAL = 1,    --垂直
    HORIZONTAL = 2,  --水平
    BOTH = 3,         --两者都
}

--列表内部结点对齐方式
Gravity = 
{
    LEFT = 0,      			--左对齐
    RIGHT = 1,    			--右对齐
    CENTER_HORIZONTAL = 2,  --中心水平对齐
    TOP = 3,  				--顶部
    BOTTOM = 4, 			--底部
    CENTER_VERTICAL = 5     --中心垂直
}

--背景颜色类型
BackGroundColorType = 
{
    NONE = 0,    --背景无颜色
    SOLID = 1,   --背景是实体颜色 
    GRADIENT = 2 --背景是渐变色
}

function MMUIListview:ctor(wide,high,listView)
	self.wide = wide
	self.high = high
	self.listview = listView
	self:init()
end

function MMUIListview:init()
	if self.listview == nil then
		--创建列表
		self.listview = ccui.ListView:create()
		--添加到舞台上
		self:addChild(self.listview)
		--设置大小
		self.listview:setContentSize(cc.size(self.wide, self.high))	
		--默认上下拖动
		self:setDirection(ListDirection.VERTICAL)
		--开启拖动
		self:setTouchEnabled(true)
		--开启回弹
		self.listview:setBounceEnabled(true)
		--使能九宫格背景
		self.listview:setBackGroundImageScale9Enabled(true)
		--设置对齐方式
		self:setGravity(Gravity.CENTER_VERTICAL)
		--设置列表背景颜色
		self:setBackGroundType(BackGroundColorType.SOLID)
		--设置列表每项间距
		self:setItemsMargin(0)
	end
end

--重新设置大小
function MMUIListview:setContentSize(wide,high)
	self.listview:setContentSize(cc.size(wide,high))	
end

--设置列表每项间距
function MMUIListview:setItemsMargin(margin)
	self.listview:setItemsMargin(margin)
end

--注册回调
function MMUIListview:addTouchEventListener(callback,obj)
	if callback == nil then
		return
	end

	local arry = self.listview:getItems()
	for k,v in pairs(arry) do
		v:setTouchEnabled(true)
		v:addTouchEventListener(function(sender,eventType)
			local index = self.listview:getIndex(sender)+1
			callback(obj,sender,eventType,index)
		end)
	end
end

--获取列表
function MMUIListview:getListView()
	return self.listview
end

--设置列表背景颜色类型
function MMUIListview:setBackGroundType(colorType,color)
	color = color or cc.c3b(255, 0, 255)
	--设置背景颜色类型
	self.listview:setBackGroundColorType(colorType)
	--设置背景颜色
    self.listview:setBackGroundColor(color)
end

--关闭列表背景颜色
function MMUIListview:closeBgColor()
	self.listview:setBackGroundColorType(BackGroundColorType.NONE)
end

--开启/关闭触摸
function MMUIListview:setTouchEnabled(able)
	local arry = self.listview:getItems()
	for k,v in pairs(arry) do
		v:setTouchEnabled(able)
	end
	self.listview:setTouchEnabled(able)
end

--设置拖动方向
function MMUIListview:setDirection(dir)
	self.listview:setDirection(dir)
end

--设置对齐方式
function MMUIListview:setGravity(value)
	self.listview:setGravity(value)
end

--设置坐标
function MMUIListview:setPosition(x,y)
	self.listview:setPosition(x,y)
end

--插入一项数据
function MMUIListview:pushBackCustomItem(node)
	if node == nil then
		return
	end

	local custom_item = ccui.Layout:create()
    custom_item:setContentSize(node:getContentSize())
    custom_item:addChild(node)
    self.listview:pushBackCustomItem(custom_item)
    node:setPosition(cc.p(custom_item:getContentSize().width/2.0, custom_item:getContentSize().height/2.0))
end

--刷新列表
function MMUIListview:refreshView()
	self.listview:refreshView()
end

--删除所有数据项
function MMUIListview:removeAllItems()
	self.listview:removeAllItems()
end

--删除指定项
function MMUIListview:removeItem(index)
	self.listview:removeItem(index)
end

--获取指定项
function MMUIListview:getItem(index) 
	return self.listview:getItem(index)
end

--获取下标
function MMUIListview:getIndex(item)
	return self.listview:getIndex(item)
end

function MMUIListview:onEnter()

end

function MMUIListview:onExit()

end




