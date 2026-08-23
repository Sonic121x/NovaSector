/obj/item/circuitboard/machine/radiocarbon_spectrometer
	name = "Radiocarbon spectrometer"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/radiocarbon_spectrometer
	req_components = list(
		/datum/stock_part/scanning_module = 4,
		/obj/item/reagent_containers/cup/beaker = 1,
		/obj/item/stack/sheet/glass = 1,
	)

/obj/machinery/radiocarbon_spectrometer
	name = "Radiocarbon spectrometer"
	desc = "A specialised, complex scanner for gleaning information on all manner of small things."
	anchored = TRUE
	density = TRUE
	icon = 'modular_nova/modules/xenoarchartifacts/icons/machinery.dmi'
	icon_state = "spectrometer"

	circuit = /obj/item/circuitboard/machine/radiocarbon_spectrometer

	use_power = IDLE_POWER_USE // 1 = idle, 2 = active
	idle_power_usage = 20
	active_power_usage = 3000
	// Are we scanning right now?
	var/scanning = FALSE
	// Sample of the rock we need to scan
	var/obj/item/xenoarch/core_sampler/current_sample

/obj/machinery/radiocarbon_spectrometer/crowbar_act(mob/living/user, obj/item/tool)
	return default_deconstruction_crowbar(user, tool)

/obj/machinery/radiocarbon_spectrometer/screwdriver_act(mob/living/user, obj/item/tool)
	return default_pry_open(user, tool, close_after_pry = FALSE, open_density = FALSE, closed_density = TRUE, deconstruct_on_fail = TRUE)

/obj/machinery/radiocarbon_spectrometer/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/xenoarch/core_sampler))
		balloon_alert(user, LANG("obj.5dd22dfe91643255", null))
		return NONE

	var/obj/item/xenoarch/core_sampler/sampler = tool
	if(!powered())
		return ITEM_INTERACT_BLOCKING
	if(scanning)
		to_chat(user, span_notice(LANG("obj.94a8d0b1f9654b58", null)))
		return ITEM_INTERACT_BLOCKING
	if(!sampler.sample)
		balloon_alert(user, LANG("obj.d1e936e56992af60", null))
		return ITEM_INTERACT_BLOCKING
	if(!user.transferItemToLoc(sampler, src))
		to_chat(user, span_warning(LANG("obj.0d10df9a93e1dd55", list(sampler))))
		return ITEM_INTERACT_BLOCKING
	current_sample = sampler
	scanning = TRUE
	user.visible_message(
		span_notice(LANG("obj.05c6f8cadd77b915", list(user, sampler, src))),
		span_notice(LANG("obj.8ce99939bf01b695", list(sampler, src))),
		blind_message = span_notice(LANG("obj.0e0002b3a4e16270", null)),
	)
	process_sample()
	return ITEM_INTERACT_SUCCESS

/**
 * Tries to process inserted geosample.
 * Takes 10 seconds.
 */
/obj/machinery/radiocarbon_spectrometer/proc/process_sample()
	var/data = ""
	if(powered())
		update_use_power(ACTIVE_POWER_USE)
		icon_state = "spectrometer_processing"
		var/obj/structure/boulder/current_boulder = current_sample.sample
		var/age = current_boulder.artifact_age
		data = "Mundane object (archaic xenos origins)<br>"
		data += "<B>Spectometric analysis on mineral sample has determined type of required field: [current_boulder.artifact_stabilizing_field]</B><BR>"
		data += "<HR>"
		if (age > 1000000000)
			data += " - Radiometric dating shows age of approximate [round(age/1000000000)] billion years<br>"
		else if (age > 1000000)
			data += " - Radiometric dating shows age of approximate [round(age/1000000)] million years<br>"
		else
			data += " - Radiometric dating shows age of approximate [round(age/1000)] thousand years<br>"
		data += " - Hyperspectral imaging reveals exotic energy wavelength detected with ID: [current_boulder.artifact_id]<br>"
		sleep(10 SECONDS)
	else
		fail_scan()
		return
	if(powered()) // Double check if still powered after sleep
		var/obj/item/paper/artifact_info/artifact_report = new(get_turf(src))
		artifact_report.name = "[src] report"
		artifact_report.add_raw_text(data)
		artifact_report.update_icon()
		var/obj/item/stamp/granted/our_stamp = new
		var/stamp_data = our_stamp.get_writing_implement_details()
		artifact_report.add_stamp(stamp_data["stamp_class"], rand(0, 300), rand(0, 400), rand(0, 360), stamp_data["stamp_icon_state"])
		playsound(src, 'sound/machines/printer.ogg', 25, FALSE)
		scanning = FALSE
		icon_state = "spectrometer"
		update_use_power(IDLE_POWER_USE)
	else
		fail_scan()

/**
 * Used in process() to fail the scan
 */
/obj/machinery/radiocarbon_spectrometer/proc/fail_scan()
	qdel(current_sample)
	current_sample = NONE
	scanning = FALSE
	icon_state = "spectrometer"
	update_use_power(IDLE_POWER_USE)
	visible_message(
		span_warning(LANG("obj.87273db5518a02ed", list(src))),
		blind_message = span_warning(LANG("obj.b29110a7c0096f42", null)),
	)
