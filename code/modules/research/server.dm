// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/// Default master server machine state. Use a special screwdriver to get to the next state.
#define HDD_PANEL_CLOSED 0
/// Front master server HDD panel has been removed. Use a special crowbar to get to the next state.
#define HDD_PANEL_OPEN 1
/// Master server HDD has been pried loose and is held in by only cables. Use a special set of wirecutters to finish stealing the objective.
#define HDD_PRIED 2
/// Master server HDD has been cut loose.
#define HDD_CUT_LOOSE 3
/// The ninja has blown the HDD up.
#define HDD_OVERLOADED 4

#define SERVER_NOMINAL_TEXT "Nominal"

/obj/machinery/rnd/server
	name = "\improper R&D Server"
	desc = "A computer system running a deep neural network that processes arbitrary information to produce data useable in the development of new technologies. In layman's terms, it makes research points."
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "RD-server-on"
	base_icon_state = "RD-server"
	circuit = /obj/item/circuitboard/machine/rdserver
	req_access = list(ACCESS_RD)

	/// if TRUE, we are currently operational and giving out research points.
	var/working = TRUE
	/// if TRUE, someone manually disabled us via console.
	var/research_disabled = FALSE

/obj/machinery/rnd/server/Initialize(mapload)
	. = ..()
	//servers handle techwebs differently as we are expected to be there to connect
	//every other machinery on-station.
	if(!stored_research)
		if(CONFIG_GET(flag/no_default_techweb_link))
			stored_research = new /datum/techweb
		else
			var/datum/techweb/science_web = locate(/datum/techweb/science) in SSresearch.techwebs
			connect_techweb(science_web)
	stored_research.techweb_servers |= src
	name += " [num2hex(rand(1,65535), -1)]" //gives us a random four-digit hex number as part of the name. Y'know, for fluff.

/obj/machinery/rnd/server/Destroy()
	if(stored_research)
		stored_research.techweb_servers -= src
	if(CONFIG_GET(flag/no_default_techweb_link))
		QDEL_NULL(stored_research)
	return ..()

/obj/machinery/rnd/server/update_icon_state()
	. = ..()
	if(machine_stat & NOPOWER)
		icon_state = "[base_icon_state]-off"
	else if(panel_open)
		icon_state = "[base_icon_state]-on" + "_t"
	else
		// "working" will cover EMP'd, disabled, or just broken
		icon_state = "[base_icon_state]-[working ? "on" : "halt"]"

/obj/machinery/rnd/server/power_change()
	refresh_working()
	return ..()

/obj/machinery/rnd/server/on_set_machine_stat()
	refresh_working()
	return ..()

/// Checks if we should be working or not, and updates accordingly.
/obj/machinery/rnd/server/proc/refresh_working()
	if(machine_stat & (NOPOWER|EMPED) || research_disabled)
		working = FALSE
	else
		working = TRUE

	update_current_power_usage()
	update_appearance(UPDATE_ICON_STATE)

/obj/machinery/rnd/server/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	set_machine_stat(machine_stat | EMPED)
	addtimer(CALLBACK(src, PROC_REF(fix_emp)), 60 SECONDS)
	refresh_working()

/// Callback to un-emp the server afetr some time.
/obj/machinery/rnd/server/proc/fix_emp()
	set_machine_stat(machine_stat & ~EMPED)
	refresh_working()

/// Toggles whether or not researched_disabled is, yknow, disabled
/obj/machinery/rnd/server/proc/toggle_disable(mob/user)
	research_disabled = !research_disabled
	user.log_message("[research_disabled ? "shut off" : "turned on"] [src]", LOG_GAME)
	refresh_working()

