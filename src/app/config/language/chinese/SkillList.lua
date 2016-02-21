--[[
	SkillList.lua
--]]

local SkillList=
{
	[1] = { sl_id=1,sl_name="全体攻击",sl_icon="skill_1001",sl_action=1,sl_des="全体攻击的描述",sl_user=1,sl_class="C",sl_type=2,sl_skillltype=1,sl_target=1,sl_num=2,sl_soldier=9,sl_attack=100,sl_bufftype=0,sl_effect=0,sl_duration=0,sl_probability=0.2,sl_attackbackroww=0,},
	[2] = { sl_id=2,sl_name="单体攻击",sl_icon="skill_1002",sl_action=2,sl_des="单体攻击的描述",sl_user=1,sl_class="B",sl_type=2,sl_skillltype=1,sl_target=1,sl_num=1,sl_soldier=9,sl_attack=200,sl_bufftype=0,sl_effect=0,sl_duration=0,sl_probability=0.2,sl_attackbackroww=0,},
	[3] = { sl_id=3,sl_name="攻击加成",sl_icon="skill_1003",sl_action=3,sl_des="攻击加成的描述",sl_user=1,sl_class="A",sl_type=2,sl_skillltype=2,sl_target=2,sl_num=1,sl_soldier=9,sl_attack=0,sl_bufftype=1,sl_effect=0.1,sl_duration=2,sl_probability=0.3,sl_attackbackroww=0,},
	[4] = { sl_id=4,sl_name="防御加成",sl_icon="skill_1004",sl_action=4,sl_des="防御加成的描述",sl_user=1,sl_class="B",sl_type=2,sl_skillltype=2,sl_target=2,sl_num=1,sl_soldier=9,sl_attack=0,sl_bufftype=2,sl_effect=0.1,sl_duration=2,sl_probability=0.2,sl_attackbackroww=0,},
	[5] = { sl_id=5,sl_name="步兵攻击削弱",sl_icon="skill_1005",sl_action=5,sl_des="步兵攻击削弱的描述",sl_user=1,sl_class="C",sl_type=2,sl_skillltype=2,sl_target=1,sl_num=1,sl_soldier=1,sl_attack=0,sl_bufftype=1,sl_effect=-0.1,sl_duration=2,sl_probability=0.2,sl_attackbackroww=0,},
	[6] = { sl_id=6,sl_name="骑兵防御削弱",sl_icon="skill_1006",sl_action=6,sl_des="骑兵防御削弱的描述",sl_user=1,sl_class="C",sl_type=2,sl_skillltype=2,sl_target=1,sl_num=1,sl_soldier=2,sl_attack=0,sl_bufftype=2,sl_effect=-0.1,sl_duration=2,sl_probability=0.2,sl_attackbackroww=0,},
	[7] = { sl_id=7,sl_name="攻击光环",sl_icon="skill_1007",sl_action=7,sl_des="攻击光环的描述",sl_user=1,sl_class="A",sl_type=1,sl_skillltype=2,sl_target=2,sl_num=2,sl_soldier=9,sl_attack=0,sl_bufftype=1,sl_effect=0.05,sl_duration=0,sl_probability=1,sl_attackbackroww=0,},
	[8] = { sl_id=8,sl_name="自身攻击加成",sl_icon="skill_2001",sl_action=8,sl_des="自身攻击加成的描述",sl_user=2,sl_class="C",sl_type=1,sl_skillltype=2,sl_target=2,sl_num=1,sl_soldier=9,sl_attack=0,sl_bufftype=1,sl_effect=0.1,sl_duration=0,sl_probability=1,sl_attackbackroww=0,},
	[9] = { sl_id=9,sl_name="攻击后排目标",sl_icon="skill_2002",sl_action=9,sl_des="攻击后排目标的描述",sl_user=2,sl_class="B",sl_type=1,sl_skillltype=1,sl_target=1,sl_num=1,sl_soldier=9,sl_attack=0,sl_bufftype=0,sl_effect=0,sl_duration=0,sl_probability=0.6,sl_attackbackroww=1,},
	[10] = { sl_id=10,sl_name="行军速度增加",sl_icon="skill_2003",sl_action=10,sl_des="行军速度增加的描述",sl_user=2,sl_class="C",sl_type=1,sl_skillltype=3,sl_target=2,sl_num=1,sl_soldier=9,sl_attack=0,sl_bufftype=0,sl_effect=0,sl_duration=0,sl_probability=1,sl_attackbackroww=0,},
	[11] = { sl_id=11,sl_name="防御力增加",sl_icon="skill_2004",sl_action=11,sl_des="防御力增加的描述",sl_user=2,sl_class="C",sl_type=1,sl_skillltype=2,sl_target=2,sl_num=1,sl_soldier=9,sl_attack=0,sl_bufftype=0,sl_effect=0,sl_duration=0,sl_probability=1,sl_attackbackroww=0,},
}
return SkillList
