// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/// This accessory can be pinned onto someone else
/datum/component/pinnable_accessory
	/// Do we let people know what we're doing?
	var/silent
	/// How long does it take to pin this onto someone?
	var/pinning_time
	/// Optional callback invoked before pinning, will cancel if it returns FALSE
	var/datum/callback/on_pre_pin

/datum/component/pinnable_accessory/Initialize(silent = FALSE, pinning_time = 2 SECONDS, datum/callback/on_pre_pin = null)
	. = ..()
	if (!istype(parent, /obj/item/clothing/accessory))
		return COMPONENT_INCOMPATIBLE
	src.silent = silent
	src.pinning_time = pinning_time
	src.on_pre_pin = on_pre_pin

/datum/component/pinnable_accessory/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ITEM_INTERACTING_WITH_ATOM, PROC_REF(on_atom_interact))

/datum/component/pinnable_accessory/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_ITEM_INTERACTING_WITH_ATOM)

/// Called when you whack someone with this accessory
/datum/component/pinnable_accessory/proc/on_atom_interact(obj/item/clothing/accessory/badge, mob/living/user, atom/target, modifiers)
	SIGNAL_HANDLER
	if (!ishuman(target) || target == user)
		return

	INVOKE_ASYNC(src, PROC_REF(try_to_pin), badge, target, user)
	return COMPONENT_CANCEL_ATTACK_CHAIN

/// Actually try to pin it on
/datum/component/pinnable_accessory/proc/try_to_pin(obj/item/clothing/accessory/badge, mob/living/carbon/human/distinguished, mob/user)
	var/obj/item/clothing/under/distinguished_uniform = distinguished.w_uniform
	if(!istype(distinguished_uniform))
		distinguished.balloon_alert(user, LANG("datum.42735d0c24ddf8fb", null))
		return

	if(!badge.can_attach_accessory(distinguished_uniform, user))
		// Check handles feedback messages and etc
		return

	if (!silent)
		user.visible_message(
			span_notice(LANG("datum.390eef44b16bc652", list(user, badge, distinguished))),
			span_notice(LANG("datum.e4e75b94cc1b4519", list(badge, distinguished))),
		)

	if (on_pre_pin && !on_pre_pin.Invoke(distinguished, user))
		return
	if(!pin_checks(user, distinguished) || !do_after(user, pinning_time, distinguished, extra_checks = CALLBACK(src, PROC_REF(pin_checks), user, distinguished)))
		return

	var/pinned = distinguished_uniform.attach_accessory(badge, user)
	if (silent)
		return

	if (pinned)
		user.visible_message(
			span_notice(LANG("datum.571feb4a83144b2d", list(user, badge, distinguished))),
			span_notice(LANG("datum.69613c36e140a609", list(badge, distinguished))),
		)
	else
		user.visible_message(
			span_warning(LANG("datum.16c87b6305d6f586", list(user, badge, distinguished))),
			span_warning(LANG("datum.7b4cdbb118927271", list(badge, distinguished))),
		)

/// Callback for do_after to check if we can still be pinned
/datum/component/pinnable_accessory/proc/pin_checks(mob/living/pinner, mob/living/carbon/human/pinning_on)
	if(QDELETED(parent) || QDELETED(pinner) || QDELETED(pinning_on))
		return FALSE
	if(!pinner.is_holding(parent) || !pinner.Adjacent(pinning_on))
		return FALSE
	var/obj/item/clothing/accessory/badge = parent
	var/obj/item/clothing/under/pinning_on_uniform = pinning_on.w_uniform
	if(!istype(pinning_on_uniform) || !badge.can_attach_accessory(pinning_on_uniform, pinner))
		return FALSE
	return TRUE
