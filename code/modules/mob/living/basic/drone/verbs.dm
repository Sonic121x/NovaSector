// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/**
 * Echoes drone laws to the user
 *
 * See [/mob/living/basic/drone/var/laws]
 */
GAME_VERB(/mob/living/basic/drone, check_laws, "查看法则", "Drone")

	to_chat(src, LANG("mob.24a048ba", null))
	to_chat(src, laws)

/**
 * Creates an alert to drones in the same network
 *
 * Prompts user for alert level of:
 * * Low
 * * Medium
 * * High
 * * Critical
 *
 * Attaches area name to message
 */
GAME_VERB(/mob/living/basic/drone, drone_ping, "无人机警报", "Drone")

	var/alert_s = input(src,LANG("mob.5b32bc9b", null),LANG("mob.4a2934c5", null),null) as null|anything in list("Low","Medium","High","Critical")

	var/area/A = get_area(loc)

	if(alert_s && A && stat != DEAD)
		var/msg = span_big("DRONE PING: [name]: [alert_s] priority alert in [A.name]!")
		alert_drones(msg)
