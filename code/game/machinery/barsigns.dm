/obj/machinery/barsign // All Signs are 64 by 32 pixels, they take two tiles
	name = "酒吧招牌"
	desc = "一个尚未初始化的酒吧招牌，不知为何。向程序员抱怨吧！"
	icon = 'icons/obj/machines/barsigns.dmi'
	icon_state = "empty"
	req_access = list(ACCESS_BAR)
	max_integrity = 500
	integrity_failure = 0.5
	armor_type = /datum/armor/sign_barsign
	active_power_usage = BASE_MACHINE_ACTIVE_CONSUMPTION * 0.15
	/// Selected barsign being used
	var/datum/barsign/chosen_sign
	/// Do we attempt to rename the area we occupy when the chosen sign is changed?
	var/change_area_name = FALSE
	/// What kind of sign do we drop upon being disassembled?
	var/disassemble_result = /obj/item/wallframe/barsign

/datum/armor/sign_barsign
	melee = 20
	bullet = 20
	laser = 20
	energy = 100
	fire = 50
	acid = 50

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/barsign, 32)

/obj/machinery/barsign/Initialize(mapload)
	. = ..()
	//Roundstart/map specific barsigns "belong" in their area and should be renaming it, signs created from wallmounts will not.
	change_area_name = mapload
	set_sign(new /datum/barsign/hiddensigns/signoff)
	if(mapload)
		find_and_mount_on_atom()

/obj/machinery/barsign/proc/set_sign(datum/barsign/sign)
	if(!istype(sign))
		return

	var/area/bar_area = get_area(src)
	if(change_area_name && sign.rename_area)
		rename_area(bar_area, sign.name)

	chosen_sign = sign
	update_appearance()

/obj/machinery/barsign/update_icon_state()
	if(!(machine_stat & BROKEN) && (!(machine_stat & NOPOWER) || machine_stat & EMPED) && chosen_sign && chosen_sign.icon_state)
		icon_state = chosen_sign.icon_state
	else
		icon_state = "empty"

	return ..()

/obj/machinery/barsign/update_desc()
	. = ..()

	if(chosen_sign && chosen_sign.desc)
		desc = chosen_sign.desc

/obj/machinery/barsign/update_name()
	. = ..()
	if(chosen_sign && chosen_sign.rename_area)
		name = "[initial(name)] ([chosen_sign.name])"
	else
		name = "[initial(name)]"

/obj/machinery/barsign/update_overlays()
	. = ..()

	if(((machine_stat & NOPOWER) && !(machine_stat & EMPED)) || (machine_stat & BROKEN))
		return

	if(chosen_sign && chosen_sign.light_mask)
		. += emissive_appearance(icon, "[chosen_sign.icon_state]-light-mask", src)

/obj/machinery/barsign/update_appearance(updates=ALL)
	. = ..()
	if(machine_stat & (NOPOWER|BROKEN))
		set_light(0)
		return
	if(chosen_sign && chosen_sign.neon_color)
		set_light(MINIMUM_USEFUL_LIGHT_RANGE, 0.7, chosen_sign.neon_color)

/obj/machinery/barsign/proc/set_sign_by_name(sign_name)
	for(var/datum/barsign/sign as anything in subtypesof(/datum/barsign))
		if(initial(sign.name) == sign_name)
			var/new_sign = new sign
			set_sign(new_sign)

/obj/machinery/barsign/atom_break(damage_flag)
	. = ..()
	if(machine_stat & BROKEN)
		set_sign(new /datum/barsign/hiddensigns/signoff)

/obj/machinery/barsign/on_deconstruction(disassembled)
	if(disassembled)
		new disassemble_result(drop_location())
	else
		new /obj/item/stack/sheet/iron(drop_location(), 2)
		new /obj/item/stack/cable_coil(drop_location(), 2)

/obj/machinery/barsign/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			playsound(src.loc, 'sound/effects/glass/glasshit.ogg', 75, TRUE)
		if(BURN)
			playsound(src.loc, 'sound/items/tools/welder.ogg', 100, TRUE)

