/datum/species/lizard/ashwalker
	mutanteyes = /obj/item/organ/eyes/night_vision/ashwalker
	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/lizard/ashwalker,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/lizard/ashwalker,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/lizard/ashwalker,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/lizard/ashwalker,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/lizard/ashwalker,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/lizard/ashwalker,
	)

/datum/species/lizard/ashwalker/on_species_gain(mob/living/carbon/carbon_target, datum/species/old_species, pref_load, regenerate_icons)
	. = ..()
	ADD_TRAIT(carbon_target, TRAIT_ASHSTORM_IMMUNE, SPECIES_TRAIT)
	RegisterSignal(carbon_target, COMSIG_MOB_ITEM_ATTACK, PROC_REF(mob_attack))
	carbon_target.AddComponent(/datum/component/ash_age)
	carbon_target.apply_status_effect(/datum/status_effect/ash_age)
	carbon_target.add_faction(FACTION_ASHWALKER)

/datum/species/lizard/ashwalker/on_species_loss(mob/living/carbon/carbon_target)
	. = ..()
	REMOVE_TRAIT(carbon_target, TRAIT_ASHSTORM_IMMUNE, SPECIES_TRAIT)
	UnregisterSignal(carbon_target, COMSIG_MOB_ITEM_ATTACK)
	carbon_target.remove_faction(FACTION_ASHWALKER)

/datum/species/lizard/ashwalker/proc/mob_attack(datum/source, mob/mob_target, mob/user)
	SIGNAL_HANDLER

	if(!isliving(mob_target))
		return

	var/mob/living/living_target = mob_target
	var/datum/status_effect/ashwalker_damage/ashie_damage = living_target.has_status_effect(/datum/status_effect/ashwalker_damage)
	if(!ashie_damage)
		ashie_damage = living_target.apply_status_effect(/datum/status_effect/ashwalker_damage)

	ashie_damage.register_mob_damage(living_target)

/**
 * 15 minutes = armor
 * 30 minutes = base punch + boulder breaking
 * 45 minutes = hivemind
 * 60 minutes = speed
 * 75 minutes = mutated armblade
 * 90 minutes = lavaproof + firebreath
 */

/datum/component/ash_age
	/// the current stage of the ash
	var/current_stage = 0
	/// the human target the element is attached to
	var/mob/living/carbon/human/human_target

/datum/component/ash_age/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE

	// set the target for the element so we can reference in other parts
	human_target = parent
	// when the rune successfully completes the age ritual, it will send the signal... do the proc when we receive the signal
	RegisterSignal(human_target, COMSIG_RUNE_EVOLUTION, PROC_REF(check_evolution))
	RegisterSignal(human_target, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))

/// Age Ritual handler
/datum/component/ash_age/proc/check_evolution()
	SIGNAL_HANDLER
	// if the world time hasn't yet passed the time required for evolution
	if(human_target.has_status_effect(/datum/status_effect/ash_age))
		to_chat(human_target, span_warning("需要更多时间来进化——每次进化之间需要十五分钟..."))
		return

	// since it was time, go up a stage and now we check what to add
	current_stage++
	human_target.apply_status_effect(/datum/status_effect/ash_age)
	var/datum/species/species_target = human_target.dna.species
	switch(current_stage)
		if(1)
			species_target.damage_modifier += 10
			to_chat(human_target, span_notice("你的身体似乎更结实了..."))

		if(2)
			var/obj/item/bodypart/arm/left/left_arm = human_target.get_bodypart(BODY_ZONE_L_ARM)
			if(left_arm)
				left_arm.unarmed_damage_low += 5
				left_arm.unarmed_damage_high += 5

			var/obj/item/bodypart/arm/right/right_arm = human_target.get_bodypart(BODY_ZONE_R_ARM)
			if(right_arm)
				right_arm.unarmed_damage_low += 5
				right_arm.unarmed_damage_high += 5

			ADD_TRAIT(human_target, TRAIT_BOULDER_BREAKER, REF(src))
			to_chat(human_target, span_notice("你的手臂似乎更致密、更强壮了..."))

		if(3)
			var/datum/action/ashen_actions/hivemind_speak/grant_hivemind = new /datum/action/ashen_actions/hivemind_speak(human_target)
			grant_hivemind.Grant(human_target)

		if(4)
			human_target.add_movespeed_modifier(/datum/movespeed_modifier/ash_aged)
			to_chat(human_target, span_notice("你的身体似乎更轻盈了..."))

		if(5)
			var/obj/item/organ/ashen_armblade/summoned_organ = new /obj/item/organ/ashen_armblade()
			summoned_organ.Insert(human_target)
			to_chat(human_target, span_notice("你的手臂因激动而颤抖..."))

		if(6)
			ADD_TRAIT(human_target, TRAIT_LAVA_IMMUNE, REF(src))
			var/datum/action/cooldown/mob_cooldown/fire_breath/granted_action
			granted_action = new(human_target)
			granted_action.Grant(human_target)
			to_chat(human_target, span_notice("你的身体感觉更热了..."))

		if(7 to INFINITY)
			to_chat(human_target, span_warning("你已经达到了当前身体的巅峰！"))

