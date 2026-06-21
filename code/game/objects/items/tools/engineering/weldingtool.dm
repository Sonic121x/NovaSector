/obj/item/weldingtool
	name = "焊接工具"
	desc = "由纳星公司提供的标准版焊枪。"
	icon = 'icons/obj/tools.dmi'
	icon_state = "welder"
	inhand_icon_state = "welder"
	worn_icon_state = "welder"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	obj_flags = CONDUCTS_ELECTRICITY
	slot_flags = ITEM_SLOT_BELT
	force = 3
	throwforce = 5
	hitsound = SFX_SWING_HIT
	usesound = list('sound/items/tools/welder.ogg', 'sound/items/tools/welder2.ogg')
	drop_sound = 'sound/items/handling/tools/weldingtool_drop.ogg'
	pickup_sound = 'sound/items/handling/tools/weldingtool_pickup.ogg'
	light_system = OVERLAY_LIGHT
	light_range = 2
	light_power = 1.5
	light_color = LIGHT_COLOR_FIRE
	light_on = FALSE
	throw_speed = 3
	throw_range = 5
	w_class = WEIGHT_CLASS_SMALL
	armor_type = /datum/armor/item_weldingtool
	resistance_flags = FIRE_PROOF
	heat = 3800
	tool_behaviour = TOOL_WELDER
	toolspeed = 1
	wound_bonus = 10
	exposed_wound_bonus = 15
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*0.7, /datum/material/glass=SMALL_MATERIAL_AMOUNT*0.3)
	/// Whether the welding tool is on or off.
	var/welding = FALSE
	/// Whether the welder is secured or unsecured (able to attach rods to it to make a flamethrower)
	var/status = TRUE
	/// The max amount of fuel the welder can hold
	var/max_fuel = 20
	/// Does the welder start with fuel.
	var/starting_fuel = TRUE
	/// Whether or not we're changing the icon based on fuel left.
	var/change_icons = TRUE
	/// Used in process(), dictates whether or not we're calling STOP_PROCESSING whilst we're not welding.
	var/can_off_process = FALSE
	/// When fuel was last removed.
	var/burned_fuel_for = 0

	var/activation_sound = 'sound/items/tools/welderactivate.ogg'
	var/deactivation_sound = 'sound/items/tools/welderdeactivate.ogg'
	/// Lighting middleman, lets us do a flicker effect
	var/datum/light_middleman/middleman

/datum/armor/item_weldingtool
	fire = 100
	acid = 30

/obj/item/weldingtool/Initialize(mapload)
	. = ..()
	if(IS_OVERLAY_LIGHT_SYSTEM(light_system))
		middleman = new(src, "flashlight")
		RegisterSignal(middleman, COMSIG_LIGHT_MIDDLEMAN_UPDATED, PROC_REF(light_updated))
		middleman.being_overriding_light()
	AddElement(/datum/element/update_icon_updates_onmob)
	AddElement(/datum/element/tool_flash, light_range)
	AddElement(/datum/element/falling_hazard, damage = force, wound_bonus = wound_bonus, hardhat_safety = TRUE, crushes = FALSE, impact_sound = hitsound)

	create_reagents(max_fuel)
	if(starting_fuel)
		reagents.add_reagent(/datum/reagent/fuel, max_fuel)
	update_appearance()

/obj/item/weldingtool/Destroy(force)
	QDEL_NULL(middleman)
	return ..()

/obj/item/weldingtool/update_icon_state()
	if(welding)
		inhand_icon_state = "[initial(inhand_icon_state)]1"
	else
		inhand_icon_state = "[initial(inhand_icon_state)]"
	return ..()


/obj/item/weldingtool/update_overlays()
	. = ..()
	if(change_icons)
		var/ratio = get_fuel() / max_fuel
		ratio = ceil(ratio*4) * 25
		. += "[initial(icon_state)][ratio]"
	if(welding)
		. += "[initial(icon_state)]-on"


/obj/item/weldingtool/process(seconds_per_tick)
	if(welding)
		force = 15
		damtype = BURN
		burned_fuel_for += seconds_per_tick
		if(burned_fuel_for >= TOOL_FUEL_BURN_INTERVAL)
			use(TRUE)
		update_appearance()

	//Welders left on now use up fuel, but lets not have them run out quite that fast
	else
		force = 3
		damtype = BRUTE
		update_appearance()
		if(!can_off_process)
			STOP_PROCESSING(SSobj, src)
		return

	//This is to start fires. process() is only called if the welder is on.
	open_flame()


