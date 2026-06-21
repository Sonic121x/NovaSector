/*
CONTAINS:
BEDSHEETS
LINEN BINS
*/

/obj/item/bedsheet
	name = "床单"
	desc = "柔软到令人惊讶的亚麻床单。"
	icon = 'icons/obj/bedsheets.dmi'
	lefthand_file = 'icons/mob/inhands/items/bedsheet_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/bedsheet_righthand.dmi'
	icon_state = "sheetwhite"
	inhand_icon_state = "sheetwhite"
	drop_sound = SFX_CLOTH_DROP
	pickup_sound = SFX_CLOTH_PICKUP
	slot_flags = ITEM_SLOT_NECK
	layer = BELOW_MOB_LAYER
	throwforce = 0
	throw_speed = 1
	throw_range = 2
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	dying_key = DYE_REGISTRY_BEDSHEET
	interaction_flags_click = NEED_DEXTERITY|ALLOW_RESTING

	dog_fashion = /datum/dog_fashion/head/ghost
	/// Custom nouns to act as the subject of dreams
	var/list/dream_messages = list("white")
	/// Cutting it up will yield this.
	var/stack_type = /obj/item/stack/sheet/cloth
	/// The number of sheets dropped by this bedsheet when cut
	var/stack_amount = 3
	/// Denotes if the bedsheet is a single, double, or other kind of bedsheet
	var/bedsheet_type = BEDSHEET_SINGLE
	var/datum/weakref/signal_sleeper //this is our goldylocks

/obj/item/bedsheet/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/surgery_aid, "bedsheet")
	AddElement(/datum/element/bed_tuckable, mapload, 0, 0, 0)
	if(bedsheet_type == BEDSHEET_DOUBLE)
		stack_amount *= 2
		dying_key = DYE_REGISTRY_DOUBLE_BEDSHEET
	register_context()
	register_item_context()

/obj/item/bedsheet/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	if(istype(held_item) && (held_item.tool_behaviour == TOOL_WIRECUTTER || held_item.get_sharpness()))
		context[SCREENTIP_CONTEXT_LMB] = "Shred into cloth"

	context[SCREENTIP_CONTEXT_ALT_LMB] = "Rotate"
	return CONTEXTUAL_SCREENTIP_SET

/obj/item/bedsheet/add_item_context(datum/source, list/context, mob/living/target)
	if(isliving(target) && target.body_position == LYING_DOWN)
		context[SCREENTIP_CONTEXT_RMB] = "Cover"
		return CONTEXTUAL_SCREENTIP_SET

	return NONE

/obj/item/bedsheet/interact_with_atom_secondary(atom/interacting_with, mob/living/user, list/modifiers)
	if(!isliving(interacting_with))
		return NONE
	var/mob/living/to_cover = interacting_with
	if(to_cover.body_position != LYING_DOWN)
		return ITEM_INTERACT_BLOCKING
	if(!user.transfer_item_to_turf(src, get_turf(to_cover)))
		return ITEM_INTERACT_BLOCKING

	balloon_alert(user, "盖好了")
	coverup(to_cover)
	add_fingerprint(user)

	return ITEM_INTERACT_SUCCESS

/obj/item/bedsheet/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	// Handle wirecutters here so we still tear it up in combat mode
	if(tool.tool_behaviour != TOOL_WIRECUTTER && !tool.get_sharpness())
		return NONE

	// We cannot get free cloth from holograms
	if(flags_1 & HOLOGRAM_1)
		return ITEM_INTERACT_BLOCKING

	var/obj/item/stack/shreds = new stack_type(get_turf(src), stack_amount)
	if(!QDELETED(shreds)) // Stacks merged
		transfer_fingerprints_to(shreds)
		shreds.add_fingerprint(user)
	to_chat(user, span_notice("你撕碎了 [src]。"))
	qdel(src)
	return ITEM_INTERACT_SUCCESS

/obj/item/bedsheet/attack_self(mob/living/user)
	if(!IsReachableBy(user)) //No telekinetic grabbing.
		return
	if(user.body_position != LYING_DOWN)
		return
	if(!user.transfer_item_to_turf(src, get_turf(src)))
		return

	coverup(user)
	add_fingerprint(user)

