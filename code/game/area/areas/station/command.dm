/area/station/command
	name = "指挥区"
	icon_state = "command"
	ambientsounds = list(
		'sound/ambience/misc/signal.ogg',
		)
	airlock_wires = /datum/wires/airlock/command
	sound_environment = SOUND_AREA_STANDARD_STATION
	tacmap_color = TACMAP_AREA_COMMAND

/area/station/command/bridge
	name = "\improper 舰桥"
	icon_state = "bridge"

/area/station/command/meeting_room
	name = "\improper 部门主管会议室"
	icon_state = "meeting"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/station/command/meeting_room/council
	name = "\improper 议会厅"
	icon_state = "meeting"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/station/command/corporate_showroom
	name = "\improper 企业展示厅"
	icon_state = "showroom"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/station/command/corporate_suite
	name = "\improper 企业宾客套房"
	icon_state = "command"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/station/command/emergency_closet
	name = "\improper 公司应急储物间"
	icon_state = "command"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

// Monitored areas

/area/station/command/eva
	name = "EVA 存储区"
	icon_state = "eva"
	ambience_index = AMBIENCE_DANGER
	motion_monitored = TRUE

/area/station/command/eva/upper
	name = "上层 EVA 存储区"

/area/station/command/vault
	name = "\improper 金库"
	icon_state = "nuke_storage" // someone should change this, not me though
	motion_monitored = TRUE

/*
* Command Head Areas
*/

/area/station/command/heads_quarters
	icon_state = "heads_quarters"

/area/station/command/heads_quarters/captain
	name = "\improper 舰长办公室"
	icon_state = "captain"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/station/command/heads_quarters/captain/private
	name = "\improper 舰长宿舍"
	icon_state = "captain_private"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/station/command/heads_quarters/ce
	name = "\improper 总工程师办公室"
	icon_state = "ce_office"

/area/station/command/heads_quarters/cmo
	name = "\improper 首席医疗官办公室"
	icon_state = "cmo_office"

/area/station/command/heads_quarters/hop
	name = "\improper 人事主管办公室"
	icon_state = "hop_office"

/area/station/command/heads_quarters/hos
	name = "\improper 安保主管办公室"
	icon_state = "hos_office"

/area/station/command/heads_quarters/rd
	name = "\improper 研究主管办公室"
	icon_state = "rd_office"

/area/station/command/heads_quarters/qm
	name = "\improper 军需官办公室"
	icon_state = "qm_office"

/*
* Command - Teleporter
*/

/area/station/command/teleporter
	name = "\improper 传送室"
	icon_state = "teleporter"
	ambience_index = AMBIENCE_ENGI

/area/station/command/gateway
	name = "\improper 星门"
	icon_state = "gateway"
	ambience_index = AMBIENCE_ENGI

/*
* Command - Misc
*/

/area/station/command/corporate_dock
	name = "\improper 公司私人泊位"
	icon_state = "command"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR
