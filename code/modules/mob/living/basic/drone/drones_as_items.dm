// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/** Drone Shell: Ghost role item for drones
 *
 * A simple mob spawner item that transforms into a maintenance drone
 * Respects drone minimum age
 */

/obj/effect/mob_spawn/ghost_role/drone
	name = "drone shell"
	desc = "A shell of a maintenance drone, an expendable robot built to perform station repairs."
	icon = 'icons/mob/silicon/drone.dmi'
	icon_state = "drone_maint_hat" //yes reuse the _hat state.
	layer = BELOW_MOB_LAYER
	density = FALSE
	mob_name = "drone"
	///Type of drone that will be spawned
	mob_type = /mob/living/basic/drone
	role_ban = ROLE_DRONE
	show_flavor = FALSE
	prompt_name = "maintenance drone"
	you_are_text = "You are a Maintenance Drone."
	flavour_text = "Born out of science, your purpose is to maintain Space Station 13. Maintenance Drones can become the backbone of a healthy station."
	important_text = "You MUST read and follow your laws carefully."
	spawner_job_path = /datum/job/maintenance_drone

/obj/effect/mob_spawn/ghost_role/drone/Initialize(mapload)
	. = ..()
	var/area/area = get_area(src)
	if(area)
		notify_ghosts(
			LANG("obj.29f7c73a9c0434e7", list(area.name)),
			source = src,
			header = "Drone Shell Created",
			click_interact = TRUE,
			ignore_key = POLL_IGNORE_DRONE,
			notify_flags = (GHOST_NOTIFY_IGNORE_MAPLOAD),
		)

/obj/effect/mob_spawn/ghost_role/drone/allow_spawn(mob/user, silent = FALSE)
	var/client/user_client = user.client
	var/mob/living/basic/drone/drone_type = mob_type
	if(!initial(drone_type.shy) || isnull(user_client) || !CONFIG_GET(flag/use_exp_restrictions_other))
		return ..()
	var/required_role = CONFIG_GET(string/drone_required_role)
	var/required_playtime = CONFIG_GET(number/drone_role_playtime) * 60
	if(CONFIG_GET(flag/use_exp_restrictions_admin_bypass) && check_rights_for(user.client, R_ADMIN))
		return ..()
	if(user?.client?.prefs.db_flags & DB_FLAG_EXEMPT)
		return ..()
	if(required_playtime <= 0)
		return ..()
	var/current_playtime = user_client?.calc_exp_type(required_role)
	if (current_playtime < required_playtime)
		var/minutes_left = required_playtime - current_playtime
		var/playtime_left = DisplayTimeText(minutes_left * (1 MINUTES))
		if(!silent)
			to_chat(user, span_danger(LANG("obj.367c6ce554285b00", list(playtime_left, required_role))))
		return FALSE
	return ..()
