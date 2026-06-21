/obj/item/reagent_containers/crack
	name = "快克"
	desc = "一块游离碱可卡因，也被称为快克。"
	icon = 'modular_nova/modules/morenarcotics/icons/crack.dmi'
	icon_state = "crack"
	volume = 10
	has_variable_transfer_amount = FALSE
	list_reagents = list(/datum/reagent/drug/cocaine/freebase_cocaine = 10)

/obj/item/reagent_containers/crackbrick
	name = "快克砖"
	desc = "一块快克可卡因砖。"
	icon = 'modular_nova/modules/morenarcotics/icons/crack.dmi'
	icon_state = "crackbrick"
	volume = 40
	has_variable_transfer_amount = FALSE
	list_reagents = list(/datum/reagent/drug/cocaine/freebase_cocaine = 40)

/obj/item/reagent_containers/crackbrick/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	if(attacking_item.get_sharpness())
		user.show_message(span_notice("你将 \the [src] 切成了几块石头。"), MSG_VISUAL)
		for(var/i = 1 to 4)
			new /obj/item/reagent_containers/crack(user.loc)
		qdel(src)

/datum/crafting_recipe/crackbrick
	name = "快克砖"
	result = /obj/item/reagent_containers/crackbrick
	reqs = list(/obj/item/reagent_containers/crack = 4)
	parts = list(/obj/item/reagent_containers/crack = 4)
	time = 20
	category = CAT_CHEMISTRY //i might just make a crafting category for drugs at some point

// Should probably give this the edible component at some point
/obj/item/reagent_containers/cocaine
	name = "可卡因"
	desc = "重现你最喜欢的《疤面煞星》场景！"
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
		to_chat(user, span_warning("你得先取下你的[covered]！"))
	var/obj/item/organ/lungs/lungs = user.get_organ_slot(ORGAN_SLOT_LUNGS)
	if(isnull(lungs) || istype(lungs, /obj/item/organ/lungs/synth))
		to_chat(user, span_warning("你必须能呼吸才能吸食可卡因！"))
		return
	user.visible_message(span_notice("[user]开始吸食[src]。"))
	if(do_after(user, 30))
		to_chat(user, span_notice("你吸食完了[src]。"))
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
	name = "可卡因砖"
	desc = "一块可卡因砖。便于运输！"
	icon = 'modular_nova/modules/morenarcotics/icons/crack.dmi'
	icon_state = "cocainebrick"
	volume = 25
	has_variable_transfer_amount = FALSE
	list_reagents = list(/datum/reagent/drug/cocaine = 25)


/obj/item/reagent_containers/cocainebrick/attack_self(mob/user)
	user.visible_message(span_notice("[user]开始弄碎[src]。"))
	if(do_after(user,10))
		to_chat(user, span_notice("你弄碎了[src]。"))
		for(var/i = 1 to 5)
			new /obj/item/reagent_containers/cocaine(user.loc)
		qdel(src)

/datum/crafting_recipe/cocainebrick
	name = "可卡因砖"
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