/obj/item/bedsheet/click_alt(mob/living/user)
	setDir(REVERSE_DIR(dir))
	return CLICK_ACTION_SUCCESS

/obj/item/bedsheet/proc/coverup(mob/living/sleeper)
	layer = ABOVE_MOB_LAYER
	pixel_x = 0
	pixel_y = 0
	pixel_z = sleeper.pixel_z // Account for possible mob elevation
	balloon_alert(sleeper, "盖好了")
	var/angle = sleeper.lying_prev
	dir = angle2dir(angle + 180) // 180 flips it to be the same direction as the mob

	signal_sleeper = WEAKREF(sleeper)
	RegisterSignal(src, COMSIG_ITEM_PICKUP, PROC_REF(on_pickup))
	RegisterSignal(sleeper, COMSIG_MOVABLE_MOVED, PROC_REF(smooth_sheets))
	RegisterSignal(sleeper, COMSIG_LIVING_SET_BODY_POSITION, PROC_REF(smooth_sheets))
	RegisterSignal(sleeper, COMSIG_QDELETING, PROC_REF(smooth_sheets))

/obj/item/bedsheet/proc/smooth_sheets(mob/living/sleeper)
	SIGNAL_HANDLER

	UnregisterSignal(src, COMSIG_ITEM_PICKUP)
	UnregisterSignal(sleeper, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(sleeper, COMSIG_LIVING_SET_BODY_POSITION)
	UnregisterSignal(sleeper, COMSIG_QDELETING)
	balloon_alert(sleeper, "铺平了床单")
	layer = initial(layer)
	SET_PLANE_IMPLICIT(src, initial(plane))
	pixel_z = 0
	signal_sleeper = null

// We need to do this in case someone picks up a bedsheet while a mob is covered up
// otherwise the bedsheet will disappear while in our hands if the sleeper signals get activated by moving
/obj/item/bedsheet/proc/on_pickup(datum/source, mob/grabber)
	SIGNAL_HANDLER

	var/mob/living/sleeper = signal_sleeper?.resolve()

	UnregisterSignal(src, COMSIG_ITEM_PICKUP)
	UnregisterSignal(sleeper, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(sleeper, COMSIG_LIVING_SET_BODY_POSITION)
	UnregisterSignal(sleeper, COMSIG_QDELETING)
	pixel_z = 0
	signal_sleeper = null

/obj/item/bedsheet/blue
	icon_state = "sheetblue"
	inhand_icon_state = "sheetblue"
	dream_messages = list("blue")

/obj/item/bedsheet/green
	icon_state = "sheetgreen"
	inhand_icon_state = "sheetgreen"
	dream_messages = list("green")

/obj/item/bedsheet/grey
	icon_state = "sheetgrey"
	inhand_icon_state = "sheetgrey"
	dream_messages = list("grey")

/obj/item/bedsheet/orange
	icon_state = "sheetorange"
	inhand_icon_state = "sheetorange"
	dream_messages = list("orange")

/obj/item/bedsheet/purple
	icon_state = "sheetpurple"
	inhand_icon_state = "sheetpurple"
	dream_messages = list("purple")

/obj/item/bedsheet/patriot
	name = "爱国床单"
	desc = "当你睡在这上面时，你感到无与伦比的自由。"
	icon_state = "sheetUSA"
	inhand_icon_state = "sheetUSA"
	dream_messages = list("America", "freedom", "fireworks", "bald eagles")

/obj/item/bedsheet/rainbow
	name = "彩虹床单"
	desc = "五彩缤纷的毯子。它实际上是由几个不同的床单被切割并缝合在一起的。"
	icon_state = "sheetrainbow"
	inhand_icon_state = "sheetrainbow"
	dream_messages = list("red", "orange", "yellow", "green", "blue", "purple", "a rainbow")

/obj/item/bedsheet/red
	icon_state = "sheetred"
	inhand_icon_state = "sheetred"
	dream_messages = list("red")

/obj/item/bedsheet/yellow
	icon_state = "sheetyellow"
	inhand_icon_state = "sheetyellow"
	dream_messages = list("yellow")

/obj/item/bedsheet/mime
	name = "哑剧毛毯"
	desc = "一条非常舒服的条纹毛毯，当你在被子里的时候，所有的噪音似乎都消失了。"
	icon_state = "sheetmime"
	inhand_icon_state = "sheetmime"
	dream_messages = list("silence", "gestures", "a pale face", "a gaping mouth", "the mime")

/obj/item/bedsheet/clown
	name = "小丑毛毯"
	desc = "一条织有小丑面具图案的彩虹色毯子。它散发着淡淡的香蕉味。"
	icon_state = "sheetclown"
	inhand_icon_state = "sheetrainbow"
	dream_messages = list("honk", "laughter", "a prank", "a joke", "a smiling face", "the clown")

/obj/item/bedsheet/captain
	name = "舰长床单"
	desc = "它上面有一个纳米传讯公司的标志，是由一种全新的革命性线材织成的，这种线材对大多数非化学物质的渗透率保证能达到 0.01%。这种线材在大多数现代船长中非常受欢迎。"
	icon_state = "sheetcaptain"
	inhand_icon_state = "sheetcaptain"
	dream_messages = list("authority", "a golden ID", "sunglasses", "a green disc", "an antique gun", "the captain")

/obj/item/bedsheet/rd
	name = "科研部长的床单"
	desc = "它似乎有一个烧杯形状的标志，并且是由防火材料制成的，不过在你日常所熟悉的那种火灾情况下，它可能并不能保护你。"
	icon_state = "sheetrd"
	inhand_icon_state = "sheetrd"
	dream_messages = list("authority", "a silvery ID", "a bomb", "a mech", "a facehugger", "maniacal laughter", "the research director")

// for Free Golems.
/obj/item/bedsheet/rd/royal_cape
	name = "解放者皇家披风"
	desc = "气势恢宏。"
	dream_messages = list("mining", "stone", "a golem", "freedom", "doing whatever")

/obj/item/bedsheet/medical
	name = "医用毯"
	desc = "这是一条医疗部常用的'无菌'毯子。"
	icon_state = "sheetmedical"
	inhand_icon_state = "sheetmedical"
	dream_messages = list("healing", "life", "surgery", "a doctor")

/obj/item/bedsheet/cmo
	name = "首席医疗官床单"
	desc = "It's a sterilized blanket that has a cross emblem. There's some cat fur on it, likely from Runtime."
	icon_state = "sheetcmo"
	inhand_icon_state = "sheetcmo"
	dream_messages = list("authority", "a silvery ID", "healing", "life", "surgery", "a cat", "the chief medical officer")

/obj/item/bedsheet/hos
	name = "安保主管的床单"
	desc = "它上面装饰着一个盾形标志。尽管犯罪行为从未停歇，而你却能安然入睡，因为你依然是正义的化身！"
	icon_state = "sheethos"
	inhand_icon_state = "sheethos"
	dream_messages = list("authority", "a silvery ID", "handcuffs", "a baton", "a flashbang", "sunglasses", "the head of security")

/obj/item/bedsheet/hop
	name = "人事主管床单"
	desc = "它饰有醒目的钥匙标志图案。在那些难得的时刻，你可以与伊恩一起安静地休息、亲密相拥，而不会因为无线电里有人在呼喊你的名字而感到不安。"
	icon_state = "sheethop"
	inhand_icon_state = "sheethop"
	dream_messages = list("authority", "a silvery ID", "obligation", "a computer", "an ID", "a corgi", "the head of personnel")

/obj/item/bedsheet/ce
	name = "工程部长床单"
	desc = "它上面饰有扳手图案。其具有极佳的反光性和防污性，因此您无需担心油污会损坏它。"
	icon_state = "sheetce"
	inhand_icon_state = "sheetce"
	dream_messages = list("authority", "a silvery ID", "the engine", "power tools", "an APC", "a parrot", "the chief engineer")

/obj/item/bedsheet/qm
	name = "军需官床单"
	desc = "它上面饰有银色的板条箱图案。它非常坚固，正是在一天繁琐的文书工作之后用来休息躺下的好选择。"
	icon_state = "sheetqm"
	inhand_icon_state = "sheetqm"
	dream_messages = list("authority", "a silvery ID", "a shuttle", "a crate", "a sloth", "the quartermaster")

/obj/item/bedsheet/chaplain
	name = "牧师的毯子"
	desc = "一条由众神之心织成的毯子……等等，那不过就是普通的亚麻布罢了。"
	icon_state = "sheetchap"
	inhand_icon_state = "sheetchap"
	dream_messages = list("a grey ID", "the gods", "a fulfilled prayer", "a cult", "the chaplain")

/obj/item/bedsheet/brown
	icon_state = "sheetbrown"
	inhand_icon_state = "sheetbrown"
	dream_messages = list("brown")

/obj/item/bedsheet/black
	icon_state = "sheetblack"
	inhand_icon_state = "sheetblack"
	dream_messages = list("black")

/obj/item/bedsheet/centcom
	name = "\improper 中央指挥部床单"
	desc = "采用先进的纳米线编织而成，既保暖又装饰精美，是所有官员必备的物品。"
	icon_state = "sheetcentcom"
	inhand_icon_state = "sheetcentcom"
	dream_messages = list("a unique ID", "authority", "artillery", "an ending")

/obj/item/bedsheet/syndie
	name = "辛迪加床单"
	desc = "它有一个辛迪加的标志，而且给人一种邪恶的气息。"
	icon_state = "sheetsyndie"
	inhand_icon_state = "sheetsyndie"
	dream_messages = list("a green disc", "a red crystal", "a glowing blade", "a wire-covered ID")

/obj/item/bedsheet/cult
	name = "血教徒床单"
	desc = "如果你带着这个睡觉，可能会梦见纳西，它看起来相当破旧，散发着一种邪术的气息。"
	icon_state = "sheetcult"
	inhand_icon_state = "sheetcult"
	dream_messages = list("a tome", "a floating red crystal", "a glowing sword", "a bloody symbol", "a massive humanoid figure")

/obj/item/bedsheet/wiz
	name = "巫师床单"
	desc = "一种融入了神奇的魔力的特别织物，让您拥有一个充满魔力的夜晚。它甚至还会发光！"
	icon_state = "sheetwiz"
	inhand_icon_state = "sheetwiz"
	dream_messages = list("a book", "an explosion", "lightning", "a staff", "a skeleton", "a robe", "magic")

/obj/item/bedsheet/rev
	name = "革命者的床单"
	desc = "从中央指挥部官员卧室偷来的床单，作为反抗纳米特拉森暴政的胜利象征。正面的金色徽章已被涂鸦抹去。"
	icon_state = "sheetrev"
	inhand_icon_state = "sheetrev"
	dream_messages = list(
		"the people",
		"liberation",
		"collaboration",
		"heads rolling",
		"so, so many baseball bats",
		"blinding light",
		"your brothers in arms"
	)

/obj/item/bedsheet/nanotrasen
	name = "\improper 纳米传讯床单"
	desc = "它上面有纳米传讯的标志，给人一种使命感十足的感觉。"
	icon_state = "sheetNT"
	inhand_icon_state = "sheetNT"
	dream_messages = list("authority", "an ending")

/obj/item/bedsheet/ian
	icon_state = "sheetian"
	inhand_icon_state = "sheetian"
	dream_messages = list("a dog", "a corgi", "woof", "bark", "arf")

/obj/item/bedsheet/runtime
	icon_state = "sheetruntime"
	inhand_icon_state = "sheetruntime"
	dream_messages = list("a kitty", "a cat", "meow", "purr", "nya~")

/obj/item/bedsheet/pirate
	name = "海盗的床单"
	desc = "上面印有骷髅旗标志，散发着淡淡的格罗格酒气味。"
	icon_state = "sheetpirate"
	inhand_icon_state = "sheetpirate"
	dream_messages = list(
		"a buried treasure",
		"an island",
		"a monkey",
		"a parrot",
		"a swashbuckler",
		"a talking skull",
		"avast",
		"being a pirate",
		"'cause a pirate is free",
		"doing whatever you want",
		"gold",
		"landlubbers",
		"stealing",
		"sailing the Seven Seas",
		"yarr",
	)

/obj/item/bedsheet/gondola
	name = "冈多拉床单"
	desc = "一张用濒危奇特生物皮毛制成的珍贵床单。"
	icon_state = "sheetgondola"
	inhand_icon_state = "sheetgondola"
	dream_messages = list("peace", "comfiness", "a rare critter", "a harmless creature")
	stack_type = /obj/item/stack/sheet/animalhide/gondola
	stack_amount = 1
	///one of four icon states that represent its mouth
	var/gondola_mouth
	///one of four icon states that represent its eyes
	var/gondola_eyes

/obj/item/bedsheet/gondola/Initialize(mapload)
	. = ..()
	gondola_mouth = "sheetgondola_mouth[rand(1, 4)]"
	gondola_eyes = "sheetgondola_eyes[rand(1, 4)]"
	add_overlay(gondola_mouth)
	add_overlay(gondola_eyes)

/obj/item/bedsheet/gondola/worn_overlays(mutable_appearance/standing, isinhands, icon_file)
	. = ..()
	if(!isinhands)
		. += mutable_appearance(icon_file, gondola_mouth)
		. += mutable_appearance(icon_file, gondola_eyes)

/obj/item/bedsheet/cosmos
	name = "宇宙空间床单"
	desc = "由那些对星空充满好奇之人的梦想所铸就。"
	icon_state = "sheetcosmos"
	inhand_icon_state = "sheetcosmos"
	dream_messages = list("the infinite cosmos", "Hans Zimmer music", "a flight through space", "the galaxy", "being fabulous", "shooting stars")
	light_power = 2
	light_range = 1.4

/obj/item/bedsheet/double
	icon_state = "double_sheetwhite"
	worn_icon_state = "sheetwhite"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/blue/double
	icon_state = "double_sheetblue"
	worn_icon_state = "sheetblue"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/green/double
	icon_state = "double_sheetgreen"
	worn_icon_state = "sheetgreen"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/grey/double
	icon_state = "double_sheetgrey"
	worn_icon_state = "sheetgrey"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/orange/double
	icon_state = "double_sheetorange"
	worn_icon_state = "sheetorange"
	dying_key = DYE_REGISTRY_DOUBLE_BEDSHEET
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/purple/double
	icon_state = "double_sheetpurple"
	worn_icon_state = "sheetpurple"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/patriot/double
	icon_state = "double_sheetUSA"
	worn_icon_state = "sheetUSA"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/rainbow/double
	icon_state = "double_sheetrainbow"
	worn_icon_state = "sheetrainbow"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/red/double
	icon_state = "double_sheetred"
	worn_icon_state = "sheetred"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/yellow/double
	icon_state = "double_sheetyellow"
	worn_icon_state = "sheetyellow"
	dying_key = DYE_REGISTRY_DOUBLE_BEDSHEET
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/mime/double
	icon_state = "double_sheetmime"
	worn_icon_state = "sheetmime"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/clown/double
	icon_state = "double_sheetclown"
	worn_icon_state = "sheetclown"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/captain/double
	icon_state = "double_sheetcaptain"
	worn_icon_state = "sheetcaptain"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/rd/double
	icon_state = "double_sheetrd"
	worn_icon_state = "sheetrd"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/medical/double
	icon_state = "double_sheetmedical"
	worn_icon_state = "sheetmedical"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/cmo/double
	icon_state = "double_sheetcmo"
	worn_icon_state = "sheetcmo"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/hos/double
	icon_state = "double_sheethos"
	worn_icon_state = "sheethos"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/hop/double
	icon_state = "double_sheethop"
	worn_icon_state = "sheethop"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/ce/double
	icon_state = "double_sheetce"
	worn_icon_state = "sheetce"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/qm/double
	icon_state = "double_sheetqm"
	worn_icon_state = "sheetqm"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/chaplain/double
	icon_state = "double_sheetchap"
	worn_icon_state = "sheetchap"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/brown/double
	icon_state = "double_sheetbrown"
	worn_icon_state = "sheetbrown"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/black/double
	icon_state = "double_sheetblack"
	worn_icon_state = "sheetblack"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/centcom/double
	icon_state = "double_sheetcentcom"
	worn_icon_state = "sheetcentcom"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/syndie/double
	icon_state = "double_sheetsyndie"
	worn_icon_state = "sheetsyndie"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/cult/double
	icon_state = "double_sheetcult"
	worn_icon_state = "sheetcult"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/wiz/double
	icon_state = "double_sheetwiz"
	worn_icon_state = "sheetwiz"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/rev/double
	icon_state = "double_sheetrev"
	worn_icon_state = "sheetrev"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/nanotrasen/double
	icon_state = "double_sheetNT"
	worn_icon_state = "sheetNT"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/ian/double
	icon_state = "double_sheetian"
	worn_icon_state = "sheetian"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/runtime/double
	icon_state = "double_sheetruntime"
	worn_icon_state = "sheetruntime"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/item/bedsheet/cosmos/double
	icon_state = "double_sheetcosmos"
	worn_icon_state = "sheetcosmos"
	bedsheet_type = BEDSHEET_DOUBLE

/obj/structure/bedsheetbin
	name = "亚麻品箱"
	desc = "它看起来相当舒适。"
	icon = 'icons/obj/structures.dmi'
	icon_state = "linenbin-full"
	base_icon_state = "linenbin"
	anchored = TRUE
	pass_flags = PASSTABLE
	resistance_flags = FLAMMABLE
	max_integrity = 70
	anchored_tabletop_offset = 6
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT)
	/// The number of bedsheets in the bin
	var/amount = 10
	/// A list of actual sheets within the bin
	var/list/sheets = list()
	/// The object hiddin within the bedsheet bin
	var/obj/item/hidden = null

/obj/structure/bedsheetbin/empty
	amount = 0
	icon_state = "linenbin-empty"
	anchored = FALSE


/obj/structure/bedsheetbin/Initialize(mapload)
	. = ..()
	register_context()

/obj/structure/bedsheetbin/examine(mob/user)
	. = ..()
	if(amount < 1)
		. += "There are no bed sheets in the bin."
	else if(amount == 1)
		. += "There is one bed sheet in the bin."
	else
		. += "There are [amount] bed sheets in the bin."

/obj/structure/bedsheetbin/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	if(isnull(held_item))
		if(amount)
			context[SCREENTIP_CONTEXT_LMB] = "Take bedsheet"
			return CONTEXTUAL_SCREENTIP_SET
		return

	if(istype(held_item, /obj/item/bedsheet))
		context[SCREENTIP_CONTEXT_LMB] = "Put in"
		return CONTEXTUAL_SCREENTIP_SET

	if(held_item.tool_behaviour == TOOL_SCREWDRIVER)
		context[SCREENTIP_CONTEXT_RMB] = "Disassemble"
		. = CONTEXTUAL_SCREENTIP_SET
	else if(held_item.tool_behaviour == TOOL_WRENCH)
		context[SCREENTIP_CONTEXT_RMB] = "[anchored ? "Una" : "A"]nchor"
		. = CONTEXTUAL_SCREENTIP_SET

	if(amount && held_item.w_class < WEIGHT_CLASS_BULKY)
		context[SCREENTIP_CONTEXT_LMB] = "Hide item in"
		. = CONTEXTUAL_SCREENTIP_SET
	return .

/obj/structure/bedsheetbin/update_icon_state()
	switch(amount)
		if(0)
			icon_state = "[base_icon_state]-empty"
		if(1 to 5)
			icon_state = "[base_icon_state]-half"
		else
			icon_state = "[base_icon_state]-full"
	return ..()

/obj/structure/bedsheetbin/fire_act(exposed_temperature, exposed_volume)
	if(amount)
		amount = 0
		update_appearance()
	..()

/obj/structure/bedsheetbin/screwdriver_act_secondary(mob/living/user, obj/item/tool)
	if(amount)
		to_chat(user, span_warning("必须先将[src]清空！"))
		return ITEM_INTERACT_SUCCESS
	if(tool.use_tool(src, user, 0.5 SECONDS, volume=50))
		to_chat(user, span_notice("你拆解了[src]."))
		new /obj/item/stack/rods(loc, 2)
		qdel(src)
		return ITEM_INTERACT_SUCCESS

/obj/structure/bedsheetbin/wrench_act_secondary(mob/living/user, obj/item/tool)
	. = ..()
	default_unfasten_wrench(user, tool, time = 0.5 SECONDS)
	return ITEM_INTERACT_SUCCESS

/obj/structure/bedsheetbin/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/bedsheet))
		return bedsheet_act(user, tool)

	// Everything else we try to hide
	return hide_item_act(user, tool)

