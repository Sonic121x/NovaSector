// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/element/hand_organ_insertion
	element_flags = ELEMENT_BESPOKE
	argument_hash_start_idx = 2

	var/insertion_time = 0 SECONDS

/datum/element/hand_organ_insertion/Attach(datum/target, insertion_time = 5 SECONDS)
	. = ..()
	if (!iscarbon(target))
		return ELEMENT_INCOMPATIBLE

	src.insertion_time = insertion_time

	RegisterSignal(target, COMSIG_USER_ITEM_INTERACTION_SECONDARY, PROC_REF(on_item_interaction_secondary))

/datum/element/hand_organ_insertion/Detach(datum/source, ...)
	. = ..()

	UnregisterSignal(source, COMSIG_USER_ITEM_INTERACTION_SECONDARY)

/datum/element/hand_organ_insertion/proc/on_item_interaction_secondary(mob/living/carbon/parent, atom/target, obj/item/tool, list/modifiers)
	SIGNAL_HANDLER
	if (target != parent)
		return FALSE
	if (!isorgan(tool))
		return FALSE

	INVOKE_ASYNC(src, PROC_REF(attempt_to_insert_organ), parent, tool)
	return TRUE

/datum/element/hand_organ_insertion/proc/attempt_to_insert_organ(mob/living/carbon/user, obj/item/organ/organ)
	if (!can_insert_organ(user, organ, feedback = TRUE))
		return

	var/zone_name = user.parse_zone_with_bodypart(organ.zone)

	user.visible_message(
		message = span_danger(LANG("datum.53c5139a98612eb7", list(user, user.p_s(), organ, user.p_their(), zone_name))),
		self_message = span_danger(LANG("datum.102ce38502ae6311", list(organ, zone_name))),
		blind_message = span_hear(LANG("datum.cb2a47b82abe7fe3", null))
	)

	user.balloon_alert(user, LANG("datum.14b48e798b316996", null))

	playsound(user, 'sound/items/handling/surgery/organ2.ogg', vol = 80, vary = TRUE, ignore_walls = FALSE)

	if (!do_after(user, insertion_time, extra_checks = CALLBACK(src, PROC_REF(can_insert_organ), user, organ)))
		user.balloon_alert(user, LANG("datum.c67b5d274d6e724b", null))
		return

	zone_name = user.parse_zone_with_bodypart(organ.zone)

	user.visible_message(
		message = span_danger(LANG("datum.4aa2fdf58f466e3f", list(user, user.p_s(), organ, user.p_their(), zone_name))),
		self_message = span_danger(LANG("datum.0d7a9e3be0c11b84", list(organ, zone_name))),
		blind_message = span_hear(LANG("datum.bdc0f1a5b8c510f2", null))
	)

	user.balloon_alert(user, LANG("datum.863baa0b9898fd21", null))

	playsound(user, 'sound/items/handling/surgery/organ1.ogg', vol = 80, vary = TRUE, ignore_walls = FALSE)
	user.temporarilyRemoveItemFromInventory(organ, force = TRUE)
	organ.pre_surgical_insertion(user, user, organ.zone)
	organ.Insert(user)
	organ.on_surgical_insertion(user, user.get_bodypart(deprecise_zone(organ.zone)))

/datum/element/hand_organ_insertion/proc/can_insert_organ(mob/living/carbon/user, obj/item/organ/organ, feedback = FALSE)
	if (!user.get_bodypart(deprecise_zone(organ.zone)))
		user.balloon_alert(user, LANG("datum.9e954968dc5de110", list(parse_zone(organ.zone))))
		return FALSE

	var/obj/item/organ/existing_organ = user.get_organ_slot(organ.slot)
	if (existing_organ)
		user.balloon_alert(user, LANG("datum.efd41d03f67cca6f", list(existing_organ, existing_organ.p_are())))
		return FALSE

	if (!organ.useable)
		user.balloon_alert(user, LANG("datum.1b07c6139f397a59", null))
		return FALSE
	return TRUE
