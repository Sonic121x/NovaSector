#define BEAN_CAPACITY 10 //amount of coffee beans that can fit inside the impressa coffeemaker

/obj/machinery/coffeemaker
	name = "咖啡机"
	desc = "一台Modello 3型咖啡机，可以冲泡咖啡并将其保持在176华氏度的完美温度.由Piccionaia家用电器公司制造."
	icon = 'icons/obj/machines/coffeemaker.dmi'
	icon_state = "coffeemaker_nopot_nocart"
	base_icon_state = "coffeemaker"
	resistance_flags = FIRE_PROOF | ACID_PROOF
	circuit = /obj/item/circuitboard/machine/coffeemaker
	anchored_tabletop_offset = 4
	interaction_flags_machine = parent_type::interaction_flags_machine | INTERACT_MACHINE_OFFLINE
	var/obj/item/reagent_containers/cup/coffeepot/coffeepot = null
	var/brewing = FALSE
	var/brew_time = 20 SECONDS
	var/speed = 1
	/// The coffee cartridge to make coffee from. In the future, coffee grounds are like printer ink.
	var/obj/item/coffee_cartridge/cartridge = null
	/// The type path to instantiate for the coffee cartridge the device initially comes with, eg. /obj/item/coffee_cartridge
	var/initial_cartridge = /obj/item/coffee_cartridge
	/// The number of cups left
	var/coffee_cups = 15
	var/max_coffee_cups = 15
	/// The amount of sugar packets left
	var/sugar_packs = 10
	var/max_sugar_packs = 10
	/// The amount of sweetener packets left
	var/sweetener_packs = 10
	var/max_sweetener_packs = 10
	/// The amount of creamer packets left
	var/creamer_packs = 10
	var/max_creamer_packs = 10

	var/static/radial_examine = image(icon = 'icons/hud/radial.dmi', icon_state = "radial_examine")
	var/static/radial_brew = image(icon = 'icons/hud/radial_coffee.dmi', icon_state = "radial_brew")
	var/static/radial_eject_pot = image(icon = 'icons/hud/radial_coffee.dmi', icon_state = "radial_eject_pot")
	var/static/radial_eject_cartridge = image(icon = 'icons/hud/radial_coffee.dmi', icon_state = "radial_eject_cartridge")
	var/static/radial_take_cup = image(icon = 'icons/hud/radial_coffee.dmi', icon_state = "radial_take_cup")
	var/static/radial_take_sugar = image(icon = 'icons/hud/radial_coffee.dmi', icon_state = "radial_take_sugar")
	var/static/radial_take_sweetener = image(icon = 'icons/hud/radial_coffee.dmi', icon_state = "radial_take_sweetener")
	var/static/radial_take_creamer = image(icon = 'icons/hud/radial_coffee.dmi', icon_state = "radial_take_creamer")

	var/cup_type = /obj/item/reagent_containers/cup/glass/coffee_cup

/obj/machinery/coffeemaker/Initialize(mapload)
	. = ..()
	if(mapload)
		coffeepot = new /obj/item/reagent_containers/cup/coffeepot(src)
		cartridge = new /obj/item/coffee_cartridge(src)

/obj/machinery/coffeemaker/on_deconstruction(disassembled)
	coffeepot?.forceMove(drop_location())
	cartridge?.forceMove(drop_location())

/obj/machinery/coffeemaker/Destroy()
	QDEL_NULL(coffeepot)
	QDEL_NULL(cartridge)
	remove_shared_particles(/particles/smoke)
	return ..()

/obj/machinery/coffeemaker/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == coffeepot)
		coffeepot = null
		update_appearance(UPDATE_OVERLAYS)
	if(gone == cartridge)
		cartridge = null
		update_appearance(UPDATE_OVERLAYS)

/obj/machinery/coffeemaker/RefreshParts()
	. = ..()
	speed = 0
	for(var/datum/stock_part/micro_laser/laser in component_parts)
		speed += laser.tier

