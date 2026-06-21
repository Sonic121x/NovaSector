/datum/id_trim/away/tarkon
	assignment = "P-T Deck Worker"
	access = list(ACCESS_AWAY_GENERAL, ACCESS_WEAPONS, ACCESS_TARKON)
	department_color = COLOR_WHITE
	department_state = "department"
	subdepartment_color = COLOR_DARK_CYAN
	sechud_icon_state = SECHUD_UNKNOWN
	trim_state = "trim_unknown"

/obj/item/card/id/advanced/tarkon
	name = "塔康甲板访问通行证"
	desc = "一张积满灰尘的访客通行证，上面有一行小字写着“塔康港，太空家园民用合作的第一步”。"
	icon = 'modular_nova/modules/tarkon/icons/misc/card.dmi'
	icon_state = "tarkon"
	trim = /datum/id_trim/away/tarkon
	assigned_icon_state = "assigned_tarkon"

/datum/id_trim/away/tarkon/cargo
	assignment = "P-T Cargo Personnel"
	access = list(ACCESS_AWAY_GENERAL, ACCESS_WEAPONS, ACCESS_TARKON)
	department_color = COLOR_DARK_BROWN
	department_state = "department"
	sechud_icon_state = SECHUD_CARGO_TECHNICIAN
	trim_state = "trim_cargotechnician"

/obj/item/card/id/advanced/tarkon/cargo
	name = "P-T 货运搬运工门禁卡"
	desc = "An access card designated for \"cargo's finest\". You're also a part time space miner, when cargonia is quiet."
	trim = /datum/id_trim/away/tarkon/cargo

/datum/id_trim/away/tarkon/sec
	assignment = "P-T Port Guard"
	access = list(ACCESS_AWAY_GENERAL, ACCESS_WEAPONS, ACCESS_TARKON)
	department_color = COLOR_DARK_RED
	sechud_icon_state = SECHUD_SECURITY_OFFICER
	trim_state = "trim_securityofficer"

/datum/id_trim/away/tarkon/med
	assignment = "P-T Trauma Medic"
	access = list(ACCESS_MEDICAL, ACCESS_AWAY_GENERAL, ACCESS_WEAPONS, ACCESS_TARKON)
	department_color = COLOR_MEDICAL_BLUE
	sechud_icon_state = SECHUD_MEDICAL_DOCTOR
	trim_state = "trim_medicaldoctor"

/obj/item/card/id/advanced/tarkon/med
	name = "P-T 创伤急救员门禁卡"
	desc = "一张指定给“医疗人员”的门禁卡。你负责提供医疗包。"
	trim = /datum/id_trim/away/tarkon/med

/datum/id_trim/away/tarkon/eng
	assignment = "P-T Maintenance Crew"
	department_color = COLOR_ENGINEERING_ORANGE
	sechud_icon_state = SECHUD_STATION_ENGINEER
	trim_state = "trim_stationengineer"

/obj/item/card/id/advanced/tarkon/engi
	name = "P-T 维护区工程师门禁卡"
	desc = "一张指定给“工程部人员”的门禁卡。老实说，你会是那个被所有人指着去修东西的人。"
	trim = /datum/id_trim/away/tarkon/eng

/datum/id_trim/away/tarkon/sci
	assignment = "P-T Field Researcher"
	access = list(ACCESS_AWAY_GENERAL, ACCESS_WEAPONS, ACCESS_TARKON)
	department_color = COLOR_SCIENCE_PINK
	sechud_icon_state = SECHUD_SCIENTIST
	trim_state = "trim_scientist"

/obj/item/card/id/advanced/tarkon/sci
	name = "P-T 实地研究员门禁卡"
	desc = "一张指定给“科研团队”的门禁卡。说到实验室，你基本上立刻就被遗忘了。"
	trim = /datum/id_trim/away/tarkon/sci

/datum/id_trim/away/tarkon/robo
	access = list(ACCESS_ROBOTICS)

/obj/item/card/id/away/tarkonrobo
	name = "塔康机器人门禁卡"
	desc = "一张设计用于访问机器人接入端口的门禁卡，由塔康工业提供。"
	icon = 'modular_nova/modules/tarkon/icons/misc/card.dmi'
	icon_state = "robotics"
	trim = /datum/id_trim/away/tarkon/robo

/datum/id_trim/away/tarkon/ensign
	assignment = "Tarkon Ensign"
	access = list(ACCESS_MEDICAL, ACCESS_ROBOTICS, ACCESS_AWAY_GENERAL, ACCESS_TARKON, ACCESS_WEAPONS)
	department_color = COLOR_COMMAND_BLUE
	sechud_icon_state = SECHUD_BLUESHIELD
	trim_icon = 'modular_nova/master_files/icons/obj/card.dmi'
	trim_state = "trim_blueshield"

/obj/item/card/id/advanced/tarkon/sec
	name = "P-T 驻地副警长门禁卡"
	desc = "一张指定给“安保成员”的门禁卡。每个人都想要你的枪，搭档。耶哈。"
	trim = /datum/id_trim/away/tarkon/sec


/obj/item/card/id/advanced/tarkon/ensign
	name = "塔康少尉门禁卡"
	desc = "一张指定给“塔康少尉”的门禁卡。没人必须听你的……但你是这里最接近指挥的人了。"
	trim = /datum/id_trim/away/tarkon/ensign

/datum/id_trim/away/tarkon/director
	assignment = "Tarkon Port Director"
	access = list(ACCESS_MEDICAL, ACCESS_ROBOTICS, ACCESS_AWAY_GENERAL, ACCESS_TARKON, ACCESS_WEAPONS)
	department_color = COLOR_COMMAND_BLUE
	sechud_icon_state = SECHUD_BLUESHIELD
	trim_state = "trim_captain"

/obj/item/card/id/advanced/tarkon/director
	name = "塔康港口主管门禁卡"
	desc = "一张指定给“塔康港口主管”的门禁卡。不再有犹豫，只有考量。"
	trim = /datum/id_trim/away/tarkon/director
