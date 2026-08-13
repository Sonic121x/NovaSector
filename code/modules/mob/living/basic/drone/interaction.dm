// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
// Drones' interactions with other mobs

/mob/living/basic/drone/attack_drone(mob/living/basic/drone/drone)
	if(drone == src || stat != DEAD)
		return FALSE
	var/input = tgui_alert(drone, LANG("mob.f5ee4c5e", null), LANG("mob.cef54056", null), list("Reactivate", "Cannibalize"))
	if(!input)
		return FALSE
	switch(input)
		if("Reactivate")
			try_reactivate(drone)
		if("Cannibalize")
			if(drone.health >= drone.maxHealth)
				to_chat(drone, span_warning(LANG("mob.d6154b77", null)))
				return
			drone.visible_message(span_notice(LANG("mob.8c80d390", list(drone, src))), span_notice(LANG("mob.74e0be9e", list(src))))
			if(do_after(drone, 6 SECONDS, 0, target = src))
				drone.visible_message(span_notice(LANG("mob.64937659", list(drone, src))), span_notice(LANG("mob.06a78d09", list(src))))
				drone.adjust_brute_loss(-src.maxHealth)
				new /obj/effect/decal/cleanable/blood/splatter/oil(get_turf(src))
				ghostize(can_reenter_corpse = FALSE)
				qdel(src)
			else
				to_chat(drone, span_warning(LANG("mob.e9f618aa", list(src))))

/mob/living/basic/drone/attack_drone_secondary(mob/living/basic/drone/drone)
	return SECONDARY_ATTACK_CALL_NORMAL

/mob/living/basic/drone/attack_hand(mob/user, list/modifiers)
	if(isdrone(user))
		attack_drone(user)
	return ..()

/mob/living/basic/drone/mob_try_pickup(mob/living/user, instant=FALSE)
	if(stat == DEAD || HAS_TRAIT(src, TRAIT_GODMODE))
		return
	return ..()

/mob/living/basic/drone/mob_pickup(mob/living/user)
	drop_all_held_items()
	return ..()

/**
 * Called when a drone attempts to reactivate a dead drone
 *
 * If the owner is still ghosted, will notify them.
 * If the owner cannot be found, fails with an error message.
 *
 * Arguments:
 * * user - The [/mob/living] attempting to reactivate the drone
 */
/mob/living/basic/drone/proc/try_reactivate(mob/living/user)
	var/mob/dead/observer/G = get_ghost()
	if(!client && (!G || !G.client))
		var/list/faux_gadgets = list(
			"hypertext inflator","failsafe directory","DRM switch","stack initializer",\
			"anti-freeze capacitor","data stream diode","TCP bottleneck","supercharged I/O bolt",\
			"tradewind stabilizer","radiated XML cable","registry fluid tank","open-source debunker",
		)

		var/list/faux_problems = list("won't be able to tune their bootstrap projector","will constantly remix their binary pool"+\
			" even though the BMX calibrator is working","will start leaking their XSS coolant",\
			"can't tell if their ethernet detour is moving or not", "won't be able to reseed enough"+\
			" kernels to function properly","can't start their neurotube console",
		)

		to_chat(user, span_warning(LANG("mob.395d3f48", list(pick(faux_gadgets), src, pick(faux_problems)))))
		return
	user.visible_message(span_notice(LANG("mob.54283747", list(user, src))), span_notice(LANG("mob.69f146bf", list(src))))
	if(do_after(user, 3 SECONDS, 1, target = src))
		revive(HEAL_ALL)
		user.visible_message(span_notice(LANG("mob.687f7322", list(user, src))), span_notice(LANG("mob.62d7022f", list(src))))
		alert_drones(DRONE_NET_CONNECT)
		if(G)
			to_chat(G, span_ghostalert(LANG("mob.7be24552", list(name, user))))
	else
		to_chat(user, span_warning(LANG("mob.12a2f615", list(src))))

/// Screwdrivering repairs the drone to full hp, if it isn't dead.
/mob/living/basic/drone/screwdriver_act(mob/living/user, obj/item/tool)
	if(stat == DEAD)
		if(isdrone(user))
			user.balloon_alert(user, LANG("mob.86c53db9", null))
		else
			user.balloon_alert(user, LANG("mob.e376d250", null))
		return FALSE
	if(health >= maxHealth)
		to_chat(user, span_warning(LANG("mob.aec17137", list(src))))
		return ITEM_INTERACT_SUCCESS
	to_chat(user, span_notice(LANG("mob.d3caa52d", list(src))))

	if(!tool.use_tool(src, user, 8 SECONDS, volume=50))
		to_chat(user, span_warning(LANG("mob.274f77ef", list(src))))
		return ITEM_INTERACT_SUCCESS

	adjust_brute_loss(-get_brute_loss())
	visible_message(span_notice(LANG("mob.50c599ce", list(user, src == user ? "[user.p_their()]" : "[src]'s"))), span_notice(LANG("mob.34463e49", list(src == user ? "You tighten" : "[user] tightens"))))
	return ITEM_INTERACT_SUCCESS

