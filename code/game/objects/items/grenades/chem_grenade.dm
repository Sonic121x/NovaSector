/obj/item/grenade/chem_grenade
	name = "化学手榴弹"
	desc = "一枚定制的手榴弹。"
	icon_state = "chemg"
	base_icon_state = "chemg"
	inhand_icon_state = "flashbang"
	w_class = WEIGHT_CLASS_SMALL
	force = 2
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT)
	/// Which stage of construction this grenade is currently at.
	var/stage = GRENADE_EMPTY
	/// The set of reagent containers that have been added to this grenade casing.
	var/list/obj/item/beakers = list()
	/// The types of reagent containers that can be added to this grenade casing.
	var/list/allowed_containers = list(/obj/item/reagent_containers/cup/beaker, /obj/item/reagent_containers/cup/bottle)
	/// The types of reagent containers that can't be added to this grenade casing.
	var/list/banned_containers = list(/obj/item/reagent_containers/cup/beaker/bluespace) //Containers to exclude from specific grenade subtypes
	/// The maximum volume of the reagents in the grenade casing.
	var/casing_holder_volume = 1000
	/// The range that this grenade can splash reagents at if they aren't consumed on detonation.
	var/affected_area = 3
	/// The amount of temperature that is added to the reagents on detonation.
	var/ignition_temp = 10
	/// How much to scale the reagents by when the grenade detonates. Used by advanced grenades to make them slightly more worthy.
	var/threatscale = 1
	/// The description when examining empty casings.
	var/casedesc = "This basic model accepts both beakers and bottles. It heats contents by 10 K upon ignition."
	/// Whether or not the grenade is currently acting as a landmine.
	var/obj/item/assembly/prox_sensor/landminemode = null

/obj/item/grenade/chem_grenade/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/empprotection, EMP_PROTECT_WIRES)
	create_reagents(casing_holder_volume)
	set_wires(new /datum/wires/explosive/chem_grenade(src))
	update_appearance()

/obj/item/grenade/chem_grenade/Destroy(force)
	QDEL_NULL(landminemode)
	QDEL_LIST(beakers)
	return ..()

/obj/item/grenade/chem_grenade/apply_grenade_fantasy_bonuses(quality)
	threatscale = modify_fantasy_variable("threatscale", threatscale, quality/10)

/obj/item/grenade/chem_grenade/remove_grenade_fantasy_bonuses(quality)
	threatscale = reset_fantasy_variable("threatscale", threatscale)

/obj/item/grenade/chem_grenade/examine(mob/user)
	display_timer = (stage == GRENADE_READY) //show/hide the timer based on assembly state
	. = ..()
	if (!user.can_see_reagents())
		if (stage == GRENADE_READY || !(length(beakers)))
			return
		if (length(beakers) == 2 && beakers[1].name == beakers[2].name)
			. += span_notice("你看到手榴弹内有两个[beakers[1].name]。")
			return

		for (var/obj/item/beaker as anything in beakers)
			. += span_notice("你看到手榴弹内有一个[beaker.name]。")

	if (!length(beakers))
		. += span_notice("你扫描了手榴弹，但未检测到任何东西。")
		return

	. += span_notice("你扫描了手榴弹并检测到以下试剂：")

	for (var/obj/item/beaker as anything in beakers)
		for (var/datum/reagent/reagent in beaker.reagents.reagent_list)
			. += span_notice("[reagent.volume] 单位的 [reagent.name] 在 \the [beaker] 中。")

	if (length(beakers) == 1)
		. += span_notice("你检测到手榴弹中没有第二个烧杯。")

/obj/item/grenade/chem_grenade/update_name(updates)
	switch (stage)
		if (GRENADE_EMPTY)
			name = "[initial(name)]外壳"
		if (GRENADE_WIRED)
			name = "未固定的[initial(name)]"
		if (GRENADE_READY)
			name = initial(name)
	return ..()

/obj/item/grenade/chem_grenade/update_desc(updates)
	switch (stage)
		if (GRENADE_EMPTY)
			desc = "一个自制的[initial(name)]！[initial(casedesc)]"
		if (GRENADE_WIRED)
			desc = "一个未固定的[initial(name)]组件。"
		if (GRENADE_READY)
			desc = initial(desc)
	return ..()


