/// Items fried through the deep fryer.
/datum/element/fried_item
	/// List of colors to apply the element target.
	/// Each index corresponds to a different level.
	var/static/list/fried_colors

/datum/element/fried_item/Attach(datum/target, fry_time)
	. = ..()
	if(!isatom(target))
		return ELEMENT_INCOMPATIBLE

	if (isnull(fried_colors))
		fried_colors = list(
			color_transition_filter(COLOR_LIGHT_BROWN, SATURATION_OVERRIDE),
			color_transition_filter(COLOR_BROWNER_BROWN, SATURATION_OVERRIDE),
			color_transition_filter(COLOR_DARKER_BROWN, SATURATION_OVERRIDE),
			color_transition_filter(COLOR_BLACK, SATURATION_OVERRIDE),
		)

	var/atom/this_food = target

	switch(fry_time)
		if(0 to FRYING_TIME_FRIED)
			this_food.add_atom_colour(fried_colors[1], FIXED_COLOUR_PRIORITY)
			this_food.name = "微炸 [this_food.name]"
			this_food.desc += " It's been lightly fried in a deep fryer."

		if(FRYING_TIME_FRIED to FRYING_TIME_PERFECT)
			this_food.add_atom_colour(fried_colors[2], FIXED_COLOUR_PRIORITY)
			this_food.name = "油炸 [this_food.name]"
			this_food.desc += " It's been fried, increasing its tastiness value by [rand(1, 75)]%."

		if(FRYING_TIME_PERFECT to FRYING_TIME_BURNT)
			this_food.add_atom_colour(fried_colors[3], FIXED_COLOUR_PRIORITY)
			this_food.name = "油炸 [this_food.name]"
			this_food.desc += " Deep-fried to perfection."

		if(FRYING_TIME_BURNT to INFINITY)
			this_food.add_atom_colour(fried_colors[4], FIXED_COLOUR_PRIORITY)
			this_food.name = "\proper 油炸食品这一概念的具体体现"
			this_food.desc = "一个炸得透透的……东西。谁还能分辨出来呢？"

	ADD_TRAIT(this_food, TRAIT_FOOD_FRIED, ELEMENT_TRAIT(type))
	// Already edible items will inherent these parameters
	// Otherwise, we will become edible.
	this_food.AddComponentFrom( \
		SOURCE_EDIBLE_FRIED, \
		/datum/component/edible, \
		bite_consumption = 2, \
		food_flags = FOOD_FINGER_FOOD, \
		junkiness = 10, \
		foodtypes = FRIED, \
	)
	SEND_SIGNAL(this_food, COMSIG_ITEM_FRIED, fry_time)

/datum/element/fried_item/Detach(atom/source, ...)
	for(var/color in fried_colors)
		source.remove_atom_colour(FIXED_COLOUR_PRIORITY, color)
	source.name = initial(source.name)
	source.desc = initial(source.desc)
	REMOVE_TRAIT(source, TRAIT_FOOD_FRIED, ELEMENT_TRAIT(type))
	source.RemoveComponentSource(SOURCE_EDIBLE_FRIED, /datum/component/edible)
	return ..()