/// Speed mod
/datum/movespeed_modifier/ash_aged
	multiplicative_slowdown = -0.2

/// Examines
/datum/component/ash_age/proc/on_examine(atom/target_atom, mob/user, list/examine_list)
	SIGNAL_HANDLER
	if(human_target.has_status_effect(/datum/status_effect/ash_age))
		examine_list += span_notice("[human_target]尚未达到进化的年龄。")
		return
	examine_list += span_warning("[human_target]已经达到进化的年龄了！")

/datum/status_effect/ash_age
	id = "ash_age"
	duration = 15 MINUTES
	show_duration = TRUE
	alert_type = /atom/movable/screen/alert/status_effect/ash_age

/atom/movable/screen/alert/status_effect/ash_age
	name = "灰烬年龄疲劳"
	desc = "你的身体最近经历了一些变化，需要更多时间才能进一步改变。"
	icon = 'modular_nova/modules/ashwalkers/icons/screen_alert.dmi'
	icon_state = "ash_age"

/obj/item/organ/ashen_armblade
	name = "灰烬触手"
	desc = "这个器官蠕动着，四处触碰寻找着什么。"
	zone = BODY_ZONE_CHEST

	/// The summoned armblade
	var/obj/item/melee/ashen_blade/summoned_armblade

	/// The armblade action given to the owner so they can summon and unsummon the armblade
	var/datum/action/ashen_actions/summon_ashblade/granted_action

/obj/item/organ/ashen_armblade/Initialize(mapload)
	. = ..()
	summoned_armblade = new /obj/item/melee/ashen_blade(src)

/obj/item/organ/ashen_armblade/Destroy()
	QDEL_NULL(summoned_armblade)
	QDEL_NULL(granted_action)
	return ..()

/obj/item/organ/ashen_armblade/on_mob_insert(mob/living/carbon/organ_owner, special, movement_flags)
	. = ..()
	granted_action = new()
	granted_action.Grant(organ_owner)
	granted_action.connected_organ = src

/obj/item/organ/ashen_armblade/on_mob_remove(mob/living/carbon/organ_owner, special, movement_flags)
	. = ..()
	granted_action.connected_organ = null
	granted_action.Remove(organ_owner)
	if(!locate(summoned_armblade) in src) //if the armblade isnt in the organ when it is removed, move the armblade back into the organ
		summoned_armblade.forceMove(src)

/datum/action/ashen_actions
	button_icon = 'modular_nova/modules/ashwalkers/icons/actions.dmi'
	background_icon_state = "bg_demon"
	overlay_icon_state = "bg_demon_border"

/datum/action/ashen_actions/summon_ashblade
	name = "灰烬臂刃"
	button_icon_state = "armblade"

	/// the organ that is connected to this action
	var/obj/item/organ/ashen_armblade/connected_organ

/datum/action/ashen_actions/summon_ashblade/Trigger(trigger_flags)
	. = ..()
	if(!.)
		return

	if(locate(connected_organ.summoned_armblade) in connected_organ)
		owner.put_in_active_hand(connected_organ.summoned_armblade)
		owner.visible_message(span_warning("一把怪异的刀刃在[owner]的手臂周围形成！"), span_warning("我们的手臂扭曲变异，将其变成了一把致命的刀刃。"), span_hear("你听到有机物质被撕裂的声音！"))
		playsound(get_turf(owner), 'sound/effects/blob/blobattack.ogg', 30, TRUE)

	else
		connected_organ.summoned_armblade.forceMove(connected_organ)
		owner.visible_message(span_warning("伴随着令人作呕的碎裂声，[owner]将[owner.p_their()]的[connected_organ.summoned_armblade]重塑成了一只手臂！"), span_notice("我们将[connected_organ.summoned_armblade]重新吸收回体内。"), span_italics("你听到有机物质被撕裂的声音！"))
		playsound(get_turf(owner), 'sound/effects/blob/blobattack.ogg', 30, TRUE)

/obj/item/melee/ashen_blade
	name = "灰烬臂刃"
	desc = "一把由骨头和血肉构成的怪异刀刃，切开人体如同热刀切黄油。"
	icon = 'icons/obj/weapons/changeling_items.dmi'
	icon_state = "arm_blade"
	inhand_icon_state = "arm_blade"
	icon_angle = 180
	lefthand_file = 'icons/mob/inhands/antag/changeling_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/antag/changeling_righthand.dmi'
	item_flags = NEEDS_PERMIT | ABSTRACT
	w_class = WEIGHT_CLASS_HUGE
	force = 5
	throwforce = 0 //Just to be on the safe side
	throw_range = 0
	throw_speed = 0
	hitsound = 'sound/items/weapons/bladeslice.ogg'
	attack_verb_continuous = list("attacks", "slashes", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("attack", "slash", "slice", "tear", "lacerate", "rip", "dice", "cut")
	sharpness = SHARP_EDGED
	wound_bonus = 0
	exposed_wound_bonus = 0
	armour_penetration = 5

	/// how many trophies we have consumed
	var/consumed_trophies = 0

	/// how many trophies we can consume
	var/max_trophies = 7

	/// the alternate continuous sharpness phrases
	var/list/alt_continuous = list("stabs", "pierces", "impales")

	/// the alternate simple sharpness phrases
	var/list/alt_simple = list("stab", "pierce", "impale")

/obj/item/melee/ashen_blade/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, REF(src))
	alt_continuous = string_list(alt_continuous)
	alt_simple = string_list(alt_simple)
	AddComponent(/datum/component/alternative_sharpness, SHARP_POINTY, alt_continuous, alt_simple, -5)
	AddComponent(/datum/component/butchering, speed = 6 SECONDS, effectiveness = 80)

