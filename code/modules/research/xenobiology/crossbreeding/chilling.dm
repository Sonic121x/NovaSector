// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/*
Chilling extracts:
	Have a unique, primarily defensive effect when
	filled with 10u plasma and activated in-hand.
*/
/obj/item/slimecross/chilling
	name = "chilling extract"
	desc = "It's cold to the touch, as if frozen solid."
	effect = "chilling"
	icon_state = "chilling"

/obj/item/slimecross/chilling/Initialize(mapload)
	. = ..()
	create_reagents(10, INJECTABLE | DRAWABLE)

/obj/item/slimecross/chilling/attack_self(mob/user)
	if(!reagents.has_reagent(/datum/reagent/toxin/plasma, 10))
		to_chat(user, span_warning(LANG("obj.883dcdd9caaf3016", null)))
		return
	reagents.remove_reagent(/datum/reagent/toxin/plasma, 10)
	to_chat(user, span_notice(LANG("obj.879f3da7868def2c", null)))
	playsound(src, 'sound/effects/bubbles/bubbles.ogg', 50, TRUE)
	playsound(src, 'sound/effects/glass/glassbr1.ogg', 50, TRUE)
	do_effect(user)

/obj/item/slimecross/chilling/proc/do_effect(mob/user) //If, for whatever reason, you don't want to delete the extract, don't do ..()
	qdel(src)
	return

/obj/item/slimecross/chilling/grey
	colour = SLIME_TYPE_GREY
	effect_desc = "Creates some slime barrier cubes. When used they create slimy barricades."

/obj/item/slimecross/chilling/grey/do_effect(mob/user)
	user.visible_message(span_notice(LANG("obj.13bcaa1903c5045b", list(src))))
	for(var/i in 1 to 3)
		new /obj/item/barriercube(get_turf(user))
	..()

/obj/item/slimecross/chilling/orange
	colour = SLIME_TYPE_ORANGE
	effect_desc = "Creates a ring of fire one tile away from the user."

/obj/item/slimecross/chilling/orange/do_effect(mob/user)
	user.visible_message(span_danger(LANG("obj.d608c2ee43d70546", list(src))))
	for(var/turf/T in orange(get_turf(user),2))
		if(get_dist(get_turf(user), T) > 1)
			new /obj/effect/hotspot(T)
	..()

/obj/item/slimecross/chilling/purple
	colour = SLIME_TYPE_PURPLE
	effect_desc = "Injects everyone in the area with some regenerative jelly."

/obj/item/slimecross/chilling/purple/do_effect(mob/user)
	var/area/user_area = get_area(user)
	if(user_area.outdoors)
		to_chat(user, span_warning(LANG("obj.7c709303b65b9d02", list(src))))
		return
	user.visible_message(span_notice(LANG("obj.7fefa3dbd5c4e4a0", list(src))))
	for (var/list/zlevel_turfs as anything in user_area.get_zlevel_turf_lists())
		for(var/turf/area_turf as anything in zlevel_turfs)
			for(var/mob/living/carbon/nearby in area_turf)
				nearby.reagents?.add_reagent(/datum/reagent/medicine/regen_jelly,10)
	..()

/obj/item/slimecross/chilling/blue
	colour = SLIME_TYPE_BLUE
	effect_desc = "Creates a rebreather, a tankless mask."

/obj/item/slimecross/chilling/blue/do_effect(mob/user)
	user.visible_message(span_notice(LANG("obj.626bb42698a55f75", list(src))))
	new /obj/item/clothing/mask/nobreath(get_turf(user))
	..()

/obj/item/slimecross/chilling/metal
	colour = SLIME_TYPE_METAL
	effect_desc = "Temporarily surrounds the user with unbreakable walls."

/obj/item/slimecross/chilling/metal/do_effect(mob/user)
	user.visible_message(span_danger(LANG("obj.788c682235ca6f63", list(src, user))))
	for(var/turf/T in orange(get_turf(user),1))
		if(get_dist(get_turf(user), T) > 0)
			new /obj/effect/forcefield/slimewall(T)
	..()