/obj/machinery/barsign/attack_ai(mob/user)
	return attack_hand(user)

/obj/machinery/barsign/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(!allowed(user))
		balloon_alert(user, "访问被拒绝！")
		return
	if(machine_stat & (NOPOWER|BROKEN|EMPED))
		balloon_alert(user, "控制无响应！")
		return
	pick_sign(user)

/obj/machinery/barsign/screwdriver_act(mob/living/user, obj/item/tool)
	tool.play_tool_sound(src)
	panel_open = !panel_open
	if(panel_open)
		balloon_alert(user, "面板已打开")
		set_sign(new /datum/barsign/hiddensigns/signoff)
		return ITEM_INTERACT_SUCCESS

	balloon_alert(user, "面板已关闭")

	if(machine_stat & (NOPOWER|BROKEN) || !chosen_sign)
		set_sign(new /datum/barsign/hiddensigns/signoff)
	else
		set_sign(chosen_sign)

	return ITEM_INTERACT_SUCCESS

/obj/machinery/barsign/wrench_act(mob/living/user, obj/item/tool)
	if(!panel_open)
		balloon_alert(user, "先打开面板！")
		return ITEM_INTERACT_BLOCKING

	tool.play_tool_sound(src)
	if(!do_after(user, (10 SECONDS), target = src))
		return ITEM_INTERACT_BLOCKING

	tool.play_tool_sound(src)
	deconstruct(disassembled = TRUE)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/barsign/attackby(obj/item/attacking_item, mob/user)

	if(istype(attacking_item, /obj/item/blueprints) && !change_area_name)
		if(!panel_open)
			balloon_alert(user, "先打开面板！")
			return TRUE

		change_area_name = TRUE
		balloon_alert(user, "招牌已注册")
		return TRUE

	if(istype(attacking_item, /obj/item/stack/cable_coil) && panel_open)
		var/obj/item/stack/cable_coil/wire = attacking_item

		if(atom_integrity >= max_integrity)
			balloon_alert(user, "不需要修理！")
			return TRUE

		if(!wire.use(2))
			balloon_alert(user, "需要两根电缆！")
			return TRUE

		balloon_alert(user, "已修复")
		atom_integrity = max_integrity
		set_machine_stat(machine_stat & ~BROKEN)
		update_appearance()
		return TRUE

	return ..()

/obj/machinery/barsign/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return

	set_machine_stat(machine_stat | EMPED)
	addtimer(CALLBACK(src, PROC_REF(fix_emp), chosen_sign), 60 SECONDS)
	set_sign(new /datum/barsign/hiddensigns/empbarsign)

/// Callback to un-emp the sign some time.
/obj/machinery/barsign/proc/fix_emp(datum/barsign/sign)
	set_machine_stat(machine_stat & ~EMPED)
	if(!istype(sign))
		return

	set_sign(sign)

/obj/machinery/barsign/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(machine_stat & (NOPOWER|BROKEN|EMPED))
		balloon_alert(user, "控制无响应！")
		return FALSE

	balloon_alert(user, "非法酒吧招牌已加载")
	addtimer(CALLBACK(src, PROC_REF(finish_emag_act)), 10 SECONDS)
	return TRUE

/// Timer proc, called after ~10 seconds after [emag_act], since [emag_act] returns a value and cannot sleep
/obj/machinery/barsign/proc/finish_emag_act()
	set_sign(new /datum/barsign/hiddensigns/syndibarsign)

/obj/machinery/barsign/proc/pick_sign(mob/user)
	var/picked_name = tgui_input_list(user, "可用招牌", "酒吧招牌", sort_list(get_bar_names()))
	if(isnull(picked_name))
		return
	set_sign_by_name(picked_name)
	SSblackbox.record_feedback("tally", "barsign_picked", 1, chosen_sign.type)

/proc/get_bar_names()
	var/list/names = list()
	for(var/d in subtypesof(/datum/barsign))
		var/datum/barsign/D = d
		if(!initial(D.hidden))
			names += initial(D.name)
	. = names

