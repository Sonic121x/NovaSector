//RAPID HANDHELD DEVICE. the base for all rapid devices

#define SILO_USE_AMOUNT (SHEET_MATERIAL_AMOUNT / 4)

/obj/item/construction
	name = "非游戏内使用"
	desc = "一种用于快速建造和解构的设备。使用铁、塑钢、玻璃或压缩物质弹匣进行装填。"
	abstract_type = /obj/item/construction
	opacity = FALSE
	density = FALSE
	anchored = FALSE
	obj_flags = CONDUCTS_ELECTRICITY
	item_flags = NOBLUDGEON
	force = 0
	throwforce = 10
	throw_speed = 3
	throw_range = 5
	w_class = WEIGHT_CLASS_NORMAL
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 50)
	req_access = list(ACCESS_ENGINE_EQUIP)
	armor_type = /datum/armor/item_construction
	resistance_flags = FIRE_PROOF
	/// the spark system which sparks whever the ui options are dited
	var/datum/effect_system/basic/spark_spread/spark_system
	/// current local matter inside the device, not used when silo link is on
	var/matter = 0
	/// maximum local matter this device can hold, not used when silo link is on
	var/max_matter = 100
	/// controls whether or not does update_icon apply ammo indicator overlays
	var/has_ammobar = FALSE
	/// amount of divisions in the ammo indicator overlay/number of ammo indicator states
	var/ammo_sections = 10
	/// icon_state prefix used for charge overlays — defaults to icon_state if not set
	var/charge_icon_state
	/// bitflags for upgrades
	var/construction_upgrades = NONE
	/// bitflags for banned upgrades
	var/banned_upgrades = NONE
	/// remote connection to the silo
	var/datum/remote_materials/silo_mats
	/// switch to use internal or remote storage
	var/silo_link = FALSE
	/// has the blueprint design changed
	var/blueprint_changed = FALSE

/datum/armor/item_construction
	fire = 100
	acid = 50

/obj/item/construction/Initialize(mapload)
	. = ..()
	spark_system = new(5, FALSE, src)
	spark_system.attach(src)
	if(construction_upgrades & RCD_UPGRADE_SILO_LINK)
		silo_mats = new (src, mapload, FALSE)
	update_appearance()

/obj/item/construction/Destroy()
	QDEL_NULL(silo_mats)
	return ..()

///An do_after() specially designed for rhd devices
/obj/item/construction/proc/build_delay(mob/user, delay, atom/target)
	if(delay <= 0)
		return TRUE

	blueprint_changed = FALSE

	return do_after(user, delay, target, extra_checks = CALLBACK(src, PROC_REF(blueprint_change)))

/obj/item/construction/proc/blueprint_change()
	PRIVATE_PROC(TRUE)

	return !blueprint_changed

///used for examining the RCD and for its UI
/obj/item/construction/proc/get_silo_iron()
	if(silo_link && silo_mats.mat_container && !silo_mats.on_hold())
		return silo_mats.mat_container.get_material_amount(/datum/material/iron) / SILO_USE_AMOUNT
	return 0

///returns local matter units available. overridden by rcd borg to return power units available
/obj/item/construction/proc/get_matter(mob/user)
	return matter

/obj/item/construction/examine(mob/user)
	. = ..()
	. += "It currently holds [get_matter(user)]/[max_matter] matter-units."
	if(construction_upgrades & RCD_UPGRADE_SILO_LINK)
		. += "Remote storage link state: [silo_link ? "[silo_mats.on_hold() ? "ON HOLD" : "ON"]" : "OFF"]."
		var/iron = get_silo_iron()
		if(iron)
			. += "Remote connection has iron in equivalent to [iron] RCD unit\s." //1 matter for 1 floor tile, as 4 tiles are produced from 1 iron

/obj/item/construction/Destroy()
	QDEL_NULL(spark_system)
	silo_mats = null
	return ..()

/obj/item/construction/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	SHOULD_CALL_PARENT(TRUE)

	if(istype(interacting_with, /obj/item/rcd_upgrade))
		install_upgrade(interacting_with, user)
		return ITEM_INTERACT_SUCCESS
	if(insert_matter(interacting_with, user))
		return ITEM_INTERACT_SUCCESS
	return ..()

/obj/item/construction/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	SHOULD_CALL_PARENT(TRUE)

	if(istype(tool, /obj/item/rcd_upgrade))
		install_upgrade(tool, user)
		return ITEM_INTERACT_SUCCESS
	if(insert_matter(tool, user))
		return ITEM_INTERACT_SUCCESS
	return ..()

