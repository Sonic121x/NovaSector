/obj/item/mecha_parts/mecha_equipment/utility/fob_3d_printer
	name = "FOB制造器模块"
	desc = "一款为太阳联邦野战机甲配备的可部署结构打印机。允许制造战术基础设施。"
	icon = 'icons/obj/machines/lathes.dmi'
	icon_state = "autolathe"
	equipment_slot = MECHA_UTILITY
	detachable = FALSE
	///are we laying a cable?
	var/cablelay_mode = FALSE
	///List of printables items
	var/list/printables = list(
		/obj/structure/deployable_barricade/metal/plasteel = list(
			name = "塑钢路障",
			energy = 100,
			time = 2.5 SECONDS
		),
		/obj/structure/deployable_barricade/metal = list(
			name = "金属路障",
			energy = 75,
			time = 2 SECONDS
		),
		/obj/structure/barricade/sandbags = list(
			name = "沙袋",
			energy = 50,
			time = 1.5 SECONDS
		),
		/turf/closed/wall/r_wall = list(
			name = "强化墙",
			energy = 120,
			time = 3 SECONDS
		),
		/turf/closed/wall = list(
			name = "墙",
			energy = 90,
			time = 2.5 SECONDS
		),
		/obj/machinery/power/smes/battery_pack = list(
			name = "固定式电池",
			energy = 200,
			time = 4 SECONDS
		),
		/obj/machinery/power/rtg/portable = list(
			name = "RTG发电机",
			energy = 250,
			time = 5 SECONDS
		),
		/obj/machinery/power/floodlight = list(
			name = "泛光灯",
			energy = 80,
			time = 2 SECONDS
		),
		/turf/open/floor/plating = list(
			name = "底板",
			energy = 30,
			time = 1 SECONDS
		),
		/obj/machinery/mech_bay_recharge_port = list(
			name = "机甲泊位电源接口",
			energy = 150,
			time = 3.5 SECONDS
		),
		/obj/machinery/computer/mech_bay_power_console = list(
			name = "机甲泊位控制台",
			energy = 100,
			time = 3 SECONDS
		)
	)

/obj/item/mecha_parts/mecha_equipment/utility/fob_3d_printer/attach(obj/vehicle/sealed/mecha/new_mecha, attach_right)
	. = ..()
	new_mecha.initialize_controller_action_type(/datum/action/vehicle/sealed/mecha/solfed_3d_printer_open_menu, VEHICLE_CONTROL_EQUIPMENT)
	new_mecha.initialize_controller_action_type(/datum/action/vehicle/sealed/mecha/toggle_cablelay, VEHICLE_CONTROL_EQUIPMENT)

/obj/item/mecha_parts/mecha_equipment/solfed_3d_printer/detach(atom/moveto)
	chassis?.destroy_controller_action_type(/datum/action/vehicle/sealed/mecha/solfed_3d_printer_open_menu, VEHICLE_CONTROL_EQUIPMENT)
	chassis?.destroy_controller_action_type(/datum/action/vehicle/sealed/mecha/toggle_cablelay, VEHICLE_CONTROL_EQUIPMENT)
	return ..()

/obj/item/mecha_parts/mecha_equipment/solfed_3d_printer/Destroy()
	chassis?.destroy_controller_action_type(/datum/action/vehicle/sealed/mecha/solfed_3d_printer_open_menu, VEHICLE_CONTROL_EQUIPMENT)
	chassis?.destroy_controller_action_type(/datum/action/vehicle/sealed/mecha/toggle_cablelay, VEHICLE_CONTROL_EQUIPMENT)
	return ..()

/datum/action/vehicle/sealed/mecha/solfed_3d_printer_open_menu
	name = "可部署结构"
	button_icon = 'modular_nova/modules/solfed_mechs/icons/action_mecha.dmi'
	button_icon_state = "rcd"
	desc = "部署太阳联邦野战结构。"

/datum/action/vehicle/sealed/mecha/solfed_3d_printer_open_menu/Trigger(mob/user, trigger_flags)
	. = ..()
	if(!.)
		return
	var/obj/item/mecha_parts/mecha_equipment/utility/fob_3d_printer/printer = locate(/obj/item/mecha_parts/mecha_equipment/utility/fob_3d_printer) in chassis.equip_by_category[MECHA_UTILITY]
	if (!printer)
		to_chat(user, "未检测到打印机模块。")
		return

	var/list/choices = list()
	for (var/typepath in printer.printables)
		var/name = printer.printables[typepath]["name"]
		choices[name] = typepath

	var/choice = input(user, "选择要部署的结构：", "FOBricator") in choices
	if (!choice)
		return

	printer.deploy_structure(user, choices[choice])

