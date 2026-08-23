// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/buildmode_mode/delete
	key = "delete"

/datum/buildmode_mode/delete/show_help(client/builder)
	to_chat(builder, span_purple(boxed_message(
		LANG("datum.787f353bc0a86d8d", list(span_bold("Delete an object"), span_bold("Delete all objects of a type")))))
	)

/datum/buildmode_mode/delete/handle_click(client/c, params, object)
	var/list/modifiers = params2list(params)

	if(LAZYACCESS(modifiers, LEFT_CLICK))
		if(isturf(object))
			var/turf/T = object
			T.ScrapeAway(flags = CHANGETURF_INHERIT_AIR)
		else if(isatom(object))
			// NOVA EDIT ADDITION START -- optional bluespace sparks on delete
			if(c.prefs.read_preference(/datum/preference/toggle/admin/delete_sparks))
				do_admin_sparks(10, TRUE, object) // non-interactive sparks
			// NOVA EDIT ADDITION END
			qdel(object)

	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		if(check_rights(R_DEBUG|R_SERVER)) //Prevents buildmoded non-admins from breaking everything.
			if(isturf(object))
				return
			var/atom/deleting = object
			var/action_type = tgui_alert(usr,LANG("datum.68e254d380f2e571", list(deleting.type)),,list("Strict type","Type and subtypes","Cancel"))
			if(action_type == "Cancel" || !action_type)
				return

			if(tgui_alert(usr,LANG("datum.8a97a2c8ee5e0d0c", list(deleting.type)),,list("Yes","No")) != "Yes")
				return

			if(tgui_alert(usr,LANG("datum.bd025aa5cea64e01", null),,list("Yes","No")) != "Yes")
				return

			var/O_type = deleting.type
			switch(action_type)
				if("Strict type")
					var/i = 0
					for(var/atom/Obj in world)
						if(Obj.type == O_type)
							i++
							qdel(Obj)
						CHECK_TICK
					if(!i)
						to_chat(usr, LANG("datum.bbf7720b6714ed59", null))
						return
					log_admin("[key_name(usr)] deleted all instances of type [O_type] ([i] instances deleted) ")
					message_admins(span_notice("[key_name(usr)] deleted all instances of type [O_type] ([i] instances deleted) "))
				if("Type and subtypes")
					var/i = 0
					for(var/Obj in world)
						if(istype(Obj,O_type))
							i++
							qdel(Obj)
						CHECK_TICK
					if(!i)
						to_chat(usr, LANG("datum.bbf7720b6714ed59", null))
						return
					log_admin("[key_name(usr)] deleted all instances of type or subtype of [O_type] ([i] instances deleted) ")
					message_admins(span_notice("[key_name(usr)] deleted all instances of type or subtype of [O_type] ([i] instances deleted) "))