/// Installs an upgrade into the RCD checking if it is already installed, or if it is a banned upgrade
/obj/item/construction/proc/install_upgrade(obj/item/rcd_upgrade/design_disk, mob/user)
	if(design_disk.upgrade & construction_upgrades)
		balloon_alert(user, "已安装！")
		return FALSE
	if(design_disk.upgrade & banned_upgrades)
		balloon_alert(user, "无法安装升级！")
		return FALSE
	construction_upgrades |= design_disk.upgrade
	if((design_disk.upgrade & RCD_UPGRADE_SILO_LINK) && !silo_mats)
		silo_mats = new (src, FALSE, FALSE)
	playsound(loc, 'sound/machines/click.ogg', 50, TRUE)
	qdel(design_disk)
	update_static_data_for_all_viewers()
	return TRUE

/// Inserts matter into the RCD allowing it to build
/obj/item/construction/proc/insert_matter(obj/item, mob/user)
	if(iscyborg(user))
		return FALSE

	var/loaded = FALSE
	if(istype(item, /obj/item/rcd_ammo))
		var/obj/item/rcd_ammo/ammo = item
		var/load = min(ammo.ammoamt, max_matter - matter)
		if(load <= 0)
			balloon_alert(user, "存储已满！")
			return FALSE
		ammo.ammoamt -= load
		if(ammo.ammoamt <= 0)
			qdel(ammo)
		matter += load
		playsound(loc, 'sound/machines/click.ogg', 50, TRUE)
		loaded = TRUE
	else if(isstack(item))
		loaded = loadwithsheets(item, user)
	if(loaded)
		update_appearance() //ensures that ammo counters (if present) get updated
	return loaded

/obj/item/construction/proc/loadwithsheets(obj/item/stack/the_stack, mob/user)
	if(the_stack.matter_amount <= 0)
		balloon_alert(user, "无效板材！")
		return FALSE
	var/maxsheets = round((max_matter-matter) / the_stack.matter_amount) //calculate the max number of sheets that will fit in RCD
	if(maxsheets > 0)
		var/amount_to_use = min(the_stack.amount, maxsheets)
		the_stack.use(amount_to_use)
		matter += the_stack.matter_amount * amount_to_use
		playsound(loc, 'sound/machines/click.ogg', 50, TRUE)
		return TRUE
	balloon_alert(user, "存储已满！")
	return FALSE

/obj/item/construction/attack_self(mob/user)
	playsound(loc, 'sound/effects/pop.ogg', 50, FALSE)
	if(prob(20))
		spark_system.start()

/obj/item/construction/update_overlays()
	. = ..()
	if(has_ammobar)
		var/ratio = ceil((matter / max_matter) * ammo_sections)
		if(ratio > 0)
			. += "[charge_icon_state || icon_state]_charge[ratio]"

/**
 * Uses resource to do some action. Returns amount of resource used or TRUE/FALSE if only an dry run is required
 *
 * Arguments
 * * amount - the amount of resource to use
 * * mob/user - the player using the resource
 * * dry_run - if TRUE will only check if the amount of resource is available but will not use any
*/
/obj/item/construction/proc/useResource(amount, mob/user, dry_run = FALSE)
	if(!silo_mats || !silo_link)
		if(matter < amount)
			if(has_ammobar)
				flick("[charge_icon_state || icon_state]_empty", src)
			if(user)
				balloon_alert(user, "材料不足！")
			return FALSE
		if(!dry_run)
			matter -= amount
			update_appearance()
			playsound(loc, 'sound/items/deconstruct.ogg', 50, TRUE)
	else
		if(!silo_mats.can_use_resource(user_data = ID_DATA(user)))
			if(user)
				balloon_alert(user, "权限不足！")
			return FALSE
		if(!silo_mats.mat_container.has_enough_of_material(/datum/material/iron, amount * SILO_USE_AMOUNT))
			if(user)
				balloon_alert(user, "筒仓材料不足！")
			return FALSE
		if(!dry_run)
			amount = silo_mats.use_materials(list(/datum/material/iron = SILO_USE_AMOUNT), multiplier = amount, action = "RESTOCKED", name = "x restocked an RCD", user_data = ID_DATA(user))
			playsound(loc, 'sound/items/deconstruct.ogg', 50, TRUE)
	return dry_run ? TRUE : amount

