// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
#define STATE_SORTING "sorting"
#define STATE_IDLE "idle"
#define STATE_YES "yes"
#define STATE_NO "no"
#define MAIL_CAPACITY 100

/obj/machinery/mailsorter
	name = "mail sorter"
	desc = "A large mail sorting unit. Sorting mail since 1987!"
	icon = 'icons/obj/machines/mailsorter.dmi'
	icon_state = "mailsorter"
	base_icon_state = "mailsorter"
	layer = BELOW_OBJ_LAYER
	density = TRUE
	max_integrity = 300
	integrity_failure = 0.33
	circuit = /obj/item/circuitboard/machine/mailsorter

	var/light_mask = "mailsorter-light-mask"
	var/panel_type = "panel"

	/// What the machine is currently doing. Can be "sorting", "idle", "yes", "no".
	var/currentstate = STATE_IDLE
	/// List of all mail that's inside the mailbox.
	var/list/mail_list = list()
	/// The direction in which the mail will be unloaded.
	var/output_dir = SOUTH
	/// List of the departments to sort the mail for.
	var/static/list/sorting_departments = list(
		DEPARTMENT_ENGINEERING,
		DEPARTMENT_SECURITY,
		DEPARTMENT_MEDICAL,
		DEPARTMENT_SCIENCE,
		DEPARTMENT_CARGO,
		DEPARTMENT_SERVICE,
		DEPARTMENT_COMMAND,
	)
	var/static/list/choices = list(
		"Eject" = icon('icons/hud/radial.dmi', "radial_eject"),
		"Dump" = icon('icons/hud/radial.dmi', "mail_dump"),
		"Sort" = icon('icons/hud/radial.dmi', "mail_sort"),
	)

/// Steps one tile in the `output_dir`. Returns `turf`.
/obj/machinery/mailsorter/proc/get_unload_turf()
	return get_step(src, output_dir)

/// Opening the maintenance panel.
/obj/machinery/mailsorter/screwdriver_act(mob/living/user, obj/item/tool)
	return default_deconstruction_screwdriver(user, tool)

/// Deconstructing the mail sorter.
/obj/machinery/mailsorter/crowbar_act(mob/living/user, obj/item/tool)
	return default_deconstruction_crowbar(user, tool)

/obj/machinery/mailsorter/examine(mob/user)
	. = ..()
	. += span_notice(LANG("obj.bae2cc1d", list(length(mail_list) < 100 ? " " : " no more ", length(mail_list) < 100 ? "[100 - length(mail_list)] " : "")))
	. += span_notice(LANG("obj.bf9945c3", list(length(mail_list) >= 2 ? "are" : "is", length(mail_list) ? length(mail_list) : "no")))
	if(panel_open)
		. += span_notice(LANG("obj.5da71edf", null))

/obj/machinery/mailsorter/Destroy()
	QDEL_LIST(mail_list)
	. = ..()

/obj/machinery/mailsorter/on_deconstruction(disassembled)
	drop_all_mail()
	. = ..()

/// Drops all enevlopes on the machine turf.
/obj/machinery/mailsorter/proc/drop_all_mail()
	if(!isturf(get_turf(src)))
		QDEL_LIST(mail_list)
		return
	for(var/obj/item/mail in mail_list)
		mail.forceMove(src)
		mail_list -= mail

/// Dumps all envelopes on the `unload_turf`.
/obj/machinery/mailsorter/proc/dump_all_mail()
	if(!isturf(get_turf(src)))
		QDEL_LIST(mail_list)
		return
	var/turf/unload_turf = get_unload_turf()
	for(var/obj/item/mail in mail_list)
		mail.forceMove(unload_turf)
		mail.throw_at(unload_turf, 2, 3)
		mail_list -= mail

/// Validates whether the inserted item is acceptable.
/obj/machinery/mailsorter/proc/accept_check(obj/item/weapon)
	var/static/list/accepted_items = list(
		/obj/item/mail,
		/obj/item/paper,
	)
	return is_type_in_list(weapon, accepted_items)

/obj/machinery/mailsorter/interact(mob/user)
	if (currentstate != STATE_IDLE)
		return
	if (length(mail_list) == 0)
		to_chat(user, span_warning(LANG("obj.751f0dcf", null)))
		return
	var/choice = show_radial_menu(
		user,
		src,
		choices,
		require_near = !HAS_SILICON_ACCESS(user),
		autopick_single_option = FALSE,
	)
	if (!choice)
		return
	switch (choice)
		if ("Eject")
			pick_mail(user)
		if ("Dump")
			playsound(src, 'sound/machines/buzz/buzz-sigh.ogg', 20, TRUE)
			to_chat(user, span_notice(LANG("obj.64363dbe", list(src, length(mail_list)))))
			dump_all_mail()
		if ("Sort")
			sort_mail(user)

