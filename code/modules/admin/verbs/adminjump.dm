// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
ADMIN_VERB(jump_to_area, R_ADMIN, "跳转到区域", "Jumps to the specified area.", ADMIN_CATEGORY_GAME)
	VERB_ARG_TYPED(target, VERB_ARG_TYPE_AREA, VERB_ARG_SOURCE_WORLD, /area)
	var/turf/drop_location
	top_level:
		for(var/list/zlevel_turfs as anything in target.get_zlevel_turf_lists())
			for(var/turf/area_turf as anything in zlevel_turfs)
				if(area_turf.density)
					continue
				drop_location = area_turf
				break top_level

	if(isnull(drop_location))
		to_chat(user, span_warning(LANG("datum.0d94156d", null)))
		return

	user.mob.abstract_move(drop_location)
	log_admin("[key_name(user)] jumped to [AREACOORD(drop_location)]")
	message_admins("[key_name_admin(user)] jumped to [AREACOORD(drop_location)]")
	BLACKBOX_LOG_ADMIN_VERB("Jump To Area")

ADMIN_VERB_ONLY_CONTEXT_MENU(jump_to_turf, R_ADMIN, "跳转到地块", /turf)
	VERB_ARG_TYPED(locale, VERB_ARG_TYPE_TURF, VERB_ARG_SOURCE_WORLD, /turf)
	log_admin("[key_name(user)] jumped to [AREACOORD(locale)]")
	message_admins("[key_name_admin(user)] jumped to [AREACOORD(locale)]")
	user.mob.abstract_move(locale)
	BLACKBOX_LOG_ADMIN_VERB("Jump To Turf")

ADMIN_VERB_ONLY_CONTEXT_MENU(jump_to_mob, R_ADMIN, "跳转到生物", /mob)
	VERB_ARG_TYPED(target, VERB_ARG_TYPE_MOB, VERB_ARG_SOURCE_WORLD, /mob)
	user.mob.abstract_move(target.loc)
	log_admin("[key_name(user)] jumped to [key_name(target)]")
	message_admins("[key_name_admin(user)] jumped to [ADMIN_LOOKUPFLW(target)] at [AREACOORD(target)]")
	BLACKBOX_LOG_ADMIN_VERB("Jump To Mob")

ADMIN_VERB(jump_to_coord, R_ADMIN, "跳转到坐标", "Jump to a specific coordinate in the game world.", ADMIN_CATEGORY_GAME)
	VERB_ARG(cx, VERB_ARG_TYPE_NUM, VERB_ARG_SOURCE_INPUT)
	VERB_ARG(cy, VERB_ARG_TYPE_NUM, VERB_ARG_SOURCE_INPUT)
	VERB_ARG(cz, VERB_ARG_TYPE_NUM, VERB_ARG_SOURCE_INPUT)
	var/turf/where_we_droppin = locate(cx, cy, cz)
	if(isnull(where_we_droppin))
		to_chat(user, span_warning(LANG("datum.7b57b728", null)))
		return

	user.mob.abstract_move(where_we_droppin)
	message_admins("[key_name_admin(user)] jumped to coordinates [cx], [cy], [cz]")
	BLACKBOX_LOG_ADMIN_VERB("Jump To Coordiate")

ADMIN_VERB(jump_to_key, R_ADMIN, "跳转到 Key", "Jump to a specific player.", ADMIN_CATEGORY_GAME)
	if(!isobserver(user.mob))
		SSadmin_verbs.dynamic_invoke_verb(user, /datum/admin_verb/admin_ghost)

	var/list/keys = list()
	for(var/mob/M in GLOB.player_list)
		keys += M.client
	var/client/selection = input(user, LANG("datum.49fce9a4", null), LANG("datum.a34d9875", null)) as null|anything in sort_key(keys)
	if(!selection)
		to_chat(user, LANG("datum.aadcdcc6", null), confidential = TRUE)
		return
	var/mob/M = selection.mob
	log_admin("[key_name(user)] jumped to [key_name(M)]")
	message_admins("[key_name_admin(user)] jumped to [ADMIN_LOOKUPFLW(M)]")
	user.mob.abstract_move(M.loc)
	BLACKBOX_LOG_ADMIN_VERB("Jump To Key")

