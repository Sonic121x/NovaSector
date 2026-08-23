// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/action/cooldown/spell/chuuni_invocations
	name = "Chuuni Invocations"
	desc = "Makes all your spells shout invocations, and the invocations become... stupid. You heal slightly after casting a spell."
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

	to_chat(cast_on, span_green(LANG("datum.eb3c905228df1d23", null)))
	if(!do_after(cast_on, 5 SECONDS))
		to_chat(cast_on, span_warning(LANG("datum.e40fb1bf4248eafe", null)))
		return

	playsound(cast_on, 'sound/effects/bamf.ogg', 75, TRUE, 5)
	to_chat(cast_on, span_danger(LANG("datum.d3bf06a17996e93a", null)))

	cast_on.AddComponent(/datum/component/chuunibyou)

	if(ishuman(cast_on))
		var/mob/living/carbon/human/human_cast_on = cast_on
		human_cast_on.dropItemToGround(human_cast_on.glasses)
		var/obj/item/clothing/head/wizard/wizhat = human_cast_on.head
		if(istype(wizhat))
			to_chat(human_cast_on, span_notice(LANG("datum.1b341085cccdcfd5", list(wizhat))))
			qdel(wizhat)
		else
			to_chat(human_cast_on, span_notice(LANG("datum.0a61699550512283", null)))
		human_cast_on.equip_to_slot_or_del(new /obj/item/clothing/glasses/eyepatch/medical/chuuni(human_cast_on), ITEM_SLOT_EYES)

	qdel(src)
