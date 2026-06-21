// Core balance principles with these roundstart augments is that they are SLOW. 2 toolspeed minimum where possible - finding actual things in round should always be better, this is for flavor and accessibility. The accessibility alone already provides these with a lot of value.

// EYE IMPLANTS

/obj/item/organ/eyes/robotic/binoculars
	name = "数字放大光学器件"
	desc = "常用于视野相对开阔的边疆世界，以辅助视觉识别同事和目标。"
	actions_types = list(/datum/action/item_action/organ_action/toggle)
	var/zoomed = FALSE
	var/range_power = 2 // what kind of range modifier do we feed to the scope component?

/obj/item/organ/eyes/robotic/binoculars/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/scope, range_modifier = range_power)

/obj/item/organ/eyes/robotic/binoculars/ui_action_click(mob/user, actiontype)
	if (istype(actiontype, /datum/action/item_action/organ_action/toggle))
		toggle_active(user)

/obj/item/organ/eyes/robotic/binoculars/proc/toggle_active(mob/user)
	//this is so unbelievably, hysterically jank. i actually cannot believe this works. what the fuck
	var/datum/component/scope/zoom = src.GetComponent(/datum/component/scope)
	if (zoomed)
		zoom.stop_zooming(user)
		zoomed = FALSE
	else
		//check if they're blind
		if (user.is_blind())
			user.balloon_alert(user, "失明时无法激活放大功能！")
			return

		zoom.zoom(user)
		zoomed = TRUE

/obj/item/organ/eyes/robotic/binoculars/emp_act(severity)
	. = ..()
	if((. & EMP_PROTECT_SELF) || !owner)
		return
	var/do_nothing_chance = 100
	switch(severity)
		if(EMP_LIGHT)
			do_nothing_chance = 20
		if(EMP_HEAVY)
			do_nothing_chance = 10
	if(prob(do_nothing_chance))
		return
	to_chat(owner, span_warning("你的视觉放大功能发生剧烈故障！"))
	// Apply static vision overlay
	owner.overlay_fullscreen("emp_static", /atom/movable/screen/fullscreen/flash/static)
	addtimer(CALLBACK(owner, TYPE_PROC_REF(/mob, clear_fullscreen), "emp_static"), severity == EMP_LIGHT ? 0.75 SECONDS : 1.5 SECONDS)
	owner.set_eye_blur_if_lower(severity == EMP_LIGHT ? 1.5 SECONDS : 3 SECONDS)

// ARM IMPLANTS
/obj/item/organ/cyberimp/arm/toolkit/adjuster
	name = "调节臂植入体"
	desc = "一个微型工具组植入体，包含一个安装在指尖的通用螺丝刀头，带有反向扭矩扳手头。最常用于重新布置家具或其他空间站机械。"
	items_to_create = list(/obj/item/wrench/integrated, /obj/item/screwdriver/integrated)

/obj/item/organ/cyberimp/arm/toolkit/adjuster/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF || !IS_ROBOTIC_ORGAN(src))
		return
	var/effect_chance = 0
	switch(severity)
		if(EMP_LIGHT)
			effect_chance = 15
		if(EMP_HEAVY)
			effect_chance = 30
	if(prob(effect_chance) && owner)
		owner.visible_message(
			span_danger("[owner]的[active_item]突然疯狂旋转并振动！"),
			span_warning("你的调节器植入体发生故障，导致手臂不受控制地颤抖！")
		)
		if(active_item)
			Retract()
		owner.set_jitter_if_lower(severity == EMP_LIGHT ? 5 SECONDS : 10 SECONDS)
		do_sparks(2, TRUE, owner)
		playsound(owner, 'sound/items/tools/change_drill.ogg', 40, TRUE)

/obj/item/organ/cyberimp/arm/toolkit/adjuster/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/manufacturer_examine, COMPANY_NAKAMURA)