/datum/barsign
	/// User-visible name of the sign.
	var/name
	/// Icon state associated with this sign
	var/icon_state
	/// Description shown in the sign's examine text.
	var/desc
	/// Hidden from list of selectable options.
	var/hidden = FALSE
	/// Rename the area when this sign is selected.
	var/rename_area = TRUE
	/// If a barsign has a light mask for emission effects
	var/light_mask = TRUE
	/// The emission color of the neon light
	var/neon_color

/datum/barsign/New()
	if(!desc)
		desc = "它显示着\"[name]\"。"

// Specific bar signs.

/datum/barsign/maltesefalcon
	name = "马耳他之鹰"
	icon_state = "maltesefalcon"
	desc = "马耳他之鹰，太空酒吧与烧烤。"
	neon_color = "#5E8EAC"

/datum/barsign/thebark
	name = "吠叫酒吧"
	icon_state = "thebark"
	desc = "伊恩的首选酒吧。"
	neon_color = "#f7a604"

/datum/barsign/harmbaton
	name = "和谐警棍"
	icon_state = "theharmbaton"
	desc = "为安保人员和助手提供绝佳的用餐体验。"
	neon_color = "#ff7a4d"

/datum/barsign/thesingulo
	name = "奇点酒吧"
	icon_state = "thesingulo"
	desc = "人们宁愿不被人直呼其名时去的地方。"
	neon_color = "#E600DB"

/datum/barsign/thedrunkcarp
	name = "醉鲤酒吧"
	icon_state = "thedrunkcarp"
	desc = "请勿酒后游泳。"
	neon_color = "#a82196"

/datum/barsign/scotchservinwill
	name = "威利苏格兰酒馆"
	icon_state = "scotchservinwill"
	desc = "威利确实从一个小丑晋升为酒保了。"
	neon_color = "#fee4bf"

/datum/barsign/officerbeersky
	name = "比尔斯基警官酒馆"
	icon_state = "officerbeersky"
	desc = "老天，这些饮料真棒。"
	neon_color = "#16C76B"

/datum/barsign/thecavern
	name = "洞穴酒吧"
	icon_state = "thecavern"
	desc = "美酒佳酿，伴以动人旋律。"
	neon_color = "#0fe500"

/datum/barsign/theouterspess
	name = "外层空间"
	icon_state = "theouterspess"
	desc = "这家酒吧其实并不在外太空。"
	neon_color = "#30f3cc"

/datum/barsign/slipperyshots
	name = "滑溜小酌"
	icon_state = "slipperyshots"
	desc = "用我们的酒滑向醉意的深渊吧！"
	neon_color = "#70DF00"

/datum/barsign/thegreytide
	name = "灰色浪潮"
	icon_state = "thegreytide"
	desc = "放下你的工具箱，来杯慵懒的啤酒吧！"
	neon_color = "#00F4D6"

/datum/barsign/honkednloaded
	name = "Honked 'n' Loaded"
	icon_state = "honkednloaded"
	desc = "鸣笛。"
	neon_color = "#FF998A"

/datum/barsign/le_cafe_silencieux
	name = "静谧咖啡馆"
	icon_state = "le_cafe_silencieux"
	desc = "..."
	neon_color = "#ffffff"

/datum/barsign/thenest
	name = "巢穴"
	icon_state = "thenest"
	desc = "在漫长一夜的打击犯罪后，这是个退休小酌的好地方。"
	neon_color = "#4d6796"

/datum/barsign/thecoderbus
	name = "代码巴士"
	icon_state = "thecoderbus"
	desc = "一家以种类繁多且不断变化的饮品而闻名的极具争议的酒吧。"
	neon_color = "#ffffff"

/datum/barsign/theadminbus
	name = "管理巴士"
	icon_state = "theadminbus"
	desc = "一家主要由太空法官光顾的场所。它被炸的次数远不及法庭听证会那么多。"
	neon_color = "#ffffff"

/datum/barsign/oldcockinn
	name = "老雄鸡旅馆"
	icon_state = "oldcockinn"
	desc = "这个招牌的某些地方让你充满了绝望。"
	neon_color = "#a4352b"

