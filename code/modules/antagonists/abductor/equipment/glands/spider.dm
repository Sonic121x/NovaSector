// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/organ/heart/gland/spiderman
	abductor_hint = "araneae cloister accelerator. The abductee occasionally exhales spider pheromones and will spawn spiderlings."
	cooldown_low = 450
	cooldown_high = 900
	uses = -1
	icon_state = "spider"
	mind_control_uses = 2
	mind_control_duration = 2400

/obj/item/organ/heart/gland/spiderman/activate()
	to_chat(owner, span_warning(LANG("obj.2c5d35627482b67f", null)))
	owner.add_faction(FACTION_SPIDER)
	var/mob/living/basic/spider/growing/spiderling/spider = new(owner.drop_location())
	spider.directive = "Protect your nest inside [owner.real_name]."
