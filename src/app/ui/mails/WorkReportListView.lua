
--[[
	jinyan.zhang
	工作室报告列表
--]]

WorkReportListView = class("WorkReportListView",MailInfoListBase)

function WorkReportListView:ctor(parent)
	self.parent = parent
	self.super.ctor(self,parent)
end

--更新UI
function WorkReportListView:updateUI()
	self:setTitle(Lan:lanText(55, "工作室"))
	self:createList()
end

--选中回调
function WorkReportListView:onSel(index)
	print("工作室 index=",index)
end