/obj/structure/bedsheetbin/proc/bedsheet_act(mob/living/user, obj/item/tool)
	if(!user.transferItemToLoc(tool, src, silent = FALSE))
		return ITEM_INTERACT_BLOCKING
	sheets.Add(tool)
	amount++
	to_chat(user, span_notice("你将[tool]放入了[src]。"))
	update_appearance()
	return ITEM_INTERACT_SUCCESS

/obj/structure/bedsheetbin/proc/hide_item_act(mob/living/user, obj/item/tool)
	if(user.combat_mode)
		return NONE
	if(tool.w_class >= WEIGHT_CLASS_BULKY)
		balloon_alert(user, "太大了！")
		return ITEM_INTERACT_BLOCKING
	if(!amount)
		balloon_alert(user, "没有东西可以藏在下面！")
		return ITEM_INTERACT_BLOCKING
	if(hidden)
		balloon_alert(user, "已经有东西了！")
		return ITEM_INTERACT_BLOCKING
	if(!user.transferItemToLoc(tool, src, silent = FALSE))
		to_chat(user, span_warning("\The [tool]粘在你手上，你无法把它藏在床单里！"))
		return ITEM_INTERACT_BLOCKING
	hidden = tool
	to_chat(user, span_notice("你将[tool]藏在了床单中。"))
	return ITEM_INTERACT_SUCCESS

