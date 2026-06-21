/obj/item/ammo_casing/foam_dart
	name = "泡沫飞镖"
	desc = "要么唐克，要么别玩！适合8岁及以上。"
	projectile_type = /obj/projectile/bullet/foam_dart
	caliber = CALIBER_FOAM
	icon = 'icons/obj/weapons/guns/toy.dmi'
	icon_state = "foamdart"
	base_icon_state = "foamdart"
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 0.1125)
	harmful = FALSE
	newtonian_force = 0.5
	embed_type = /datum/embedding/foam_dart
	var/modified = FALSE
	var/static/list/insertable_items_hint = list(/obj/item/pen)
	///For colored magazine overlays.
	var/tip_color = "blue"

/obj/item/ammo_casing/foam_dart/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/caseless, TRUE)

/obj/item/ammo_casing/foam_dart/update_icon_state()
	. = ..()
	if(modified)
		icon_state = "[base_icon_state]_empty"
		loaded_projectile?.icon_state = "[loaded_projectile.base_icon_state]_empty_proj"
		return
	icon_state = "[base_icon_state]"
	loaded_projectile?.icon_state = "[loaded_projectile.base_icon_state]_proj"

/obj/item/ammo_casing/foam_dart/update_desc()
	. = ..()
	desc = "要么唐克，要么别玩！[modified ? "... Although, this one doesn't look too safe." : "Ages 8 and up."]"

/obj/item/ammo_casing/foam_dart/examine_more(mob/user)
	. = ..()
	if(!HAS_TRAIT(src, TRAIT_DART_HAS_INSERT))
		var/list/type_initial_names = list()
		for(var/type in insertable_items_hint)
			var/obj/item/type_item = type
			type_initial_names += "\a [initial(type_item.name)]"
		. += span_notice("[modified ? "You can" : "If you removed the safety cap with a screwdriver, you could"] insert a small item\
			[length(type_initial_names) ? ", such as [english_list(type_initial_names, and_text = "or ", final_comma_text = ", ")]" : ""].")


/obj/item/ammo_casing/foam_dart/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	if (attacking_item.tool_behaviour != TOOL_SCREWDRIVER || modified)
		return ..()

	var/obj/projectile/bullet/foam_dart/dart = loaded_projectile
	modified = TRUE
	dart.modified = TRUE
	dart.damage_type = BRUTE
	dart.set_embed(null) // Cap is what makes them sticky
	to_chat(user, span_notice("你取下了[src]的安全帽。"))
	update_appearance()

/obj/item/ammo_casing/foam_dart/riot
	name = "防暴泡沫弹"
	desc = "是谁想出的聪明主意，用玩具来控制人群？适合18岁及以上人群。"
	projectile_type = /obj/projectile/bullet/foam_dart/riot
	icon_state = "foamdart_riot"
	base_icon_state = "foamdart_riot"
	tip_color = "red"
	embed_type = /datum/embedding/foam_dart/riot
	custom_materials = list(/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT * 1.125)
