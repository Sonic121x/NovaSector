// Blue-space plasma vent: a station goal machine that ships plasma to Central Command.
//
// Construction is the normal endgame route: machine frame -> circuitboard -> stock parts ->
// screwdriver. A console next to it performs the one-time channel handshake, which is the goal
// itself; the canister on the open tile is a separate, manually triggered reward on a cooldown.
//
//	 dx: -1 .. +2      (4 tiles wide, anchored 1 in from the left edge)
//	 dy: -2 ..  0      (3 tiles tall, anchored on the top row)
//	 open tile: (+1, -2)  -- canisters land here, people can stand here

/// Cooldown on the reward canister.
#define PLASMA_VENT_CANISTER_COOLDOWN (5 MINUTES)
/// Length of the one-time console handshake.
#define PLASMA_VENT_HANDSHAKE_TIME (5 SECONDS)
/// Extra plasma added on top of the canister's default 0.5 fill.
#define PLASMA_VENT_PLASMA_MOLES 900
/// Footprint extents, in tiles, relative to the machine's own turf.
#define PLASMA_VENT_LEFT 1
#define PLASMA_VENT_RIGHT 2
#define PLASMA_VENT_DOWN 2
/// The one open tile: bottom row, second column from the right (not the literal SE corner).
#define PLASMA_VENT_OUTLET_DX 1
#define PLASMA_VENT_OUTLET_DY -2

/* ------------------------------------------------------------------ machine */

/// Deliberately has no tool_act overrides: the deployed vent is a goal structure, and machinery has
/// no generic tool behaviour, so screwdriver/crowbar/wrench all do nothing to it.
/obj/machinery/plasma_vent
	name = "bluespace plasma vent"
	desc = "A squat industrial frame wrapped around a containment ring. It reaches through bluespace to skim plasma off a planet's upper atmosphere and pipes it to Central Command, condensing a canister for the station on demand."
	icon = 'modular_z121/code/modules/plasma_vent/icons/plasma_vent.dmi'
	icon_state = "plasma_vent"
	density = TRUE
	anchored = TRUE
	pixel_x = -32
	pixel_y = -64
	idle_power_usage = BASE_MACHINE_IDLE_CONSUMPTION * 2
	active_power_usage = BASE_MACHINE_ACTIVE_CONSUMPTION * 6
	use_power = IDLE_POWER_USE
	/// Set once by a control console; the vent does nothing before that.
	var/channel_active = FALSE
	/// The single console allowed to drive this vent.
	var/datum/weakref/console_ref
	/// world.time of the next allowed reward canister.
	var/next_canister = 0
	/// Turf the canisters land on: the open tile in the bottom row.
	var/turf/dispense_turf
	/// Invisible blockers covering the solid part of the footprint.
	var/list/obj/structure/filler/fillers = list()

/obj/machinery/plasma_vent/Initialize(mapload)
	. = ..()
	dispense_turf = locate(x + PLASMA_VENT_OUTLET_DX, y + PLASMA_VENT_OUTLET_DY, z)
	build_fillers()

/obj/machinery/plasma_vent/Destroy()
	QDEL_LIST(fillers)
	dispense_turf = null
	return ..()

/// Unpowered or broken vents use the cold, unlit sprite; power_change() already refreshes on NOPOWER.
/obj/machinery/plasma_vent/update_icon_state()
	. = ..()
	icon_state = (machine_stat & (NOPOWER | BROKEN)) ? "plasma_vent_off" : "plasma_vent"

/// Covers every footprint tile except the machine's own and the open outlet.
/obj/machinery/plasma_vent/proc/build_fillers()
	for(var/dx in -PLASMA_VENT_LEFT to PLASMA_VENT_RIGHT)
		for(var/dy in -PLASMA_VENT_DOWN to 0)
			var/turf/footprint = locate(x + dx, y + dy, z)
			if(!footprint || footprint == loc || footprint == dispense_turf)
				continue
			if(locate(/obj/structure/filler) in footprint)
				continue
			var/obj/structure/filler/blocker = new(footprint)
			blocker.parent = src
			fillers += blocker

/// Opens the link to Central Command. Returns FALSE when it is already open.
/// The console drives the paced handshake and both announcements; this proc only commits the state.
/obj/machinery/plasma_vent/proc/establish_channel()
	if(channel_active)
		return FALSE
	channel_active = TRUE
	next_canister = world.time
	return TRUE