/obj/item/slimecross/chilling/yellow
	colour = SLIME_TYPE_YELLOW
	effect_desc = "Recharges the room's APC by 50%."

/obj/item/slimecross/chilling/yellow/do_effect(mob/user)
	var/area/user_area = get_area(user)
	if(isnull(user_area.apc?.cell))
		user.visible_message(span_notice(LANG("obj.a5e3b2946ece1f47", list(src))))
		return

	var/obj/machinery/power/apc/area_apc = user_area.apc
	area_apc.cell.charge = min(area_apc.cell.charge + area_apc.cell.maxcharge / 2, area_apc.cell.maxcharge)
	user.visible_message(span_notice(LANG("obj.e9b62d34f9741082", list(src))))
	..()

/obj/item/slimecross/chilling/darkpurple
	colour = SLIME_TYPE_DARK_PURPLE
	effect_desc = "Removes all plasma gas in the area."

/obj/item/slimecross/chilling/darkpurple/do_effect(mob/user)
	var/area/A = get_area(get_turf(user))
	if(A.outdoors)
		to_chat(user, span_warning(LANG("obj.7c709303b65b9d02", list(src))))
		return
	var/filtered = FALSE
	for(var/turf/open/T in A.get_turfs_from_all_zlevels())
		var/datum/gas_mixture/G = T.air
		if(istype(G))
			G.assert_gas(/datum/gas/plasma)
			G.moles[/datum/gas/plasma] = 0
			filtered = TRUE
			G.garbage_collect()
			T.air_update_turf(FALSE, FALSE)
	if(filtered)
		user.visible_message(span_notice(LANG("obj.e73bc08289116eb3", list(src))))
	else
		user.visible_message(span_notice(LANG("obj.a64856a21d073b11", list(src))))
	..()

/obj/item/slimecross/chilling/darkblue
	colour = SLIME_TYPE_DARK_BLUE
	effect_desc = "Seals the user in a protective block of ice."

/obj/item/slimecross/chilling/darkblue/do_effect(mob/user)
	if(isliving(user))
		user.visible_message(span_notice(LANG("obj.3af2dd48c6b52ca6", list(src, user))))
		var/mob/living/M = user
		M.apply_status_effect(/datum/status_effect/frozenstasis)
	..()

/obj/item/slimecross/chilling/silver
	colour = SLIME_TYPE_SILVER
	effect_desc = "Creates several ration packs."

/obj/item/slimecross/chilling/silver/do_effect(mob/user)
	user.visible_message(span_notice(LANG("obj.9c0b80edc1e83b6a", list(src))))
	var/amount = rand(5, 10)
	for(var/i in 1 to amount)
		new /obj/item/food/rationpack(get_turf(user))
	..()

/obj/item/slimecross/chilling/bluespace
	colour = SLIME_TYPE_BLUESPACE
	effect_desc = "Touching people with this extract adds them to a list, when it is activated it teleports everyone on that list to the user."
	var/list/slimepals = list()
	var/active = FALSE

/obj/item/slimecross/chilling/bluespace/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!isliving(interacting_with) || active)
		return NONE
	user.do_attack_animation(interacting_with)
	if(HAS_TRAIT(interacting_with, TRAIT_NO_TELEPORT))
		to_chat(user, span_warning(LANG("obj.34b4ecf6a54f369e", list(interacting_with, src))))
		return ITEM_INTERACT_BLOCKING
	if(interacting_with in slimepals)
		slimepals -= interacting_with
		to_chat(user, span_notice(LANG("obj.079ad7109e3dd1fb", list(src, interacting_with))))
	else
		slimepals += interacting_with
		to_chat(user, span_notice(LANG("obj.e06b0e5fb3f1d8c7", list(src, interacting_with))))
	return ITEM_INTERACT_SUCCESS

