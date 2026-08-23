// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/**
 * The base object for the quantum server
 */
/obj/machinery/quantum_server
	name = "quantum server"

	circuit = /obj/item/circuitboard/machine/quantum_server
	density = TRUE
	desc = "A hulking computational machine designed to fabricate virtual domains."
	icon = 'icons/obj/machines/bitrunning.dmi'
	base_icon_state = "qserver"
	icon_state = "qserver"
	/// Affects server cooldown efficiency
	var/capacitor_coefficient = 1
	/// The loaded map template, map_template/virtual_domain
	var/datum/lazy_template/virtual_domain/generated_domain
	/// If the current domain was a random selection
	var/domain_randomized = FALSE
	/// Whether the domain is finished, so the bitrunners can leave despite glitches
	var/domain_complete = FALSE
	/// Prevents multiple user actions. Handled by loading domains and cooldowns
	var/is_ready = TRUE
	/// Chance multipled by threat to spawn a glitch
	var/glitch_chance = 0.2
	/// Current plugged in users
	var/list/datum/weakref/avatar_connection_refs = list()
	/// Cached list of mutable mobs in zone for cybercops
	var/list/datum/weakref/mutation_candidate_refs = list()
	/// Any ghosts that have spawned in
	var/list/datum/weakref/spawned_threat_refs = list()
	/// Scales loot with extra players
	var/multiplayer_bonus = 1.1
	/// Extra bonus for every player that nohits the run
	var/nohit_bonus = 0.8
	/// The amount of points in the system, used to purchase maps
	var/points = 0
	/// Keeps track of the number of times someone has built a hololadder
	var/retries_spent = 0
	/// Changes how much info is available on the domain
	var/scanner_tier = 1
	/// Length of time it takes for the server to cool down after resetting. Here to give runners downtime so their faces don't get stuck like that
	var/server_cooldown_time = 2 MINUTES
	/// Applies bonuses to rewards etc
	var/servo_bonus = 0
	/// Determines the glitches available to spawn, builds with completion
	var/threat = 0
	/// Maximum rate at which a glitch can spawn
	var/threat_prob_max = 15
	/// The turfs we can place a hololadder on.
	var/list/turf/exit_turfs = list()
	/// Determines if we broadcast to entertainment monitors or not
	var/broadcasting = FALSE
	/// Cooldown between being able to toggle broadcasting
	COOLDOWN_DECLARE(broadcast_toggle_cd)
	/// Cooldown for how often you're allowed to harass deadchat for PVP domains
	COOLDOWN_DECLARE(polling_cooldown)

/obj/machinery/quantum_server/Initialize(mapload)
	. = ..()
	register_context()

/obj/machinery/quantum_server/post_machine_initialize()
	. = ..()

	RegisterSignals(src, list(COMSIG_MACHINERY_BROKEN, COMSIG_MACHINERY_POWER_LOST), PROC_REF(on_broken))
	RegisterSignal(src, COMSIG_QDELETING, PROC_REF(on_delete))

/obj/machinery/quantum_server/Destroy(force)
	mutation_candidate_refs.Cut()
	avatar_connection_refs.Cut()
	spawned_threat_refs.Cut()
	exit_turfs.Cut()
	QDEL_NULL(generated_domain)
	return ..()

/obj/machinery/quantum_server/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = NONE
	if(isnull(held_item))
		return

	if(held_item.tool_behaviour == TOOL_SCREWDRIVER)
		context[SCREENTIP_CONTEXT_LMB] = "[panel_open ? "Close" : "Open"] Panel"
		return CONTEXTUAL_SCREENTIP_SET
	else if(held_item.tool_behaviour == TOOL_CROWBAR && panel_open)
		context[SCREENTIP_CONTEXT_LMB] = "Deconstruct"
		return CONTEXTUAL_SCREENTIP_SET