/// Announcement, part one: the channel is still linking up. Yellow alert stripe, notice3 plus a
/// portal layer played to everyone so the two cues stack.
/obj/machinery/plasma_vent/proc/announce_establishing()
	announce_styled(
		"通路链接中…",
		"蓝空等离子矿井",
		'sound/announcer/notice/notice3.ogg',
		"yellow"
	)
	SEND_SOUND(world, sound('sound/effects/portal/portal_travel.ogg', volume = 60))

/// Announcement, part two: the channel is open. Green stripe, announcer intercept sting.
/obj/machinery/plasma_vent/proc/announce_established()
	announce_styled(
		"蓝空气体通路连接完成。",
		"蓝空等离子矿井",
		ANNOUNCER_INTERCEPT,
		"green"
	)

/// priority_announce() html-encodes its body by default; the body here is plain text, and the
/// whole alert block is tinted through `color_override` instead of per-span font colours.
/// `color` maps to the chat_alert_<color> stripe classes (yellow / green / red / blue / orange / purple).
/obj/machinery/plasma_vent/proc/announce_styled(text, title, sound, color)
	priority_announce(
		text,
		title,
		sound,
		null,
		null,
		FALSE,
		GLOB.player_list,
		TRUE,
		FALSE,
		color
	)

/// Manual reward: condenses one canister if the channel is open and the coils are ready.
/// Returns NULL on success, otherwise a reason string.
/obj/machinery/plasma_vent/proc/dispense_canister()
	if(!channel_active)
		return "The bluespace channel is not open yet."
	if(machine_stat & (BROKEN | NOPOWER))
		return "The vent has no power."
	if(world.time < next_canister)
		return "The transfer coils are still cycling."
	if(!dispense_turf || !istype(dispense_turf, /turf/open) || dispense_turf.density)
		return "The outlet is blocked."
	for(var/atom/movable/obstacle as anything in dispense_turf)
		if(obstacle.density)
			return "Something is standing in the outlet."
	// Pay for the cycle before anything is created; a dead APC must not hand out a free canister.
	if(!use_energy(active_power_usage, force = FALSE))
		return "The vent has no power."
	var/obj/machinery/portable_atmospherics/canister/fresh_canister = new /obj/machinery/portable_atmospherics/canister/plasma(dispense_turf)
	fresh_canister.air_contents.adjust_gas(/datum/gas/plasma, PLASMA_VENT_PLASMA_MOLES)
	fresh_canister.update_appearance()
	// Start the cooldown before the flourish, so a misbehaving effect can never leave the console stale.
	next_canister = world.time + PLASMA_VENT_CANISTER_COOLDOWN
	bluespace_arrival(fresh_canister)
	return null

/// The teleport-in flourish: the canister drops out of the port with a flare.
/obj/machinery/plasma_vent/proc/bluespace_arrival(obj/machinery/portable_atmospherics/canister/fresh_canister)
	playsound(dispense_turf, 'sound/machines/mining/auto_teleport.ogg', 50, TRUE)
	new /obj/effect/temp_visual/bluespace_dispense(dispense_turf)
	fresh_canister.pixel_y = 16
	animate(fresh_canister, pixel_y = 0, time = 6, easing = BOUNCE_EASING)

/obj/machinery/plasma_vent/examine(mob/user)
	. = ..()
	if(!channel_active)
		. += span_notice("The bluespace channel is not established yet; a control console can open it.")
		return
	. += span_notice("The channel to Central Command is open. It can condense a canister on demand.")

/// Short-lived flare marking the bluespace arrival.
/obj/effect/temp_visual/bluespace_dispense
	icon = 'icons/effects/effects.dmi'
	icon_state = "phasein"
	duration = 8

/* -------------------------------------------------------------------- pack */

/// The finished build stage: a one-tile crate with the whole vent folded inside.
/// A control console unfolds it into the 4x3 machine.
/obj/machinery/plasma_vent_pack
	name = "compressed plasma vent"
	desc = "A single-tile crate of folded plating, containment ring segments and bluespace emitters. A control console can unfold it into a full vent."
	icon = 'modular_z121/code/modules/plasma_vent/icons/plasma_vent_pack.dmi'
	icon_state = "pack"
	density = TRUE
	anchored = TRUE
	use_power = NO_POWER_USE

/// The frame hands its board to /obj/machinery/New, which adopts it before Initialize() runs; the
/// parent Initialize() then distributes the parts. Only admin/VV spawns arrive without a circuit.
/obj/machinery/plasma_vent_pack/Initialize(mapload)
	. = ..()
	if(isnull(circuit))
		circuit = new /obj/item/circuitboard/machine/plasma_vent(src)
		circuit.apply_default_parts(src)

/obj/machinery/plasma_vent_pack/examine(mob/user)
	. = ..()
	. += span_notice("It is still folded up. A plasma vent control console can unfold it.")

