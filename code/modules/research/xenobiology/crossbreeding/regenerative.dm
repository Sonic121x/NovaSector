// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/*
Regenerative extracts:
	Work like a legion regenerative core.
	Has a unique additional effect.
*/
/obj/item/slimecross/regenerative
	name = "regenerative extract"
	desc = "It's filled with a milky substance, and pulses like a heartbeat."
	effect = "regenerative"
	icon_state = "regenerative"
	effect_desc = "Completely heals your injuries, with no extra effects."

/obj/item/slimecross/regenerative/proc/core_effect(mob/living/carbon/human/target, mob/user)
	return
/obj/item/slimecross/regenerative/proc/core_effect_before(mob/living/carbon/human/target, mob/user)
	return

/obj/item/slimecross/regenerative/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!isliving(interacting_with))
		return
	var/mob/living/H = interacting_with
	if(H.stat == DEAD)
		to_chat(user, span_warning(LANG("obj.c3bb95df", list(src))))
		return ITEM_INTERACT_BLOCKING
	if(H != user)
		user.visible_message(span_notice(LANG("obj.6722e0bd", list(user, src, H, H.p_their()))),
			span_notice(LANG("obj.237b656e", list(src, H, H.p_their()))))
	else
		user.visible_message(span_notice(LANG("obj.a18018e6", list(user, src, user.p_them(), user.p_their()))),
			span_notice(LANG("obj.99657655", list(src))))
	core_effect_before(H, user)
	user.do_attack_animation(interacting_with)
	H.revive(HEAL_ALL & ~HEAL_REFRESH_ORGANS)
	core_effect(H, user)
	playsound(H, 'sound/effects/splat.ogg', 40, TRUE)
	qdel(src)
	return ITEM_INTERACT_SUCCESS

/obj/item/slimecross/regenerative/grey
	colour = SLIME_TYPE_GREY //Has no bonus effect.
	effect_desc = "Fully heals the target and does nothing else."

/obj/item/slimecross/regenerative/orange
	colour = SLIME_TYPE_ORANGE

/obj/item/slimecross/regenerative/orange/core_effect_before(mob/living/target, mob/user)
	target.visible_message(span_warning(LANG("obj.37be1be9", list(src))))
	for(var/turf/targetturf in RANGE_TURFS(1,target))
		if(!locate(/obj/effect/hotspot) in targetturf)
			new /obj/effect/hotspot(targetturf)

/obj/item/slimecross/regenerative/purple
	colour = SLIME_TYPE_PURPLE
	effect_desc = "Fully heals the target and injects them with some regen jelly."

/obj/item/slimecross/regenerative/purple/core_effect(mob/living/target, mob/user)
	target.reagents.add_reagent(/datum/reagent/medicine/regen_jelly,10)

/obj/item/slimecross/regenerative/blue
	colour = SLIME_TYPE_BLUE
	effect_desc = "Fully heals the target and makes the floor wet."

/obj/item/slimecross/regenerative/blue/core_effect(mob/living/target, mob/user)
	if(isturf(target.loc))
		var/turf/open/T = get_turf(target)
		T.MakeSlippery(TURF_WET_WATER, min_wet_time = 10, wet_time_to_add = 5)
		target.visible_message(span_warning(LANG("obj.7bf7150a", null)))

/obj/item/slimecross/regenerative/metal
	colour = SLIME_TYPE_METAL
	effect_desc = "Fully heals the target and encases the target in a locker."

/obj/item/slimecross/regenerative/metal/core_effect(mob/living/target, mob/user)
	target.visible_message(span_warning(LANG("obj.6e6a8607", list(target))))
	var/obj/structure/closet/C = new /obj/structure/closet(target.loc)
	C.name = "slimy closet"
	C.desc = "Looking closer, it seems to be made of a sort of solid, opaque, metal-like goo."
	if(target.mob_size > C.max_mob_size) //Prevents capturing megafauna or other large mobs in the closets
		C.bust_open()
		C.visible_message(span_warning(LANG("obj.c375817f", list(target, C.name))))
	else //This can't be allowed to actually happen to the too-big mobs or it breaks some actions
		target.forceMove(C)

/obj/item/slimecross/regenerative/yellow
	colour = SLIME_TYPE_YELLOW
	effect_desc = "Fully heals the target and fully recharges a single item on the target."

/obj/item/slimecross/regenerative/yellow/core_effect(mob/living/target, mob/user)
	var/list/batteries = list()
	for(var/obj/item/stock_parts/power_store/cell in assoc_to_values(target.get_all_cells()))
		if(cell.charge < cell.maxcharge)
			batteries += cell
	if(batteries.len)
		var/obj/item/stock_parts/power_store/ToCharge = pick(batteries)
		ToCharge.charge = ToCharge.maxcharge
		to_chat(target, span_notice(LANG("obj.2a57b276", null)))

/obj/item/slimecross/regenerative/darkpurple
	colour = SLIME_TYPE_DARK_PURPLE
	effect_desc = "Fully heals the target and gives them purple clothing if they are naked."