/obj/item/grenade/chem_grenade/update_icon_state()
	if (active)
		icon_state = "[base_icon_state]_active"
		return ..()

	switch (stage)
		if (GRENADE_EMPTY)
			icon_state = base_icon_state
		if (GRENADE_WIRED)
			icon_state = "[base_icon_state]_ass"
		if (GRENADE_READY)
			icon_state = "[base_icon_state]_locked"
	return ..()


/obj/item/grenade/chem_grenade/attack_self(mob/user)
	if (stage == GRENADE_READY && !active)
		return ..()

	if (stage == GRENADE_WIRED)
		wires.interact(user)

/obj/item/grenade/chem_grenade/screwdriver_act(mob/living/user, obj/item/tool)
	if (dud_flags & GRENADE_USED)
		balloon_alert(user, "重置触发器中...")
		if (!do_after(user, 2 SECONDS, src))
			return ITEM_INTERACT_BLOCKING

		balloon_alert(user, "触发器已重置")
		dud_flags &= ~GRENADE_USED
		return ITEM_INTERACT_SUCCESS

	if (stage == GRENADE_WIRED)
		if (length(beakers))
			stage_change(GRENADE_READY)
			to_chat(user, span_notice("你锁定了[initial(name)]组件。"))
			tool.play_tool_sound(src, 25)
			return ITEM_INTERACT_SUCCESS

		if (!landminemode || !(landminemode.scanning || landminemode.timing))
			to_chat(user, span_warning("在锁定[initial(name)]组件前，你至少需要添加一个烧杯！"))
			return ITEM_INTERACT_BLOCKING

		landminemode.timing = FALSE
		landminemode.toggle_scan(FALSE)
		to_chat(user, span_notice("你解除了\the [landminemode]。"))
		tool.play_tool_sound(src, 25)
		return ITEM_INTERACT_SUCCESS

	if (stage != GRENADE_READY)
		to_chat(user, span_warning("你需要添加一根电线！"))
		return ITEM_INTERACT_BLOCKING

	det_time = det_time == 5 SECONDS ? 3 SECONDS : 5 SECONDS
	if (landminemode)
		landminemode.time = det_time * 0.1 //overwrites the proxy sensor activation timer

	tool.play_tool_sound(src, 25)
	to_chat(user, span_notice("你修改了延时设置。它被设定为[DisplayTimeText(det_time)]。"))
	return TRUE

/obj/item/grenade/chem_grenade/wirecutter_act(mob/living/user, obj/item/tool)
	if (stage != GRENADE_READY || active)
		return NONE

	tool.play_tool_sound(src)
	stage_change(GRENADE_WIRED)
	to_chat(user, span_notice("你解锁了[initial(name)]组件。"))
	return TRUE

/obj/item/grenade/chem_grenade/wrench_act(mob/living/user, obj/item/tool)
	if (stage != GRENADE_WIRED)
		return NONE

	if (!length(beakers))
		tool.play_tool_sound(src)
		wires.detach_assembly(wires.get_wire(1))
		new /obj/item/stack/cable_coil(get_turf(src), 1)
		stage_change(GRENADE_EMPTY)
		to_chat(user, span_notice("你从[initial(name)]组件上移除了激活机构。"))
		return ITEM_INTERACT_SUCCESS

	to_chat(user, span_notice("你打开了[initial(name)]组件并移除了有效载荷。"))
	for(var/obj/item/beaker as anything in beakers)
		beaker.forceMove(drop_location())
		if(!beaker.reagents)
			continue
		var/reagent_list = pretty_string_from_reagent_list(beaker.reagents.reagent_list)
		user.log_message("removed [beaker] ([reagent_list]) from [src]", LOG_GAME)
	return ITEM_INTERACT_SUCCESS

