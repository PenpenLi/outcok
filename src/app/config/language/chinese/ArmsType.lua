--[[
	ArmsType.lua
--]]

local ArmsType=
{
	[1] = { at_id=1,at_name="步兵",at_against1=2,at_against1effect=0.1,at_against2=5,at_against2effect=0.1,at_against3=0,at_against3effect=0,at_against4=0,at_against4effect=0,at_subtype1name="盾兵",at_subtype2name="枪兵",},
	[2] = { at_id=2,at_name="骑兵",at_against1=3,at_against1effect=0.1,at_against2=5,at_against2effect=0.1,at_against3=0,at_against3effect=0,at_against4=0,at_against4effect=0,at_subtype1name="骑士",at_subtype2name="弓骑兵",},
	[3] = { at_id=3,at_name="弓兵",at_against1=1,at_against1effect=0.1,at_against2=5,at_against2effect=0.1,at_against3=0,at_against3effect=0,at_against4=0,at_against4effect=0,at_subtype1name="弓兵",at_subtype2name="弩兵",},
	[4] = { at_id=4,at_name="战车兵",at_against1=6,at_against1effect=0.1,at_against2=5,at_against2effect=0.1,at_against3=7,at_against3effect=0.1,at_against4=8,at_against4effect=0.1,at_subtype1name="冲车",at_subtype2name="投石车",},
	[5] = { at_id=5,at_name="法师兵",at_against1=1,at_against1effect=0.1,at_against2=2,at_against2effect=0.1,at_against3=3,at_against3effect=0.1,at_against4=4,at_against4effect=0.1,at_subtype1name="法师",at_subtype2name="术士",},
	[6] = { at_id=6,at_name="箭塔",at_against1=2,at_against1effect=0.1,at_against2=0,at_against2effect=0,at_against3=0,at_against3effect=0,at_against4=0,at_against4effect=0,at_subtype1name=0,at_subtype2name=0,},
	[7] = { at_id=7,at_name="炮塔",at_against1=1,at_against1effect=0.1,at_against2=0,at_against2effect=0,at_against3=0,at_against3effect=0,at_against4=0,at_against4effect=0,at_subtype1name=0,at_subtype2name=0,},
	[8] = { at_id=8,at_name="魔法塔",at_against1=3,at_against1effect=0.1,at_against2=0,at_against2effect=0,at_against3=0,at_against3effect=0,at_against4=0,at_against4effect=0,at_subtype1name=0,at_subtype2name=0,},
	[9] = { at_id=9,at_name="落石",at_against1=4,at_against1effect=-0.1,at_against2=0,at_against2effect=0,at_against3=0,at_against3effect=0,at_against4=0,at_against4effect=0,at_subtype1name=0,at_subtype2name=0,},
	[10] = { at_id=10,at_name="火箭",at_against1=4,at_against1effect=-0.1,at_against2=0,at_against2effect=0,at_against3=0,at_against3effect=0,at_against4=0,at_against4effect=0,at_subtype1name=0,at_subtype2name=0,},
	[11] = { at_id=11,at_name="滚木",at_against1=4,at_against1effect=-0.1,at_against2=0,at_against2effect=0,at_against3=0,at_against3effect=0,at_against4=0,at_against4effect=0,at_subtype1name=0,at_subtype2name=0,},
}
return ArmsType