/// Prompts the player to select a department to sort the mail for. Returns if `null`.
/obj/machinery/mailsorter/proc/sort_mail(mob/user)
	var/sorting_dept = tgui_input_list(user, LANG("obj.5e061e26", null),LANG("obj.5a388381", null), sorting_departments)
	if (!sorting_dept)
		return
	currentstate = STATE_SORTING
	update_appearance(UPDATE_OVERLAYS)
	playsound(src, 'sound/machines/mail_sort.ogg', 20, TRUE)
	addtimer(CALLBACK(src, PROC_REF(continue_sort), user, sorting_dept), 5 SECONDS)

/// Sorts the mail based on the picked department. Ejects the sorted envelopes onto the `unload_turf`.
/obj/machinery/mailsorter/proc/continue_sort(mob/user, sorting_dept)
	var/list/sorted_mail = list()
	var/total_to_sort = length(mail_list)
	var/sorted = 0
	var/unable_to_sort = 0

	for (var/obj/item/mail/some_mail in mail_list)
		if (!some_mail.recipient_ref)
			unable_to_sort ++
			continue
		var/datum/mind/some_recipient = some_mail.recipient_ref.resolve()
		if (some_recipient)
			var/datum/job/recipient_job = some_recipient.assigned_role
			var/datum/job_department/primary_department = recipient_job.departments_list?[1]
			if (primary_department == null)	// permabrig is temporary, tide is forever
				unable_to_sort ++
			else
				var/datum/job_department/main_department = primary_department.department_name
				if (main_department == sorting_dept)
					sorted_mail.Add(some_mail)
					sorted ++
		else
			unable_to_sort ++
	if (length(sorted_mail) == 0)
		currentstate = STATE_NO
		update_appearance(UPDATE_OVERLAYS)
		playsound(src, 'sound/machines/buzz/buzz-sigh.ogg', 20, TRUE)
		say(LANG("obj.e75ca099", list(sorting_dept)))
	else
		currentstate = STATE_YES
		update_appearance(UPDATE_OVERLAYS)
		say(LANG("obj.4259f688", list(sorted)))
		playsound(src, 'sound/machines/ping.ogg', 20, TRUE)
		to_chat(user, span_notice(LANG("obj.d0480b16", list(src, length(sorted_mail)))))
		var/turf/unload_turf = get_unload_turf()
		for (var/obj/item/mail/mail_in_list in sorted_mail)
			mail_in_list.forceMove(unload_turf)
			sorted_mail -= mail_in_list
			mail_list -= mail_in_list
	addtimer(CALLBACK(src, PROC_REF(check_sorted), unable_to_sort, total_to_sort), 1 SECONDS)

/// Informs the player of the amount of processed envelopes.
/obj/machinery/mailsorter/proc/check_sorted(mob/user, unable_to_sort, total_to_sort)
	if (unable_to_sort > 0)
		playsound(src, 'sound/machines/buzz/buzz-sigh.ogg', 20, TRUE)
		say(LANG("obj.e8768631", list(unable_to_sort)))
	else
		playsound(src, 'sound/machines/ping.ogg', 20, TRUE)
		say(LANG("obj.946bdc1b", list(total_to_sort)))
	addtimer(CALLBACK(src, PROC_REF(update_state_after_sorting)), 1 SECONDS)

/obj/machinery/mailsorter/proc/update_state_after_sorting()
	currentstate = STATE_IDLE
	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/mailsorter/item_interaction(mob/user, obj/item/thingy, params)
	if (istype(thingy, /obj/item/storage/bag/mail))
		if (length(thingy.contents) < 1)
			to_chat(user, span_warning(LANG("obj.cd703f63", list(thingy))))
			return
		var/loaded = 0
		for (var/obj/item/mail in thingy.contents)
			if (!(mail.item_flags & ABSTRACT) && \
				!(mail.flags_1 & HOLOGRAM_1) && \
				accept_check(mail) \
			)
				if (length(mail_list) + 1 > MAIL_CAPACITY )
					to_chat(user, span_warning(LANG("obj.9f7179a1", list(src))))
					return FALSE
				else if (load(mail, user))
					loaded++
					mail_list += mail
		if(loaded)
			user.visible_message(span_notice(LANG("obj.d8b0a4dd", list(user, src, thingy))), \
			span_notice(LANG("obj.ae0abc0e", list(src, thingy))))
			if(length(thingy.contents))
				to_chat(user, span_warning(LANG("obj.94d8d593", null)))
			return TRUE
		else
			to_chat(user, span_warning(LANG("obj.49073a2c", list(thingy, src))))
			return FALSE
	else if (istype(thingy, /obj/item/mail))
		if (length(mail_list) + 1 > MAIL_CAPACITY )
			to_chat(user, span_warning(LANG("obj.9f7179a1", list(src))))
		else
			thingy.forceMove(src)
			mail_list += thingy
			to_chat(user, span_notice(LANG("obj.da36cc96", list(src, thingy))))

