/datum/action/cooldown/spell/chuuni_invocations
	name = "中二病召唤术"
	desc = "让你所有的法术都会喊出咒语，并且咒语变得...很蠢。施法后你会略微恢复生命值。"
	button_icon_state = "chuuni"

	school = SCHOOL_FORBIDDEN
	cooldown_time = 1 SECONDS

	invocation = "By the decree of the dark lord, I invoke the curse of the chuuni. Let all my spells be tainted by the power of delusion. O, Reality! Bend to my will!"
	invocation_type = INVOCATION_SHOUT
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC|SPELL_REQUIRES_STATION|SPELL_REQUIRES_MIND
	antimagic_flags = MAGIC_RESISTANCE|MAGIC_RESISTANCE_HOLY
	spell_max_level = 1

/datum/action/cooldown/spell/chuuni_invocations/cast(mob/living/cast_on)
	. = ..()

	to_chat(cast_on, span_green("你将你的奥术知识聚焦成一种日常生活的形式..."))
	if(!do_after(cast_on, 5 SECONDS))
		to_chat(cast_on, span_warning("你的专注被打断了，那些剧集般的浪漫喜剧时刻慢慢消逝。"))
		return

	playsound(cast_on, 'sound/effects/bamf.ogg', 75, TRUE, 5)
	to_chat(cast_on, span_danger("你感到自己的本质正与一种日常生活的形式绑定！"))

	cast_on.AddComponent(/datum/component/chuunibyou)

	if(ishuman(cast_on))
		var/mob/living/carbon/human/human_cast_on = cast_on
		human_cast_on.dropItemToGround(human_cast_on.glasses)
		var/obj/item/clothing/head/wizard/wizhat = human_cast_on.head
		if(istype(wizhat))
			to_chat(human_cast_on, span_notice("你的[wizhat]变成了一个眼罩。"))
			qdel(wizhat)
		else
			to_chat(human_cast_on, span_notice("一个眼罩凭空出现在你的一只眼睛上。"))
		human_cast_on.equip_to_slot_or_del(new /obj/item/clothing/glasses/eyepatch/medical/chuuni(human_cast_on), ITEM_SLOT_EYES)

	qdel(src)
