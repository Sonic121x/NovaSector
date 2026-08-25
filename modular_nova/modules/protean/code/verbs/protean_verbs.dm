GAME_VERB_PROC_DESC(/mob/living/carbon, protean_ui, "打开套装界面", "Opens your suit UI", "Protean")
	var/obj/item/mod/control/pre_equipped/protean/suit = get_protean_modsuit(src)
	if(isnull(suit))
		return
	suit.ui_interact(src)

GAME_VERB_PROC_DESC(/mob/living/carbon, protean_heal, "治疗器官和四肢", "Heals your replaceable organs and limbs with 6 metal.", "Protean")
	var/obj/item/organ/brain/protean/brain = get_organ_slot(ORGAN_SLOT_BRAIN)

	if(!istype(brain))
		return

	var/obj/item/mod/control/pre_equipped/protean/suit = get_protean_modsuit(src)
	if(isnull(suit))
		return
	if(incapacitated && loc != suit)
		balloon_alert(src, LANG("mob.7ac2788bbe3be4b1", null))
		return

	brain.replace_limbs()

GAME_VERB_PROC_DESC(/mob/living/carbon, lock_suit, "锁定套装", "Locks your suit on someone", "Protean")
	var/obj/item/mod/control/pre_equipped/protean/suit = get_protean_modsuit(src)
	if(isnull(suit))
		return

	suit.toggle_lock()
	to_chat(src, span_notice(LANG("mob.d31e11321bc63010", list(suit.modlocked ? "<b>lock</b>" : "<b>unlock</b>", isprotean(suit.wearer) || loc == suit ? "" : "onto [suit.wearer]"))))
	playsound(src, 'sound/machines/click.ogg', 25)

GAME_VERB_PROC_DESC(/mob/living/carbon, suit_transformation, "切换套装变形", "Either leave or enter your suit.", "Protean")
	var/obj/item/organ/brain/protean/brain = get_organ_slot(ORGAN_SLOT_BRAIN)

	if(!istype(brain))
		return
	var/obj/item/mod/control/pre_equipped/protean/suit = get_protean_modsuit(src)
	if(isnull(suit))
		return
	if(loc == suit)
		brain.leave_modsuit()
	else if(isturf(loc))
		if(!incapacitated)
			brain.go_into_suit()
		else
			balloon_alert(src, LANG("mob.7ac2788bbe3be4b1", null))

GAME_VERB_PROC_DESC(/mob/living/carbon, remove_assimilated_modsuit, "移除同化模组服", "Pry out an absorbed modsuit from your protean suit.", "Protean")
	var/obj/item/mod/control/pre_equipped/protean/suit = get_protean_modsuit(src)
	if(isnull(suit))
		return
	suit.unassimilate_modsuit(src)

GAME_VERB_PROC_DESC(/mob/living/carbon, remove_assimilated_plating, "移除同化装甲板", "Reset your modsuit appearance back to default.", "Protean")
	var/obj/item/mod/control/pre_equipped/protean/suit = get_protean_modsuit(src)
	if(isnull(suit))
		return
	suit.unassimilate_theme()

GAME_VERB_PROC_DESC(/mob/living/carbon, low_power, "切换低功耗模式", "Toggle whether you are running on low power mode.", "Protean")
	var/obj/item/mod/control/pre_equipped/protean/suit = get_protean_modsuit(src)
	if(isnull(suit))
		return
	var/obj/item/organ/stomach/protean/stomach = get_organ_slot(ORGAN_SLOT_STOMACH)
	if(!istype(stomach))
		to_chat(src, span_warning(LANG("mob.f360a083dd230dff", null)))
		return
	if(loc == suit)
		to_chat(src, span_notice(LANG("mob.fd750461f10658ff", null)))
		return
	if(!do_after(src, 2.5 SECONDS))
		src.loc.balloon_alert(src, LANG("mob.08fef07e4f494aba", null))
		return
	var/datum/status_effect/protean_low_power_mode/effect = /datum/status_effect/protean_low_power_mode/low_power
	if(istype(has_status_effect(effect), effect))
		remove_status_effect(effect)
	else
		if(suit.active)
			suit.toggle_activate(usr, TRUE)
		// Preventing low power slowdown being removed by reform cooldown
		if(has_status_effect(/datum/status_effect/protean_low_power_mode))
			remove_status_effect(/datum/status_effect/protean_low_power_mode)
		apply_status_effect(effect)