/obj/machinery/plasma_vent_pack/screwdriver_act(mob/living/user, obj/item/tool)
	return default_deconstruction_screwdriver(user, tool)

/obj/machinery/plasma_vent_pack/crowbar_act(mob/living/user, obj/item/tool)
	return default_deconstruction_crowbar(user, tool)

/obj/machinery/plasma_vent_pack/wrench_act(mob/living/user, obj/item/tool)
	if(tool.tool_behaviour != TOOL_WRENCH)
		return NONE
	if(default_unfasten_wrench(user, tool, 2 SECONDS) != SUCCESSFUL_UNFASTEN)
		return ITEM_INTERACT_BLOCKING
	return ITEM_INTERACT_SUCCESS

/* ---------------------------------------------------------------- console */

/obj/machinery/computer/plasma_vent
	name = "plasma vent control"
	desc = "Bluespace calibration, transport monitoring and the channel handshake for a plasma vent."
	icon = 'icons/obj/machines/particle_accelerator.dmi'
	icon_state = "control_boxp"
	icon_keyboard = null
	icon_screen = null
	use_power = IDLE_POWER_USE
	idle_power_usage = BASE_MACHINE_IDLE_CONSUMPTION * 0.5
	active_power_usage = BASE_MACHINE_IDLE_CONSUMPTION
	circuit = /obj/item/circuitboard/computer/plasma_vent
	/// The vent this console talks to.
	var/datum/weakref/vent_ref
	/// Last line of feedback shown to the operator.
	var/notice
	/// Severity of the notice line: "info", "success" or "danger".
	var/notice_type = "info"
	/// TRUE while the one-time handshake is running.
	var/handshaking = FALSE
	/// world.time at which the handshake completes.
	var/handshake_ends = 0
	/// TRUE while a periodic UI push is already queued.
	var/ui_refresh_queued = FALSE

/obj/machinery/computer/plasma_vent/examine(mob/user)
	. = ..()
	. += span_notice("It talks to a vent within seven tiles and opens its bluespace channel once.")

/obj/machinery/computer/plasma_vent/ui_state(mob/user)
	return GLOB.physical_state

/obj/machinery/computer/plasma_vent/ui_interact(mob/user, datum/tgui/ui)
	..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PlasmaVent", name)
		ui.open()
	// A window opened mid-handshake or mid-cooldown still needs the countdown to move.
	queue_ui_refresh(1 SECONDS)

/// Resolve the linked vent, or the nearest unclaimed one that is both in range and in sight.
/obj/machinery/computer/plasma_vent/proc/find_vent()
	var/obj/machinery/plasma_vent/vent = vent_ref?.resolve()
	if(vent && !QDELETED(vent) && get_dist(vent, src) <= 7 && can_see(src, vent, 7))
		return vent
	for(var/obj/machinery/plasma_vent/candidate in range(7, src))
		if(!can_see(src, candidate, 7))
			continue
		var/obj/machinery/computer/plasma_vent/owner = candidate.console_ref?.resolve()
		// An owner that is still alive but can no longer reach the vent does not hold it hostage.
		if(owner && owner != src && get_dist(owner, candidate) <= 7 && can_see(owner, candidate, 7))
			continue
		return candidate
	return null

/obj/machinery/computer/plasma_vent/proc/find_pack()
	for(var/obj/machinery/plasma_vent_pack/pack in range(7, src))
		if(can_see(src, pack, 7))
			return pack
	return null

/// Keeps the open window live while a handshake or the five-minute cooldown counts down: the
/// handshake hides every action section, so the client cannot trigger an update by itself.
/obj/machinery/computer/plasma_vent/proc/queue_ui_refresh(delay = 1 SECONDS)
	if(ui_refresh_queued)
		return
	ui_refresh_queued = TRUE
	addtimer(CALLBACK(src, PROC_REF(refresh_ui_tick)), delay)

/obj/machinery/computer/plasma_vent/proc/refresh_ui_tick()
	ui_refresh_queued = FALSE
	if(QDELETED(src) || !LAZYLEN(open_uis))
		return
	SStgui.update_uis(src)
	if(handshaking)
		queue_ui_refresh(0.5 SECONDS)
		return
	// Follow the linked vent directly, so losing line of sight does not freeze the countdown.
	// Falling back to find_vent() covers taking over a vent this console never deployed.
	var/obj/machinery/plasma_vent/vent = vent_ref?.resolve()
	if(!vent)
		vent = find_vent()
	if(vent && vent.channel_active && vent.next_canister > world.time)
		queue_ui_refresh(1 SECONDS)

