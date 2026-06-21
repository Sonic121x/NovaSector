/datum/design/borg_snack_dispenser
	name = "零食分发器模块"
	id = "borg_upgrade_snacks"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/snack_dispenser
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT * 7,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
	)
	construction_time = 1 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_ALL,
	)

/obj/item/borg/upgrade/snack_dispenser
	name = "零食分发器模块"
	desc = "赋予任何机器人分发特色零食的能力。"
	/// For storing modules that we remove, since the upgraded snack dispensor automatically removes inferior versions
	var/list/removed_modules = list()

/obj/item/borg/upgrade/snack_dispenser/action(mob/living/silicon/robot/R, user)
	. = ..()
	if(!.)
		return
	var/obj/item/borg_snack_dispenser/snack_dispenser = new(R.model)
	R.model.basic_modules += snack_dispenser
	R.model.add_module(snack_dispenser, FALSE, TRUE)
	for(var/obj/item/rsf/cookiesynth/cookiesynth in R.model)
		removed_modules += cookiesynth
		R.model.remove_module(cookiesynth)
	for(var/obj/item/borg/lollipop/lollipop in R.model)
		removed_modules += lollipop
		R.model.remove_module(lollipop)

/obj/item/borg/upgrade/snack_dispenser/deactivate(mob/living/silicon/robot/R, user)
	. = ..()
	if(!.)
		return
	for(var/obj/item/borg_snack_dispenser/dispenser in R.model)
		R.model.remove_module(dispenser, TRUE)
	for(var/obj/item as anything in removed_modules)
		R.model.basic_modules += item
		R.model.add_module(item, FALSE, TRUE)

/obj/item/borg_snack_dispenser
	name = "\improper 自动博格零食分发器"
	desc = "能够自动打印多种不同形式的零食。现已获得蜥蜴人认证！"
	icon = 'icons/obj/tools.dmi'
	icon_state = "rsf"
	/// Contains the PATH of the selected snack
	var/atom/selected_snack
	/// Whether snacks are launched when targeted at a distance
	var/launch_mode = FALSE
	/// A list of all valid snacks
	var/list/valid_snacks = list(
		/obj/item/food/cookie/bacon,
		/obj/item/food/cookie/cloth,
		/obj/item/food/cookie/sugar,
		/obj/item/food/lollipop/cyborg
	)
	/// Minimum amount of charge a borg can have before snack printing is disallowed
	var/borg_charge_cutoff = 200
	/// The amount of charge used per print of a snack
	var/borg_charge_usage = STANDARD_CELL_CHARGE * 0.05

/obj/item/borg_snack_dispenser/Initialize(mapload)
	. = ..()
	selected_snack = selected_snack ||  LAZYACCESS(valid_snacks, 1)

/obj/item/borg_snack_dispenser/examine(mob/user)
	. = ..()
	. += "It is currently set to dispense [initial(selected_snack.name)]."
	. += "You can AltClick it to [(launch_mode ? "disable" : "enable")] launch mode."

/obj/item/borg_snack_dispenser/attack_self(mob/user, modifiers)
	var/list/choices = list()
	for(var/atom/snack as anything in valid_snacks)
		choices[initial(snack.name)] = snack
	if(!length(choices))
		to_chat(user, span_warning("数据库中没有有效零食。"))
	if(length(choices) == 1)
		selected_snack = choices[1]
	else
		var/selected = tgui_input_list(user, "选择零食", "零食选择", choices)
		if(!selected)
			return
		selected_snack = choices[selected]
	var/snack_name = initial(selected_snack.name)
	to_chat(user, span_notice("[src] 现在正在分发 [snack_name]。"))

/obj/item/borg_snack_dispenser/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	var/mob/living/patron = interacting_with
	if(!istype(patron))
		return NONE
	var/empty_hand = LAZYACCESS(patron.get_empty_held_indexes(), 1)
	if(!empty_hand)
		to_chat(user, span_warning("[patron] 没有空闲的手！"))
		return ITEM_INTERACT_BLOCKING
	if(!selected_snack)
		to_chat(user, span_warning("未选择零食。"))
		return ITEM_INTERACT_BLOCKING
	var/mob/living/silicon/robot/borg = user
	if(!istype(borg))
		CRASH("[src] being used by non borg [borg]")
	if(borg.cell.charge < borg_charge_cutoff)
		to_chat(borg, span_danger("自动安全措施限制在[src]以下时操作[borg_charge_cutoff]！"))
		return ITEM_INTERACT_BLOCKING
	if(!borg.cell.use(borg_charge_usage))
		to_chat(borg, span_danger("零食打印失败：电源故障！"))
		return ITEM_INTERACT_BLOCKING
	var/atom/snack = new selected_snack(src)
	patron.put_in_hand(snack, empty_hand)
	borg.do_item_attack_animation(patron, null, snack)
	playsound(loc, 'sound/machines/click.ogg', 10, TRUE)
	to_chat(patron, span_notice("[borg] 将[snack]递到你空着的手里，你下意识地握住了它。"))
	to_chat(borg, span_notice("你将[snack]分发到了[patron]的手中。"))
	return ITEM_INTERACT_SUCCESS

/obj/item/borg_snack_dispenser/click_alt(mob/user)
	launch_mode = !launch_mode
	to_chat(user, span_notice("[src] [(launch_mode ? "now" : "no longer")]在远距离发射零食。"))
	return CLICK_ACTION_SUCCESS

/obj/item/borg_snack_dispenser/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!launch_mode)
		return NONE
	if(!selected_snack)
		to_chat(user, span_warning("未选择零食。"))
		return ITEM_INTERACT_BLOCKING
	var/mob/living/silicon/robot/borg = user
	if(!istype(borg))
		CRASH("[src] being used by non borg [borg]")
	if(borg.cell.charge < borg_charge_cutoff)
		to_chat(borg, span_danger("自动安全措施限制在低于[src]时操作[borg_charge_cutoff]！"))
		return ITEM_INTERACT_BLOCKING
	if(!borg.cell.use(borg_charge_usage))
		to_chat(borg, span_danger("零食打印失败：电源故障！"))
		return ITEM_INTERACT_BLOCKING
	var/atom/movable/snack = new selected_snack(get_turf(src))
	snack.throw_at(interacting_with, 7, 2, borg, TRUE, FALSE)
	playsound(loc, 'sound/machines/click.ogg', 10, TRUE)
	borg.visible_message(span_notice("[src]向[interacting_with]发射了[snack]！"))
	return ITEM_INTERACT_SUCCESS

/obj/item/food/cookie/bacon
	name = "培根条"
	desc = "培根！！！"
	icon = 'modular_nova/master_files/icons/obj/food/snacks.dmi'
	icon_state = "bacon_strip"
	tastes = list("hint of hint of bacon" = 1)
	foodtypes = MEAT

/obj/item/food/cookie/cloth
	name = "奇怪的饼干"
	desc = "一块看起来像是用……某种布料做成的饼干？"
	icon = 'modular_nova/master_files/icons/obj/food/snacks.dmi'
	icon_state = "cookie_cloth"
	tastes = list("doughy cloth" = 1)
	foodtypes = CLOTH
