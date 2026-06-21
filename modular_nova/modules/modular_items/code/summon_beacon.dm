/obj/item/summon_beacon
	name = "召唤信标"
	desc = "召唤一个东西。不过你大概不该用这个。"
	icon = 'icons/obj/devices/remote.dmi'
	icon_state = "self_delivery"
	inhand_icon_state = null
	w_class = WEIGHT_CLASS_SMALL

	/// How many uses the beacon has left
	var/uses = 1

	/// A list of allowed areas that the atom can be spawned in
	var/list/allowed_areas = list(
		/area,
	)
	/// If we are allowed to place in custom areas. Custom area represented by having [/datum/component/custom_area].
	var/allow_custom_areas = TRUE

	/// A list of possible atoms available to spawn. Cen be either regular list or associative list.
	/// Atoms in keys of assotiative list will be used as variants shown to user, values - actual items to spawn.
	var/list/selectable_atoms = list(
		/obj/item/summon_beacon,
	)

	/// The currently selected atom, if any
	var/atom/selected_atom = null

	/// Descriptor of what area it should work in
	var/area_string = "any"

	/// If the supply pod should stay or not
	var/supply_pod_stay = FALSE

/obj/item/summon_beacon/examine()
	. = ..()
	. += span_warning("警告：仅在[area_string]内有效。")
	. += span_notice("当前选择：[selected_atom ? initial(selected_atom.name) : "None"]。")

/obj/item/summon_beacon/attack_self(mob/user)
	if(!can_use_beacon(user))
		return
	if(length(selectable_atoms) == 1)
		selected_atom = selectable_atoms[1]
		return
	show_options(user)

/obj/item/summon_beacon/proc/can_use_beacon(mob/living/user)
	if(user.can_perform_action(src, FORBID_TELEKINESIS_REACH))
		return TRUE
	else
		playsound(src, 'sound/machines/buzz/buzz-sigh.ogg', 40, TRUE)
		return FALSE

/obj/item/summon_beacon/proc/generate_display_names()
	var/list/atom_list = list()
	for(var/atom/iterated_atom as anything in selectable_atoms)
		atom_list[initial(iterated_atom.name)] = iterated_atom
	return atom_list

/obj/item/summon_beacon/proc/show_options(mob/user)
	var/list/radial_build = get_available_options()
	if(!radial_build)
		return

	selected_atom = show_radial_menu(user, src, radial_build, radius = 40, tooltips = TRUE)

	if(selectable_atoms[selected_atom])
		selected_atom = selectable_atoms[selected_atom]

/obj/item/summon_beacon/proc/get_available_options()
	var/list/options = list()
	for(var/iterating_choice in selectable_atoms)
		var/obj/icon_object = iterating_choice
		var/choice_icon = icon_object.greyscale_config ? SSgreyscale.GetColoredIconByType(icon_object.greyscale_config, icon_object.greyscale_colors) : icon_object::icon
		var/datum/radial_menu_choice/option = new
		var/obj/our_object = selectable_atoms[iterating_choice]
		option.image = image(icon = choice_icon, icon_state = icon_object::post_init_icon_state || icon_object::icon_state)
		option.name = our_object ? our_object::name : icon_object::name
		option.info = span_boldnotice("[selectable_atoms[iterating_choice] ? our_object::desc : icon_object::desc]")

		options[icon_object] = option

	sort_list(options)

	return options

/obj/item/summon_beacon/proc/area_check(area/target_area, turf/target_turf)
	if(!target_turf)
		return FALSE
	if(!target_area)
		return FALSE
	if(!(is_type_in_list(target_area, allowed_areas) || (allow_custom_areas && target_area.GetComponent(/datum/component/custom_area))))
		return FALSE
	return TRUE

