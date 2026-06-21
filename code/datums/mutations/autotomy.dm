/datum/mutation/self_amputation
	name = "自切"
	desc = "允许生物主动舍弃一个随机的肢体。"
	quality = POSITIVE
	text_gain_indication = span_notice("你的关节感觉松动了。")
	instability = POSITIVE_INSTABILITY_MINOR
	power_path = /datum/action/cooldown/spell/self_amputation

	energy_coeff = 1
	synchronizer_coeff = 1

/datum/action/cooldown/spell/self_amputation
	name = "舍弃一个肢体"
	desc = "集中精神，让一个随机的肢体从你身上脱落。"
	button_icon_state = "autotomy"

	cooldown_time = 10 SECONDS
	spell_requirements = NONE

/datum/action/cooldown/spell/self_amputation/is_valid_target(atom/cast_on)
	return iscarbon(cast_on)

/datum/action/cooldown/spell/self_amputation/cast(mob/living/carbon/cast_on)
	. = ..()
	if(HAS_TRAIT(cast_on, TRAIT_NODISMEMBER))
		to_chat(cast_on, span_notice("你非常努力地集中精神，但什么都没发生。"))
		return

	var/list/parts = list()
	for(var/obj/item/bodypart/to_remove as anything in cast_on.get_bodyparts())
		if(to_remove.body_zone == BODY_ZONE_HEAD || to_remove.body_zone == BODY_ZONE_CHEST)
			continue
		if(to_remove.bodypart_flags & BODYPART_UNREMOVABLE)
			continue
		parts += to_remove

	if(!length(parts))
		to_chat(cast_on, span_notice("你不能再脱落更多肢体了！"))
		return

	var/obj/item/bodypart/to_remove = pick(parts)
	to_remove.dismember()
