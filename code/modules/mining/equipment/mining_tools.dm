/*****************Pickaxes & Drills & Shovels****************/
/obj/item/pickaxe
	name = "镐子"
	icon = 'icons/obj/mining.dmi'
	icon_state = "pickaxe"
	inhand_icon_state = "pickaxe"
	icon_angle = -45
	obj_flags = CONDUCTS_ELECTRICITY
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_BACK
	force = 15
	throwforce = 10
	demolition_mod = 1.15
	lefthand_file = 'icons/mob/inhands/equipment/mining_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/mining_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	custom_materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT)
	tool_behaviour = TOOL_MINING
	toolspeed = 1
	usesound = list('sound/effects/pickaxe/picaxe1.ogg', 'sound/effects/pickaxe/picaxe2.ogg', 'sound/effects/pickaxe/picaxe3.ogg')
	attack_verb_continuous = list("hits", "pierces", "slices", "attacks")
	attack_verb_simple = list("hit", "pierce", "slice", "attack")

/obj/item/pickaxe/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] begins digging into [user.p_their()] chest! It looks like [user.p_theyre()] trying to commit suicide!"))
	if(use_tool(user, user, 30, volume=50))
		return BRUTELOSS
	user.visible_message(span_suicide("[user] couldn't do it!"))
	return SHAME

/obj/item/pickaxe/rusted
	name = "生锈的镐"
	desc = "一把已经锈迹斑斑的镐子."
	attack_verb_continuous = list("ineffectively hits")
	attack_verb_simple = list("ineffectively hit")
	force = 1
	throwforce = 1

/obj/item/pickaxe/mini
	name = "紧凑稿"
	desc = "标准鹤嘴锄的小而紧凑的版本。"
	icon_state = "minipick"
	worn_icon_state = "pickaxe"
	force = 10
	throwforce = 7
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_NORMAL
	custom_materials = list(/datum/material/iron=HALF_SHEET_MATERIAL_AMOUNT)

/obj/item/pickaxe/silver
	name = "镀银镐"
	icon_state = "spickaxe"
	inhand_icon_state = "spickaxe"
	toolspeed = 0.5 //mines faster than a normal pickaxe, bought from mining vendor
	desc = "一种镀银的鹤嘴锄，挖矿速度比标准型号稍快。"
	force = 17

/obj/item/pickaxe/diamond
	name = "钻石尖嘴镐"
	icon_state = "dpickaxe"
	inhand_icon_state = "dpickaxe"
	toolspeed = 0.3
	desc = "有钻石头的鹤嘴锄。在开裂岩壁和挖土方面非常强健。"
	force = 19

/obj/item/pickaxe/drill
	name = "采矿钻"
	icon_state = "handdrill"
	inhand_icon_state = "handdrill"
	icon_angle = 0
	slot_flags = ITEM_SLOT_BELT
	toolspeed = 0.6 //available from roundstart, faster than a pickaxe.
	usesound = 'sound/items/weapons/drill.ogg'
	hitsound = 'sound/items/weapons/drill.ogg'
	desc = "为细狗的人准备的电钻。"

/obj/item/pickaxe/drill/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/cuffable_item) //closed handle

/obj/item/pickaxe/drill/diamonddrill
	name = "钻石尖采矿钻"
	icon_state = "diamonddrill"
	inhand_icon_state = "diamonddrill"
	toolspeed = 0.2
	desc = "你的钻头将突破天际！"

/obj/item/pickaxe/drill/jackhammer
	name = "声波手提钻"
	icon_state = "jackhammer"
	inhand_icon_state = "jackhammer"
	toolspeed = 0.1 //the epitome of powertools. extremely fast mining
	usesound = 'sound/items/weapons/sonic_jackhammer.ogg'
	hitsound = 'sound/items/weapons/sonic_jackhammer.ogg'
	desc = "用声波震碎岩石。"

/obj/item/pickaxe/improvised
	name = "临时镐"
	desc = "一把由刀和撬棍拼接而成的铁锹，会不会断裂呢？"
	icon_state = "ipickaxe"
	inhand_icon_state = "ipickaxe"
	worn_icon_state = "pickaxe"
	force = 10
	throwforce = 7
	toolspeed = 3 //3 times slower than a normal pickaxe
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_NORMAL
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*6) //This number used to be insane and I'm just going to save your sanity and not tell you what it was.