/obj/item/summon_beacon/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!selected_atom)
		balloon_alert(user, "未选择目标！")
		return NONE
	var/turf/target_turf = get_turf(interacting_with)
	var/area/target_area = get_area(interacting_with)
	if(!area_check(target_area, target_turf))
		balloon_alert(user, "无法在此处召唤！")
		return NONE

	var/confirmed = tgui_alert(user, "你确定要在此处召唤[initial(selected_atom.name)]吗？", "确认", list("Yes", "No"))
	if(confirmed != "Yes")
		return ITEM_INTERACT_BLOCKING

	if(!uses)
		return ITEM_INTERACT_BLOCKING

	uses -= 1
	balloon_alert(user, "还剩[uses]次使用[uses == 1 ? "" : "s"]！")

	podspawn(list(
		"target" = target_turf,
		"path" = supply_pod_stay ? /obj/structure/closet/supplypod/podspawn/no_return : /obj/structure/closet/supplypod/podspawn,
		"style" = /datum/pod_style/centcom,
		"spawn" = selected_atom,
	))

	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		if(istype(human_user.ears, /obj/item/radio/headset))
			to_chat(user, span_notice("You hear something crackle in your ears for a moment before a voice speaks. \
				\"Please stand by for a message from Central Command.  Message as follows: \
				[span_bold("Request received. Pod inbound, please stand back from the landing site.")] \
				Message ends.\""))

	if(!uses)
		qdel(src)
	return ITEM_INTERACT_SUCCESS

// Misc stuff here

/obj/structure/closet/supplypod/podspawn/no_return
	bluespace = FALSE

/obj/item/storage/box/gas_miner_beacons
	name = "气体矿机传送信标盒"
	desc = "包含两个用于传送大气气体矿机的信标。"

/obj/item/storage/box/gas_miner_beacons/PopulateContents()
	new /obj/item/summon_beacon/gas_miner(src)
	new /obj/item/summon_beacon/gas_miner(src)

// Actual beacons start here

/obj/item/summon_beacon/gas_miner
	name = "气体矿机信标"
	desc = "选择气体矿机类型后，会将一个气体矿机传送到目标位置。"
	icon = 'modular_nova/modules/modular_items/icons/remote.dmi'

	allowed_areas = list(
		/area/station/engineering/atmos,
		/area/station/engineering/atmospherics_engine,
		/area/ruin/space/has_grav/nova/des_two/engineering, //ds2
		/area/ruin/space/has_grav/port_tarkon/atmos, //tarkon
		/area/centcom/tdome/arena, //thunderdome
	)

	selectable_atoms = list(
		/obj/machinery/portable_atmospherics/canister/carbon_dioxide = /obj/machinery/atmospherics/miner/carbon_dioxide,
		/obj/machinery/portable_atmospherics/canister/nitrous_oxide = /obj/machinery/atmospherics/miner/n2o,
		/obj/machinery/portable_atmospherics/canister/nitrogen = /obj/machinery/atmospherics/miner/nitrogen,
		/obj/machinery/portable_atmospherics/canister/oxygen = /obj/machinery/atmospherics/miner/oxygen,
		/obj/machinery/portable_atmospherics/canister/plasma = /obj/machinery/atmospherics/miner/plasma,
		/obj/machinery/portable_atmospherics/canister/water_vapor = /obj/machinery/atmospherics/miner/water_vapor,
	)

	area_string = "atmospherics"
	supply_pod_stay = TRUE

/obj/item/summon_beacon/gas_miner/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	. = ..()
	if(. == ITEM_INTERACT_SUCCESS)
		var/turf/location = get_turf(interacting_with)
		location.investigate_log("was selected as target to spawn [selected_atom.name] by [user.ckey]", INVESTIGATE_ATMOS)
		message_admins("[selected_atom.name] was spawned by [user] ([user.ckey]) [ADMIN_JMP(location)].")

