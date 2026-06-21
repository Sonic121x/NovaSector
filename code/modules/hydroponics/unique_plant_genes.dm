
// --- Below here are special, unique plant traits that only belong to certain plants. ---
// They are un-removable and cannot be mutated randomly, and should never be graftable.

/// Holymelon's anti-magic trait. Charges based on potency.
/datum/plant_gene/trait/anti_magic
	name = "反魔法泡囊"
	description = "你可以躲在它后面躲避火球！"
	icon = FA_ICON_HAND_SPARKLES
	/// The amount of anti-magic blocking uses we have.
	var/shield_uses = 1

/datum/plant_gene/trait/anti_magic/on_new_plant(obj/item/our_plant, newloc)
	. = ..()
	if(!.)
		return
	var/obj/item/seeds/our_seed = our_plant.get_plant_seed()
	shield_uses = round(our_seed.potency / 20)
	//deliver us from evil o melon god
	our_plant.AddComponent(/datum/component/anti_magic, \
		antimagic_flags = MAGIC_RESISTANCE|MAGIC_RESISTANCE_HOLY, \
		inventory_flags = ITEM_SLOT_HANDS, \
		charges = shield_uses, \
		block_magic = CALLBACK(src, PROC_REF(drain_antimagic)), \
		expiration = CALLBACK(src, PROC_REF(expire)), \
	)

/// When the plant our gene is hosted in is drained of an anti-magic charge.
/datum/plant_gene/trait/anti_magic/proc/drain_antimagic(mob/user, obj/item/our_plant)
	to_chat(user, span_warning("[our_plant] 轻微地嗡嗡作响，并且似乎有些衰败。"))

/// When the plant our gene is hosted in is drained of all of its anti-magic charges.
/datum/plant_gene/trait/anti_magic/proc/expire(mob/user, obj/item/our_plant)
	to_chat(user, span_warning("[our_plant] 迅速化为灰烬！"))
	new /obj/effect/decal/cleanable/ash(our_plant.drop_location())
	qdel(our_plant)

/// Traits that turn a plant into a weapon, giving them force and effects on attack.
/datum/plant_gene/trait/attack
	name = "攻击特性"
	description = "这是一件非常危险的武器。"
	icon = FA_ICON_HAND_FIST
	/// The multiplier we apply to the potency to calculate force. Set to 0 to not affect the force.
	var/force_multiplier = 0
	/// If TRUE, our plant will degrade in force every hit until diappearing.
	var/degrades_after_hit = FALSE
	/// When we fully degrade, what degraded off of us?
	var/degradation_noun = "leaves"

/datum/plant_gene/trait/attack/on_new_plant(obj/item/our_plant, newloc)
	. = ..()
	if(!.)
		return

	if(force_multiplier)
		var/obj/item/seeds/our_seed = our_plant.get_plant_seed()
		our_plant.force = round((5 + our_seed.potency * force_multiplier), 1)
	RegisterSignal(our_plant, COMSIG_ITEM_ATTACK, PROC_REF(on_plant_attack))
	RegisterSignal(our_plant, COMSIG_ITEM_AFTERATTACK, PROC_REF(after_plant_attack))

/// Signal proc for [COMSIG_ITEM_ATTACK] that allows for effects on attack
/datum/plant_gene/trait/attack/proc/on_plant_attack(obj/item/source, mob/living/target, mob/living/user)
	SIGNAL_HANDLER

	INVOKE_ASYNC(src, PROC_REF(attack_effect), source, target, user)

/*
 * Effects done when we hit people with our plant, ON attack.
 * Override on a per-plant basis.
 *
 * our_plant - our plant, that we're attacking with
 * user - the person who is attacking with the plant
 * target - the person who is attacked by the plant
 */
/datum/plant_gene/trait/attack/proc/attack_effect(obj/item/our_plant, mob/living/target, mob/living/user)
	return

/// Signal proc for [COMSIG_ITEM_AFTERATTACK] that allows for effects after an attack is done
/datum/plant_gene/trait/attack/proc/after_plant_attack(obj/item/source, atom/target, mob/user, list/modifiers)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(after_attack_effect), source, target, user)

/*
 * Effects done when we hit people with our plant, AFTER the attack is done.
 * Extend on a per-plant basis.
 *
 * our_plant - our plant, that we're attacking with
 * user - the person who is attacking with the plant
 * target - the atom which is attacked by the plant
 */
