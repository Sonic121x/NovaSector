// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/analyzer
	desc = "A hand-held environmental scanner which reports current gas levels."
	name = "gas analyzer"
	custom_price = PAYCHECK_LOWER * 0.9
	icon = 'icons/obj/devices/scanner.dmi'
	icon_state = "analyzer"
	inhand_icon_state = "analyzer"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	obj_flags = CONDUCTS_ELECTRICITY
	item_flags = NOBLUDGEON
	slot_flags = ITEM_SLOT_BELT
	throwforce = 0
	throw_speed = 3
	throw_range = 7
	tool_behaviour = TOOL_ANALYZER
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT * 0.3, /datum/material/glass=SMALL_MATERIAL_AMOUNT * 0.2)
	interaction_flags_click = NEED_LITERACY|NEED_LIGHT|ALLOW_RESTING
	pickup_sound = 'sound/items/handling/gas_analyzer/gas_analyzer_pickup.ogg'
	drop_sound = 'sound/items/handling/gas_analyzer/gas_analyzer_drop.ogg'
	/// Boolean whether this has a CD
	var/cooldown = FALSE
	/// The time in deciseconds
	var/cooldown_time = 25 SECONDS
	/// 0 is best accuracy
	var/barometer_accuracy
	/// Cached gasmix data from ui_interact
	var/list/last_gasmix_data

	var/datum/weakref/last_scanned
	/// Max scan distance
	var/ranged_scan_distance = 1

/obj/item/analyzer/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_TOOL_ATOM_ACTED_PRIMARY(tool_behaviour), PROC_REF(on_analyze))

	if(type != /obj/item/analyzer)
		return
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/material_sniffer)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/analyzer/grind_results()
	return list(/datum/reagent/mercury = 5, /datum/reagent/iron = 5, /datum/reagent/silicon = 5)

/obj/item/analyzer/equipped(mob/user, slot, initial)
	. = ..()
	ADD_TRAIT(user, TRAIT_DETECT_STORM, CLOTHING_TRAIT)

/obj/item/analyzer/dropped(mob/user, silent)
	. = ..()
	REMOVE_TRAIT(user, TRAIT_DETECT_STORM, CLOTHING_TRAIT)

/obj/item/analyzer/examine(mob/user)
	. = ..()
	. += span_notice(LANG("obj.647b6ae72cb65913", list(src)))
	. += span_notice(LANG("obj.51181bf68a207a6a", list(src)))

/obj/item/analyzer/suicide_act(mob/living/user)
	user.visible_message(span_suicide(LANG("obj.1cd52c32807c3847", list(user, user.p_them(), src, user.p_theyre()))))
	return BRUTELOSS

/obj/item/analyzer/click_alt(mob/user) //Barometer output for measuring when the next storm happens
	if(cooldown)
		to_chat(user, span_warning(LANG("obj.d3c6539477e2630d", list(src))))
		return CLICK_ACTION_BLOCKING

	var/turf/T = get_turf(user)
	if(!T)
		return CLICK_ACTION_BLOCKING

	playsound(src, 'sound/effects/pop.ogg', 100)
	var/area/user_area = T.loc
	var/datum/weather/ongoing_weather = null

	if(!user_area.outdoors)
		to_chat(user, span_warning(LANG("obj.261a3319fb726920", list(src))))
		return CLICK_ACTION_BLOCKING

	for(var/V in SSweather.processing)
		var/datum/weather/W = V
		if((W.weather_flags & WEATHER_BAROMETER) && (T.z in W.impacted_z_levels) && W.area_type == user_area.type && !(W.stage == END_STAGE))
			ongoing_weather = W
			break

	if(ongoing_weather)
		if((ongoing_weather.stage == MAIN_STAGE) || (ongoing_weather.stage == WIND_DOWN_STAGE))
			to_chat(user, span_warning(LANG("obj.67af6f3fb8e57648", list(src, ongoing_weather.stage == MAIN_STAGE ? "already here!" : "winding down."))))
			return CLICK_ACTION_BLOCKING

		to_chat(user, span_notice(LANG("obj.48ac87bf02e4ded8", list(ongoing_weather, butchertime(ongoing_weather.next_hit_time - world.time)))))
		if(!(ongoing_weather.weather_flags & FUNCTIONAL_WEATHER))
			to_chat(user, span_warning(LANG("obj.e13009ac37607046", list(src))))
	else
		var/next_hit = SSweather.next_hit_by_zlevel["[T.z]"]
		var/fixed = next_hit ? timeleft(next_hit) : -1
		if(fixed < 0)
			to_chat(user, span_warning(LANG("obj.892c75506a1b84f4", list(src))))
		else
			to_chat(user, span_warning(LANG("obj.6a27eee16282d7a6", list(src, butchertime(fixed)))))
	cooldown = TRUE
	addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/item/analyzer, ping)), cooldown_time)
	return CLICK_ACTION_SUCCESS

