
--箭塔配置

require("app.config.battleConfig.AnimationConfig")

ArrowTowerTab = {}
ArrowTowerTab.moveSpeed = 0   --移动速度
ArrowTowerTab.beRecSize = cc.size(70,74)  --受击区大小
ArrowTowerTab.attack_distance = 3700   --攻击距离

ArrowTowerTab.idle = {}
ArrowTowerTab.idle[ANMATION_DIR.UP] = "arrowTower_idle_1_"
ArrowTowerTab.idle[ANMATION_DIR.RIGHT_UP] = "arrowTower_idle_1_"
ArrowTowerTab.idle[ANMATION_DIR.RIGHT] = "arrowTower_idle_1_"
ArrowTowerTab.idle[ANMATION_DIR.RIGHT_DOWN] = "arrowTower_idle_1_"
ArrowTowerTab.idle[ANMATION_DIR.DOWN] = "arrowTower_idle_1_"
ArrowTowerTab.idle.begin = 0
ArrowTowerTab.idle.count = 1
ArrowTowerTab.idle.time = 1
ArrowTowerTab.idle.defaultFileName = "00000.png"

ArrowTowerTab.hurt = {}
ArrowTowerTab.hurt[ANMATION_DIR.UP] = "arrowTower_idle_1_"
ArrowTowerTab.hurt[ANMATION_DIR.RIGHT_UP] = "arrowTower_idle_1_"
ArrowTowerTab.hurt[ANMATION_DIR.RIGHT] = "arrowTower_idle_1_"
ArrowTowerTab.hurt[ANMATION_DIR.RIGHT_DOWN] = "arrowTower_idle_1_"
ArrowTowerTab.hurt[ANMATION_DIR.DOWN] = "arrowTower_idle_1_"
ArrowTowerTab.hurt.begin = 0
ArrowTowerTab.hurt.count = 1
ArrowTowerTab.hurt.time = 0.5
ArrowTowerTab.hurt.defaultFileName = "00000.png"

ArrowTowerTab.death = {}
ArrowTowerTab.death[ANMATION_DIR.UP] = "arowTower_die_1_"
ArrowTowerTab.death[ANMATION_DIR.RIGHT_UP] = "arowTower_die_1_"
ArrowTowerTab.death[ANMATION_DIR.RIGHT] = "arowTower_die_1_"
ArrowTowerTab.death[ANMATION_DIR.RIGHT_DOWN] = "arowTower_die_1_"
ArrowTowerTab.death[ANMATION_DIR.DOWN] = "arowTower_die_1_"
ArrowTowerTab.death.begin = 0
ArrowTowerTab.death.count = 3
ArrowTowerTab.death.time = 0.4
ArrowTowerTab.death.defaultFileName = "00000.png"

ArrowTowerTab.att1 = {}
ArrowTowerTab.att1[ANMATION_DIR.UP] = "arrowTower_idle_1_"
ArrowTowerTab.att1[ANMATION_DIR.RIGHT_UP] = "arrowTower_idle_1_"
ArrowTowerTab.att1[ANMATION_DIR.RIGHT] = "arrowTower_idle_1_"
ArrowTowerTab.att1[ANMATION_DIR.RIGHT_DOWN] = "arrowTower_idle_1_"
ArrowTowerTab.att1[ANMATION_DIR.DOWN] = "arrowTower_idle_1_"
ArrowTowerTab.att1.begin = 0
ArrowTowerTab.att1.count = 1
ArrowTowerTab.att1.time = 1
ArrowTowerTab.att1.delayAttCheckTime = 0.5       --攻击延迟检测时间
ArrowTowerTab.att1.flySpeed = 600
ArrowTowerTab.att1.cdTime = 2
ArrowTowerTab.att1.defaultFileName = "00000.png"
ArrowTowerTab.att1.worldMap_time = 1   --地图上的AI攻击时间配置
ArrowTowerTab.att1.WorldMap_flySpeed = 400

ArrowTowerTab.effect = {}
ArrowTowerTab.effect.att1 = {}
ArrowTowerTab.effect.att1.path = "effect/arrow/e_gongshou_flyer_1_"
ArrowTowerTab.effect.att1.begin = 0
ArrowTowerTab.effect.att1.count = 4
ArrowTowerTab.effect.att1.time = 1
ArrowTowerTab.effect.att1.delayPlayEffectTime = 0.8
ArrowTowerTab.effect.att1.size = {}
ArrowTowerTab.effect.att1.size.width = 15
ArrowTowerTab.effect.att1.size.height = 20
ArrowTowerTab.effect.att1.defaultFileName = "00000.png"
ArrowTowerTab.effect.att1.worldMap_time = 1  

ArrowTowerTab.effect.hurt1 = {}
ArrowTowerTab.effect.hurt1.path = "effect/commAtt/e_gongjian_hit_1_"
ArrowTowerTab.effect.hurt1.begin = 0
ArrowTowerTab.effect.hurt1.count = 4
ArrowTowerTab.effect.hurt1.time = 0.5
ArrowTowerTab.effect.hurt1.defaultFileName = "00000.png"




