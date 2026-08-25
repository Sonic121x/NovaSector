// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/// Prevents a movable atom from moving to somewhere which isn't an open turf with floor on it
/datum/element/floor_loving

/datum/element/floor_loving/Attach(datum/target)
	. = ..()
	if(!ismovable(target))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(attempting_move))

/datum/element/floor_loving/Detach(datum/target)
	UnregisterSignal(target, COMSIG_MOVABLE_PRE_MOVE)
	return ..()

/// Block movement to any non-floor location
/datum/element/floor_loving/proc/attempting_move(atom/movable/parent, newloc)
	SIGNAL_HANDLER
	if (!isopenturf(newloc) || is_space_or_openspace(newloc))
		return COMPONENT_MOVABLE_BLOCK_PRE_MOVE
	if (isliving(parent))
		var/mob/living/living_parent = parent
		living_parent.balloon_alert(living_parent, LANG("datum.e277db5c09b9aa4f", null))