/datum/plant_gene/trait/attack/proc/after_attack_effect(obj/item/our_plant, atom/target, mob/living/user)
	SHOULD_CALL_PARENT(TRUE)

	if(!degrades_after_hit)
		return

	// We probably hit something or someone. Reduce our force
	if(our_plant.force > 0)
		our_plant.force -= rand(1, (our_plant.force / 3) + 1)
		return

	// When our force degrades to zero or below, we're all done
	to_chat(user, span_warning("所有 [degradation_noun] 都因为猛烈的抽打而从 [our_plant] 上掉落了！"))
	qdel(our_plant)

/// Novaflower's attack effects (sets people on fire) + degradation on attack
/datum/plant_gene/trait/attack/novaflower_attack
	name = "炽热花瓣"
	description = "用它击打可能会使物体燃烧。"
	force_multiplier = 0.2
	degrades_after_hit = TRUE
	degradation_noun = "petals"
	trait_flags = TRAIT_SHOW_EXAMINE

/datum/plant_gene/trait/attack/novaflower_attack/attack_effect(obj/item/our_plant, mob/living/target, mob/living/user)
	if(!istype(target))
		return

	var/obj/item/seeds/our_seed = our_plant.get_plant_seed()
	to_chat(target, span_danger("你被 [our_plant] 的强烈高温点燃了！"))
	target.adjust_fire_stacks(round(our_seed.potency / 20))
	if(target.ignite_mob())
		message_admins("[ADMIN_LOOKUPFLW(user)] set [ADMIN_LOOKUPFLW(target)] on fire with [our_plant] at [AREACOORD(user)]")
		user.log_message("set [key_name(target)] on fire with [our_plant]", LOG_ATTACK)
		target.log_message("was set on fire by [key_name(user)] with [our_plant].", LOG_VICTIM, log_globally = FALSE)
	our_plant.investigate_log("was used by [key_name(user)] to burn [key_name(target)] at [AREACOORD(user)]", INVESTIGATE_BOTANY)

/// Sunflower's attack effect (shows cute text)
/datum/plant_gene/trait/attack/sunflower_attack
	name = "鲜艳花瓣"
	description = "击中时能让其他人感受到力量。"

/datum/plant_gene/trait/attack/sunflower_attack/after_attack_effect(obj/item/our_plant, atom/target, mob/user, list/modifiers)
	if(ismob(target))
		var/mob/target_mob = target
		user.visible_message("<font color='green'>[user] smacks [target_mob] with [user.p_their()] [our_plant.name]! <font color='orange'><b>FLOWER POWER!</b></font></font>", ignored_mobs = list(target_mob, user))
		if(target_mob != user)
			to_chat(target_mob, "<font color='green'>[user] smacks you with [our_plant]!<font color='orange'><b>FLOWER POWER!</b></font></font>")
		to_chat(user, "<font color='green'>Your [our_plant.name]'s <font color='orange'><b>FLOWER POWER</b></font> strikes [target_mob]!</font>")

	return ..()

/// Normal nettle's force + degradation on attack
/datum/plant_gene/trait/attack/nettle_attack
	name = "锋利枝叶"
	force_multiplier = 0.2
	degrades_after_hit = TRUE

/// Deathnettle force + degradation on attack
/datum/plant_gene/trait/attack/nettle_attack/death
	name = "锋利且变尖的叶片"
	force_multiplier = 0.4

/// Traits for plants with backfire effects. These are negative effects that occur when a plant is handled without gloves/unsafely.
/datum/plant_gene/trait/backfire
	name = "反作用特征"
	icon = FA_ICON_MITTEN
	description = "在没有防护的情况下手持它时要小心。"
	/// Whether our actions are cancelled when the backfire triggers.
	var/cancel_action_on_backfire = FALSE
	/// A list of extra traits to check to be considered safe.
	var/list/traits_to_check
	/// A list of extra genes to check to be considered safe.
	var/list/genes_to_check

/datum/plant_gene/trait/backfire/on_new_plant(obj/item/our_plant, newloc)
	. = ..()
	if(!.)
		return
	if(genes_to_check)
		genes_to_check = string_list(genes_to_check)
	if(traits_to_check)
		traits_to_check = string_list(traits_to_check)
	our_plant.AddElement(/datum/element/plant_backfire, cancel_action_on_backfire, traits_to_check, genes_to_check)
	RegisterSignal(our_plant, COMSIG_PLANT_ON_BACKFIRE, PROC_REF(on_backfire))

/// Signal proc for [COMSIG_PLANT_ON_BACKFIRE] that causes the backfire effect.
/datum/plant_gene/trait/backfire/proc/on_backfire(obj/item/source, mob/living/carbon/user)
	SIGNAL_HANDLER

	INVOKE_ASYNC(src, PROC_REF(backfire_effect), source, user)

