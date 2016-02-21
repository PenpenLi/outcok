
--[[
    jinyan.zhang
    使用道具加速造兵
--]]

UsePropAcceMakeSoldierModel = class("UsePropAcceMakeSoldierModel")

local instance = nil

--构造
--返回值(无)
function UsePropAcceMakeSoldierModel:ctor()
    self:init()
end

--初始化
--返回值(无)
function UsePropAcceMakeSoldierModel:init()

end

--获取单例
--返回值(单例)
function UsePropAcceMakeSoldierModel:getInstance()
    if instance == nil then
        instance = UsePropAcceMakeSoldierModel.new()
    end
    return instance
end

--使用道具加速造兵结果
--data 数据
function UsePropAcceMakeSoldierModel:acceRes(data)
    local items = data.items
    local buildingPos = data.pos
    local config = ItemTemplateConfig:getInstance():getItemTemplateByID(items.templateId)
    local second = config.it_turbotime*60
    local timeInfo = TimeInfoData:getInstance():minusLeftTimeByPos(buildingPos,second)
    BagModel:getInstance():useItem(items)

    UIMgr:getInstance():closeUI(UITYPE.BUILDING_ACCELERATION)
    UIMgr:getInstance():closeUI(UITYPE.TRAINING_CITY)
    UIMgr:getInstance():closeUI(UITYPE.BUILDING_MENU)

    --刷新地图上的建筑
    local cityBuildingListCtrl = MapMgr:getInstance():getCityBuildingListCtrl()
    if cityBuildingListCtrl ~= nil then
        cityBuildingListCtrl:modifMakeSoldierTimeUI(buildingPos,timeInfo.start_time,timeInfo.interval)
    end
end

--获取加速道具数量
function UsePropAcceMakeSoldierModel:getPropNum()
    local total = 0
    local itemlist = ItemData:getInstance():getQuickItemList()
    for k,v in pairs(itemlist) do
        if v.speedType == ItemSpeedType.train or v.speedType == ItemSpeedType.all then
            total = total + v.number
        end
    end
    return total
end

--清理缓存数据
--返回值(无)
function UsePropAcceMakeSoldierModel:clearCache()
    self:init()
end



