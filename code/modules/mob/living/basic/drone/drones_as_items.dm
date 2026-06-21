/** Drone Shell: Ghost role item for drones
 *
 * A simple mob spawner item that transforms into a maintenance drone
 * Respects drone minimum age
 */

/obj/effect/mob_spawn/ghost_role/drone
	name = "无人机外壳"
	desc = "一个维护区无人机的空壳，一种为执行空间站维修而建造的消耗型机器人。"
	icon = 'icons/mob/silicon/drone.dmi'
	icon_state = "drone_maint_hat" //yes reuse the _hat state.
	layer = BELOW_MOB_LAYER
	density = FALSE
	mob_name = "drone"
	///Type of drone that will be spawned
	mob_type = /mob/living/basic/drone
	role_ban = ROLE_DRONE
	show_flavor = FALSE
	prompt_name = "维护区无人机"
	you_are_text = "你是一台维护区无人机。"
	flavour_text = "你诞生于科研，你的使命是维护空间站13。维护区无人机可以成为健康空间站的支柱。"
	important_text = "你必须仔细阅读并遵守你的法则。"
	spawner_job_path = /datum/job/maintenance_drone

/obj/effect/mob_spawn/ghost_role/drone/Initialize(mapload)
	. = ..()
	var/area/area = get_area(src)
	if(area)
		notify_ghosts(
			"A drone shell has been created in \the [area.name].",
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
			to_chat(user, span_danger("你需要再以[required_role]的身份游玩[playtime_left]才能以维护区无人机身份生成！"))
		return FALSE
	return ..()