/obj/item/weldingtool/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] 用焊枪把 [user.p_their()] 身上每个孔洞都焊死了！看起来 [user.p_theyre()] 想自杀！"))
	return FIRELOSS

/obj/item/weldingtool/screwdriver_act(mob/living/user, obj/item/tool)
	flamethrower_screwdriver(tool, user)
	return ITEM_INTERACT_SUCCESS

/obj/item/weldingtool/attackby(obj/item/tool, mob/user, list/modifiers, list/attack_modifiers)
	if(istype(tool, /obj/item/stack/rods))
		flamethrower_rods(tool, user)
	else
		. = ..()
	update_appearance()

/obj/item/weldingtool/cyborg_unequip(mob/user)
	if(!isOn())
		return
	switched_on(user)

/obj/item/weldingtool/use_tool(atom/target, mob/living/user, delay, amount, volume, datum/callback/extra_checks)
	var/mutable_appearance/sparks = mutable_appearance('icons/effects/welding_effect.dmi', "welding_sparks", GASFIRE_LAYER, src, ABOVE_LIGHTING_PLANE)
	target.add_overlay(sparks)
	LAZYADD(target.update_overlays_on_z, sparks)
	. = ..()
	LAZYREMOVE(target.update_overlays_on_z, sparks)
	target.cut_overlay(sparks)

/obj/item/weldingtool/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!status && interacting_with.is_refillable())
		reagents.trans_to(interacting_with, reagents.total_volume, transferred_by = user)
		to_chat(user, span_notice("你将 [src] 的燃料罐清空，倒入 [interacting_with]。"))
		update_appearance()
		return ITEM_INTERACT_SUCCESS
	if(!ishuman(interacting_with))
		return NONE
	if(user.combat_mode)
		return NONE

	return try_heal_loop(interacting_with, user)

/obj/item/weldingtool/proc/light_updated(datum/source)
	SIGNAL_HANDLER
	fire_flicker_middleman(middleman)