/// Gets status text based on this server's status for the computer.
/obj/machinery/rnd/server/proc/get_status_text()
	if(machine_stat & EMPED)
		return "O&F@I*$ - R3*&O$T R@U!R%D"
	else if(machine_stat & NOPOWER)
		return "Offline - Server Unpowered"
	else if(research_disabled)
		return "Offline - Server Control Disabled"
	else if(!working)
		// If, for some reason, working is FALSE even though we're not emp'd or powerless,
		// We need something to update our working state - such as rebooting the server
		return "Offline - Reboot Required"

	return SERVER_NOMINAL_TEXT

/obj/machinery/rnd/server/multitool_act(mob/living/user, obj/item/multitool/tool)
	if(!stored_research)
		return
	tool.set_buffer(stored_research)
	balloon_alert(user, LANG("obj.84afb909aab2db8b", null))
	return TRUE

/// Master R&D server. As long as this still exists and still holds the HDD for the theft objective, research points generate at normal speed. Destroy it or an antag steals the HDD? Half research speed.
/obj/machinery/rnd/server/master
	max_integrity = 1800 //takes roughly ~15s longer to break then full deconstruction.
	circuit = null
	var/obj/item/disk/computer/hdd_theft/source_code_hdd
	var/deconstruction_state = HDD_PANEL_CLOSED
	var/front_panel_screws = 4
	var/hdd_wires = 6

/obj/machinery/rnd/server/master/Initialize(mapload)
	. = ..()
	name = "\improper Master " + name
	desc += "\nIt looks incredibly resistant to damage!"
	source_code_hdd = new(src)

	add_overlay("RD-server-objective-stripes")

/obj/machinery/rnd/server/master/Destroy()
	QDEL_NULL(source_code_hdd)
	return ..()

/obj/machinery/rnd/server/master/get_status_text()
	. = ..()
	// Give us a special message if we're nominal, but our hard drive is gone
	if(. == SERVER_NOMINAL_TEXT && !source_code_hdd)
		return "<font color=orange>Nominal - Hard Drive Missing</font>"

/obj/machinery/rnd/server/master/examine(mob/user)
	. = ..()

	switch(deconstruction_state)
		if(HDD_PANEL_CLOSED)
			. += LANG("obj.3d193e8591c51efb", null)
		if(HDD_PANEL_OPEN)
			. += LANG("obj.6fd85e29021562e6", null)
		if(HDD_PRIED)
			. += LANG("obj.96d692752445681a", null)
		if(HDD_CUT_LOOSE)
			. += LANG("obj.241a3dea9d4c76a7", null)
		if(HDD_OVERLOADED)
			. += LANG("obj.60d7daf09b91fbbb", null)

/obj/machinery/rnd/server/master/tool_act(mob/living/user, obj/item/tool, list/modifiers)
	if(!tool.tool_behaviour)
		return ..()
	// Only antags are given the training and knowledge to disassemble this thing.
	if(!user.is_antag())
		if(user.combat_mode)
			return ITEM_INTERACT_SKIP_TO_ATTACK
		balloon_alert(user, LANG("obj.1e52c3a6512b8af9", null))
		return ITEM_INTERACT_BLOCKING
	return ..()

/obj/machinery/rnd/server/master/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/disk/computer/hdd_theft))
		return NONE
	switch(deconstruction_state)
		if(HDD_PANEL_CLOSED)
			balloon_alert(user, LANG("obj.a25d70e1cb98d10b", null))
		if(HDD_PANEL_OPEN)
			balloon_alert(user, LANG("obj.7af774c3462b02a0", null))
		if(HDD_PRIED)
			balloon_alert(user, LANG("obj.2f71f57c6cd8c9a7", null))
		if(HDD_CUT_LOOSE)
			balloon_alert(user, LANG("obj.92f20bf37619bc36", null))
		if(HDD_OVERLOADED)
			balloon_alert(user, LANG("obj.a226ff1bd91c1b7d", null))
	return ITEM_INTERACT_BLOCKING

