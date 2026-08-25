// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/// How many more items does `max_items` get increased by per rating point.
#define MAX_ITEMS_PER_RATING 10
/// How many items are converted per cycle, per rating point of the manipulator used.
#define PROCESSED_ITEMS_PER_RATING 5

/obj/machinery/biogenerator
	name = "biogenerator"
	desc = "Converts plants into biomass, which can be used to construct useful items."
	icon = 'icons/obj/machines/biogenerator.dmi'
	icon_state = "biogenerator"
	density = TRUE
	circuit = /obj/item/circuitboard/machine/biogenerator
	processing_flags = START_PROCESSING_MANUALLY
	interaction_flags_click = FORBID_TELEKINESIS_REACH
	/// Whether the biogenerator is currently processing biomass or not.
	var/processing = FALSE
	/// The reagent container that is currently inside of the biomass generator. Can be null.
	var/obj/item/reagent_containers/cup/beaker = null
	/// The amount of biomass that's currently stored in the biogenerator.
	var/biomass = 0
	/// The amount by which the biomass consumption will be divided.
	var/efficiency = 1
	/// The conversion factor for nutrient to biomass, and the amount of additional items that will be processed at once per cycle.
	var/productivity = 1
	/// The amount of items that will be converted into biomass per processing cycle.
	var/processed_items_per_cycle = 5
	/// The maximum amount of items the biogenerator can hold for biomass conversion purposes.
	var/max_items = 20
	/// Cached amount of items currently in the biogenerator, for use in UI so we don't have to loop over contents every second while its open
	var/content_count_cache = 0
	/// The maximum amount of biomass that will affect the visuals of the biogenerator.
	var/max_visual_biomass = 5000
	/// The maximum amount of reagents that the biogenerator can output to a container at once.
	var/max_output = 50
	/// The research that is stored within this biogenerator.
	var/datum/techweb/stored_research
	/// The different visual categories for the biogenerator, for the tabs.
	var/list/show_categories = list(
		RND_CATEGORY_BIO_FOOD,
		RND_CATEGORY_BIO_CHEMICALS,
		RND_CATEGORY_BIO_MATERIALS,
	)
	/// The category that's currently selected in the UI.
	var/selected_cat
	/// The sound loop that can be heard when the generator is processing.
	var/datum/looping_sound/generator/soundloop
	/// Whether the biogen is welded down to the floor disabling unwrenching
	var/welded_down = FALSE

/obj/machinery/biogenerator/Initialize(mapload)
	. = ..()
	GLOB.autounlock_techwebs[/datum/techweb/autounlocking/biogenerator] ||= new /datum/techweb/autounlocking/biogenerator()
	stored_research = GLOB.autounlock_techwebs[/datum/techweb/autounlocking/biogenerator]
	soundloop = new(src, processing)
	if(mapload)
		welded_down = TRUE

/obj/machinery/biogenerator/can_be_unfasten_wrench(mob/user, silent)
	if(welded_down)
		to_chat(user, span_warning(LANG("obj.9092e2c6bd6db4b5", list(src))))
		return FAILED_UNFASTEN
	return ..()

/obj/machinery/biogenerator/set_anchored(anchorvalue)
	. = ..()
	if(!anchored && welded_down) //make sure they're keep in sync in case it was forcibly unanchored by badmins or by a megafauna.
		welded_down = FALSE