/obj/item/weldingtool/proc/try_heal_loop(atom/interacting_with, mob/living/user, repeating = FALSE)
	var/mob/living/carbon/human/attacked_humanoid = interacting_with
	var/obj/item/bodypart/affecting = attacked_humanoid.get_bodypart(check_zone(user.zone_selected))
	if(isnull(affecting) || !IS_ROBOTIC_LIMB(affecting))
		return NONE

	if (!affecting.brute_dam)
		balloon_alert(user, "肢体未受损")
		return ITEM_INTERACT_BLOCKING

	user.visible_message(span_notice("[user] 开始修复 [attacked_humanoid == user ? user.p_their() : "[attacked_humanoid]'s"] [affecting.name] 上的一些凹痕。"),
		span_notice("你开始修复 [attacked_humanoid == user ? "your" : "[attacked_humanoid]'s"] [affecting.name] 上的一些凹痕。"))
	var/use_delay = repeating ? 1 SECONDS : 0
	if(user == attacked_humanoid)
		use_delay = self_delay // NOVA EDIT CHANGE - ORIGINAL: use_delay = 5 SECONDS
	// NOVA EDIT ADDITION START
	else
		use_delay = other_delay
	// NOVA EDIT ADDITION END

	if(!use_tool(attacked_humanoid, user, use_delay, volume=50, amount=1))
		return ITEM_INTERACT_BLOCKING

	if (!attacked_humanoid.item_heal(user, brute_heal = 15, burn_heal = 0, heal_message_brute = "dents", heal_message_burn = "burnt wires", required_bodytype = BODYTYPE_ROBOTIC))
		return ITEM_INTERACT_BLOCKING

	INVOKE_ASYNC(src, PROC_REF(try_heal_loop), interacting_with, user, TRUE)
	return ITEM_INTERACT_SUCCESS

/obj/item/weldingtool/afterattack(atom/target, mob/user, list/modifiers, list/attack_modifiers)
	if(!isOn())
		return
	use(1)
	var/turf/location = get_turf(user)
	location.hotspot_expose(700, 50, 1)
	if(QDELETED(target) || !isliving(target)) // can't ignite something that doesn't exist
		return
	var/mob/living/attacked_mob = target
	if(attacked_mob.ignite_mob())
		message_admins("[ADMIN_LOOKUPFLW(user)] set [key_name_admin(attacked_mob)] on fire with [src] at [AREACOORD(user)]")
		user.log_message("set [key_name(attacked_mob)] on fire with [src].", LOG_ATTACK)

/obj/item/weldingtool/attack_self(mob/user)
	if(reagents.spark_act(0, SPARK_ACT_ENCLOSED, banned_reagents = /datum/reagent/fuel) & SPARK_ACT_DESTRUCTIVE)
		message_admins("[ADMIN_LOOKUPFLW(user)] activated a rigged welder at [AREACOORD(user)].")
		user.log_message("activated a rigged welder", LOG_VICTIM)
		qdel(src)
		return

	switched_on(user)
	update_appearance()

/// Returns the amount of fuel in the welder
/obj/item/weldingtool/proc/get_fuel()
	return reagents.get_reagent_amount(/datum/reagent/fuel) + reagents.get_reagent_amount(/datum/reagent/toxin/plasma)

/// Uses fuel from the welding tool.
/obj/item/weldingtool/use(used = 0)
	if(!isOn() || !check_fuel())
		return FALSE

	if(used > 0)
		burned_fuel_for = 0

	if(get_fuel() >= used)
		reagents.remove_reagent(/datum/reagent/fuel, used)
		check_fuel()
		return TRUE
	else
		return FALSE


/// Toggles the welding value.
/obj/item/weldingtool/proc/set_welding(new_value)
	if(welding == new_value)
		return
	. = welding
	welding = new_value
	set_light_on(welding)


/// Turns off the welder if there is no more fuel (does this really need to be its own proc?)
/obj/item/weldingtool/proc/check_fuel(mob/user)
	if(get_fuel() <= 0 && welding)
		set_light_on(FALSE)
		switched_on(user)
		update_appearance()
		return FALSE
	return TRUE

// /Switches the welder on
/obj/item/weldingtool/proc/switched_on(mob/user)
	if(!status)
		balloon_alert(user, "未固定！")
		return
	set_welding(!welding)
	if(welding)
		if(get_fuel() >= 1)
			playsound(loc, activation_sound, 50, TRUE)
			force = 15
			damtype = BURN
			hitsound = 'sound/items/tools/welder.ogg'
			update_appearance()
			START_PROCESSING(SSobj, src)
		else
			balloon_alert(user, "没有燃料！")
			switched_off()
	else
		playsound(loc, deactivation_sound, 50, TRUE)
		switched_off()

/// Switches the welder off
/obj/item/weldingtool/proc/switched_off()
	set_welding(FALSE)

	force = 3
	damtype = BRUTE
	hitsound = SFX_SWING_HIT
	update_appearance()


/obj/item/weldingtool/examine(mob/user)
	. = ..()
	. += "It contains [get_fuel()] unit\s of fuel out of [max_fuel]."

/obj/item/weldingtool/get_temperature()
	return welding * heat

/// Returns whether or not the welding tool is currently on.
/obj/item/weldingtool/proc/isOn()
	return welding

/// If welding tool ran out of fuel during a construction task, construction fails.
/obj/item/weldingtool/tool_use_check(mob/living/user, amount, heat_required)
	if(!isOn() || !check_fuel())
		to_chat(user, span_warning("[src] 必须开启才能完成此任务！"))
		return FALSE
	if(get_fuel() < amount)
		to_chat(user, span_warning("你需要更多焊接燃料来完成此任务！"))
		return FALSE
	if(heat < heat_required)
		to_chat(user, span_warning("[src] 温度不够高，无法完成此任务！"))
		return FALSE
	return TRUE

/// Ran when the welder is attacked by a screwdriver.
/obj/item/weldingtool/proc/flamethrower_screwdriver(obj/item/tool, mob/user)
	if(welding)
		to_chat(user, span_warning("先把它关掉！"))
		return
	status = !status
	if(status)
		to_chat(user, span_notice("你重新固定了 [src] 并关闭了燃料罐。"))
		reagents.flags &= ~(OPENCONTAINER)
	else
		to_chat(user, span_notice("[src] 现在可以被安装、改装和补充燃料了。"))
		reagents.flags |= OPENCONTAINER
	add_fingerprint(user)

/// First step of building a flamethrower (when a welder is attacked by rods)
/obj/item/weldingtool/proc/flamethrower_rods(obj/item/tool, mob/user)
	if(!status)
		var/obj/item/stack/rods/used_rods = tool
		if (used_rods.use(1))
			var/obj/item/flamethrower/flamethrower_frame = new /obj/item/flamethrower(user.loc)
			if(!remove_item_from_storage(flamethrower_frame, user))
				user.transferItemToLoc(src, flamethrower_frame, TRUE)
			flamethrower_frame.weldtool = src
			add_fingerprint(user)
			to_chat(user, span_notice("你将一根金属棒添加到焊枪上，开始制造喷火器。"))
			user.put_in_hands(flamethrower_frame)
		else
			to_chat(user, span_warning("你需要一根金属棒来开始制造喷火器！"))

/obj/item/weldingtool/ignition_effect(atom/ignitable_atom, mob/user)
	if(use_tool(ignitable_atom, user, 0))
		return span_rose("[user] 随意地用 [src] 点燃了 [ignitable_atom]，真是个狠角色。")
	else
		return ""

/obj/item/weldingtool/empty
	starting_fuel = FALSE

/obj/item/weldingtool/largetank
	name = "工业焊接工具"
	desc = "一个储罐稍大的焊枪。"
	icon_state = "indwelder"
	inhand_icon_state = "indwelder"
	max_fuel = 40
	custom_materials = list(/datum/material/glass=SMALL_MATERIAL_AMOUNT*0.6)

/obj/item/weldingtool/largetank/flamethrower_screwdriver()
	return

/obj/item/weldingtool/largetank/empty
	starting_fuel = FALSE

/obj/item/weldingtool/largetank/cyborg
	name = "集成式焊枪"
	desc = "一种专为机器人系统设计的高级焊枪。定制框架使焊接速度加倍。"
	icon = 'icons/obj/items_cyborg.dmi'
	icon_state = "indwelder_cyborg"
	toolspeed = 0.5

/obj/item/weldingtool/mini
	name = "应急焊枪"
	desc = "一种用于紧急情况的微型焊枪。"
	icon_state = "miniwelder"
	inhand_icon_state = "miniwelder"
	max_fuel = 10
	w_class = WEIGHT_CLASS_TINY
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*0.3, /datum/material/glass=SMALL_MATERIAL_AMOUNT*0.1)
	change_icons = FALSE

/obj/item/weldingtool/mini/flamethrower_screwdriver()
	return

/obj/item/weldingtool/mini/empty
	starting_fuel = FALSE

/obj/item/weldingtool/abductor
	name = "外星焊枪"
	desc = "一种外星焊枪。无论使用何种燃料，它都永不耗尽。"
	icon = 'icons/obj/antags/abductor.dmi'
	icon_state = "welder"
	inhand_icon_state = "abductorwelder"
	toolspeed = 0.1
	custom_materials = list(/datum/material/iron =SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/silver = SHEET_MATERIAL_AMOUNT*1.25, /datum/material/plasma =SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/titanium =SHEET_MATERIAL_AMOUNT, /datum/material/diamond =SHEET_MATERIAL_AMOUNT)
	light_system = NO_LIGHT_SUPPORT
	light_range = 0
	change_icons = FALSE

/obj/item/weldingtool/abductor/process()
	if(get_fuel() <= max_fuel)
		reagents.add_reagent(/datum/reagent/fuel, 1)
	..()

/obj/item/weldingtool/hugetank
	name = "升级版工业焊枪"
	desc = "基于工业焊枪升级而来的焊枪。"
	icon_state = "upindwelder"
	inhand_icon_state = "upindwelder"
	max_fuel = 80
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*0.7, /datum/material/glass=SMALL_MATERIAL_AMOUNT*1.2)

/obj/item/weldingtool/experimental
	name = "实验性焊枪"
	desc = "一种能够自生燃料且对眼睛伤害较小的实验性焊枪。"
	icon_state = "exwelder"
	inhand_icon_state = "exwelder"
	max_fuel = 40
	custom_materials = list(/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT, /datum/material/glass = SMALL_MATERIAL_AMOUNT*5, /datum/material/plasma =HALF_SHEET_MATERIAL_AMOUNT*1.5, /datum/material/uranium =SMALL_MATERIAL_AMOUNT * 2)
	change_icons = FALSE
	can_off_process = TRUE
	light_range = 1
	w_class = WEIGHT_CLASS_NORMAL
	toolspeed = 0.5
	var/last_gen = 0
	var/nextrefueltick = 0

/obj/item/weldingtool/experimental/process()
	..()
	if(get_fuel() < max_fuel && nextrefueltick < world.time)
		nextrefueltick = world.time + 10
		reagents.add_reagent(/datum/reagent/fuel, 1)
