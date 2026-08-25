/obj/item/reagent_containers/cup/soda_cans/nova/lubricola
	name = "LubriCola"
	desc = "The perfect lubricant for your weary gears."
	icon_state = "lubricola"
	list_reagents = list(/datum/reagent/fuel/oil = 30)
	custom_price = PAYCHECK_LOWER * 1.2

/obj/item/reagent_containers/cup/soda_cans/nova/welding_fizz
	name = "Welding Fizz"
	desc = "More energy than in an IED! Now carbonated. WARNING: Contains toxic and flammable fuels."
	icon_state = "welding_fizz"
	list_reagents = list(/datum/reagent/fuel = 25, /datum/reagent/carbondioxide = 5)
	custom_price = PAYCHECK_LOWER * 1.2

/obj/item/reagent_containers/cup/soda_cans/nova/synthanolcan
	name = "Silly Cone's Synthanol"
	desc = "A recompiling can of synthanol."
	icon_state = "synthanolcan"
	list_reagents = list(/datum/reagent/consumable/ethanol/synthanol = 30)
	custom_price = PAYCHECK_CREW

//CODING SIN BYOND HERE

/obj/item/trash/can/nova
	icon = 'modular_nova/master_files/icons/obj/janitor.dmi'
	icon_state = "lemonade"

/*
*	NOVA SECTOR SODA CANS
*/

/// How much fizziness is added to the can of soda by throwing it, in percentage points
#define SODA_FIZZINESS_THROWN 15
/// How much fizziness is added to the can of soda by shaking it, in percentage points
#define SODA_FIZZINESS_SHAKE 5

/obj/item/reagent_containers/cup/soda_cans/nova
	icon = 'modular_nova/master_files/icons/obj/drinks.dmi'
	icon_state = null

/obj/item/reagent_containers/cup/soda_cans/nova/attack(mob/M, mob/living/user)
	if(istype(M, /mob/living/carbon) && !reagents.total_volume && user.combat_mode && user.zone_selected == BODY_ZONE_HEAD)
		if(M == user)
			user.visible_message(span_warning(LANG("obj.58fd28bc8ac4d931", list(user, src, user.p_their()))), span_notice(LANG("obj.918576da5169c04d", list(src))))
		else
			user.visible_message(span_warning(LANG("obj.7ba56bac676b1eee", list(user, src, M))), span_notice(LANG("obj.d0fb0ba14bfb7712", list(src, M))))
		playsound(M,'sound/items/weapons/pierce.ogg', rand(10,50), TRUE)
		var/obj/item/trash/can/nova/crushed_can = new /obj/item/trash/can/nova(M.loc)
		crushed_can.icon_state = icon_state
		qdel(src)
		return TRUE
	. = ..()

/obj/item/reagent_containers/cup/soda_cans/nova/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit = FALSE)
	. = ..()

	if(. != BULLET_ACT_HIT)
		return

	if(hitting_projectile.damage > 0 && hitting_projectile.damage_type == BRUTE && !QDELETED(src))
		var/obj/item/trash/can/nova/crushed_can = new /obj/item/trash/can/nova(src.loc)
		crushed_can.icon_state = icon_state
		var/atom/throw_target = get_edge_target_turf(crushed_can, pick(GLOB.alldirs))
		crushed_can.throw_at(throw_target, rand(1,2), 7)
		qdel(src)
		return

/**
 * Burst the soda open on someone. Fun! Opens and empties the soda can, but does not crush it.
 *
 * Arguments:
 * * target - Who's getting covered in soda
 * * hide_message - Stops the generic fizzing message, so you can do your own
 */

/obj/item/reagent_containers/cup/soda_cans/nova/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(. || !reagents.total_volume) // if it was caught, already opened, or has nothing in it
		return

	fizziness += SODA_FIZZINESS_THROWN
	if(!prob(fizziness))
		return

	burst_soda(hit_atom, hide_message = TRUE)
	visible_message(span_danger(LANG("obj.957f4876bfed575b", list(src, hit_atom))))
	var/obj/item/trash/can/nova/crushed_can = new /obj/item/trash/can/nova(src.loc)
	crushed_can.icon_state = icon_state
	moveToNullspace()
	QDEL_IN(src, 1 SECONDS) // give it a second so it can still be logged for the throw impact

#undef SODA_FIZZINESS_THROWN
#undef SODA_FIZZINESS_SHAKE