/obj/machinery/biogenerator/welder_act(mob/living/user, obj/item/tool)
	..()
	if(welded_down)
		if(!tool.tool_start_check(user, amount=2))
			return TRUE
		user.visible_message(
			span_notice(LANG("obj.62651aed81728dfd", list(user.name, src))),
			span_notice(LANG("obj.41ed57fe66669269", list(src))),
			span_hear(LANG("obj.1aa82fa3545466eb", null)),
		)
		if(!tool.use_tool(src, user, 10 SECONDS, volume=100))
			return FALSE
		welded_down = FALSE
		to_chat(user, span_notice(LANG("obj.6a908a91e8707af7", list(src))))
		return TRUE
	if(!anchored)
		to_chat(user, span_warning(LANG("obj.acb3909a82cc6dff", list(src))))
		return TRUE
	if(!tool.tool_start_check(user, amount=2))
		return TRUE
	user.visible_message(
		span_notice(LANG("obj.9449da477015e3e3", list(user.name, src))),
		span_notice(LANG("obj.7765e0fab90f0928", list(src))),
		span_hear(LANG("obj.1aa82fa3545466eb", null)),
	)
	if(!tool.use_tool(src, user, 10 SECONDS, volume=100))
		balloon_alert(user, LANG("obj.bcb4be71fd475a4f", null))
		return FALSE
	welded_down = TRUE
	to_chat(user, span_notice(LANG("obj.46f0194bbe668d3b", list(src))))
	return TRUE

/obj/machinery/biogenerator/Destroy()
	QDEL_NULL(beaker)
	QDEL_NULL(soundloop)
	return ..()

/obj/machinery/biogenerator/contents_explosion(severity, target)
	. = ..()
	if(!beaker)
		return

	switch(severity)
		if(EXPLODE_DEVASTATE)
			SSexplosions.high_mov_atom += beaker
		if(EXPLODE_HEAVY)
			SSexplosions.med_mov_atom += beaker
		if(EXPLODE_LIGHT)
			SSexplosions.low_mov_atom += beaker

/obj/machinery/biogenerator/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == beaker)
		beaker = null
		update_appearance()

/obj/machinery/biogenerator/RefreshParts()
	. = ..()

	var/new_efficiency = 0
	var/new_productivity = 0
	var/new_max_items = 10
	var/new_processed_items_per_cycle = 0

	for(var/datum/stock_part/matter_bin/bin in component_parts)
		new_max_items += MAX_ITEMS_PER_RATING * bin.tier

	for(var/datum/stock_part/servo/servo in component_parts)
		new_productivity += servo.tier
		new_efficiency += servo.tier
		new_processed_items_per_cycle += PROCESSED_ITEMS_PER_RATING * servo.tier

	max_items = new_max_items
	efficiency = new_efficiency
	productivity = new_productivity
	processed_items_per_cycle = new_processed_items_per_cycle

	update_appearance()


/obj/machinery/biogenerator/examine(mob/user)
	. = ..()

	if(in_range(user, src) || isobserver(user))
		. += span_notice(LANG("obj.e69769dde0bfcc79", null))
		. += span_notice(LANG("obj.237b12aa33670638", list(productivity * 100)))
		. += span_notice(LANG("obj.94074b376e8f7af0", list(processed_items_per_cycle)))
		. += span_notice(LANG("obj.15a651395919212f", list(1 / efficiency * 100)))
		. += span_notice(LANG("obj.560b9e0d35b84ea0", list(max_items, get_content_count())))

	if(welded_down)
		. += span_info(LANG("obj.a29ae2b37230283b", null))

/obj/machinery/biogenerator/update_appearance()
	. = ..()

	var/power = machine_stat & (NOPOWER|BROKEN) ? 0 : 1 + min(biomass / max_visual_biomass, 1) + (processing & 1)
	set_light(MINIMUM_USEFUL_LIGHT_RANGE, power, LIGHT_COLOR_CYAN)


/obj/machinery/biogenerator/update_overlays()
	. = ..()

	if(panel_open)
		. += mutable_appearance(icon, "[icon_state]_o_panel")

	if(beaker)
		. += mutable_appearance(icon, "[icon_state]_o_container")

	if(biomass > 0)
		// Get current biomass volume adjusted with sine function (more biomass = less frequent icon changes)
		var/biomass_volume_sin = sin(min(biomass/max_visual_biomass, 1) * 90)
		// Round up to get the corresponding overlay icon
		var/biomass_level = ROUND_UP(biomass_volume_sin * 7)
		. += mutable_appearance(icon, "[icon_state]_o_biomass_[biomass_level]")
		. += emissive_appearance(icon, "[icon_state]_o_biomass_[biomass_level]", src)

	if(machine_stat & (NOPOWER|BROKEN))
		return

	if(processing)
		. += mutable_appearance(icon, "[icon_state]_o_process")
		. += emissive_appearance(icon, "[icon_state]_o_process", src)

	. += mutable_appearance(icon, "[icon_state]_o_screen")
	. += emissive_appearance(icon, "[icon_state]_o_screen", src)