/obj/item/melee/ashen_blade/afterattack(atom/target, mob/user, click_parameters)
	if(istype(target, /obj/structure/table))
		var/obj/smash = target
		smash.deconstruct(FALSE)

	else if(istype(target, /obj/machinery/computer))
		target.attack_alien(user) //muh copypasta

	else if(istype(target, /obj/machinery/door/airlock))
		var/obj/machinery/door/airlock/opening = target

		if((!opening.requiresID() || opening.allowed(user)) && opening.hasPower()) //This is to prevent stupid shit like hitting a door with an arm blade, the door opening because you have acces and still getting a "the airlocks motors resist our efforts to force it" message, power requirement is so this doesn't stop unpowered doors from being pried open if you have access
			return
		if(opening.locked)
			opening.balloon_alert(user, "已上锁！")
			return

		if(opening.hasPower())
			user.visible_message(span_warning("[user]将[src]卡进气闸门并开始撬开它！"), span_warning("我们开始强行打开[opening]。"), \
			span_hear("你听到金属刮擦的声音。"))
			playsound(opening, 'sound/machines/airlock/airlock_alien_prying.ogg', 100, TRUE)
			if(!do_after(user, 10 SECONDS, target = opening))
				return

		user.visible_message(span_warning("[user]用[user.p_their()]的[src]强行打开了气闸门！"), span_warning("我们强行打开了[opening]。"), \
		span_hear("你听到金属刮擦的声音。"))
		opening.open(BYPASS_DOOR_CHECKS)

/obj/item/melee/ashen_blade/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/crusher_trophy))
		if(prob(25)) //by chance, you should get at least every 3 out of 4 trophies.
			to_chat(user, span_warning("你的[src]吞噬了[tool]却毫无益处！"))
			qdel(tool)
			return ITEM_INTERACT_BLOCKING

		to_chat(user, span_warning("你的[src]吞噬了[tool]！"))
		playsound(get_turf(src), 'sound/effects/magic/demon_attack1.ogg', 50, TRUE)
		qdel(tool)
		consumed_trophies += 1
		if(isliving(user)) //give a reason to consume past the increased damage
			var/mob/living/living_user = user
			var/need_mob_update
			need_mob_update += living_user.adjust_brute_loss(-5, updating_health = FALSE)
			need_mob_update += living_user.adjust_fire_loss(-5, updating_health = FALSE)
			if(need_mob_update)
				living_user.updatehealth()

		if(consumed_trophies <= max_trophies)
			force += 5
			armour_penetration += 5
			wound_bonus += 2
			exposed_wound_bonus += 2

		else if(consumed_trophies == (max_trophies + 1)) //just so you aren't spammed...
			to_chat(user, span_warning("[src]无法再变得更强了！"))

		return ITEM_INTERACT_BLOCKING

	return ..()

/datum/action/ashen_actions/hivemind_speak
	name = "灰烬蜂巢思维传讯"
	desc = "将你想说的话输入灰烬蜂巢思维。"
	button_icon_state = "hivemind"

	/// is this button currently in use?
	var/currently_used = FALSE

/datum/action/ashen_actions/hivemind_speak/Trigger(trigger_flags)
	. = ..()
	if(!.)
		return

	if(currently_used)
		return

	currently_used = TRUE

	var/inserted_message = tgui_input_text(owner, "你想通过灰烬蜂巢思维说什么？", "灰烬蜂巢思维消息", max_length = CHAT_MESSAGE_MAX_LENGTH)
	if(isnull(inserted_message))
		currently_used = FALSE
		return

	for(var/mob/living/living_ashwalker in GLOB.player_list)
		if(!isashwalker(living_ashwalker))
			continue

		to_chat(living_ashwalker, span_rose("<b>灰烬蜂巢思维：[owner]吟唱道：“[inserted_message]”</b>"))

	for(var/mob/dead_mob in GLOB.dead_mob_list)
		var/link = FOLLOW_LINK(dead_mob, src)
		to_chat(dead_mob, span_rose("[link] <b>灰烬蜂巢思维：[owner]吟唱道：“[inserted_message]”</b>"))

	var/logging_text = "[key_name(owner)] spoke into the hivemind: [inserted_message]"
	log_say(logging_text)
	currently_used = FALSE
