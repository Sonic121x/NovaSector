//Alium nests. Essentially beds with an unbuckle delay that only aliums can buckle mobs to.

/obj/structure/bed/nest
	name = "外星人巢穴"
	desc = "这是一堆可怕的厚厚的粘性树脂，形状像一个巢。"
	icon = 'icons/obj/smooth_structures/alien/nest.dmi'
	icon_state = "nest-0"
	base_icon_state = "nest"
	max_integrity = 120
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_ALIEN_NEST
	canSmoothWith = SMOOTH_GROUP_ALIEN_NEST
	build_stack_type = null
	elevation = 0
	can_deconstruct = FALSE
	var/static/mutable_appearance/nest_overlay = mutable_appearance('icons/mob/nonhuman-player/alien.dmi', "nestoverlay", LYING_MOB_LAYER)

/obj/structure/bed/nest/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_DANGEROUS_BUCKLE, INNATE_TRAIT)

/obj/structure/bed/nest/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	if(held_item?.tool_behaviour == TOOL_WRENCH)
		return NONE

	return ..()

/obj/structure/bed/nest/buckle_feedback(mob/living/being_buckled, mob/buckler)
	if(being_buckled == buckler)
		being_buckled.visible_message(
			span_notice("[buckler] 躺在 [src] 上，用一层厚实粘稠的树脂将 [buckler.p_them()] 自己包裹起来。"),
			span_notice("你躺在 [src] 上，用一层厚实粘稠的树脂将自己包裹起来。"),
			visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
		)
	else
		being_buckled.visible_message(
			span_notice("[buckler] 将 [being_buckled] 放在 [src] 上躺下，用一层厚实粘稠的树脂将 [being_buckled.p_them()] 包裹起来。"),
			span_notice("[buckler] 将你放在 [src] 上躺下，用一层厚实粘稠的树脂将你包裹起来。"),
			visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
		)

/obj/structure/bed/nest/unbuckle_feedback(mob/living/being_unbuckled, mob/unbuckler)
	if(being_unbuckled == unbuckler)
		being_unbuckled.visible_message(
			span_notice("[unbuckler] pulls [unbuckler.p_them()]self free from the sticky nest!"),
			span_notice("你从粘稠的巢穴中挣脱了出来！"),
			visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
		)
	else
		being_unbuckled.visible_message(
			span_notice("[unbuckler] 将 [being_unbuckled] 从粘稠的巢穴中拉了出来！"),
			span_notice("[unbuckler] 将你从粘稠的巢穴中拉了出来！"),
			visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
		)

/obj/structure/bed/nest/user_unbuckle_mob(mob/living/captive, mob/living/hero)
	if(!length(buckled_mobs))
		return

	if(hero.get_organ_by_type(/obj/item/organ/alien/plasmavessel))
		unbuckle_mob(captive)
		add_fingerprint(hero)
		return

	if(captive != hero)
		captive.visible_message(span_notice("[hero.name] 将 [captive.name] 从粘稠的巢穴中拉了出来！"),
			span_notice("[hero.name] 将你从凝胶状的树脂中拉了出来。"),
			span_hear("你听到噗叽噗叽的声音..."))
		unbuckle_mob(captive)
		add_fingerprint(hero)
		return

	captive.visible_message(span_warning("[captive.name] 挣扎着试图从凝胶状的树脂中挣脱出来！"),
		span_notice("你挣扎着试图从凝胶状的树脂中挣脱出来...（保持不动大约一分半钟。）"),
		span_hear("你听到噗叽噗叽的声音..."))

	if(!do_after(captive, 100 SECONDS, target = src, hidden = TRUE))
		if(captive.buckled)
			to_chat(captive, span_warning("你没能挣脱出来！"))
		return

	captive.visible_message(span_warning("[captive.name] 从凝胶状的树脂中挣脱了出来！"),
		span_notice("你从凝胶状的树脂中挣脱了出来！"),
		span_hear("你听到噗叽噗叽的声音..."))

	unbuckle_mob(captive)
	add_fingerprint(hero)

/obj/structure/bed/nest/user_buckle_mob(mob/living/M, mob/user, check_loc = TRUE)
	if ( !ismob(M) || (get_dist(src, user) > 1) || (M.loc != src.loc) || user.incapacitated || M.buckled )
		return

	if(M.get_organ_by_type(/obj/item/organ/alien/plasmavessel))
		return
	if(!user.get_organ_by_type(/obj/item/organ/alien/plasmavessel))
		return

	if(has_buckled_mobs())
		unbuckle_all_mobs()

	if(buckle_mob(M))
		M.visible_message(span_notice("[user.name]分泌出一团浓稠恶心的黏液，将[M.name]牢牢固定在[src]里！"),\
			span_danger("[user.name]用一股恶臭的树脂浸透了你，将你困在[src]里！"),\
			span_hear("你听到一阵黏糊糊的声音..."))

/obj/structure/bed/nest/post_buckle_mob(mob/living/M)
	ADD_TRAIT(M, TRAIT_HANDS_BLOCKED, type)
	M.add_offsets(type, x_add = 2)
	M.layer = BELOW_MOB_LAYER
	add_overlay(nest_overlay)

	if(ishuman(M))
		var/mob/living/carbon/human/victim = M
		if(((victim.wear_mask && istype(victim.wear_mask, /obj/item/clothing/mask/facehugger)) || HAS_TRAIT(victim, TRAIT_XENO_HOST)) && victim.stat != DEAD) //If they're a host or have a facehugger currently infecting them. Must be alive.
			victim.apply_status_effect(/datum/status_effect/nest_sustenance)

/obj/structure/bed/nest/post_unbuckle_mob(mob/living/M)
	REMOVE_TRAIT(M, TRAIT_HANDS_BLOCKED, type)
	M.remove_offsets(type)
	M.layer = initial(M.layer)
	cut_overlay(nest_overlay)
	M.remove_status_effect(/datum/status_effect/nest_sustenance)

/obj/structure/bed/nest/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			playsound(loc, 'sound/effects/blob/attackblob.ogg', 100, TRUE)
		if(BURN)
			playsound(loc, 'sound/items/tools/welder.ogg', 100, TRUE)

/obj/structure/bed/nest/attack_alien(mob/living/carbon/alien/user, list/modifiers)
	if(!user.combat_mode)
		return attack_hand(user, modifiers)
	else
		return ..()
