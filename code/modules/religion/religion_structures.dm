/obj/structure/altar
	name = "\improper 祭坛"
	desc = "一个宗教建筑。如果你想的话，可以躺在上面。"
	icon = 'icons/obj/service/hand_of_god_structures.dmi'
	icon_state = "convertaltar"
	density = TRUE
	anchored = TRUE
	layer = TABLE_LAYER
	pass_flags_self = PASSSTRUCTURE | PASSTABLE | LETPASSTHROW
	can_buckle = TRUE
	buckle_lying = 90 //we turn to you!
	/// Do we have lit candles?
	var/lit_candles = TRUE
	/// Optional emissive overlay
	var/emissive_icon_state

/obj/structure/altar/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/climbable)
	AddElement(/datum/element/elevation, pixel_shift = 12)
	update_appearance(UPDATE_OVERLAYS)

/obj/structure/altar/update_overlays()
	. = ..()
	if (lit_candles)
		. += mutable_appearance(icon, "convertaltarcandle", alpha = src.alpha)
		. += emissive_appearance(icon, "convertaltarcandle", src, alpha = src.alpha)
	if(emissive_icon_state)
		. += emissive_appearance(icon, emissive_icon_state, src, alpha = src.alpha)

/obj/structure/altar/attack_hand(mob/living/user, list/modifiers)
	if(!Adjacent(user) || !user.pulling)
		return ..()
	if(!isliving(user.pulling))
		return ..()
	var/mob/living/pushed_mob = user.pulling
	if(pushed_mob.buckled)
		to_chat(user, span_warning("[pushed_mob]被绑在[pushed_mob.buckled]上了！"))
		return ..()
	to_chat(user, span_notice("你试图将[pushed_mob]哄到[src]上..."))
	if(!do_after(user,(5 SECONDS),target = pushed_mob))
		return ..()
	pushed_mob.forceMove(loc)
	return ..()

/// This one actually has relevance to chaplains
/obj/structure/altar/of_gods
	name = "\improper 众神祭坛"
	desc = "一个祭坛，它能让教会的领袖选择某种宗教教义派别，并通过进行祭祀来祈求神灵的庇佑。"
	///Avoids having to check global everytime by referencing it locally.
	var/datum/religion_sect/sect_to_altar

/obj/structure/altar/of_gods/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/religious_tool, ALL, FALSE, CALLBACK(src, PROC_REF(reflect_sect_in_icons)))
	reflect_sect_in_icons()
	GLOB.chaplain_altars += src

/obj/structure/altar/of_gods/Destroy()
	GLOB.chaplain_altars -= src
	return ..()

/obj/structure/altar/of_gods/examine_more(mob/user)
	if(!isobserver(user))
		return ..()
	. = list(span_notice("<i>你更仔细地检查了[src]，并注意到以下内容...</i>"))
	if(GLOB.religion)
		. += list(span_notice("神祇：[GLOB.deity]。"))
		. += list(span_notice("宗教：[GLOB.religion]。"))
		. += list(span_notice("圣经：[GLOB.bible_name]。"))
	if(GLOB.religious_sect)
		. += list(span_notice("教派：[GLOB.religious_sect]。"))
		. += list(span_notice("恩惠：[GLOB.religious_sect.favor]。"))
	var/chaplains = get_chaplains()
	if(isAdminObserver(user) && chaplains)
		. += list(span_notice("牧师：[chaplains]。"))

/obj/structure/altar/of_gods/proc/reflect_sect_in_icons()
	if(isnull(GLOB.religious_sect))
		lit_candles = FALSE
		icon = initial(icon)
		icon_state = initial(icon_state)
		emissive_icon_state = initial(emissive_icon_state)
	else
		sect_to_altar = GLOB.religious_sect
		lit_candles = GLOB.religious_sect.candle_overlay
		if(sect_to_altar.altar_icon)
			icon = sect_to_altar.altar_icon
		if(sect_to_altar.altar_icon_state)
			icon_state = sect_to_altar.altar_icon_state
		if(sect_to_altar.altar_emissive_icon_state)
			emissive_icon_state = sect_to_altar.altar_emissive_icon_state
	update_appearance(UPDATE_OVERLAYS) //Light the candles!

/obj/structure/altar/of_gods/proc/get_chaplains()
	var/chaplain_string = ""
	for(var/mob/living/carbon/human/potential_chap in GLOB.player_list)
		if(potential_chap.key && is_chaplain_job(potential_chap.mind?.assigned_role))
			if(chaplain_string)
				chaplain_string += ", "
			chaplain_string += "[potential_chap] ([potential_chap.key])"
	return chaplain_string

/obj/item/ritual_totem
	name = "仪式图腾"
	desc = "带有怪异刻痕的木制图腾。"
	icon = 'icons/obj/service/hand_of_god_structures.dmi'
	icon_state = "ritual_totem"
	inhand_icon_state = "sheet-wood"
	lefthand_file = 'icons/mob/inhands/items/sheets_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/sheets_righthand.dmi'
	//made out of a single sheet of wood
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT)
	item_flags = NO_PIXEL_RANDOM_DROP

/obj/item/ritual_totem/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/anti_magic, \
		antimagic_flags = MAGIC_RESISTANCE|MAGIC_RESISTANCE_HOLY, \
		charges = 1, \
		expiration = CALLBACK(src, PROC_REF(expire)), \
	)
	AddComponent(/datum/component/religious_tool, RELIGION_TOOL_INVOKE, FALSE)

/// When the ritual totem is depleted of antimagic
/obj/item/ritual_totem/proc/expire(mob/user)
	to_chat(user, span_warning("[src]吞噬了其内部的魔力，并迅速腐烂！"))
	new /obj/effect/decal/cleanable/ash(drop_location())
	qdel(src)

/obj/item/ritual_totem/can_be_pulled(user, force)
	. = ..()
	return FALSE //no

/obj/item/ritual_totem/examine(mob/user)
	. = ..()
	var/is_holy = user.mind?.holy_role
	if(is_holy)
		. += span_notice("[src]只能由[GLOB.deity]的重要信徒移动。")

/obj/item/ritual_totem/pickup(mob/taker)
	var/initial_loc = loc
	var/holiness = taker.mind?.holy_role
	var/no_take = FALSE
	if(holiness == NONE)
		to_chat(taker, span_warning("无论你怎么尝试，似乎都无法捡起[src]！"))
		no_take = TRUE
	else if(holiness == HOLY_ROLE_DEACON) //deacons cannot pick them up either
		no_take = TRUE
		to_chat(taker, span_warning("你无法捡起[src]。看来你对[GLOB.deity]来说还不够重要。"))
	..()
	if(no_take)
		taker.dropItemToGround(src)
		forceMove(initial_loc)
