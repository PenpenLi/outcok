
--盾兵配置

require("app.config.battleConfig.AnimationConfig")

ShieldSoldierTab = {}
ShieldSoldierTab.moveSpeed = 100   --移动速度
ShieldSoldierTab.beRecSize = cc.size(70,74)  --受击区大小
ShieldSoldierTab.attack_distance = 70   --攻击距离

ShieldSoldierTab.idle = {}
ShieldSoldierTab.idle[ANMATION_DIR.UP] = "tuoer_idle_1_"
ShieldSoldierTab.idle[ANMATION_DIR.RIGHT_UP] = "tuoer_idle_2_"
ShieldSoldierTab.idle[ANMATION_DIR.RIGHT] = "tuoer_idle_3_"
ShieldSoldierTab.idle[ANMATION_DIR.RIGHT_DOWN] = "tuoer_idle_4_"
ShieldSoldierTab.idle[ANMATION_DIR.DOWN] = "tuoer_idle_5_"
ShieldSoldierTab.idle.begin = 0
ShieldSoldierTab.idle.count = 10
ShieldSoldierTab.idle.time = 1
ShieldSoldierTab.idle.defaultFileName = "00000.png"

ShieldSoldierTab.move = {}
ShieldSoldierTab.move[ANMATION_DIR.UP] = "tuoer_run_1_"
ShieldSoldierTab.move[ANMATION_DIR.RIGHT_UP] = "tuoer_run_2_"
ShieldSoldierTab.move[ANMATION_DIR.RIGHT] = "tuoer_run_3_"
ShieldSoldierTab.move[ANMATION_DIR.RIGHT_DOWN] = "tuoer_run_4_"
ShieldSoldierTab.move[ANMATION_DIR.DOWN] = "tuoer_run_5_"
ShieldSoldierTab.move.begin = 0
ShieldSoldierTab.move.count = 10
ShieldSoldierTab.move.time = 1
ShieldSoldierTab.move.defaultFileName = "00000.png"

ShieldSoldierTab.hurt = {}
ShieldSoldierTab.hurt[ANMATION_DIR.UP] = "tuoer_hit_1_"
ShieldSoldierTab.hurt[ANMATION_DIR.RIGHT_UP] = "tuoer_hit_2_"
ShieldSoldierTab.hurt[ANMATION_DIR.RIGHT] = "tuoer_hit_3_"
ShieldSoldierTab.hurt[ANMATION_DIR.RIGHT_DOWN] = "tuoer_hit_4_"
ShieldSoldierTab.hurt[ANMATION_DIR.DOWN] = "tuoer_hit_5_"
ShieldSoldierTab.hurt.begin = 0
ShieldSoldierTab.hurt.count = 6
ShieldSoldierTab.hurt.time = 0.5
ShieldSoldierTab.hurt.defaultFileName = "00000.png"

ShieldSoldierTab.death = {}
ShieldSoldierTab.death[ANMATION_DIR.UP] = "tuoer_die_1_"
ShieldSoldierTab.death[ANMATION_DIR.RIGHT_UP] = "tuoer_die_2_"
ShieldSoldierTab.death[ANMATION_DIR.RIGHT] = "tuoer_die_3_"
ShieldSoldierTab.death[ANMATION_DIR.RIGHT_DOWN] = "tuoer_die_4_"
ShieldSoldierTab.death[ANMATION_DIR.DOWN] = "tuoer_die_5_"
ShieldSoldierTab.death.begin = 0
ShieldSoldierTab.death.count = 8
ShieldSoldierTab.death.time = 0.4
ShieldSoldierTab.death.defaultFileName = "00000.png"

ShieldSoldierTab.att1 = {}
ShieldSoldierTab.att1[ANMATION_DIR.UP] = "tuoer_attack1_1_"
ShieldSoldierTab.att1[ANMATION_DIR.RIGHT_UP] = "tuoer_attack1_2_"
ShieldSoldierTab.att1[ANMATION_DIR.RIGHT] = "tuoer_attack1_3_"
ShieldSoldierTab.att1[ANMATION_DIR.RIGHT_DOWN] = "tuoer_attack1_4_"
ShieldSoldierTab.att1[ANMATION_DIR.DOWN] = "tuoer_attack1_5_"
ShieldSoldierTab.att1.begin = 0
ShieldSoldierTab.att1.count = 9
ShieldSoldierTab.att1.time = 2
ShieldSoldierTab.att1.delayAttCheckTime = 0.5
ShieldSoldierTab.att1.cdTime = 2
ShieldSoldierTab.att1.defaultFileName = "00000.png"
ShieldSoldierTab.att1.worldMap_time = 1 

