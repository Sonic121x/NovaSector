
/**
 * Enables an admin to upload a new titlescreen image.
 */
ADMIN_VERB(admin_change_title_screen, R_FUN, "标题画面：更改", "Upload a new titlescreen image.", ADMIN_CATEGORY_FUN)
	log_admin("[key_name(user)] is changing the title screen.")
	message_admins("[key_name_admin(user)] is changing the title screen.")

	switch(alert(usr, LANG("datum.901865e9", null), LANG("datum.b4e55da5", null), "Change", "Reset", "Cancel"))
		if("Change")
			var/file = input(user) as icon|null
			if(!file)
				return
			SStitle.change_title_screen(file)
		if("Reset")
			SStitle.change_title_screen()
		if("Cancel")
			return

/**
 * Sets a titlescreen notice, a big red text on the main screen.
 */
ADMIN_VERB(change_title_screen_notice, R_FUN, "标题画面：设置公告", "Sets a titlescreen notice, a big red text on the main screen.", ADMIN_CATEGORY_FUN)
	log_admin("[key_name(usr)] is setting the title screen notice.")
	message_admins("[key_name_admin(usr)] is setting the title screen notice.")

	var/new_notice = input(usr, LANG("datum.3c9ed767", null), LANG("datum.5a174e20", null)) as text|null
	SStitle.set_notice(new_notice)
	if(!new_notice)
		return
	for(var/mob/dead/new_player/new_player in GLOB.new_player_list)
		to_chat(new_player, span_boldannounce(LANG("datum.e918a8a8", list(new_notice))))
		SEND_SOUND(new_player,  sound('modular_nova/modules/admin/sound/duckhonk.ogg'))

/**
 * Reloads the titlescreen if it is bugged for someone.
 */
ADMIN_VERB(fix_title_screen, R_ADMIN, "修复大厅屏幕", "Lobbyscreen broke? Press this.", ADMIN_CATEGORY_MAIN)
	if(istype(user.mob, /mob/dead/new_player))
		var/mob/dead/new_player/new_player = user.mob
		new_player.show_title_screen()
	else
		winset(src, "nova_title_browser", "is-disabled=true;is-visible=false")
		winset(src, "status_bar", "is-visible=true")

/**
 * An admin debug command that enables you to change the HTML on the go.
 */
ADMIN_VERB(change_title_screen_html, R_DEBUG, "标题画面：设置 HTML", "Change lobby screen HTML on the go.", ADMIN_CATEGORY_FUN)
	log_admin("[key_name(user)] is setting the title screen HTML.")
	message_admins("[key_name_admin(user)] is setting the title screen HTML.")

	var/new_html = input(user, LANG("datum.2ee1a063", null), LANG("datum.c18ee36f", null)) as message|null

	if(!new_html)
		return

	SStitle.title_html = new_html
	SStitle.show_title_screen()

	message_admins("[key_name_admin(user)] has changed the title screen HTML.")
