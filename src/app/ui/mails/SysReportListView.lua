
--[[
	jinyan.zhang
	系统报告列表
--]]

SysReportListView = class("SysReportListView",MailInfoListBase)

function SysReportListView:ctor(parent)
	self.parent = parent
	self.super.ctor(self,parent)
end

--更新UI
function SysReportListView:updateUI()
	self:setTitle(Lan:lanText(45, "系统"))
	self:createList()
end

--选中回调
function SysReportListView:onSel(index)
	print("系统 index=",index)
end

