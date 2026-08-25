// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/action/cooldown/mob_cooldown/spit_ore
	name = "Spit Ore"
	desc = "Vomit out all of your consumed ores."
	click_to_activate = FALSE
	cooldown_time = 5 SECONDS

/datum/action/cooldown/mob_cooldown/spit_ore/IsAvailable(feedback)
	if(is_jaunting(owner))
		if(feedback)
			owner.balloon_alert(owner, LANG("datum.63f9f23a4a7240e9", null))
		return FALSE

	if(!length(owner.contents))
		if(feedback)
			owner.balloon_alert(owner, LANG("datum.7d3296464e278794", null))
		return FALSE
	return TRUE

/datum/action/cooldown/mob_cooldown/spit_ore/Activate()
	var/mob/living/basic/mining/goldgrub/grub_owner = owner
	grub_owner.barf_contents()
	StartCooldown()
	return TRUE

/datum/action/cooldown/mob_cooldown/burrow
	name = "Burrow"
	desc = "Burrow under soft ground, evading predators and increasing your speed."
	cooldown_time = 7 SECONDS
	click_to_activate = FALSE

/datum/action/cooldown/mob_cooldown/burrow/IsAvailable(feedback)
	. = ..()
	if (!.)
		return FALSE
	var/turf/location = get_turf(owner)

	if(!isasteroidturf(location) && !ismineralturf(location))
		if(feedback)
			owner.balloon_alert(owner, LANG("datum.67c8f07afa1addca", null))
		return FALSE

	return TRUE

/datum/action/cooldown/mob_cooldown/burrow/Activate()
	var/obj/effect/dummy/phased_mob/grub_burrow/holder = null
	var/turf/current_loc = get_turf(owner)
	var/mob/living/grub = owner

	if(!do_after(owner, 2.5 SECONDS, target = current_loc, extra_checks = CALLBACK(src, PROC_REF(health_check), grub.health)))
		return

	if(get_turf(owner) != current_loc)
		to_chat(owner, span_warning(LANG("datum.cb91c92edc249bdd", null)))
		return

	if(!is_jaunting(owner))
		owner.visible_message(span_danger(LANG("datum.2a2c29f3ec2c1c9c", list(owner))))
		playsound(get_turf(owner), 'sound/effects/break_stone.ogg', 50, TRUE, -1)
		holder = new /obj/effect/dummy/phased_mob/grub_burrow(current_loc, owner)
		return TRUE

	holder = owner.loc
	holder.eject_jaunter()
	holder = null
	owner.visible_message(span_danger(LANG("datum.5b8bb6938142a303", list(owner))))

	if(ismineralturf(current_loc))
		var/turf/closed/mineral/mineral_turf = current_loc
		mineral_turf.gets_drilled(owner)

	playsound(current_loc, 'sound/effects/break_stone.ogg', 50, TRUE, -1)
	StartCooldown()
	return TRUE

/datum/action/cooldown/mob_cooldown/burrow/proc/health_check(health)
	var/mob/living/grub = owner
	return grub.health >= health

/obj/effect/dummy/phased_mob/grub_burrow

/obj/effect/dummy/phased_mob/grub_burrow/phased_check(mob/living/user, direction)
	. = ..()

	if(!.)
		return

	if(!ismineralturf(.) && !isasteroidturf(.))
		to_chat(user, span_warning(LANG("obj.a1b4bb838ec47654", null)))
		return null