/obj/machinery/quantum_server/examine(mob/user)
	. = ..()

	. += span_infoplain(LANG("obj.fb160dbb86fa62bd", null))

	. += span_notice(LANG("obj.f3fabb12d30acb3c", list(EXAMINE_HINT("screwed"), panel_open ? "close" : "open")))
	if(panel_open)
		. += span_notice(LANG("obj.fa5fc7965e12e9d0", list(EXAMINE_HINT("pried"))))

	var/upgraded = FALSE
	if(capacitor_coefficient < 1)
		. += span_infoplain(LANG("obj.c88196ab8039ad4f", list((1 - capacitor_coefficient) * 100)))
		upgraded = TRUE

	if(servo_bonus > 0.2)
		. += span_infoplain(LANG("obj.f66d7d5ae8846d02", list(servo_bonus)))
		. += span_infoplain(LANG("obj.8f8831fb0e4a24f3", list(servo_bonus * 100)))
		upgraded = TRUE

	if(!upgraded)
		. += span_notice(LANG("obj.59921e18571ce6c6", null))

	if(!is_ready)
		. += span_notice(LANG("obj.05e7947b0af45a96", null))

	if(isobserver(user) && (obj_flags & EMAGGED))
		. += span_notice(LANG("obj.1682df33b78033e4", null))


/obj/machinery/quantum_server/emag_act(mob/user, obj/item/card/emag/emag_card)
	. = ..()

	if(obj_flags & EMAGGED)
		return

	obj_flags |= EMAGGED
	glitch_chance *= 2
	threat_prob_max *= 2

	add_overlay(mutable_appearance('icons/obj/machines/bitrunning.dmi', "emag_overlay"))
	balloon_alert(user, LANG("obj.61d25b48c49a02e3", null))
	playsound(src, 'sound/effects/sparks/sparks1.ogg', 35, vary = TRUE)


/obj/machinery/quantum_server/update_appearance(updates)
	if(isnull(generated_domain) || !is_operational)
		set_light(l_on = FALSE)
		return ..()

	set_light(l_range = 2, l_power = 1.5, l_color = is_ready ? LIGHT_COLOR_BABY_BLUE : LIGHT_COLOR_FIRE, l_on = TRUE)
	return ..()


/obj/machinery/quantum_server/update_icon_state()
	if(isnull(generated_domain) || !is_operational)
		icon_state = base_icon_state
		return ..()
	if(panel_open)
		icon_state = "[base_icon_state]_panel"
		return ..()

	icon_state = "[base_icon_state]_[is_ready ? "on" : "off"]"
	return ..()


/obj/machinery/quantum_server/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/bitrunning_debug))
		return NONE

	balloon_alert(user, LANG("obj.2432f01af73bee0d", null))
	obj_flags |= EMAGGED
	glitch_chance = 0.5
	capacitor_coefficient = 0.1
	points = 100
	return ITEM_INTERACT_SUCCESS

/obj/machinery/quantum_server/crowbar_act(mob/living/user, obj/item/crowbar)
	if(!is_ready)
		balloon_alert(user, LANG("obj.906576e576280743", null))
		return ITEM_INTERACT_FAILURE
	if(length(avatar_connection_refs))
		balloon_alert(user, LANG("obj.706e5aeac7556fd2", null))
		return ITEM_INTERACT_FAILURE
	return default_deconstruction_crowbar(user, crowbar)

/obj/machinery/quantum_server/screwdriver_act(mob/living/user, obj/item/screwdriver)
	if(!is_ready)
		balloon_alert(user, LANG("obj.906576e576280743", null))
		return ITEM_INTERACT_FAILURE
	return default_deconstruction_screwdriver(user, screwdriver)

/obj/machinery/quantum_server/RefreshParts()
	var/capacitor_rating = 1.15
	var/datum/stock_part/capacitor/cap = locate() in component_parts
	capacitor_rating -= cap.tier * 0.15

	capacitor_coefficient = capacitor_rating

	var/datum/stock_part/scanning_module/scanner = locate() in component_parts
	if(scanner)
		scanner_tier = scanner.tier

	var/servo_rating = 0
	for(var/datum/stock_part/servo/servo in component_parts)
		servo_rating += servo.tier * 0.1

	servo_bonus = servo_rating

	return ..()

/datum/aas_config_entry/bitrunning_QS_ready_announcement
	name = "Cargo Alert: Bitrunning QS Ready"
	general_tooltip = "Announces when the quantum server is ready to be used. No variables provided"
	announcement_lines_map = list(
		"Message" = "Quantum Server report: Thermal systems within operational parameters. Proceeding to domain configuration."
	)
