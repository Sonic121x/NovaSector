// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/action/cooldown/mob_cooldown/blood_worm/invade
	name = "Invade Corpse"
	desc = "Invade a humanoid corpse, taking it as your host."

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
		victim.balloon_alert(worm, LANG("datum.a462ee7c", null))
		return FALSE
	if (!victim.IsReachableBy(worm))
		victim.balloon_alert(worm, LANG("datum.fba9228d", null))
		return FALSE

	unset_click_ability(worm, refund_cooldown = FALSE) // If you fail after this point, it's because your attempt got interrupted or because the victim is invalid.

	if (!invade_check(worm, victim, feedback = TRUE))
		return TRUE // Don't bite the victim.

	worm.visible_message(
		message = span_danger(LANG("datum.7b10e1eb", list(worm, victim))),
		self_message = span_notice(LANG("datum.279af548", list(victim))),
		blind_message = span_hear(LANG("datum.da94412c", null))
	)

	if (!do_after(worm, 5 SECONDS, victim, extra_checks = CALLBACK(src, PROC_REF(invade_check), worm, victim)))
		return TRUE // Don't bite the victim.

	worm.enter_host(victim)

	return ..()

/// See if we can invade something
/datum/action/cooldown/mob_cooldown/blood_worm/invade/proc/invade_check(mob/living/basic/blood_worm/worm, mob/living/carbon/human/victim, feedback = FALSE)
	if (HAS_TRAIT(victim, TRAIT_BLOOD_WORM_HOST))
		if (feedback)
			victim.balloon_alert(worm, LANG("datum.2e134713", null))
		return FALSE
	if (victim.stat != DEAD)
		if (feedback)
			victim.balloon_alert(worm, LANG("datum.61eeb765", null))
		return FALSE
	if (!CAN_HAVE_BLOOD(victim))
		if (feedback)
			victim.balloon_alert(worm, LANG("datum.ce2814af", null))
		return FALSE
	if (victim.get_blood_volume() + worm.health * BLOOD_WORM_HEALTH_TO_BLOOD <= worm.get_eject_volume_threshold())
		if (feedback)
			victim.balloon_alert(worm, LANG("datum.ce5f3050", null))
		return FALSE
	return TRUE
