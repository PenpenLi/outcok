
--[[
	jinyan.zhang
	城内建筑位置配置表
--]]

BuildPosConfig = class("BuildPosConfig")

local instance = nil

local cityFloor = "test/floor.png"   --城墙内的底板路径
local outCityFloor = "citybuilding/farmlandFloor.png"  --城墙外的底板路径

--[[
	城内建筑配置表
	x,y 是建筑坐标
	posType  城墙内，还是城墙外建筑  1 城墙内  2 城墙外
	buildType 建筑类型  具体定义在define.lua中 (0表示空地)
	pos  建筑位置
--]]

local BuildPos =
{
	--城墙内建筑
	[1] = { pos=0,x=610,y=1774,buildType=BuildType.castle,posType=1},  	--城堡
	[2] = { pos=1,x=1477,y=963,buildType=BuildType.wall,posType=1},  	--城墙
	[3] = { pos=2,x=2143,y=1465,buildType=0,posType=1},   				--瞭望塔
	[4] = { pos=3,x=1148,y=1804,buildType=0,posType=1},					--仓库
	[5] = { pos=4,x=268,y=1334,buildType=0,posType=1},
	[6] = { pos=5,x=435,y=1173,buildType=0,posType=1},
	[7] = { pos=6,x=402,y=1478,buildType=0,posType=1},
	[8] = { pos=7,x=636,y=1388,buildType=0,posType=1},
	[9] = { pos=8,x=887,y=1226,buildType=0,posType=1},
	[10] = { pos=9,x=670,y=1101,buildType=0,posType=1}, 
	[11] = { pos=10,x=909,y=1939,buildType=0,posType=1}, 					
	[12] = { pos=11,x=1292,y=1678,buildType=0,posType=1},
	[13] = { pos=12,x=1526,y=1520,buildType=0,posType=1},
	[14] = { pos=13,x=1558,y=1724,buildType=0,posType=1},
	[15] = { pos=14,x=1752,y=1626,buildType=0,posType=1},
	[16] = { pos=15,x=144,y=1653,buildType=0,posType=1},
	--防御塔
	[17] = { pos=16,x=959,y=873,buildType=0,posType=3},   --魔法塔
	[18] = { pos=17,x=1212,y=1012,buildType=0,posType=3},  --炮塔
	[19] = { pos=18,x=1850,y=1322,buildType=0,posType=3},  --箭塔

	--城墙外建筑
	[20] = { pos=19,x=1900,y=786,buildType=0,posType=2},
	[21] = { pos=20,x=1816,y=688,buildType=0,posType=2},
	[22] = { pos=21,x=2062,y=734,buildType=0,posType=2},
	[23] = { pos=22,x=1954,y=646,buildType=0,posType=2},
	[24] = { pos=23,x=2180,y=660,buildType=0,posType=2},
	[25] = { pos=24,x=2230,y=930,buildType=0,posType=2},
	[26] = { pos=25,x=2318,y=854,buildType=0,posType=2},
	[27] = { pos=26,x=2424,y=922,buildType=0,posType=2},
	[28] = { pos=27,x=2482,y=828,buildType=0,posType=2},
	[29] = { pos=28,x=2375,y=770,buildType=0,posType=2},
	--未解锁的地
	[30] = { pos = 40,x=2632,y=1380,buildType=0,posType=2},
	[31] = { pos = 41,x=2770,y=1310,buildType=0,posType=2},
	[32] = { pos = 42,x=2752,y=1462,buildType=0,posType=2},
	[33] = { pos = 43,x=2898,y=1382,buildType=0,posType=2},
	[34] = { pos = 44,x=2924,y=1488,buildType=0,posType=2},

	[35] = { pos = 45,x=2662,y=754,buildType=0,posType=2},
	[36] = { pos = 46,x=2730,y=880,buildType=0,posType=2},
	[37] = { pos = 47,x=2836,y=674,buildType=0,posType=2},
	[38] = { pos = 48,x=2930,y=840,buildType=0,posType=2},
	[39] = { pos = 49,x=3026,y=718,buildType=0,posType=2},

	[40] = { pos = 50,x=2388,y=488,buildType=0,posType=2},
	[41] = { pos = 51,x=2524,y=584,buildType=0,posType=2},
	[42] = { pos = 52,x=2624,y=418,buildType=0,posType=2},
	[43] = { pos = 53,x=2710,y=540,buildType=0,posType=2},
	[44] = { pos = 54,x=2852,y=422,buildType=0,posType=2},

	[45] = { pos = 55,x=1428,y=490,buildType=0,posType=2},
	[46] = { pos = 56,x=1500,y=606,buildType=0,posType=2},
	[47] = { pos = 57,x=1626,y=550,buildType=0,posType=2},
	[48] = { pos = 58,x=1740,y=458,buildType=0,posType=2},
	[49] = { pos = 59,x=1938,y=490,buildType=0,posType=2},

	[50] = { pos=100,x=100,y=1144,buildType=BuildType.flag,posType=1}, --旗子
}

--构造
--返回值(无)
function BuildPosConfig:ctor()
	self:init()
end

--初始化
--返回值(无)
function BuildPosConfig:init()

end

--获取单例
--返回值(单例)
function BuildPosConfig:getInstance()
	if instance == nil then
		instance = BuildPosConfig.new()
	end
	return instance
end

--获取配置信息
--pos 建筑位置
--返回值(配置信息)
function BuildPosConfig:getConfigInfoByPos(pos)
	for k,v in pairs(BuildPos) do
		if v.pos == pos then
			return v
		end
	end
end

--获取配置信息
function BuildPosConfig:getConfigInfo()
	return BuildPos
end

--获取底板图片路径
--返回值(路径)
function BuildPosConfig:getFloorResPath(posType)
	if posType == 1 then
		return cityFloor
	else
		return outCityFloor
	end
end

--是否需要创建底板
--buildingType 建筑类型
--返回值(true:需要,false:不需要)
function BuildPosConfig:isNeedCreateFloor(buildingType)
	if buildingType == BuildType.castle or buildingType == BuildType.wall then
		return false
	end
	return true
end




