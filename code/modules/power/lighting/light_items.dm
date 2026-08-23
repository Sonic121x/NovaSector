// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
// the light item
// can be tube or bulb subtypes
// will fit into empty /obj/machinery/light of the corresponding type

/obj/item/light
	icon = 'icons/obj/lighting.dmi'
	force = 2
	throwforce = 5
	w_class = WEIGHT_CLASS_TINY
	custom_materials = list(/datum/material/glass=SMALL_MATERIAL_AMOUNT)
	///How much light it gives off
	var/brightness = 2
	///LIGHT_OK, LIGHT_BURNED or LIGHT_BROKEN
	var/status = LIGHT_OK
	///Base icon state for each bulb types
	var/base_state
	///Number of times switched on and off
	var/switchcount = 0

/obj/item/light/Initialize(mapload)
	. = ..()
	create_reagents(LIGHT_REAGENT_CAPACITY, INJECTABLE | DRAINABLE | SEALED_CONTAINER | TRANSPARENT)
	AddComponent(/datum/component/caltrop, min_damage = force)
	update_icon_state()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
	)
	AddElement(/datum/element/connect_loc, loc_connections)
	AddElement(/datum/element/update_icon_updates_onmob)
	AddComponent(/datum/component/golem_food, golem_food_key = /obj/item/light, extra_validation = CALLBACK(src, PROC_REF(is_intact)))

/obj/item/light/grind_results()
	return list(/datum/reagent/silicon = 5, /datum/reagent/nitrogen = 10)

/obj/item/light/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/lightreplacer))
		return NONE
	tool.item_interaction(user, src)
	return ITEM_INTERACT_SUCCESS

/// Returns true if bulb is intact
/obj/item/light/proc/is_intact()
	return status == LIGHT_OK

/obj/item/light/suicide_act(mob/living/user)
	if (status == LIGHT_BROKEN)
		user.visible_message(span_suicide(LANG("obj.e72a1256a685556c", list(user, user.p_them(), src, user.p_theyre()))))
	else
		user.visible_message(span_suicide(LANG("obj.7446c38ba51ffa1c", list(user, src, user.p_theyre()))))
		shatter()
	return BRUTELOSS

/obj/item/light/tube
	name = "light tube"
	desc = "A replacement light tube."
	icon_state = "ltube"
	base_state = "ltube"
	worn_icon = "ltube"
	inhand_icon_state = "ltube"
	icon_angle = -45
	brightness = 8
	custom_price = PAYCHECK_CREW * 0.5

/obj/item/light/tube/update_icon_state()
	. = ..()
	switch(status)
		if(LIGHT_BURNED)
			inhand_icon_state = "[base_state]-burned"
		if(LIGHT_BROKEN)
			inhand_icon_state = "[base_state]-broken"

/obj/item/light/tube/broken
	status = LIGHT_BROKEN
	sharpness = SHARP_POINTY

/obj/item/light/bulb
	name = "light bulb"
	desc = "A replacement light bulb."
	icon_state = "lbulb"
	base_state = "lbulb"
	icon_angle = -90
	worn_icon = "lbulb"
	inhand_icon_state = "contvapour"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	brightness = 4
	custom_price = PAYCHECK_CREW * 0.4

/obj/item/light/bulb/broken
	status = LIGHT_BROKEN
	sharpness = SHARP_POINTY

/obj/item/light/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(!..()) //not caught by a mob
		shatter()

// update the icon state and description of the light

/obj/item/light/update_icon_state()
	. = ..()
	switch(status)
		if(LIGHT_OK)
			icon_state = base_state
		if(LIGHT_BURNED)
			icon_state = "[base_state]-burned"
		if(LIGHT_BROKEN)
			icon_state = "[base_state]-broken"

/obj/item/light/update_desc()
	. = ..()
	switch(status)
		if(LIGHT_OK)
			desc = LANG("obj.4d3eacbb7bf43548", list(name))
		if(LIGHT_BURNED)
			desc = LANG("obj.e272c82428315e04", list(name))
		if(LIGHT_BROKEN)
			desc = LANG("obj.0c66c17ad0abc3d5", list(name))

/obj/item/light/proc/on_entered(datum/source, atom/movable/moving_atom)
	SIGNAL_HANDLER
	if(!isliving(moving_atom))
		return
	var/mob/living/moving_mob = moving_atom
	if(!(moving_mob.movement_type & MOVETYPES_NOT_TOUCHING_GROUND) || moving_mob.buckled)
		playsound(src, 'sound/effects/footstep/glass_step.ogg', HAS_TRAIT(moving_mob, TRAIT_LIGHT_STEP) ? 30 : 50, TRUE)
		if(status == LIGHT_BURNED || status == LIGHT_OK)
			shatter(moving_mob)

/obj/item/light/attack(mob/living/M, mob/living/user, def_zone)
	..()
	shatter(M)

/obj/item/light/attack_atom(obj/attacked_obj, mob/living/user, list/modifiers, list/attack_modifiers)
	..()
	shatter(attacked_obj)

/obj/item/light/proc/shatter(target)
	if(status == LIGHT_OK || status == LIGHT_BURNED)
		visible_message(span_danger(LANG("obj.2f5bd03cb3300512", list(src))),span_hear(LANG("obj.1495b353d5e1d9a1", null)))
		status = LIGHT_BROKEN
		force = 5
		sharpness = SHARP_POINTY
		playsound(loc, 'sound/effects/glass/glasshit.ogg', 75, TRUE)
		if(length(reagents.reagent_list))
			visible_message(span_danger(LANG("obj.6bace69025a9d6c5", list(src))),span_hear(LANG("obj.9a869e2ae05b23a5", list(src))))
			reagents.expose(target, TOUCH)
		update_appearance(UPDATE_DESC | UPDATE_ICON)