/obj/item/shovel
	name = "铲子"
	desc = "用来挖土和铲土的大型工具。"
	icon = 'icons/obj/mining.dmi'
	icon_state = "shovel"
	inhand_icon_state = "shovel"
	icon_angle = 135
	lefthand_file = 'icons/mob/inhands/equipment/mining_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/mining_righthand.dmi'
	obj_flags = CONDUCTS_ELECTRICITY
	slot_flags = ITEM_SLOT_BELT
	force = 8
	throwforce = 4
	tool_behaviour = TOOL_SHOVEL
	toolspeed = 1
	usesound = 'sound/effects/shovel_dig.ogg'
	w_class = WEIGHT_CLASS_NORMAL
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*0.5)
	attack_verb_continuous = list("bashes", "bludgeons", "thrashes", "whacks")
	attack_verb_simple = list("bash", "bludgeon", "thrash", "whack")
	sharpness = SHARP_EDGED

/obj/item/shovel/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/butchering, \
	speed = 15 SECONDS, \
	effectiveness = 40, \
	)
	//it's sharp, so it works, but barely.
	AddElement(/datum/element/gravedigger)

/obj/item/shovel/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] begins digging their own grave! It looks like [user.p_theyre()] trying to commit suicide!"))
	if(use_tool(user, user, 30, volume=50))
		return BRUTELOSS
	user.visible_message(span_suicide("[user] couldn't do it!"))
	return SHAME

/obj/item/shovel/spade
	name = "铲子"
	desc = "用来挖土和铲土的小型工具。"
	icon_state = "spade"
	inhand_icon_state = "spade"
	icon_angle = -135
	lefthand_file = 'icons/mob/inhands/equipment/hydroponics_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/hydroponics_righthand.dmi'
	force = 5
	throwforce = 7
	w_class = WEIGHT_CLASS_SMALL

/obj/item/shovel/spade/cyborg
	name = "cyborg spade"
	icon = 'icons/obj/items_cyborg.dmi'
	icon_state = "sili_shovel"
	icon_angle = 0
	toolspeed = 0.6
	worn_icon_state = null

/obj/item/shovel/serrated
	name = "锯齿骨铲"
	desc = "A wicked tool that cleaves through dirt just as easily as it does flesh. The design was styled after ancient lavaland tribal designs. \
		It seems less capable of harming inorganic creatures. Who knows why."
	icon_state = "shovel_bone"
	worn_icon_state = "shovel_serr"
	lefthand_file = 'icons/mob/inhands/equipment/mining_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/mining_righthand.dmi'
	force = 10
	throwforce = 12
	w_class = WEIGHT_CLASS_NORMAL
	tool_behaviour = TOOL_SHOVEL // hey, it's serrated.
	toolspeed = 0.3
	attack_verb_continuous = list("slashes", "impales", "stabs", "slices")
	attack_verb_simple = list("slash", "impale", "stab", "slice")
	sharpness = SHARP_EDGED
	item_flags = CRUEL_IMPLEMENT
	custom_materials = list(/datum/material/bone = SHEET_MATERIAL_AMOUNT * 4, /datum/material/iron = SMALL_MATERIAL_AMOUNT * 0.5)

/obj/item/shovel/serrated/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/bane, affected_biotypes = MOB_ORGANIC, damage_multiplier = 2) //You may be horridly cursed now, but at least you kill the living a whole lot more easily!

/obj/item/shovel/serrated/examine(mob/user)
	. = ..()
	if( !(user.mind && HAS_TRAIT(user.mind, TRAIT_MORBID)) )
		return
	. += span_deadsay("You feel an intense, strange craving to 'dig' straight through living flesh with this shovel. Why else would it be serrated? The thought is mesmerizing...")

// Coroner mail version
/obj/item/shovel/serrated/dull
	name = "dull bone shovel"
	desc = "An ancient, dull bone shovel with a strange design and markings. Visually, it seems pretty weak, but you get the feeling there's more to it than meets the eye..."
	force = 8
	throwforce = 10
	toolspeed = 0.8

