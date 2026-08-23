/**
 * EXTRA MOB VV
 */
/mob/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION(VV_HK_SEND_CRYO, "Send to Cryogenic Storage")
	VV_DROPDOWN_OPTION(VV_HK_LOAD_PREFS, "Load Prefs Onto Mob")

/mob/vv_do_topic(list/href_list)
	. = ..()
	if(href_list[VV_HK_SEND_CRYO])
		vv_send_cryo()


	if(href_list[VV_HK_LOAD_PREFS])
		vv_load_prefs()

/**
 * Sends said person to a cryopod.
 */
/mob/proc/vv_send_cryo()
	if(!check_rights(R_SPAWN))
		return

	var/send_notice = tgui_alert(usr, LANG("mob.6fe25d3d692e037b", list(name)), LANG("mob.c35aff6f09f3fafc", null), list("Yes", "No", "Cancel"))
	if(send_notice != "Yes" && send_notice != "No")
		return

	//log/message
	to_chat(usr, LANG("mob.475662c7850baee0", list(src)))
	log_admin("[key_name(usr)] has put [key_name(src)] into a cryopod.")
	var/msg = span_notice("[key_name_admin(usr)] has put [key_name(src)] into a cryopod from [ADMIN_VERBOSEJMP(src)].")
	message_admins(msg)
	admin_ticket_log(src, msg)

	send_notice = send_notice == "Yes"
	send_to_cryo(send_notice)

/**
 * Overrides someones mob with their loaded prefs.
 */
/mob/proc/vv_load_prefs()
	if(!check_rights(R_ADMIN))
		return

	if(!client)
		to_chat(usr, span_warning(LANG("mob.769f0d87c8accbd8", null)))
		return

	if(!ishuman(src))
		to_chat(usr, span_warning(LANG("mob.b2b10715f4cc873e", null)))
		return

	var/notice = tgui_alert(usr, LANG("mob.3673dd5685216238", null), LANG("mob.927b06df5b80408a", null), list("Yes", "No"))
	if(notice != "Yes")
		return
	var/quirks_prompt = tgui_alert(usr, LANG("mob.789bc677652cf2bf", null), LANG("mob.16869b6546b2e43e", null), list("Yes", "No"))

	var/mob/living/carbon/human/human_mob = src
	human_mob.dna.mutant_bodyparts = list()
	human_mob.dna.species.regenerate_organs(src, replace_current = TRUE)
	client?.prefs?.apply_prefs_to(src, icon_updates = FALSE)
	human_mob.dna.update_body_size()
	human_mob.update_body(is_creating = TRUE)
	if(quirks_prompt == "Yes")
		human_mob.cleanse_quirk_datums()
		SSquirks.AssignQuirks(src, client)
	SEND_SIGNAL(human_mob, COMSIG_HUMAN_CHARACTER_SETUP_FINISHED)
	var/msg = span_notice("[key_name_admin(usr)] has loaded [key_name(src)]'s preferences onto their current mob [ADMIN_VERBOSEJMP(src)].")
	message_admins(msg)
	admin_ticket_log(src, msg)
