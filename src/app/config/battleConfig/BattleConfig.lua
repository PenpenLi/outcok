
--[[
	jinyan.zhang
	战斗相关配置
--]]

require("app.data.ArmsData")

BATTLE_CONFIG = {}  --战斗配置

BATTLE_CONFIG.SCALE = 0.5

--盾兵
BATTLE_CONFIG[SOLDIER_TYPE.shieldSoldier] = ShieldSoldierTab
--枪兵
BATTLE_CONFIG[SOLDIER_TYPE.marines] = MarinesTab
--骑士
BATTLE_CONFIG[SOLDIER_TYPE.knight] = KnightTab
--弓骑兵
BATTLE_CONFIG[SOLDIER_TYPE.bowCavalry] = BowCavalryTab
--弓兵
BATTLE_CONFIG[SOLDIER_TYPE.archer] = ArcherConfigTab
--弩兵
BATTLE_CONFIG[SOLDIER_TYPE.crossbowmen] = CrossbowmenTab
--冲车
BATTLE_CONFIG[SOLDIER_TYPE.tank] = TankTab
--投石车
BATTLE_CONFIG[SOLDIER_TYPE.catapult] = CatapultTab
--法师
BATTLE_CONFIG[SOLDIER_TYPE.master] = MasterTab
--术士
BATTLE_CONFIG[SOLDIER_TYPE.warlock] = WarlockTab
--箭塔
BATTLE_CONFIG[SOLDIER_TYPE.arrowTower] = ArrowTowerTab
--魔法塔
BATTLE_CONFIG[SOLDIER_TYPE.magicTower] = MagicTowerTab
--炮塔
BATTLE_CONFIG[SOLDIER_TYPE.turretTower] = TurretTowerTab













