--[[
	BuildingType.lua
--]]

local BuildingType=
{
	[1] = { bt_id=1,bt_name="城堡",bt_position=1,bt_wildbuildingtype=0,bt_defaultlevel=1,bt_num=1,bt_description="城堡说明",bt_detaileddescription="城堡详细",bt_deviationXY={0,0},bt_wildmaphold=4,},
	[2] = { bt_id=2,bt_name="步兵营",bt_position=1,bt_wildbuildingtype=0,bt_defaultlevel=0,bt_num=1,bt_description="步兵营说明",bt_detaileddescription="步兵营详细",bt_deviationXY={0,18},bt_wildmaphold=0,},
	[3] = { bt_id=3,bt_name="骑兵营",bt_position=1,bt_wildbuildingtype=0,bt_defaultlevel=0,bt_num=1,bt_description="骑兵营说明",bt_detaileddescription="骑兵营详细",bt_deviationXY={0,18},bt_wildmaphold=0,},
	[4] = { bt_id=4,bt_name="弓兵营",bt_position=1,bt_wildbuildingtype=0,bt_defaultlevel=0,bt_num=1,bt_description="弓兵营说明",bt_detaileddescription="弓兵营详细",bt_deviationXY={0,18},bt_wildmaphold=0,},
	[5] = { bt_id=5,bt_name="战车兵营",bt_position=1,bt_wildbuildingtype=0,bt_defaultlevel=0,bt_num=1,bt_description="战车兵营说明",bt_detaileddescription="战车兵营详细",bt_deviationXY={0,18},bt_wildmaphold=0,},
	[6] = { bt_id=6,bt_name="法师兵营",bt_position=1,bt_wildbuildingtype=0,bt_defaultlevel=0,bt_num=1,bt_description="法师兵营说明",bt_detaileddescription="法师兵营详细",bt_deviationXY={20,30},bt_wildmaphold=0,},
	[7] = { bt_id=7,bt_name="瞭望塔",bt_position=1,bt_wildbuildingtype=0,bt_defaultlevel=0,bt_num=1,bt_description="瞭望塔说明",bt_detaileddescription="瞭望塔详细",bt_deviationXY={0,100},bt_wildmaphold=0,},
	[8] = { bt_id=8,bt_name="训练营",bt_position=1,bt_wildbuildingtype=0,bt_defaultlevel=0,bt_num=1,bt_description="训练营说明",bt_detaileddescription="训练营详细",bt_deviationXY={0,50},bt_wildmaphold=0,},
	[9] = { bt_id=9,bt_name="仓库",bt_position=1,bt_wildbuildingtype=0,bt_defaultlevel=1,bt_num=1,bt_description="仓库说明",bt_detaileddescription="仓库详细",bt_deviationXY={4,25},bt_wildmaphold=0,},
	[10] = { bt_id=10,bt_name="酒馆",bt_position=1,bt_wildbuildingtype=0,bt_defaultlevel=0,bt_num=1,bt_description="酒馆说明",bt_detaileddescription="酒馆详细",bt_deviationXY={4,28},bt_wildmaphold=0,},
	[11] = { bt_id=11,bt_name="学院",bt_position=1,bt_wildbuildingtype=0,bt_defaultlevel=0,bt_num=1,bt_description="学院说明",bt_detaileddescription="学院详细",bt_deviationXY={-10,50},bt_wildmaphold=0,},
	[12] = { bt_id=12,bt_name="市场",bt_position=1,bt_wildbuildingtype=0,bt_defaultlevel=0,bt_num=1,bt_description="市场说明",bt_detaileddescription="市场详细",bt_deviationXY={100,80},bt_wildmaphold=0,},
	[13] = { bt_id=13,bt_name="战争要塞",bt_position=1,bt_wildbuildingtype=0,bt_defaultlevel=0,bt_num=1,bt_description="战争要塞说明",bt_detaileddescription="战争要塞详细",bt_deviationXY={0,40},bt_wildmaphold=0,},
	[14] = { bt_id=14,bt_name="堡垒",bt_position=1,bt_wildbuildingtype=0,bt_defaultlevel=0,bt_num=1,bt_description="堡垒说明",bt_detaileddescription="堡垒详细",bt_deviationXY={0,110},bt_wildmaphold=0,},
	[15] = { bt_id=15,bt_name="公会大厅",bt_position=1,bt_wildbuildingtype=0,bt_defaultlevel=0,bt_num=1,bt_description="公会大厅说明",bt_detaileddescription="公会大厅详细",bt_deviationXY={0,0},bt_wildmaphold=0,},
	[16] = { bt_id=16,bt_name="城墙",bt_position=1,bt_wildbuildingtype=0,bt_defaultlevel=1,bt_num=1,bt_description="城墙说明",bt_detaileddescription="城墙详细",bt_deviationXY={0,0},bt_wildmaphold=0,},
	[17] = { bt_id=17,bt_name="农田",bt_position=2,bt_wildbuildingtype=0,bt_defaultlevel=0,bt_num=10,bt_description="农田说明",bt_detaileddescription="农田详细",bt_deviationXY={0,0},bt_wildmaphold=0,},
	[18] = { bt_id=18,bt_name="伐木场",bt_position=2,bt_wildbuildingtype=0,bt_defaultlevel=0,bt_num=10,bt_description="伐木场说明",bt_detaileddescription="伐木场详细",bt_deviationXY={0,0},bt_wildmaphold=0,},
	[19] = { bt_id=19,bt_name="铁矿",bt_position=2,bt_wildbuildingtype=0,bt_defaultlevel=0,bt_num=10,bt_description="铁矿说明",bt_detaileddescription="铁矿详细",bt_deviationXY={0,30},bt_wildmaphold=0,},
	[20] = { bt_id=20,bt_name="秘银矿",bt_position=2,bt_wildbuildingtype=0,bt_defaultlevel=0,bt_num=10,bt_description="秘银矿说明",bt_detaileddescription="秘银矿详细",bt_deviationXY={0,30},bt_wildmaphold=0,},
	[21] = { bt_id=21,bt_name="急救帐篷",bt_position=2,bt_wildbuildingtype=0,bt_defaultlevel=0,bt_num=8,bt_description="急救帐篷说明",bt_detaileddescription="急救帐篷详细",bt_deviationXY={0,30},bt_wildmaphold=0,},
	[22] = { bt_id=22,bt_name="行军帐篷",bt_position=2,bt_wildbuildingtype=0,bt_defaultlevel=0,bt_num=8,bt_description="行军帐篷说明",bt_detaileddescription="行军帐篷详细",bt_deviationXY={0,30},bt_wildmaphold=0,},
	[23] = { bt_id=23,bt_name="箭塔",bt_position=3,bt_wildbuildingtype=0,bt_defaultlevel=0,bt_num=3,bt_description="箭塔说明",bt_detaileddescription="箭塔详细",bt_deviationXY={0,110},bt_wildmaphold=0,},
	[24] = { bt_id=24,bt_name="炮塔",bt_position=3,bt_wildbuildingtype=0,bt_defaultlevel=0,bt_num=3,bt_description="炮塔说明",bt_detaileddescription="炮塔详细",bt_deviationXY={0,110},bt_wildmaphold=0,},
	[25] = { bt_id=25,bt_name="魔法塔",bt_position=3,bt_wildbuildingtype=0,bt_defaultlevel=0,bt_num=3,bt_description="魔法塔说明",bt_detaileddescription="魔法塔详细",bt_deviationXY={0,110},bt_wildmaphold=0,},
	[26] = { bt_id=26,bt_name="集结处",bt_position=1,bt_wildbuildingtype=0,bt_defaultlevel=1,bt_num=1,bt_description="集结处说明",bt_detaileddescription="集结处详细",bt_deviationXY={0,0},bt_wildmaphold=0,},
	[27] = { bt_id=27,bt_name="大型农田",bt_position=4,bt_wildbuildingtype=1,bt_defaultlevel=1,bt_num=0,bt_description="大型农田说明",bt_detaileddescription="大型农田详细",bt_deviationXY={0,0},bt_wildmaphold=1,},
	[28] = { bt_id=28,bt_name="大型伐木场",bt_position=4,bt_wildbuildingtype=1,bt_defaultlevel=1,bt_num=0,bt_description="大型伐木场说明",bt_detaileddescription="大型伐木场详细",bt_deviationXY={0,0},bt_wildmaphold=1,},
	[29] = { bt_id=29,bt_name="大型铁矿场",bt_position=4,bt_wildbuildingtype=1,bt_defaultlevel=1,bt_num=0,bt_description="大型铁矿场说明",bt_detaileddescription="大型铁矿场详细",bt_deviationXY={0,0},bt_wildmaphold=1,},
	[30] = { bt_id=30,bt_name="大型秘银矿场",bt_position=4,bt_wildbuildingtype=1,bt_defaultlevel=1,bt_num=0,bt_description="大型秘银矿场说明",bt_detaileddescription="大型秘银矿场详细",bt_deviationXY={0,0},bt_wildmaphold=1,},
	[31] = { bt_id=31,bt_name="金矿场",bt_position=4,bt_wildbuildingtype=1,bt_defaultlevel=1,bt_num=0,bt_description="大型金矿场说明",bt_detaileddescription="大型金矿场详细",bt_deviationXY={0,0},bt_wildmaphold=1,},
	[32] = { bt_id=32,bt_name="箭塔",bt_position=4,bt_wildbuildingtype=2,bt_defaultlevel=1,bt_num=1,bt_description="箭塔说明",bt_detaileddescription="箭塔详细",bt_deviationXY={0,0},bt_wildmaphold=1,},
	[33] = { bt_id=33,bt_name="炮塔",bt_position=4,bt_wildbuildingtype=2,bt_defaultlevel=1,bt_num=1,bt_description="炮塔说明",bt_detaileddescription="炮塔详细",bt_deviationXY={0,0},bt_wildmaphold=1,},
	[34] = { bt_id=34,bt_name="魔法塔",bt_position=4,bt_wildbuildingtype=2,bt_defaultlevel=1,bt_num=1,bt_description="魔法塔说明",bt_detaileddescription="魔法塔详细",bt_deviationXY={0,0},bt_wildmaphold=1,},
	[35] = { bt_id=35,bt_name="城墙",bt_position=4,bt_wildbuildingtype=3,bt_defaultlevel=1,bt_num=0,bt_description="城墙说明",bt_detaileddescription="城墙详细",bt_deviationXY={0,0},bt_wildmaphold=1,},
}
return BuildingType
