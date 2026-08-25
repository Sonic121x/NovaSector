// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
// Gel skins
/datum/atom_skin/med_gel
	abstract_type = /datum/atom_skin/med_gel

/datum/atom_skin/med_gel/blue
	preview_name = "Blue"
	new_icon_state = "medigel_blue"

/datum/atom_skin/med_gel/cyan
	preview_name = "Cyan"
	new_icon_state = "medigel_cyan"

/datum/atom_skin/med_gel/green
	preview_name = "Green"
	new_icon_state = "medigel_green"

/datum/atom_skin/med_gel/red
	preview_name = "Red"
	new_icon_state = "medigel_red"

/datum/atom_skin/med_gel/orange
	preview_name = "Orange"
	new_icon_state = "medigel_orange"

/datum/atom_skin/med_gel/purple
	preview_name = "Purple"
	new_icon_state = "medigel_purple"

/obj/item/reagent_containers/medigel
	name = "medical gel"
	desc = "A medical gel applicator bottle, designed for precision application, with an unscrewable cap."
	icon = 'icons/obj/medical/chemical.dmi'
	icon_state = "medigel"
	inhand_icon_state = "spraycan"
	worn_icon_state = "spraycan"
	lefthand_file = 'icons/mob/inhands/equipment/hydroponics_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/hydroponics_righthand.dmi'
	item_flags = NOBLUDGEON
	obj_flags = UNIQUE_RENAME
	initial_reagent_flags = OPENCONTAINER | NO_SPLASH
	slot_flags = ITEM_SLOT_BELT
	throwforce = 0
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 3
	throw_range = 7
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10)
	volume = 60
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 1.25, /datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT)
	var/can_fill_from_container = TRUE
	var/apply_type = PATCH
	var/apply_method = "spray" //the thick gel is sprayed and then dries into patch like film.
	var/self_delay = 30
	custom_price = PAYCHECK_CREW * 2

/obj/item/reagent_containers/medigel/setup_reskins()
	if(icon_state == "medigel") // oh yeah baby raw icon state check to make sure we can't reskin preset gels
		AddComponent(/datum/component/reskinable_item, /datum/atom_skin/med_gel)

/obj/item/reagent_containers/medigel/mode_change_message(mob/user)
	var/squirt_mode = amount_per_transfer_from_this == initial(amount_per_transfer_from_this)
	to_chat(user, span_notice(LANG("obj.21b323621dbd101b", list(squirt_mode ? "extended sprays":"short bursts", amount_per_transfer_from_this))))

/obj/item/reagent_containers/medigel/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!isliving(interacting_with))
		return NONE
	if(!reagents || !reagents.total_volume)
		to_chat(user, span_warning(LANG("obj.02d482cc1aef0cef", list(src))))
		return ITEM_INTERACT_BLOCKING

	user.changeNext_move(CLICK_CD_MELEE)
	if(interacting_with == user)
		interacting_with.visible_message(span_notice(LANG("obj.b97b1831153d4291", list(user, apply_method, src, user.p_them()))))
		if(self_delay)
			if(!do_after(user, self_delay, interacting_with))
				return ITEM_INTERACT_BLOCKING
			if(!reagents || !reagents.total_volume)
				return ITEM_INTERACT_BLOCKING
		to_chat(interacting_with, span_notice(LANG("obj.7d788d27df68ee87", list(apply_method, src))))

	else
		log_combat(user, interacting_with, "attempted to apply", src, reagents.get_reagent_log_string())
		interacting_with.visible_message(
			span_danger(LANG("obj.af7ed728020b22cc", list(user, apply_method, src, interacting_with))),
			span_userdanger(LANG("obj.55908223edf36040", list(user, apply_method, src))),
		)
		if(!do_after(user, CHEM_INTERACT_DELAY(3 SECONDS, user), interacting_with))
			return ITEM_INTERACT_BLOCKING
		if(!reagents || !reagents.total_volume)
			return ITEM_INTERACT_BLOCKING
		interacting_with.visible_message(
			span_danger(LANG("obj.9b4d2f273bfbd8aa", list(user, apply_method, interacting_with, src))),
			span_userdanger(LANG("obj.8f8cad87c137cd79", list(user, apply_method, src))),
		)

	log_combat(user, interacting_with, "applied", src, reagents.get_reagent_log_string())
	playsound(src, 'sound/effects/spray.ogg', 30, TRUE, -6)
	reagents.trans_to(interacting_with, amount_per_transfer_from_this, transferred_by = user, methods = apply_type)
	return ITEM_INTERACT_SUCCESS

/obj/item/reagent_containers/medigel/libital
	name = "medical gel (libital)"
	desc = "A medical gel applicator bottle, designed for precision application, with an unscrewable cap. This one contains libital, for treating cuts and bruises. Libital does minor liver damage. Diluted with granibitaluri."
	icon_state = "brutegel"
	list_reagents = list(/datum/reagent/medicine/c2/libital = 24, /datum/reagent/medicine/granibitaluri = 36)

/obj/item/reagent_containers/medigel/aiuri
	name = "medical gel (aiuri)"
	desc = "A medical gel applicator bottle, designed for precision application, with an unscrewable cap. This one contains aiuri, useful for treating burns. Aiuri does minor eye damage. Diluted with granibitaluri."
	icon_state = "burngel"
	list_reagents = list(/datum/reagent/medicine/c2/aiuri = 24, /datum/reagent/medicine/granibitaluri = 36)

/obj/item/reagent_containers/medigel/synthflesh
	name = "medical gel (synthflesh)"
	desc = "A medical gel applicator bottle, designed for precision application, with an unscrewable cap. This one contains synthflesh, a slightly toxic medicine capable of healing bruises, burns, and husks."
	icon_state = "synthgel"
	list_reagents = list(/datum/reagent/medicine/c2/synthflesh = 60)
	list_reagents_purity = 1
	amount_per_transfer_from_this = 60
	possible_transfer_amounts = list(5, 10, 60)
	custom_price = PAYCHECK_CREW * 5

/obj/item/reagent_containers/medigel/synthflesh/examine(mob/user)
	. = ..()
	if(reagents.total_volume >= 60)
		. += span_info(LANG("obj.1bd2a6d8f1e974be", null))

/obj/item/reagent_containers/medigel/synthflesh/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(iscarbon(interacting_with) && reagents?.total_volume)
		var/mob/living/carbon/carbies = interacting_with
		if(HAS_TRAIT_FROM(carbies, TRAIT_HUSK, BURN) && carbies.get_fire_loss() > UNHUSK_DAMAGE_THRESHOLD * 2.5)
			// give them a warning if the mob is a husk but synthflesh won't unhusk yet
			carbies.visible_message(span_boldwarning(LANG("obj.b7d1172b4fc87af9", list(carbies))))

	return ..()

/obj/item/reagent_containers/medigel/sterilizine
	name = "sterilizer gel"
	desc = "gel bottle loaded with non-toxic sterilizer. Useful in preparation for surgery."
	icon_state = "medigel_blue"
	list_reagents = list(/datum/reagent/space_cleaner/sterilizine = 60)
	custom_price = PAYCHECK_CREW * 2
