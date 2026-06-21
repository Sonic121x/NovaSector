// Banana
/obj/item/seeds/banana
	name = "香蕉种子包"
	desc = "能长成香蕉树的种子。成熟后，远离小丑。"
	icon_state = "seed-banana"
	species = "banana"
	plantname = "Banana Tree"
	product = /obj/item/food/grown/banana
	lifespan = 50
	endurance = 30
	instability = 10
	growing_icon = 'icons/obj/service/hydroponics/growing_fruits.dmi'
	icon_dead = "banana-dead"
	genes = list(/datum/plant_gene/trait/slip, /datum/plant_gene/trait/repeated_harvest)
	mutatelist = list(/obj/item/seeds/banana/mime, /obj/item/seeds/banana/bluespace)
	reagents_add = list(/datum/reagent/consumable/banana = 0.1, /datum/reagent/potassium = 0.1, /datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.02)
	graft_gene = /datum/plant_gene/trait/slip

/obj/item/food/grown/banana
	seed = /obj/item/seeds/banana
	name = "香蕉"
	desc = "这是小丑的绝佳道具。"
	icon_state = "banana"
	inhand_icon_state = "banana_peel"
	trash_type = /obj/item/grown/bananapeel
	bite_consumption_mod = 3
	foodtypes = FRUIT
	distill_reagent = /datum/reagent/consumable/ethanol/bananahonk

/obj/item/food/grown/banana/juice_typepath()
	return /datum/reagent/consumable/banana

/obj/item/food/grown/banana/make_edible()
	. = ..()
	AddComponentFrom(SOURCE_EDIBLE_INNATE, /datum/component/edible, check_liked = CALLBACK(src, PROC_REF(check_liked)))

/obj/item/food/grown/banana/Initialize(mapload)
	. = ..()
	if(prob(1))
		AddComponent(/datum/component/boomerang, boomerang_throw_range = throw_range + 4, thrower_easy_catch_enabled = TRUE, examine_message = span_green("这根香蕉的弧度看起来特别尖锐。"))

///Clowns will always like bananas.
/obj/item/food/grown/banana/proc/check_liked(mob/living/carbon/human/consumer)
	var/obj/item/organ/liver/liver = consumer.get_organ_slot(ORGAN_SLOT_LIVER)
	if (!HAS_TRAIT(consumer, TRAIT_AGEUSIA) && liver && HAS_TRAIT(liver, TRAIT_COMEDY_METABOLISM))
		return FOOD_LIKED

/obj/item/food/grown/banana/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user]正把[src]对准[user.p_them()]自己！看起来[user.p_theyre()]想自杀！"))
	playsound(loc, 'sound/items/bikehorn.ogg', 50, TRUE, -1)
	sleep(2.5 SECONDS)
	if(!user)
		return OXYLOSS
	user.say("BANG!", forced = /datum/reagent/consumable/banana)
	sleep(2.5 SECONDS)
	if(!user)
		return OXYLOSS
	user.visible_message("<B>[user]</B>笑得喘不过气来了！")
	return OXYLOSS

//Banana Peel
/obj/item/grown/bananapeel
	seed = /obj/item/seeds/banana
	name = "香蕉皮"
	desc = "从香蕉上剥下来的香蕉皮。"
	lefthand_file = 'icons/mob/inhands/items/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/food_righthand.dmi'
	icon_state = "banana_peel"
	inhand_icon_state = "banana_peel"
	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
	throw_speed = 3
	throw_range = 7

/obj/item/grown/bananapeel/Initialize(mapload)
	. = ..()
	if(prob(40))
		if(prob(60))
			icon_state = "[icon_state]_2"
		else
			icon_state = "[icon_state]_3"

/obj/item/grown/bananapeel/grind_results()
	return list(/datum/reagent/medicine/coagulant/banana_peel = seed.potency * 0.2)

/obj/item/grown/bananapeel/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user]故意踩在[src]上滑倒！看起来[user.p_theyre()]想自杀！"))
	playsound(loc, 'sound/misc/slip.ogg', 50, TRUE, -1)
	return BRUTELOSS

// Mimana - invisible sprites are totally a feature!
/obj/item/seeds/banana/mime
	name = "哑剧香蕉种子包"
	desc = "能长成默蕉树的种子。成熟后，远离默剧。"
	icon_state = "seed-mimana"
	species = "mimana"
	plantname = "Mimana Tree"
	product = /obj/item/food/grown/banana/mime
	growthstages = 4
	mutatelist = null
	reagents_add = list(/datum/reagent/consumable/nothing = 0.1, /datum/reagent/toxin/mutetoxin = 0.1, /datum/reagent/consumable/nutriment = 0.02)
	rarity = 15

/obj/item/food/grown/banana/mime
	seed = /obj/item/seeds/banana/mime
	name = "默蕉"
	desc = "它是默剧表演的绝佳道具。"
	icon_state = "mimana"
	trash_type = /obj/item/grown/bananapeel/mimanapeel
	distill_reagent = /datum/reagent/consumable/ethanol/silencer

