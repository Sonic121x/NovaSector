#define WIRE_VENT_DIRECTION "Vent Direction"
#define WIRE_VENT_POWER "Vent Power"
#define WIRE_TAMPER "Tamper"

/datum/wires/rbmk2
	holder_type = /obj/machinery/power/rbmk2
	proper_name = "RB-MK2"

/datum/wires/rbmk2/New(atom/holder)
	wires = list(
		WIRE_OVERCLOCK,
		WIRE_ACTIVATE,
		WIRE_THROW,
		WIRE_VENT_POWER,
		WIRE_VENT_DIRECTION,
		WIRE_SAFETY,
		WIRE_LIMIT,
		WIRE_POWER,
		WIRE_TAMPER,
	)
	. = ..()

/datum/wires/rbmk2/emp_pulse()
	return TRUE //Handled already in the RBMK.

/datum/wires/rbmk2/interactable(mob/user)
	if(!..())
		return FALSE
	var/obj/machinery/power/rbmk2/machine = holder
	return machine.panel_open

/datum/wires/rbmk2/get_status()
	var/obj/machinery/power/rbmk2/machine = holder
	. = list()
	. += LANG("datum.50637ffafedc0b84", list(machine.power && machine.powernet ? "yellow" : "off"))
	. += LANG("datum.3e1ae9d681719f9a", list(machine.stored_rod ? "purple" : "off"))
	. += LANG("datum.0b8d503ccae7f5b4", list(machine.active ? "green" : "off"))
	. += LANG("datum.2c3bcfb8d9293d5f", list(machine.safety ? "blue" : "flashing red"))
	if(machine.vent_reverse_direction)
		. += LANG("datum.1c191eb5e95e03ba", list(machine.venting ? "flashing orange and white" : "flashing red"))
	else
		. += LANG("datum.1c191eb5e95e03ba", list(machine.venting ? "green" : "flashing red"))
	. += LANG("datum.52a85cc663285d34", list(machine.overclocked ? "blinking blue" : "off"))
	. += LANG("datum.a1d8dfbf08869f94", list(machine.cooling_limiter))
	. += LANG("datum.230eb30ac5842bfc", list(machine.tampered ? "flashing red" : "green"))

/datum/wires/rbmk2/on_pulse(wire, user)
	var/obj/machinery/power/rbmk2/machine = holder
	switch(wire)
		if(WIRE_OVERCLOCK)
			machine.overclocked = !machine.overclocked
		if(WIRE_ACTIVATE)
			machine.toggle_active(user)
		if(WIRE_THROW)
			machine.remove_rod(user, do_throw = TRUE)
		if(WIRE_VENT_POWER)
			machine.toggle_vents(user)
			machine.shock(user, 0.125)
		if(WIRE_VENT_DIRECTION)
			machine.toggle_reverse_vents(user)
		if(WIRE_SAFETY)
			machine.toggle_active(user, FALSE)
		if(WIRE_LIMIT)
			machine.cooling_limiter = (machine.cooling_limiter + 10) % (machine.cooling_limiter_max+10)
		if(WIRE_POWER)
			machine.shock(user, 0.5)
		if(WIRE_TAMPER)
			machine.tampered = TRUE

/datum/wires/rbmk2/on_cut(wire, mend, source)
	var/obj/machinery/power/rbmk2/machine = holder
	switch(wire)
		if(WIRE_OVERCLOCK)
			if(mend)
				machine.overclocked = FALSE
		if(WIRE_ACTIVATE)
			machine.toggle_active(source, mend)
		if(WIRE_THROW)
			if(mend)
				machine.remove_rod(source, do_throw = TRUE)
		if(WIRE_VENT_POWER)
			machine.toggle_vents(source, mend)
			machine.shock(source, 0.25)
		if(WIRE_VENT_DIRECTION)
			if(mend)
				machine.toggle_reverse_vents(source, FALSE)
		if(WIRE_SAFETY)
			machine.safety = mend
			if(!mend)
				var/turf/machine_turf = get_turf(machine)
				if(isliving(source))
					var/mob/living/living_source = source
					message_admins("[src] had the safety wire cut by [ADMIN_LOOKUPFLW(source)] at [ADMIN_VERBOSEJMP(machine_turf)].")
					living_source.log_message("cut the safety wire of [machine]", LOG_GAME)
					machine.investigate_log("had the safety wire cut by [key_name(source)] at [AREACOORD(machine)].", INVESTIGATE_ENGINE)
				else
					message_admins("[src] had the safety wire cut at [ADMIN_VERBOSEJMP(machine_turf)]")
					log_game("[src] had the safety wire cut at [AREACOORD(machine_turf)]")
					machine.investigate_log("had the safety wire cut at [AREACOORD(machine_turf)]", INVESTIGATE_ENGINE)
		if(WIRE_LIMIT)
			machine.cooling_limiter = mend ? initial(machine.cooling_limiter) : 0
		if(WIRE_POWER)
			machine.power = mend
			if(!mend)
				var/turf/machine_turf = get_turf(machine)
				if(isliving(source))
					var/mob/living_source = source
					message_admins("[src] had the power wire cut by [ADMIN_LOOKUPFLW(source)] at [ADMIN_VERBOSEJMP(machine_turf)].")
					living_source.log_message("cut the power wire of [machine]", LOG_GAME)
					machine.investigate_log("had the power wire cut by [key_name(source)] at [AREACOORD(machine)].", INVESTIGATE_ENGINE)
				else
					message_admins("[src] had the power wire cut at [ADMIN_VERBOSEJMP(machine_turf)]")
					log_game("[src] had the power wire cut at [AREACOORD(machine_turf)]")
					machine.investigate_log("had the power wire cut at [AREACOORD(machine_turf)]", INVESTIGATE_ENGINE)
			machine.shock(source, 100)
		if(WIRE_TAMPER)
			machine.tampered = TRUE

/datum/wires/rbmk2/can_reveal_wires(mob/user)
	if(HAS_TRAIT(user, TRAIT_KNOW_ENGI_WIRES))
		return TRUE
	return ..()

#undef WIRE_VENT_DIRECTION
#undef WIRE_VENT_POWER
#undef WIRE_TAMPER