/obj/machinery/coffeemaker/examine(mob/user)
	. = ..()
	if(!in_range(user, src) && !issilicon(user) && !isobserver(user))
		. += span_warning("你离得太远，无法检查[src]的内容和显示屏！")
		return

	if(brewing)
		. += span_warning("\The [src] 正在冲泡中。")
		return

	if(panel_open)
		. += span_notice("[src]的维护区舱门是开着的！")
		return

	if(coffeepot || cartridge)
		. += span_notice("\The [src] 包含：")
		if(coffeepot)
			. += span_notice("- \A [coffeepot].")
		if(cartridge)
			. += span_notice("- \A [cartridge].")
		return

	if(!(machine_stat & (NOPOWER|BROKEN)))
		. += "[span_notice("The status display reads:")]\n"+\
		span_notice("- 正在以<b>[speed*100]%</b>的速度冲泡咖啡。")
		if(coffeepot)
			for(var/datum/reagent/consumable/cawfee as anything in coffeepot.reagents.reagent_list)
				. += span_notice("- [cawfee.volume] 单位咖啡在壶中。")
		if(cartridge)
			if(cartridge.charges < 1)
				. += span_notice("- 咖啡粉盒是空的。")
			else
				. += span_notice("- 咖啡粉盒还剩 [cartridge.charges] 次用量。")

	if (coffee_cups >= 1)
		. += span_notice("还剩 [coffee_cups == 1 ? "is" : "are"] [coffee_cups] 个咖啡杯[coffee_cups != 1 && "s"]。")
	else
		. += span_notice("没有咖啡杯剩余。")

	if (sugar_packs >= 1)
		. += span_notice("还剩 [sugar_packs == 1 ? "is" : "are"] [sugar_packs] 包[sugar_packs != 1 && "s"]糖。")
	else
		. += span_notice("没有糖剩余。")

	if (sweetener_packs >= 1)
		. += span_notice("还剩 [sweetener_packs == 1 ? "is" : "are"] [sweetener_packs] 包[sweetener_packs != 1 && "s"]甜味剂。")
	else
		. += span_notice("没有甜味剂剩余。")

	if (creamer_packs > 1)
		. += span_notice("还剩 [creamer_packs == 1 ? "is" : "are"] [creamer_packs] 包[creamer_packs != 1 && "s"]奶精。")
	else
		. += span_notice("没有奶精剩余。")