/obj/machinery/computer/plasma_vent/proc/set_notice(text, severity = "info")
	notice = text
	notice_type = severity

/// Starts the paced handshake. The vent is only committed when the timer finishes.
/obj/machinery/computer/plasma_vent/proc/begin_handshake(obj/machinery/plasma_vent/vent)
	handshaking = TRUE
	handshake_ends = world.time + PLASMA_VENT_HANDSHAKE_TIME
	set_notice("Negotiating bluespace link…", "info")
	vent.announce_establishing()
	queue_ui_refresh(0.5 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(finish_handshake), WEAKREF(vent)), PLASMA_VENT_HANDSHAKE_TIME)

/obj/machinery/computer/plasma_vent/proc/finish_handshake(datum/weakref/held_vent)
	if(QDELETED(src))
		return
	handshaking = FALSE
	handshake_ends = 0
	var/obj/machinery/plasma_vent/vent = held_vent?.resolve()
	if(!vent)
		set_notice("The vent was lost during the handshake.", "danger")
	else if(vent.machine_stat & (BROKEN | NOPOWER))
		set_notice("The vent lost power during the handshake.", "danger")
	else if(!vent.establish_channel())
		set_notice("The channel is already open.", "info")
	else
		vent.announce_established()
		set_notice("Handshake complete. Transport is nominal.", "success")
	SStgui.update_uis(src)

/// Unfolds the nearest compressed pack into the full vent. Returns a notice.
/obj/machinery/computer/plasma_vent/proc/unfold_vent()
	if(vent_ref?.resolve())
		return "A vent is already linked to this console."
	// Raw lookup on purpose: another console's claimed vent still blocks a second footprint here.
	if(locate(/obj/machinery/plasma_vent) in range(7, src))
		return "A plasma vent is already within seven tiles."
	var/obj/machinery/plasma_vent_pack/pack = find_pack()
	if(!pack)
		return "No compressed vent within seven tiles."
	var/turf/base = get_turf(pack)
	if(!space_is_clear(base, pack))
		return "Not enough open floor for the vent."
	do_smoke(4, get_turf(src), base)
	var/obj/machinery/plasma_vent/vent = new(base)
	vent_ref = WEAKREF(vent)
	vent.console_ref = WEAKREF(src)
	qdel(pack)
	return null

/// The 4x3 footprint around `base` has to be open floor, and must not swallow this console.
/// The compressed pack itself is the only dense thing allowed on the anchor turf.
/obj/machinery/computer/plasma_vent/proc/space_is_clear(turf/base, obj/machinery/plasma_vent_pack/pack)
	var/turf/console_turf = get_turf(src)
	for(var/dx in -PLASMA_VENT_LEFT to PLASMA_VENT_RIGHT)
		for(var/dy in -PLASMA_VENT_DOWN to 0)
			var/turf/potential_turf = locate(base.x + dx, base.y + dy, base.z)
			if(!potential_turf || potential_turf.density || isspaceturf(potential_turf) || potential_turf == console_turf)
				if(potential_turf)
					new /obj/effect/temp_visual/point(potential_turf)
				return FALSE
			for(var/atom/movable/obstacle as anything in potential_turf)
				if(obstacle == pack)
					continue
				if(obstacle.density)
					new /obj/effect/temp_visual/point(potential_turf)
					return FALSE
	return TRUE

/obj/machinery/computer/plasma_vent/ui_data(mob/user)
	var/list/data = list()
	var/obj/machinery/plasma_vent/vent = find_vent()
	data["linked"] = !isnull(vent)
	data["pack"] = !isnull(find_pack())
	data["channel"] = vent ? vent.channel_active : FALSE
	data["calibrated"] = vent ? !(vent.machine_stat & (BROKEN | NOPOWER)) : FALSE
	data["notice"] = notice
	data["notice_type"] = notice_type
	data["handshaking"] = handshaking
	var/progress = 0
	if(handshaking)
		progress = min(1, max(0, 1 - (handshake_ends - world.time) / PLASMA_VENT_HANDSHAKE_TIME))
	data["handshake_progress"] = progress
	var/cooldown = 0
	if(vent && vent.channel_active)
		cooldown = max(0, vent.next_canister - world.time)
	data["cooldown"] = round(cooldown / 10, 1)
	data["cooldown_max"] = PLASMA_VENT_CANISTER_COOLDOWN / 10
	return data

