/datum/action/cooldown/mob_cooldown/blood_worm/invade
	name = "入侵尸体"
	desc = "入侵一具类人尸体，将其作为你的宿主。"

	button_icon_state = "invade_corpse"

	cooldown_time = 0 SECONDS
	shared_cooldown = NONE

	unset_after_click = FALSE // Unsetting is handled explicitly.

/datum/action/cooldown/mob_cooldown/blood_worm/invade/Grant(mob/granted_to)
	. = ..()
	if (!owner)
		return
	RegisterSignal(owner, COMSIG_MOUSEDROP_ONTO, PROC_REF(on_dragged_onto))

/datum/action/cooldown/mob_cooldown/blood_worm/invade/Remove(mob/removed_from)
	. = ..()
	UnregisterSignal(removed_from, COMSIG_MOUSEDROP_ONTO)

/datum/action/cooldown/mob_cooldown/blood_worm/invade/IsAvailable(feedback)
	if (!istype(owner, /mob/living/basic/blood_worm))
		return FALSE
	return ..()

/// If we drag ourselves onto a corpse (or a live human) then try and climb in
/datum/action/cooldown/mob_cooldown/blood_worm/invade/proc/on_dragged_onto(atom/movable/source, atom/over, mob/user)
	SIGNAL_HANDLER
	if (user != owner || !ishuman(over))
		return
	INVOKE_ASYNC(src, PROC_REF(Activate), over)
	return COMPONENT_CANCEL_MOUSEDROP_ONTO

/datum/action/cooldown/mob_cooldown/blood_worm/invade/Activate(atom/target)
	if (!ishuman(target))
		return FALSE

	var/mob/living/basic/blood_worm/worm = owner
	var/mob/living/carbon/human/victim = target

	if (!worm.Adjacent(victim))
		victim.balloon_alert(worm, "距离太远！")
		return FALSE
	if (!victim.IsReachableBy(worm))
		victim.balloon_alert(worm, "够不着！")
		return FALSE

	unset_click_ability(worm, refund_cooldown = FALSE) // If you fail after this point, it's because your attempt got interrupted or because the victim is invalid.

	if (!invade_check(worm, victim, feedback = TRUE))
		return TRUE // Don't bite the victim.

	worm.visible_message(
		message = span_danger("\The [worm] 开始进入 \the [victim]！"),
		self_message = span_notice("You start entering \the [victim]."),
		blind_message = span_hear("你听到了挤压声。")
	)

	if (!do_after(worm, 5 SECONDS, victim, extra_checks = CALLBACK(src, PROC_REF(invade_check), worm, victim)))
		return TRUE // Don't bite the victim.

	worm.enter_host(victim)

	return ..()

/// See if we can invade something
/datum/action/cooldown/mob_cooldown/blood_worm/invade/proc/invade_check(mob/living/basic/blood_worm/worm, mob/living/carbon/human/victim, feedback = FALSE)
	if (HAS_TRAIT(victim, TRAIT_BLOOD_WORM_HOST))
		if (feedback)
			victim.balloon_alert(worm, "已有宿主！")
		return FALSE
	if (victim.stat != DEAD)
		if (feedback)
			victim.balloon_alert(worm, "还活着！")
		return FALSE
	if (!CAN_HAVE_BLOOD(victim))
		if (feedback)
			victim.balloon_alert(worm, "没有血液！")
		return FALSE
	if (victim.get_blood_volume() + worm.health * BLOOD_WORM_HEALTH_TO_BLOOD <= worm.get_eject_volume_threshold())
		if (feedback)
			victim.balloon_alert(worm, "血液不足以控制！")
		return FALSE
	return TRUE
