/obj/item/organ/heart/gland/access
	abductor_hint = "anagraphic electro-scrambler. After it activates, grants the abductee intrinsic all access."
	cooldown_low = 600
	cooldown_high = 1200
	uses = 1
	icon_state = "mindshock"
	mind_control_uses = 3
	mind_control_duration = 900

/obj/item/organ/heart/gland/access/activate()
	to_chat(owner, span_notice("不知为何，你感觉自己像个贵宾。"))
	owner.AddComponent(/datum/component/simple_access, SSid_access.get_region_access_list(list(REGION_ALL_GLOBAL)), src)
