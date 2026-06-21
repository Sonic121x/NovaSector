/obj/item/food/grown/cannabis/on_grind()
	if(HAS_TRAIT(src, TRAIT_DRIED))
		if(!reagents)
			return ..()
		reagents.convert_reagent(/datum/reagent/drug/thc, /datum/reagent/drug/thc/hash, 1, include_source_subtypes = FALSE)
	return ..()

/datum/chemical_reaction/hash
	required_reagents = list(/datum/reagent/drug/thc/hash = 10)
	reaction_flags = REACTION_INSTANT
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_CHEMICAL

/datum/chemical_reaction/hash/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i in 1 to created_volume)
		new /obj/item/reagent_containers/hash(location)

/datum/chemical_reaction/dabs
	required_reagents = list(/datum/reagent/drug/thc = 20)
	required_temp = 420 //haha very funny
	reaction_flags = REACTION_INSTANT
	reaction_tags = REACTION_TAG_EASY | REACTION_TAG_CHEMICAL

/datum/chemical_reaction/dabs/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i in 1 to created_volume)
		new /obj/item/reagent_containers/hash/dabs(location)

//shit for effects
/datum/mood_event/stoned
	description = span_nicegreen("你现在完全嗨了...\n")
	mood_change = 6
	timeout = 3 MINUTES

/atom/movable/screen/alert/stoned
	name = "嗨了"
	desc = "你嗨得神志不清了！哇哦..."
	icon_state = "high"

//the reagent itself
/datum/reagent/drug/thc
	name = "THC"
	description = "大麻中发现的一种化学物质，是其主要的致幻成分。"
	color = "#cfa40c"
	overdose_threshold = 30 //just gives funny effects, but doesnt hurt you; thc has no actual known overdose
	ph = 6
	taste_description = "skunk"

/datum/reagent/drug/thc/concentrated
	name = "浓缩THC"
	description = "纯浓缩形式的TCH"

/datum/reagent/drug/thc/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/high_message = pick("You feel relaxed.", "You feel fucked up.", "You feel totally wrecked...")
	if(affected_mob.hud_used != null)
		var/atom/movable/plane_master_controller/game_plane_master_controller = affected_mob.hud_used.plane_master_controllers[PLANE_MASTERS_GAME]
		game_plane_master_controller.add_filter("weed_blur", 10, angular_blur_filter(0, 0, 0.45))
	if(SPT_PROB(2.5, seconds_per_tick))
		to_chat(affected_mob, span_notice("[high_message]"))
	affected_mob.add_mood_event("stoned", /datum/mood_event/stoned, name)
	affected_mob.throw_alert("嗑嗨了", /atom/movable/screen/alert/stoned)
	affected_mob.sound_environment_override = SOUND_ENVIRONMENT_DRUGGED
	affected_mob.set_dizzy_if_lower(5 * seconds_per_tick * metabolization_ratio * 2 SECONDS)
	affected_mob.adjust_nutrition(-1 * seconds_per_tick * metabolization_ratio) //munchies
	if(SPT_PROB(3.5, seconds_per_tick))
		affected_mob.emote(pick("laugh","giggle"))

/datum/reagent/drug/thc/on_mob_end_metabolize(mob/living/carbon/affected_mob)
	. = ..()
	if(affected_mob.hud_used != null)
		var/atom/movable/plane_master_controller/game_plane_master_controller = affected_mob.hud_used.plane_master_controllers[PLANE_MASTERS_GAME]
		game_plane_master_controller.remove_filter("weed_blur")
	affected_mob.clear_alert("嗑嗨了")
	affected_mob.sound_environment_override = SOUND_ENVIRONMENT_NONE

/datum/reagent/drug/thc/overdose_process(mob/living/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/cg420_message = pick("It's major...", "Oh my goodness...",)
	if(SPT_PROB(1.5, seconds_per_tick))
		affected_mob.say("[cg420_message]")
	affected_mob.adjust_drowsiness(0.2 SECONDS * normalise_creation_purity() * seconds_per_tick * metabolization_ratio)
	if(SPT_PROB(3.5, seconds_per_tick))
		playsound(affected_mob, pick('modular_nova/master_files/sound/effects/lungbust_cough1.ogg','modular_nova/master_files/sound/effects/lungbust_cough2.ogg'), 50, TRUE)
		affected_mob.emote("cough")

/datum/reagent/drug/thc/hash //only exists to generate hash object
	name = "哈希什"
	description = "浓缩大麻提取物。通过烟枪使用时能带来更强烈的快感。"
	color = "#cfa40c"
