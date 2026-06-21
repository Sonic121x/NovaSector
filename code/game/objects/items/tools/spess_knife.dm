#define NO_TOOL "fold"

/obj/item/spess_knife
	name = "太空小刀"
	desc = "释放你指尖的宇宙巧思。它无缝切换形态，揭示可能拯救局面的隐藏才能。谁知道这件天界工具中藏着什么秘密？"
	icon = 'icons/obj/tools.dmi'
	icon_state = "spess_knife"
	worn_icon_state = "spess_knife"
	inside_belt_icon_state = "spess_knife"
	inhand_icon_state = "spess_knife"
	icon_angle = -90
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	obj_flags = CONDUCTS_ELECTRICITY
	slot_flags = ITEM_SLOT_BELT
	resistance_flags = FIRE_PROOF
	tool_behaviour = null
	toolspeed = 1.25 // 25% worse than default tools
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT)
	hitsound = SFX_SWING_HIT
	///Radial menu tool options
	var/list/options = list()
	///Chance to select wrong tool
	var/wrong_tool_prob = 10

/obj/item/spess_knife/get_all_tool_behaviours()
	return list(TOOL_KNIFE, TOOL_SCREWDRIVER, TOOL_WIRECUTTER)

/obj/item/spess_knife/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/butchering, \
		speed = 8 SECONDS, \
		effectiveness = 100, \
		disabled = TRUE, \
	)
	options = list(
		NO_TOOL = image(icon = 'icons/obj/tools.dmi', icon_state = initial(icon_state)),
		TOOL_KNIFE = image(icon = 'icons/obj/tools.dmi', icon_state = "[initial(icon_state)]_[TOOL_KNIFE]"),
		TOOL_SCREWDRIVER = image(icon = 'icons/obj/tools.dmi', icon_state = "[initial(icon_state)]_[TOOL_SCREWDRIVER]"),
		TOOL_WIRECUTTER = image(icon = 'icons/obj/tools.dmi', icon_state = "[initial(icon_state)]_[TOOL_WIRECUTTER]"),
	)

/obj/item/spess_knife/attack_self(mob/user, modifiers)
	. = ..()
	var/old_tool_behaviour = tool_behaviour
	var/new_tool_behaviour = show_radial_menu(user, src, options, require_near = TRUE, tooltips = TRUE)
	if(isnull(new_tool_behaviour) || new_tool_behaviour == tool_behaviour)
		return
	if(new_tool_behaviour == NO_TOOL)
		tool_behaviour = null
	else
		tool_behaviour = new_tool_behaviour

	var/mistake_chance = HAS_TRAIT(user, TRAIT_CLUMSY) ? wrong_tool_prob * 5 : wrong_tool_prob
	var/mistake_occured = FALSE
	if(!isnull(tool_behaviour) && prob(mistake_chance))
		do
			pick_tool() // Pick random tool, excluding the desired and current one
		while (tool_behaviour == new_tool_behaviour || tool_behaviour == old_tool_behaviour)
		mistake_occured = TRUE

	if(isnull(tool_behaviour))
		update_weight_class(WEIGHT_CLASS_TINY)
		balloon_alert(user, "已折叠")
	else
		update_weight_class(WEIGHT_CLASS_SMALL)
		balloon_alert(user, mistake_occured ? "哎呀！[tool_behaviour] 出来了" : "[tool_behaviour] 出来了")

	update_tool_parameters()
	update_appearance(UPDATE_ICON_STATE)
	playsound(src, 'sound/items/weapons/empty.ogg', 50, TRUE)

/// Used to pick random tool behavior for the knife
/obj/item/spess_knife/proc/pick_tool()
	tool_behaviour = pick_weight(list(
		TOOL_KNIFE = 10,
		TOOL_SCREWDRIVER = 10,
		TOOL_WIRECUTTER = 10,
		TOOL_WRENCH = 5,
		TOOL_SHOVEL = 2,
		TOOL_SAW = 2,
		TOOL_ROLLINGPIN = 1,
	))

/// Used to update sounds and tool parameters during switching
/obj/item/spess_knife/proc/update_tool_parameters()
	var/datum/component/butchering/butchering = src.GetComponent(/datum/component/butchering)
	butchering.butchering_enabled = tool_behaviour == TOOL_KNIFE
	RemoveElement(/datum/element/eyestab)
	var/obj/item/reference
	switch(tool_behaviour)
		if(TOOL_KNIFE)
			force = 8
			reference = /obj/item/knife
			AddElement(/datum/element/eyestab)
		if(TOOL_SCREWDRIVER)
			force = 4
			reference = /obj/item/screwdriver
			AddElement(/datum/element/eyestab)
		if(TOOL_WIRECUTTER)
			force = 4
			reference = /obj/item/wirecutters
		if(TOOL_WRENCH)
			force = 4
			reference = /obj/item/wrench
		if(TOOL_SHOVEL)
			force = 6
			reference = /obj/item/shovel
		if(TOOL_SAW)
			force = 6
			reference = /obj/item/knife // There is no manual saw in the game ATM to refer
		if(TOOL_ROLLINGPIN)
			force = 6
			reference = /obj/item/kitchen/rollingpin
		else
			force = 0
	if(isnull(reference))
		sharpness = NONE
		hitsound = initial(hitsound)
		usesound = initial(usesound)
	else
		sharpness = initial(reference.sharpness)
		hitsound = initial(reference.hitsound)
		usesound = initial(reference.usesound)

/obj/item/spess_knife/examine(mob/user)
	. = ..()

	if(tool_behaviour)
		. += "It has a [tool_behaviour] extended out."
	else
		. += "It's folded."

/obj/item/spess_knife/update_icon_state()
	icon_state = initial(icon_state)

	if (tool_behaviour)
		icon_state += "_[sanitize_css_class_name(tool_behaviour)]"

	if(tool_behaviour)
		inhand_icon_state = initial(inhand_icon_state) + "_unfolded"
	else
		inhand_icon_state = initial(inhand_icon_state)

	return ..()

#undef NO_TOOL
