#define SHOWCASE_CONSTRUCTED 1
#define SHOWCASE_SCREWDRIVERED 2

/*Completely generic structures for use by mappers to create fake objects, i.e. display rooms*/
/obj/structure/showcase
	name = "展品"
	icon = 'icons/obj/fluff/general.dmi'
	icon_state = "showcase_1"
	desc = "一个用螺栓固定着一个赛博的展台。"
	density = TRUE
	anchored = TRUE
	var/deconstruction_state = SHOWCASE_CONSTRUCTED

/obj/structure/showcase/fakeid
	name = "\improper 中央指挥部识别控制台"
	desc = "您可以使用这东西更改ID。"
	icon = 'icons/obj/machines/computer.dmi'
	icon_state = "computer"

/obj/structure/showcase/fakeid/Initialize(mapload)
	. = ..()
	add_overlay("id")
	add_overlay("id_key")

/obj/structure/showcase/fakesec
	name = "\improper 中央指挥部安全记录"
	desc = "用于查看和编辑人员的安全记录。"
	icon = 'icons/obj/machines/computer.dmi'
	icon_state = "computer"

/obj/structure/showcase/fakesec/update_overlays()
	. = ..()
	. += "security"
	. += "security_key"

/obj/structure/showcase/horrific_experiment
	name = "可怕的实验"
	desc = "某种装满了血液和内脏的吊舱，你发誓你能看到它在移动……"
	icon = 'icons/obj/machines/cloning.dmi'
	icon_state = "pod_g" // Please don't delete it and not notice it for months this time.

/obj/structure/showcase/machinery/oldpod
	name = "损坏的低温舱"
	desc = "一个受损的低温舱，包括它的前乘客，很久以前就陨灭了。"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper-open"

/obj/structure/showcase/machinery/oldpod/used
	name = "已打开的低温舱"
	desc = "一个低温舱最近释放了它的乘客，似乎无法正常工作。"

/obj/structure/showcase/machinery/oldpod/used/psyker
	name = "已开启的精神能量激发器"
	desc = "一台最近刚释放了乘员的精神能量激发器。该舱体看起来已无法运作。"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "psykerpod-open"

/obj/structure/showcase/cyborg/old
	name = "赛博雕像"
	desc = "一个老的、停用的赛博，虽然它曾经被积极地用来防范入侵者，但现在它只是用它冷酷、钢铁般的凝视吓唬他们。"
	icon = 'icons/mob/silicon/robots.dmi'
	icon_state = "robot_old"
	density = FALSE

/obj/structure/showcase/mecha/marauder
	name = "战斗机甲展览品"
	desc = "一个架子上装着一台空置的纳米传讯公司老旧战斗机甲，它被描述为用于保护公司利益和员工的首要单位。"
	icon = 'icons/mob/rideables/mecha.dmi'
	icon_state = "marauder"

/obj/structure/showcase/mecha/ripley
	name = "建筑机械展览品"
	desc = "一个用螺栓固定着一个退役建筑机械展览品，夹具的额定值为9300PSI，似乎马上要崩开了。"
	icon = 'icons/mob/rideables/mecha.dmi'
	icon_state = "firefighter"

/obj/structure/showcase/machinery/implanter
	name = "\improper 纳米传讯自动心盾植入仓展品"
	desc = "一个标准的纳米传讯自动心盾植入仓劣质展品。现有了安全的定位线束与机械手术注射器，脑损伤与其他严重的医学事故可能性降低了60%！"
	icon = 'icons/obj/machines/implant_chair.dmi'
	icon_state = "implantchair"

/obj/structure/showcase/machinery/microwave
	name = "\improper 纳米传讯牌微波炉"
	desc = "著名的纳米传讯牌牌微波炉，每个空间站都需要的多功能烹饪用具！这一个似乎是用纸板箱画的。"
	icon = 'icons/obj/machines/microwave.dmi'
	icon_state = "mw_complete"

/obj/structure/showcase/machinery/microwave_engineering
	name = "\improper 纳米特拉森 Wave(tm) 微波炉"
	desc = "Just when everyone thought Nanotrasen couldn't improve on their famous microwave, this 2563 model features Wave™! A Nanotrasen exclusive, Wave™ allows your PDA to be charged wirelessly through microwave frequencies. Because nothing says 'future' like charging your PDA while overcooking your leftovers. Nanotrasen Wave™ - Multitasking, redefined."
	icon = 'icons/obj/machines/microwave.dmi'
	icon_state = "engi_mw_complete"