ADMIN_VERB(jump_to_ghost, R_ADMIN, "身体跳转到幽灵处", "Jump your body to your Aghost.", ADMIN_CATEGORY_GAME)
	var/mob/dead/observer/ghost = user.mob
	if(!isobserver(ghost))
		return
	var/mob/living/body = ghost?.mind?.current
	if(!body)
		to_chat(user, LANG("datum.9e71f104", null), confidential = TRUE)
		return
	log_admin("[key_name(user)] jumped to their Aghost at [AREACOORD(ghost.loc)]")
	message_admins("[key_name_admin(user)] jumped to their Aghost [ADMIN_FLW(body)] at [AREACOORD(ghost.loc)]")
	body.abstract_move(ghost.loc)
	body.setDir(ghost.dir)
	SSadmin_verbs.dynamic_invoke_verb(user, /datum/admin_verb/admin_ghost)
	BLACKBOX_LOG_ADMIN_VERB("Jump To Ghost")

ADMIN_VERB_AND_CONTEXT_MENU(get_mob, R_ADMIN, "抓取 Mob", "Teleport a mob to your location.", ADMIN_CATEGORY_GAME, /mob)
	VERB_ARG_TYPED(target, VERB_ARG_TYPE_MOB, VERB_ARG_SOURCE_WORLD, /mob)
	var/atom/loc = get_turf(user.mob)
	target.admin_teleport(loc)
	BLACKBOX_LOG_ADMIN_VERB("Get Mob")

/// Proc to hook user-enacted teleporting behavior and keep logging of the event.
/atom/movable/proc/admin_teleport(atom/new_location)
	if(isnull(new_location))
		log_admin("[key_name(usr)] teleported [key_name(src)] to nullspace")
		moveToNullspace()
	else
		var/turf/location = get_turf(new_location)
		log_admin("[key_name(usr)] teleported [key_name(src)] to [AREACOORD(location)]")
		forceMove(new_location)

/mob/admin_teleport(atom/new_location)
	var/turf/location = get_turf(new_location)
	var/msg = "[key_name_admin(usr)] teleported [ADMIN_LOOKUPFLW(src)] to [isnull(new_location) ? "nullspace" : ADMIN_VERBOSEJMP(location)]"
	message_admins(msg)
	admin_ticket_log(src, msg)
	return ..()

ADMIN_VERB(get_key, R_ADMIN, "抓取 Key", "Teleport the player with the provided key to you.", ADMIN_CATEGORY_GAME)
	var/list/keys = list()
	for(var/mob/M in GLOB.player_list)
		keys += M.client
	var/client/selection = input(user, LANG("datum.49fce9a4", null), LANG("datum.a34d9875", null)) as null|anything in sort_key(keys)
	if(!selection)
		return
	var/mob/M = selection.mob

	if(!M)
		return
	log_admin("[key_name(user)] teleported [key_name(M)]")
	var/msg = "[key_name_admin(user)] teleported [ADMIN_LOOKUPFLW(M)]"
	message_admins(msg)
	admin_ticket_log(M, msg)
	if(M)
		M.forceMove(get_turf(user))
		BLACKBOX_LOG_ADMIN_VERB("Get Key")

ADMIN_VERB_AND_CONTEXT_MENU(send_mob, R_ADMIN, "发送 Mob", "Teleport the specified mob to an area of your choosing.", ADMIN_CATEGORY_GAME, /mob)
	VERB_ARG_TYPED(jumper, VERB_ARG_TYPE_MOB, VERB_ARG_SOURCE_WORLD, /mob)
	var/list/sorted_areas = get_sorted_areas()
	if(!length(sorted_areas))
		to_chat(user, LANG("datum.2a026971", null), confidential = TRUE)
		return
	var/area/target_area = tgui_input_list(user, LANG("datum.7a731178", null), LANG("datum.e6339034", null), sorted_areas)
	if(isnull(target_area))
		return
	if(!istype(target_area))
		return
	var/list/turfs = get_area_turfs(target_area)
	if(length(turfs) && jumper.forceMove(pick(turfs)))
		log_admin("[key_name(user)] teleported [key_name(jumper)] to [AREACOORD(jumper)]")
		var/msg = "[key_name_admin(user)] teleported [ADMIN_LOOKUPFLW(jumper)] to [AREACOORD(jumper)]"
		message_admins(msg)
		admin_ticket_log(jumper, msg)
	else
		to_chat(user, LANG("datum.9e904b59", null), confidential = TRUE)
	BLACKBOX_LOG_ADMIN_VERB("Send Mob")