/obj/item/slimecross/chilling/bluespace/do_effect(mob/user)
	if(slimepals.len <= 0)
		to_chat(user, span_warning(LANG("obj.bb1cb86b034d0700", list(src))))
		return
	to_chat(user, span_notice(LANG("obj.8158b31e818e124a", list(src))))
	active = TRUE
	for(var/mob/living/M in slimepals)
		var/datum/status_effect/slimerecall/S = M.apply_status_effect(/datum/status_effect/slimerecall)
		S.target = user
	if(do_after(user, 10 SECONDS, target=src))
		to_chat(user, span_notice(LANG("obj.9bc2495ef3b1964b", list(src))))
		for(var/mob/living/M in slimepals)
			var/datum/status_effect/slimerecall/S = M.has_status_effect(/datum/status_effect/slimerecall)
			M.remove_status_effect(S)
	else
		to_chat(user, span_warning(LANG("obj.df82029106197762", list(src))))
		for(var/mob/living/M in slimepals)
			var/datum/status_effect/slimerecall/S = M.has_status_effect(/datum/status_effect/slimerecall)
			if(istype(S))
				S.interrupted = TRUE
				M.remove_status_effect(S)
	..()

/obj/item/slimecross/chilling/sepia
	colour = SLIME_TYPE_SEPIA
	effect_desc = "Touching someone with it adds/removes them from a list. Activating the extract stops time for 30 seconds, and everyone on the list is immune, except the user."
	var/list/slimepals = list()

/obj/item/slimecross/chilling/sepia/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!isliving(interacting_with))
		return NONE
	user.do_attack_animation(interacting_with)
	if(interacting_with in slimepals)
		slimepals -= interacting_with
		to_chat(user, span_notice(LANG("obj.079ad7109e3dd1fb", list(src, interacting_with))))
	else
		slimepals += interacting_with
		to_chat(user, span_notice(LANG("obj.e06b0e5fb3f1d8c7", list(src, interacting_with))))
	return ITEM_INTERACT_SUCCESS

/obj/item/slimecross/chilling/sepia/do_effect(mob/user)
	user.visible_message(span_warning(LANG("obj.c7e5378083d29532", list(src))))
	slimepals -= user //support class
	new /obj/effect/timestop(get_turf(user), 2, 300, slimepals)
	..()

/obj/item/slimecross/chilling/cerulean
	colour = SLIME_TYPE_CERULEAN
	effect_desc = "Creates a flimsy copy of the user, that they control."

/obj/item/slimecross/chilling/cerulean/do_effect(mob/user)
	if(isliving(user))
		user.visible_message(span_warning(LANG("obj.8a474267fad0132e", list(src, user))))
		var/mob/living/M = user
		M.apply_status_effect(/datum/status_effect/slime_clone)
	..()

/obj/item/slimecross/chilling/pyrite
	colour = SLIME_TYPE_PYRITE
	effect_desc = "Creates a pair of Prism Glasses, which allow the wearer to place colored light crystals."

/obj/item/slimecross/chilling/pyrite/do_effect(mob/user)
	user.visible_message(span_notice(LANG("obj.167f077b30279823", list(src))))
	new /obj/item/clothing/glasses/prism_glasses(get_turf(user))
	..()

/obj/item/slimecross/chilling/red
	colour = SLIME_TYPE_RED
	effect_desc = "Pacifies every slime in your vacinity."

/obj/item/slimecross/chilling/red/do_effect(mob/user)
	var/slimesfound = FALSE
	for(var/mob/living/basic/slime/slime_in_view in view(get_turf(user), 7))
		slimesfound = TRUE
		slime_in_view.set_pacified_behaviour()
	if(slimesfound)
		user.visible_message(span_notice(LANG("obj.12630198288566d9", list(src))))
	else
		user.visible_message(span_notice(LANG("obj.987b85f47fcac7b2", list(src))))
	return ..()

/obj/item/slimecross/chilling/green
	colour = SLIME_TYPE_GREEN
	effect_desc = "Creates a bone gun in the hand it is used in, which uses blood as ammo."

