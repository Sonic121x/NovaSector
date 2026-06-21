// Watermelon
/obj/item/seeds/watermelon
	name = "西瓜种子包"
	desc = "能长成西瓜植株的种子(watermelon seeds)。"
	icon_state = "seed-watermelon"
	species = "watermelon"
	plantname = "Watermelon Vines"
	product = /obj/item/food/grown/watermelon
	lifespan = 50
	endurance = 40
	instability = 20
	growing_icon = 'icons/obj/service/hydroponics/growing_fruits.dmi'
	icon_dead = "watermelon-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	mutatelist = list(/obj/item/seeds/watermelon/holy, /obj/item/seeds/watermelon/barrel)
	reagents_add = list(/datum/reagent/water = 0.2, /datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.2)

/obj/item/seeds/watermelon/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user]正在吞下[src]！看起来[user.p_theyre()]试图自杀！"))
	user.gib(DROP_ALL_REMAINS)
	new product(drop_location())
	qdel(src)
	return MANUAL_SUICIDE

/obj/item/food/grown/watermelon
	seed = /obj/item/seeds/watermelon
	name = "西瓜"
	desc = "水分足，味道好。"
	icon_state = "watermelon"
	inhand_icon_state = "watermelon"
	bite_consumption_mod = 2
	w_class = WEIGHT_CLASS_NORMAL
	foodtypes = FRUIT
	wine_power = 40

/obj/item/food/grown/watermelon/juice_typepath()
	return /datum/reagent/consumable/watermelonjuice

/obj/item/food/grown/watermelon/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/watermelonslice, 5, 20, screentip_verb = "Slice", sound_to_play = SFX_KNIFE_SLICE)

/obj/item/food/grown/watermelon/make_dryable()
	return //No drying

/obj/item/food/grown/watermelon/attackby(obj/item/I, mob/user, list/modifiers, list/attack_modifiers)
	if(!istype(I, /obj/item/kitchen/spoon))
		return ..()

	var/melon_pulp_count = 1
	if(seed)
		melon_pulp_count += round(seed.potency / 25)

	user.balloon_alert(user, "挖出了[melon_pulp_count]块果肉")
	for(var/i in 1 to melon_pulp_count)
		new /obj/item/food/watermelonmush(user.loc)

	/// The piece of armour melon turns into; either chetsplate or helmet
	var/obj/item/clothing/melon_armour
	/// Chance for the armour to be a chestplate instead of the helmet
	var/melon_chestplate_chance = (max(0, seed.potency - 50) / 50)
	if (prob(melon_chestplate_chance))
		if(seed.resistance_flags & FIRE_PROOF)
			melon_armour = new /obj/item/clothing/suit/armor/durability/watermelon/fire_resist
		else
			melon_armour = new /obj/item/clothing/suit/armor/durability/watermelon
		to_chat(user, span_notice("你用[I]将西瓜挖空做成了头盔。"))
	else
		if(seed.resistance_flags & FIRE_PROOF)
			melon_armour = new /obj/item/clothing/head/helmet/durability/watermelon/fire_resist
		else
			melon_armour = new /obj/item/clothing/head/helmet/durability/watermelon
		to_chat(user, span_notice("你用[I]将西瓜挖空做成了胸甲。"))
	remove_item_from_storage(user)
	qdel(src)
	user.put_in_hands(melon_armour)

// Holymelon
/obj/item/seeds/watermelon/holy
	name = "圣瓜种子包"
	desc = "能长成圣瓜植株的种子(holymelon seeds)。"
	icon_state = "seed-holymelon"
	species = "holymelon"
	plantname = "Holy Melon Vines"
	product = /obj/item/food/grown/holymelon
	genes = list(/datum/plant_gene/trait/glow/yellow, /datum/plant_gene/trait/anti_magic)
	mutatelist = null
	reagents_add = list(/datum/reagent/water/holywater = 0.2, /datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.1)
	rarity = PLANT_MODERATELY_RARE
	graft_gene = /datum/plant_gene/trait/glow/yellow

/obj/item/food/grown/holymelon
	seed = /obj/item/seeds/watermelon/holy
	name = "圣瓜"
	desc = "这个甜瓜里的水得到了某个特别喜欢西瓜的神的祝福。"
	icon_state = "holymelon"
	inhand_icon_state = "holymelon"
	bite_consumption_mod = 2
	w_class = WEIGHT_CLASS_NORMAL
	foodtypes = FRUIT
	wine_power = 70 //Water to wine, baby.
	wine_flavor = "divinity"

/obj/item/food/grown/holymelon/juice_typepath()
	return /datum/reagent/water/holywater

/obj/item/food/grown/holymelon/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/holymelonslice, 5, 20, screentip_verb = "Slice", sound_to_play = SFX_KNIFE_SLICE)

/obj/item/food/grown/holymelon/make_dryable()
	return //No drying

/obj/item/food/grown/holymelon/make_edible()
	. = ..()
	AddComponentFrom(SOURCE_EDIBLE_INNATE, /datum/component/edible, check_liked = CALLBACK(src, PROC_REF(check_holyness)))