/datum/barsign/thewretchedhive
	name = "悲惨巢穴"
	icon_state = "thewretchedhive"
	desc = "法律义务提醒您在饮用前检查饮料中是否含有酸性物质。"
	neon_color = "#26b000"

/datum/barsign/robustacafe
	name = "罗布斯塔咖啡馆"
	icon_state = "robustacafe"
	desc = "连续5年保持'最致命酒吧斗殴'纪录的持有者。"
	neon_color = "#c45f7a"

/datum/barsign/emergencyrumparty
	name = "紧急朗姆酒派对"
	icon_state = "emergencyrumparty"
	desc = "在长期停业后最近重新获得了执照。"
	neon_color = "#f90011"

/datum/barsign/combocafe
	name = "组合咖啡馆"
	icon_state = "combocafe"
	desc = "因其毫无创意的饮品组合而在整个星系闻名。"
	neon_color = "#33ca40"

/datum/barsign/vladssaladbar
	name = "弗拉德的沙拉吧"
	icon_state = "vladssaladbar"
	desc = "现已更换管理层。弗拉德用那把霰弹枪总是有点过于手痒。"
	neon_color = "#306900"

/datum/barsign/theshaken
	name = "摇匀酒吧"
	icon_state = "theshaken"
	desc = "本店不提供搅拌过的饮品。"
	neon_color = "#dcd884"

/datum/barsign/thealenath
	name = "艾尔·纳特酒吧"
	icon_state = "thealenath"
	desc = "好了，伙计。我觉得你已经喝够EI NATH了。是时候叫辆出租车了。"
	neon_color = "#ed0000"

/datum/barsign/thealohasnackbar
	name = "阿罗哈小吃吧"
	icon_state = "alohasnackbar"
	desc = "一个雅致、不冒犯人的提基酒吧招牌。"
	neon_color = ""

/datum/barsign/thenet
	name = "网络酒吧"
	icon_state = "thenet"
	desc = "你似乎会沉浸其中好几个小时。"
	neon_color = "#0e8a00"

/datum/barsign/maidcafe
	name = "女仆咖啡馆"
	icon_state = "maidcafe"
	desc = "欢迎回来，主人！"
	neon_color = "#ff0051"

/datum/barsign/the_lightbulb
	name = "灯泡酒吧"
	icon_state = "the_lightbulb"
	desc = "一家深受飞蛾和蛾人欢迎的咖啡馆。曾因酒保用樟脑丸保护她的备用制服而停业一周。"
	neon_color = "#faff82"

/datum/barsign/goose
	name = "逍遥鹅"
	icon_state = "goose"
	desc = "喝到吐，和/或打破现实法则！"
	neon_color = "#00cc33"

/datum/barsign/maltroach
	name = "麦芽蟑螂"
	icon_state = "maltroach"
	desc = "蛾蟑螂礼貌地欢迎你进入酒吧，或者它们是在互相打招呼？"
	neon_color = "#649e8a"

/datum/barsign/rock_bottom
	name = "谷底"
	icon_state = "rock-bottom"
	desc = "当你感觉困在坑里时，不妨喝一杯。"
	neon_color = "#aa2811"

/datum/barsign/orangejuice
	name = "橙子榨汁坊"
	icon_state = "orangejuice"
	desc = "为那些希望对不饮酒人群保持最佳礼貌的人而设。"
	neon_color = COLOR_ORANGE

/datum/barsign/tearoom
	name = "小点心茶室"
	icon_state = "little_treats"
	desc = "一家令人愉悦的放松茶室，献给宇宙中所有时髦的绅士。"
	neon_color = COLOR_LIGHT_ORANGE

/datum/barsign/assembly_line
	name = "流水线"
	icon_state = "the-assembly-line"
	desc = "这里的每一杯饮品都以工业效率精心打造！"
	neon_color = "#ffffff"

/datum/barsign/bargonia
	name = "巴戈尼亚"
	icon_state = "bargonia"
	desc = "仓库渴望着更高的使命……于是供应部宣布了巴戈尼亚的成立！"
	neon_color = COLOR_WHITE