/**
 * The actual backfire effect on the user.
 * Override with plant-specific effects.
 */
/datum/plant_gene/trait/backfire/proc/backfire_effect(obj/item/our_plant, mob/living/carbon/user)
	return

/// Rose's prick on backfire
/datum/plant_gene/trait/backfire/rose_thorns
	name = "玫瑰刺"
	description = "茎干上有很多刺。"
	traits_to_check = list(TRAIT_PIERCEIMMUNE)
	trait_flags = TRAIT_SHOW_EXAMINE

/datum/plant_gene/trait/backfire/rose_thorns/backfire_effect(obj/item/our_plant, mob/living/carbon/user)
	var/obj/item/seeds/our_seed = our_plant.get_plant_seed()
	if(!our_seed.get_gene(/datum/plant_gene/trait/sticky) && prob(66))
		to_chat(user, span_danger("[our_plant] 的刺差点扎到你的手。最好小心点。"))
		return

	to_chat(user, span_danger("[our_plant] 的刺扎到了你的手。哎哟。"))
	our_plant.investigate_log("rose-pricked [key_name(user)] at [AREACOORD(user)]", INVESTIGATE_BOTANY)
	user.apply_damage(2, BRUTE, user.get_active_hand())

/// Novaflower's hand burn on backfire
/datum/plant_gene/trait/backfire/novaflower_heat
	name = "燃烧的茎"
	description = "茎干可能会灼伤你的手。"
	cancel_action_on_backfire = TRUE
	trait_flags = TRAIT_SHOW_EXAMINE

/datum/plant_gene/trait/backfire/novaflower_heat/backfire_effect(obj/item/our_plant, mob/living/carbon/user)
	to_chat(user, span_danger("[our_plant] 灼伤了你的赤手！"))
	our_plant.investigate_log("self-burned [key_name(user)] for [our_plant.force] at [AREACOORD(user)]", INVESTIGATE_BOTANY)
	user.apply_damage(our_plant.force, our_plant.damtype, user.get_active_hand(), wound_bonus = CANT_WOUND)

/// Normal Nettle hannd burn on backfire
/datum/plant_gene/trait/backfire/nettle_burn
	name = "刺茎"
	description = "茎干可能会刺痛你的手。"
	trait_flags = TRAIT_SHOW_EXAMINE

/datum/plant_gene/trait/backfire/nettle_burn/backfire_effect(obj/item/our_plant, mob/living/carbon/user)
	to_chat(user, span_danger("[our_plant] 灼伤了你的赤手！"))
	our_plant.investigate_log("self-burned [key_name(user)] for [our_plant.force] at [AREACOORD(user)]", INVESTIGATE_BOTANY)
	user.apply_damage(our_plant.force, our_plant.damtype, user.get_active_hand(), wound_bonus = CANT_WOUND)

/// Deathnettle hand burn + stun on backfire
/datum/plant_gene/trait/backfire/nettle_burn/death
	name = "具有攻击性的刺茎"
	cancel_action_on_backfire = TRUE

/datum/plant_gene/trait/backfire/nettle_burn/death/backfire_effect(obj/item/our_plant, mob/living/carbon/user)
	. = ..()
	if(!. || prob(50))
		return

	user.Paralyze(10 SECONDS)
	to_chat(user, span_userdanger("你被 [our_plant] 的强酸惊呆了！"))

/// Ghost-Chili heating up on backfire
/datum/plant_gene/trait/backfire/chili_heat
	name = "活跃的辣椒腺体"
	description = "手持时会散发出强烈的热量。"
	trait_flags = TRAIT_SHOW_EXAMINE
	genes_to_check = list(/datum/plant_gene/trait/chem_heating)
	/// The mob currently holding the chili.
	var/datum/weakref/held_mob
	/// The chili this gene is tied to, to track it for processing.
	var/datum/weakref/our_chili

/datum/plant_gene/trait/backfire/chili_heat/on_new_plant(obj/item/our_plant, newloc)
	. = ..()
	if(!.)
		return

	our_chili = WEAKREF(our_plant)
	RegisterSignals(our_plant, list(COMSIG_QDELETING, COMSIG_ITEM_DROPPED), PROC_REF(stop_backfire_effect))

/*
 * Begin processing the trait on backfire.
 *
 * our_plant - our source plant, which is backfiring
 * user - the mob holding our plant
 */
/datum/plant_gene/trait/backfire/chili_heat/backfire_effect(obj/item/our_plant, mob/living/carbon/user)
	held_mob = WEAKREF(user)
	START_PROCESSING(SSobj, src)

