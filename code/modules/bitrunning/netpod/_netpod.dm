// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
#define BASE_DISCONNECT_DAMAGE 40
#define SCANNING_TOGGLE_COOLDOWN 5

/obj/machinery/netpod
	name = "netpod"

	base_icon_state = "netpod"
	circuit = /obj/item/circuitboard/machine/netpod
	desc = "A link to the netverse. It has an assortment of cables to connect yourself to a virtual domain."
	icon = 'icons/obj/machines/bitrunning.dmi'
	icon_state = "netpod"
	max_integrity = 300
	obj_flags = BLOCKS_CONSTRUCTION
	state_open = TRUE
	interaction_flags_mouse_drop = NEED_HANDS | NEED_DEXTERITY

	/// Whether we have an ongoing connection
	var/connected = FALSE
	/// A player selected outfit by clicking the netpod
	var/datum/outfit/netsuit = /datum/outfit/job/bitrunner
	/// Holds this to see if it needs to generate a new one
	var/datum/weakref/avatar_ref
	/// The linked quantum server
	var/datum/weakref/server_ref
	/// The amount of brain damage done from force disconnects
	var/disconnect_damage
	/// Static list of outfits to select from
	var/list/cached_outfits = list()
	/// Whether bit avatars become visually similar to their bitrunner on first creation
	var/copy_body = FALSE
	/// The next time copy_body can be toggled
	var/scanning_can_toggle = 0


/obj/machinery/netpod/post_machine_initialize()
	. = ..()

	disconnect_damage = BASE_DISCONNECT_DAMAGE
	find_server()

	RegisterSignal(src, COMSIG_ATOM_TAKE_DAMAGE, PROC_REF(on_damage_taken))
	RegisterSignal(src, COMSIG_MACHINERY_POWER_LOST, PROC_REF(on_power_loss))
	RegisterSignals(src, list(COMSIG_QDELETING,	COMSIG_MACHINERY_BROKEN),PROC_REF(on_broken))

	register_context()
	update_appearance()


/obj/machinery/netpod/Destroy()
	. = ..()

	QDEL_LIST(cached_outfits)


/obj/machinery/netpod/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()

	if(isnull(held_item))
		context[SCREENTIP_CONTEXT_LMB] = "Select Outfit"
	else
		if(held_item.tool_behaviour == TOOL_SCREWDRIVER && !occupant && !state_open)
			context[SCREENTIP_CONTEXT_LMB] = "[panel_open ? "Close" : "Open"] Panel"

		if(held_item.tool_behaviour == TOOL_CROWBAR)
			if(isnull(occupant))
				if(panel_open)
					context[SCREENTIP_CONTEXT_LMB] = "Deconstruct"
				else
					context[SCREENTIP_CONTEXT_LMB] = "[state_open ? "Close" : "Open"] Cover"
			else
				context[SCREENTIP_CONTEXT_LMB] = "Break out"

	context[SCREENTIP_CONTEXT_ALT_LMB] = "[copy_body ? "Disable" : "Enable"] Scan"
	return CONTEXTUAL_SCREENTIP_SET

/obj/machinery/netpod/examine(mob/user)
	. = ..()

	. += span_notice(LANG("obj.f3fabb12d30acb3c", list(EXAMINE_HINT("screwed"), panel_open ? "close" : "open")))
	if(isnull(occupant))
		if(panel_open)
			. += span_notice(LANG("obj.fa5fc7965e12e9d0", list(EXAMINE_HINT("pried"))))
		else
			. += span_notice(LANG("obj.2eaa3b1c82838440", list(EXAMINE_HINT("pried"), state_open ? "closed" : "open")))

	if(isnull(server_ref?.resolve()))
		. += span_infoplain(LANG("obj.b8effa34c8b656fe", null))
		. += span_infoplain(LANG("obj.1e9dcde542c9dacf", null))
		return

	if(!isobserver(user))
		. += span_infoplain(LANG("obj.f1e4f04a468a965f", null))
		. += span_infoplain(LANG("obj.0cf6d95960df10aa", null))
		. += span_infoplain(LANG("obj.8cfba2a1605537f3", null))
		if(copy_body)
			. += span_infoplain(LANG("obj.7f6c2041fb606458", null))
		. += span_infoplain(LANG("obj.ae4e2e732162fc49", list(copy_body ? "disable" : "enable")))

	if(isnull(occupant))
		. += span_infoplain(LANG("obj.bc6aa97bf773ed56", null))
		return

	. += span_infoplain(LANG("obj.735641dae1f8557a", list(occupant)))

	if(isobserver(user))
		. += span_notice(LANG("obj.4d38f328dacd0e2f", null))
		return

	. += span_notice(LANG("obj.84d74ac87b54af5f", null))


/obj/machinery/netpod/update_icon_state()
	if(!is_operational)
		icon_state = base_icon_state
		return ..()

	if(state_open)
		icon_state = base_icon_state + "_open_active"
		return ..()

	if(panel_open)
		icon_state = base_icon_state + "_panel"
		return ..()

	icon_state = base_icon_state + "_closed"
	if(occupant)
		icon_state += "_active"

	return ..()


/obj/machinery/netpod/mouse_drop_receive(mob/target, mob/user, params)
	var/mob/living/carbon/player = user

	if(!iscarbon(player) || !is_operational || !state_open || player.buckled)
		return

	close_machine(target)


/obj/machinery/netpod/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(!state_open && user == occupant)
		container_resist_act(user)


/obj/machinery/netpod/attack_ghost(mob/dead/observer/our_observer)
	var/our_target = avatar_ref?.resolve()
	if(isnull(our_target) || !our_observer.orbit(our_target))
		return ..()


/// When the server is upgraded, drops brain damage a little
/obj/machinery/netpod/proc/on_server_upgraded(obj/machinery/quantum_server/source)
	SIGNAL_HANDLER

	disconnect_damage = BASE_DISCONNECT_DAMAGE * (1 - source.servo_bonus)

/obj/machinery/netpod/click_alt(mob/user)
	if(world.time < scanning_can_toggle)
		return CLICK_ACTION_BLOCKING
	copy_body = !copy_body
	scanning_can_toggle = world.time + SCANNING_TOGGLE_COOLDOWN
	playsound(src, 'sound/machines/click.ogg', 50, TRUE)
	user.balloon_alert_to_viewers(user, LANG("obj.541d7ff69ad11e07", list(copy_body ? "enabled" : "disabled")))
	return CLICK_ACTION_SUCCESS

#undef BASE_DISCONNECT_DAMAGE
#undef SCANNING_TOGGLE_COOLDOWN
