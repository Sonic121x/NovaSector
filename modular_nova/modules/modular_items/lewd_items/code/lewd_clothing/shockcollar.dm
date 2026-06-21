/obj/item/electropack/shockcollar
	name = "电击项圈"
	desc = "一个加固的金属项圈。正面附近有某种线路。"
	icon = 'modular_nova/modules/modular_items/lewd_items/icons/obj/lewd_clothing/lewd_neck.dmi'
	worn_icon = 'modular_nova/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_neck.dmi'
	icon_state = "shockcollar"
	inhand_icon_state = null
	body_parts_covered = NECK
	slot_flags = ITEM_SLOT_NECK
	obj_flags_nova = ERP_ITEM
	w_class = WEIGHT_CLASS_SMALL
	strip_delay = 60
	obj_flags = parent_type::obj_flags | UNIQUE_RENAME
	// equip_delay_other = 60
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT,
	)
	var/random = TRUE
	var/freq_in_name = TRUE

/datum/design/electropack/shockcollar
	name = "电击项圈"
	id = "shockcollar"
	build_type = AUTOLATHE
	build_path = /obj/item/electropack/shockcollar
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT,
	)
	category = list(
		RND_CATEGORY_HACKED,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MISC,
	)

/obj/item/electropack/shockcollar/can_mob_unequip(mob/user)
	if(user.get_item_by_slot(slot_flags) == src)
		to_chat(user, span_warning("项圈扣得很紧！如果你想取下来，需要别人帮忙！"))
		return FALSE
	return ..()

/obj/item/electropack/shockcollar/receive_signal(datum/signal/signal)
	if(!signal || signal.data["code"] != code)
		return

	if(isliving(loc) && on) //the "on" arg is currently useless
		var/mob/living/carbon/human/affected_mob = loc
		if(!affected_mob.get_item_by_slot(ITEM_SLOT_NECK)) //**properly** stops pocket shockers
			return
		if(shock_cooldown == TRUE)
			return
		shock_cooldown = TRUE
		addtimer(VARSET_CALLBACK(src, shock_cooldown, FALSE), 100)
		step(affected_mob, pick(GLOB.cardinals))

		to_chat(affected_mob, span_danger("你感到项圈传来一阵剧烈的电击！"))
		do_sparks(3, TRUE, affected_mob)

		affected_mob.Paralyze(30)
		affected_mob.adjust_pain(10)
		affected_mob.adjust_stutter(30 SECONDS)

	if(master)
		if(isassembly(master))
			var/obj/item/assembly/master_as_assembly = master
			master_as_assembly.pulsed()
		master.receive_signal()
	return

/obj/item/electropack/shockcollar/Initialize(mapload)
	if(random)
		code = rand(1, 100)
		frequency = rand(MIN_FREE_FREQ, MAX_FREE_FREQ)
		if(ISMULTIPLE(frequency, 2)) // Signaller frequencies are always uneven!
			frequency++
	if(freq_in_name)
		name = initial(name) + "- 频率: [frequency/10] 代码: [code]"
	return ..()

/obj/item/electropack/shockcollar/ui_act(action, params)
	. = ..()
	icon_state = src::icon_state

/obj/item/electropack/shockcollar/pacify
	name = "安抚项圈"
	desc = "一个加固的金属项圈，会扣在佩戴者身上并阻止有害的想法。"

/obj/item/electropack/shockcollar/pacify/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot & ITEM_SLOT_NECK)
		ADD_TRAIT(user, TRAIT_PACIFISM, "pacifying-collar")

/obj/item/electropack/shockcollar/pacify/dropped(mob/living/carbon/human/user)
	. = ..()
	REMOVE_TRAIT(user, TRAIT_PACIFISM, "pacifying-collar")
