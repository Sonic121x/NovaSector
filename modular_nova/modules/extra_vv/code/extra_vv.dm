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

	var/send_notice = tgui_alert(usr, "添加一份关于将 [name] 送入低温舱的纸质通知？", "留下纸条？", list("Yes", "No", "Cancel"))
	if(send_notice != "Yes" && send_notice != "No")
		return

	//log/message
	to_chat(usr, "将 [src] 放入低温休眠舱。")
	log_admin("[key_name(usr)] has put [key_name(src)] into a cryopod.")
	var/msg = span_notice("[key_name_admin(usr)] 已将 [key_name(src)] 从 [ADMIN_VERBOSEJMP(src)] 放入低温休眠舱。")
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
		to_chat(usr, span_warning("未找到客户端！"))
		return

	if(!ishuman(src))
		to_chat(usr, span_warning("目标不是人类！"))
		return

	var/notice = tgui_alert(usr, "你确定要将客户端的当前偏好设置加载到其角色上吗？", "加载偏好设置", list("Yes", "No"))
	if(notice != "Yes")
		return
	var/quirks_prompt = tgui_alert(usr, "Reload their quirks too? This will clear any existing quirks on the mob.", "Load Quirks", list("Yes", "No"))

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
	var/msg = span_notice("[key_name_admin(usr)] 已将 [key_name(src)] 的偏好设置加载到其当前角色 [ADMIN_VERBOSEJMP(src)] 上。")
	message_admins(msg)
	admin_ticket_log(src, msg)