/datum/barsign/cult_cove
	name = "邪教湾"
	icon_state = "cult-cove"
	desc = "Nar'Sie's favourite retreat"
	neon_color = COLOR_RED

/datum/barsign/neon_flamingo
	name = "霓虹火烈鸟"
	icon_state = "neon-flamingo"
	desc = "一辆为所有人服务的巴士，除了那些缺乏浮夸天赋的人。"
	neon_color = COLOR_PINK

/datum/barsign/slowdive
	name = "慢潜"
	icon_state = "slowdive"
	desc = "地狱后的第一站，天堂前的最后一站。"
	neon_color = COLOR_RED

/datum/barsign/the_red_mons
	name = "红山"
	icon_state = "the-red-mons"
	desc = "来自红色星球的饮品。"
	neon_color = COLOR_RED

/datum/barsign/the_rune
	name = "符文"
	icon_state = "therune"
	desc = "现实扭曲饮品。"
	neon_color = COLOR_RED

/datum/barsign/the_wizard
	name = "巫师"
	icon_state = "the-wizard"
	desc = "魔法调酒。"
	neon_color = COLOR_RED

/datum/barsign/months_moths_moths
	name = "蛾蛾蛾"
	icon_state = "moths-moths-moths"
	desc = "活蛾子！"
	neon_color = COLOR_RED

/datum/barsign/coldones
	name = "冷饮"
	icon_state = "cold-ones"
	desc = "他们管这叫酸奶效应。"
	neon_color = ""

/datum/barsign/doctorsorders
	name = "医嘱"
	icon_state = "doctors-orders"
	desc = "专供非处方止痛药。"
	neon_color = ""

/datum/barsign/wrongturn
	name = "错路"
	icon_state = "wrong-turn"
	desc = "你并不感到迷茫。不过，几杯酒下肚总能解决一切。"
	neon_color = ""

/datum/barsign/punpunspub
	name = "潘潘酒馆"
	icon_state = "pun-puns-pub"
	desc = "经历了那么多之后？我也想待在酒旁边。"
	neon_color = ""

// Hidden signs list below this point

/datum/barsign/hiddensigns
	hidden = TRUE

/datum/barsign/hiddensigns/empbarsign
	name = "电磁脉冲"
	icon_state = "empbarsign"
	desc = "出了大问题。"
	rename_area = FALSE

/datum/barsign/hiddensigns/syndibarsign
	name = "辛迪猫"
	icon_state = "syndibarsign"
	desc = "加入辛迪加，否则死路一条。"
	neon_color = "#ff0000"

/datum/barsign/hiddensigns/signoff
	name = "关闭"
	icon_state = "empty"
	desc = "这个招牌似乎没有亮起。"
	rename_area = FALSE
	light_mask = FALSE

// For other locations that aren't in the main bar
/obj/machinery/barsign/all_access
	req_access = null
	disassemble_result = /obj/item/wallframe/barsign/all_access

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/barsign/all_access, 32)

/obj/item/wallframe/barsign
	name = "酒吧招牌框架"
	desc = "用于吸引乌合之众进入你的酒吧。需要一些组装。"
	icon = 'icons/obj/machines/wallmounts.dmi'
	icon_state = "barsign"
	result_path = /obj/machinery/barsign
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT,
	)
	pixel_shift = 32

/obj/item/wallframe/barsign/Initialize(mapload)
	. = ..()
	desc += "可以用一套[span_bold("station blueprints")]进行注册，将招牌与其所在区域关联起来。"

/obj/item/wallframe/barsign/try_build(turf/on_wall, mob/user)
	. = ..()
	if(!.)
		return .

	if(isopenturf(get_step(on_wall, EAST))) //This takes up 2 tiles so we want to make sure we have two tiles to hang it from.
		balloon_alert(user, "需要更多支撑！")
		return FALSE

/obj/item/wallframe/barsign/all_access
	desc = "用于吸引乌合之众进入你的酒吧。需要一些组装。这个没有访问锁。"
	result_path = /obj/machinery/barsign/all_access
