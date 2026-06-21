/obj/item/door_seal
	name = "气动气闸密封器"
	desc = "一种用于密封和加固气闸的支撑装置。对于阻止没有对生拇指的生物进入区域非常有用。"
	icon = 'icons/obj/machines/wallmounts.dmi'
	icon_state = "pneumatic_seal"
	inhand_icon_state = "pneumatic_seal"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	obj_flags = CONDUCTS_ELECTRICITY
	resistance_flags = FIRE_PROOF | ACID_PROOF
	force = 5
	throwforce = 5
	throw_speed = 2
	throw_range = 1
	w_class = WEIGHT_CLASS_NORMAL
	custom_materials = list(/datum/material/iron= SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/plasma= SMALL_MATERIAL_AMOUNT * 5)
	/// how long the seal takes to place on the door
	var/seal_time = 3 SECONDS
	/// how long it takes to remove the seal from a door
	var/unseal_time = 2 SECONDS

/obj/item/door_seal/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] 正在用[user.p_them()]将[src]自己与世界隔绝！看起来[user.p_theyre()]想要自杀！"))
	playsound(src, 'sound/items/tools/jaws_pry.ogg', 30, TRUE)
	return BRUTELOSS

