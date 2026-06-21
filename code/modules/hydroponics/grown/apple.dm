// Apple
/obj/item/seeds/apple
	name = "苹果种子包"
	desc = "能长成苹果树的种子。"
	icon_state = "seed-apple"
	species = "apple"
	plantname = "Apple Tree"
	product = /obj/item/food/grown/apple
	lifespan = 55
	endurance = 35
	yield = 5
	growing_icon = 'icons/obj/service/hydroponics/growing_fruits.dmi'
	icon_grow = "apple-grow"
	icon_dead = "apple-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest, /datum/plant_gene/trait/one_bite)
	mutatelist = list(/obj/item/seeds/apple/gold)
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1)

/obj/item/food/grown/apple
	seed = /obj/item/seeds/apple
	name = "苹果"
	desc = "这是伊甸园的一小部分。"
	icon_state = "apple"
	foodtypes = FRUIT
	tastes = list("apple" = 1)
	distill_reagent = /datum/reagent/consumable/ethanol/hcider

/obj/item/food/grown/apple/juice_typepath()
	return /datum/reagent/consumable/applejuice

/obj/item/food/grown/apple/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/appleslice, 5, 20, screentip_verb = "Slice", sound_to_play = SFX_KNIFE_SLICE)

/obj/item/food/grown/apple/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if (.) //it's been caught.
		return
	if (!ishuman(hit_atom))
		return
	var/mob/living/carbon/human/einstein = hit_atom
	var/obj/item/organ/liver/liver_organ = einstein.get_organ_slot(ORGAN_SLOT_LIVER)
	if (isnull(liver_organ))
		return
	if (HAS_TRAIT(liver_organ, TRAIT_MEDICAL_METABOLISM))
		einstein.apply_damage(2, BRUTE, throwingdatum.target_zone)
	else if (HAS_TRAIT(liver_organ, TRAIT_SCIENTIST_LIVER) && throwingdatum.target_zone == BODY_ZONE_HEAD && prob(2))
		gravity_reminder(einstein)

/obj/item/food/grown/apple/onZImpact(turf/impacted_turf, levels, impact_flags)
	. = ..()
	var/mob/living/carbon/human/einstein = locate(/mob/living/carbon/human) in impacted_turf
	if (isnull(einstein))
		return
	var/obj/item/organ/liver/liver_organ = einstein.get_organ_slot(ORGAN_SLOT_LIVER)
	if (liver_organ && HAS_TRAIT(liver_organ, TRAIT_SCIENTIST_LIVER) && prob(40))
		gravity_reminder(einstein)

/// Provide an important insight
/obj/item/food/grown/apple/proc/gravity_reminder(mob/living/einstein)
	einstein.do_alert_animation()
	playsound(einstein, 'sound/machines/chime.ogg', 50, TRUE)
	einstein.say(pick_list_replacements(VISTA_FILE, "ballmer_good_msg"), forced = "apple inspiration")

// Gold Apple
/obj/item/seeds/apple/gold
	name = "金苹果种子包"
	desc = "能长成金苹果树的种子。好在太空中没有火鸟。"
	icon_state = "seed-goldapple"
	species = "goldapple"
	plantname = "Golden Apple Tree"
	product = /obj/item/food/grown/apple/gold
	maturation = 10
	production = 10
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	mutatelist = null
	reagents_add = list(/datum/reagent/gold = 0.2, /datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1)
	rarity = 40 // Alchemy!

/obj/item/food/grown/apple/gold/make_processable()
	return // You're going to break your knife!

/obj/item/food/grown/apple/gold
	seed = /obj/item/seeds/apple/gold
	name = "金苹果"
	desc = "Emblazoned upon the apple is the word 'Kallisti'."
	icon_state = "goldapple"
	distill_reagent = null
	wine_power = 50
