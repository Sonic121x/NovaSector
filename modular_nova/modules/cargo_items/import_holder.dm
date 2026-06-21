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
	name = "货运警报：补给箱已销毁"
	// Empty line will be dropped, so by default we will not report properly destroyed goody cases.
	announcement_lines_map = list(
		"Delivered" = "",
		"Locked" = "%OWNER的已锁定补给箱已在%LOCATION被摧毁。")
	vars_and_tooltips_map = list(
		"LOCATION" = "将被替换为补给箱的位置。",
		"OWNER" = "替换为箱子所有者的名字。"
	)

/obj/item/goodycase_holder
	name = "补给箱支架"
	desc = "或许公司从未预料到补给箱会带来如此大的货运流量。这个支架就是用来存放多个补给箱的解决方案。"
	icon = 'modular_nova/modules/cargo_items/icons/import_holder.dmi'
	icon_state = "goodycase_holder"
	w_class = WEIGHT_CLASS_BULKY

	///the maximum amount of goody cases this item can hold
	var/max_goodycases = 8

	///the list of goody cases that are currently in the item
	var/list/goodycase_list = list()

/obj/item/goodycase_holder/examine(mob/user)
	. = ..()
	. += span_notice("<br>当前存放了[length(goodycase_list)]/[max_goodycases]个箱子。")
	. += span_notice("要访问内部物品，请按动此物品。")

/obj/item/goodycase_holder/update_appearance(updates)
	. = ..()
	cut_overlays()
	var/goody_count = length(goodycase_list) > max_goodycases ? 8 : length(goodycase_list)
	for(var/added_overlays in 1 to goody_count)
		add_overlay("[added_overlays]")

/obj/item/goodycase_holder/attack_self(mob/user, modifiers)
	if(length(goodycase_list) < 1)
		to_chat(user, span_notice("没有物品可以取出。"))
		return

	var/obj/obj_choice = tgui_input_list(user, "你想移除哪个赠品箱？", "赠品箱收纳器选择", goodycase_list)
	if(isnull(obj_choice))
		return

	obj_choice.forceMove(get_turf(src))
	goodycase_list -= obj_choice
	to_chat(user, span_notice("[obj_choice]已从[src]中取出到[get_turf(src)]。"))
	update_appearance()

/obj/item/goodycase_holder/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/storage/lockbox/order))
		if(length(goodycase_list) >= max_goodycases)
			to_chat(user, span_warning("你无法将更多物品放入[src]！"))
			return ITEM_INTERACT_BLOCKING

		goodycase_list += tool
		tool.forceMove(src)
		update_appearance()
		to_chat(user, span_notice("你将[tool]添加到了[src]。"))
		return ITEM_INTERACT_BLOCKING

	return ..()

/datum/design/goodycase_holder
	name = "补给箱支架"
	desc = "解决货运大厅里堆积如山的补给箱问题的方案。"
	id = "goodycase_holder"
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