/obj/item/summon_beacon/vendors
	name = "自动售货机信标"
	desc = "通过轨道空投传送一台自动售货机，采用获得专利的Donk公司SafeTec技术！"
	uses = 2

	selectable_atoms = list(
		/obj/machinery/vending/assist, // "Part-Mart"
		/obj/machinery/vending/autodrobe, // "AutoDrobe"
		/obj/machinery/vending/boozeomat, // "Booze-O-Mat"
		/obj/machinery/vending/cigarette, // "ShadyCigs Deluxe"
		/obj/machinery/vending/clothing, // "ClothesMate"
		/obj/machinery/vending/coffee, // "Solar's Best Hot Drinks"
		/obj/machinery/vending/cola, // "Robust Softdrinks"
		/obj/machinery/vending/custom, // "Custom Vendor"
		/obj/machinery/vending/dinnerware, // "Plasteel Chef's Dinnerware Vendor"
		/obj/machinery/vending/games, // "Good Clean Fun"
		/obj/machinery/vending/hydronutrients, // "NutriMax"
		/obj/machinery/vending/hydroseeds, // "MegaSeed Servitor"
		/obj/machinery/vending/modularpc, // "Deluxe Silicate Selections"
		/obj/machinery/vending/snack, // "Getmore Chocolate Corp"
		/obj/machinery/vending/tool, // "YouTool"
		/obj/machinery/vending/barbervend, // "Fab-O-Vend"
		/obj/machinery/vending/imported/nt, // "NT Sustenance Supplier"
		/obj/machinery/vending/imported/mothic, // "Nomad Fleet Ration Chit Exchange"
		/obj/machinery/vending/imported/tiziran, // "Tiziran Imported Delicacies"
		/obj/machinery/vending/imported/yangyu, // "Fudobenda"
		/obj/machinery/vending/deforest_medvend, // "DeForest Med-Vend"
	)

/obj/item/summon_beacon/vendors/equipped(mob/user, slot, initial)
	. = ..()
	if (!CONFIG_GET(flag/disable_erp_preferences) && user?.client?.prefs.read_preference(/datum/preference/toggle/master_erp_preferences))
		selectable_atoms += /obj/machinery/vending/dorms
	else
		selectable_atoms -= /obj/machinery/vending/dorms

/obj/item/summon_beacon/gas_miner/hacked
	name = "被黑入的气体矿机信标"
	desc = parent_type::desc + "看起来区域探测器被硬编码为TRUE。嗯。"
	area_string = "any"
	allowed_areas = list(
		/area,
	)

/obj/item/summon_beacon/gas_miner/expanded
	name = "扩展型气体矿机信标"
	desc = parent_type::desc + "这个信标的选择范围似乎被扩展了。"

/obj/item/summon_beacon/gas_miner/expanded/Initialize(mapload)
	. = ..()
	selectable_atoms += list(
		/obj/machinery/portable_atmospherics/canister/water_vapor = /obj/machinery/atmospherics/miner/water_vapor,
		/obj/machinery/portable_atmospherics/canister/freon = /obj/machinery/atmospherics/miner/freon,
		/obj/machinery/portable_atmospherics/canister/halon = /obj/machinery/atmospherics/miner/halon,
		/obj/machinery/portable_atmospherics/canister/healium = /obj/machinery/atmospherics/miner/healium,
		/obj/machinery/portable_atmospherics/canister/hydrogen = /obj/machinery/atmospherics/miner/hydrogen,
		/obj/machinery/portable_atmospherics/canister/nob = /obj/machinery/atmospherics/miner/hypernoblium,
		/obj/machinery/portable_atmospherics/canister/miasma = /obj/machinery/atmospherics/miner/miasma,
		/obj/machinery/portable_atmospherics/canister/nitrium = /obj/machinery/atmospherics/miner/nitrium,
		/obj/machinery/portable_atmospherics/canister/pluoxium = /obj/machinery/atmospherics/miner/pluoxium,
		/obj/machinery/portable_atmospherics/canister/proto_nitrate = /obj/machinery/atmospherics/miner/proto_nitrate,
		/obj/machinery/portable_atmospherics/canister/tritium = /obj/machinery/atmospherics/miner/tritium,
		/obj/machinery/portable_atmospherics/canister/zauker = /obj/machinery/atmospherics/miner/zauker,
		/obj/machinery/portable_atmospherics/canister/helium = /obj/machinery/atmospherics/miner/helium,
		/obj/machinery/portable_atmospherics/canister/antinoblium = /obj/machinery/atmospherics/miner/antinoblium,
	)

/obj/item/summon_beacon/gas_miner/expanded/debug
	name = "调试用气体矿机信标"
	desc = "你最好清楚自己在用这东西做什么。"
	area_string = "any"
	uses = 99
	allowed_areas = list(
		/area,
	)
