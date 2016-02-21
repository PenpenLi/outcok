
--[[
	jinyan.zhang
	常量定义处
--]]

msgPacketName = "node.DataPacket"  --消息包名(统一)
pbPath = "src/app/network/netmsg/message/"  --pb消息文件路径
CONFIG_SRC_PRE_PATH = ""  --配置文件前置路径

--UI类型（前端使用）
UITYPE =
{
    PUB = 10,                    --酒馆
    COLLEGE = 11,                --科技学院
    LOGIN = 100,				 --登录界面
	LOADING = 101,		         --加载进度条
	LOGO = 102,				     --LOGO界面
	CITY = 103,				     --城内界面
	CITY_BUILD_LIST = 104,         --建筑列表
	CITY_BUILD_DETAILS = 105,      --建筑详情
    CITY_BUILD_UPGRADE = 106,      --升级详情
    CITY_BUILD_MAIL = 107,         --邮件界面
    PVP_BATTLE = 108,			   --pvp战斗
    AGGREGATION_CITY = 109,       --集结界面
    GO_BATTLE_CITY = 110,         --出征界面
    INSTANCE_CITY = 111,          --副本界面
    INSTANCE_BATTLE_CITY = 112,   --副本界面
 	BUILDING_MENU = 113, 		 --建筑菜单界面
 	PVP_BATTLE_RESULT = 114,      --pvp战斗结果界面
 	LOOK = 115,					 --侦察界面
    CITY_WATCHTOWER = 116,        --瞭望塔界面
    PROP_BOX = 117,				 --通用提示框
    OUT_WALL_BUILDINGLIST = 118,  --城墙外建筑列表
    BUILDING_ACCELERATION = 119,  --加速建筑列表
    OUT_CITY = 120,			     --城外主界面
    BUILDING_RES_DETAILS = 121,   --资源详情界面
    GATHER = 122,                 --集结处界面
    BUILDING_AID_DETAILS = 123,   --急救帐篷详情界面
    BUILDING_MARCH_DETAILS = 124, --行军帐篷详情界面
    TREATMENT = 125,              --治疗界面
    WAREHOUSE_DETAILS = 126,      --仓库详情界面
    BAG = 127,                    --背包界面
    FORTRESS = 128, 				 --堡垒界面
    WALL_DETAILS = 129,           --城墙详情界面
    TOWER_DETAILS = 130,          --防御塔详情界面
    TOWER_DEFENSE_LIST = 131,     --防御塔列表界面
    WALL = 132, 					 --城墙界面
    TRAINING_DETAILS = 133,       --训练场详情界面
    HERO_TRAIN = 134,             --英雄训练界面
    MOVE_CASTLE = 135,			 --迁城
    FINISH_HERO_TRAIN = 136,      --完成英雄训练
    PUB_DETAILS = 137,            --酒馆详情
    GAIN = 138,                   --增益界面
    CASTLE_INFORMATION = 139,     --城堡信息
    TRAINING_CITY = 140,          --训练界面
    LORD = 141,                   --领主
    COLLEGE_PATH = 142,           --科技列表
    LAIRD_SKILL = 144,            --领主天赋界面
    TERRITORY = 145, 			  --野外领地界面
}

--建筑类型(与服务端一起约定的)
BuildType =
{
	emptyFloor = 0,  --空地
	castle = 1,  --城堡
	infantryBattalion = 2, --步兵营
	cavalryBattalion = 3, --骑兵营
	archerCamp = 4, --弓兵营
	chariotBarracks = 5, --战车兵营
	masterBarracks = 6, --法师兵营
	wathchTower = 7,  --瞭望塔
	trainingCamp = 8, --训练场
	warehouse = 9,    --仓库
	PUB = 10,  --酒馆
	COLLEGE = 11,  --学院
	market = 12,  --市场
	warFortress = 13, --战争要塞
	fortress = 14, --堡垒
	guildhall = 15, --公会大厅
	wall = 16,  --城墙
	farmland = 17,  --农田
	loggingField = 18, --伐木场
	ironOre = 19, --铁矿
	illithium = 20, --秘银矿
	firstAidTent = 21, --急救账篷
	marchTent = 22, --行军账篷
	arrowTower = 23, --箭塔
	turret = 24,  --炮塔
	magicTower = 25,  --魔法塔
	flag = 26, 		--集结处
	out_farmland = 27,  --野外大型农田
	out_logging = 28,   --野外大型伐木场
	out_iron = 29,      --野外大型铁矿场
	out_mithril = 30,   --野外大型秘银矿
	out_goldoreField = 31,  --野外金矿场
	out_arrowTower = 32,   --野外箭塔
	out_turretTower = 33,  --野外炮塔
	out_magicTower = 34,   --野外魔法塔
	out_wall = 35, 		   --野外城墙

	activityCenter = 40, --活动中心
	bulletinBoard = 41,  --公告栏
	forest = 42,  --森林
	OTHER = -1,  --其它
}

--建筑状态
BuildingState =
{
    createBuilding = 0,  --创建建筑中
    removeBuilding = 1,  --称除建筑中
    uplving = 2,         --升级建筑中
    makeSoldiers = 3,    --创建士兵中
    MARCH = 4,           --行军
    MARCH_BACK = 5,      --行军返回
    TREATMENT = 8,       --治疗定时器
    uplvingOut = 17,     --升级野外建筑
   	TRAIN_HERO = 90, 	  --英雄训练
    buildOk = 600,       --建筑完成
}

--定时器action
TimeAction =
{
	produc_res_speed = 7,  --生产资源加速
}

--建造状态
BuidState =
{
	UN_FINISH = 0,   --未完成状态(升级，创建，造兵中)
	FINISH = 1,   	 --完成
}

