/*Vorpal Scythe, or the implant null rod that isn't as strong as other null rods up until you use it to behead someone with the special death knell attack.
If the scythe isn't empowered when you sheath it, you take a heap of damage and probably a wound!*/

#define SCYTHE_WEAK 0
#define SCYTHE_SATED 1
#define SCYTHE_EMPOWERED 2

/obj/item/organ/cyberimp/arm/toolkit/shard/scythe
	name = "不祥碎片"
	desc = "这块碎片似乎与某个不祥的存在直接相连。它可能就是你的神！而且当你握住它太久时，它还会让你起非常可怕的皮疹。"
	items_to_create = list(/obj/item/vorpalscythe)
	organ_traits = list(TRAIT_MORBID)

/obj/item/organ/cyberimp/arm/toolkit/shard/scythe/Initialize(mapload)
	. = ..()
	for (var/obj/item/scythe as anything in items_list)
		ADD_TRAIT(scythe, TRAIT_NULLROD_ITEM, INNATE_TRAIT)

/obj/item/organ/cyberimp/arm/toolkit/shard/scythe/Retract()
	var/obj/item/vorpalscythe/scythe = active_item
	if(!scythe)
		return FALSE
	if(scythe.empowerment >= SCYTHE_SATED)
		return ..()

	to_chat(owner, span_userdanger("[scythe] 因你傲慢的不配之举而撕裂了你！"))
	playsound(owner, 'sound/effects/magic/demon_attack1.ogg', 50, TRUE)
	owner.apply_damage(25, BRUTE, hand, wound_bonus = 10, sharpness = SHARP_EDGED)
	return ..()

/obj/item/vorpalscythe
	name = "斩首镰刀"
	desc = "种瓜得瓜，种豆得豆。"
	icon = 'icons/obj/weapons/staff.dmi'
	icon_state = "vorpalscythe"
	inhand_icon_state = "vorpalscythe"
	worn_icon_state = null
	icon_angle = -35 // Scythes look better when slightly angled
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	w_class = WEIGHT_CLASS_GIGANTIC
	force = 10 //a lot worse than most nullrods initially. Why did you invest so much into making it vorpal, you dork.
	armour_penetration = 50 //Very good armor penetration to make up for our abysmal force
	reach = 2 //why yes, this does have reach
	slot_flags = null
	obj_flags = UNIQUE_RENAME
	sharpness = SHARP_EDGED
	attack_verb_continuous = list("chops", "slices", "cuts", "reaps")
	attack_verb_simple = list("chop", "slice", "cut", "reap")
	wound_bonus = 10
	exposed_wound_bonus = 15
	/*What state is our scythe in?

	If it is SCYTHE_WEAK, it will harm our reaper on being sheathed.

	if it is SCYTHE_SATED, it will be able to sheath for 4 minutes. Gained from hitting a mob or performing the death knell on mindless humans.

	If it is SCYTHE_EMPOWERED, we've performed the death knell on a human with a mind. Lets you sheath for 2 minutes and grants additional force.*/
	var/empowerment = SCYTHE_WEAK
	///Our bonus to force after we have death knelled. Lasts approximately 2 minutes.
	var/bonus_force_multiplier = 2

/obj/item/vorpalscythe/examine(mob/user)
	. = ..()
	. += span_notice("你可以对一名人类使用右键点击 [src] 来执行死亡丧钟。如果目标曾具有意识（无论是当前还是过去某个时刻），成功执行死亡丧钟将使 [src] 获得强化。")
	. += span_notice("[src] 似乎有相当远的攻击距离。你或许能从更远的地方击中目标。")

	var/current_empowerment = empowerment
	switch(current_empowerment)
		if(SCYTHE_EMPOWERED)
			. += span_notice("[src] 已被强化，正嗡嗡作响充满能量。")
		if(SCYTHE_SATED)
			. += span_notice("[src] 已满足，但仍渴求更多。执行死亡丧钟吧！")
		else
			. += span_notice("[src] 静止不动。它在等待挥击。最好不要因剥夺它品尝鲜血的机会而激怒它。")

/obj/item/vorpalscythe/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/nullrod_core, chaplain_spawnable = FALSE, rune_remove_line = "TO DUST WITH YE!! AWAY!!") // The implant is the actual item the chappie can select
	AddComponent(/datum/component/bane, affected_biotypes = MOB_PLANT, damage_multiplier = 1.5) //also good at killing plants
	AddComponent(/datum/component/butchering, speed = 3 SECONDS, effectiveness = 125)
	AddComponent(/datum/component/walking_aid)

/obj/item/vorpalscythe/attack(mob/living/target, mob/living/user, list/modifiers, list/attack_modifiers)
	if(ismonkey(target) && !target.mind) //Don't empower from hitting monkeys. Hit a corgi or something, I don't know.
		return ..()

	if(target.stat < DEAD && target != user)
		scythe_empowerment(SCYTHE_SATED)

	return ..()

/obj/item/vorpalscythe/pre_attack(atom/target, mob/living/user, list/modifiers, list/attack_modifiers)
	if(empowerment == SCYTHE_EMPOWERED)
		MODIFY_ATTACK_FORCE_MULTIPLIER(attack_modifiers, bonus_force_multiplier)

	return ..()