/datum/action/vehicle/sealed/mecha/toggle_cablelay
	name = "切换电缆铺设模式"
	button_icon = 'modular_nova/modules/solfed_mechs/icons/action_mecha.dmi'
	button_icon_state = "rcl_off"
	desc = "在有效格子上移动时自动铺设电缆。"

/datum/action/vehicle/sealed/mecha/toggle_cablelay/Trigger(mob/clicker, trigger_flags)
	. = ..()
	if(!.)
		return
	var/obj/item/mecha_parts/mecha_equipment/utility/fob_3d_printer/printer = locate(/obj/item/mecha_parts/mecha_equipment/utility/fob_3d_printer) in chassis.equip_by_category[MECHA_UTILITY]
	if (!printer)
		to_chat(clicker, "未检测到电缆铺设模块。")
		return

	printer.cablelay_mode = !printer.cablelay_mode
	button_icon_state = printer.cablelay_mode ? "rcl_on" : "rcl_off"
	build_all_button_icons()
	to_chat(clicker, "电缆铺设模式[printer.cablelay_mode ? "enabled" : "disabled"]。")

/obj/item/mecha_parts/mecha_equipment/utility/fob_3d_printer/Move(newloc, dir)
	. = ..()
	if(!cablelay_mode)
		return
	var/turf/current_tile = get_turf(src)
	var/mob/living/user = chassis.return_drivers()[1]
	if(isnull(user) || !isturf(current_tile))
		return

	if(current_tile.underfloor_accessibility < UNDERFLOOR_INTERACTABLE || !current_tile.can_have_cabling())
		return

	for(var/obj/structure/cable/existing_cable in current_tile)
		if(existing_cable.cable_layer & CABLE_LAYER_2)
			return // Already a cable here

	var/obj/structure/cable/new_cable = new /obj/structure/cable(current_tile)
	new_cable.cable_layer = CABLE_LAYER_2

	var/datum/powernet/net = new()
	net.add_cable(new_cable)

	for(var/dir_check in GLOB.cardinals)
		new_cable.mergeConnectedNetworks(dir_check)
	new_cable.mergeConnectedNetworksOnTurf()

	chassis.use_energy(25)

/datum/action/vehicle/sealed/mecha/open_fob_menu
	name = "可部署结构"
	button_icon_state = "build"
	desc = "部署太阳联邦野外结构。"

/datum/action/vehicle/sealed/mecha/open_fob_menu/Trigger(mob/user, trigger_flags)
	. = ..()
	if(!.)
		return
	if(!chassis)
		return

	var/obj/item/mecha_parts/mecha_equipment/utility/fob_3d_printer/printer = locate(/obj/item/mecha_parts/mecha_equipment/utility/fob_3d_printer) in chassis.flat_equipment
	var/list/choices = list()
	for(var/typepath in printer.printables)
		var/name = printer.printables[typepath]["name"]
		choices[name] = typepath

	var/choice = input(user, "选择要部署的结构：", "FOBricator") in choices
	if(!choice)
		return

	printer.deploy_structure(user, choices[choice])

///Check if the item the mech is trying to build fits at the location targetted.
/obj/item/mecha_parts/mecha_equipment/utility/fob_3d_printer/proc/can_build_here(turf/target_turf, typepath, atom/movable/user = null)
	// Rule 1: Must be a valid turf and not a closed one
	if(!isturf(target_turf) || istype(target_turf, /turf/closed))
		return FALSE

	// Rule 2: Use RCD-style blocked turf check
	if(target_turf.is_blocked_turf(
		exclude_mobs = TRUE,
		source_atom = user,
		ignore_atoms = list(/obj/item, /obj/effect),
		type_list = TRUE))
		balloon_alert(user, "该格子上有东西！")
		return FALSE

	// Rule 3: Plating can only be built on openspace
	if(typepath == /turf/open/floor/plating && !istype(target_turf, /turf/open/openspace))
		return FALSE

	return TRUE

///Provided there's space and the mecha has enough power, create a structure one step in front of the mech.
/obj/item/mecha_parts/mecha_equipment/utility/fob_3d_printer/proc/deploy_structure(mob/user, typepath)
	var/data = printables[typepath]
	if(!data)
		return

	var/energy_cost = data["energy"]
	var/deploy_time = data["time"]
	var/turf/target = get_step(src, usr.dir)

	if(!can_build_here(target, typepath))
		to_chat(user, "不是有效的部署空间。")
		return

	if(!chassis.use_energy(energy_cost))
		to_chat(user, "能量不足，无法制造[data["name"]]。")
		return

	to_chat(user, "Beginning deployment of [data["name"]]...")

	if (do_after(user, deploy_time, target))
		chassis.use_energy(energy_cost)
		var/obj/structure/item = new typepath(target)
		item.setDir(user.dir)
		to_chat(user, "[item]部署成功。")