/*
 * Stop processing the trait when we're dropped or deleted.
 *
 * our_plant - our source plant
 */
/datum/plant_gene/trait/backfire/chili_heat/proc/stop_backfire_effect(datum/source)
	SIGNAL_HANDLER

	held_mob = null
	STOP_PROCESSING(SSobj, src)

/*
 * The processing of our trait. Heats up the mob ([held_mob]) currently holding the source plant ([our_chili]).
 * Stops processing if we're no longer being held by [held mob].
 */
/datum/plant_gene/trait/backfire/chili_heat/process(seconds_per_tick)
	var/mob/living/carbon/our_mob = held_mob?.resolve()
	var/obj/item/our_plant = our_chili?.resolve()

	// If our weakrefs don't resolve, or if our mob is not holding our plant, stop processing.
	if(!our_mob || !our_plant || !our_mob.is_holding(our_plant))
		stop_backfire_effect()
		return

	our_mob.adjust_bodytemperature(7.5 * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick)
	if(SPT_PROB(5, seconds_per_tick))
		to_chat(our_mob, span_warning("你握着 [our_plant] 的手在燃烧！"))

/// Bluespace Tomato squashing on the user on backfire
/datum/plant_gene/trait/backfire/bluespace
	name = "蓝空活泼"
	description = "如果你没有防护地手持它，可能会被传送到太空。"
	cancel_action_on_backfire = TRUE
	genes_to_check = list(/datum/plant_gene/trait/squash)

/datum/plant_gene/trait/backfire/bluespace/backfire_effect(obj/item/our_plant, mob/living/carbon/user)
	if(prob(50))
		return

	to_chat(user, span_danger("[our_plant] 从你手中滑脱了！"))

	var/obj/item/seeds/our_seed = our_plant.get_plant_seed()
	var/datum/plant_gene/trait/squash/squash_gene = our_seed.get_gene(/datum/plant_gene/trait/squash)
	squash_gene.squash_plant(our_plant, user)

/// Traits for plants that can be activated to turn into a mob.
/datum/plant_gene/trait/mob_transformation
	name = "蛰伏的凶猛性"
	description = "在手中摇晃时它会活过来。"
	icon = FA_ICON_HEART_PULSE
	trait_ids = ATTACK_SELF_ID
	/// Whether mobs spawned by this trait are dangerous or not.
	var/dangerous = FALSE
	/// The typepath to what mob spawns from this plant.
	var/killer_plant
	/// Whether our attatched plant is currently waking up or not.
	var/awakening = FALSE
	/// Spawned mob's health = this multiplier * seed endurance.
	var/mob_health_multiplier = 1
	/// Spawned mob's melee damage = this multiplier * seed potency.
	var/mob_melee_multiplier = 1
	/// Spawned mob's move delay = this multiplier * seed potency.
	var/mob_speed_multiplier = 1

/datum/plant_gene/trait/mob_transformation/on_new_plant(obj/item/our_plant, newloc)
	. = ..()
	if(!.)
		return

	if(dangerous)
		our_plant.AddElement(/datum/element/plant_backfire, TRUE)
		RegisterSignal(our_plant, COMSIG_PLANT_ON_BACKFIRE, PROC_REF(early_awakening))
	RegisterSignal(our_plant, COMSIG_ITEM_ATTACK_SELF, PROC_REF(manual_awakening))
	RegisterSignal(our_plant, COMSIG_ITEM_PRE_ATTACK, PROC_REF(pre_consumption_check))

/*
 * Before we can eat our plant, check to see if it's waking up. Don't eat it if it is.
 *
 * our_plant - signal source, the plant we're eating
 * target - the mob eating the plant
 * user - the mob feeding someone the plant (generally, target == user)
 */
/datum/plant_gene/trait/mob_transformation/proc/pre_consumption_check(obj/item/our_plant, atom/target, mob/user)
	SIGNAL_HANDLER

	if(!awakening)
		return

	if(!ismob(target))
		return

	if(target != user)
		to_chat(user, span_warning("[our_plant] 正在抽搐和摇晃，阻止你将它喂给 [target]。"))
	to_chat(target, span_warning("[our_plant] 正在抽搐和摇晃，阻止你吃掉它。"))
	return COMPONENT_CANCEL_ATTACK_CHAIN

/*
 * Called when a user manually activates the plant.
 * Checks if the critera is met to spawn it, and spawns it in 3 seconds if it is.
 *
 * our_plant - our plant that we're waking up
 * user - the mob activating the plant
 */