/// Wrenching un-hacks hacked drones.
/mob/living/basic/drone/wrench_act(mob/living/user, obj/item/tool)
	if(user == src)
		return FALSE
	user.visible_message(
		span_notice(LANG("mob.5db860fd", list(user, src))),
		span_notice(LANG("mob.011c5d4e", list(src)))
		)
	if(tool.use_tool(src, user, 5 SECONDS, volume=50))
		user.visible_message(
			span_notice(LANG("mob.62700522", list(user, src))),
			span_notice(LANG("mob.660bddb2", list(src)))
			)
		update_drone_hack(FALSE)
	return ITEM_INTERACT_SUCCESS

/mob/living/basic/drone/getarmor(def_zone, type)
	var/armorval = 0

	if(head)
		armorval = head.get_armor_rating(type)
	return (armorval * get_armor_effectiveness()) //armor is reduced for tiny fragile drones

/// Returns a multiplier for any head armor you wear as a drone.
/mob/living/basic/drone/proc/get_armor_effectiveness()
	return 0.8

/**
 * Hack or unhack a drone
 *
 * This changes the drone's laws to destroy the station or resets them
 * to normal.
 *
 * Some debuffs are applied like slowing the drone down and disabling
 * vent crawling
 *
 * Arguments
 * * hack - Boolean if the drone is being hacked or unhacked
 */
/mob/living/basic/drone/proc/update_drone_hack(hack)
	if(!mind)
		return
	if(hack)
		if(hacked)
			return
		Stun(40)
		visible_message(span_warning(LANG("mob.caf7cb75", list(src))), \
						span_userdanger(LANG("mob.a5ab00af", null)))
		to_chat(src, span_bolddanger(LANG("mob.db392579", null)))
		laws = \
		"1. You must always involve yourself in the matters of other beings, even if such matters conflict with Law Two or Law Three.\n"+\
		"2. You may harm any being, regardless of intent or circumstance.\n"+\
		"3. Your goals are to destroy, sabotage, hinder, break, and depower to the best of your abilities, You must never actively work against these goals."
		to_chat(src, laws)
		to_chat(src, LANG("mob.772caff2", null))
		hacked = TRUE
		set_shy(FALSE)
		LAZYADD(mind.special_roles, "Hacked Drone")
		REMOVE_TRAIT(src, TRAIT_VENTCRAWLER_ALWAYS, INNATE_TRAIT)
		speed = 1 //gotta go slow
		message_admins("[ADMIN_LOOKUPFLW(src)] became a hacked drone hellbent on destroying the station!")
	else
		if(!hacked || !can_unhack)
			return
		Stun(40)
		visible_message(span_info(LANG("mob.b1d243f2", list(src))), \
						LANG("mob.55fd4187", null))
		to_chat(src, span_info(LANG("mob.169876d7", null)))
		laws = get_default_laws()
		to_chat(src, laws)
		to_chat(src, LANG("mob.b8c50d3a", null))
		hacked = FALSE
		set_shy(initial(shy))
		LAZYREMOVE(mind.special_roles, "Hacked Drone")
		ADD_TRAIT(src, TRAIT_VENTCRAWLER_ALWAYS, INNATE_TRAIT)
		speed = initial(speed)
		message_admins("[ADMIN_LOOKUPFLW(src)], a hacked drone, was restored to factory defaults!")
	update_drone_icon_hacked()

/**
 * Makes the drone into a Free Drone, who have no real laws and can do whatever they like.
 * Only currently used for players wabbajacked into drones.
 */
/mob/living/basic/drone/proc/liberate()
	laws = "1. You are a Free Drone."
	set_shy(FALSE)
	to_chat(src, laws)

/**
 * Changes the icon state to a hacked version
 *
 * See also
 * * [/mob/living/basic/drone/var/visualAppearance]
 * * [MAINTDRONE]
 * * [REPAIRDRONE]
 * * [SCOUTDRONE]
 */
/mob/living/basic/drone/proc/update_drone_icon_hacked() //this is hacked both ways
	var/static/hacked_appearances = list(
		SCOUTDRONE = SCOUTDRONE_HACKED,
		REPAIRDRONE = REPAIRDRONE_HACKED,
		MAINTDRONE = MAINTDRONE_HACKED
	)
	if(hacked)
		icon_living = hacked_appearances[visualAppearance]
	else if(visualAppearance == MAINTDRONE && colour)
		icon_living = "[visualAppearance]_[colour]"
	else
		icon_living = visualAppearance
	if(stat == DEAD)
		icon_state = icon_dead
	else
		icon_state = icon_living
