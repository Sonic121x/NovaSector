// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/// Applied to living mobs.
/// Adds a force threshold for which attacks will be blocked entirely.
/// IE, if they are hit with an attack that deals less than X damage, the attack does nothing.
/datum/element/damage_threshold
	element_flags = ELEMENT_BESPOKE
	argument_hash_start_idx = 2
	/// Incoming attacks beneath this threshold, inclusive, will be blocked entirely
	var/force_threshold = -1

/datum/element/damage_threshold/Attach(datum/target, threshold)
	. = ..()
	if(!isliving(target))
		return ELEMENT_INCOMPATIBLE
	if(!isnum(threshold) || threshold <= 0)
		return ELEMENT_INCOMPATIBLE

	RegisterSignal(target, COMSIG_LIVING_CHECK_BLOCK, PROC_REF(check_block))
	force_threshold = threshold

/datum/element/damage_threshold/Detach(datum/source, ...)
	. = ..()
	UnregisterSignal(source, COMSIG_LIVING_CHECK_BLOCK)

/datum/element/damage_threshold/proc/check_block(
	mob/living/source,
	atom/hitby,
	damage,
	attack_text,
	attack_type,
	armour_penetration,
	damage_type,
	attack_flag,
)
	SIGNAL_HANDLER

	if(damage <= 0) // Already handled
		return NONE

	if(damage <= force_threshold)
		var/obj/item/item_hitting = hitby
		var/tap_vol = istype(item_hitting) ? item_hitting.get_clamped_volume() : 50
		source.visible_message(
			span_warning(LANG("datum.99f2eb3ce8374027", list(source))),
			span_warning(LANG("datum.e7a1b5437e68fd6a", list(attack_text))),
			span_hear(LANG("datum.34acf327d0f39f88", null)),
			COMBAT_MESSAGE_RANGE,
		)
		playsound(source, 'sound/items/weapons/tap.ogg', tap_vol, TRUE, -1)
		return SUCCESSFUL_BLOCK

	return NONE