/// Prompts the user to select an anvelope from the list of all the envelopes inside.
/obj/machinery/mailsorter/proc/pick_mail(mob/user)
	if(!length(mail_list))
		return
	var/obj/item/mail/mail_throw = tgui_input_list(user, LANG("obj.3d130988", null),LANG("obj.5a388381", null), mail_list)
	if(!mail_throw)
		return
	currentstate = STATE_SORTING
	update_appearance(UPDATE_OVERLAYS)
	playsound(src, 'sound/machines/mail_sort.ogg', 20, TRUE)
	addtimer(CALLBACK(src, PROC_REF(pick_envelope), user, mail_throw), 50)

/// Ejects a single envelope the player has picked onto the `unload_turf`.
/obj/machinery/mailsorter/proc/pick_envelope(mob/user, obj/item/mail/mail_throw)
	to_chat(user, span_notice(LANG("obj.149b11dd", list(src, mail_throw))))
	var/turf/unload_turf = get_unload_turf()
	mail_throw.forceMove(unload_turf)
	mail_throw.throw_at(unload_turf, 2, 3)
	mail_list -= mail_throw
	currentstate = STATE_IDLE
	update_appearance(UPDATE_OVERLAYS)

/// Tries to load something into the machine.
/obj/machinery/mailsorter/proc/load(obj/item/thingy, mob/user)
	if(ismob(thingy.loc))
		var/mob/owner = thingy.loc
		if(!owner.transferItemToLoc(thingy, src))
			to_chat(owner, span_warning(LANG("obj.e235f1cb", list(thingy, src))))
			return FALSE
		return TRUE
	else
		if(thingy.loc.atom_storage)
			return thingy.loc.atom_storage.attempt_remove(thingy, src, silent = TRUE)
		else
			thingy.forceMove(src)
			return TRUE

/obj/machinery/mailsorter/click_alt(mob/living/user)
	if(!panel_open)
		return CLICK_ACTION_BLOCKING
	output_dir = turn(output_dir, -90)
	to_chat(user, span_notice(LANG("obj.73016afe", list(src, dir2text(output_dir)))))
	update_appearance(UPDATE_OVERLAYS)
	return CLICK_ACTION_SUCCESS


/obj/machinery/mailsorter/update_overlays()
	. = ..()
	if(!powered())
		return
	if(!(machine_stat & BROKEN))
		var/image/mail_output = image(icon='icons/obj/doors/airlocks/station/overlays.dmi', icon_state="unres_[output_dir]")
		switch(output_dir)
			if(NORTH)
				mail_output.pixel_z = 32
			if(SOUTH)
				mail_output.pixel_z = -32
			if(EAST)
				mail_output.pixel_w = 32
			if(WEST)
				mail_output.pixel_w = -32
		mail_output.color = COLOR_CRAYON_ORANGE
		var/mutable_appearance/light_out = emissive_appearance(mail_output.icon, mail_output.icon_state, offset_spokesman = src, alpha = mail_output.alpha)
		light_out.pixel_z = mail_output.pixel_z
		light_out.pixel_w = mail_output.pixel_w
		. += mail_output
		. += light_out
		. += mutable_appearance(base_icon_state, currentstate)
	if(panel_open)
		. += panel_type
	if(light_mask && !(machine_stat & BROKEN))
		. += emissive_appearance(icon, light_mask, src)

/obj/machinery/mailsorter/update_icon_state()
	icon_state = "[base_icon_state][(powered() && !panel_open) ? null : "-off"]"
	if(machine_stat & BROKEN)
		icon_state = "[base_icon_state]-broken"
	return ..()

#undef STATE_SORTING
#undef STATE_IDLE
#undef STATE_YES
#undef STATE_NO
#undef MAIL_CAPACITY
