
--魔法塔配置

require("app.config.battleConfig.AnimationConfig")

MagicTowerTab = {}
MagicTowerTab.moveSpeed = 0   --移动速度
MagicTowerTab.beRecSize = cc.size(70,74)  --受击区大小
MagicTowerTab.attack_distance = 3400   --攻击距离

MagicTowerTab.idle = {}
MagicTowerTab.idle[ANMATION_DIR.UP] = "magicTower_idle_1_"
MagicTowerTab.idle[ANMATION_DIR.RIGHT_UP] = "magicTower_idle_1_"
MagicTowerTab.idle[ANMATION_DIR.RIGHT] = "magicTower_idle_1_"
MagicTowerTab.idle[ANMATION_DIR.RIGHT_DOWN] = "magicTower_idle_1_"
MagicTowerTab.idle[ANMATION_DIR.DOWN] = "magicTower_idle_1_"
MagicTowerTab.idle.begin = 0
MagicTowerTab.idle.count = 1
MagicTowerTab.idle.time = 1
MagicTowerTab.idle.defaultFileName = "00000.png"

MagicTowerTab.hurt = {}
MagicTowerTab.hurt[ANMATION_DIR.UP] = "magicTower_idle_1_"
MagicTowerTab.hurt[ANMATION_DIR.RIGHT_UP] = "magicTower_idle_1_"
MagicTowerTab.hurt[ANMATION_DIR.RIGHT] = "magicTower_idle_1_"
MagicTowerTab.hurt[ANMATION_DIR.RIGHT_DOWN] = "magicTower_idle_1_"
MagicTowerTab.hurt[ANMATION_DIR.DOWN] = "magicTower_idle_1_"
MagicTowerTab.hurt.begin = 0
MagicTowerTab.hurt.count = 1
MagicTowerTab.hurt.time = 0.5
MagicTowerTab.hurt.defaultFileName = "00000.png"

MagicTowerTab.death = {}
MagicTowerTab.death[ANMATION_DIR.UP] = "magicTower_die_1_"
MagicTowerTab.death[ANMATION_DIR.RIGHT_UP] = "magicTower_die_1_"
MagicTowerTab.death[ANMATION_DIR.RIGHT] = "magicTower_die_1_"
MagicTowerTab.death[ANMATION_DIR.RIGHT_DOWN] = "magicTower_die_1_"
MagicTowerTab.death[ANMATION_DIR.DOWN] = "magicTower_die_1_"
MagicTowerTab.death.begin = 0
MagicTowerTab.death.count = 3
MagicTowerTab.death.time = 0.4
MagicTowerTab.death.defaultFileName = "00000.png"

MagicTowerTab.att1 = {}
MagicTowerTab.att1[ANMATION_DIR.UP] = "magicTower_idle_1_"
MagicTowerTab.att1[ANMATION_DIR.RIGHT_UP] = "magicTower_idle_1_"
MagicTowerTab.att1[ANMATION_DIR.RIGHT] = "magicTower_idle_1_"
MagicTowerTab.att1[ANMATION_DIR.RIGHT_DOWN] = "magicTower_idle_1_"
MagicTowerTab.att1[ANMATION_DIR.DOWN] = "magicTower_idle_1_"
MagicTowerTab.att1.begin = 0
MagicTowerTab.att1.count = 1
MagicTowerTab.att1.time = 1
MagicTowerTab.att1.delayAttCheckTime = 0.5       --攻击延迟检测时间
MagicTowerTab.att1.flySpeed = 800
MagicTowerTab.att1.cdTime = 2
MagicTowerTab.att1.defaultFileName = "00000.png"
MagicTowerTab.att1.worldMap_time = 1   --地图上的AI攻击时间配置
MagicTowerTab.att1.WorldMap_flySpeed = 400

MagicTowerTab.effect = {}
MagicTowerTab.effect.att1 = {}
MagicTowerTab.effect.att1.path = "effect/arrow/e_gongshou_flyer_1_"
MagicTowerTab.effect.att1.begin = 0
MagicTowerTab.effect.att1.count = 4
MagicTowerTab.effect.att1.time = 1
MagicTowerTab.effect.att1.delayPlayEffectTime = 0.8
MagicTowerTab.effect.att1.size = {}
MagicTowerTab.effect.att1.size.width = 15
MagicTowerTab.effect.att1.size.height = 20
MagicTowerTab.effect.att1.defaultFileName = "00000.png"
MagicTowerTab.effect.att1.worldMap_time = 1  

MagicTowerTab.effect.hurt1 = {}
MagicTowerTab.effect.hurt1.path = "effect/commAtt/e_gongjian_hit_1_"
MagicTowerTab.effect.hurt1.begin = 0
MagicTowerTab.effect.hurt1.count = 4
MagicTowerTab.effect.hurt1.time = 0.5
MagicTowerTab.effect.hurt1.defaultFileName = "00000.png"