/obj/structure/bedsheetbin/attack_paw(mob/user, list/modifiers)
	return attack_hand(user, modifiers)

/obj/structure/bedsheetbin/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(isliving(user))
		var/mob/living/L = user
		if(!(L.mobility_flags & MOBILITY_PICKUP))
			return
	if(amount >= 1)
		amount--

		var/obj/item/bedsheet/B
		if(sheets.len > 0)
			B = sheets[sheets.len]
			sheets.Remove(B)

		else
			B = new /obj/item/bedsheet(loc)

		B.forceMove(drop_location())
		user.put_in_hands(B)
		to_chat(user, span_notice("你将 [B] 从 [src] 中拿出."))
		update_appearance()

		if(hidden)
			hidden.forceMove(drop_location())
			to_chat(user, span_notice("[hidden]从[B]里掉了出来！"))
			hidden = null

	add_fingerprint(user)


/obj/structure/bedsheetbin/attack_tk(mob/user)
	if(amount >= 1)
		amount--

		var/obj/item/bedsheet/B
		if(sheets.len > 0)
			B = sheets[sheets.len]
			sheets.Remove(B)

		else
			B = new /obj/item/bedsheet(loc)

		B.forceMove(drop_location())
		to_chat(user, span_notice("你用心灵遥感从[src]中移除了[B]."))
		update_appearance()

		if(hidden)
			hidden.forceMove(drop_location())
			hidden = null

	add_fingerprint(user)
	return COMPONENT_CANCEL_ATTACK_CHAIN

/obj/structure/bedsheetbin/basket
	name = "亚麻布篮"
	icon_state = "linenbasket-full"
	base_icon_state = "linenbasket"

/obj/structure/bedsheetbin/empty/basket
	name = "亚麻篮"
	icon_state = "linenbasket-empty"
	base_icon_state = "linenbasket"
