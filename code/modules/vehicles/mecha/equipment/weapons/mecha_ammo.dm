/obj/item/mecha_ammo
	name = "通用弹药箱"
	desc = "一箱未知武器的弹药."
	w_class = WEIGHT_CLASS_BULKY
	icon = 'icons/obj/weapons/guns/mecha_ammo.dmi'
	icon_state = "empty"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	var/rounds = 0
	var/direct_load //For weapons where we re-load the weapon itself rather than adding to the ammo storage.
	var/load_audio = 'sound/items/weapons/gun/general/mag_bullet_insert.ogg'
	var/ammo_type
	/// whether to qdel this mecha_ammo when it becomes empty
	var/qdel_on_empty = FALSE

/obj/item/mecha_ammo/update_name()
	. = ..()
	name = "[rounds ? null : "empty "][initial(name)]"

/obj/item/mecha_ammo/update_desc()
	. = ..()
	desc = rounds ? initial(desc) : "一个已被清空的动力装甲弹药箱。可以安全折叠以便回收。"

/obj/item/mecha_ammo/update_icon_state()
	icon_state = rounds ? initial(icon_state) : "[initial(icon_state)]_e"
	return ..()

/obj/item/mecha_ammo/attack_self(mob/user)
	..()
	if(rounds)
		to_chat(user, span_warning("弹药箱清空前无法压平！"))
		return

	to_chat(user, span_notice("你将[src]折叠平整。"))
	var/trash = new /obj/item/stack/sheet/iron(user.loc)
	qdel(src)
	user.put_in_hands(trash)

/obj/item/mecha_ammo/examine(mob/user)
	. = ..()
	if(rounds)
		. += "There [rounds > 1?"are":"is"] [rounds] [ammo_type][rounds > 1?"s":""] left."
	else
		. += span_notice("在手中使用可将其折叠成铁板。")

/obj/item/mecha_ammo/incendiary
	name = "燃烧子弹弹药箱"
	desc = "一箱燃烧弹药，用于机甲。"
	icon_state = "incendiary"
	custom_materials = list(/datum/material/iron= SHEET_MATERIAL_AMOUNT*3)
	rounds = 24
	ammo_type = MECHA_AMMO_INCENDIARY

/obj/item/mecha_ammo/scattershot
	name = "霰弹 弹药盒"
	desc = "一盒放大的霰弹，为大型机甲霰弹枪设计。"
	icon_state = "scattershot"
	custom_materials = list(/datum/material/iron= SHEET_MATERIAL_AMOUNT*3)
	rounds = 40
	ammo_type = MECHA_AMMO_BUCKSHOT

/obj/item/mecha_ammo/lmg
	name = "机枪弹药箱"
	desc = "一箱相连的弹药，专为AC 2机甲武器设计。"
	icon_state = "lmg"
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*2)
	rounds = 300
	ammo_type = MECHA_AMMO_LMG

/// Missile Ammo
/// SRM-8 Missile type - Used by Nuclear Operatives
/obj/item/mecha_ammo/missiles_srm
	name = "短程导弹"
	desc = "一箱大型导弹，已准备好装载到SRM-8外装导弹架上。"
	icon_state = "missile_he"
	rounds = 8
	direct_load = TRUE
	load_audio = 'sound/items/weapons/gun/general/mag_bullet_insert.ogg'
	ammo_type = MECHA_AMMO_MISSILE_SRM

/// PEP-6 Missile type - Used by Robotics
/obj/item/mecha_ammo/missiles_pep
	name = "精确爆破导弹"
	desc = "一箱大型导弹，准备装入PEP-6动力装甲导弹架。"
	icon_state = "missile_br"
	custom_materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*4,/datum/material/gold=SMALL_MATERIAL_AMOUNT*5)
	rounds = 6
	direct_load = TRUE
	load_audio = 'sound/items/weapons/gun/general/mag_bullet_insert.ogg'
	ammo_type = MECHA_AMMO_MISSILE_PEP

/obj/item/mecha_ammo/flashbang
	name = "可发射式闪光弹"
	desc = "一盒光滑的闪光弹，用于大型机甲发射装置。不能手动启动。"
	icon_state = "flashbang"
	custom_materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*2,/datum/material/gold=SMALL_MATERIAL_AMOUNT*5)
	rounds = 6
	ammo_type = MECHA_AMMO_FLASHBANG

/obj/item/mecha_ammo/clusterbang
	name = "可发射闪光弹组"
	desc = "一盒集束闪光弹，用于专门的机甲集束发射装置。不能手动启动。"
	icon_state = "clusterbang"
	custom_materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*3,/datum/material/gold=HALF_SHEET_MATERIAL_AMOUNT * 1.5,/datum/material/uranium=HALF_SHEET_MATERIAL_AMOUNT * 1.5)
	rounds = 3
	direct_load = TRUE
	ammo_type = MECHA_AMMO_CLUSTERBANG
