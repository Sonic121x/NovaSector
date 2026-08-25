// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/mob/living/silicon/ai/examine(mob/user)
	. = list()
	if(stat == DEAD)
		. += span_warning(LANG("mob.8ca0f7fccb643eb0", list(p_They(), p_s())))
	. += span_notice(LANG("mob.2e9e1c08ef2a7c4c", list(p_Their(), is_anchored ? "tightened" : "loose")))
	if(is_anchored)
		if(!opened)
			if(!emagged)
				. += span_notice(LANG("mob.2299454bf1e4e9b3", list(p_Their(), stat == DEAD ? "damaged" : "closed and locked")))
			else
				. += span_warning(LANG("mob.2a26588f16ce03f0", list(p_Their())))
		else
			. += span_notice(LANG("mob.b0adf1fea9a09141", list(p_Their())))
	if(stat != DEAD)
		if (get_brute_loss())
			if (get_brute_loss() < 30)
				. += span_warning(LANG("mob.c487477b1d7f722c", list(p_They(), p_s())))
			else
				. += span_warning(LANG("mob.5f081d0a68ed8c98", list(p_They(), p_s())))
		if (get_fire_loss())
			if (get_fire_loss() < 30)
				. += span_warning(LANG("mob.822ee81430e55a34", list(p_They(), p_s())))
			else
				. += span_warning(LANG("mob.40f30327c292b6c6", list(p_Their())))
		if(deployed_shell)
			. += LANG("mob.c0556282f3ad2df9", null)
		else if (!shunted && !client)
			. += LANG("mob.dbbd0a6016a76729", list(src))
	//NOVA EDIT ADDITION BEGIN - CUSTOMIZATION
	. += get_silicon_flavortext(user)
	//NOVA EDIT ADDITION END

	. += ..()