/obj/structure/showcase/machinery/cloning_pod
	name = "克隆吊舱展览品"
	desc = "描述了可靠克隆技术失败尝试的原型，在出现严重突变、摇摆耳朵综合症和自发性尾巴生长的报道后，这项技术被废弃，底座上刻有日期11.11.2558。"
	icon = 'icons/obj/machines/cloning.dmi'
	icon_state = "pod_0"

/obj/structure/showcase/perfect_employee
	name = "‘完人’员工展览品"
	desc = "一个展台上挂着一个完美的纳米传讯员工模型，有迹象表明，它是经过基因改造的，而且非常忠诚。"

/obj/structure/showcase/machinery/tv
	name = "\improper 纳米传讯公司新闻提要"
	desc = "一台看起来有点破旧的电视，各种纳米传讯信息广告循环播放，伴随着欢快的曲调。"
	icon = 'icons/obj/machines/computer.dmi'
	icon_state = "television"

/obj/structure/showcase/machinery/signal_decrypter
	name = "子系统信号解密器"
	desc = "一种奇怪的机器，据说是用来帮助拾取和解密信号波的。"
	icon = 'icons/obj/machines/telecomms.dmi'
	icon_state = "processor"

/obj/structure/showcase/wizard
	name = "wizard of yendor 展品"
	desc = "一位对巫师联盟非常重要的历史人物，他花了漫长的一生学习魔术，偷窃神器，并用剑骚扰白痴，愿他永远安息，罗德尼。"
	icon = 'icons/mob/simple/mob.dmi'
	icon_state = "nim"

/obj/structure/showcase/machinery/rng
	name = "byond随机数生成器"
	desc = "一台被认为来自另一个世界的奇怪机器，多年来，巫师联合会一直在干预此事。"
	icon = 'icons/obj/machines/telecomms.dmi'
	icon_state = "processor"

/obj/structure/showcase/katana
	name = "切腹武士刀"
	desc = "好吧，只有一种方法可以挽回你的名誉。"
	density = 0
	icon = 'icons/obj/weapons/sword.dmi'
	icon_state = "katana"

//Deconstructing
//Showcases can be any sprite, so it makes sense that they can't be constructed.
//However if a player wants to move an existing showcase or remove one, this is for that.

/obj/structure/showcase/screwdriver_act(mob/living/user, obj/item/tool)
	if(anchored)
		return FALSE
	if(deconstruction_state == SHOWCASE_SCREWDRIVERED)
		to_chat(user, span_notice("你将螺丝拧回了展示柜。"))
		tool.play_tool_sound(src, 100)
		deconstruction_state = SHOWCASE_CONSTRUCTED
	else if (deconstruction_state == SHOWCASE_CONSTRUCTED)
		to_chat(user, span_notice("你拧松了螺丝。"))
		tool.play_tool_sound(src, 100)
		deconstruction_state = SHOWCASE_SCREWDRIVERED
	return ITEM_INTERACT_SUCCESS

/obj/structure/showcase/crowbar_act(mob/living/user, obj/item/tool)
	if(!tool.use_tool(src, user, 2 SECONDS, volume=100))
		return
	to_chat(user, span_notice("你开始用撬棍撬开展示柜..."))
	new /obj/item/stack/sheet/iron(drop_location(), 4)
	qdel(src)
	return ITEM_INTERACT_SUCCESS

/obj/structure/showcase/wrench_act(mob/living/user, obj/item/tool)
	if(deconstruction_state != SHOWCASE_CONSTRUCTED)
		return FALSE
	default_unfasten_wrench(user, tool)
	return ITEM_INTERACT_SUCCESS

//Feedback is given in examine because showcases can basically have any sprite assigned to them

/obj/structure/showcase/examine(mob/user)
	. = ..()

	switch(deconstruction_state)
		if(SHOWCASE_CONSTRUCTED)
			. += "It's fully constructed."
		if(SHOWCASE_SCREWDRIVERED)
			. += "It has its screws loosened."
		else
			. += "If you see this, something is wrong."

#undef SHOWCASE_CONSTRUCTED
#undef SHOWCASE_SCREWDRIVERED