/obj/item/slimecross/regenerative/darkpurple/core_effect(mob/living/target, mob/user)
	var/equipped = 0
	equipped += target.equip_to_slot_or_del(new /obj/item/clothing/shoes/sneakers/purple(null), ITEM_SLOT_FEET)
	equipped += target.equip_to_slot_or_del(new /obj/item/clothing/under/color/lightpurple(null), ITEM_SLOT_ICLOTHING)
	equipped += target.equip_to_slot_or_del(new /obj/item/clothing/gloves/color/purple(null), ITEM_SLOT_GLOVES)
	equipped += target.equip_to_slot_or_del(new /obj/item/clothing/head/soft/purple(null), ITEM_SLOT_HEAD)
	if(equipped > 0)
		target.visible_message(span_notice(LANG("obj.818fba9b", null)))

/obj/item/slimecross/regenerative/darkblue
	colour = SLIME_TYPE_DARK_BLUE
	effect_desc = "Fully heals the target and fireproofs their clothes."

/obj/item/slimecross/regenerative/darkblue/core_effect(mob/living/target, mob/user)
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/H = target
	var/fireproofed = FALSE
	if(H.get_item_by_slot(ITEM_SLOT_OCLOTHING))
		fireproofed = TRUE
		var/obj/item/clothing/C = H.get_item_by_slot(ITEM_SLOT_OCLOTHING)
		fireproof(C)
	if(H.get_item_by_slot(ITEM_SLOT_HEAD))
		fireproofed = TRUE
		var/obj/item/clothing/C = H.get_item_by_slot(ITEM_SLOT_HEAD)
		fireproof(C)
	if(fireproofed)
		target.visible_message(span_notice(LANG("obj.7ff32aa4", list(target))))

/obj/item/slimecross/regenerative/darkblue/proc/fireproof(obj/item/clothing/clothing_piece)
	clothing_piece.name = "fireproofed [clothing_piece.name]"
	clothing_piece.remove_atom_colour(WASHABLE_COLOUR_PRIORITY)
	clothing_piece.add_atom_colour(color_transition_filter(COLOR_NAVY, SATURATION_OVERRIDE), FIXED_COLOUR_PRIORITY)
	clothing_piece.max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	clothing_piece.heat_protection = clothing_piece.body_parts_covered
	clothing_piece.resistance_flags |= FIRE_PROOF

/obj/item/slimecross/regenerative/silver
	colour = SLIME_TYPE_SILVER
	effect_desc = "Fully heals the target and makes their belly feel round and full."

/obj/item/slimecross/regenerative/silver/core_effect(mob/living/target, mob/user)
	target.set_nutrition(NUTRITION_LEVEL_FULL - 1)
	to_chat(target, span_notice(LANG("obj.d8359be5", null)))

/obj/item/slimecross/regenerative/bluespace
	colour = SLIME_TYPE_BLUESPACE
	effect_desc = "Fully heals the target and teleports them to where this core was created."
	var/turf/open/T

/obj/item/slimecross/regenerative/bluespace/core_effect(mob/living/target, mob/user)
	var/turf/old_location = get_turf(target)
	if(do_teleport(target, T, channel = TELEPORT_CHANNEL_QUANTUM)) //despite being named a bluespace teleportation method the quantum channel is used to preserve precision teleporting with a bag of holding
		old_location.visible_message(span_warning(LANG("obj.c3b6f23a", list(target))))
		to_chat(target, span_danger(LANG("obj.b0ea622a", null)))

	if(HAS_TRAIT(target, TRAIT_NO_TELEPORT))
		old_location.visible_message(span_warning(LANG("obj.4699fa74", list(target))))

/obj/item/slimecross/regenerative/bluespace/Initialize(mapload)
	. = ..()
	T = get_turf(src)

/obj/item/slimecross/regenerative/sepia
	colour = SLIME_TYPE_SEPIA
	effect_desc = "Fully heals the target. After 10 seconds, relocate the target to the initial position the core was used with their previous health status."

/obj/item/slimecross/regenerative/sepia/core_effect_before(mob/living/target, mob/user)
	to_chat(target, span_notice(LANG("obj.5f0f8138", null)))
	target.AddComponent(/datum/component/dejavu)

/obj/item/slimecross/regenerative/cerulean
	colour = SLIME_TYPE_CERULEAN
	effect_desc = "Fully heals the target and makes a second regenerative core with no special effects."

/obj/item/slimecross/regenerative/cerulean/core_effect(mob/living/target, mob/user)
	src.forceMove(user.loc)
	var/obj/item/slimecross/X = new /obj/item/slimecross/regenerative(user.loc)
	X.name = name
	X.desc = desc
	user.put_in_active_hand(X)
	to_chat(user, span_notice(LANG("obj.a4ab9ad7", null)))

/obj/item/slimecross/regenerative/pyrite
	colour = SLIME_TYPE_PYRITE
	effect_desc = "Fully heals and randomly colors the target."

/obj/item/slimecross/regenerative/pyrite/core_effect(mob/living/target, mob/user)
	target.visible_message(span_warning(LANG("obj.69ab02d8", list(target, target.p_them()))))
	target.add_atom_colour(color_transition_filter(rgb(rand(0,255), rand(0,255), rand(0,255)), SATURATION_OVERRIDE), WASHABLE_COLOUR_PRIORITY)