/datum/plant_gene/trait/mob_transformation/proc/manual_awakening(obj/item/our_plant, mob/user)
	SIGNAL_HANDLER

	if(awakening || isspaceturf(user.loc))
		return

	if(dangerous && HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, span_notice("你决定不唤醒 [our_plant]。它可能非常危险！"))
		return

	to_chat(user, span_notice("你开始唤醒 [our_plant]..."))
	begin_awaken(our_plant, 3 SECONDS)
	our_plant.investigate_log("was awakened by [key_name(user)] at [AREACOORD(user)].", INVESTIGATE_BOTANY)

/*
 * Called when a user accidentally activates the plant via backfire effect.
 *
 * our_plant - our plant, which is waking up
 * user - the mob handling the plant
 */
/datum/plant_gene/trait/mob_transformation/proc/early_awakening(obj/item/our_plant, mob/living/carbon/user)
	SIGNAL_HANDLER

	if(!awakening && !isspaceturf(user.loc) && prob(25))
		our_plant.visible_message(span_danger("[our_plant] 开始咆哮并摇晃！"))
		begin_awaken(our_plant, 1 SECONDS)
		our_plant.investigate_log("was awakened (via plant backfire) by [key_name(user)] at [AREACOORD(user)].", INVESTIGATE_BOTANY)

/*
 * Actually begin the process of awakening the plant.
 *
 * awaken_time - the time, in seconds, it will take for the plant to spawn.
 */
/datum/plant_gene/trait/mob_transformation/proc/begin_awaken(obj/item/our_plant, awaken_time)
	awakening = TRUE
	addtimer(CALLBACK(src, PROC_REF(awaken), our_plant), awaken_time)

/*
 * Actually awaken the plant, spawning the mob designated by the [killer_plant] typepath.
 *
 * our_plant - the plant that's waking up
 */
/datum/plant_gene/trait/mob_transformation/proc/awaken(obj/item/our_plant)
	if(QDELETED(our_plant))
		return
	if(!ispath(killer_plant))
		return

	var/obj/item/seeds/our_seed = our_plant.get_plant_seed()
	var/mob/living/spawned_mob = new killer_plant(our_plant.drop_location())
	spawned_mob.maxHealth += round(our_seed.endurance * mob_health_multiplier)
	spawned_mob.health = spawned_mob.maxHealth
	if(ishostile(spawned_mob))
		var/mob/living/simple_animal/hostile/spawned_simplemob = spawned_mob
		spawned_simplemob.melee_damage_lower += round(our_seed.potency * mob_melee_multiplier)
		spawned_simplemob.melee_damage_upper += round(our_seed.potency * mob_melee_multiplier)
		spawned_simplemob.move_to_delay -= round(our_seed.production * mob_speed_multiplier)

	if(isbasicmob(spawned_mob))
		var/mob/living/basic/spawned_basicmob = spawned_mob
		spawned_basicmob.melee_damage_lower += round(our_seed.potency * mob_melee_multiplier)
		spawned_basicmob.melee_damage_upper += round(our_seed.potency * mob_melee_multiplier)
		// basic mob speeds aren't exactly equivalent to simple animal's "move to delay" but this seems balanced enough.
		var/calculated_speed = initial(spawned_basicmob.speed) - round((our_seed.production * mob_speed_multiplier), 0.01)
		spawned_basicmob.set_varspeed(calculated_speed)

	our_plant.forceMove(our_plant.drop_location())
	spawned_mob.visible_message(span_notice("[our_plant] 咆哮着突然苏醒了！"))
	qdel(our_plant)

/// Killer Tomato's transformation gene.
/datum/plant_gene/trait/mob_transformation/tomato
	dangerous = TRUE
	killer_plant = /mob/living/basic/killer_tomato
	mob_health_multiplier = 0.33
	mob_melee_multiplier = 0.1
	mob_speed_multiplier = 0.02

/// Walking Mushroom's transformation gene
/datum/plant_gene/trait/mob_transformation/shroom
	killer_plant = /mob/living/basic/mushroom
	mob_health_multiplier = 0.25
	mob_melee_multiplier = 0.05
	mob_speed_multiplier = 0.02

/// Traiit for plants eaten in 1 bite.
/datum/plant_gene/trait/one_bite
	name = "大口吞食"
	description = "你忍不住要一口把它吃掉！"
	icon = FA_ICON_DRUMSTICK_BITE
	trait_flags = TRAIT_SHOW_EXAMINE

/datum/plant_gene/trait/one_bite/on_new_plant(obj/item/our_plant, newloc)
	. = ..()
	if(!.)
		return

	var/obj/item/food/grown/grown_plant = our_plant
	if(istype(grown_plant))
		grown_plant.bite_consumption_mod = 100