ShieldSoldierTab.att2 = {}
ShieldSoldierTab.att2[ANMATION_DIR.UP] = "tuoer_attack2_1_"
ShieldSoldierTab.att2[ANMATION_DIR.RIGHT_UP] = "tuoer_attack2_2_"
ShieldSoldierTab.att2[ANMATION_DIR.RIGHT] = "tuoer_attack2_3_"
ShieldSoldierTab.att2[ANMATION_DIR.RIGHT_DOWN] = "tuoer_attack2_4_"
ShieldSoldierTab.att2[ANMATION_DIR.DOWN] = "tuoer_attack2_5_"
ShieldSoldierTab.att2.begin = 0
ShieldSoldierTab.att2.count = 11
ShieldSoldierTab.att2.time = 2
ShieldSoldierTab.att2.delayAttCheckTime = 0.5
ShieldSoldierTab.att2.cdTime = 2
ShieldSoldierTab.att2.defaultFileName = "00000.png"
ShieldSoldierTab.att2.worldMap_time = 1 

ShieldSoldierTab.effect = {}
ShieldSoldierTab.effect.att1 = {}
ShieldSoldierTab.effect.att1[ANMATION_DIR.UP] = "e_tuoer_attack1_1_"
ShieldSoldierTab.effect.att1[ANMATION_DIR.RIGHT_UP] = "e_tuoer_attack1_2_"
ShieldSoldierTab.effect.att1[ANMATION_DIR.RIGHT] = "e_tuoer_attack1_3_"
ShieldSoldierTab.effect.att1[ANMATION_DIR.RIGHT_DOWN] = "e_tuoer_attack1_4_"
ShieldSoldierTab.effect.att1[ANMATION_DIR.DOWN] = "e_tuoer_attack1_5_"
ShieldSoldierTab.effect.att1.begin = 0
ShieldSoldierTab.effect.att1.count = 12
ShieldSoldierTab.effect.att1.time = 2
ShieldSoldierTab.effect.att1.delayPlayEffectTime = 0
ShieldSoldierTab.effect.att1.size = {}
ShieldSoldierTab.effect.att1.size.width = 15
ShieldSoldierTab.effect.att1.size.height = 20
ShieldSoldierTab.effect.att1.defaultFileName = "00000.png"
ShieldSoldierTab.effect.att1.worldMap_time = 1  

ShieldSoldierTab.effect.att2 = {}
ShieldSoldierTab.effect.att2[ANMATION_DIR.UP] = "e_tuoer_attack2_1_"
ShieldSoldierTab.effect.att2[ANMATION_DIR.RIGHT_UP] = "e_tuoer_attack2_2_"
ShieldSoldierTab.effect.att2[ANMATION_DIR.RIGHT] = "e_tuoer_attack2_3_"
ShieldSoldierTab.effect.att2[ANMATION_DIR.RIGHT_DOWN] = "e_tuoer_attack2_4_"
ShieldSoldierTab.effect.att2[ANMATION_DIR.DOWN] = "e_tuoer_attack2_5_"
ShieldSoldierTab.effect.att2.begin = 0
ShieldSoldierTab.effect.att2.count = 11
ShieldSoldierTab.effect.att2.time = 2
ShieldSoldierTab.effect.att2.delayPlayEffectTime = 0
ShieldSoldierTab.effect.att2.size = {}
ShieldSoldierTab.effect.att2.size.width = 15
ShieldSoldierTab.effect.att2.size.height = 20
ShieldSoldierTab.effect.att2.defaultFileName = "00000.png"
ShieldSoldierTab.effect.att2.worldMap_time = 1  

ShieldSoldierTab.effect.hurt1 = {}
ShieldSoldierTab.effect.hurt1.path = "et_magichero_lv1_hit_"
ShieldSoldierTab.effect.hurt1.begin = 0
ShieldSoldierTab.effect.hurt1.count = 6
ShieldSoldierTab.effect.hurt1.time = 0.5
ShieldSoldierTab.effect.hurt1.defaultFileName = "00000.png"

