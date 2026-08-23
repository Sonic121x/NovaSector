// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
// The basic eldritch painting
/obj/item/wallframe/painting/eldritch
	name = "The Blank Canvas: A Study in Default Subtypes"
	desc = "An impossible painting made of impossible paint. It should not exist in this reality."
	icon = 'icons/obj/signs.dmi'
	resistance_flags = FLAMMABLE
	flags_1 = NONE
	icon_state = "eldritch_painting_debug"
	result_path = /obj/structure/sign/painting/eldritch
	pixel_shift = 30

/obj/structure/sign/painting/eldritch
	name = "The Blank Canvas: A Study in Default Subtypes"
	desc = "An impossible painting made of impossible paint. It should not exist in this reality."
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
	if(isnull(viewer.mind) || isnull(viewer.mob_mood) || IS_UNCONSCIOUS_OR_CRIT(viewer) || viewer.is_blind())
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
	to_chat(viewer, span_hypnophrase(LANG("obj.2d978eaaa5c5e8f4", null)))

/obj/structure/sign/painting/eldritch/wirecutter_act(mob/living/user, obj/item/I)
	if(!user.can_block_magic(MAGIC_RESISTANCE_MOON))
		user.add_mood_event("ripped_eldritch_painting", /datum/mood_event/eldritch_painting)
		to_chat(user, span_hypnophrase(LANG("obj.e2c85404530b30e3", null)))
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
		to_chat(examiner, span_notice(LANG("obj.17b4027b7cd178e9", null)))
	else
		to_chat(examiner, span_notice(LANG("obj.d73b73ed2fd9b494", null)))

// The Sister and He Who Wept eldritch painting
/obj/item/wallframe/painting/eldritch/weeping
	name = "\improper The Sister and He Who Wept"
	desc = "A beautiful painting depicting a fair lady sitting beside Him. He weeps. You will see him again."
	icon_state = "eldritch_painting_weeping"
	result_path = /obj/structure/sign/painting/eldritch/weeping

/obj/structure/sign/painting/eldritch/weeping
	name = "\improper The Sister and He Who Wept"
	desc = "A beautiful painting depicting a fair lady sitting beside Him. He weeps. You will see him again. Removable with wirecutters."
	icon_state = "eldritch_painting_weeping"
	applied_status_effect = /datum/status_effect/eldritch_painting/weeping
	text_to_display = "Such beauty! Such sorrow!"

/obj/structure/sign/painting/eldritch/weeping/examine_effects(mob/living/carbon/examiner)
	if(!IS_HERETIC(examiner))
		to_chat(examiner, span_hypnophrase(LANG("obj.1921bcda9c9ddb2a", null)))
		examiner.mob_mood.mood_events.Remove("eldritch_weeping")
		examiner.add_mood_event("weeping_withdrawal", /datum/mood_event/eldritch_painting/weeping_withdrawal)
		return

	to_chat(examiner, span_notice(LANG("obj.0e94b28eb7768cff", null)))
	examiner.remove_status_effect(/datum/status_effect/hallucination)
	examiner.add_mood_event("heretic_eldritch_painting", /datum/mood_event/eldritch_painting/weeping_heretic)

// The First Desire painting, using a lot of the painting/eldritch framework
/obj/item/wallframe/painting/eldritch/desire
	name = "\improper The Feast of Desire"
	desc = "A painting of an elaborate feast. Despite being made entirely of rotting meat and decaying organs, the food looks very appetising."
	icon_state = "eldritch_painting_desire"
	result_path = /obj/structure/sign/painting/eldritch/desire

/obj/structure/sign/painting/eldritch/desire
	name = "\improper The Feast of Desire"
	desc = "A painting of an elaborate feast. Despite being made entirely of rotting meat and decaying organs, the food looks very appetising. Removable with wirecutters."
	icon_state = "eldritch_painting_desire"
	applied_status_effect = /datum/status_effect/eldritch_painting/desire
	text_to_display = "Just looking at this painting makes me hungry..."

// The special examine interaction for this painting
/obj/structure/sign/painting/eldritch/desire/examine_effects(mob/living/carbon/examiner)
	if(!IS_HERETIC(examiner))
		// Gives them some nutrition
		examiner.adjust_nutrition(50)
		to_chat(examiner, span_warning(LANG("obj.40deb76f801f97ce", null)))
		examiner.adjust_organ_loss(ORGAN_SLOT_STOMACH, 5)
		to_chat(examiner, span_notice(LANG("obj.2dc4af5a7021bf17", null)))
		to_chat(examiner, span_warning(LANG("obj.066b53cf99623855", null)))
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
	to_chat(examiner, span_notice(LANG("obj.e72ebded99134562", null)))
	to_chat(examiner, span_warning(LANG("obj.1b06c6728b4b3445", null)))
	// Adds a negative mood event to our heretic
	examiner.add_mood_event("heretic_eldritch_hunger", /datum/mood_event/eldritch_painting/desire_heretic)

