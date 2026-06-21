/area/station/medical
	name = "医疗部"
	icon_state = "medbay"
	ambience_index = AMBIENCE_MEDICAL
	airlock_wires = /datum/wires/airlock/medbay
	sound_environment = SOUND_AREA_STANDARD_STATION
	tacmap_color = TACMAP_AREA_MEDICAL

/area/station/medical/abandoned
	name = "\improper 废弃医疗湾"
	icon_state = "abandoned_medbay"
	ambientsounds = list(
		'sound/ambience/misc/signal.ogg',
		)
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	tacmap_color = TACMAP_AREA_MAINTENANCE

/area/station/medical/medbay/central
	name = "医疗湾中心"
	icon_state = "med_central"

/area/station/medical/lower
	name = "\improper 下层医疗湾"
	icon_state = "lower_med"

/area/station/medical/medbay/lobby
	name = "\improper 医疗湾大厅"
	icon_state = "med_lobby"

/area/station/medical/medbay/aft
	name = "医疗湾后部"
	icon_state = "med_aft"

/area/station/medical/storage
	name = "医疗湾储藏室"
	icon_state = "med_storage"

/area/station/medical/paramedic
	name = "急救员调度室"
	icon_state = "paramedic"

/area/station/medical/office
	name = "\improper 医疗办公室"
	icon_state = "med_office"

/area/station/medical/break_room
	name = "\improper 医疗休息室"
	icon_state = "med_break"

/area/station/medical/coldroom
	name = "\improper 医疗冷藏室"
	icon_state = "kitchen_cold"

/area/station/medical/patients_rooms
	name = "\improper 病房"
	icon_state = "patients"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/station/medical/patients_rooms/room_a
	name = "A病房"
	icon_state = "patients"

/area/station/medical/patients_rooms/room_b
	name = "B病房"
	icon_state = "patients"

/area/station/medical/virology
	name = "病毒学实验室"
	icon_state = "virology"
	ambience_index = AMBIENCE_VIROLOGY

/area/station/medical/virology/isolation
	name = "病毒学隔离室"
	icon_state = "virology_isolation"

/area/station/medical/morgue
	name = "\improper 停尸房"
	icon_state = "morgue"
	ambience_index = AMBIENCE_SPOOKY
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/medical/chemistry
	name = "化学实验室"
	icon_state = "chem"

/area/station/medical/chemistry/minisat
	name = "化学实验室微型卫星站"

/area/station/medical/pharmacy
	name = "\improper 药房"
	icon_state = "pharmacy"

/area/station/medical/chem_storage
	name = "\improper 化学品储藏室"
	icon_state = "chem_storage"

/area/station/medical/surgery
	name = "\improper 手术室"
	icon_state = "surgery"

/area/station/medical/surgery/fore
	name = "\improper 前部手术室"
	icon_state = "foresurgery"

/area/station/medical/surgery/aft
	name = "\improper 后部手术室"
	icon_state = "aftsurgery"

/area/station/medical/surgery/theatre
	name = "\improper 大型手术室"
	icon_state = "surgerytheatre"

/area/station/medical/cryo
	name = "低温休眠室"
	icon_state = "cryo"

/area/station/medical/exam_room
	name = "\improper 检查室"
	icon_state = "exam_room"

/area/station/medical/treatment_center
	name = "\improper 医疗部治疗中心"
	icon_state = "exam_room"

/area/station/medical/psychology
	name = "\improper 心理诊疗室"
	icon_state = "psychology"
	mood_bonus = 3
	mood_message = "I feel at ease here."
	ambientsounds = list(
		'sound/ambience/aurora_caelus/aurora_caelus_short.ogg',
		)
