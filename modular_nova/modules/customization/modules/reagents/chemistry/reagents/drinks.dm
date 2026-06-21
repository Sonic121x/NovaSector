/obj/item/reagent_containers/cup/soda_cans/nova/lubricola
	name = "润滑可乐"
	desc = "为你疲惫的齿轮准备的完美润滑剂。"
	icon_state = "lubricola"
	list_reagents = list(/datum/reagent/fuel/oil = 30)
	custom_price = PAYCHECK_LOWER * 1.2

/obj/item/reagent_containers/cup/soda_cans/nova/welding_fizz
	name = "焊接嘶嘶"
	desc = "比简易爆炸装置能量还多！现已碳酸化。警告：含有有毒和易燃燃料。"
	icon_state = "welding_fizz"
	list_reagents = list(/datum/reagent/fuel = 25, /datum/reagent/carbondioxide = 5)
	custom_price = PAYCHECK_LOWER * 1.2

/obj/item/reagent_containers/cup/soda_cans/nova/synthanolcan
	name = "傻锥牌合成醇"
	desc = "一罐重新编译的合成醇。"
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
			user.visible_message(span_warning("[user] 把 [src] 的罐子砸在了 [user.p_their()] 额头上！"), span_notice("你将一罐[src]在额头上捏扁了。"))
		else
			user.visible_message(span_warning("[user] 把 [src] 的易拉罐在 [M] 的额头上捏扁了！"), span_notice("你将一罐[src]捏扁在[M]的额头上。"))
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
	visible_message(span_danger("[src] 与 [hit_atom] 的撞击导致它破裂，洒得到处都是！"))
	var/obj/item/trash/can/nova/crushed_can = new /obj/item/trash/can/nova(src.loc)
	crushed_can.icon_state = icon_state
	moveToNullspace()
	QDEL_IN(src, 1 SECONDS) // give it a second so it can still be logged for the throw impact

#undef SODA_FIZZINESS_THROWN
#undef SODA_FIZZINESS_SHAKE