/obj/item/organ/cyberimp/arm/toolkit/electrical_toolset
	name = "电工工具组植入体"
	desc = "这种植入体没有任何绝缘可言，在边疆前哨人员中有个非常独特的绰号：'滋滋作响者'。常用于垂直高度大、负载空间宝贵的环境。"
	items_to_create = list(/obj/item/screwdriver/integrated, /obj/item/multitool/integrated, /obj/item/wirecutters/integrated)

/obj/item/organ/cyberimp/arm/toolkit/electrical_toolset/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF || !IS_ROBOTIC_ORGAN(src))
		return
	var/effect_chance = 0
	switch(severity)
		if(EMP_LIGHT)
			effect_chance = 25
		if(EMP_HEAVY)
			effect_chance = 50
	if(prob(effect_chance) && owner)
		owner.visible_message(
			span_danger("[owner]的电工工具组迸发出电弧！"),
			span_warning("你的电工工具组剧烈迸出火花，使你的手臂感到刺痛！")
		)
		if(active_item)
			Retract()
		owner.adjust_stutter(severity == EMP_LIGHT ? 5 SECONDS : 10 SECONDS)
		owner.set_jitter_if_lower(severity == EMP_LIGHT ? 7.5 SECONDS : 15 SECONDS)
		do_sparks(5, TRUE, owner)

/obj/item/organ/cyberimp/arm/toolkit/electrical_toolset/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/manufacturer_examine, COMPANY_NAKAMURA)

/obj/item/organ/cyberimp/arm/toolkit/arc_welder
	name = "拆船工工具组植入体"
	desc = "A specialized salvage-grade implant that houses an arc welder, miniaturized crowbar within the bearer's arm, plus a fingertip torque-wrench rated for enough newtons to get the job done. Renowned across the frontier for being the 'trashy tattoo' equivalent of someone's first aug."
	items_to_create = list(/obj/item/wrench/integrated, /obj/item/crowbar/integrated, /obj/item/weldingtool/electric/arc_welder/integrated)

/obj/item/organ/cyberimp/arm/toolkit/arc_welder/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF || !IS_ROBOTIC_ORGAN(src))
		return
	var/effect_chance = 0
	switch(severity)
		if(EMP_LIGHT)
			effect_chance = 20
		if(EMP_HEAVY)
			effect_chance = 40
	if(prob(effect_chance) && owner)
		owner.visible_message(
			span_danger("[owner]的电弧焊枪迸发出一阵火花！"),
			span_warning("你的电弧焊枪植入体短路了，暂时致盲了你！")
		)
		if(active_item)
			Retract()
		owner.flash_act(1, 1)
		owner.set_eye_blur_if_lower(severity == EMP_LIGHT ? 5 SECONDS : 10 SECONDS)
		do_sparks(5, TRUE, owner)
		playsound(owner, 'sound/items/tools/welder.ogg', 50, TRUE)

/obj/item/organ/cyberimp/arm/toolkit/arc_welder/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/manufacturer_examine, COMPANY_FRONTIER)

/obj/item/organ/cyberimp/arm/toolkit/emt_triage
	name = "分诊执行器植入体"
	desc = "由Interdyne制药公司为其边疆驻地首创，这套手臂内增强装置允许医疗人员在现场借助带刃器械进行基本的救生手术。"
	items_to_create = list(/obj/item/surgical_drapes/integrated, /obj/item/retractor/integrated, /obj/item/hemostat/integrated)

/obj/item/organ/cyberimp/arm/toolkit/emt_triage/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF || !IS_ROBOTIC_ORGAN(src))
		return
	var/effect_chance = 0
	switch(severity)
		if(EMP_LIGHT)
			effect_chance = 12.5
		if(EMP_HEAVY)
			effect_chance = 25
	if(prob(effect_chance) && owner)
		owner.visible_message(
			span_danger("[owner]的分诊植入体执行器不规则地抽搐着！"),
			span_warning("你的分诊植入体发生故障，导致你的手颤抖！")
		)
		if(active_item)
			Retract()
		owner.set_jitter_if_lower(severity == EMP_LIGHT ? 7.5 SECONDS : 15 SECONDS)
		do_sparks(2, TRUE, owner)