/obj/item/analyzer/proc/ping()
	if(isliving(loc))
		var/mob/living/L = loc
		to_chat(L, span_notice(LANG("obj.e10fc5897ed0e071", list(src))))
	playsound(src, 'sound/machines/click.ogg', 100)
	cooldown = FALSE

/// Applies the barometer inaccuracy to the gas reading.
/obj/item/analyzer/proc/butchertime(amount)
	if(!amount)
		return
	if(barometer_accuracy)
		var/inaccurate = round(barometer_accuracy*(1/3))
		if(prob(50))
			amount -= inaccurate
		if(prob(50))
			amount += inaccurate
	return DisplayTimeText(max(1,amount))

/obj/item/analyzer/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "GasAnalyzer", "Gas Analyzer")
		ui.open()

/obj/item/analyzer/ui_static_data(mob/user)
	return return_atmos_handbooks()

/obj/item/analyzer/ui_data(mob/user)
	var/obj/item/last_scanned_real = last_scanned?.resolve()
	if(!QDELETED(last_scanned_real) && can_see(user, last_scanned_real, ranged_scan_distance))
		collect_scan_info(last_scanned_real) // updates last_gasmix_data as long as we're in range

	return list(
		"gasmixes" = last_gasmix_data,
	)

/// Checks if we can use the analyzer at all
/obj/item/analyzer/proc/can_use(mob/user)
	if(!user.can_read(src))
		return FALSE
	// Logical, but it contains "tutorial information", so we should allow it.
	// if(user.is_blind())
	// 	return FALSE
	return TRUE

/obj/item/analyzer/ui_status(mob/user)
	return can_use(user) ? ..() : UI_CLOSE

/obj/item/analyzer/attack_self(mob/user, modifiers)
	scan_atom(get_turf(src), user)
	return TRUE

/obj/item/analyzer/attack_self_secondary(mob/user, modifiers)
	ui_interact(user)
	return TRUE

/obj/item/analyzer/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(istype(interacting_with, /obj/effect/anomaly) && can_see(user, interacting_with, ranged_scan_distance))
		var/obj/effect/anomaly/ranged_anomaly = interacting_with
		ranged_anomaly.analyzer_act(user, src)
		return ITEM_INTERACT_SUCCESS

	return interact_with_atom(interacting_with, user, modifiers)

/obj/item/analyzer/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!HAS_TRAIT(interacting_with, TRAIT_COMBAT_MODE_SKIP_INTERACTION) && can_see(user, interacting_with, ranged_scan_distance))
		scan_atom(interacting_with.return_analyzable_air() ? interacting_with : get_turf(interacting_with), user)
	return NONE // Non-blocking

/obj/item/analyzer/proc/scan_atom(atom/target, mob/living/user)
	if(!can_use(user))
		return

	atmos_scan(user, target, silent = FALSE)
	collect_scan_info(target)

/obj/item/analyzer/proc/collect_scan_info(atom/target)
	var/mixture = target.return_analyzable_air()
	if(!mixture)
		return

	var/list/airs = islist(mixture) ? mixture : list(mixture)
	var/list/new_gasmix_data = list()
	for(var/datum/gas_mixture/air as anything in airs)
		var/mix_name = capitalize(LOWER_TEXT(target.name))
		if(airs.len != 1) //not a unary gas mixture
			mix_name += " - Node [airs.Find(air)]"
		new_gasmix_data += list(gas_mixture_parser(air, mix_name))
	last_gasmix_data = new_gasmix_data
	last_scanned = WEAKREF(target)

/// Called when our analyzer is used on something
/obj/item/analyzer/proc/on_analyze(datum/source, atom/target)
	SIGNAL_HANDLER
	collect_scan_info(target)

