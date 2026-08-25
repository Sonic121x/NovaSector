// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/// Handles all special considerations for "virtual entities" such as bitrunning ghost roles or digital anomaly antagonists.
/datum/component/virtual_entity
	/// The cooldown for balloon alerts, so the player isn't spammed while trying to enter a restricted area.
	COOLDOWN_DECLARE(OOB_cooldown)


/datum/component/virtual_entity/Initialize(obj/machinery/quantum_server)
	if(quantum_server.obj_flags & EMAGGED)
		jailbreak_mobs()
		return COMPONENT_REDUNDANT

	RegisterSignal(parent, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(on_parent_pre_move))
	RegisterSignal(quantum_server, COMSIG_ATOM_EMAG_ACT, PROC_REF(on_emagged))


/// Self-destructs the component, allowing free-roam by all entities with this restriction.
/datum/component/virtual_entity/proc/jailbreak_mobs()
	to_chat(parent, span_bolddanger(LANG("datum.8f7a5a725ef5004f", null)))
	to_chat(parent, span_notice(LANG("datum.e4456812fd470079", null)))
	to_chat(parent, span_danger(LANG("datum.5b264c4136516a0c", null)))
	to_chat(parent, span_notice(LANG("datum.334db1fa71f07042", null)))


/// Remove any restrictions AFTER the mob has spawned
/datum/component/virtual_entity/proc/on_emagged(datum/source)
	SIGNAL_HANDLER

	jailbreak_mobs()
	qdel(src)


/// Prevents entry to a certain area if it has flags preventing virtual entities from entering.
/datum/component/virtual_entity/proc/on_parent_pre_move(atom/movable/source, atom/new_location)
	SIGNAL_HANDLER

	var/area/location_area = get_area(new_location)
	if(!location_area)
		stack_trace("Virtual entity entered a location with no area!")
		return

	if(location_area.area_flags_mapping & VIRTUAL_SAFE_AREA)
		source.balloon_alert(source, LANG("datum.934b11432cc2c5a3", null))
		COOLDOWN_START(src, OOB_cooldown, 2 SECONDS)
		return COMPONENT_MOVABLE_BLOCK_PRE_MOVE