/obj/machinery/biogenerator/wrench_act(mob/living/user, obj/item/tool)
	switch(default_unfasten_wrench(user, tool))
		if(SUCCESSFUL_UNFASTEN)
			return ITEM_INTERACT_SUCCESS
		if(FAILED_UNFASTEN)
			return ITEM_INTERACT_BLOCKING
	return NONE

/obj/machinery/biogenerator/screwdriver_act(mob/living/user, obj/item/tool)
	. = default_deconstruction_screwdriver(user, tool)
	if(processing)
		stop_process(FALSE)

	if(beaker)
		beaker.forceMove(drop_location())
		beaker = null

	return .

/obj/machinery/biogenerator/crowbar_act(mob/living/user, obj/item/tool)
	. = default_deconstruction_crowbar(user, tool)
	if(!(. & ITEM_INTERACT_SUCCESS))
		return
	var/turf/drop_location = drop_location()
	if(biomass > 0)
		drop_location.visible_message(span_warning(LANG("obj.7d7dbe0b6b036c25", list(src))))
		playsound(drop_location, 'sound/effects/slosh.ogg', 25, vary = TRUE)
		new /obj/effect/decal/cleanable/greenglow(drop_location)

/obj/machinery/biogenerator/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(user.combat_mode)
		return NONE

	if(istype(tool, /obj/item/reagent_containers/cup))
		if(panel_open)
			to_chat(user, span_warning(LANG("obj.b13bf2a8bc6430a1", null)))
			return ITEM_INTERACT_BLOCKING

		insert_beaker(user, tool)
		return ITEM_INTERACT_SUCCESS

	var/content_count = get_content_count()
	if(istype(tool, /obj/item/storage/bag))
		if(content_count >= max_items)
			to_chat(user, span_warning(LANG("obj.60ad134d9c6adcd5", list(src))))
			return ITEM_INTERACT_FAILURE

		var/obj/item/storage/bag/bag = tool
		for(var/obj/item/food/item in bag.contents)
			if(content_count >= max_items)
				break
			bag.atom_storage.attempt_remove(item, src)

		content_count = get_content_count() // Refresh the cache for UI
		if(bag.contents.len == 0)
			to_chat(user, span_info(LANG("obj.04f0231a077feeb5", list(bag, src))))
		else if (content_count >= max_items)
			to_chat(user, span_info(LANG("obj.49ef40eaa101f6e6", list(src, bag))))
		else
			to_chat(user, span_info(LANG("obj.b8142e41f5ceccfe", list(src, bag))))
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/food))
		if(content_count >= max_items)
			to_chat(user, span_warning(LANG("obj.60ad134d9c6adcd5", list(src))))
			return ITEM_INTERACT_FAILURE

		if(user.transferItemToLoc(tool, src))
			to_chat(user, span_info(LANG("obj.3e7178020a57bf4b", list(tool, src))))
			get_content_count() // Refresh the cache for UI
		return ITEM_INTERACT_SUCCESS

	to_chat(user, span_warning(LANG("obj.33b055bba334fa5c", list(tool, src))))
	return ITEM_INTERACT_BLOCKING

/obj/machinery/biogenerator/click_alt(mob/living/user)
	eject_beaker(user)
	return CLICK_ACTION_SUCCESS

/// Activates biomass processing and converts all inserted food products into biomass
/obj/machinery/biogenerator/proc/start_process()
	if(machine_stat != NONE || panel_open)
		return

	if(processing)
		say(LANG("obj.e8db372dd15918d4", null))
		return

	if(!(locate(/obj/item/food) in contents))
		say(LANG("obj.62148145688118bc", null))
		return

	begin_processing()
	processing = TRUE
	soundloop.start()
	update_appearance()