/obj/machinery/coffeemaker/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(!can_interact(user) || !user.can_perform_action(src, FORBID_TELEKINESIS_REACH|SILENT_ADJACENCY))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(brewing)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	replace_pot(user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/coffeemaker/attack_robot_secondary(mob/user, list/modifiers)
	return attack_hand_secondary(user, modifiers)

/obj/machinery/coffeemaker/attack_ai_secondary(mob/user, list/modifiers)
	return attack_hand_secondary(user, modifiers)

/obj/machinery/coffeemaker/update_overlays()
	. = ..()
	. += overlay_checks()

/obj/machinery/coffeemaker/proc/overlay_checks()
	. = list()
	if(coffeepot)
		if(istype(coffeepot, /obj/item/reagent_containers/cup/coffeepot/bluespace))
			. += "coffeemaker_pot_bluespace"
		else
			. += "coffeemaker_pot_[coffeepot.reagents.total_volume ? "full" : "empty"]"
	if(cartridge)
		. += "coffeemaker_cartidge"
	return .

/obj/machinery/coffeemaker/proc/replace_pot(mob/living/user, obj/item/reagent_containers/cup/coffeepot/new_coffeepot)
	if(!user)
		return FALSE

	// If we're trying to eject/remove the current pot
	if(!new_coffeepot)
		if(!coffeepot)
			balloon_alert(user, "没有咖啡壶可移除！")
			return FALSE
		try_put_in_hand(coffeepot, user)
		balloon_alert(user, "咖啡壶已放回")
		coffeepot = null
	else
		// If we're replacing with a new pot
		if(coffeepot)
			try_put_in_hand(coffeepot, user)
		coffeepot = new_coffeepot
		balloon_alert(user, "咖啡壶已插入")

	update_appearance(UPDATE_OVERLAYS)
	return TRUE

/obj/machinery/coffeemaker/proc/replace_cartridge(mob/living/user, obj/item/coffee_cartridge/new_cartridge)
	if(!user)
		return FALSE
	if(cartridge)
		try_put_in_hand(cartridge, user)
	if(new_cartridge)
		cartridge = new_cartridge
	update_appearance(UPDATE_OVERLAYS)
	return TRUE

/obj/machinery/coffeemaker/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	default_unfasten_wrench(user, tool)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/coffeemaker/screwdriver_act(mob/living/user, obj/item/tool)
	return isnull(coffeepot) ? default_deconstruction_screwdriver(user, tool) : NONE

/obj/machinery/coffeemaker/crowbar_act(mob/living/user, obj/item/tool)
	return default_deconstruction_crowbar(user, tool)

/obj/machinery/coffeemaker/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(panel_open) //Can't insert objects when its screwed open
		return NONE

	if (istype(tool, /obj/item/reagent_containers/cup/coffeepot) && !(tool.item_flags & ABSTRACT) && tool.is_open_container())
		var/obj/item/reagent_containers/cup/coffeepot/new_pot = tool
		. = ITEM_INTERACT_SUCCESS //no afterattack
		if(!user.transferItemToLoc(new_pot, src))
			return ITEM_INTERACT_BLOCKING
		replace_pot(user, new_pot)
		update_appearance(UPDATE_OVERLAYS)
		return ITEM_INTERACT_SUCCESS //no afterattack

	if (istype(tool, cup_type) && !(tool.item_flags & ABSTRACT) && tool.is_open_container())
		var/obj/item/reagent_containers/cup/glass/coffee_cup/new_cup = tool
		if(new_cup.reagents.total_volume > 0)
			balloon_alert(user, "杯子必须是空的！")
			return ITEM_INTERACT_BLOCKING
		if(coffee_cups >= max_coffee_cups)
			balloon_alert(user, "杯架已满！")
			return ITEM_INTERACT_BLOCKING
		if(!user.transferItemToLoc(tool, src))
			return ITEM_INTERACT_BLOCKING
		coffee_cups++
		update_appearance(UPDATE_OVERLAYS)
		return ITEM_INTERACT_SUCCESS //no afterattack

	if (istype(tool, /obj/item/reagent_containers/condiment/pack/sugar))
		var/obj/item/reagent_containers/condiment/pack/sugar/new_pack = tool
		if(new_pack.reagents.total_volume < new_pack.reagents.maximum_volume)
			balloon_alert(user, "包装必须是满的！")
			return ITEM_INTERACT_BLOCKING
		if(sugar_packs >= max_sugar_packs)
			balloon_alert(user, "糖隔间已满！")
			return ITEM_INTERACT_BLOCKING
		if(!user.transferItemToLoc(tool, src))
			return ITEM_INTERACT_BLOCKING
		sugar_packs++
		update_appearance(UPDATE_OVERLAYS)
		return ITEM_INTERACT_SUCCESS //no afterattack

	if (istype(tool, /obj/item/reagent_containers/condiment/creamer))
		var/obj/item/reagent_containers/condiment/creamer/new_pack = tool
		if(new_pack.reagents.total_volume < new_pack.reagents.maximum_volume)
			balloon_alert(user, "包装必须是满的！")
			return ITEM_INTERACT_BLOCKING
		if(creamer_packs >= max_creamer_packs)
			balloon_alert(user, "奶精隔间已满！")
			return ITEM_INTERACT_BLOCKING
		if(!user.transferItemToLoc(tool, src))
			return ITEM_INTERACT_BLOCKING
		creamer_packs++
		update_appearance(UPDATE_OVERLAYS)
		return ITEM_INTERACT_SUCCESS //no afterattack

	if (istype(tool, /obj/item/reagent_containers/condiment/pack/astrotame))
		var/obj/item/reagent_containers/condiment/pack/astrotame/new_pack = tool
		if(new_pack.reagents.total_volume < new_pack.reagents.maximum_volume)
			balloon_alert(user, "包装必须是满的！")
			return ITEM_INTERACT_BLOCKING
		else if(sweetener_packs >= max_sweetener_packs)
			balloon_alert(user, "甜味剂隔间已满！")
			return ITEM_INTERACT_BLOCKING
		else if(!user.transferItemToLoc(tool, src))
			return ITEM_INTERACT_BLOCKING
		sweetener_packs++
		update_appearance(UPDATE_OVERLAYS)
		return ITEM_INTERACT_SUCCESS //no afterattack

	if (initial_cartridge && istype(tool, /obj/item/coffee_cartridge) && !(tool.item_flags & ABSTRACT))
		var/obj/item/coffee_cartridge/new_cartridge = tool
		if(!user.transferItemToLoc(new_cartridge, src))
			return ITEM_INTERACT_BLOCKING
		replace_cartridge(user, new_cartridge)
		balloon_alert(user, "已添加咖啡胶囊")
		update_appearance(UPDATE_OVERLAYS)
		return ITEM_INTERACT_SUCCESS //no afterattack

	return NONE // Allow normal attack processing if no special interaction occurred

/obj/machinery/coffeemaker/proc/try_brew()
	if(!cartridge)
		balloon_alert(usr, "未插入咖啡胶囊！")
		return FALSE
	if(cartridge.charges < 1)
		balloon_alert(usr, "咖啡胶囊已空！")
		return FALSE
	if(!coffeepot)
		balloon_alert(usr, "内部没有咖啡壶！")
		return FALSE
	if(machine_stat & (NOPOWER|BROKEN))
		balloon_alert(usr, "机器未通电！")
		return FALSE
	if(coffeepot.reagents.total_volume >= coffeepot.reagents.maximum_volume)
		balloon_alert(usr, "咖啡壶已经满了！")
		return FALSE
	return TRUE

/obj/machinery/coffeemaker/ui_interact(mob/user) // The microwave Menu //I am reasonably certain that this is not a microwave //I am positively certain that this is not a microwave
	. = ..()

	if(brewing || !user.can_perform_action(src, SILENT_ADJACENCY))
		return

	var/list/options = list()

	if(coffeepot)
		options["Eject Pot"] = radial_eject_pot

	if(cartridge)
		options["Eject Cartridge"] = radial_eject_cartridge

	options["Brew"] = radial_brew //brew is always available as an option, when the machine is unable to brew the player is told by balloon alerts whats exactly wrong

	if(coffee_cups > 0)
		options["Take Cup"] = radial_take_cup

	if(sugar_packs > 0)
		options["Take Sugar"] = radial_take_sugar

	if(sweetener_packs > 0)
		options["Take Sweetener"] = radial_take_sweetener

	if(creamer_packs > 0)
		options["Take Creamer"] = radial_take_creamer

	if(isAI(user))
		if(machine_stat & NOPOWER)
			return
		options["Examine"] = radial_examine

	var/choice

	if(length(options) < 1)
		return
	if(length(options) == 1)
		choice = options[1]
	else
		choice = show_radial_menu(user, src, options, require_near = !HAS_SILICON_ACCESS(user))

	// post choice verification
	if(brewing || (isAI(user) && machine_stat & NOPOWER) || !user.can_perform_action(src, SILENT_ADJACENCY))
		return

	switch(choice)
		if("Brew")
			brew(user)
		if("Eject Pot")
			eject_pot(user)
		if("Eject Cartridge")
			eject_cartridge(user)
		if("Examine")
			user.examinate(src)
		if("Take Cup")
			take_cup(user)
		if("Take Sugar")
			take_sugar(user)
		if("Take Sweetener")
			take_sweetener(user)
		if("Take Creamer")
			take_creamer(user)

/obj/machinery/coffeemaker/proc/eject_pot(mob/user)
	if(coffeepot)
		replace_pot(user)

/obj/machinery/coffeemaker/proc/eject_cartridge(mob/user)
	if(cartridge)
		replace_cartridge(user)

/obj/machinery/coffeemaker/proc/take_cup(mob/user)
	if(!coffee_cups) //shouldn't happen, but we all know how stuff manages to break
		balloon_alert(user, "没有杯子了！")
		return
	var/obj/item/reagent_containers/cup/glass/coffee_cup/new_cup = new(get_turf(src))
	user.put_in_hands(new_cup)
	coffee_cups--
	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/coffeemaker/proc/take_sugar(mob/user)
	if(!sugar_packs)
		balloon_alert(user, "没有糖了！")
		return
	var/obj/item/reagent_containers/condiment/pack/sugar/new_pack = new(get_turf(src))
	user.put_in_hands(new_pack)
	sugar_packs--
	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/coffeemaker/proc/take_sweetener(mob/user)
	if(!sweetener_packs)
		balloon_alert(user, "没有甜味剂了！")
		return
	var/obj/item/reagent_containers/condiment/pack/astrotame/new_pack = new(get_turf(src))
	user.put_in_hands(new_pack)
	sweetener_packs--
	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/coffeemaker/proc/take_creamer(mob/user)
	if(!creamer_packs)
		balloon_alert(user, "没有奶精了！")
		return
	var/obj/item/reagent_containers/condiment/creamer/new_pack = new(drop_location())
	user.put_in_hands(new_pack)
	creamer_packs--
	update_appearance(UPDATE_OVERLAYS)

///Updates the smoke state to something else, setting particles if relevant
/obj/machinery/coffeemaker/proc/toggle_steam()
	if(!brewing)
		remove_shared_particles("smoke_coffeemaker")
		return

	var/obj/effect/abstract/shared_particle_holder/smoke_particles = add_shared_particles(/particles/smoke/steam/mild, "smoke_coffeemaker")
	smoke_particles.particles.position = list(-6, 0, 0)

/obj/machinery/coffeemaker/proc/operate_for(time, silent = FALSE)
	brewing = TRUE
	if(!silent)
		playsound(src, 'sound/machines/coffeemaker_brew.ogg', 20, vary = TRUE)
	toggle_steam()
	use_energy(active_power_usage * time / (1 SECONDS)) // .1 needed here to convert time (in deciseconds) to seconds such that watts * seconds = joules
	addtimer(CALLBACK(src, PROC_REF(stop_operating)), time / speed)

/obj/machinery/coffeemaker/proc/stop_operating()
	brewing = FALSE
	toggle_steam()

/obj/machinery/coffeemaker/proc/brew()
	power_change()
	if(!try_brew())
		return
	operate_for(brew_time)
	coffeepot.reagents.add_reagent_list(cartridge.drink_type)
	cartridge.charges--
	update_appearance(UPDATE_OVERLAYS)

//Coffee Cartridges: like toner, but for your coffee!
/obj/item/coffee_cartridge
	name = "咖啡机胶囊-经典咖啡（Generico）"
	desc = "适用于Modello 3系统的咖啡胶囊，Piccionaia Coffee公司生产."
	icon = 'icons/obj/food/cartridges.dmi'
	icon_state = "cartridge_basic"
	var/charges = 4
	var/list/drink_type = list(/datum/reagent/consumable/coffee = 120)

/obj/item/coffee_cartridge/examine(mob/user)
	. = ..()
	if(charges)
		. += span_warning("该咖啡盒还剩 [charges] 份咖啡粉。")
	else
		. += span_warning("该咖啡胶囊已无剩余未使用的咖啡粉。")

/obj/item/coffee_cartridge/fancy
	name = "咖啡机胶囊-咖啡幻想（Fantasioso）"
	desc = "适用于Modello 3系统的华丽的咖啡胶囊，Piccionaia Coffee公司生产."
	icon_state = "cartridge_blend"

//Here's the joke before I get 50 issue reports: they're all the same, and that's intentional
/obj/item/coffee_cartridge/fancy/Initialize(mapload)
	. = ..()
	var/coffee_type = pick("blend", "blue_mountain", "kilimanjaro", "mocha")
	switch(coffee_type)
		if("blend")
			name = "咖啡机胶囊-鸽子拼配（Miscela di Piccione）"
			icon_state = "cartridge_blend"
		if("blue_mountain")
			name = "咖啡机胶囊-蓝山风味（Montagna Blu）"
			icon_state = "cartridge_blue_mtn"
		if("kilimanjaro")
			name = "咖啡机胶囊-乞力马扎罗山（Kilimangiaro）"
			icon_state = "cartridge_kilimanjaro"
		if("mocha")
			name = "咖啡机胶囊-阿拉伯摩卡（Moka Arabica）"
			icon_state = "cartridge_mocha"

/obj/item/coffee_cartridge/decaf
	name = "咖啡机胶囊-低因咖啡（Decaffeinato）"
	desc = "适用于Modello 3系统的低因咖啡胶囊，Piccionaia Coffee公司生产."
	icon_state = "cartridge_decaf"

// no you can't just squeeze the juice bag into a glass!
/obj/item/coffee_cartridge/bootleg
	name = "咖啡机胶囊-植物学混装（Botany Blend）"
	desc = "一个临时拼凑的咖啡胶囊装置。理论上能与“Modello 3”系统兼容，不过这样做可能会导致保修失效。"
	icon_state = "cartridge_bootleg"

// blank cartridge for crafting's sake, can be made at the service lathe
/obj/item/blank_coffee_cartridge
	name = "空的咖啡机胶囊"
	desc = "一个空的咖啡筒，已准备好装入咖啡粉。"
	icon = 'icons/obj/food/cartridges.dmi'
	icon_state = "cartridge_blank"

//now, how do you store coffee carts? well, in a rack, of course!
/obj/item/storage/fancy/coffee_cart_rack
	name = "咖啡机胶囊架"
	desc = "一个用于存放咖啡机胶囊的小架子。"
	icon = 'icons/obj/food/containers.dmi'
	icon_state = "coffee_cartrack1"
	base_icon_state = "coffee_cartrack"
	contents_tag = "coffee cartridge"
	open_status = FANCY_CONTAINER_ALWAYS_OPEN
	spawn_type = /obj/item/coffee_cartridge
	spawn_count = 1
	storage_type = /datum/storage/coffee_cart_rack

/*
 * impressa coffee maker
 * its supposed to be a premium line product, so its cargo-only, the board cant be therefore researched
 */

/obj/machinery/coffeemaker/impressa
	name = "impressa咖啡机"
	desc = "一款工业级的Impressa Modello 5咖啡机，属于Piccionaia Home Appliances高端咖啡机产品线。使用新鲜干燥的整粒咖啡豆制作咖啡。"
	icon_state = "coffeemaker_impressa"
	circuit = /obj/item/circuitboard/machine/coffeemaker/impressa
	initial_cartridge = null //no cartridge, just coffee beans
	brew_time = 15 SECONDS //industrial grade, its faster than the regular one
	density = TRUE
	pass_flags = PASSTABLE

	cup_type = /obj/item/reagent_containers/cup/glass/coffee
	/// Current amount of coffee beans stored
	var/coffee_amount = 0
	/// List of coffee bean objects are stored
	var/list/coffee = list()

/obj/machinery/coffeemaker/impressa/Initialize(mapload)
	. = ..()
	if(mapload)
		coffeepot = new /obj/item/reagent_containers/cup/coffeepot(src)
		cartridge = null

/obj/machinery/coffeemaker/impressa/Destroy()
	QDEL_NULL(coffeepot)
	QDEL_LIST(coffee)
	return ..()

/obj/machinery/coffeemaker/impressa/examine(mob/user)
	. = ..()
	if(coffee)
		. += span_notice("内部研磨机含有 [length(coffee)] scoop\s 咖啡豆")

/obj/machinery/coffeemaker/impressa/update_overlays()
	. = ..()
	. += overlay_checks()

/obj/machinery/coffeemaker/impressa/overlay_checks()
	. = list()
	if(coffeepot)
		if(istype(coffeepot, /obj/item/reagent_containers/cup/coffeepot/bluespace))
			. += "pot_bluespace"
		else
			. += "pot_[coffeepot.reagents.total_volume ? "full" : "empty"]"
	if(coffee_cups > 0)
		if(coffee_cups >= max_coffee_cups/3)
			if(coffee_cups > max_coffee_cups/1.5)
				. += "cups_3"
			else
				. += "cups_2"
		else
			. += "cups_1"
	if(sugar_packs)
		. += "extras_1"
	if(creamer_packs)
		. += "extras_2"
	if(sweetener_packs)
		. += "extras_3"
	if(coffee_amount)
		if(coffee_amount < 0.7*BEAN_CAPACITY)
			. += "grinder_half"
		else
			. += "grinder_full"
	return .

/obj/machinery/coffeemaker/impressa/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone in coffee)
		coffee -= gone
		update_appearance(UPDATE_OVERLAYS)

