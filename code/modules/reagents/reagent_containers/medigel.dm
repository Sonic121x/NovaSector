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
	name = "医用凝胶"
	desc = "一款医用凝胶涂抹瓶，设计用于精准施药，配有可旋开的瓶盖。"
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
	to_chat(user, span_notice("You will now apply the medigel's contents in [squirt_mode ? "extended sprays":"short bursts"]. You'll now use [amount_per_transfer_from_this] units per use."))

/obj/item/reagent_containers/medigel/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!isliving(interacting_with))
		return NONE
	if(!reagents || !reagents.total_volume)
		to_chat(user, span_warning("[src]是空的！"))
		return ITEM_INTERACT_BLOCKING

	user.changeNext_move(CLICK_CD_MELEE)
	if(interacting_with == user)
		interacting_with.visible_message(span_notice("[user]试图[apply_method][src]在[user.p_them()]自己身上。"))
		if(self_delay)
			if(!do_after(user, self_delay, interacting_with))
				return ITEM_INTERACT_BLOCKING
			if(!reagents || !reagents.total_volume)
				return ITEM_INTERACT_BLOCKING
		to_chat(interacting_with, span_notice("你用[src][apply_method]了自己。"))

	else
		log_combat(user, interacting_with, "attempted to apply", src, reagents.get_reagent_log_string())
		interacting_with.visible_message(
			span_danger("[user]试图[apply_method][src]在[interacting_with]身上。"),
			span_userdanger("[user]试图[apply_method][src]在你身上。"),
		)
		if(!do_after(user, CHEM_INTERACT_DELAY(3 SECONDS, user), interacting_with))
			return ITEM_INTERACT_BLOCKING
		if(!reagents || !reagents.total_volume)
			return ITEM_INTERACT_BLOCKING
		interacting_with.visible_message(
			span_danger("[user]用[src][apply_method]倒了[interacting_with]。"),
			span_userdanger("[user]用[src][apply_method]倒了你。"),
		)

	log_combat(user, interacting_with, "applied", src, reagents.get_reagent_log_string())
	playsound(src, 'sound/effects/spray.ogg', 30, TRUE, -6)
	reagents.trans_to(interacting_with, amount_per_transfer_from_this, transferred_by = user, methods = apply_type)
	return ITEM_INTERACT_SUCCESS

/obj/item/reagent_containers/medigel/libital
	name = "医用凝胶(利比特)-'Libital'"
	desc = "医用凝胶涂抹瓶，设计用于精准施药，配有可旋开的瓶盖。此瓶内装有“利比妥”凝胶，用于治疗割伤与瘀伤。请注意，利比妥会造成轻微的肝损伤。本品已用“格拉尼比妥里”稀释。"
	icon_state = "brutegel"
	list_reagents = list(/datum/reagent/medicine/c2/libital = 24, /datum/reagent/medicine/granibitaluri = 36)

/obj/item/reagent_containers/medigel/aiuri
	name = "医用凝胶(艾尤里)-'Aiuri'"
	desc = "医用凝胶涂抹瓶，设计用于精准施药，配有可旋开的瓶盖。此瓶内装有“艾尤里”凝胶，用于治疗烧伤。请注意，艾尤里会造成轻微的眼部损伤。本品已用“格拉尼比妥里”稀释。"
	icon_state = "burngel"
	list_reagents = list(/datum/reagent/medicine/c2/aiuri = 24, /datum/reagent/medicine/granibitaluri = 36)

/obj/item/reagent_containers/medigel/synthflesh
	name = "医用凝胶(合成肉)-'Synthflesh'"
	desc = "一个医疗凝胶涂抹瓶，专为精确涂抹设计，带有可旋开的瓶盖。此瓶内含合成肉，一种略有毒性、能够治疗瘀伤、烧伤和焦尸化的药物。"
	icon_state = "synthgel"
	list_reagents = list(/datum/reagent/medicine/c2/synthflesh = 60)
	list_reagents_purity = 1
	amount_per_transfer_from_this = 60
	possible_transfer_amounts = list(5, 10, 60)
	custom_price = PAYCHECK_CREW * 5

/obj/item/reagent_containers/medigel/synthflesh/examine(mob/user)
	. = ..()
	if(reagents.total_volume >= 60)
		. += span_info("一整瓶可以修复一具因烧伤而焦尸化的尸体。")

/obj/item/reagent_containers/medigel/synthflesh/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(iscarbon(interacting_with) && reagents?.total_volume)
		var/mob/living/carbon/carbies = interacting_with
		if(HAS_TRAIT_FROM(carbies, TRAIT_HUSK, BURN) && carbies.get_fire_loss() > UNHUSK_DAMAGE_THRESHOLD * 2.5)
			// give them a warning if the mob is a husk but synthflesh won't unhusk yet
			carbies.visible_message(span_boldwarning("[carbies]的烧伤需要先修复，合成肉才能解除其焦尸化状态！"))

	return ..()

/obj/item/reagent_containers/medigel/sterilizine
	name = "消毒喷雾"
	desc = "一瓶装有无毒灭菌剂的凝胶，可用于手术前的准备工作。"
	icon_state = "medigel_blue"
	list_reagents = list(/datum/reagent/space_cleaner/sterilizine = 60)
	custom_price = PAYCHECK_CREW * 2