--建筑位置类型
BuildingPosType =
{
	CITY = 1,  --城内建筑
	OUT = 2,   --城外建筑
	CITY_DEF_TOWER = 3,  --城内防御塔
}

--资源状态
ResourceState =
{
    noHarvest = 0, --未丰收
    harvest = 1.   --丰收
}

--定时器类型(客户端内部用的)
TimeType =
{
	BATTLE_SKILL_CD = 1,  --战斗技能CD
	BATTLE_PVP = 2,   --战斗PVP
	MARCH = 3, 		  --行军
	PLAYER_ARMS_STATE = 4, --玩家部队状态检测
	UPDATE_WATCH_TOWER = 5, --更新瞭望塔时间
	UPDATE_WATCH_TOWER_DETAILS = 6, --更新瞭望塔详情时间
	OTHER_PLAYER_MARCH_TIME = 7, --更新其它玩家行军信息
	RecvHeartbeatTime = 8,		 --收到心跳包的时间
	SendHeartbeatTime = 9,  	--发送心跳包的间隔时间
	ACC_SPEED_UP_BUILDING_TIME = 10, --加速升级建筑
	HAMMER_BUILDING_TIME = 11, 		--锤子建造时间
	RIGHTNOW_UP_BUILDING = 12, 		--立即升级建筑
	ACC_MAKE_SOLDIER = 13, 			--加速造兵
	UPDATE_SOLDIER_TRAINING_TIME = 14,  --士兵训练时间
    TREATMENT = 15, --治疗时间
    TRAP = 16, 		--陷井
    COMMON = 17,    --在UI界面执行的定时器，关了UI就不执行了
    wallFireTime = 18,   		--城墙着火时间
    wallRepairCoolTime = 19,    --修复城墙冷却时间
    MOVE_CASTLE = 20, 		    --迁城
    TRAIN_HERO = 21,   			--训练英雄
    GAIN = 22,  				--增益
    TECHNOLOGY = 23,   			--科技研究
    goldAcceTime = 24,      	--金币加速时间
    propAcceTime = 25, 		    --道具加速时间
    time = 26,  			    --时间进度
    castRes = 27, 				--消耗资源
    upLevel = 28,               --升级建筑
}

--连接服务器结果
CONNECT_FAIL =
{
    CONNECT_SERVER_FAIL = 0,   --连不上服务器
    CONNECT_DATA_ERROR = 1,    --数据包有错
    CONNECT_DISCONNECT = 2,    --与服务器断开连接了
}

--游戏层级
GAME_ZORDER =
{
    GAME = 0,
	MAP = 1,  --地图层级
	BATTLE=2, --战斗层
	EFFECT=3, --特效层
	UI = 4,	  --UI层级
	PROP = 5, --通用提示框层级
}

--地图内部层级
MAP_ZORDER =
{
	CITY = 1,  --主城
	WORLD = 2, --大世界
}

--世界地图内部层级
WORLDE_MAP_ZORDER =
{
	BUILDING = 1, 	--建筑
	MARCH_LINE = 2,  --行军路线
	HERO = 3, 		--玩家
	ENEMY = 3, 		--怪物
}

--行军操作类型
MarchOperationType =
{
	stationed = 0,  --驻扎
	collection = 1,  --采集
	reconnaissance = 2, --侦察
	attack = 3, 	    --攻击
}

--行军状态
MarchState =
{
	marching = 0,  --行军中
	back = 1, --返回
	together =2, --集结
	stationed = 3,  --驻扎
	retunCastle = 4, --回到城堡
}

--其它部队行军操作类型
OTHER_MARCH_OPTION_TYPE =
{
	reconnaissance = 0, --侦察
	attack = 1, 	 --攻击
	RESOURCE_HELP = 2, --资源援助
	SOLDIER_HELP = 3, --士兵援助
}

--滚动方向
TouchDirection =
{
    enum_Horizontal = 0,		--水平滚动
    enum_Vertical = 1,			--垂直滚动
    enum_Both = 2,				--两者都
}

--技能类型
SkillsType =
{
	REGION = 1,   --区域性类技能
	FLG = 2,  	  --子弹类技能
	FALLROCEK = 3,  --陷井落石
	BOWLING = 4, 	--陷井滚木
	ROCKET = 5,    --陷井火箭
	HERO_ROCKET = 6, --英雄火箭(全体技能)
	BUFF = 7,       --buff
}

--战斗类型
BATTLE_TYPE =
{
	PVP = 1,
	PVE = 2,
	GVG = 3,
}

--阵营
CAMP =
{
	ATTER = 1, --攻击方
	DEFER=2, --防守方
}

--AI状态
AI_STATE =
{
	IDLE = 1,   --空闲
	MOVE = 2,   --移动
	ATTACT = 3, --攻击
	HURT = 4,   --受击
	DEATH = 5,  --死亡
}

EMPTY = 0
FULL = 1

--追击方向
CHASE_DIR_LEFTDOWN = 1
CHASE_DIR_RIGHTDOWN = 2
CHASE_DIR_LEFTUP = 3
CHASE_DIR_RIGHTUP = 4
CHASE_DIR_DOWN = 5
CHASE_DIR_UP = 6
CHASE_DIR_LEFT = 7
CHASE_DIR_RIGHT = 8

--场景类型
SCENE_TYPE =
{
	COPY = 1, --副本
	WORLD = 2, --世界地图
	CITY = 3,  --城内地图
}

--世界地图对象类型 
ObjType = {
	player = 1, --玩家
	monster = 2, --怪物
	res = 3,     --资源
	block = 4,   --障碍物
}



