
--枪兵配置

require("app.config.battleConfig.AnimationConfig")

MarinesTab = {}
MarinesTab.moveSpeed = 100   --移动速度
MarinesTab.beRecSize = cc.size(70,74)  --受击区大小
MarinesTab.attack_distance = 70   --攻击距离

MarinesTab.idle = {}
MarinesTab.idle[ANMATION_DIR.UP] = "tuoer_idle_1_"
MarinesTab.idle[ANMATION_DIR.RIGHT_UP] = "tuoer_idle_2_"
MarinesTab.idle[ANMATION_DIR.RIGHT] = "tuoer_idle_3_"
MarinesTab.idle[ANMATION_DIR.RIGHT_DOWN] = "tuoer_idle_4_"
MarinesTab.idle[ANMATION_DIR.DOWN] = "tuoer_idle_5_"
MarinesTab.idle.begin = 0
MarinesTab.idle.count = 10
MarinesTab.idle.time = 1
MarinesTab.idle.defaultFileName = "00000.png"

MarinesTab.move = {}
MarinesTab.move[ANMATION_DIR.UP] = "tuoer_run_1_"
MarinesTab.move[ANMATION_DIR.RIGHT_UP] = "tuoer_run_2_"
MarinesTab.move[ANMATION_DIR.RIGHT] = "tuoer_run_3_"
MarinesTab.move[ANMATION_DIR.RIGHT_DOWN] = "tuoer_run_4_"
MarinesTab.move[ANMATION_DIR.DOWN] = "tuoer_run_5_"
MarinesTab.move.begin = 0
MarinesTab.move.count = 10
MarinesTab.move.time = 1
MarinesTab.move.defaultFileName = "00000.png"

MarinesTab.hurt = {}
MarinesTab.hurt[ANMATION_DIR.UP] = "tuoer_hit_1_"
MarinesTab.hurt[ANMATION_DIR.RIGHT_UP] = "tuoer_hit_2_"
MarinesTab.hurt[ANMATION_DIR.RIGHT] = "tuoer_hit_3_"
MarinesTab.hurt[ANMATION_DIR.RIGHT_DOWN] = "tuoer_hit_4_"
MarinesTab.hurt[ANMATION_DIR.DOWN] = "tuoer_hit_5_"
MarinesTab.hurt.begin = 0
MarinesTab.hurt.count = 6
MarinesTab.hurt.time = 0.5
MarinesTab.hurt.defaultFileName = "00000.png"

MarinesTab.death = {}
MarinesTab.death[ANMATION_DIR.UP] = "tuoer_die_1_"
MarinesTab.death[ANMATION_DIR.RIGHT_UP] = "tuoer_die_2_"
MarinesTab.death[ANMATION_DIR.RIGHT] = "tuoer_die_3_"
MarinesTab.death[ANMATION_DIR.RIGHT_DOWN] = "tuoer_die_4_"
MarinesTab.death[ANMATION_DIR.DOWN] = "tuoer_die_5_"
MarinesTab.death.begin = 0
MarinesTab.death.count = 8
MarinesTab.death.time = 0.4
MarinesTab.death.defaultFileName = "00000.png"

MarinesTab.att1 = {}
MarinesTab.att1[ANMATION_DIR.UP] = "tuoer_attack1_1_"
MarinesTab.att1[ANMATION_DIR.RIGHT_UP] = "tuoer_attack1_2_"
MarinesTab.att1[ANMATION_DIR.RIGHT] = "tuoer_attack1_3_"
MarinesTab.att1[ANMATION_DIR.RIGHT_DOWN] = "tuoer_attack1_4_"
MarinesTab.att1[ANMATION_DIR.DOWN] = "tuoer_attack1_5_"
MarinesTab.att1.begin = 0
MarinesTab.att1.count = 9
MarinesTab.att1.time = 2
MarinesTab.att1.delayAttCheckTime = 0.5
MarinesTab.att1.cdTime = 2
MarinesTab.att1.defaultFileName = "00000.png"
MarinesTab.att1.worldMap_time = 1 

MarinesTab.att2 = {}
MarinesTab.att2[ANMATION_DIR.UP] = "tuoer_attack2_1_"
MarinesTab.att2[ANMATION_DIR.RIGHT_UP] = "tuoer_attack2_2_"
MarinesTab.att2[ANMATION_DIR.RIGHT] = "tuoer_attack2_3_"
MarinesTab.att2[ANMATION_DIR.RIGHT_DOWN] = "tuoer_attack2_4_"
MarinesTab.att2[ANMATION_DIR.DOWN] = "tuoer_attack2_5_"
MarinesTab.att2.begin = 0
MarinesTab.att2.count = 11
MarinesTab.att2.time = 2
MarinesTab.att2.delayAttCheckTime = 0.5
MarinesTab.att2.cdTime = 2
MarinesTab.att2.defaultFileName = "00000.png"
MarinesTab.att2.worldMap_time = 1 

MarinesTab.effect = {}
MarinesTab.effect.att1 = {}
MarinesTab.effect.att1[ANMATION_DIR.UP] = "e_tuoer_attack1_1_"
MarinesTab.effect.att1[ANMATION_DIR.RIGHT_UP] = "e_tuoer_attack1_2_"
MarinesTab.effect.att1[ANMATION_DIR.RIGHT] = "e_tuoer_attack1_3_"
MarinesTab.effect.att1[ANMATION_DIR.RIGHT_DOWN] = "e_tuoer_attack1_4_"
MarinesTab.effect.att1[ANMATION_DIR.DOWN] = "e_tuoer_attack1_5_"
MarinesTab.effect.att1.begin = 0
MarinesTab.effect.att1.count = 12
MarinesTab.effect.att1.time = 2
MarinesTab.effect.att1.delayPlayEffectTime = 0
MarinesTab.effect.att1.size = {}
MarinesTab.effect.att1.size.width = 15
MarinesTab.effect.att1.size.height = 20
MarinesTab.effect.att1.defaultFileName = "00000.png"
MarinesTab.effect.att1.worldMap_time = 1  

MarinesTab.effect.att2 = {}
MarinesTab.effect.att2[ANMATION_DIR.UP] = "e_tuoer_attack2_1_"
MarinesTab.effect.att2[ANMATION_DIR.RIGHT_UP] = "e_tuoer_attack2_2_"
MarinesTab.effect.att2[ANMATION_DIR.RIGHT] = "e_tuoer_attack2_3_"
MarinesTab.effect.att2[ANMATION_DIR.RIGHT_DOWN] = "e_tuoer_attack2_4_"
MarinesTab.effect.att2[ANMATION_DIR.DOWN] = "e_tuoer_attack2_5_"
MarinesTab.effect.att2.begin = 0
MarinesTab.effect.att2.count = 11
MarinesTab.effect.att2.time = 2
MarinesTab.effect.att2.delayPlayEffectTime = 0
MarinesTab.effect.att2.size = {}
MarinesTab.effect.att2.size.width = 15
MarinesTab.effect.att2.size.height = 20
MarinesTab.effect.att2.defaultFileName = "00000.png"
MarinesTab.effect.att2.worldMap_time = 1  

MarinesTab.effect.hurt1 = {}
MarinesTab.effect.hurt1.path = "et_magichero_lv1_hit_"
MarinesTab.effect.hurt1.begin = 0
MarinesTab.effect.hurt1.count = 6
MarinesTab.effect.hurt1.time = 0.5
MarinesTab.effect.hurt1.defaultFileName = "00000.png"