/obj/item/slimecross/chilling/green/do_effect(mob/user)
	var/mob/living/L = user
	if(!istype(user))
		return
	var/obj/item/held = L.get_active_held_item() //This should be itself, but just in case...
	L.dropItemToGround(held)
	var/obj/item/gun/magic/bloodchill/gun = new(user)
	if(!L.put_in_hands(gun))
		qdel(gun)
		user.visible_message(span_warning(LANG("obj.0aabe134ad064bb4", list(src, user))))
	else
		user.visible_message(span_danger(LANG("obj.fcc75c76d0c45744", list(src, user))))
	user.emote("scream")
	L.apply_damage(30, BURN, L.get_active_hand())
	..()

/obj/item/slimecross/chilling/pink
	colour = SLIME_TYPE_PINK
	effect_desc = "Creates a slime corgi puppy."

/obj/item/slimecross/chilling/pink/do_effect(mob/user)
	user.visible_message(span_notice(LANG("obj.3c0cdeff32e57f6c", list(src))))
	new /mob/living/basic/pet/dog/corgi/puppy/slime(get_turf(user))
	..()

/obj/item/slimecross/chilling/gold
	colour = SLIME_TYPE_GOLD
	effect_desc = "Produces a golden capture device"

/obj/item/slimecross/chilling/gold/do_effect(mob/user)
	user.visible_message(span_notice(LANG("obj.23c8c89219fb202b", list(src))))
	new /obj/item/capturedevice(get_turf(user))
	..()

/obj/item/slimecross/chilling/oil
	colour = SLIME_TYPE_OIL
	effect_desc = "It creates a weak, but wide-ranged explosion."

/obj/item/slimecross/chilling/oil/do_effect(mob/user)
	user.visible_message(span_danger(LANG("obj.bd7f8da8cc311973", list(src))))
	addtimer(CALLBACK(src, PROC_REF(boom)), 5 SECONDS)

/obj/item/slimecross/chilling/oil/proc/boom()
	explosion(src, devastation_range = -1, heavy_impact_range = -1, light_impact_range = 10, explosion_cause = src) //Large radius, but mostly light damage, and no flash.
	qdel(src)

/obj/item/slimecross/chilling/black
	colour = SLIME_TYPE_BLACK
	effect_desc = "Transforms the user into a golem."

/obj/item/slimecross/chilling/black/do_effect(mob/user)
	if(ishuman(user))
		user.visible_message(span_notice(LANG("obj.52967edb7629660f", list(src, user))))
		var/mob/living/carbon/human/H = user
		H.set_species(/datum/species/golem)
	..()

/obj/item/slimecross/chilling/lightpink
	colour = SLIME_TYPE_LIGHT_PINK
	effect_desc = "Creates a Heroine Bud, a special flower that pacifies whoever wears it on their head. They will not be able to take it off without help."

/obj/item/slimecross/chilling/lightpink/do_effect(mob/user)
	user.visible_message(span_notice(LANG("obj.f33f7bdc02f0e8c7", list(src))))
	new /obj/item/clothing/head/peaceflower(get_turf(user))
	..()

/obj/item/slimecross/chilling/adamantine
	colour = SLIME_TYPE_ADAMANTINE
	effect_desc = "Solidifies into a set of adamantine armor."

/obj/item/slimecross/chilling/adamantine/do_effect(mob/user)
	user.visible_message(span_notice(LANG("obj.e024577b5ab752d0", list(src))))
	new /obj/item/clothing/suit/armor/heavy/adamantine(get_turf(user))
	..()

/obj/item/slimecross/chilling/rainbow
	colour = SLIME_TYPE_RAINBOW
	effect_desc = "Makes an unpassable wall in every door in the area."

/obj/item/slimecross/chilling/rainbow/do_effect(mob/user)
	var/area/area = get_area(user)
	if(area.outdoors)
		to_chat(user, span_warning(LANG("obj.7c709303b65b9d02", list(src))))
		return
	user.visible_message(span_warning(LANG("obj.8f9ddfe3ec630264", list(src))))
	for (var/list/zlevel_turfs as anything in area.get_zlevel_turf_lists())
		for(var/turf/area_turf as anything in zlevel_turfs)
			for(var/obj/machinery/door/airlock/door in area_turf)
				new /obj/effect/forcefield/slimewall/rainbow(door.loc)
	return ..()
