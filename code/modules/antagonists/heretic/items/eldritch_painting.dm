// The basic eldritch painting
/obj/item/wallframe/painting/eldritch
	name = "空白画布：默认子类型研究"
	desc = "一幅由不可能存在的颜料绘制的、不可能存在的画作。它本不应存在于这个现实中。"
	icon = 'icons/obj/signs.dmi'
	resistance_flags = FLAMMABLE
	flags_1 = NONE
	icon_state = "eldritch_painting_debug"
	result_path = /obj/structure/sign/painting/eldritch
	pixel_shift = 30

/obj/structure/sign/painting/eldritch
	name = "空白画布：默认子类型研究"
	desc = "一幅由不可能存在的颜料绘制的、不可能存在的画作。它本不应存在于这个现实中。"
	icon = 'icons/obj/signs.dmi'
	icon_state = "eldritch_painting_debug"
	custom_materials = list(/datum/material/wood =SHEET_MATERIAL_AMOUNT)
	resistance_flags = FLAMMABLE
	buildable_sign = FALSE
	// The list of canvas types accepted by this frame, set to zero here
	accepted_canvas_types = list()
	// Set to false since we don't want this to persist
	persistence_id = FALSE
	/// The trauma the painting applies
	var/applied_status_effect = /datum/status_effect/eldritch_painting
	/// The text that shows up when you cross the paintings path
	var/text_to_display = "Some things should not be seen by mortal eyes..."
	/// The range of the paintings effect
	var/range = 7

/obj/structure/sign/painting/eldritch/Initialize(mapload)
	. = ..()
	if(ispath(applied_status_effect))
		var/static/list/connections = list(COMSIG_ATOM_ENTERED = PROC_REF(apply_status_effect))
		AddComponent(/datum/component/connect_range, tracked = src, connections = connections, range = range, works_in_containers = FALSE)

/obj/structure/sign/painting/eldritch/proc/apply_status_effect(datum/source, mob/living/carbon/viewer)
	SIGNAL_HANDLER
	if(!isliving(viewer) || !can_see(viewer, src, range))
		return
	if(isnull(viewer.mind) || isnull(viewer.mob_mood) || viewer.stat != CONSCIOUS || viewer.is_blind())
		return
	if(viewer.has_status_effect(applied_status_effect))
		return
	if(IS_HERETIC(viewer))
		return
	if(viewer.can_block_magic(MAGIC_RESISTANCE_MOON))
		return
	if(viewer.reagents.has_reagent(/datum/reagent/water/holywater))
		return
	to_chat(viewer, span_notice(text_to_display))
	viewer.apply_status_effect(applied_status_effect)
	INVOKE_ASYNC(viewer, TYPE_PROC_REF(/mob, emote), "scream")
	to_chat(viewer, span_hypnophrase("你的心智被征服了！这幅画在你的心灵上留下了印记。"))

/obj/structure/sign/painting/eldritch/wirecutter_act(mob/living/user, obj/item/I)
	if(!user.can_block_magic(MAGIC_RESISTANCE_MOON))
		user.add_mood_event("ripped_eldritch_painting", /datum/mood_event/eldritch_painting)
		to_chat(user, span_hypnophrase("There's an itch in your brain. It's laughing at you..."))
	qdel(src)
	return ITEM_INTERACT_SUCCESS

// On examine eldritch paintings give a trait so their effects can not be spammed
/obj/structure/sign/painting/eldritch/examine(mob/user)
	. = ..()
	if(!iscarbon(user))
		return
	if(HAS_TRAIT(user, TRAIT_ELDRITCH_PAINTING_EXAMINE))
		return

	ADD_TRAIT(user, TRAIT_ELDRITCH_PAINTING_EXAMINE, REF(src))
	addtimer(TRAIT_CALLBACK_REMOVE(user, TRAIT_ELDRITCH_PAINTING_EXAMINE, REF(src)), 3 MINUTES)
	addtimer(CALLBACK(src, PROC_REF(examine_effects), user), 0.2 SECONDS)

/obj/structure/sign/painting/eldritch/proc/examine_effects(mob/living/carbon/examiner)
	if(IS_HERETIC(examiner))
		to_chat(examiner, span_notice("多么引人入胜的画作！"))
	else
		to_chat(examiner, span_notice("多么奇怪的画作……"))

// The Sister and He Who Wept eldritch painting
/obj/item/wallframe/painting/eldritch/weeping
	name = "\improper 姐妹与垂泪者"
	desc = "一幅美丽的画作，描绘了一位优雅的女士坐在祂身旁。祂在哭泣。你会再次见到祂。"
	icon_state = "eldritch_painting_weeping"
	result_path = /obj/structure/sign/painting/eldritch/weeping

