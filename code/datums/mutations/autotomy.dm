// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/mutation/self_amputation
	name = "Autotomy"
	desc = "The subject gains the ability to voluntarily discard a random appendage."
	quality = POSITIVE
	text_gain_indication = span_notice("Your joints feel loose.")
	instability = POSITIVE_INSTABILITY_MINOR
	power_path = /datum/action/cooldown/spell/self_amputation

	energy_coeff = 1
	synchronizer_coeff = 1

/datum/action/cooldown/spell/self_amputation
	name = "Drop a limb"
	desc = "Concentrate to make a random limb pop right off your body."
	button_icon_state = "autotomy"

	cooldown_time = 10 SECONDS
	spell_requirements = NONE

/datum/action/cooldown/spell/self_amputation/is_valid_target(atom/cast_on)
	return iscarbon(cast_on)

/datum/action/cooldown/spell/self_amputation/cast(mob/living/carbon/cast_on)
	. = ..()
	if(HAS_TRAIT(cast_on, TRAIT_NODISMEMBER))
		to_chat(cast_on, span_notice(LANG("datum.46d68b019691a839", null)))
		return

	var/list/parts = list()
	for(var/obj/item/bodypart/to_remove as anything in cast_on.get_bodyparts())
		if(to_remove.body_zone == BODY_ZONE_HEAD || to_remove.body_zone == BODY_ZONE_CHEST)
			continue
		if(to_remove.bodypart_flags & BODYPART_UNREMOVABLE)
			continue
		parts += to_remove

	if(!length(parts))
		to_chat(cast_on, span_notice(LANG("datum.e23c223d110e6937", null)))
		return

	var/obj/item/bodypart/to_remove = pick(parts)
	to_remove.dismember()
