// NOVA MODULE IC-SPAWNING https://github.com/Skyrat-SS13/Skyrat-tg/pull/104
/obj/item/card/id/advanced/debug/bst
	name = "\improper 蓝空ID卡"
	desc = "一张蓝空ID卡。拥有所有访问权限，你真的不该拥有这个。"
	icon_state = "card_centcom"
	assigned_icon_state = "assigned_centcom"
	trim = /datum/id_trim/admin/bst
	wildcard_slots = WILDCARD_LIMIT_ADMIN

/datum/id_trim/admin/bst
	assignment = "Bluespace Technician"
	trim_state = "trim_stationengineer"
	department_color = COLOR_CENTCOM_BLUE
	subdepartment_color = COLOR_ENGINEERING_ORANGE
	sechud_icon_state = SECHUD_SCRAMBLED