//Borrows some amputation shear code, but much more specific
/obj/item/vorpalscythe/attack_secondary(mob/living/victim, mob/living/user, params)
	if(!iscarbon(victim) || user.combat_mode)
		return SECONDARY_ATTACK_CALL_NORMAL

	if(user.zone_selected != BODY_ZONE_HEAD)
		return SECONDARY_ATTACK_CALL_NORMAL

	var/mob/living/carbon/potential_reaping = victim

	if(HAS_TRAIT(potential_reaping, TRAIT_NODISMEMBER))
		to_chat(user, span_warning("你认为你无法斩首这个生物..."))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	var/head_name
	var/obj/item/bodypart/head/reaped_head

	reaped_head = potential_reaping.get_bodypart(check_zone(user.zone_selected))
	if(!reaped_head)
		to_chat(user, span_warning("没有头颅可供收割。"))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	head_name = reaped_head.name

	//We're tracking this separately from empowerment so that we can use it to determine whether or not we haunt the heads we cut off.
	var/potential_empowerment = SCYTHE_EMPOWERED

	if(!potential_reaping.mind) //We put this here juuuust in case there is something funky with ling checks
		if(ismonkey(potential_reaping))
			to_chat(user, span_warning("毫无意义的存在。这次死亡丧钟除了斩首这个肮脏东西带来的满足感外，你得不到任何好处。"))
			potential_empowerment = SCYTHE_WEAK
		else
			to_chat(user, span_warning("这个灵魂几乎不存在。但 [src] 仍能从这次献祭中获得一些东西。一个傀儡。"))
			potential_empowerment = SCYTHE_SATED

	var/death_knell_speed_mod = 1

	potential_reaping.visible_message(span_danger("[user] 开始将 [src] 高举过 [potential_reaping] 的 [head_name]。"), span_userdanger("[user] 开始举起 [src]，意图削掉你的 [head_name]！"))
	if(potential_reaping.stat >= UNCONSCIOUS || HAS_TRAIT(potential_reaping, TRAIT_INCAPACITATED)) //if the victim is incapacitated (due to paralysis, a stun, being in staminacrit, etc.), critted, unconscious, or dead, it's much easier to properly behead
		death_knell_speed_mod *= 0.5
	if(potential_reaping.stat != DEAD && potential_reaping.has_status_effect(/datum/status_effect/jitter)) //jittering will make it harder to perform the death knell, even if they're still
		death_knell_speed_mod *= 1.5 //Staminacritting someone who's jittering (from, say, a stun baton) won't give you enough time to slice their head off, but staminacritting someone who isn't jittering will
	if(empowerment == SCYTHE_EMPOWERED) //That said, if heads are already rolling, why stop here?
		death_knell_speed_mod *= 0.5
	if(ispodperson(potential_reaping) || ismonkey(potential_reaping)) //And if they're a podperson or monkey, they can just die.
		death_knell_speed_mod *= 0.5

	log_combat(user, potential_reaping, "prepared to use [src] to decapitate")

	if(do_after(user,  15 SECONDS * death_knell_speed_mod, target = potential_reaping))
		playsound(get_turf(potential_reaping), 'sound/items/weapons/bladeslice.ogg', 250, TRUE)
		reaped_head.dismember()
		user.visible_message(span_danger("[user] 挥下 [src]，干净利落地削掉了 [potential_reaping] 的 [head_name]！你觉得 [src] 可能变强了！"), span_notice("当你对 [potential_reaping] 执行死亡丧钟时，[src] 获得了力量！持续一段时间..."))
		if(potential_empowerment == SCYTHE_SATED) //We don't want actual player heads to go wandering off, but it'll be funny if a bunch of monkeyhuman heads started floating around
			reaped_head.AddComponent(/datum/component/haunted_item, \
				haunt_color = "#7be595", \
				haunt_duration = 1 MINUTES, \
				aggro_radius = null, \
				spawn_message = span_revenwarning("[reaped_head] 颤抖着，在一圈淡绿色的光晕中升到空中！"), \
				despawn_message = span_revenwarning("[reaped_head] 落回地面，再次静止不动。"), \
				throw_force_bonus = 0, \
				throw_force_max = 0, \
			)

		scythe_empowerment(potential_empowerment)
		log_combat(user, potential_reaping, "used [src] to decapitate")

		if(HAS_MIND_TRAIT(user, TRAIT_MORBID)) //You feel good about yourself, pal?
			user.add_mood_event("morbid_dismemberment", /datum/mood_event/morbid_dismemberment)

	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/vorpalscythe/proc/scythe_empowerment(potential_empowerment = SCYTHE_WEAK)
	//Determines if we are entitled to setting/resetting our timer.
	//Only reset SCYTHE_EMPOWERED with an empowerment that would grant that.
	//Only reset SCTHE_SATED if hitting at least simple mobs or nonmonkey carbons.
	var/allow_timer_set = FALSE

	if(empowerment < potential_empowerment || empowerment == potential_empowerment) //Reset the timer only if our potential empowerment is equivalent or stronger than our current empowerment
		allow_timer_set = TRUE
	empowerment = potential_empowerment
	if(potential_empowerment != SCYTHE_WEAK && allow_timer_set) //And finally, if the empowerment was improved and wasn't too weak to get an empowerment, we set/reset our timer
		addtimer(CALLBACK(src, PROC_REF(scythe_empowerment_end)), (4 MINUTES / empowerment), TIMER_UNIQUE | TIMER_OVERRIDE)

/obj/item/vorpalscythe/proc/scythe_empowerment_end()
	empowerment = SCYTHE_WEAK

#undef SCYTHE_WEAK
#undef SCYTHE_SATED
#undef SCYTHE_EMPOWERED
