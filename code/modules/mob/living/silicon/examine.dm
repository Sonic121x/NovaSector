// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/mob/living/silicon/examine(mob/user) //Displays a silicon's laws to ghosts
	. = ..()
	if(laws && isobserver(user))
		. += LANG("mob.b79bbe525a0de56d", list(src))
		for(var/law in laws.get_law_list(include_zeroth = TRUE))
			. += law
