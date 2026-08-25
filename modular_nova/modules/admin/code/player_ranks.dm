/// The list of the available special player ranks
#define NOVA_PLAYER_RANKS list("Donator", "Mentor", "Nova Star")

ADMIN_VERB(manage_player_ranks, R_PERMISSIONS, "管理玩家等级", "Manage who has the special player ranks while the server is running.", ADMIN_CATEGORY_MAIN)
	usr.client?.holder.manage_player_ranks()

/// Proc for admins to change people's "player" ranks (donator, mentor, nova star, etc.)
/datum/admins/proc/manage_player_ranks()
	if(IsAdminAdvancedProcCall())
		return

	if(!check_rights(R_PERMISSIONS))
		return

	var/choice = tgui_alert(usr, LANG("datum.37c605232db9a89f", null), LANG("datum.658a4ef0eb96e4ea", null), NOVA_PLAYER_RANKS)
	if(!choice || !(choice in NOVA_PLAYER_RANKS))
		return

	manage_player_rank_in_group(choice)

/**
 * Handles managing player ranks based on the name of the group that was chosen.
 *
 * Arguments:
 * * group - The title of the player rank that was chosen to be managed.
 */
/datum/admins/proc/manage_player_rank_in_group(group)
	PROTECTED_PROC(TRUE)

	if(IsAdminAdvancedProcCall())
		return

	if(!(group in NOVA_PLAYER_RANKS))
		CRASH("[key_name(usr)] attempted to add someone to an invalid \"[group]\" group.")

	var/group_title = LOWER_TEXT(replacetext(group, " ", "_"))

	var/list/choices = list("Add", "Remove")
	switch(tgui_alert(usr, LANG("datum.ab3c2f647ff1b220", null), LANG("datum.74de5d85c84a23f0", list(group)), choices))
		if("Add")
			var/name = input(usr, LANG("datum.65a3b9e7c8d1cd3f", list(group)), LANG("datum.67e0cfc04b4fe4d3", list(group))) as null|text
			if(!name)
				return

			var/player_to_be = ckey(name)
			if(!player_to_be)
				to_chat(usr, span_warning(LANG("datum.f33b2d5b9dc138f9", list(name))))
				return

			var/success = SSplayer_ranks.add_player_to_group(usr.client, player_to_be, group_title)

			if(!success)
				return

			message_admins("[key_name(usr)] has granted [group] status to [player_to_be].")
			log_admin_private("[key_name(usr)] has granted [group] status to [player_to_be].")


		if("Remove")
			var/name = input(usr, LANG("datum.64ae4ccee421b466", list(group)), LANG("datum.48e12e4324d81052", list(group))) as null|text
			if(!name)
				return

			var/player_that_was = ckey(name)
			if(!player_that_was)
				to_chat(usr, span_warning(LANG("datum.f33b2d5b9dc138f9", list(name))))
				return

			var/success = SSplayer_ranks.remove_player_from_group(usr.client, player_that_was, group_title)

			if(!success)
				return

			message_admins("[key_name(usr)] has revoked [group] status from [player_that_was].")
			log_admin_private("[key_name(usr)] has revoked [group] status from [player_that_was].")

		else
			return


ADMIN_VERB(migrate_player_ranks, R_PERMISSIONS|R_DEBUG|R_SERVER, "迁移玩家等级", "Individually migrate the various player ranks from their legacy system to the SQL-based one.", ADMIN_CATEGORY_DEBUG)
	user.mob.client?.holder.migrate_player_ranks()

/datum/admins/proc/migrate_player_ranks()
	if(IsAdminAdvancedProcCall())
		return

	if(!check_rights(R_PERMISSIONS | R_DEBUG | R_SERVER))
		return

	if(!CONFIG_GET(flag/sql_enabled))
		return

	var/choice = tgui_alert(usr, LANG("datum.e91e75faf189b82f", null), LANG("datum.87963233600b1e1d", null), NOVA_PLAYER_RANKS)
	if(!choice || !(choice in NOVA_PLAYER_RANKS))
		return

	if(tgui_alert(usr, LANG("datum.74ed3b7affd432b8", list(choice)), LANG("datum.87963233600b1e1d", null), list("Yes", "No")) != "Yes")
		return

	log_admin("[key_name(usr)] is migrating the [choice] player rank from its legacy system to the SQL-based one.")
	SSplayer_ranks.migrate_player_rank_to_sql(usr.client, choice)


#undef NOVA_PLAYER_RANKS
