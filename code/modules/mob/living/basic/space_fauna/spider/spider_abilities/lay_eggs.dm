// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/action/cooldown/mob_cooldown/lay_eggs
	name = "Lay Eggs"
	desc = "Lay a cluster of eggs, which will soon grow into a normal spider."
	button_icon = 'icons/mob/actions/actions_animal.dmi'
	button_icon_state = "lay_eggs"
	background_icon_state = "bg_alien"
	overlay_icon_state = "bg_alien_border"
	cooldown_time = 20 SECONDS
	melee_cooldown_time = 5 SECONDS
	shared_cooldown = NONE
	click_to_activate = FALSE
	///How long it takes for a broodmother to lay eggs.
	var/egg_lay_time = 4 SECONDS
	///The type of egg we create
	var/egg_type = /obj/effect/mob_spawn/ghost_role/spider

/datum/action/cooldown/mob_cooldown/lay_eggs/Grant(mob/grant_to)
	. = ..()
	if (!owner)
		return
	RegisterSignals(owner, list(COMSIG_MOVABLE_MOVED, COMSIG_DO_AFTER_BEGAN, COMSIG_DO_AFTER_ENDED), PROC_REF(update_status_on_signal))

/datum/action/cooldown/mob_cooldown/lay_eggs/Remove(mob/removed_from)
	. = ..()
	UnregisterSignal(removed_from, list(COMSIG_MOVABLE_MOVED, COMSIG_DO_AFTER_BEGAN, COMSIG_DO_AFTER_ENDED))

/datum/action/cooldown/mob_cooldown/lay_eggs/IsAvailable(feedback = FALSE)
	. = ..()
	if(!.)
		return FALSE
	if(DOING_INTERACTION(owner, DOAFTER_SOURCE_SPIDER))
		if (feedback)
			owner.balloon_alert(owner, LANG("datum.8df72942c63f9092", null))
		return FALSE
	var/obj/structure/spider/eggcluster/eggs = locate() in get_turf(owner)
	if(eggs)
		if (feedback)
			owner.balloon_alert(owner, LANG("datum.f33507b80d989186", null))
		return FALSE
	return TRUE

/datum/action/cooldown/mob_cooldown/lay_eggs/Activate(atom/target)
	owner.balloon_alert_to_viewers(LANG("datum.1564e82c1bdb6be5", null))
	StartCooldown(360 SECONDS, 360 SECONDS)
	if(!do_after(owner, egg_lay_time, target = get_turf(owner), interaction_key = DOAFTER_SOURCE_SPIDER))
		owner.balloon_alert(owner, LANG("datum.c67b5d274d6e724b", null))
		StartCooldown(0 SECONDS)
		return
	var/obj/structure/spider/eggcluster/eggs = locate() in get_turf(owner)
	if(eggs)
		owner.balloon_alert(owner, LANG("datum.f33507b80d989186", null))
	else
		lay_egg()
	StartCooldown()

/datum/action/cooldown/mob_cooldown/lay_eggs/proc/lay_egg()
	var/obj/effect/mob_spawn/ghost_role/spider/new_eggs = new egg_type(get_turf(owner))
	SET_FACTION_AND_ALLIES_FROM(new_eggs, owner)
	var/datum/action/cooldown/mob_cooldown/set_spider_directive/spider_directive = locate() in owner.actions
	if (spider_directive)
		new_eggs.directive = spider_directive.current_directive

/datum/action/cooldown/mob_cooldown/lay_eggs/abnormal
	name = "Lay Abnormal Eggs"
	desc = "Lay a cluster of eggs, which will soon grow into a uncommon spider."
	button_icon_state = "lay_abnormal_eggs"
	cooldown_time = 180 SECONDS
	egg_type = /obj/effect/mob_spawn/ghost_role/spider/abnormal

/datum/action/cooldown/mob_cooldown/lay_eggs/enriched
	name = "Lay Enriched Eggs"
	desc = "Lay a cluster of eggs, which will soon grow into a rare spider.  Requires you drain a human per cluster of these eggs."
	button_icon_state = "lay_enriched_eggs"
	cooldown_time = 60 SECONDS
	egg_type = /obj/effect/mob_spawn/ghost_role/spider/enriched
	/// How many charges we have to make eggs
	var/charges = 0

/datum/action/cooldown/mob_cooldown/lay_eggs/enriched/IsAvailable(feedback = FALSE)
	. = ..()
	if (!.)
		return FALSE
	if (charges <= 0)
		if (feedback)
			owner.balloon_alert(owner, LANG("datum.2bebcffac7307e29", null))
		return FALSE
	return TRUE

/datum/action/cooldown/mob_cooldown/lay_eggs/enriched/lay_egg()
	charges--
	return ..()
