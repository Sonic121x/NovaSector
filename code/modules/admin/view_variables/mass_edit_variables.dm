// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/client/proc/cmd_mass_modify_object_variables(datum/target, var_name)
	if(tgui_alert(src, LANG("client.06906caab9c685c2", list(var_name)), LANG("client.0b1b237ab8187726", null), list("Yes", "No"), 60 SECONDS) != "Yes")
		return

	if(!check_rights(R_VAREDIT))
		return

	/// if false get only the strict type, get all subtypes too otherwise
	var/strict_type = FALSE
	if(target?.type)
		strict_type = vv_subtype_prompt(target.type)

	massmodify_variables(target, var_name, strict_type)
	BLACKBOX_LOG_ADMIN_VERB("Mass Edit Variables")

/client/proc/massmodify_variables(datum/target, var_name = "", strict_type = FALSE)
	if(!check_rights(R_VAREDIT))
		return
	if(!istype(target))
		return

	var/variable = ""
	if(!var_name)
		var/list/names = list()
		for (var/V in target.vars)
			names += V

		names = sort_list(names)

		variable = input(src, LANG("client.3e95c4ff429965ba", null), LANG("client.61b9a9e107dedb8a", null)) as null|anything in names
	else
		variable = var_name

	if(!variable || !target.can_vv_get(variable))
		return
	var/default
	var/var_value = target.vars[variable]

	if(variable in GLOB.VVckey_edit)
		to_chat(src, LANG("client.76436c0550001696", null), confidential = TRUE)
		return
	if(variable in GLOB.VVlocked)
		if(!check_rights(R_DEBUG))
			return
	if(variable in GLOB.VVicon_edit_lock)
		if(!check_rights(R_FUN|R_DEBUG))
			return
	if(variable in GLOB.VVpixelmovement)
		if(!check_rights(R_DEBUG))
			return
		var/prompt = tgui_alert(src, LANG("client.5cf56dd35eaedcb0", null), LANG("client.3be55d75e081d250", null), list("ABORT ", "Continue", " ABORT"))
		if (prompt != "Continue")
			return

	default = vv_get_class(variable, var_value)

	if(isnull(default))
		to_chat(src, LANG("client.79202fb969bb1d48", null), confidential = TRUE)
	else
		to_chat(src, LANG("client.a7b53abf28e579ff", list(uppertext(default))), confidential = TRUE)

	to_chat(src, LANG("client.34502e1ef4fb1bcd", list(var_value)), confidential = TRUE)

	if(default == VV_NUM)
		var/dir_text = ""
		if(var_value > 0 && var_value < 16)
			if(var_value & 1)
				dir_text += "NORTH"
			if(var_value & 2)
				dir_text += "SOUTH"
			if(var_value & 4)
				dir_text += "EAST"
			if(var_value & 8)
				dir_text += "WEST"

		if(dir_text)
			to_chat(src, LANG("client.091219d656be7f8b", list(dir_text)), confidential = TRUE)

	var/value = vv_get_value(default_class = default)
	var/new_value = value["value"]
	var/class = value["class"]

	if(!class || !new_value == null && class != VV_NULL)
		return

	if (class == VV_MESSAGE)
		class = VV_TEXT

	if (value["type"])
		class = VV_NEW_TYPE

	var/original_name = "[target]"

	var/rejected = 0
	var/accepted = 0

	switch(class)
		if(VV_RESTORE_DEFAULT)
			to_chat(src, LANG("client.a7b247d92e8a93aa", null), confidential = TRUE)
			var/list/items = get_all_of_type(target.type, strict_type)
			to_chat(src, LANG("client.21c9b9eb3c7c7f2e", list(items.len)), confidential = TRUE)
			for(var/thing in items)
				if (!thing)
					continue
				var/datum/D = thing
				if (D.vv_edit_var(variable, initial(D.vars[variable])) != FALSE)
					accepted++
				else
					rejected++
				CHECK_TICK

		if(VV_TEXT)
			var/list/varsvars = vv_parse_text(target, new_value)
			var/pre_processing = new_value
			var/unique
			if (varsvars?.len)
				unique = tgui_alert(src, LANG("client.88c860f0da81b40d", null), LANG("client.e6e5f425560e12ac", null), list("Unique", "Same"))
				if(unique == "Unique")
					unique = TRUE
				else
					unique = FALSE
					for(var/V in varsvars)
						new_value = replacetext(new_value,"\[[V]]","[target.vars[V]]")

			to_chat(src, LANG("client.a7b247d92e8a93aa", null), confidential = TRUE)
			var/list/items = get_all_of_type(target.type, strict_type)
			to_chat(src, LANG("client.21c9b9eb3c7c7f2e", list(items.len)), confidential = TRUE)
			for(var/thing in items)
				if (!thing)
					continue
				var/datum/D = thing
				if(unique)
					new_value = pre_processing
					for(var/V in varsvars)
						new_value = replacetext(new_value,"\[[V]]","[D.vars[V]]")

				if (D.vv_edit_var(variable, new_value) != FALSE)
					accepted++
				else
					rejected++
				CHECK_TICK

		if (VV_NEW_TYPE)
			var/many = tgui_alert(src, LANG("client.c1d2934a4d32155b", list(value["type"])), LANG("client.93ccb9665aa46d50", null), list("One", "Many", "Cancel"))
			if (many == "Cancel")
				return
			if (many == "Many")
				many = TRUE
			else
				many = FALSE

			var/type = value["type"]
			to_chat(src, LANG("client.a7b247d92e8a93aa", null), confidential = TRUE)
			var/list/items = get_all_of_type(target.type, strict_type)
			to_chat(src, LANG("client.21c9b9eb3c7c7f2e", list(items.len)), confidential = TRUE)
			for(var/thing in items)
				if (!thing)
					continue
				var/datum/D = thing
				if(many && !new_value)
					new_value = new type()

				if (D.vv_edit_var(variable, new_value) != FALSE)
					accepted++
				else
					rejected++
				new_value = null
				CHECK_TICK

		else
			to_chat(src, LANG("client.a7b247d92e8a93aa", null), confidential = TRUE)
			var/list/items = get_all_of_type(target.type, strict_type)
			to_chat(src, LANG("client.21c9b9eb3c7c7f2e", list(items.len)), confidential = TRUE)
			for(var/thing in items)
				if (!thing)
					continue
				var/datum/D = thing
				if (D.vv_edit_var(variable, new_value) != FALSE)
					accepted++
				else
					rejected++
				CHECK_TICK


	var/count = rejected+accepted
	if (!count)
		to_chat(src, LANG("client.dd4402fa68ef5460", null), confidential = TRUE)
		return
	if (!accepted)
		to_chat(src, LANG("client.b982b249f935d101", null), confidential = TRUE)
		return
	if (rejected)
		to_chat(src, LANG("client.2c4cc3ffd1445ae5", list(rejected, count)), confidential = TRUE)

	log_world("### MassVarEdit by [src]: [target.type] (A/R [accepted]/[rejected]) [variable]=[html_encode("[target.vars[variable]]")]([list2params(value)])")
	log_admin("[key_name(src)] mass modified [original_name]'s [variable] to [target.vars[variable]] ([accepted] objects modified)")
	message_admins("[key_name_admin(src)] mass modified [original_name]'s [variable] to [target.vars[variable]] ([accepted] objects modified)")