/obj/machinery/biogenerator/process(seconds_per_tick)
	if(!processing)
		return

	if(machine_stat != NONE || panel_open)
		stop_process()
		return

	if(!get_content_count())
		stop_process()
		return

	for(var/i in 1 to processed_items_per_cycle)
		var/obj/item/food/food_to_convert = locate(/obj/item/food) in contents

		if(!food_to_convert)
			break

		if(food_to_convert.flags_1 & HOLOGRAM_1)
			qdel(food_to_convert)
		else
			convert_to_biomass(food_to_convert)

	use_energy(active_power_usage * seconds_per_tick)

	if(!get_content_count())
		stop_process(FALSE)

	update_appearance()

/obj/machinery/biogenerator/proc/get_content_count()
	content_count_cache = 0
	for (var/obj/item/food/food in contents)
		content_count_cache += 1
	return content_count_cache

/**
 * Simple helper proc that converts the given food item into biomass for the generator, while also handling removing it
 *
 * Arguments:
 * * food_to_convert - The food item that will be converted into biomass and
 * subsequently be deleted.
 */
/obj/machinery/biogenerator/proc/convert_to_biomass(obj/item/food/food_to_convert)
	var/nutriments = ROUND_UP(food_to_convert.reagents.get_reagent_amount(/datum/reagent/consumable/nutriment, type_check = REAGENT_PARENT_TYPE))
	biomass += nutriments * productivity
	qdel(food_to_convert)

/**
 * Simple helper to handle stopping the process of the biogenerator.
 *
 * Arguments:
 * * update_appearance - Whether or not we call `update_appearance()` here.
 * Defaults to `TRUE`.
 */
/obj/machinery/biogenerator/proc/stop_process(update_appearance = TRUE)
	end_processing()
	processing = FALSE
	soundloop.stop()

	if(update_appearance)
		update_appearance()


/obj/machinery/biogenerator/proc/use_biomass(list/materials, amount = 1, remove_biomass = TRUE)
	if(materials.len != 1 || materials[1] != SSmaterials.get_material(/datum/material/biomass))
		return FALSE

	var/cost = materials[SSmaterials.get_material(/datum/material/biomass)] * amount / efficiency
	if (cost > biomass)
		return FALSE


	if(remove_biomass)
		biomass -= cost

	update_appearance()
	return TRUE


/obj/machinery/biogenerator/proc/create_product(datum/design/design, amount)
	if(design.make_reagent)
		if(!beaker)
			return FALSE

		if(beaker.reagents.maximum_volume - beaker.reagents.total_volume < amount)
			say(LANG("obj.b460e63facbbdb96", null))
			return FALSE

		if(!use_biomass(design.materials, amount))
			return FALSE

		beaker.reagents.add_reagent(design.make_reagent, amount, added_purity = BIOGEN_REAGENT_PURITY)

	if(design.build_path)
		if(!use_biomass(design.materials, amount))
			return FALSE

		var/drop_location = drop_location()
		if(istype(design.build_path, /obj/item/stack/sheet))
			design.create_result(drop_location, amount = amount)
		else
			for(var/i in 1 to amount)
				design.create_result(drop_location)

	return TRUE


/*
 * Insert a new beaker into the biogenerator, replacing/swapping our current beaker if there is one.
 *
 * user - the mob inserting the beaker
 * inserted_beaker - the beaker we're inserting into the biogen
 */
/obj/machinery/biogenerator/proc/insert_beaker(mob/living/user, obj/item/reagent_containers/cup/inserted_beaker)
	if(!can_interact(user))
		return

	if(!user.transferItemToLoc(inserted_beaker, src))
		return

	if(beaker)
		to_chat(user, span_notice(LANG("obj.f693579bc3bb62f1", list(beaker, src, inserted_beaker))))
		eject_beaker(user, silent = TRUE)

	else
		to_chat(user, span_notice(LANG("obj.0c27fe262b2ac3b6", list(inserted_beaker, src))))

	beaker = inserted_beaker
	update_appearance(UPDATE_ICON)