// Great chaparral over rolling hills, this one doesn't have the sensor type
/obj/item/wallframe/painting/eldritch/vines
	name = "\improper Great Chaparral Over Rolling Hills"
	desc = "A painting depicting a massive thicket. This painting teems with life, and seems to strain against its frame."
	icon_state = "eldritch_painting_vines"
	result_path = /obj/structure/sign/painting/eldritch/vines

/obj/structure/sign/painting/eldritch/vines
	name = "\improper Great Chaparral Over Rolling Hills"
	desc = "A painting depicting a massive thicket. This painting teems with life, and seems to strain against its frame. Removable with wirecutters."
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
		/obj/item/food/grown/flower/poppy,
		/obj/item/food/grown/flower/harebell,
	)

/obj/structure/sign/painting/eldritch/vines/Initialize(mapload)
	. = ..()
	new /datum/spacevine_controller(get_turf(src), mutations, 0, 10)

/obj/structure/sign/painting/eldritch/vines/examine_effects(mob/living/carbon/examiner)
	. = ..()
	if(!IS_HERETIC(examiner))
		new /datum/spacevine_controller(get_turf(examiner), mutations, 0, 10)
		to_chat(examiner, span_hypnophrase(LANG("obj.c6f7af759618af88", null)))
		to_chat(examiner, span_notice(LANG("obj.f84e4102084842ba", null)))
		return

	var/item_to_spawn = pick(items_to_spawn)
	to_chat(examiner, span_notice(LANG("obj.4a37377b65d59219", null)))
	to_chat(examiner, span_notice(LANG("obj.d88a79b14a6fa168", null)))
	new item_to_spawn(examiner.drop_location())
	examiner.add_mood_event("heretic_vines", /datum/mood_event/eldritch_painting/heretic_vines)


// Lady out of gates, gives a brain trauma causing the person to scratch themselves
/obj/item/wallframe/painting/eldritch/beauty
	name = "\improper Lady of the Gate"
	desc = "A painting of an otherworldly being. Its thin, porcelain-coloured skin is stretched tight over its strange bone structure. It has an odd beauty."
	icon_state = "eldritch_painting_beauty"
	result_path = /obj/structure/sign/painting/eldritch/beauty

/obj/structure/sign/painting/eldritch/beauty
	name = "\improper Lady of the Gate"
	desc = "A painting of an otherworldly being. Its thin, porcelain-coloured skin is stretched tight over its strange bone structure. It has an odd beauty. Removable with wirecutters."
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
		to_chat(examiner, span_hypnophrase(LANG("obj.d02228c69fc09381", null)))
		examiner.easy_random_mutate(NEGATIVE + MINOR_NEGATIVE)
		return

	to_chat(examiner, span_notice(LANG("obj.3dcfa58bb900b89c", null)))
	examiner.reagents.add_reagent_list(reagents_to_add)

// Climb over the rusted mountain, gives a brain trauma causing the person to randomly rust tiles beneath them
/obj/item/wallframe/painting/eldritch/rust
	name = "\improper Master of the Rusted Mountain"
	desc = "A painting of a strange being climbing a rust-coloured mountain. The brushwork is unnatural and unnerving."
	icon_state = "eldritch_painting_rust"
	result_path = /obj/structure/sign/painting/eldritch/rust

/obj/structure/sign/painting/eldritch/rust
	name = "\improper Master of the Rusted Mountain"
	desc = "A painting of a strange being climbing a rust-coloured mountain. The brushwork is unnatural and unnerving. Removable with wirecutters."
	icon_state = "eldritch_painting_rust"
	applied_status_effect = /datum/status_effect/eldritch_painting/rusting
	text_to_display = "The rust decays. The master climbs. It calls. You answer..."

// The special examine interaction for this painting
/obj/structure/sign/painting/eldritch/rust/examine_effects(mob/living/carbon/examiner)
	. = ..()

	if(!IS_HERETIC(examiner))
		to_chat(examiner, span_hypnophrase(LANG("obj.e53c24827c1e52bc", null)))
		examiner.add_mood_event("rusted_examine", /datum/mood_event/eldritch_painting/rust_examine)
		return

	to_chat(examiner, span_notice(LANG("obj.7fe57858103126ea", null)))
	examiner.add_mood_event("rusted_examine", /datum/mood_event/eldritch_painting/rust_heretic_examine)
