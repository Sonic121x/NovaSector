/obj/item/reagent_containers/crack
	name = "crack"
	desc = "A rock of freebase cocaine, otherwise known as crack."
	icon = 'modular_nova/modules/morenarcotics/icons/crack.dmi'
	icon_state = "crack"
	volume = 10
	has_variable_transfer_amount = FALSE
	list_reagents = list(/datum/reagent/drug/cocaine/freebase_cocaine = 10)

/obj/item/reagent_containers/crackbrick
	name = "crack brick"
	desc = "A brick of crack cocaine."
	icon = 'modular_nova/modules/morenarcotics/icons/crack.dmi'
	icon_state = "crackbrick"
	volume = 40
	has_variable_transfer_amount = FALSE
	list_reagents = list(/datum/reagent/drug/cocaine/freebase_cocaine = 40)

/obj/item/reagent_containers/crackbrick/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(tool.get_sharpness())
		user.show_message(span_notice("You cut \the [src] into some rocks."), MSG_VISUAL)
		for(var/i = 1 to 4)
			new /obj/item/reagent_containers/crack(user.loc)
		qdel(src)
		return ITEM_INTERACT_SUCCESS
	return ITEM_INTERACT_BLOCKING

/datum/crafting_recipe/crackbrick
	name = "Crack brick"
	result = /obj/item/reagent_containers/crackbrick
	reqs = list(/obj/item/reagent_containers/crack = 4)
	parts = list(/obj/item/reagent_containers/crack = 4)
	time = 20
	category = CAT_CHEMISTRY //i might just make a crafting category for drugs at some point

// Should probably give this the edible component at some point
/obj/item/reagent_containers/cocaine
	name = "cocaine"
	desc = "Reenact your favorite scenes from Scarface!"
	icon = 'modular_nova/modules/morenarcotics/icons/crack.dmi'
	icon_state = "cocaine"
	volume = 5
	has_variable_transfer_amount = FALSE
	list_reagents = list(/datum/reagent/drug/cocaine = 5)

/obj/item/reagent_containers/cocaine/proc/snort(mob/living/user)
	if(!iscarbon(user))
		return
	var/covered = ""
	if(user.is_mouth_covered(ITEM_SLOT_HEAD))
		covered = "headgear"
	else if(user.is_mouth_covered(ITEM_SLOT_MASK))
		covered = "mask"
	if(covered)
		// NOVA EDIT CHANGE START - i18n: 拆成两条整句模板。原写法把 "headgear"/"mask" 当 LANG 实参，
		// 而它们是**单 token 局部量** —— LANG 实参的多词闸门按设计不收（单 token 实参里 act/黑板键
		// 浓度极高），于是模板译好了、槽里漏出英文（玩家看到「你必须先取下你的headgear！」）。
		// 整条走模板既绕开那道闸门，也让中文语序自己排。所有格代词经 lang_pronoun 走语法表。
		// ORIGINAL: to_chat(user, span_warning(LANG("obj.9f5fad6f715a086d", list(covered))))
		if(covered == "headgear")
			to_chat(user, span_warning(LANG("obj.892b7338f1a82533", list(lang_pronoun("your")))))
		else
			to_chat(user, span_warning(LANG("obj.725be70e424818d6", list(lang_pronoun("your")))))
		// NOVA EDIT CHANGE END
	var/obj/item/organ/lungs/lungs = user.get_organ_slot(ORGAN_SLOT_LUNGS)
	if(isnull(lungs) || istype(lungs, /obj/item/organ/lungs/synth))
		to_chat(user, span_warning(LANG("obj.ffe7fde35ddce20d", null)))
		return
	user.visible_message(span_notice(LANG("obj.3a5b305fa6690ee4", list(user, src))))
	if(do_after(user, 30))
		to_chat(user, span_notice(LANG("obj.88742f4661dfff78", list(src))))
		if(reagents.total_volume)
			reagents.trans_to(user, reagents.total_volume, transferred_by = user, methods = INGEST)
		qdel(src)

/obj/item/reagent_containers/cocaine/attack_self(mob/user)
		snort(user)

/obj/item/reagent_containers/cocaine/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return

	. = SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	if(!in_range(user, src) || user.get_active_held_item())
		return

	snort(user)

	return

/obj/item/reagent_containers/cocainebrick
	name = "cocaine brick"
	desc = "A brick of cocaine. Good for transport!"
	icon = 'modular_nova/modules/morenarcotics/icons/crack.dmi'
	icon_state = "cocainebrick"
	volume = 25
	has_variable_transfer_amount = FALSE
	list_reagents = list(/datum/reagent/drug/cocaine = 25)


/obj/item/reagent_containers/cocainebrick/attack_self(mob/user)
	user.visible_message(span_notice(LANG("obj.2c94b9cac2485db3", list(user, src))))
	if(do_after(user,10))
		to_chat(user, span_notice(LANG("obj.eb1bbccb3849e180", list(src))))
		for(var/i = 1 to 5)
			new /obj/item/reagent_containers/cocaine(user.loc)
		qdel(src)

/datum/crafting_recipe/cocainebrick
	name = "Cocaine brick"
	result = /obj/item/reagent_containers/cocainebrick
	reqs = list(/obj/item/reagent_containers/cocaine = 5)
	parts = list(/obj/item/reagent_containers/cocaine = 5)
	time = 20
	category = CAT_CHEMISTRY //i might just make a crafting category for drugs at some point

//if you want money, convert it into crackbricks
/datum/export/crack
	cost = CARGO_CRATE_VALUE * 0.5
	unit_name = "crack"
	export_types = list(/obj/item/reagent_containers/crack)
	include_subtypes = FALSE

/datum/export/crack/crackbrick
	cost = CARGO_CRATE_VALUE * 2.5
	unit_name = "crack brick"
	export_types = list(/obj/item/reagent_containers/crackbrick)
	include_subtypes = FALSE

/datum/export/cocaine
	cost = CARGO_CRATE_VALUE * 0.4
	unit_name = "cocaine"
	export_types = list(/obj/item/reagent_containers/cocaine)
	include_subtypes = FALSE

/datum/export/cocainebrick
	cost = CARGO_CRATE_VALUE * 2
	unit_name = "cocaine brick"
	export_types = list(/obj/item/reagent_containers/cocainebrick)
	include_subtypes = FALSE
