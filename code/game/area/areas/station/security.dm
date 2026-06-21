// When adding a new area to the security areas, make sure to add it to /datum/bounty/patrol as well!

/area/station/security
	name = "安保部"
	icon_state = "security"
	ambience_index = AMBIENCE_DANGER
	airlock_wires = /datum/wires/airlock/security
	sound_environment = SOUND_AREA_STANDARD_STATION
	tacmap_color = TACMAP_AREA_SECURITY

/area/station/security/office
	name = "\improper 安保办公室"
	icon_state = "security"

/area/station/security/breakroom
	name = "\improper 安保休息室"
	icon_state = "brig"

/area/station/security/tram
	name = "\improper 安保转运电车"
	icon_state = "security"

/area/station/security/lockers
	name = "\improper 安保更衣室"
	icon_state = "securitylockerroom"

/area/station/security/brig
	name = "\improper 禁闭室"
	icon_state = "brig"

/area/station/security/holding_cell
	name = "\improper 拘留室"
	icon_state = "holding_cell"

/area/station/security/medical
	name = "\improper 安保医疗室"
	icon_state = "security_medical"

/area/station/security/brig/upper
	name = "\improper 禁闭室监控台"
	icon_state = "upperbrig"

/area/station/security/brig/lower
	name = "\improper 下层禁闭室"
	icon_state = "lower_brig"

/area/station/security/brig/entrance
	name = "\improper 禁闭室入口"
	icon_state = "brigentry"

/area/station/security/courtroom
	name = "\improper 法庭"
	icon_state = "courtroom"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/station/security/courtroom/holding
	name = "\improper 法庭犯人候审室"

/area/station/security/processing
	name = "\improper 劳役穿梭机停靠处"
	icon_state = "sec_labor_processing"

/area/station/security/processing/cremation
	name = "\improper 安保焚化室"
	icon_state = "sec_cremation"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/security/interrogation
	name = "\improper 审讯室"
	icon_state = "interrogation"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/security/warden
	name = "禁闭室控制中心"
	icon_state = "warden"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/station/security/evidence
	name = "证物储藏室"
	icon_state = "evidence"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/security/armory
	name = "\improper 军械库"
	icon_state = "armory"
	ambience_index = AMBIENCE_DANGER
	motion_monitored = TRUE

/area/station/security/armory/upper
	name = "上层军械库"

/area/station/security/detectives_office
	name = "\improper 侦探办公室"
	icon_state = "detective"
	ambientsounds = list(
		'sound/ambience/security/ambidet1.ogg',
		'sound/ambience/security/ambidet2.ogg',
		)

/area/station/security/detectives_office/private_investigators_office
	name = "\improper 私家侦探办公室"
	icon_state = "investigate_office"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/station/security/range
	name = "\improper 射击场"
	icon_state = "firingrange"

/area/station/security/eva
	name = "\improper 安保舱外活动区"
	icon_state = "sec_eva"

/area/station/security/execution
	icon_state = "execution_room"

/area/station/security/execution/transfer
	name = "\improper 转移中心"
	icon_state = "sec_processing"

/area/station/security/execution/education
	name = "\improper 囚犯教育室"

/area/station/security/mechbay
	name = "安保机甲库"
	icon_state = "sec_mechbay"

/*
* Security Checkpoints
*/

/area/station/security/checkpoint
	name = "\improper 安保检查点"
	icon_state = "checkpoint"

/area/station/security/checkpoint/escape
	name = "\improper 离港安保检查点"
	icon_state = "checkpoint_esc"

/area/station/security/checkpoint/arrivals
	name = "\improper 抵港安保检查点"
	icon_state = "checkpoint_arr"

/area/station/security/checkpoint/supply
	name = "安保岗哨 - 货舱"
	icon_state = "checkpoint_supp"

/area/station/security/checkpoint/engineering
	name = "安保岗哨 - 工程部"
	icon_state = "checkpoint_engi"

/area/station/security/checkpoint/medical
	name = "安保岗哨 - 医疗部"
	icon_state = "checkpoint_med"

/area/station/security/checkpoint/medical/medsci
	name = "安保岗哨 - 医学科研部"

/area/station/security/checkpoint/science
	name = "安保岗哨 - 科学部"
	icon_state = "checkpoint_sci"

/area/station/security/checkpoint/science/research
	name = "安保岗哨 - 研究分部"
	icon_state = "checkpoint_res"

/area/station/security/checkpoint/customs
	name = "海关"
	icon_state = "customs_point"

/area/station/security/checkpoint/customs/auxiliary
	name = "辅助海关"
	icon_state = "customs_point_aux"

/area/station/security/checkpoint/customs/fore
	name = "前部海关"
	icon_state = "customs_point_fore"

/area/station/security/checkpoint/customs/aft
	name = "船尾海关"
	icon_state = "customs_point_aft"

/area/station/security/checkpoint/first
	name = "安保岗哨 - 一楼"
	icon_state = "checkpoint_1"

/area/station/security/checkpoint/second
	name = "安保岗哨 - 二楼"
	icon_state = "checkpoint_2"

/area/station/security/checkpoint/third
	name = "安保岗哨 - 三楼"
	icon_state = "checkpoint_3"


/area/station/security/prison
	name = "\improper 监狱侧翼"
	icon_state = "sec_prison"
	area_flags = VALID_TERRITORY | BLOBS_ALLOWED | CULT_PERMITTED | PERSISTENT_ENGRAVINGS

//Rad proof
/area/station/security/prison/toilet
	name = "\improper 监狱厕所"
	icon_state = "sec_prison_safe"

// Rad proof
/area/station/security/prison/safe
	name = "\improper 监狱侧翼牢房"
	icon_state = "sec_prison_safe"

/area/station/security/prison/upper
	name = "\improper 上层监狱侧翼"
	icon_state = "prison_upper"

/area/station/security/prison/visit
	name = "\improper 监狱探视区"
	icon_state = "prison_visit"

/area/station/security/prison/rec
	name = "\improper 监狱娱乐室"
	icon_state = "prison_rec"

/area/station/security/prison/mess
	name = "\improper 监狱食堂"
	icon_state = "prison_mess"

/area/station/security/prison/work
	name = "\improper 监狱工作间"
	icon_state = "prison_work"

/area/station/security/prison/shower
	name = "\improper 监狱淋浴间"
	icon_state = "prison_shower"

/area/station/security/prison/workout
	name = "\improper 监狱健身房"
	icon_state = "prison_workout"

/area/station/security/prison/garden
	name = "\improper 监狱花园"
	icon_state = "prison_garden"