/obj/item/organ/cyberimp/arm/toolkit/emt_triage/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/manufacturer_examine, COMPANY_INTERDYNE)

/obj/item/organ/cyberimp/arm/toolkit/civilian_barstaff
	name = "侍者植入体"
	desc = "银河系服务业对其（低薪）员工要求苛刻，催生了这项可悲的技术，它用食物存储空间和集成的麂皮清洁布取代了使用者的有机手臂。为什么？"
	items_to_create = list(/obj/item/storage/bag/tray/integrated, /obj/item/rag/integrated)

/obj/item/organ/cyberimp/arm/toolkit/civilian_barstaff/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF || !IS_ROBOTIC_ORGAN(src))
		return
	var/effect_chance = 0
	switch(severity)
		if(EMP_LIGHT)
			effect_chance = 17.5
		if(EMP_HEAVY)
			effect_chance = 35
	if(prob(effect_chance) && owner)
		// Find the tray in our items and spill its contents
		for(var/datum/weakref/item_ref in items_list)
			var/obj/item/storage/bag/tray/tray = item_ref.resolve()
			if(!istype(tray))
				continue
			var/spilled_items = FALSE
			for(var/obj/item/stored_item in tray.contents)
				stored_item.forceMove(get_turf(owner))
				var/throw_target = get_edge_target_turf(owner, pick(GLOB.cardinals))
				stored_item.throw_at(throw_target, rand(1, 2), rand(1, 2))
				spilled_items = TRUE
			if(spilled_items)
				owner.visible_message(
					span_danger("[owner]的餐盘猛烈地弹出了里面的东西！"),
					span_warning("你的餐盘植入体发生故障，洒出了所有东西！")
				)
				do_sparks(2, TRUE, owner)
				playsound(owner, 'sound/items/trayhit/trayhit1.ogg', 50, TRUE)
			break

/obj/item/organ/cyberimp/arm/toolkit/civilian_lighter
	name = "拇指尖打火机植入体"
	desc = "这个极其无用的植入体是市场需求下的产物，它的存在是因为银河系流散族群显然渴望能用拇指尖点燃东西的能力。"
	items_to_create = list(/obj/item/lighter/integrated)

/obj/item/organ/cyberimp/arm/toolkit/civilian_lighter/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF || !IS_ROBOTIC_ORGAN(src))
		return
	var/effect_chance = 0
	switch(severity)
		if(EMP_LIGHT)
			effect_chance = 15
		if(EMP_HEAVY)
			effect_chance = 30
	if(prob(effect_chance) && owner)
		owner.visible_message(
			span_danger("[owner]的拇指尖打火机反复迸出火花！"),
			span_warning("你的拇指尖打火机发生故障，不受控制地迸出火花！")
		)
		do_sparks(3, TRUE, owner)
		owner.adjust_fire_stacks(1)
		playsound(owner, 'sound/items/lighter/lighter_on.ogg', 50, TRUE)

/obj/item/organ/cyberimp/arm/toolkit/blacksteel_forging
	name = "Blacksteel 'Starforge' metalworking toolset implant"
	desc = "这款不太可能的工具组增强体是基金会最受欢迎的产品之一，深受那些对基础冶金学或普通武器着迷的新兴星际种族喜爱。"
	items_to_create = list(/obj/item/forging/hammer/integrated, /obj/item/forging/tongs/integrated, /obj/item/forging/billow/integrated)