/obj/item/slimecross/regenerative/red
	colour = SLIME_TYPE_RED
	effect_desc = "Fully heals the target and injects them with some ephedrine."

/obj/item/slimecross/regenerative/red/core_effect(mob/living/target, mob/user)
	to_chat(target, span_notice(LANG("obj.5d137fd8", null)))
	target.reagents.add_reagent(/datum/reagent/medicine/ephedrine,3)

/obj/item/slimecross/regenerative/green
	colour = SLIME_TYPE_GREEN
	effect_desc = "Fully heals the target and changes the species or color of a slime or jellyperson."

/obj/item/slimecross/regenerative/green/core_effect(mob/living/target, mob/user)
	if(isslime(target))
		target.visible_message(span_warning(LANG("obj.15949140", list(target))))
		var/mob/living/basic/slime/target_slime = target
		target_slime.set_slime_type()
	if(target.mob_biotypes & MOB_SLIME)
		target.reagents.add_reagent(/datum/reagent/mutationtoxin/jelly,5)

/obj/item/slimecross/regenerative/pink
	colour = SLIME_TYPE_PINK
	effect_desc = "Fully heals the target and injects them with some krokodil."

/obj/item/slimecross/regenerative/pink/core_effect(mob/living/target, mob/user)
	to_chat(target, span_notice(LANG("obj.562fa2d7", null)))
	target.reagents.add_reagent(/datum/reagent/drug/krokodil,4)

/obj/item/slimecross/regenerative/gold
	colour = SLIME_TYPE_GOLD
	effect_desc = "Fully heals the target and produces a random coin."

/obj/item/slimecross/regenerative/gold/core_effect(mob/living/target, mob/user)
	var/newcoin = get_random_coin()
	var/obj/item/coin/C = new newcoin(target.loc)
	playsound(C, 'sound/items/coinflip.ogg', 50, TRUE)
	target.put_in_hand(C)

/obj/item/slimecross/regenerative/oil
	colour = SLIME_TYPE_OIL
	effect_desc = "Fully heals the target and flashes everyone in sight."

/obj/item/slimecross/regenerative/oil/core_effect(mob/living/target, mob/user)
	playsound(src, 'sound/items/weapons/flash.ogg', 100, TRUE)
	for(var/mob/living/L in view(user,7))
		L.flash_act()

/obj/item/slimecross/regenerative/black
	colour = SLIME_TYPE_BLACK
	effect_desc = "Fully heals the target and creates an imperfect duplicate of them made of slime, that fakes their death."

/obj/item/slimecross/regenerative/black/core_effect_before(mob/living/target, mob/user)
	var/dummytype = target.type
	if(target.mob_biotypes & MOB_SPECIAL) //Prevents megafauna and voidwalker duping in a lame way
		dummytype = /mob/living/basic/slime
		to_chat(user, span_warning(LANG("obj.e62336e8", list(target))))
	var/mob/living/dummy = new dummytype(target.loc)
	to_chat(target, span_notice(LANG("obj.015c60b5", null)))
	if(iscarbon(target) && iscarbon(dummy))
		var/mob/living/carbon/carbon_target = target
		var/mob/living/carbon/carbon_dummy = dummy
		carbon_dummy.real_name = carbon_target.real_name
		carbon_target.dna.copy_dna(carbon_dummy.dna, COPY_DNA_SE|COPY_DNA_SPECIES)
		carbon_dummy.updateappearance(mutcolor_update = TRUE)
	dummy.adjust_brute_loss(target.get_brute_loss())
	dummy.adjust_fire_loss(target.get_fire_loss())
	dummy.adjust_tox_loss(target.get_tox_loss())
	dummy.death()

/obj/item/slimecross/regenerative/lightpink
	colour = SLIME_TYPE_LIGHT_PINK
	effect_desc = "Fully heals the target and also heals the user."

/obj/item/slimecross/regenerative/lightpink/core_effect(mob/living/target, mob/user)
	if(!isliving(user))
		return
	if(target == user)
		return
	var/mob/living/U = user
	U.revive(HEAL_ALL & ~HEAL_REFRESH_ORGANS)
	to_chat(U, span_notice(LANG("obj.34af3312", null)))

/obj/item/slimecross/regenerative/adamantine
	colour = SLIME_TYPE_ADAMANTINE
	effect_desc = "Fully heals the target and boosts their armor."

/obj/item/slimecross/regenerative/adamantine/core_effect(mob/living/target, mob/user) //WIP - Find out why this doesn't work.
	target.apply_status_effect(/datum/status_effect/slimeskin)

/obj/item/slimecross/regenerative/rainbow
	colour = SLIME_TYPE_RAINBOW
	effect_desc = "Fully heals the target and temporarily makes them immortal, but pacifistic."

/obj/item/slimecross/regenerative/rainbow/core_effect(mob/living/target, mob/user)
	target.apply_status_effect(/datum/status_effect/rainbow_protection)
