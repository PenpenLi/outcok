
--炮塔配置

require("app.config.battleConfig.AnimationConfig")

TurretTowerTab = {}
TurretTowerTab.moveSpeed = 0   --移动速度
TurretTowerTab.beRecSize = cc.size(70,74)  --受击区大小
TurretTowerTab.attack_distance = 3400   --攻击距离

TurretTowerTab.idle = {}
TurretTowerTab.idle[ANMATION_DIR.UP] = "turret_idle_1_"
TurretTowerTab.idle[ANMATION_DIR.RIGHT_UP] = "turret_idle_1_"
TurretTowerTab.idle[ANMATION_DIR.RIGHT] = "turret_idle_1_"
TurretTowerTab.idle[ANMATION_DIR.RIGHT_DOWN] = "turret_idle_1_"
TurretTowerTab.idle[ANMATION_DIR.DOWN] = "turret_idle_1_"
TurretTowerTab.idle.begin = 0
TurretTowerTab.idle.count = 1
TurretTowerTab.idle.time = 1
TurretTowerTab.idle.defaultFileName = "00000.png"

TurretTowerTab.hurt = {}
TurretTowerTab.hurt[ANMATION_DIR.UP] = "turret_idle_1_"
TurretTowerTab.hurt[ANMATION_DIR.RIGHT_UP] = "turret_idle_1_"
TurretTowerTab.hurt[ANMATION_DIR.RIGHT] = "turret_idle_1_"
TurretTowerTab.hurt[ANMATION_DIR.RIGHT_DOWN] = "turret_idle_1_"
TurretTowerTab.hurt[ANMATION_DIR.DOWN] = "turret_idle_1_"
TurretTowerTab.hurt.begin = 0
TurretTowerTab.hurt.count = 1
TurretTowerTab.hurt.time = 0.5
TurretTowerTab.hurt.defaultFileName = "00000.png"

TurretTowerTab.death = {}
TurretTowerTab.death[ANMATION_DIR.UP] = "turetTower_die_1_"
TurretTowerTab.death[ANMATION_DIR.RIGHT_UP] = "turetTower_die_1_"
TurretTowerTab.death[ANMATION_DIR.RIGHT] = "turetTower_die_1_"
TurretTowerTab.death[ANMATION_DIR.RIGHT_DOWN] = "turetTower_die_1_"
TurretTowerTab.death[ANMATION_DIR.DOWN] = "turetTower_die_1_"
TurretTowerTab.death.begin = 0
TurretTowerTab.death.count = 3
TurretTowerTab.death.time = 0.4
TurretTowerTab.death.defaultFileName = "00000.png"

TurretTowerTab.att1 = {}
TurretTowerTab.att1[ANMATION_DIR.UP] = "turret_idle_1_"
TurretTowerTab.att1[ANMATION_DIR.RIGHT_UP] = "turret_idle_1_"
TurretTowerTab.att1[ANMATION_DIR.RIGHT] = "turret_idle_1_"
TurretTowerTab.att1[ANMATION_DIR.RIGHT_DOWN] = "turret_idle_1_"
TurretTowerTab.att1[ANMATION_DIR.DOWN] = "turret_idle_1_"
TurretTowerTab.att1.begin = 0
TurretTowerTab.att1.count = 1
TurretTowerTab.att1.time = 1
TurretTowerTab.att1.delayAttCheckTime = 0.5       --攻击延迟检测时间
TurretTowerTab.att1.flySpeed = 1000
TurretTowerTab.att1.cdTime = 2
TurretTowerTab.att1.defaultFileName = "00000.png"
TurretTowerTab.att1.worldMap_time = 1   --地图上的AI攻击时间配置
TurretTowerTab.att1.WorldMap_flySpeed = 400

TurretTowerTab.effect = {}
TurretTowerTab.effect.att1 = {}
TurretTowerTab.effect.att1.path = "effect/arrow/e_gongshou_flyer_1_"
TurretTowerTab.effect.att1.begin = 0
TurretTowerTab.effect.att1.count = 4
TurretTowerTab.effect.att1.time = 1
TurretTowerTab.effect.att1.delayPlayEffectTime = 0.8
TurretTowerTab.effect.att1.size = {}
TurretTowerTab.effect.att1.size.width = 15
TurretTowerTab.effect.att1.size.height = 20
TurretTowerTab.effect.att1.defaultFileName = "00000.png"
TurretTowerTab.effect.att1.worldMap_time = 1  

TurretTowerTab.effect.hurt1 = {}
TurretTowerTab.effect.hurt1.path = "effect/commAtt/e_gongjian_hit_1_"
TurretTowerTab.effect.hurt1.begin = 0
TurretTowerTab.effect.hurt1.count = 4
TurretTowerTab.effect.hurt1.time = 0.5
TurretTowerTab.effect.hurt1.defaultFileName = "00000.png"