/*
 * Eject the current stored beaker either into the user's hands or onto the ground.
 *
 * user - the mob ejecting the beaker
 * silent - whether to give a message to the user that the beaker was ejected.
 */
/obj/machinery/biogenerator/proc/eject_beaker(mob/living/user, silent = FALSE)
	if(!beaker)
		return

	if(!can_interact(user))
		return

	var/obj/item/ejected_beaker = beaker

	if(user.put_in_hands(beaker))
		if(!silent)
			to_chat(user, span_notice(LANG("obj.daa0023e3c36c4e8", list(ejected_beaker, src))))

	else
		if(!silent)
			to_chat(user, span_notice(LANG("obj.cb3a2d713ecd060f", list(ejected_beaker, src))))

		ejected_beaker.forceMove(drop_location())

	beaker = null
	update_appearance(UPDATE_ICON)


/obj/machinery/biogenerator/ui_status(mob/user, datum/ui_state/state)
	if(machine_stat & BROKEN || panel_open)
		return UI_CLOSE

	return ..()


/obj/machinery/biogenerator/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet_batched/research_designs),
	)


/obj/machinery/biogenerator/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Biogenerator", name)
		ui.open()


/obj/machinery/biogenerator/ui_data(mob/user)
	var/list/data = list()
	data["beaker"] = beaker ? TRUE : FALSE
	data["biomass"] = biomass
	data["processing"] = processing
	data["max_output"] = max_output
	data["efficiency"] = efficiency
	data["can_process"] = !!content_count_cache

	if(beaker)
		data["beakerCurrentVolume"] = round(beaker.reagents.total_volume, 0.01)
		data["beakerMaxVolume"] = beaker.volume
		data["reagent_color"] = mix_color_from_reagents(beaker.reagents.reagent_list)

	return data


/obj/machinery/biogenerator/ui_static_data(mob/user)
	var/list/data = list()
	data["categories"] = list()
	data["max_visual_biomass"] = max_visual_biomass

	var/list/categories = show_categories.Copy()
	for(var/category in categories)
		categories[category] = list()

	for(var/design_path in stored_research.researched_designs)
		var/datum/design/design = SSresearch.techweb_designs[design_path]
		for(var/category in categories)
			if(category in design.category)
				categories[category] += design

	for(var/category, category_designs in categories)
		var/list/cat = list(
			"name" = category,
			"items" = (category == selected_cat ? list() : null))

		for(var/datum/design/design as anything in category_designs)
			cat["items"] += list(list(
				"path" = design.type,
				"name" = lang_reverse_text(design.name), // NOVA EDIT - I18N: ui_static_data (constant data, bypasses P1); product name in datum.json but front-end auto-localizes vs tgui.json → reverse here (act uses path, safe). ORIGINAL: "name" = design.name,
				"icon" = design.asset_id,
				"is_reagent" = !isnull(design.make_reagent),
				"cost" = design.materials[SSmaterials.get_material(/datum/material/biomass)] / efficiency,
			))
		data["categories"] += list(cat)

	return data


/obj/machinery/biogenerator/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("activate")
			start_process()
			return TRUE

		if("eject")
			eject_beaker(usr)
			return TRUE

		if("create")
			var/design_path = text2path(params["design_path"])
			if(!design_path)
				return

			if(!stored_research.researched_designs[design_path])
				return

			var/datum/design/design = SSresearch.techweb_designs[design_path]
			if(!istype(design))
				stack_trace("Invalid design ID passed into biogenerator ui_act()")
				return

			var/amount = text2num(params["amount"])
			if(!amount)
				return
			amount = clamp(amount, 1, (design.make_reagent && beaker ? beaker.reagents.maximum_volume - beaker.reagents.total_volume : max_output))
			create_product(design, amount)

			return TRUE

		if("select")
			selected_cat = params["category"]
			return TRUE


#undef MAX_ITEMS_PER_RATING
#undef PROCESSED_ITEMS_PER_RATING