/obj/item/food/grown/holymelon/attackby(obj/item/I, mob/user, list/modifiers, list/attack_modifiers)
	if(!istype(I, /obj/item/kitchen/spoon))
		return ..()

	var/holymelon_pulp_count = 1
	if(seed)
		holymelon_pulp_count += round(seed.potency / 25)

	user.balloon_alert(user, "挖出了[holymelon_pulp_count]块果肉")
	for(var/i in 1 to holymelon_pulp_count)
		new /obj/item/food/holymelonmush(user.loc)

	/// The piece of armour holymelon turns into; either chetsplate or helmet
	var/obj/item/clothing/holymelon_armour
	/// Chance for the armour to be a chestplate instead of the helmet
	var/holymelon_chestplate_chance = (max(0, seed.potency - 50) / 50)
	if (prob(holymelon_chestplate_chance))
		if(seed.resistance_flags & FIRE_PROOF)
			holymelon_armour = new /obj/item/clothing/suit/armor/durability/holymelon/fire_resist
		else
			holymelon_armour = new /obj/item/clothing/suit/armor/durability/holymelon
		to_chat(user, span_notice("你用[I]将圣瓜挖空做成了头盔。"))
	else
		if(seed.resistance_flags & FIRE_PROOF)
			holymelon_armour = new /obj/item/clothing/head/helmet/durability/holymelon/fire_resist
		else
			holymelon_armour = new /obj/item/clothing/head/helmet/durability/holymelon
		to_chat(user, span_notice("你用[I]将圣瓜挖空做成了胸甲。"))
	remove_item_from_storage(user)
	qdel(src)
	user.put_in_hands(holymelon_armour)

/*
 * Callback to be used with the edible component.
 * Checks whether or not the person eating the holymelon
 * is a holy_role (chaplain), as chaplains love holymelons.
 */
/obj/item/food/grown/holymelon/proc/check_holyness(mob/mob_eating)
	if(!ishuman(mob_eating))
		return
	var/mob/living/carbon/human/holy_person = mob_eating
	if(!holy_person.mind?.holy_role || HAS_TRAIT(holy_person, TRAIT_AGEUSIA))
		return
	to_chat(holy_person, span_notice("这真是天堂的滋味！"))
	holy_person.add_mood_event("Divine_chew", /datum/mood_event/holy_consumption)
	return FOOD_LIKED

/// Barrel melon Seeds
/obj/item/seeds/watermelon/barrel
	name = "桶瓜种子包"
	desc = "这些种子可以长成桶瓜(barrelmelon seeds)。"
	icon_state = "seed-barrelmelon"
	species = "barrelmelon"
	plantname = "Barrel Melon Vines"
	product = /obj/item/food/grown/barrelmelon
	genes = list(/datum/plant_gene/trait/brewing)
	mutatelist = null
	reagents_add = list(/datum/reagent/consumable/ethanol/ale = 0.2, /datum/reagent/consumable/nutriment = 0.1)
	rarity = 10
	graft_gene = /datum/plant_gene/trait/brewing

/// Barrel melon Fruit
/obj/item/food/grown/barrelmelon
	seed = /obj/item/seeds/watermelon/barrel
	name = "桶瓜"
	desc = "这桶瓜(barrelmelon)中的营养物质经过其自身的压缩和发酵，含有浓郁的酒精。"
	icon_state = "barrelmelon"
	inhand_icon_state = "barrelmelon"
	distill_reagent = /datum/reagent/medicine/antihol //You can call it a integer overflow.

/obj/item/food/grown/barrelmelon/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/barrelmelonslice, 5, 20, screentip_verb = "Chop")

/obj/item/food/grown/barrelmelon/attackby(obj/item/I, mob/user, list/modifiers, list/attack_modifiers)
	if(!istype(I, /obj/item/kitchen/spoon))
		return ..()

	var/barrelmelon_pulp_count = 1
	if(seed)
		barrelmelon_pulp_count += round(seed.potency / 25)

	user.balloon_alert(user, "挖出了[barrelmelon_pulp_count]块果肉")
	for(var/i in 1 to barrelmelon_pulp_count)
		new /obj/item/food/barrelmelonmush(user.loc)

	/// The piece of armour barrelmelon turns into; either chetsplate or helmet
	var/obj/item/clothing/barrelmelon_armour
	/// Chance for the armour to be a chestplate instead of the helmet
	var/barrelmelon_chestplate_chance = (max(0, seed.potency - 50) / 50)
	if (prob(barrelmelon_chestplate_chance))
		if(seed.resistance_flags & FIRE_PROOF)
			barrelmelon_armour = new /obj/item/clothing/suit/armor/durability/barrelmelon/fire_resist
		else
			barrelmelon_armour = new /obj/item/clothing/suit/armor/durability/barrelmelon
		to_chat(user, span_notice("你用[I]将桶瓜挖空做成了头盔。"))
	else
		if(seed.resistance_flags & FIRE_PROOF)
			barrelmelon_armour = new /obj/item/clothing/head/helmet/durability/barrelmelon/fire_resist
		else
			barrelmelon_armour = new /obj/item/clothing/head/helmet/durability/barrelmelon
		to_chat(user, span_notice("你用[I]将桶瓜挖空做成了胸甲。"))

	remove_item_from_storage(user)
	qdel(src)
	user.put_in_hands(barrelmelon_armour)