/obj/item/trench_tool
	name = "挖壕工具"
	desc = "你一直所需的多功能工具。"
	icon = 'icons/obj/mining.dmi'
	icon_state = "trench_tool"
	inhand_icon_state = "trench_tool"
	icon_angle = -45
	lefthand_file = 'icons/mob/inhands/equipment/mining_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/mining_righthand.dmi'
	obj_flags = CONDUCTS_ELECTRICITY
	force = 15
	throwforce = 6
	w_class = WEIGHT_CLASS_SMALL
	tool_behaviour = TOOL_WRENCH
	toolspeed = 0.75
	usesound = 'sound/items/tools/ratchet.ogg'
	attack_verb_continuous = list("bashes", "bludgeons", "thrashes", "whacks")
	attack_verb_simple = list("bash", "bludgeon", "thrash", "whack")
	wound_bonus = 10

/obj/item/trench_tool/get_all_tool_behaviours()
	return list(TOOL_MINING, TOOL_SHOVEL, TOOL_WRENCH)

/obj/item/trench_tool/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)
	AddElement(/datum/element/gravedigger)

/obj/item/trench_tool/examine(mob/user)
	. = ..()
	. += span_notice("Use in hand to switch configuration.")
	. += span_notice("It functions as a [tool_behaviour] tool.")
	. += span_danger("<i>This weapon has no random critical hits.</i>")

/obj/item/trench_tool/update_icon_state()
	. = ..()
	switch(tool_behaviour)
		if(TOOL_WRENCH)
			icon_state = inhand_icon_state = initial(icon_state)
		if(TOOL_SHOVEL)
			icon_state = inhand_icon_state = "[initial(icon_state)]_shovel"
		if(TOOL_MINING)
			icon_state = inhand_icon_state = "[initial(icon_state)]_pick"

/obj/item/trench_tool/attack_self(mob/user, modifiers)
	. = ..()
	if(!user)
		return
	var/list/tool_list = list(
		"Wrench" = image(icon = icon, icon_state = "trench_tool"),
		"Shovel" = image(icon = icon, icon_state = "trench_tool_shovel"),
		"Pick" = image(icon = icon, icon_state = "trench_tool_pick"),
		)
	var/tool_result = show_radial_menu(user, src, tool_list, custom_check = CALLBACK(src, PROC_REF(check_menu), user), require_near = TRUE, tooltips = TRUE)
	if(!check_menu(user) || !tool_result)
		return
	switch(tool_result)
		if("Wrench")
			tool_behaviour = TOOL_WRENCH
			sharpness = NONE
			toolspeed = 0.75
			update_weight_class(WEIGHT_CLASS_SMALL)
			usesound = 'sound/items/tools/ratchet.ogg'
			attack_verb_continuous = list("bashes", "bludgeons", "thrashes", "whacks")
			attack_verb_simple = list("bash", "bludgeon", "thrash", "whack")
		if("Shovel")
			tool_behaviour = TOOL_SHOVEL
			sharpness = SHARP_EDGED
			toolspeed = 0.25
			update_weight_class(WEIGHT_CLASS_NORMAL)
			usesound = 'sound/effects/shovel_dig.ogg'
			attack_verb_continuous = list("slashes", "impales", "stabs", "slices")
			attack_verb_simple = list("slash", "impale", "stab", "slice")
		if("Pick")
			tool_behaviour = TOOL_MINING
			sharpness = SHARP_POINTY
			toolspeed = 0.5
			update_weight_class(WEIGHT_CLASS_NORMAL)
			usesound = 'sound/effects/pickaxe/picaxe1.ogg'
			attack_verb_continuous = list("hits", "pierces", "slices", "attacks")
			attack_verb_simple = list("hit", "pierce", "slice", "attack")
	playsound(src, 'sound/items/tools/ratchet.ogg', 50, vary = TRUE)
	update_appearance(UPDATE_ICON)

/obj/item/trench_tool/proc/check_menu(mob/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated || !user.Adjacent(src))
		return FALSE
	return TRUE

