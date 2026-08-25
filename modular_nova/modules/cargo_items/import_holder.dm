//lets broadcast to the common channel if a lockbox is destroyed
/obj/item/storage/lockbox/order/Destroy()
	var/announcement_line = atom_storage.locked == STORAGE_NOT_LOCKED ? "Delivered" : "Locked"
	aas_config_announce(/datum/aas_config_entry/goodycase_destroyed, list(
		"LOCATION" = get_area_name(src),
		"OWNER" = buyer_account?.account_holder,
	), src, list(RADIO_CHANNEL_COMMON), announcement_line)
	log_game("[src] was destroyed in [get_area_name(src)]")
	return ..()

/datum/aas_config_entry/goodycase_destroyed
	name = "Cargo Alert: Goody Case Destroyed"
	// Empty line will be dropped, so by default we will not report properly destroyed goody cases.
	announcement_lines_map = list(
		"Delivered" = "",
		"Locked" = "%OWNER's locked goody case has been destroyed in %LOCATION.")
	vars_and_tooltips_map = list(
		"LOCATION" = "will be replaced with the location of the goody case.",
		"OWNER" = "with case owner name."
	)

/obj/item/goodycase_holder
	name = "goody case holder"
	desc = "Perhaps the companies never expected the cargo traffic that goody cases would cause. This holder is the solution to holding multiple goody cases."
	icon = 'modular_nova/modules/cargo_items/icons/import_holder.dmi'
	icon_state = "goodycase_holder"
	w_class = WEIGHT_CLASS_BULKY
	custom_materials = list(/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT, /datum/material/uranium = HALF_SHEET_MATERIAL_AMOUNT)

	///the maximum amount of goody cases this item can hold
	var/max_goodycases = 8

	///the list of goody cases that are currently in the item
	var/list/goodycase_list = list()

/obj/item/goodycase_holder/examine(mob/user)
	. = ..()
	. += span_notice(LANG("obj.8247b879ed2c4d70", list(length(goodycase_list), max_goodycases)))
	. += span_notice(LANG("obj.e426bafc4e2154f2", null))

/obj/item/goodycase_holder/update_appearance(updates)
	. = ..()
	cut_overlays()
	var/goody_count = length(goodycase_list) > max_goodycases ? 8 : length(goodycase_list)
	for(var/added_overlays in 1 to goody_count)
		add_overlay("[added_overlays]")

/obj/item/goodycase_holder/attack_self(mob/user, modifiers)
	if(length(goodycase_list) < 1)
		to_chat(user, span_notice(LANG("obj.12f289bb059b84d3", null)))
		return

	var/obj/obj_choice = tgui_input_list(user, LANG("obj.8663600ba5dbea2e", null), LANG("obj.937d4b3e57e22bcb", null), goodycase_list)
	if(isnull(obj_choice))
		return

	obj_choice.forceMove(get_turf(src))
	goodycase_list -= obj_choice
	to_chat(user, span_notice(LANG("obj.7207df574db90456", list(obj_choice, src, get_turf(src)))))
	update_appearance()

/obj/item/goodycase_holder/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/storage/lockbox/order))
		if(length(goodycase_list) >= max_goodycases)
			to_chat(user, span_warning(LANG("obj.6a5bebbdce812640", list(src))))
			return ITEM_INTERACT_BLOCKING

		goodycase_list += tool
		tool.forceMove(src)
		update_appearance()
		to_chat(user, span_notice(LANG("obj.0c27fe262b2ac3b6", list(tool, src))))
		return ITEM_INTERACT_BLOCKING

	return ..()

/datum/design/goodycase_holder
	name = "Goody Case Holder"
	desc = "The solution to the plethora of goody cases that litter the cargonian halls."
	build_type = PROTOLATHE | AWAY_LATHE
	build_path = /obj/item/goodycase_holder
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/uranium = HALF_SHEET_MATERIAL_AMOUNT,
	)
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_CARGO,
	)
	departmental_flags = DEPARTMENT_BITFLAG_CARGO
