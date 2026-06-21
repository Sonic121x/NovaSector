/obj/item/stack/light_w
	name = "有线玻璃砖"
	singular_name = "wired glass floor tile"
	desc = "一块玻璃砖，不知怎么的，上面有电线。"
	icon = 'icons/obj/tiles.dmi'
	icon_state = "glass_wire"
	w_class = WEIGHT_CLASS_NORMAL
	force = 3
	throwforce = 5
	throw_speed = 3
	throw_range = 7
	obj_flags = CONDUCTS_ELECTRICITY
	max_amount = 60
	mats_per_unit = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 1.05, /datum/material/glass = SHEET_MATERIAL_AMOUNT * 1.05)
	merge_type = /obj/item/stack/light_w

/obj/item/stack/light_w/grind_results()
	return list(/datum/reagent/silicon = 20, /datum/reagent/copper = 5)

/obj/item/stack/light_w/examine(mob/user)
	. = ..()
	. += span_warning("\The [src]看起来未完成，添加<b>铁</b>来完成它。")

/obj/item/stack/light_w/attackby(obj/item/O, mob/user, list/modifiers, list/attack_modifiers)
	if(istype(O, /obj/item/stack/sheet/iron))
		var/obj/item/stack/sheet/iron/M = O
		if (M.use(1))
			var/obj/item/L = new /obj/item/stack/tile/light(user.drop_location())
			to_chat(user, span_notice("你制作了一块照明砖。"))
			if (!QDELETED(L))
				L.add_fingerprint(user)
			use(1)
		else
			to_chat(user, span_warning("你需要一块铁片来完成照明砖！"))
	else
		return ..()

/obj/item/stack/light_w/wirecutter_act(mob/living/user, obj/item/I)
	. = ..()
	var/atom/Tsec = user.drop_location()
	var/obj/item/stack/cable_coil/CC = new (Tsec, 5)
	if (!QDELETED(CC))
		CC.add_fingerprint(user)
	var/obj/item/stack/sheet/glass/G = new (Tsec)
	if (!QDELETED(G))
		G.add_fingerprint(user)
	use(1)
