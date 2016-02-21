
--前端提示

HintClient = class("HintClient")

local instance = nil

local text = {}

function HintClient:ctor()

end

--获取单例
--返回值(单例)
function HintClient:getInstance()
	if instance == nil then
		instance = HintClient.new()
	end
	return instance
end

function HintClient:getText()
	return text
end

text[1] = "解锁该区域需要城堡达到{}级"
text[2] = "您的英雄正驻扎在城墙无法训练"
text[3] = "您的英雄正出征无法训练"
text[4] = "当前英雄已完成训练，请退出当前页面领取英雄"
text[5] = "你暂时还没有英雄，请到酒馆招揽英雄"
text[6] = "身上{}不够"
text[7] = "你暂时还没有道具，请到商店购买"
text[8] = "粮食不够,无法解锁"
text[9] = "木材不够,无法解锁"
text[10] = "{}不足"
text[11] = "对不起,出征部队已经到达上限,无法再出征"
text[12] = "天赋点数不足"
text[13] = "重置天赋成功"
text[14] = "升级{}天赋成功"
text[15] = "升级{}科技成功"
text[16] = "升级的城墙数量不能为0"
text[17] = "对不起!有建筑在升级中,无法再进行升级"
text[18] = "建筑已经满级了,无法再进行升级"
text[19] = "城外守军数量不能为0"
text[20] = "该建筑已经放置到世界地图上,请收回后再进行升级"