/obj/structure/sign/painting/eldritch/weeping
	name = "\improper 姐妹与垂泪者"
	desc = "一幅美丽的画作，描绘了一位优雅的女士坐在祂身旁。祂在哭泣。你会再次见到祂。可用钢丝钳移除。"
	icon_state = "eldritch_painting_weeping"
	applied_status_effect = /datum/status_effect/eldritch_painting/weeping
	text_to_display = "Such beauty! Such sorrow!"

/obj/structure/sign/painting/eldritch/weeping/examine_effects(mob/living/carbon/examiner)
	if(!IS_HERETIC(examiner))
		to_chat(examiner, span_hypnophrase("喘息，暂时如此...."))
		examiner.mob_mood.mood_events.Remove("eldritch_weeping")
		examiner.add_mood_event("weeping_withdrawal", /datum/mood_event/eldritch_painting/weeping_withdrawal)
		return

	to_chat(examiner, span_notice("仅仅是凝视它，你的思绪便清晰起来。"))
	examiner.remove_status_effect(/datum/status_effect/hallucination)
	examiner.add_mood_event("heretic_eldritch_painting", /datum/mood_event/eldritch_painting/weeping_heretic)

// The First Desire painting, using a lot of the painting/eldritch framework
/obj/item/wallframe/painting/eldritch/desire
	name = "\improper 欲望盛宴"
	desc = "一幅描绘一场精致盛宴的画作。尽管食物完全由腐烂的肉块和衰败的器官构成，看起来却非常诱人。"
	icon_state = "eldritch_painting_desire"
	result_path = /obj/structure/sign/painting/eldritch/desire

/obj/structure/sign/painting/eldritch/desire
	name = "\improper 欲望盛宴"
	desc = "一幅描绘一场精致盛宴的画作。尽管食物完全由腐烂的肉块和衰败的器官构成，看起来却非常诱人。可用钢丝钳移除。"
	icon_state = "eldritch_painting_desire"
	applied_status_effect = /datum/status_effect/eldritch_painting/desire
	text_to_display = "Just looking at this painting makes me hungry..."

// The special examine interaction for this painting
/obj/structure/sign/painting/eldritch/desire/examine_effects(mob/living/carbon/examiner)
	if(!IS_HERETIC(examiner))
		// Gives them some nutrition
		examiner.adjust_nutrition(50)
		to_chat(examiner, span_warning("你感到胃部一阵灼痛！"))
		examiner.adjust_organ_loss(ORGAN_SLOT_STOMACH, 5)
		to_chat(examiner, span_notice("你感觉不那么饿了。"))
		to_chat(examiner, span_warning("你应该囤积生肉和器官，以免再次感到饥饿。"))
		examiner.add_mood_event("respite_eldritch_hunger", /datum/mood_event/eldritch_painting/desire_examine)
		return

	// A list made of the organs and bodyparts the heretic can get
	var/static/list/random_bodypart_or_organ = list(
		/obj/item/organ/brain,
		/obj/item/organ/lungs,
		/obj/item/organ/eyes,
		/obj/item/organ/ears,
		/obj/item/organ/heart,
		/obj/item/organ/liver,
		/obj/item/organ/stomach,
		/obj/item/organ/appendix,
		/obj/item/bodypart/arm/left,
		/obj/item/bodypart/arm/right,
		/obj/item/bodypart/leg/left,
		/obj/item/bodypart/leg/right
	)
	var/organ_or_bodypart_to_spawn = pick(random_bodypart_or_organ)
	new organ_or_bodypart_to_spawn(drop_location())
	to_chat(examiner, span_notice("一块血肉从画中爬出，扑通一声掉在地板上。"))
	to_chat(examiner, span_warning("虚空在尖叫！"))
	// Adds a negative mood event to our heretic
	examiner.add_mood_event("heretic_eldritch_hunger", /datum/mood_event/eldritch_painting/desire_heretic)

// Great chaparral over rolling hills, this one doesn't have the sensor type
/obj/item/wallframe/painting/eldritch/vines
	name = "\improper 起伏丘陵上的伟大查帕拉尔"
	desc = "一幅描绘巨大灌木丛的画作。这幅画生机勃勃，仿佛要挣脱画框的束缚。"
	icon_state = "eldritch_painting_vines"
	result_path = /obj/structure/sign/painting/eldritch/vines

