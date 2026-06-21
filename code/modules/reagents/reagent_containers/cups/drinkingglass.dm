/obj/item/reagent_containers/cup/glass/drinkingglass
	name = "玻璃杯"
	desc = "你的标准饮水杯。"
	icon_state = "glass_empty"
	base_icon_state = "glass_empty"
	amount_per_transfer_from_this = 10
	fill_icon_thresholds = list(0)
	fill_icon_state = "drinking_glass"
	volume = 50
	custom_materials = list(/datum/material/glass=SMALL_MATERIAL_AMOUNT*5)
	max_integrity = 20
	resistance_flags = ACID_PROOF
	obj_flags = UNIQUE_RENAME
	drop_sound = 'sound/items/handling/drinkglass_drop.ogg'
	pickup_sound = 'sound/items/handling/drinkglass_pickup.ogg'
	sound_vary = TRUE
	custom_price = PAYCHECK_LOWER
	//the screwdriver cocktail can make a drinking glass into the world's worst screwdriver. beautiful.
	toolspeed = 25

	/// The type to compare to glass_style.required_container type, or null to use class type.
	/// This allows subtypes to utilize parent styles.
	var/base_container_type = null

/obj/item/reagent_containers/cup/glass/drinkingglass/Initialize(mapload, vol)
	. = ..()
	AddComponent( \
		/datum/component/takes_reagent_appearance, \
		CALLBACK(src, PROC_REF(on_cup_change)), \
		CALLBACK(src, PROC_REF(on_cup_reset)), \
		base_container_type = base_container_type, \
	)
	RegisterSignal(src, COMSIG_COMPONENT_CLEAN_ACT, PROC_REF(on_cleaned))

/obj/item/reagent_containers/cup/glass/drinkingglass/on_reagent_change(datum/reagents/holder, ...)
	. = ..()
	if(!length(reagents.reagent_list))
		qdel(GetComponent(/datum/component/rename))
		REMOVE_TRAIT(src, TRAIT_WAS_RENAMED, SHAKER_LABEL_TRAIT) //so new drinks can rename the glass

// Having our icon state change removes fill thresholds
/obj/item/reagent_containers/cup/glass/drinkingglass/on_cup_change(datum/glass_style/style)
	. = ..()
	fill_icon_thresholds = null

// And having our icon reset restores our fill thresholds
/obj/item/reagent_containers/cup/glass/drinkingglass/on_cup_reset()
	. = ..()
	fill_icon_thresholds ||= list(0)

/obj/item/reagent_containers/cup/glass/drinkingglass/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(src, TRAIT_WAS_RENAMED))
		. += span_notice("这个杯子被赋予了自定义名称。可以通过清洗来移除它。")

/obj/item/reagent_containers/cup/glass/drinkingglass/proc/on_cleaned(obj/source_component, obj/source)
	SIGNAL_HANDLER
	if(!HAS_TRAIT(src, TRAIT_WAS_RENAMED))
		return NONE

	qdel(GetComponent(/datum/component/rename))
	REMOVE_TRAIT(src, TRAIT_WAS_RENAMED, SHAKER_LABEL_TRAIT)
	name = initial(name)
	desc = initial(desc)
	update_appearance(UPDATE_NAME | UPDATE_DESC)
	return COMPONENT_CLEANED|COMPONENT_CLEANED_GAIN_XP

//Shot glasses!//
//  This lets us add shots in here instead of lumping them in with drinks because >logic  //
//  The format for shots is the exact same as iconstates for the drinking glass, except you use a shot glass instead.  //
//  If it's a new drink, remember to add it to Chemistry-Reagents.dm  and Chemistry-Recipes.dm as well.  //
//  You can only mix the ported-over drinks in shot glasses for now (they'll mix in a shaker, but the sprite won't change for glasses). //
//  This is on a case-by-case basis, and you can even make a separate sprite for shot glasses if you want. //

/obj/item/reagent_containers/cup/glass/drinkingglass/shotglass
	name = "烈酒杯"
	desc = "一个烈酒杯——糟糕决定的通用象征。"
	icon = 'icons/obj/drinks/shot_glasses.dmi'
	icon_state = "shotglass"
	base_icon_state = "shotglass"
	gulp_size = 15
	amount_per_transfer_from_this = 15
	possible_transfer_amounts = list(15)
	fill_icon_state = "shot_glass"
	volume = 15
	custom_materials = list(/datum/material/glass=SMALL_MATERIAL_AMOUNT)
	custom_price = PAYCHECK_CREW * 0.4

/obj/item/reagent_containers/cup/glass/drinkingglass/shotglass/update_name(updates)
	if(HAS_TRAIT(src, TRAIT_WAS_RENAMED))
		return
	. = ..()
	name = "[length(reagents.reagent_list) ? "filled " : ""]小酒杯"

/obj/item/reagent_containers/cup/glass/drinkingglass/shotglass/update_desc(updates)
	if(HAS_TRAIT(src, TRAIT_WAS_RENAMED))
		return
	. = ..()
	if(length(reagents.reagent_list))
		desc = "挑战不在于你能喝多少，而在于在你昏倒前猜出它是什么。"
	else
		desc = "一个烈酒杯——糟糕决定的通用象征。"

/obj/item/reagent_containers/cup/glass/drinkingglass/filled
	base_container_type = /obj/item/reagent_containers/cup/glass/drinkingglass

/obj/item/reagent_containers/cup/glass/drinkingglass/filled/Initialize(mapload, vol)
	. = ..()
	update_appearance()

/obj/item/reagent_containers/cup/glass/drinkingglass/filled/soda
	name = "Soda Water-苏打水"
	list_reagents = list(/datum/reagent/consumable/sodawater = 50)

/obj/item/reagent_containers/cup/glass/drinkingglass/filled/cola
	name = "Space Cola-太空可乐"
	list_reagents = list(/datum/reagent/consumable/space_cola = 50)

/obj/item/reagent_containers/cup/glass/drinkingglass/filled/nuka_cola
	name = "Nuka Cola-核子可乐"
	list_reagents = list(/datum/reagent/consumable/nuka_cola = 50)

/obj/item/reagent_containers/cup/glass/drinkingglass/filled/pina_colada
	name = "椰林飘香"
	list_reagents = list(/datum/reagent/consumable/ethanol/pina_colada = 50)

/obj/item/reagent_containers/cup/glass/drinkingglass/filled/half_full
	name = "半满杯水"
	desc  = "It's a glass of water. It seems half full. Or is it half empty? You're pretty sure it's full of shit."
	list_reagents = list(/datum/reagent/water = 25)

/obj/item/reagent_containers/cup/glass/drinkingglass/filled/half_full/Initialize(mapload, vol)
	. = ..()
	name = "[pick("half full", "half empty")]杯水"

/obj/item/reagent_containers/cup/glass/drinkingglass/filled/irish_cream
	name = "爱尔兰奶油"
	list_reagents = list(/datum/reagent/consumable/ethanol/irish_cream = 50)
