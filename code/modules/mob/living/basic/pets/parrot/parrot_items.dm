// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/strippable_item/parrot_headset
	key = STRIPPABLE_ITEM_PARROT_HEADSET

/datum/strippable_item/parrot_headset/get_item(atom/source)
	var/mob/living/basic/parrot/parrot_source = source
	return istype(parrot_source) ? parrot_source.ears : null

/datum/strippable_item/parrot_headset/try_equip(atom/source, obj/item/equipping, mob/user)
	. = ..()
	if (!.)
		return FALSE

	if (!istype(equipping, /obj/item/radio/headset))
		to_chat(user, span_warning(LANG("datum.adfcc7cae9ca08fe", list(equipping))))
		return FALSE

	return TRUE

// There is no delay for putting a headset on a parrot.
/datum/strippable_item/parrot_headset/start_equip(atom/source, obj/item/equipping, mob/user)
	return TRUE

/datum/strippable_item/parrot_headset/finish_equip(atom/source, obj/item/equipping, mob/user)
	var/obj/item/radio/headset/radio = equipping
	if (!istype(radio))
		return

	var/mob/living/basic/parrot/parrot_source = source
	if (!istype(parrot_source))
		return

	if (!user.transferItemToLoc(radio, source))
		return

	parrot_source.ears = radio

	to_chat(user, span_notice(LANG("datum.3277646666b4bd41", list(radio, source))))

/datum/strippable_item/parrot_headset/start_unequip(atom/source, mob/user)
	. = ..()
	if (!.)
		return FALSE

	var/mob/living/basic/parrot/parrot_source = source
	if (!istype(parrot_source))
		return

	if (!IS_UNCONSCIOUS_OR_CRIT(parrot_source))
		var/list/list_of_channels = parrot_source.get_available_channels()
		parrot_source.say(LANG("datum.a8861083e2845a0a", list(list_of_channels ? "[pick(list_of_channels)] " : null)), forced = "attempted headset removal")

	return TRUE

/datum/strippable_item/parrot_headset/finish_unequip(atom/source, mob/user)
	var/mob/living/basic/parrot/parrot_source = source
	if (!istype(parrot_source))
		return

	parrot_source.ears.forceMove(parrot_source.drop_location())
	parrot_source.ears = null