/obj/structure/sign/painting/eldritch/vines
	name = "\improper 起伏丘陵上的伟大查帕拉尔"
	desc = "一幅描绘巨大灌木丛的画作。这幅画生机勃勃，仿佛要挣脱画框的束缚。可用钢丝钳移除。"
	icon_state = "eldritch_painting_vines"
	applied_status_effect = null
	// A static list of 5 pretty strong mutations, simple to expand for any admins
	var/list/mutations = list(
		/datum/spacevine_mutation/aggressive_spread,
		/datum/spacevine_mutation/fire_proof,
		/datum/spacevine_mutation/hardened,
		/datum/spacevine_mutation/thorns,
		/datum/spacevine_mutation/toxicity,
	)
	// Poppy and harebell are used in heretic rituals
	var/list/items_to_spawn = list(
		/obj/item/food/grown/poppy,
		/obj/item/food/grown/harebell,
	)

/obj/structure/sign/painting/eldritch/vines/Initialize(mapload)
	. = ..()
	new /datum/spacevine_controller(get_turf(src), mutations, 0, 10)

/obj/structure/sign/painting/eldritch/vines/examine_effects(mob/living/carbon/examiner)
	. = ..()
	if(!IS_HERETIC(examiner))
		new /datum/spacevine_controller(get_turf(examiner), mutations, 0, 10)
		to_chat(examiner, span_hypnophrase("你被画上的藤蔓吸引，一时失神。"))
		to_chat(examiner, span_notice("你感到有什么东西在你周围蠕动。"))
		return

	var/item_to_spawn = pick(items_to_spawn)
	to_chat(examiner, span_notice("你被藤蔓构成的混乱图案吸引，一时失神。"))
	to_chat(examiner, span_notice("你感到生命在你脚下凝聚并绽放。"))
	new item_to_spawn(examiner.drop_location())
	examiner.add_mood_event("heretic_vines", /datum/mood_event/eldritch_painting/heretic_vines)


// Lady out of gates, gives a brain trauma causing the person to scratch themselves
/obj/item/wallframe/painting/eldritch/beauty
	name = "\improper 门扉之女"
	desc = "一幅描绘异界存在的画作。它那薄如瓷器的皮肤紧绷在奇异的骨骼结构上，有种怪诞的美感。"
	icon_state = "eldritch_painting_beauty"
	result_path = /obj/structure/sign/painting/eldritch/beauty

/obj/structure/sign/painting/eldritch/beauty
	name = "\improper 门扉之女"
	desc = "一幅描绘异界存在的画作。它那薄如瓷器的皮肤紧绷在奇异的骨骼结构上，有种怪诞的美感。可用钢丝钳移除。"
	icon_state = "eldritch_painting_beauty"
	applied_status_effect = /datum/status_effect/eldritch_painting/beauty
	text_to_display = "A beacon of purity, the real world seems so mundane and imperfect in comparison..."
	/// List of reagents to add to heretics on examine, set to mutadone by default to remove mutations
	var/list/reagents_to_add = list(/datum/reagent/medicine/mutadone = 5)

// The special examine interaction for this painting
/obj/structure/sign/painting/eldritch/beauty/examine_effects(mob/living/carbon/examiner)
	. = ..()
	if(!examiner.has_dna())
		return

	if(!IS_HERETIC(examiner))
		to_chat(examiner, span_hypnophrase("你尚未纯净。"))
		examiner.easy_random_mutate(NEGATIVE + MINOR_NEGATIVE)
		return

	to_chat(examiner, span_notice("你的瑕疵被剥落了。"))
	examiner.reagents.add_reagent_list(reagents_to_add)

// Climb over the rusted mountain, gives a brain trauma causing the person to randomly rust tiles beneath them
/obj/item/wallframe/painting/eldritch/rust
	name = "\improper 锈蚀山之主"
	desc = "一幅描绘一个奇异生物攀爬锈色山脉的画作。笔触非自然且令人不安。"
	icon_state = "eldritch_painting_rust"
	result_path = /obj/structure/sign/painting/eldritch/rust

/obj/structure/sign/painting/eldritch/rust
	name = "\improper 锈蚀山之主"
	desc = "一幅描绘一个奇异生物攀爬锈色山脉的画作。笔触非自然且令人不安。可用钢丝钳移除。"
	icon_state = "eldritch_painting_rust"
	applied_status_effect = /datum/status_effect/eldritch_painting/rusting
	text_to_display = "The rust decays. The master climbs. It calls. You answer..."

// The special examine interaction for this painting
/obj/structure/sign/painting/eldritch/rust/examine_effects(mob/living/carbon/examiner)
	. = ..()

	if(!IS_HERETIC(examiner))
		to_chat(examiner, span_hypnophrase("你感受到了锈蚀。腐朽。"))
		examiner.add_mood_event("rusted_examine", /datum/mood_event/eldritch_painting/rust_examine)
		return

	to_chat(examiner, span_notice("这幅画让你充满了决心。"))
	examiner.add_mood_event("rusted_examine", /datum/mood_event/eldritch_painting/rust_heretic_examine)
