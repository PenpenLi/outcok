
--[[
	jinyan.zhang
	调整滚动列表大小
--]]

MMUIAdjustScrollView = class("MMUIAdjustScrollView")

--设置滚动列表
function MMUIAdjustScrollView:setScrollView(scollview)
	self.scrollview = scollview
end

--设置滚动列表中的内容层(滚动列表中的所有东西都加在这个层上)
function MMUIAdjustScrollView:setContentLayer(layer)
	self.panContent = layer
end

--设置滚动列表的结束Y坐标
function MMUIAdjustScrollView:setEndY(endY)
	self.endY = endY
end

--调整滚动列表高度
function MMUIAdjustScrollView:adjustHigh()
	--总高度
    local totalHigh = self.panContent:getContentSize().height - self.endY
    local innerLayer = self.scrollview:getInnerContainer()
    local oldSize = self.panContent:getContentSize()
    if totalHigh < oldSize.height then
        totalHigh = oldSize.height
    end
    innerLayer:setContentSize(cc.size(oldSize.width,totalHigh))
    self.scrollview:jumpToTop()

    local offsetY = totalHigh - oldSize.height
    print("totalHigh=",totalHigh,"offsetY=",offsetY,"oldSize.high=",oldSize.height)
    self.panContent:setPositionY(offsetY)
end

