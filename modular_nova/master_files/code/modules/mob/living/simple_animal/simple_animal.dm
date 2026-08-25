/datum/config_entry/string/pc_mob_text
	config_entry_value = "As a player controlled mob you are expected to play the role to the best of your ability. \
	This means if you're an animal, act like one. You shouldn't display much intelligence if any. \
	This also means if you're engaging in combat you should refrain from mercing people fully. \
	Play not to win but to create a challenge. \
	You're there to replace AI, make others enjoy the situation as well. \
	If your simple mob is not above simple or mute intelligence, using structures such as welding tanks/canisters/boxes to hinder your opponent is entirely forbidden. \
	Do not do this."

/mob/living
	/// If set to TRUE, ghosts will be able to click on the simple mob and take control of it.
	var/ghost_controllable = FALSE

/mob/living/attack_ghost(mob/dead/observer/user)
	. = ..()
	if(.)
		return
	if(ghost_controllable)
		take_control(user)

/mob/living/proc/take_control(mob/user)
	if(key || stat)
		return
	if(is_banned_from(user.ckey, BAN_MOB_CONTROL))
		to_chat(user, LANG("mob.2fdfbaa81d14abc4", null))
		return
	var/query = tgui_alert(user, LANG("mob.41bb31fcac4be77c", list(src)), LANG("mob.b251a324e8c587e4", null), list("Yes", "No"))
	if(!query || query == "No" || !src || QDELETED(src))
		return
	if(key)
		to_chat(user, span_warning(LANG("mob.45f21b5e926e2acd", null)))
		return
	key = user.key
	var/string_to_send = CONFIG_GET(string/pc_mob_text)
	if(string_to_send)
		to_chat(src, string_to_send)
	log_game("[key_name(src)] took control of [name].")