/obj/item/construction/ui_static_data(mob/user)
	. = list()

	.["silo_upgraded"] = !!(construction_upgrades & RCD_UPGRADE_SILO_LINK)

///shared data for rcd,rld & plumbing
/obj/item/construction/ui_data(mob/user)
	var/list/data = list()

	//matter in the rcd
	var/total_matter = ((construction_upgrades & RCD_UPGRADE_SILO_LINK) && silo_link) ? get_silo_iron() : get_matter(user)
	if(!total_matter)
		total_matter = 0
	data["matterLeft"] = total_matter

	data["silo_enabled"] = silo_link

	return data

/obj/item/construction/proc/toggle_silo(mob/user)
	if(!silo_mats)
		to_chat(user, span_warning("无远程存储连接。"))
		return FALSE

	if(!silo_mats.mat_container && !silo_link) // Allow them to turn off an invalid link.
		to_chat(user, span_warning("未检测到筒仓链接。"))
		return FALSE

	silo_link = !silo_link
	to_chat(user, span_notice("silo link state: [silo_link ? "on" : "off"]"))
	return TRUE

///shared action for toggling silo link rcd,rld & plumbing
/obj/item/construction/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(action == "toggle_silo" && (construction_upgrades & RCD_UPGRADE_SILO_LINK))
		toggle_silo(ui.user)
		return TRUE

	var/update = handle_ui_act(action, params, ui, state)
	if(isnull(update))
		update = FALSE
	return update

/// overwrite to insert custom ui handling for subtypes
/obj/item/construction/proc/handle_ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	return null

/obj/item/construction/proc/range_check(atom/target, mob/user)
	if(target.z != user.z)
		return
	if(!(target in dview(7, get_turf(user))))
		balloon_alert(user, "超出范围！")
		flick("[icon_state]_empty", src)
		return FALSE
	else
		return TRUE

/**
 * Checks if we are allowed to interact with a radial menu
 *
 * Arguments:
 * * user The living mob interacting with the menu
 * * remote_anchor The remote anchor for the menu
 */
/obj/item/construction/proc/check_menu(mob/living/user, remote_anchor)
	if(!istype(user))
		return FALSE
	if(user.incapacitated)
		return FALSE
	if(remote_anchor && user.remote_control != remote_anchor)
		return FALSE
	return TRUE

/obj/item/rcd_upgrade
	name = "RCD高级设计磁盘"
	desc = "它似乎是空的。"
	icon = 'icons/obj/devices/floppy_disks.dmi'
	icon_state = "datadisk3"
	var/upgrade

/obj/item/rcd_upgrade/frames
	name = "RCD高级升级：框架"
	desc = "它包含机器框架和计算机框架的设计。"
	icon_state = "datadisk6"
	upgrade = RCD_UPGRADE_FRAMES

/obj/item/rcd_upgrade/simple_circuits
	name = "RCD高级升级：简单电路"
	desc = "它包含防火门、空气警报器、火灾警报器、APC电路和劣质电源单元的设计。"
	icon_state = "datadisk4"
	upgrade = RCD_UPGRADE_SIMPLE_CIRCUITS

/obj/item/rcd_upgrade/anti_interrupt
	name = "RCD高级升级：抗干扰"
	desc = "它包含防止RCD建造和拆除过程中断所需的升级。"
	icon_state = "datadisk2"
	upgrade = RCD_UPGRADE_ANTI_INTERRUPT

/obj/item/rcd_upgrade/cooling
	name = "RCD高级升级：增强冷却"
	desc = "它包含允许更频繁使用RCD所需的升级。"
	icon_state = "datadisk7"
	upgrade = RCD_UPGRADE_NO_FREQUENT_USE_COOLDOWN

/obj/item/rcd_upgrade/silo_link
	name = "RCD高级升级：筒仓链接"
	desc = "它包含直接筒仓连接RCD升级。"
	icon_state = "datadisk8"
	upgrade = RCD_UPGRADE_SILO_LINK

/obj/item/rcd_upgrade/furnishing
	name = "RCD高级升级：家具"
	desc = "它包含了椅子、凳子、桌子和玻璃桌的设计图。"
	icon_state = "datadisk5"
	upgrade = RCD_UPGRADE_FURNISHING

/datum/action/item_action/rcd_scan
	name = "破坏扫描"
	desc = "扫描周围区域的破坏情况。被扫描的结构重建速度将显著加快。"

#undef SILO_USE_AMOUNT