/obj/machinery/coffeemaker/impressa/try_brew()
	if(coffee_amount <= 0)
		balloon_alert_to_viewers("no coffee beans added!")
		return FALSE
	if(!coffeepot)
		balloon_alert_to_viewers("no coffeepot inside!")
		return FALSE
	if(machine_stat & (NOPOWER|BROKEN) )
		balloon_alert_to_viewers("machine unpowered!")
		return FALSE
	if(coffeepot.reagents.total_volume >= coffeepot.reagents.maximum_volume)
		balloon_alert_to_viewers("the coffeepot is already full!")
		return FALSE
	return TRUE

/obj/machinery/coffeemaker/impressa/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(panel_open)
		return NONE

	if (istype(tool, /obj/item/food/grown/coffee) && !(tool.item_flags & ABSTRACT))
		if(coffee_amount >= BEAN_CAPACITY)
			balloon_alert(user, "咖啡容器已满！")
			return ITEM_INTERACT_BLOCKING
		if(!HAS_TRAIT(tool, TRAIT_DRIED))
			balloon_alert(user, "咖啡豆必须是干燥的！")
			return ITEM_INTERACT_BLOCKING
		var/obj/item/food/grown/coffee/new_coffee = tool
		if(!user.transferItemToLoc(new_coffee, src))
			return ITEM_INTERACT_BLOCKING
		coffee += new_coffee
		coffee_amount++
		balloon_alert(user, "已添加咖啡")
		update_appearance(UPDATE_OVERLAYS)
		return ITEM_INTERACT_SUCCESS //no afterattack

	if (istype(tool, /obj/item/storage/box/coffeepack) && !(tool.item_flags & ABSTRACT))
		if(coffee_amount >= BEAN_CAPACITY)
			balloon_alert(user, "咖啡容器已满！")
			return ITEM_INTERACT_BLOCKING
		var/obj/item/storage/box/coffeepack/new_coffee_pack = tool
		var/added_any = FALSE
		var/had_nondried = FALSE
		for(var/obj/item/food/grown/coffee/new_coffee in new_coffee_pack.contents)
			if(!HAS_TRAIT(new_coffee, TRAIT_DRIED)) //the coffee beans inside must be dry
				had_nondried = TRUE
				return ITEM_INTERACT_BLOCKING
			if(coffee_amount >= BEAN_CAPACITY)
				break
			if(!user.transferItemToLoc(new_coffee, src))
				break
			coffee += new_coffee
			coffee_amount++
			new_coffee.forceMove(src)
			added_any = TRUE

		if(added_any)
			balloon_alert(user, "已添加咖啡")
			update_appearance(UPDATE_OVERLAYS)
		else if(had_nondried)
			balloon_alert(user, "咖啡包里有未干燥的豆子！")
		else
			balloon_alert(user, "no beans added!")
		return ITEM_INTERACT_SUCCESS //no afterattack

	return ..()