/obj/item/organ/cyberimp/arm/toolkit/blacksteel_forging/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF || !IS_ROBOTIC_ORGAN(src))
		return
	var/effect_chance = 0
	switch(severity)
		if(EMP_LIGHT)
			effect_chance = 17.5
		if(EMP_HEAVY)
			effect_chance = 35
	if(prob(effect_chance) && owner)
		owner.visible_message(
			span_danger("[owner]的锻造植入体嘶嘶作响并冒出蒸汽！"),
			span_warning("你的锻造植入体过热，令人不适！")
		)
		if(active_item)
			Retract()
		owner.adjust_bodytemperature(severity == EMP_LIGHT ? 10 * BODYTEMP_NORMAL : 5 * BODYTEMP_NORMAL)
		do_sparks(3, TRUE, owner)
		playsound(owner, 'sound/items/tools/welder.ogg', 40, TRUE)

/obj/item/organ/cyberimp/arm/toolkit/blacksteel_forging/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/manufacturer_examine, COMPANY_BLACKSTEEL)

/obj/item/organ/cyberimp/arm/toolkit/bureaucracy
	name = "bureaucrat's 'Jacent' toolset implant"
	desc = "在核心世界企业人士中颇受欢迎，这套集成工具组包含一支腕鞘式四色笔、一个可容纳最多十张银河标准A4纸的特殊电动纸夹中空槽，以及一套用于批准和否决事务的双指尖印章。无法补充。"
	items_to_create = list(/obj/item/pen/fourcolor/integrated, /obj/item/paper_bin/integrated, /obj/item/stamp/granted/integrated, /obj/item/stamp/denied/integrated)

/obj/item/organ/cyberimp/arm/toolkit/bureaucracy/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF || !IS_ROBOTIC_ORGAN(src))
		return
	if(!owner)
		return
	// Find the paper bin in our items
	for(var/datum/weakref/item_ref in items_list)
		var/obj/item/paper_bin/bin = item_ref.resolve()
		if(!istype(bin))
			continue
		// Spew out all the paper dramatically
		var/papers_spat_out = 0 // how much paper have we spewed so far
		while(bin.total_paper > 0 && papers_spat_out < 5) // Limit to 5 papers to avoid spam
			var/obj/item/paper/paper = new(get_turf(owner))
			paper.pixel_x = rand(-10, 10)
			paper.pixel_y = rand(-10, 10)
			var/throw_target = get_edge_target_turf(owner, pick(GLOB.cardinals))
			paper.throw_at(throw_target, rand(1, 3), rand(1, 2))
			bin.total_paper--
			papers_spat_out++
		if(papers_spat_out > 0)
			owner.visible_message(
				span_warning("[owner]的手臂突然向四面八方喷出纸张！"),
				span_warning("你的官僚主义植入体发生故障，纸张喷得到处都是！")
			)
			playsound(owner, 'sound/items/poster/poster_ripped.ogg', 50, TRUE)
		break

/obj/item/organ/cyberimp/arm/toolkit/cargo
	name = "FTU 'Deckhand' toolset implant"
	desc = "包含一个指尖安装的通用扫描仪和一个开箱刀，该星区的甲板工人青睐这种廉价而有效的植入体，既可作为应对愤怒消费者的自卫手段，又能将一套便捷的扫描仪真正地保持在手边。"
	items_to_create = list(/obj/item/universal_scanner/integrated, /obj/item/boxcutter/extended/integrated)

/obj/item/organ/cyberimp/arm/toolkit/cargo/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF || !IS_ROBOTIC_ORGAN(src))
		return
	var/effect_chance = 0
	switch(severity)
		if(EMP_LIGHT)
			effect_chance = 12.5
		if(EMP_HEAVY)
			effect_chance = 25
	if(prob(effect_chance) && owner)
		owner.visible_message(
			span_danger("[owner]的货运植入体迸出火花并发生故障！"),
			span_warning("你的货运植入体短暂短路了！")
		)
		do_sparks(3, TRUE, owner)
		if(active_item)
			Retract()
		owner.set_jitter_if_lower(severity == EMP_LIGHT ? 4 SECONDS : 8 SECONDS)