/obj/item/grown/bananapeel/mimanapeel
	seed = /obj/item/seeds/banana/mime
	name = "默蕉皮"
	desc = "默蕉的皮。"
	icon_state = "mimana_peel"
	inhand_icon_state = "mimana_peel"

// Bluespace Banana
/obj/item/seeds/banana/bluespace
	name = "蓝空香蕉种子包"
	desc = "能长成蓝空香蕉树的种子。成熟后，远离蓝空小丑。"
	icon_state = "seed-banana-blue"
	species = "bluespacebanana"
	icon_grow = "banana-grow"
	plantname = "Bluespace Banana Tree"
	instability = 40
	product = /obj/item/food/grown/banana/bluespace
	mutatelist = null
	genes = list(/datum/plant_gene/trait/slip, /datum/plant_gene/trait/teleport, /datum/plant_gene/trait/repeated_harvest)
	reagents_add = list(/datum/reagent/bluespace = 0.2, /datum/reagent/consumable/banana = 0.1, /datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.02, /datum/reagent/liquid_dark_matter = 0.2)
	rarity = 30
	graft_gene = /datum/plant_gene/trait/teleport

/obj/item/food/grown/banana/bluespace
	seed = /obj/item/seeds/banana/bluespace
	name = "蓝空香蕉"
	icon_state = "bluenana"
	inhand_icon_state = "bluespace_peel"
	trash_type = /obj/item/grown/bananapeel/bluespace
	tastes = list("banana" = 1, "antimatter" = 1)
	wine_power = 60
	wine_flavor = "slippery hypercubes"

/obj/item/grown/bananapeel/bluespace
	seed = /obj/item/seeds/banana/bluespace
	name = "蓝空香蕉皮"
	desc = "从蓝空香蕉上剥下来的香蕉皮。"
	icon_state = "bluenana_peel"
	inhand_icon_state = "bluespace_peel"

// Other
/obj/item/grown/bananapeel/specialpeel //used by /obj/item/clothing/shoes/clown_shoes/banana_shoes
	name = "合成香蕉皮"
	desc = "一块合成香蕉皮。"

/obj/item/grown/bananapeel/specialpeel/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/slippery, 40)

/obj/item/food/grown/banana/bunch
	name = "一串香蕉"
	desc = "一串精美的香蕉。那近乎超凡的饱满度，足以让任何有眼光的表演者联想到神圣之物。"
	icon_state = "banana_bunch"
	bite_consumption_mod = 4
	var/is_ripening = FALSE

/obj/item/food/grown/banana/bunch/Initialize(mapload, obj/item/seeds/new_seed)
	. = ..()
	reagents.clear_reagents()
	reagents.add_reagent(/datum/reagent/consumable/monkey_energy, 10)
	reagents.add_reagent(/datum/reagent/consumable/banana, 10)
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_CLOWNANA, CELL_VIRUS_TABLE_GENERIC_MOB, 1, 5)

/obj/item/food/grown/banana/bunch/proc/start_ripening()
	if(is_ripening)
		return
	playsound(src, 'sound/effects/fuse.ogg', 80)

	animate(src, time = 1, pixel_z = 12, easing = ELASTIC_EASING)
	animate(time = 1, pixel_z = 0, easing = BOUNCE_EASING)
	addtimer(CALLBACK(src, PROC_REF(explosive_ripening)), 3 SECONDS)
	for(var/i in 1 to 32)
		animate(color = (i % 2) ? "#ffffff": "#ff6739", time = 1, easing = QUAD_EASING)

/obj/item/food/grown/banana/bunch/proc/explosive_ripening()
	honkerblast(src, light_range = 3, medium_range = 1)
	for(var/mob/shook_boi in range(6, loc))
		shake_camera(shook_boi, 3, 5)
	var/obj/effect/decal/cleanable/food/plant_smudge/banana_smudge = new(loc)
	banana_smudge.color = "#ffe02f"
	qdel(src)

/obj/item/food/grown/banana/bunch/monkeybomb
	desc = "一束精致的香蕉。它们超凡的饱满度似乎隐藏着什么。"

/obj/item/food/grown/banana/bunch/monkeybomb/examine(mob/user)
	. = ..()
	if(!is_simian(user))
		. += span_notice("其中一根香蕉上有个标签，你看不清上面的细节。")
		return
	. += span_notice("这束香蕉上的标签表明，猴子可以将其用作计时3秒的声波手榴弹！")

/obj/item/food/grown/banana/bunch/monkeybomb/attack_self(mob/user, modifiers)
	if(!is_simian(user))
		return to_chat(user, span_notice("你不太清楚这东西该怎么用。"))
	else start_ripening()

/// Used for april fools mail
/obj/item/grown/bananapeel/gros_michel
	name = "大麦克香蕉皮"
	desc = "一种极易受污染的香蕉品种的果皮。"

/obj/item/grown/bananapeel/gros_michel/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/germ_sensitive, mapload)
	transform *= 1.25
	AddComponent(/datum/component/decomposition, mapload, decomp_req_handle = TRUE, custom_time = 1 MINUTES, decomp_result = /obj/item/food/badrecipe/moldy)