/// Traits for plants with a different base max_volume.
/datum/plant_gene/trait/modified_volume
	name = "深泡囊"
	description = "它拥有额外的试剂容量。"
	icon = FA_ICON_VIALS
	/// The new number we set the plant's max_volume to.
	var/new_capcity = 100

/datum/plant_gene/trait/modified_volume/on_new_plant(obj/item/our_plant, newloc)
	. = ..()
	if(!.)
		return

	var/obj/item/food/grown/grown_plant = our_plant
	if(istype(grown_plant))
		grown_plant.max_volume = new_capcity

/// Omegaweed's funny 420 max volume gene
/datum/plant_gene/trait/modified_volume/omega_weed
	name = "潮湿泡囊"
	description = "它可以容纳多达 420 单位的试剂。"
	icon = FA_ICON_CANNABIS
	new_capcity = 420

/// Cherry Bomb's increased max volume gene
/datum/plant_gene/trait/modified_volume/cherry_bomb
	name = "充填粉末的泡囊"
	description = "它可以容纳多达 125 单位的试剂。"
	new_capcity = 125

/// Plants that explode when used (based on their reagent contents)
/datum/plant_gene/trait/bomb_plant
	name = "爆炸内容"
	description = "别摇晃它，里面的东西可能会爆炸。"
	icon = FA_ICON_BOMB
	trait_ids = ATTACK_SELF_ID

/datum/plant_gene/trait/bomb_plant/on_new_plant(obj/item/our_plant, newloc)
	. = ..()
	if(!.)
		return

	our_plant.max_integrity = 40 // Max_integrity is lowered so they explode better, or something like that.
	RegisterSignal(our_plant, COMSIG_ITEM_ATTACK_SELF, PROC_REF(trigger_detonation))
	RegisterSignal(our_plant, COMSIG_ATOM_EX_ACT, PROC_REF(explosion_reaction))
	RegisterSignal(our_plant, COMSIG_OBJ_DECONSTRUCT, PROC_REF(deconstruct_reaction))

/*
 * Trigger our plant's detonation.
 *
 * our_plant - the plant that's exploding
 * user - the mob detonating the plant
 */
/datum/plant_gene/trait/bomb_plant/proc/trigger_detonation(obj/item/our_plant, mob/living/user)
	SIGNAL_HANDLER

	var/obj/item/seeds/our_seed = our_plant.get_plant_seed()
	var/obj/item/food/grown/grown_plant = our_plant
	// If we have an alt icon, use that to show our plant is exploding.
	if(istype(our_plant) && grown_plant.alt_icon)
		our_plant.icon_state = grown_plant.alt_icon
	else
		our_plant.color = COLOR_RED

	playsound(our_plant, 'sound/effects/fuse.ogg', our_seed.potency, FALSE)
	user.visible_message(
		span_warning("[user] 从 [our_plant] 上拔下了茎干！"),
		span_userdanger("你从 [our_plant] 上拔下了茎干，它开始发出响亮的嘶嘶声！"),
	)
	log_bomber(user, "primed a", our_plant, "for detonation")
	detonate(our_plant)

/*
 * Reacting to when the plant is deconstructed.
 * When is a plant ever deconstructed? Apparently, when it burns.
 *
 * our_plant - the plant that's 'deconstructed'
 * disassembled - if it was disassembled when it was deconstructed.
 */
/datum/plant_gene/trait/bomb_plant/proc/deconstruct_reaction(obj/item/our_plant, disassembled)
	SIGNAL_HANDLER

	if(!disassembled)
		detonate(our_plant)
	if(!QDELETED(our_plant))
		qdel(our_plant)

/*
 * React to explosions that hit the plant.
 * Ensures that the plant id deleted by its own explosion.
 * Also prevents mass chain reaction with piles plants.
 *
 * our_plant - the plant that's exploded on
 * severity - severity of the explosion
 */
/datum/plant_gene/trait/bomb_plant/proc/explosion_reaction(obj/item/our_plant, severity)
	SIGNAL_HANDLER

	qdel(our_plant)

/*
 * RActually blow up the plant.
 *
 * our_plant - the plant that's exploding for real
 */
/datum/plant_gene/trait/bomb_plant/proc/detonate(obj/item/our_plant)
	our_plant.reagents.chem_temp = 1000 //Sets off the gunpowder
	our_plant.reagents.handle_reactions()

