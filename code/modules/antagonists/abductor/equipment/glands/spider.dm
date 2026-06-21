/obj/item/organ/heart/gland/spiderman
	abductor_hint = "araneae cloister accelerator. The abductee occasionally exhales spider pheromones and will spawn spiderlings."
	cooldown_low = 450
	cooldown_high = 900
	uses = -1
	icon_state = "spider"
	mind_control_uses = 2
	mind_control_duration = 2400

/obj/item/organ/heart/gland/spiderman/activate()
	to_chat(owner, span_warning("你感到有什么东西在你的皮肤下爬行。"))
	owner.add_faction(FACTION_SPIDER)
	var/mob/living/basic/spider/growing/spiderling/spider = new(owner.drop_location())
	spider.directive = "Protect your nest inside [owner.real_name]."
