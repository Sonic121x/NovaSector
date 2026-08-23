// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/organ/heart/gland/ventcrawling
	abductor_hint = "pliant cartilage enabler. The abductee can crawl through vents without trouble."
	cooldown_low = 1800
	cooldown_high = 2400
	uses = 1
	icon_state = "vent"
	mind_control_uses = 4
	mind_control_duration = 1800

/obj/item/organ/heart/gland/ventcrawling/activate()
	to_chat(owner, span_notice(LANG("obj.41f4ca7851756a97", null)))
	ADD_TRAIT(owner, TRAIT_VENTCRAWLER_ALWAYS, type)