/obj/machinery/computer/plasma_vent/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("deploy")
			var/deploy_error = unfold_vent()
			if(deploy_error)
				set_notice(deploy_error, "danger")
			else
				set_notice("Vent unfolded and linked.", "success")
			. = TRUE
		if("establish")
			if(handshaking)
				set_notice("A handshake is already in progress.", "danger")
				return TRUE
			var/obj/machinery/plasma_vent/vent = find_vent()
			if(!vent)
				set_notice("No plasma vent within seven tiles.", "danger")
				return TRUE
			if(vent.channel_active)
				set_notice("The channel is already open.", "info")
				return TRUE
			if(vent.machine_stat & (BROKEN | NOPOWER))
				set_notice("The vent has no power.", "danger")
				return TRUE
			var/obj/machinery/computer/plasma_vent/owner = vent.console_ref?.resolve()
			if(owner && owner != src && get_dist(owner, vent) <= 7 && can_see(owner, vent, 7))
				set_notice("Another console is already linked to this vent.", "danger")
				return TRUE
			vent_ref = WEAKREF(vent)
			vent.console_ref = WEAKREF(src)
			begin_handshake(vent)
			. = TRUE
		if("dispense")
			var/obj/machinery/plasma_vent/vent = find_vent()
			if(!vent)
				set_notice("No plasma vent within seven tiles.", "danger")
				return TRUE
			var/dispense_error = vent.dispense_canister()
			if(dispense_error)
				set_notice(dispense_error, "danger")
			else
				set_notice("Canister condensed at the vent outlet.", "success")
				queue_ui_refresh(1 SECONDS)
			. = TRUE

	// Push the new counters/notice to every open console window right away.
	SStgui.update_uis(src)

/* ------------------------------------------------------------ construction */

/obj/item/circuitboard/machine/plasma_vent
	name = "Bluespace Plasma Vent"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/plasma_vent_pack
	specific_parts = TRUE
	req_components = list(
		/datum/stock_part/capacitor/tier4 = 4,
		/datum/stock_part/servo/tier4 = 2,
		/datum/stock_part/scanning_module/tier4 = 4,
		/datum/stock_part/ansible = 1,
		/obj/item/stack/cable_coil = 15,
		/obj/item/stack/ore/bluespace_crystal = 5,
		/obj/item/stack/sheet/mineral/plastitanium = 15,
	)

/obj/item/circuitboard/computer/plasma_vent
	name = "Plasma Vent Control"
	greyscale_colors = CIRCUIT_COLOR_ENGINEERING
	build_path = /obj/machinery/computer/plasma_vent

/datum/supply_pack/engineering/plasma_vent
	name = "Bluespace Plasma Vent Crate"
	desc = "Boards for a plasma vent and its control console. Frames, stock parts and cable are on you."
	cost = CARGO_CRATE_VALUE * 40
	access_view = ACCESS_COMMAND
	// Hidden from the order console until the station goal calls on_report() and unlocks it.
	order_flags = ORDER_SPECIAL
	contains = list(
		/obj/item/circuitboard/machine/plasma_vent,
		/obj/item/circuitboard/computer/plasma_vent,
	)
	crate_name = "plasma vent crate"

/* -------------------------------------------------------------------- goal */

/datum/station_goal/plasma_vent
	name = "Plasma Vent"

/datum/station_goal/plasma_vent/get_report()
	return list(
		"Central Command is short on plasma and the local gas giant is venting it into the dark.",
		"Command has authorised a bluespace plasma vent for your station.",
		"",
		"* Order the vent crate from cargo.",
		"* Build the vent and its control console.",
		"* Open the bluespace channel from the console.",
		"",
		"Once the channel is up the vent ships plasma to Central Command on its own. \
		The console can also condense a canister for the station every five minutes.",
	).Join("\n")

/datum/station_goal/plasma_vent/on_report()
	var/datum/supply_pack/engineering/plasma_vent/pack = SSshuttle.supply_packs[/datum/supply_pack/engineering/plasma_vent]
	if(pack)
		pack.order_flags |= ORDER_SPECIAL_ENABLED

/datum/station_goal/plasma_vent/check_completion()
	if(..())
		return TRUE
	for(var/obj/machinery/plasma_vent/vent as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/plasma_vent))
		if(vent.channel_active)
			return TRUE
	return FALSE

#undef PLASMA_VENT_HANDSHAKE_TIME
#undef PLASMA_VENT_CANISTER_COOLDOWN
#undef PLASMA_VENT_PLASMA_MOLES
#undef PLASMA_VENT_LEFT
#undef PLASMA_VENT_RIGHT
#undef PLASMA_VENT_DOWN
#undef PLASMA_VENT_OUTLET_DX
#undef PLASMA_VENT_OUTLET_DY