//not using global lists as vv is a debug function and debug functions should rely on as less things as possible.
/proc/get_all_of_type(T, subtypes = TRUE)
	var/list/typecache = list()
	typecache[T] = 1
	if (subtypes)
		typecache = typecacheof(typecache)
	. = list()
	if (ispath(T, /mob))
		for(var/mob/thing in world)
			if (typecache[thing.type])
				. += thing
			CHECK_TICK

	else if (ispath(T, /obj/machinery/door))
		for(var/obj/machinery/door/thing in world)
			if (typecache[thing.type])
				. += thing
			CHECK_TICK

	else if (ispath(T, /obj/machinery))
		for(var/obj/machinery/thing in world)
			if (typecache[thing.type])
				. += thing
			CHECK_TICK

	else if (ispath(T, /obj/item))
		for(var/obj/item/thing in world)
			if (typecache[thing.type])
				. += thing
			CHECK_TICK

	else if (ispath(T, /obj))
		for(var/obj/thing in world)
			if (typecache[thing.type])
				. += thing
			CHECK_TICK

	else if (ispath(T, /atom/movable))
		for(var/atom/movable/thing in world)
			if (typecache[thing.type])
				. += thing
			CHECK_TICK

	else if (ispath(T, /turf))
		for(var/turf/thing in world)
			if (typecache[thing.type])
				. += thing
			CHECK_TICK

	else if (ispath(T, /atom))
		for(var/atom/thing in world)
			if (typecache[thing.type])
				. += thing
			CHECK_TICK

	else if (ispath(T, /client))
		for(var/client/thing in GLOB.clients)
			if (typecache[thing.type])
				. += thing
			CHECK_TICK

	else if (ispath(T, /datum))
		for(var/datum/thing)
			if (typecache[thing.type])
				. += thing
			CHECK_TICK

	else
		for(var/datum/thing in world)
			if (typecache[thing.type])
				. += thing
			CHECK_TICK