/// A subtype of bomb plants that have their boom sized based on potency instead of reagent contents.
/datum/plant_gene/trait/bomb_plant/potency_based
	name = "爆炸性特质"

/datum/plant_gene/trait/bomb_plant/potency_based/trigger_detonation(obj/item/our_plant, mob/living/user)
	user.visible_message(
		span_warning("[user] 启动了 [our_plant]！"),
		span_userdanger("你启动了 [our_plant]！"),
	)
	log_bomber(user, "primed a", our_plant, "for detonation")

	var/obj/item/food/grown/grown_plant = our_plant
	if(istype(our_plant) && grown_plant.alt_icon)
		our_plant.icon_state = grown_plant.alt_icon
	else
		our_plant.color = COLOR_RED

	playsound(our_plant.drop_location(), 'sound/items/weapons/armbomb.ogg', 75, TRUE, -3)
	addtimer(CALLBACK(src, PROC_REF(detonate), our_plant), rand(1 SECONDS, 6 SECONDS))

/datum/plant_gene/trait/bomb_plant/potency_based/detonate(obj/item/our_plant)
	var/obj/item/seeds/our_seed = our_plant.get_plant_seed()
	var/flame_reach = clamp(round(our_seed.potency / 20), 1, 5) //Like IEDs - their flame range can get up to 5, but their real boom is small

	our_plant.forceMove(our_plant.drop_location())
	explosion(our_plant, devastation_range = -1, heavy_impact_range = -1, light_impact_range = 2, flame_range = flame_reach)
	qdel(our_plant)

/// Corpseflower's miasma production.
/// Can be generalized in the future to spawn any gas, but I don't think that's necessarily a good idea.
/datum/plant_gene/trait/gas_production
	name = "瘴气气体生产"
	description = "这种植物在生长时会散发臭味。"
	icon = FA_ICON_WIND
	/// The location of our tray, if we have one.
	var/datum/weakref/home_tray
	/// The seed emitting gas.
	var/datum/weakref/stinky_seed

/datum/plant_gene/trait/gas_production/on_new_seed(obj/item/seeds/new_seed)
	RegisterSignal(new_seed, COMSIG_SEED_ON_PLANTED, PROC_REF(set_home_tray))
	RegisterSignal(new_seed, COMSIG_SEED_ON_GROW, PROC_REF(try_release_gas))
	RegisterSignal(new_seed, COMSIG_QDELETING, PROC_REF(stop_gas))
	stinky_seed = WEAKREF(new_seed)

/datum/plant_gene/trait/gas_production/on_removed(obj/item/seeds/old_seed)
	UnregisterSignal(old_seed, list(COMSIG_QDELETING, COMSIG_SEED_ON_PLANTED, COMSIG_SEED_ON_GROW))
	stop_gas()

/*
 * Whenever we're planted, set a new home tray.
 *
 * our_seed - the seed growing
 * grown_tray - the tray we were planted in
 */
/datum/plant_gene/trait/gas_production/proc/set_home_tray(obj/item/seeds/our_seed, obj/machinery/hydroponics/grown_tray)
	SIGNAL_HANDLER

	home_tray = WEAKREF(grown_tray)

/*
 * Whenever the plant starts to grow in a tray, check if we can release gas.
 *
 * our_seed - the seed growing
 * grown_tray - the tray, we're currently growing within
 */
/datum/plant_gene/trait/gas_production/proc/try_release_gas(obj/item/seeds/our_seed, obj/machinery/hydroponics/grown_tray)
	SIGNAL_HANDLER

	if(grown_tray.age < our_seed.maturation) // Start a little before it blooms
		return

	START_PROCESSING(SSobj, src)

/*
 * Stop the seed from releasing gas.
 */
/datum/plant_gene/trait/gas_production/proc/stop_gas(datum/source)
	SIGNAL_HANDLER

	STOP_PROCESSING(SSobj, src)

/*
 * If the conditions are acceptable and the potency is high enough, release miasma into the air.
 */
/datum/plant_gene/trait/gas_production/process(seconds_per_tick)
	var/obj/item/seeds/seed = stinky_seed?.resolve()
	var/obj/machinery/hydroponics/tray = home_tray?.resolve()

	// If our weakrefs don't resolve, or if our seed is /somehow/ not in the tray it was planted in, stop processing.
	if(!seed || !tray || seed.loc != tray)
		stop_gas()
		return

	var/turf/open/tray_turf = get_turf(tray)
	if(abs(ONE_ATMOSPHERE - tray_turf.return_air().return_pressure()) > (seed.potency / 10 + 10)) // clouds can begin showing at around 50-60 potency in standard atmos
		return

	var/datum/gas_mixture/stank = new

	stank.set_gas(/datum/gas/miasma, (seed.yield + 6) * 3.5 * MIASMA_CORPSE_MOLES * seconds_per_tick) // this process is only being called about 2/7 as much as corpses so this is 12-32 times a corpses
	stank.temperature = T20C // without this the room would eventually freeze and miasma mining would be easier
	tray_turf.assume_air(stank)

