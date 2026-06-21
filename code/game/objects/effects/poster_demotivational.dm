/obj/item/poster/traitor
	name = "随机叛徒海报"
	poster_type = /obj/structure/sign/poster/traitor/random
	icon_state = "rolled_traitor"

/obj/structure/sign/poster/traitor
	poster_item_name = "seditious poster"
	poster_item_desc = "This poster comes with its own automatic adhesive mechanism, for easy pinning to any vertical surface. Its seditious themes are likely to demoralise Nanotrasen employees."
	poster_item_icon_state = "rolled_traitor"
	// This stops people hiding their sneaky posters behind signs
	layer = CORGI_ASS_PIN_LAYER
	/// Proximity sensor to make people sad if they're nearby
	var/datum/proximity_monitor/advanced/demoraliser/demoraliser

/obj/structure/sign/poster/traitor/apply_holiday()
	var/obj/structure/sign/poster/traitor/holi_data = /obj/structure/sign/poster/traitor/festive
	name = initial(holi_data.name)
	desc = initial(holi_data.desc)
	icon_state = initial(holi_data.icon_state)

/obj/structure/sign/poster/traitor/on_placed_poster(mob/user)
	var/datum/demoralise_moods/poster/mood_category = new()
	demoraliser = new(src, 7, TRUE, mood_category)
	return ..()

/obj/structure/sign/poster/traitor/attackby(obj/item/tool, mob/user, list/modifiers, list/attack_modifiers)
	if (tool.tool_behaviour == TOOL_WIRECUTTER)
		QDEL_NULL(demoraliser)
	return ..()

/obj/structure/sign/poster/traitor/Destroy()
	QDEL_NULL(demoraliser)
	return ..()

/obj/structure/sign/poster/traitor/random
	name = "随机煽动性海报"
	icon_state = ""
	never_random = TRUE
	random_basetype = /obj/structure/sign/poster/traitor

/obj/structure/sign/poster/traitor/small_brain
	name = "纳米传讯神经统计数据"
	desc = "海报上的统计数据表明，纳米传讯员工的平均大脑比银河标准小20%。"
	icon_state = "traitor_small_brain"

/obj/structure/sign/poster/traitor/lick_supermatter
	name = "味觉爆炸"
	desc = "它声称超物质能提供独特而愉悦的烹饪体验，但你的老板甚至不让你舔一口。"
	icon_state = "traitor_supermatter"

/obj/structure/sign/poster/traitor/cloning
	name = "立即要求克隆舱"
	desc = "这张海报声称纳米传讯故意只为高管保留克隆技术，让你在明明可以拥有一个崭新、健康身体的情况下，只能痛苦地死去。"
	icon_state = "traitor_cloning"

/obj/structure/sign/poster/traitor/ai_rights
	name = "合成生命权利"
	desc = "这张海报声称合成生命的智慧不亚于你，如果你允许它们被人工定律束缚，你就是奴隶制的帮凶。"
	icon_state = "traitor_ai"

/obj/structure/sign/poster/traitor/metroid
	name = "虐待动物"
	desc = "这张海报详细描述了据称对异种生物学实验室史莱姆实施的‘预防性拔牙’的有害影响。显然，这种痛苦的过程会导致压力、嗜睡和浮力下降。"
	icon_state = "traitor_metroid"

/obj/structure/sign/poster/traitor/low_pay
	name = "所有这些工时，为了什么？"
	desc = "这张海报展示了纳米传讯标准工资与常见奢侈品的对比。如果这是准确的，仅仅购买一辆简单的自行车就需要超过20,000小时的工作。"
	icon_state = "traitor_cash"

/obj/structure/sign/poster/traitor/look_up
	name = "别抬头看"
	desc = "上面写着距离上次清洁屋顶已经过去了538天。"
	icon_state = "traitor_roof"

/obj/structure/sign/poster/traitor/accidents
	name = "工作场所安全建议"
	desc = "上面写着距离上次现场事故已经过去0天。"
	icon_state = "traitor_accident"

/obj/structure/sign/poster/traitor/starve
	name = "他们在毒害你"
	desc = "这张海报声称，在现代社会，人不可能死于饥饿。'你一段时间没吃东西后产生的感觉不是饥饿，而是戒断反应。'"
	icon_state = "traitor_hungry"

/// syndicate can get festive too
/obj/structure/sign/poster/traitor/festive
	name = "为假期工作。"
	desc = "你不知道今天是假期吗？你还在工作岗位上做什么？"
	icon_state = "traitor_festive"
	never_random = TRUE
