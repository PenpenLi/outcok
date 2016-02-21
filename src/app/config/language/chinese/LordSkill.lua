--[[
	LordSkill.lua
--]]

local LordSkill=
{
	[1] = { ls_id=1,ls_name="全军返回技能",ls_icon="talent_1008",ls_type=1,ls_des="全军返回技能的描述",ls_cdtime=120,ls_continuedtime=0,ls_armyback=1,ls_maxarmy=0,ls_turnwounded=0,ls_protectresource=0,ls_collectinsidetime=0,ls_increaseyieldoutside=0,ls_havepower=0,ls_increasetrain=0,ls_increasearmytime=0,},
	[2] = { ls_id=2,ls_name="出征上限提升",ls_icon="talent_1021",ls_type=2,ls_des="出征上限提升的描述",ls_cdtime=120,ls_continuedtime=60,ls_armyback=0,ls_maxarmy=0.2,ls_turnwounded=0,ls_protectresource=0,ls_collectinsidetime=0,ls_increaseyieldoutside=0,ls_havepower=0,ls_increasetrain=0,ls_increasearmytime=0,},
	[3] = { ls_id=3,ls_name="第一次出征均产生为伤兵",ls_icon="talent_1041",ls_type=3,ls_des="第一次出征均产生为伤兵的描述",ls_cdtime=120,ls_continuedtime=0,ls_armyback=0,ls_maxarmy=0,ls_turnwounded=1,ls_protectresource=0,ls_collectinsidetime=0,ls_increaseyieldoutside=0,ls_havepower=0,ls_increasetrain=0,ls_increasearmytime=0,},
	[4] = { ls_id=4,ls_name="立刻获得城内资源产量",ls_icon="talent_2007",ls_type=4,ls_des="立刻获得城内资源产量的描述",ls_cdtime=120,ls_continuedtime=0,ls_armyback=0,ls_maxarmy=0,ls_turnwounded=0,ls_protectresource=0,ls_collectinsidetime=5,ls_increaseyieldoutside=0,ls_havepower=0,ls_increasetrain=0,ls_increasearmytime=0,},
	[5] = { ls_id=5,ls_name="野外资源田产量提升",ls_icon="talent_2015",ls_type=5,ls_des="野外资源田产量提升的描述",ls_cdtime=120,ls_continuedtime=60,ls_armyback=0,ls_maxarmy=0,ls_turnwounded=0,ls_protectresource=0,ls_collectinsidetime=0,ls_increaseyieldoutside=0.2,ls_havepower=0,ls_increasetrain=0,ls_increasearmytime=0,},
	[6] = { ls_id=6,ls_name="资源保护技能",ls_icon="talent_2022",ls_type=6,ls_des="资源保护技能的描述",ls_cdtime=120,ls_continuedtime=60,ls_armyback=0,ls_maxarmy=0,ls_turnwounded=0,ls_protectresource=1,ls_collectinsidetime=0,ls_increaseyieldoutside=0,ls_havepower=0,ls_increasetrain=0,ls_increasearmytime=0,},
	[7] = { ls_id=7,ls_name="立刻获得体力",ls_icon="talent_3003",ls_type=7,ls_des="立刻获得体力的描述",ls_cdtime=120,ls_continuedtime=0,ls_armyback=0,ls_maxarmy=0,ls_turnwounded=0,ls_protectresource=0,ls_collectinsidetime=0,ls_increaseyieldoutside=0,ls_havepower=30,ls_increasetrain=0,ls_increasearmytime=0,},
	[8] = { ls_id=8,ls_name="增加英雄训练位置",ls_icon="talent_3012",ls_type=8,ls_des="增加英雄训练位置的描述",ls_cdtime=120,ls_continuedtime=0,ls_armyback=0,ls_maxarmy=0,ls_turnwounded=0,ls_protectresource=0,ls_collectinsidetime=0,ls_increaseyieldoutside=0,ls_havepower=0,ls_increasetrain=1,ls_increasearmytime=0,},
	[9] = { ls_id=9,ls_name="敌方攻击和侦查的行军时间加倍",ls_icon="talent_3023",ls_type=9,ls_des="敌方攻击和侦查的行军时间加倍的描述",ls_cdtime=120,ls_continuedtime=60,ls_armyback=0,ls_maxarmy=0,ls_turnwounded=0,ls_protectresource=0,ls_collectinsidetime=0,ls_increaseyieldoutside=0,ls_havepower=0,ls_increasetrain=0,ls_increasearmytime=2,},
}
return LordSkill