/obj/item/grenade/chem_grenade/item_interaction(mob/living/user, obj/item/item, list/modifiers)
	if (isassembly(item) && stage == GRENADE_WIRED)
		wires.interact(user)
		return ITEM_INTERACT_SUCCESS

	if (stage == GRENADE_EMPTY && istype(item, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/coil = item
		if (!coil.use(1))
			to_chat(user, span_warning("你需要一卷线圈来给组件接线！"))
			return ITEM_INTERACT_BLOCKING

		det_time = 5 SECONDS // In case the cable_coil was removed and readded.
		stage_change(GRENADE_WIRED)
		to_chat(user, span_notice("你给[initial(name)]组件接好了线。"))
		return ITEM_INTERACT_SUCCESS

	if (stage != GRENADE_WIRED)
		return NONE

	if (!is_type_in_list(item, allowed_containers))
		return NONE

	if(is_type_in_list(item, banned_containers))
		to_chat(user, span_warning("[src]太小了，装不下[item]！")) // this one hits home huh anon?
		return ITEM_INTERACT_BLOCKING

	if (length(beakers) == 2)
		to_chat(user, span_warning("[src]无法容纳更多容器！"))
		return ITEM_INTERACT_BLOCKING

	if(!user.transferItemToLoc(item, src))
		return ITEM_INTERACT_BLOCKING

	to_chat(user, span_notice("你将[item]添加到[initial(name)]组件中。"))
	beakers += item
	var/reagent_list = pretty_string_from_reagent_list(item.reagents.reagent_list)
	user.log_message("inserted [item] ([reagent_list]) into [src]", LOG_GAME)
	return ITEM_INTERACT_SUCCESS

/obj/item/grenade/chem_grenade/Exited(atom/movable/gone, direction)
	. = ..()
	beakers -= gone

/obj/item/grenade/chem_grenade/proc/stage_change(new_stage)
	stage = new_stage
	update_appearance()

/obj/item/grenade/chem_grenade/on_found(mob/finder)
	var/obj/item/assembly/assembly = wires.get_attached(wires.get_wire(1))
	assembly?.on_found(finder)

/obj/item/grenade/chem_grenade/log_grenade(mob/user)
	var/reagent_string = ""
	var/beaker_number = 1
	for(var/obj/item/exploded_beaker as anything in beakers)
		if (exploded_beaker.reagents)
			reagent_string += " ([exploded_beaker.name] [beaker_number++] : " + pretty_string_from_reagent_list(exploded_beaker.reagents.reagent_list) + ");"

	if(landminemode)
		log_bomber(user, "activated a proxy", src, "containing:[reagent_string]", message_admins = !dud_flags)
	else
		log_bomber(user, "primed a", src, "containing:[reagent_string]", message_admins = !dud_flags)

/obj/item/grenade/chem_grenade/arm_grenade(mob/user, delayoverride, msg = TRUE, volume = 60)
	log_grenade(user) //Inbuilt admin procs already handle null users
	if (user)
		add_fingerprint(user)
		if (msg)
			if (landminemode)
				to_chat(user, span_warning("你启动了[src]，激活了它的接近传感器。"))
			else
				to_chat(user, span_warning("你启动了[src]！[DisplayTimeText(det_time)]！"))

	active = TRUE
	update_icon_state()
	playsound(src, grenade_arm_sound, volume, grenade_sound_vary)
	if (landminemode)
		landminemode.toggle_scan(FALSE) // Ensures that if it was turned on before for some reason, it doesn't get turned off
		landminemode.activate()
	else
		addtimer(CALLBACK(src, PROC_REF(detonate)), isnull(delayoverride)? det_time : delayoverride)

/obj/item/grenade/chem_grenade/detonate(mob/living/lanced_by)
	if(stage != GRENADE_READY)
		return

	. = ..()
	if(!.)
		return

	var/list/datum/reagents/reactants = list()
	for(var/obj/item/beaker as anything in beakers)
		reactants += beaker.reagents

	var/turf/detonation_turf = get_turf(src)
	if (chem_splash(detonation_turf, reagents, affected_area, reactants, ignition_temp, threatscale))
		// logs from custom assemblies priming are handled by the wire component
		log_game("A grenade detonated at [AREACOORD(detonation_turf)]")

	active = FALSE
	update_appearance()

//Large chem grenades accept slime cores and use the appropriately.
/obj/item/grenade/chem_grenade/large
	name = "大型手榴弹"
	desc = "一种定制的大型手榴弹。相比基础手榴弹具有更大的溅射范围和更高的引燃温度。可容纳异域和蓝空容器。"
	casedesc = "This casing affects a larger area than the basic model and can fit exotic containers, including slime cores and bluespace beakers. Heats contents by 25 K upon ignition."
	icon_state = "large_grenade"
	base_icon_state = "large_grenade"
	allowed_containers = list(/obj/item/reagent_containers/cup, /obj/item/reagent_containers/condiment, /obj/item/reagent_containers/cup/glass, /obj/item/slime_extract)
	banned_containers = list()
	affected_area = 5
	ignition_temp = 25 // Large grenades are slightly more effective at setting off heat-sensitive mixtures than smaller grenades.
	threatscale = 1.1 // 10% more effective.

/obj/item/grenade/chem_grenade/large/detonate(mob/living/lanced_by)
	if(stage != GRENADE_READY || dud_flags)
		active = FALSE
		update_appearance()
		return FALSE

	var/extract_total_volume = 0
	var/extract_maximum_volume = 0
	var/list/extracts = list()

	var/beaker_total_volume = 0
	var/list/other_containers = list()

	for(var/obj/item/thing as anything in beakers)
		if(!thing.reagents)
			continue

		if(!istype(thing, /obj/item/slime_extract))
			beaker_total_volume += thing.reagents.total_volume
			other_containers += thing
			continue

		var/obj/item/slime_extract/extract = thing
		if(!extract.extract_uses)
			continue

		extract_total_volume += extract.reagents.total_volume
		extract_maximum_volume += extract.reagents.maximum_volume
		extracts += extract

	var/available_extract_volume = extract_maximum_volume - extract_total_volume
	if(beaker_total_volume <= 0 || available_extract_volume <= 0)
		return ..()

	var/container_ratio = available_extract_volume / beaker_total_volume
	var/datum/reagents/tmp_holder = new/datum/reagents(beaker_total_volume)
	for(var/obj/item/container as anything in other_containers)
		container.reagents.trans_to(tmp_holder, container.reagents.total_volume * container_ratio, no_react = TRUE)

	for(var/obj/item/slime_extract/extract as anything in extracts)
		var/available_volume = extract.reagents.maximum_volume - extract.reagents.total_volume
		tmp_holder.trans_to(extract, beaker_total_volume * (available_volume / available_extract_volume), no_react = TRUE)

		extract.reagents.handle_reactions() // Reaction handling in the transfer proc is reciprocal and we don't want to blow up the tmp holder early.
		if(QDELETED(extract))
			beakers -= extract
			extracts -= extract

	return ..()

/obj/item/grenade/chem_grenade/cryo // Intended for rare cryogenic mixes. Cools the area moderately upon detonation.
	name = "低温手榴弹"
	desc = "一种定制的低温手榴弹。引爆时能迅速冷却内部物质。"
	casedesc = "Upon ignition, it rapidly cools contents by 100 K. Smaller splash range than regular casings."
	icon_state = "cryog"
	base_icon_state = "cryog"
	affected_area = 2
	ignition_temp = -100

/obj/item/grenade/chem_grenade/pyro // Intended for pyrotechnical mixes. Produces a small fire upon detonation, igniting potentially flammable mixtures.
	name = "高温手榴弹"
	desc = "一种定制的高温手榴弹。引爆时能加热内部物质。"
	casedesc = "Upon ignition, it rapidly heats contents by 500 K."
	icon_state = "pyrog"
	base_icon_state = "pyrog"
	ignition_temp = 500 // This is enough to expose a hotspot.

/obj/item/grenade/chem_grenade/adv_release // Intended for weaker, but longer lasting effects. Could have some interesting uses.
	name = "高级释放手榴弹"
	desc = "一种定制的高级释放手榴弹。可多次引爆。可使用多功能工具进行配置。"
	casedesc = "This casing is able to detonate more than once. Can be configured using a multitool."
	icon_state = "timeg"
	base_icon_state = "timeg"
	var/unit_spread = 10 // Amount of units per repeat. Can be altered with a multitool.

/obj/item/grenade/chem_grenade/adv_release/multitool_act(mob/living/user, obj/item/tool)
	if (active)
		return ITEM_INTERACT_BLOCKING

	var/newspread = tgui_input_number(user, "请输入新的扩散范围", "手榴弹扩散", 5, 100, 5)
	if(!newspread || QDELETED(user) || QDELETED(src) || !usr.can_perform_action(src, FORBID_TELEKINESIS_REACH))
		return ITEM_INTERACT_BLOCKING

	unit_spread = newspread
	to_chat(user, span_notice("你将定时释放设置为每次引爆[unit_spread]单位。"))
	return ..()

/obj/item/grenade/chem_grenade/adv_release/detonate(mob/living/lanced_by)
	if(stage != GRENADE_READY || dud_flags)
		active = FALSE
		update_appearance()
		return

	var/total_volume = 0
	for(var/obj/item/reagent_containers/reagent_container in beakers)
		total_volume += reagent_container.reagents.total_volume

	if(!total_volume)
		active = FALSE
		update_appearance()
		return

	var/fraction = unit_spread/total_volume
	var/datum/reagents/reactants = new(unit_spread)
	reactants.my_atom = src
	for(var/obj/item/reagent_containers/reagent_container in beakers)
		reagent_container.reagents.trans_to(
			reactants,
			reagent_container.reagents.total_volume * fraction,
			threatscale,
			no_react = TRUE
		)

	var/turf/detonated_turf = get_turf(src)
	chem_splash(detonated_turf, reagents, affected_area, list(reactants), ignition_temp, threatscale)
	addtimer(CALLBACK(src, PROC_REF(detonate)), det_time)
	log_game("A grenade detonated at [AREACOORD(detonated_turf)]")

// Premade grenades

/obj/item/grenade/chem_grenade/metalfoam
	name = "金属泡沫手榴弹"
	desc = "用于紧急封堵船体裂缝。"
	stage = GRENADE_READY

/obj/item/grenade/chem_grenade/metalfoam/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/cup/beaker/beaker_one = new(src)
	var/obj/item/reagent_containers/cup/beaker/beaker_two = new(src)

	beaker_one.reagents.add_reagent(/datum/reagent/aluminium, 30)
	beaker_two.reagents.add_reagent(/datum/reagent/foaming_agent, 10)
	beaker_two.reagents.add_reagent(/datum/reagent/toxin/acid/fluacid, 10)

	beakers += beaker_one
	beakers += beaker_two


/obj/item/grenade/chem_grenade/smart_metal_foam
	name = "智能金属泡沫手榴弹"
	desc = "用于紧急封堵船体裂缝，同时保持区域可通行。"
	stage = GRENADE_READY

/obj/item/grenade/chem_grenade/smart_metal_foam/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/cup/beaker/large/beaker_one = new(src)
	var/obj/item/reagent_containers/cup/beaker/beaker_two = new(src)

	beaker_one.reagents.add_reagent(/datum/reagent/aluminium, 75)
	beaker_two.reagents.add_reagent(/datum/reagent/smart_foaming_agent, 25)
	beaker_two.reagents.add_reagent(/datum/reagent/toxin/acid/fluacid, 25)

	beakers += beaker_one
	beakers += beaker_two


/obj/item/grenade/chem_grenade/incendiary
	name = "燃烧手榴弹"
	desc = "用于清除房间内的生物。"
	stage = GRENADE_READY

/obj/item/grenade/chem_grenade/incendiary/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/cup/beaker/beaker_one = new(src)
	var/obj/item/reagent_containers/cup/beaker/beaker_two = new(src)

	beaker_one.reagents.add_reagent(/datum/reagent/phosphorus, 25)
	beaker_two.reagents.add_reagent(/datum/reagent/stable_plasma, 25)
	beaker_two.reagents.add_reagent(/datum/reagent/toxin/acid, 25)

	beakers += beaker_one
	beakers += beaker_two


/obj/item/grenade/chem_grenade/antiweed
	name = "除草手榴弹"
	desc = "用于清除大面积入侵植物物种。内容物处于压力下。请勿直接吸入内容物。"
	stage = GRENADE_READY

/obj/item/grenade/chem_grenade/antiweed/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/cup/beaker/beaker_one = new(src)
	var/obj/item/reagent_containers/cup/beaker/beaker_two = new(src)

	beaker_one.reagents.add_reagent(/datum/reagent/toxin/plantbgone, 25)
	beaker_one.reagents.add_reagent(/datum/reagent/potassium, 25)
	beaker_two.reagents.add_reagent(/datum/reagent/phosphorus, 25)
	beaker_two.reagents.add_reagent(/datum/reagent/consumable/sugar, 25)

	beakers += beaker_one
	beakers += beaker_two


/obj/item/grenade/chem_grenade/cleaner
	name = "清洁剂手榴弹"
	desc = "BLAM!牌泡沫太空清洁剂。采用特殊施放器，用于快速清洁大面积区域。"
	stage = GRENADE_READY

/obj/item/grenade/chem_grenade/cleaner/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/cup/beaker/beaker_one = new(src)
	var/obj/item/reagent_containers/cup/beaker/beaker_two = new(src)

	beaker_one.reagents.add_reagent(/datum/reagent/fluorosurfactant, 40)
	beaker_two.reagents.add_reagent(/datum/reagent/water, 40)
	beaker_two.reagents.add_reagent(/datum/reagent/space_cleaner, 10)

	beakers += beaker_one
	beakers += beaker_two


/obj/item/grenade/chem_grenade/ez_clean
	name = "清洁剂手榴弹"
	desc = "Waffle Corp.牌泡沫太空清洁剂。采用特殊施放器，用于快速清洁大面积区域。"
	stage = GRENADE_READY

/obj/item/grenade/chem_grenade/ez_clean/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/cup/beaker/large/beaker_one = new(src)
	var/obj/item/reagent_containers/cup/beaker/large/beaker_two = new(src)

	beaker_one.reagents.add_reagent(/datum/reagent/fluorosurfactant, 40)
	beaker_two.reagents.add_reagent(/datum/reagent/water, 40)
	beaker_two.reagents.add_reagent(/datum/reagent/space_cleaner/ez_clean, 60) //ensures a  t h i c c  distribution

	beakers += beaker_one
	beakers += beaker_two



/obj/item/grenade/chem_grenade/teargas
	name = "催泪瓦斯手榴弹"
	desc = "用于非致命性防暴控制。内容物处于压力下。请勿直接吸入内容物。"
	stage = GRENADE_READY

/obj/item/grenade/chem_grenade/teargas/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/cup/beaker/large/beaker_one = new(src)
	var/obj/item/reagent_containers/cup/beaker/large/beaker_two = new(src)

	beaker_one.reagents.add_reagent(/datum/reagent/consumable/condensedcapsaicin, 60)
	beaker_one.reagents.add_reagent(/datum/reagent/potassium, 40)
	beaker_two.reagents.add_reagent(/datum/reagent/phosphorus, 40)
	beaker_two.reagents.add_reagent(/datum/reagent/consumable/sugar, 40)

	beakers += beaker_one
	beakers += beaker_two

/obj/item/grenade/chem_grenade/teargas/instant/Initialize(mapload)
	. = ..()
	if(detonate())
		return INITIALIZE_HINT_QDEL

/obj/item/grenade/chem_grenade/facid
	name = "酸液手榴弹"
	desc = "用于融化装甲敌人。"
	stage = GRENADE_READY

/obj/item/grenade/chem_grenade/facid/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/cup/beaker/bluespace/beaker_one = new(src)
	var/obj/item/reagent_containers/cup/beaker/bluespace/beaker_two = new(src)

	beaker_one.reagents.add_reagent(/datum/reagent/toxin/acid/fluacid, 290)
	beaker_one.reagents.add_reagent(/datum/reagent/potassium, 10)
	beaker_two.reagents.add_reagent(/datum/reagent/phosphorus, 10)
	beaker_two.reagents.add_reagent(/datum/reagent/consumable/sugar, 10)
	beaker_two.reagents.add_reagent(/datum/reagent/toxin/acid/fluacid, 280)

	beakers += beaker_one
	beakers += beaker_two


/obj/item/grenade/chem_grenade/colorful
	name = "彩色手榴弹"
	desc = "用于大规模涂装项目。"
	stage = GRENADE_READY

/obj/item/grenade/chem_grenade/colorful/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/cup/beaker/beaker_one = new(src)
	var/obj/item/reagent_containers/cup/beaker/beaker_two = new(src)

	beaker_one.reagents.add_reagent(/datum/reagent/colorful_reagent, 25)
	beaker_one.reagents.add_reagent(/datum/reagent/potassium, 25)
	beaker_two.reagents.add_reagent(/datum/reagent/phosphorus, 25)
	beaker_two.reagents.add_reagent(/datum/reagent/consumable/sugar, 25)

	beakers += beaker_one
	beakers += beaker_two

/obj/item/grenade/chem_grenade/glitter
	name = "白色亮片手榴弹"
	desc = "为了那昏昏欲睡的闪亮外观。"
	stage = GRENADE_READY
	var/glitter_colors = list(COLOR_WHITE = 100)

/obj/item/grenade/chem_grenade/glitter/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/cup/beaker/beaker_one = new(src)
	var/obj/item/reagent_containers/cup/beaker/beaker_two = new(src)

	beaker_one.reagents.add_reagent(/datum/reagent/glitter, 25, data = list("colors" = glitter_colors))
	beaker_one.reagents.add_reagent(/datum/reagent/potassium, 25)
	beaker_two.reagents.add_reagent(/datum/reagent/phosphorus, 25)
	beaker_two.reagents.add_reagent(/datum/reagent/consumable/sugar, 25)

	beakers += beaker_one
	beakers += beaker_two

/obj/item/grenade/chem_grenade/glitter/pink
	name = "粉色亮片炸弹"
	desc = "为了那火热的闪亮外观。"
	glitter_colors = list("#ff8080" = 100)

/obj/item/grenade/chem_grenade/glitter/blue
	name = "蓝色亮片炸弹"
	desc = "为了那冷酷的闪亮外观。"
	glitter_colors = list("#4040ff" = 100)

/obj/item/grenade/chem_grenade/clf3
	name = "三氟化氯手榴弹"
	desc = "BURN!牌泡沫三氟化氯。采用特殊施放器，用于快速净化大面积区域。"
	stage = GRENADE_READY

/obj/item/grenade/chem_grenade/clf3/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/cup/beaker/bluespace/beaker_one = new(src)
	var/obj/item/reagent_containers/cup/beaker/bluespace/beaker_two = new(src)

	beaker_one.reagents.add_reagent(/datum/reagent/fluorosurfactant, 250)
	beaker_one.reagents.add_reagent(/datum/reagent/clf3, 50)
	beaker_two.reagents.add_reagent(/datum/reagent/water, 250)
	beaker_two.reagents.add_reagent(/datum/reagent/clf3, 50)

	beakers += beaker_one
	beakers += beaker_two

/obj/item/grenade/chem_grenade/bioterrorfoam
	name = "生物恐怖泡沫手榴弹"
	desc = "虎斑合作社化学泡沫手榴弹。对碳基生命形式造成暂时性刺激、失明、混乱、失语和突变。含有额外的孢子毒素。"
	stage = GRENADE_READY

/obj/item/grenade/chem_grenade/bioterrorfoam/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/cup/beaker/bluespace/beaker_one = new(src)
	var/obj/item/reagent_containers/cup/beaker/bluespace/beaker_two = new(src)

	beaker_one.reagents.add_reagent(/datum/reagent/cryptobiolin, 75)
	beaker_one.reagents.add_reagent(/datum/reagent/water, 50)
	beaker_one.reagents.add_reagent(/datum/reagent/toxin/mutetoxin, 50)
	beaker_one.reagents.add_reagent(/datum/reagent/toxin/spore, 75)
	beaker_one.reagents.add_reagent(/datum/reagent/toxin/itching_powder, 50)
	beaker_two.reagents.add_reagent(/datum/reagent/fluorosurfactant, 150)
	beaker_two.reagents.add_reagent(/datum/reagent/toxin/mutagen, 150)
	beakers += beaker_one
	beakers += beaker_two

/obj/item/grenade/chem_grenade/tuberculosis
	name = "真菌性结核手榴弹"
	desc = "警告：此手榴弹将释放含有活性病原体的致命孢子。使用前请确保防护服密封并关闭通风系统。"
	stage = GRENADE_READY

/obj/item/grenade/chem_grenade/tuberculosis/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/cup/beaker/bluespace/beaker_one = new(src)
	var/obj/item/reagent_containers/cup/beaker/bluespace/beaker_two = new(src)

	beaker_one.reagents.add_reagent(/datum/reagent/potassium, 50)
	beaker_one.reagents.add_reagent(/datum/reagent/phosphorus, 50)
	beaker_one.reagents.add_reagent(/datum/reagent/fungalspores, 200)
	beaker_two.reagents.add_reagent(/datum/reagent/blood, 250)
	beaker_two.reagents.add_reagent(/datum/reagent/consumable/sugar, 50)

	beakers += beaker_one
	beakers += beaker_two

/obj/item/grenade/chem_grenade/holy
	name = "神圣手榴弹"
	desc = "一个浓缩了宗教威能的容器。"
	icon_state = "holy_grenade"
	base_icon_state = "holy_grenade"
	stage = GRENADE_READY

/obj/item/grenade/chem_grenade/holy/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/cup/beaker/meta/beaker_one = new(src)
	var/obj/item/reagent_containers/cup/beaker/meta/beaker_two = new(src)

	beaker_one.reagents.add_reagent(/datum/reagent/potassium, 150)
	beaker_two.reagents.add_reagent(/datum/reagent/water/holywater, 150)

	beakers += beaker_one
	beakers += beaker_two
