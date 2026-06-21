/obj/item/ammo_box/magazine/m223
	name = "顶装式弹匣（.223）"
	desc = "一个顶装式.223弹匣，适用于M-90gl卡宾枪。"
	icon_state = ".223"
	ammo_band_icon = "+.223ab"
	ammo_type = /obj/item/ammo_casing/a223
	caliber = CALIBER_A223
	max_ammo = 30
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/ammo_box/magazine/m223/phasic
	name = "顶装式弹匣（.223相位）"
	desc = parent_type::desc + "<br>携带相位子弹，能完全无视护甲并穿透掩体，但不会穿透目标。"
	ammo_type = /obj/item/ammo_casing/a223/phasic

// .38 (Battle Rifle) //

/obj/item/ammo_box/magazine/m38
	name = "战斗步枪弹匣（.38）"
	desc = "一个用于BR-38战斗步枪的.38弹匣。"
	icon_state = "38mag"
	base_icon_state = "38mag"
	w_class = WEIGHT_CLASS_NORMAL
	ammo_type = /obj/item/ammo_casing/c38
	caliber = CALIBER_38
	custom_materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT * 4,
		/datum/material/plastic = HALF_SHEET_MATERIAL_AMOUNT * 1,
	)
	max_ammo = 15
	ammo_band_icon = "+38mag_ammo_band"
	ammo_band_color = null

/obj/item/ammo_box/magazine/m38/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state][ammo_count() ? "-ammo" : ""]"

/obj/item/ammo_box/magazine/m38/empty
	start_empty = TRUE

/obj/item/ammo_box/magazine/m38/trac
	name = "战斗步枪弹匣（.38追踪）"
	desc = parent_type::desc + "追踪子弹会在目标体内植入一个追踪器，并且完全是非致命的。"
	ammo_type = /obj/item/ammo_casing/c38/trac
	ammo_band_color = COLOR_AMMO_TRACK

/obj/item/ammo_box/magazine/m38/match
	name = "战斗步枪弹匣（.38竞赛）"
	desc = parent_type::desc + "这些子弹在极其严格的公差范围内制造，使得它们易于展示特技射击。"
	ammo_type = /obj/item/ammo_casing/c38/match
	ammo_band_color = COLOR_AMMO_MATCH

/obj/item/ammo_box/magazine/m38/match/bouncy
	name = "战斗步枪弹匣（.38橡胶）"
	desc = parent_type::desc + "这些子弹具有极强的弹性并且基本是非致命的，非常适合展示特技射击。"
	ammo_type = /obj/item/ammo_casing/c38/match/bouncy
	ammo_band_color = COLOR_AMMO_RUBBER

/obj/item/ammo_box/magazine/m38/true
	name = "战斗步枪弹匣（.38真实打击）"
	desc = parent_type::desc + "子弹会以惊人的准确度弹向新目标，并能击穿装甲目标"
	ammo_type = /obj/item/ammo_casing/c38/match/true
	ammo_band_color = COLOR_AMMO_TRUESTRIKE

/obj/item/ammo_box/magazine/m38/dumdum
	name = "战斗步枪弹匣 (.38 达姆弹)"
	desc = parent_type::desc + "这些弹头在撞击时会扩张，使其能够撕裂目标并造成大出血。对护甲和远距离目标效果极差。"
	ammo_type = /obj/item/ammo_casing/c38/dumdum
	ammo_band_color = COLOR_AMMO_DUMDUM

/obj/item/ammo_box/magazine/m38/hotshot
	name = "战斗步枪弹匣 (.38 热射弹)"
	desc = parent_type::desc + "热射弹内含燃烧装药。"
	ammo_type = /obj/item/ammo_casing/c38/hotshot
	ammo_band_color = COLOR_AMMO_HOTSHOT

/obj/item/ammo_box/magazine/m38/iceblox
	name = "战斗步枪弹匣 (.38 冰封弹)"
	desc = parent_type::desc + "冰封弹内含冷冻装药。"
	ammo_type = /obj/item/ammo_casing/c38/iceblox
	ammo_band_color = COLOR_AMMO_ICEBLOX

/obj/item/ammo_box/magazine/m38/flare
	name = "战斗步枪弹匣 (.38 信号弹)"
	desc = parent_type::desc + "信号弹壳会向目标发射一道集中的粒子束，使其在众人面前暴露无遗。"
	ammo_type = /obj/item/ammo_casing/c38/flare
	ammo_band_color = COLOR_AMMO_HELLFIRE