/// Hard caps the yield at 5 (effectively)
/datum/plant_gene/trait/complex_harvest
	name = "复杂收获"
	description = "使植物的最大产量减半，并阻止其从授粉的产量加成中受益。"
	icon = FA_ICON_SLASH
	trait_flags = TRAIT_HALVES_YIELD|TRAIT_NO_POLLINATION
	mutability_flags = NONE

/// Poppy's unique trait that allows slicing for sap
/datum/plant_gene/trait/opium_production
	name = "汁液花蕾"
	description = "在植物年龄介于 200 秒到 400 秒之间时，使用小刀或其他锋利物体可以获得汁液。"
	icon = FA_ICON_PILLS
	/// Has parent plant been harvested for sap already?
	var/extracted = FALSE

/datum/plant_gene/trait/opium_production/on_plant_in_tray(obj/machinery/hydroponics/tray, obj/item/seeds/seed)
	RegisterSignal(tray, COMSIG_ATOM_ITEM_INTERACTION, PROC_REF(try_extract))
	extracted = FALSE // just in case...

/datum/plant_gene/trait/opium_production/on_unplanted_from_tray(obj/machinery/hydroponics/tray, obj/item/seeds/seed)
	UnregisterSignal(tray, COMSIG_ATOM_ITEM_INTERACTION)

/// Redirect tray item interaction so we can have custom extracting behavior
/datum/plant_gene/trait/opium_production/proc/try_extract(obj/machinery/hydroponics/source, mob/living/user, obj/item/tool, ...)
	SIGNAL_HANDLER

	if(!tool.sharpness || tool.tool_behaviour == TOOL_SHOVEL)
		return NONE

	if(source.age < 10)
		to_chat(user, span_warning("这些 [LOWER_TEXT(source.myseed.plantname)] 太年轻了，无法提取汁液！"))
		return ITEM_INTERACT_FAILURE
	if(source.age > 19)
		to_chat(user, span_warning("这些 [LOWER_TEXT(source.myseed.plantname)] 太老了，无法提取汁液！"))
		return ITEM_INTERACT_FAILURE
	if(extracted)
		to_chat(user, span_warning("这些 [LOWER_TEXT(source.myseed.plantname)] 的汁液已经被采集过了！"))
		return ITEM_INTERACT_FAILURE

	extracted = TRUE
	new /obj/item/food/drug/opium/raw(source.drop_location(), source.myseed.potency)
	playsound(src, 'sound/effects/bubbles/bubbles.ogg', 30, TRUE)
	playsound(tool, 'sound/items/weapons/bladeslice.ogg', 30, TRUE)
	user.visible_message(
		span_notice("[user] 小心地切开一个 [source.myseed.species] 豆荚，提取出一份汁液。"),
		span_notice("你小心地切开 [source.myseed.species] 的豆荚，收集那芬芳诱人的汁液。"),
		visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
	)
	return ITEM_INTERACT_SUCCESS

/// Starthistle's essential invasive spreading
/datum/plant_gene/trait/invasive/galaxythistle
	mutability_flags = PLANT_GENE_GRAFTABLE

/// Jupitercup's essential carnivory
/datum/plant_gene/trait/carnivory/jupitercup
	mutability_flags = PLANT_GENE_GRAFTABLE

/// Preset plant reagent genes that are unremovable from a plant.
/datum/plant_gene/reagent/preset
	mutability_flags = PLANT_GENE_GRAFTABLE

/datum/plant_gene/reagent/preset/New(new_reagent_id, new_reagent_rate = 0.04)
	. = ..()
	set_reagent(reagent_id)

/// Spaceman's Trumpet fragile Polypyrylium Oligomers
/datum/plant_gene/reagent/preset/polypyr
	reagent_id = /datum/reagent/medicine/polypyr
	rate = 0.15

/// Jupitercup's fragile Liquid Electricity
/datum/plant_gene/reagent/preset/liquidelectricity
	reagent_id = /datum/reagent/consumable/liquidelectricity/enriched
	rate = 0.1

/// Carbon Roses's fragile Carbon
/datum/plant_gene/reagent/preset/carbon
	reagent_id = /datum/reagent/carbon
	rate = 0.1