/obj/machinery/coffeemaker/impressa/take_cup(mob/user)
	if(!coffee_cups) //shouldn't happen, but we all know how stuff manages to break
		balloon_alert(user, "没有杯子了！")
		return
	balloon_alert_to_viewers("took cup")
	var/obj/item/reagent_containers/cup/glass/coffee/no_lid/new_cup = new(get_turf(src))
	user.put_in_hands(new_cup)
	coffee_cups--
	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/coffeemaker/impressa/toggle_steam()
	if(!brewing)
		remove_shared_particles("smoke_impressa")
		return

	var/obj/effect/abstract/shared_particle_holder/smoke_particles = add_shared_particles(/particles/smoke/steam/mild, "smoke_impressa")
	smoke_particles.particles.position = list(-2, 1, 0)

/obj/machinery/coffeemaker/impressa/brew()
	power_change()
	if(!try_brew())
		return
	operate_for(brew_time)

	// create a reference bean reagent list
	var/list/reference_bean_reagents = list()
	var/obj/item/food/grown/coffee/reference_bean = new /obj/item/food/grown/coffee(src)
	for(var/datum/reagent/ref_bean_reagent as anything in reference_bean.reagents.reagent_list)
		reference_bean_reagents += ref_bean_reagent.name

	// add all the reagents from the coffee beans to the coffeepot (ommit the ones from the reference bean)
	var/list/reagent_delta = list()
	var/obj/item/food/grown/coffee/bean = coffee[coffee_amount]
	for(var/datum/reagent/substance as anything in bean.reagents.reagent_list)
		if(!(reference_bean_reagents.Find(substance.name)))	// we only add the reagent if it's a non-standard for coffee beans
			reagent_delta += list(substance.type = substance.volume)
	coffeepot.reagents.add_reagent_list(reagent_delta)

	qdel(reference_bean)

	// remove the coffee beans from the machine
	coffee.Cut(1,2)
	coffee_amount--

	// fill the rest of the pot with coffee
	if(coffeepot.reagents.total_volume < 120)
		var/extra_coffee_amount = 120 - coffeepot.reagents.total_volume
		coffeepot.reagents.add_reagent(/datum/reagent/consumable/coffee, extra_coffee_amount)

	update_appearance(UPDATE_OVERLAYS)

#undef BEAN_CAPACITY
