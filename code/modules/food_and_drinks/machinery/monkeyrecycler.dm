// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
GLOBAL_LIST_EMPTY(monkey_recyclers)

/obj/machinery/monkey_recycler
	name = "monkey recycler"
	desc = "A machine used for recycling dead monkeys into monkey cubes."
	icon = 'icons/obj/machines/kitchen.dmi'
	icon_state = "grinder"
	base_icon_state = "grinder"
	layer = BELOW_OBJ_LAYER
	interaction_flags_mouse_drop = NEED_DEXTERITY
	density = TRUE
	circuit = /obj/item/circuitboard/machine/monkey_recycler

	var/stored_matter = 0
	var/cube_production = 0.2

/obj/machinery/monkey_recycler/Initialize(mapload)
	. = ..()
	if (mapload)
		GLOB.monkey_recyclers += src
	add_overlay("grinder_monkey")

/obj/machinery/monkey_recycler/Destroy()
	GLOB.monkey_recyclers -= src
	return ..()

/obj/machinery/monkey_recycler/RefreshParts() //Ranges from 0.2 to 0.8 per monkey recycled
	. = ..()
	cube_production = 0
	for(var/datum/stock_part/servo/servo in component_parts)
		cube_production += servo.tier * 0.2 // NOVA EDIT CHANGE - buffs to allow 1.2 cubes per monkey at T4 - ORIGINAL: cube_production += manipulator.tier * 0.1
	for(var/datum/stock_part/matter_bin/matter_bin in component_parts)
		cube_production += matter_bin.tier * 0.2 // NOVA EDIT CHANGE - buffs to allow 1.2 cubes per monkey at T4 - ORIGINAL: cube_production += matter_bin.tier * 0.1

/obj/machinery/monkey_recycler/examine(mob/user)
	. = ..()
	if(in_range(user, src) || isobserver(user))
		. += span_notice(LANG("obj.4064aaf6554108f2", list(cube_production)))

/obj/machinery/monkey_recycler/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	if(default_unfasten_wrench(user, tool))
		power_change()
	return ITEM_INTERACT_SUCCESS

/obj/machinery/monkey_recycler/screwdriver_act(mob/living/user, obj/item/tool)
	return default_deconstruction_screwdriver(user, tool)

/obj/machinery/monkey_recycler/crowbar_act(mob/living/user, obj/item/tool)
	return default_pry_open(user, tool, close_after_pry = TRUE, deconstruct_on_fail = TRUE)

/obj/machinery/monkey_recycler/update_icon_state()
	. = ..()
	icon_state = panel_open ? "[base_icon_state]_open" : base_icon_state

/obj/machinery/monkey_recycler/mouse_drop_receive(mob/living/target, mob/living/user, params)
	if(!istype(target))
		return
	if(ismonkey(target))
		stuff_monkey_in(target, user)

/obj/machinery/monkey_recycler/proc/stuff_monkey_in(mob/living/carbon/human/target, mob/living/user)
	if(!istype(target))
		return
	if(!IS_UNCONSCIOUS_OR_CRIT(target))
		to_chat(user, span_warning(LANG("obj.c6df76274ba253e1", null)))
		return
	if(target.buckled || target.has_buckled_mobs())
		to_chat(user, span_warning(LANG("obj.16188804e4b622b0", null)))
		return
	qdel(target)
	to_chat(user, span_notice(LANG("obj.ea5bd3b8ebb6f4ba", null)))
	playsound(src.loc, 'sound/machines/juicer.ogg', 50, TRUE)
	var/offset = prob(50) ? -2 : 2
	animate(src, pixel_x = pixel_x + offset, time = 0.2, loop = 200) //start shaking
	use_energy(active_power_usage)
	stored_matter += cube_production
	addtimer(VARSET_CALLBACK(src, pixel_x, base_pixel_x))
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), user, span_notice("The machine now has [stored_matter] monkey\s worth of material stored.")))

/obj/machinery/monkey_recycler/interact(mob/user)
	if(stored_matter >= 1)
		to_chat(user, span_notice(LANG("obj.a4338b3cc1d9e365", null)))
		playsound(src.loc, 'sound/machines/hiss.ogg', 50, TRUE)
		for(var/i in 1 to floor(stored_matter))
			new /obj/item/food/monkeycube(src.loc)
			stored_matter--
		to_chat(user, span_notice(LANG("obj.dfe2ad418177eed6", list(stored_matter))))
	else
		to_chat(user, span_danger(LANG("obj.ccb51ad41c7f24d0", list(stored_matter))))

/obj/machinery/monkey_recycler/multitool_act(mob/living/user, obj/item/multitool/I)
	. = ..()
	if(istype(I))
		I.set_buffer(src)
		balloon_alert(user, LANG("obj.84afb909aab2db8b", null))
		return TRUE