/obj/item/shovel/giant_wrench
	name = "Big Slappy"
	desc = "A gigantic wrench made illegal because of its many incidents involving this tool."
	icon_state = "giant_wrench"
	icon = 'icons/obj/weapons/giant_wrench.dmi'
	icon_angle = 0
	inhand_icon_state = null
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	w_class = WEIGHT_CLASS_HUGE
	slot_flags = NONE
	toolspeed = 0.1
	force = 30
	throwforce = 20
	block_chance = 30
	throw_range = 2
	demolition_mod = 2
	armor_type = /datum/armor/giant_wrench
	resistance_flags = FIRE_PROOF
	wound_bonus = -10
	attack_verb_continuous = list("bonks", "bludgeons", "pounds")
	attack_verb_simple = list("bonk", "bludgeon", "pound")
	drop_sound = 'sound/items/weapons/sonic_jackhammer.ogg'
	pickup_sound = 'sound/items/handling/tools/crowbar_pickup.ogg'
	hitsound = 'sound/items/weapons/sonic_jackhammer.ogg'
	block_sound = 'sound/items/weapons/sonic_jackhammer.ogg'
	item_flags = SLOWS_WHILE_IN_HAND | IMMUTABLE_SLOW
	slowdown = 3
	attack_speed = 1.2 SECONDS
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 6.6, /datum/material/alloy/plasteel = SHEET_MATERIAL_AMOUNT * 5)
	/// The factor at which the recoil becomes less.
	var/recoil_factor = 3
	/// Wether we knock down and launch away out enemies when we attack.
	var/do_launch = TRUE

/obj/item/shovel/giant_wrench/get_all_tool_behaviours()
	return list(TOOL_SHOVEL, TOOL_WRENCH)

/datum/armor/giant_wrench
	acid = 30
	bomb = 100
	bullet = 30
	fire = 100
	laser = 30
	melee = 30

/obj/item/shovel/giant_wrench/Initialize(mapload)
	. = ..()
	transform = transform.Translate(-16, -16)
	AddComponent(/datum/component/two_handed, require_twohands=TRUE)
	AddComponent( \
		/datum/component/transforming, \
		force_on = 40, \
		throwforce_on = throwforce, \
		hitsound_on = hitsound, \
		w_class_on = w_class, \
		sharpness_on = SHARP_POINTY, \
		clumsy_check = TRUE, \
		inhand_icon_change = TRUE, \
	)
	RegisterSignal(src, COMSIG_TRANSFORMING_ON_TRANSFORM, PROC_REF(on_transform))

/// Used when the tool is transformed through the transforming component.
/obj/item/shovel/giant_wrench/proc/on_transform(obj/item/source, mob/user, active)
	SIGNAL_HANDLER

	usesound = (active ? 'sound/items/tools/ratchet.ogg' : initial(usesound))
	block_chance = (active ? 0 : initial(block_chance))
	recoil_factor = (active ? 2 : initial(recoil_factor))
	do_launch = (active ? FALSE : initial(do_launch))
	tool_behaviour = (active ? TOOL_WRENCH : initial(tool_behaviour))
	armour_penetration = (active ? 30 : initial(armour_penetration))
	if(user)
		balloon_alert(user, "折叠了巨力拍子 [active ? "open" : "closed"]")
	playsound(src, 'sound/items/tools/ratchet.ogg', 50, TRUE)
	return COMPONENT_NO_DEFAULT_MESSAGE

/obj/item/shovel/giant_wrench/attack(mob/living/target_mob, mob/living/user)
	..()
	if(QDELETED(target_mob))
		return
	if(do_launch)
		var/atom/throw_target = get_edge_target_turf(target_mob, get_dir(user, get_step_away(target_mob, user)))
		target_mob.throw_at(throw_target, 2, 2, user, gentle = TRUE)
		target_mob.Knockdown(2 SECONDS)
	var/body_zone = pick(user.get_all_limbs())
	user.apply_damage(force / recoil_factor, BRUTE, body_zone, user.run_armor_check(body_zone, MELEE))
	to_chat(user, span_danger("The weight of the Big Slappy recoils!"))
	log_combat(user, user, "recoiled Big Slappy into")
