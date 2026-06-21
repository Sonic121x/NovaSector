/datum/action/cooldown/spell/conjure/invisible_chair
	name = "透明椅"
	desc = "这位哑剧演员的表演将一把椅子变成了实实在在的实物。"
	background_icon_state = "bg_mime"
	overlay_icon_state = "bg_mime_border"
	button_icon = 'icons/mob/actions/actions_mime.dmi'
	button_icon_state = "invisible_chair"
	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_HANDS_BLOCKED|AB_CHECK_INCAPACITATED
	sound = null

	school = SCHOOL_MIME
	cooldown_time = 30 SECONDS
	invocation = span_notice("<b>%CASTER</b>拉出一把隐形椅子并坐了下来。")
	invocation_self_message = span_notice("你变出一把隐形椅子并坐了下来。")
	invocation_type = INVOCATION_EMOTE

	spell_requirements = SPELL_REQUIRES_HUMAN|SPELL_REQUIRES_MIME_VOW
	antimagic_flags = NONE
	spell_max_level = 1

	summon_radius = 0
	summon_type = list(/obj/structure/chair/mime)
	summon_lifespan = 25 SECONDS

/datum/action/cooldown/spell/conjure/invisible_chair/post_summon(atom/summoned_object, mob/living/carbon/human/cast_on)
	if(!isobj(summoned_object))
		return

	var/obj/chair = summoned_object
	chair.setDir(cast_on.dir)
	chair.buckle_mob(cast_on)
