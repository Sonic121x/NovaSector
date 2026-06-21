/datum/buildmode_mode/delete
	key = "delete"

/datum/buildmode_mode/delete/show_help(client/builder)
	to_chat(builder, span_purple(boxed_message(
		"[span_bold("Delete an object")] -> Left Mouse Button on obj/turf/mob\n\
		[span_bold("Delete all objects of a type")] -> Right Mouse Button on obj/turf/mob"))
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
			var/action_type = tgui_alert(usr,"严格类型 ([deleting.type]) 还是类型及其所有子类型？",,list("Strict type","Type and subtypes","Cancel"))
			if(action_type == "Cancel" || !action_type)
				return

			if(tgui_alert(usr,"你确定要删除所有类型为 [deleting.type] 的实例吗？",,list("Yes","No")) != "Yes")
				return

			if(tgui_alert(usr,"需要二次确认。删除吗？",,list("Yes","No")) != "Yes")
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
						to_chat(usr, "不存在此类型的实例")
						return
					log_admin("[key_name(usr)] deleted all instances of type [O_type] ([i] instances deleted) ")
					message_admins(span_notice("[key_name(usr)] 删除了所有类型为 [O_type] 的实例（已删除 [i] 个实例）"))
				if("Type and subtypes")
					var/i = 0
					for(var/Obj in world)
						if(istype(Obj,O_type))
							i++
							qdel(Obj)
						CHECK_TICK
					if(!i)
						to_chat(usr, "不存在此类型的实例")
						return
					log_admin("[key_name(usr)] deleted all instances of type or subtype of [O_type] ([i] instances deleted) ")
					message_admins(span_notice("[key_name(usr)] 删除了所有类型为 [O_type] 或其子类型的实例（已删除 [i] 个实例）"))