/obj/machinery/rnd/server/master/screwdriver_act(mob/living/user, obj/item/tool)
	if(deconstruction_state != HDD_PANEL_CLOSED || user.combat_mode)
		return NONE

	to_chat(user, span_notice(LANG("obj.da3872784a148ee5", list(front_panel_screws, front_panel_screws == 1 ? "it" : "them"))))
	while(tool.use_tool(src, user, 7.5 SECONDS, volume=100))
		front_panel_screws--
		if(front_panel_screws > 0)
			to_chat(user, span_notice(LANG("obj.fec45e7e9d6c9f74", list(front_panel_screws))))
			continue
		deconstruction_state = HDD_PANEL_OPEN
		to_chat(user, span_notice(LANG("obj.78caab63843013a3", list(src))))
		add_overlay("RD-server-hdd-panel-open")
		break
	return ITEM_INTERACT_SUCCESS

/obj/machinery/rnd/server/master/crowbar_act(mob/living/user, obj/item/tool)
	if(deconstruction_state != HDD_PANEL_OPEN || user.combat_mode)
		return FALSE

	to_chat(user, span_notice(LANG("obj.bf1d9f3edb317faf", list(source_code_hdd))))
	if(tool.use_tool(src, user, 15 SECONDS, volume=100))
		to_chat(user, span_notice(LANG("obj.9142def47bac8e68", list(source_code_hdd))))
		deconstruction_state = HDD_PRIED
	return TRUE

/obj/machinery/rnd/server/master/wirecutter_act(mob/living/user, obj/item/tool)
	if(deconstruction_state != HDD_PRIED || user.combat_mode)
		return FALSE

	to_chat(user, span_notice(LANG("obj.6bb43787c77d95fe", list(hdd_wires, source_code_hdd, hdd_wires == 1 ? "it" : "them"))))
	while(tool.use_tool(src, user, 7.5 SECONDS, volume=100))
		hdd_wires--

		if(hdd_wires <= 0)
			deconstruction_state = HDD_CUT_LOOSE
			to_chat(user, span_notice(LANG("obj.8abb852428634809", list(source_code_hdd))))
			try_put_in_hand(source_code_hdd, user)
			source_code_hdd = null
			stored_research.income_modifier *= 0.5
			return TRUE
		to_chat(user, span_notice(LANG("obj.03bcb324790b4bd4", list(hdd_wires))))
	return TRUE

/obj/machinery/rnd/server/master/on_deconstruction(disassembled)
	// If the machine contains a source code HDD, destroying it will negatively impact research speed. Safest to log this.
	if(source_code_hdd)
		// Destroyed with a hard drive inside = harm income
		stored_research.income_modifier *= 0.5
		// If there's a usr, this was likely a direct deconstruction of some sort. Extra logging info!
		if(usr)
			var/mob/user = usr

			message_admins("[ADMIN_LOOKUPFLW(user)] deconstructed [ADMIN_JMP(src)].")
			user.log_message("deconstructed [src].", LOG_GAME)
			return ..()

		message_admins("[ADMIN_JMP(src)] has been deconstructed by an unknown user.")
		log_game("[src] has been deconstructed by an unknown user.")

	return ..()

/// Destroys the source_code_hdd if present and sets the machine state to overloaded, adding the panel open overlay if necessary.
/obj/machinery/rnd/server/master/proc/overload_source_code_hdd()
	if(source_code_hdd)
		QDEL_NULL(source_code_hdd)
		// Overloaded = harm income
		stored_research.income_modifier *= 0.5

	if(deconstruction_state == HDD_PANEL_CLOSED)
		add_overlay("RD-server-hdd-panel-open")

	front_panel_screws = 0
	hdd_wires = 0
	deconstruction_state = HDD_OVERLOADED

#undef HDD_CUT_LOOSE
#undef HDD_OVERLOADED
#undef HDD_PANEL_CLOSED
#undef HDD_PANEL_OPEN
#undef HDD_PRIED
#undef SERVER_NOMINAL_TEXT
