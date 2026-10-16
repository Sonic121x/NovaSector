// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/mob/living/carbon/human/can_use_guns(obj/item/G)
	. = ..()
	if(HAS_TRAIT(src, TRAIT_PRONE))
		to_chat(src, span_warning(LANG("mob.cfe3c6429d76290e", null)))
		return FALSE