/**
 * Outputs a message to the user describing the target's gasmixes.
 *
 * Gets called by analyzer_act, which in turn is called by tool_act.
 * Also used in other chat-based gas scans.
 */
/proc/atmos_scan(mob/user, atom/target, silent=FALSE)
	var/mixture = target.return_analyzable_air()
	if(!mixture)
		return FALSE

	var/icon = target
	var/message = list()
	if(!silent && isliving(user))
		playsound(user, SFX_INDUSTRIAL_SCAN, 20, TRUE, -2, TRUE, FALSE)
		user.visible_message(span_notice(LANG("_root.442d7504006d8d6c", list(user, icon2html(icon, viewers(user)), target))), span_notice(LANG("_root.3da82a2f5cf28ea4", list(icon2html(icon, user), target))))
	message += span_boldnotice(LANG("_root.f540f85f37c4b0ff", list(icon2html(icon, user), target))) // NOVA EDIT - I18N

	var/list/airs = islist(mixture) ? mixture : list(mixture)
	for(var/datum/gas_mixture/air as anything in airs)
		var/mix_name = capitalize(LOWER_TEXT(target.name))
		if(airs.len > 1) //not a unary gas mixture
			var/mix_number = airs.Find(air)
			message += span_boldnotice(LANG("_root.ad89cabf5f308c26", list(mix_number))) // NOVA EDIT - I18N
			mix_name += " - Node [mix_number]"

		var/total_moles = air.total_moles()
		var/pressure = air.return_pressure()
		var/volume = air.return_volume() //could just do mixture.volume... but safety, I guess?
		var/temperature = air.return_temperature()
		var/heat_capacity = air.heat_capacity()
		var/thermal_energy = air.thermal_energy()

		if(total_moles > 0)
			message += span_notice(LANG("_root.ebc0cba414f2f0d2", list(round(total_moles, 0.01)))) // NOVA EDIT - I18N

			var/list/cached_gas_name = GAS_META[META_GAS_NAME]
			for(var/id, amount in air.moles)
				var/gas_concentration = amount / total_moles
				message += span_notice(LANG("_root.fd761232cbb906a8", list(cached_gas_name[id], round(amount, 0.01), round(gas_concentration*100, 0.01)))) // NOVA EDIT - I18N
			// NOVA EDIT CHANGE START - I18N: 具名累加器 + 非 examine proc → 抽取器整句闸挡在目录外。
			message += span_notice(LANG("_root.65277b5468ac66be", list(round(temperature - T0C,0.01), round(temperature, 0.01))))
			message += span_notice(LANG("_root.d3cc48cf0a5ef13e", list(volume)))
			message += span_notice(LANG("_root.1e0faec1b85c5156", list(round(pressure, 0.01))))
			message += span_notice(LANG("_root.71e36c17dbd74763", list(display_energy(heat_capacity))))
			message += span_notice(LANG("_root.a32465bd906b3973", list(display_energy(thermal_energy))))
			// NOVA EDIT CHANGE END
		else
			message += airs.len > 1 ? span_notice(LANG("_root.fa2f9f11cc67019c", null)) : span_notice(LANG("_root.02d482cc1aef0cef", list(target))) // NOVA EDIT - I18N
			message += span_notice(LANG("_root.d3cc48cf0a5ef13e", list(volume))) // NOVA EDIT - I18N. don't want to change the order volume appears in, suck it

	// we let the join apply newlines so we do need handholding
	to_chat(user, boxed_message(jointext(message, "\n")), type = MESSAGE_TYPE_INFO)
	return TRUE

/obj/item/analyzer/ranged
	desc = "A hand-held long-range environmental scanner which reports current gas levels."
	name = "long-range gas analyzer"
	icon_state = "analyzerranged"
	worn_icon_state = "analyzer"
	w_class = WEIGHT_CLASS_NORMAL
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 0.2, /datum/material/gold = SMALL_MATERIAL_AMOUNT*3, /datum/material/bluespace=SMALL_MATERIAL_AMOUNT*2)
	ranged_scan_distance = 15

/obj/item/analyzer/ranged/grind_results()
	return list(/datum/reagent/mercury = 5, /datum/reagent/iron = 5, /datum/reagent/silicon = 5)
