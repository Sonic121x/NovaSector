/// A reasonably durable guardian linked to you by a chain of lightning, zapping people who get between you
/mob/living/basic/guardian/lightning
	guardian_type = GUARDIAN_LIGHTNING
	melee_damage_lower = 7
	melee_damage_upper = 7
	attack_verb_continuous = "shocks"
	attack_verb_simple = "shock"
	melee_damage_type = BURN
	attack_sound = 'sound/machines/defib/defib_zap.ogg'
	damage_coeff = list(BRUTE = 0.7, BURN = 0.7, TOX = 0.7, STAMINA = 0, OXY = 0.7)
	range = 7
	playstyle_string = span_holoparasite("作为 <b>闪电</b> 类型，你会在攻击时对目标施加闪电链，并与你的召唤者之间有一条闪电链。闪电链会电击附近的任何人。")
	creator_name = "Lightning"
	creator_desc = "Attacks apply lightning chains to targets. Has a lightning chain to the user. Lightning chains shock everything near them, doing constant damage."
	creator_icon = "lightning"
	/// Link between us and our summoner
	var/datum/component/summoner_chain
	/// Associative list of chained enemies to their chains
	var/list/enemy_chains

/mob/living/basic/guardian/lightning/death(gibbed)
	. = ..()
	clear_chains()

/mob/living/basic/guardian/lightning/Destroy()
	clear_chains()
	return ..()

/mob/living/basic/guardian/lightning/manifest_effects()
	. = ..()
	if (isnull(summoner))
		return
	summoner_chain = chain_to(summoner, max_range = INFINITY) // Functionally it's actually our leash range but admins might fuck with it

/mob/living/basic/guardian/lightning/recall_effects()
	. = ..()
	clear_chains()

/// Remove all of our chains
/mob/living/basic/guardian/lightning/proc/clear_chains()
	QDEL_NULL(summoner_chain)
	QDEL_LIST_ASSOC_VAL(enemy_chains)

/mob/living/basic/guardian/lightning/melee_attack(atom/target, list/modifiers, ignore_cooldown)
	. = ..()
	if (!. || !validate_target(target) || (target in enemy_chains))
		return
	if (length(enemy_chains) == 2)
		var/old_target = enemy_chains[1]
		var/datum/old_chain = enemy_chains[old_target]
		qdel(old_chain)
	var/datum/new_chain = chain_to(target)
	RegisterSignal(new_chain, COMSIG_QDELETING, PROC_REF(on_chain_deleted))
	LAZYADDASSOC(enemy_chains, target, new_chain)

/// Create a damaging lightning chain between ourselves and a target
/mob/living/basic/guardian/lightning/proc/chain_to(atom/target, max_range = 7)
	var/datum/component/chain = AddComponent(\
		/datum/component/damage_chain, \
		linked_to = target, \
		max_distance = max_range, \
		beam_state = "lightning[rand(1,12)]", \
		beam_type = /obj/effect/ebeam/chain, \
		validate_target = CALLBACK(src, PROC_REF(validate_target)), \
		chain_damage_feedback = CALLBACK(src, PROC_REF(on_chain_zap)), \
	)
	return chain

/// Handle losing our reference when we delete a chain
/mob/living/basic/guardian/lightning/proc/on_chain_deleted(datum/source)
	SIGNAL_HANDLER
	for (var/target in enemy_chains)
		if (enemy_chains[target] != source)
			continue
		enemy_chains -= target
		return

/// Confirm whether something is valid to zap with lightning
/mob/living/basic/guardian/lightning/proc/validate_target(atom/target)
	return isliving(target) && target != src && target != summoner && !shares_summoner(target)

/// Called every few zaps by a chain
/mob/living/basic/guardian/lightning/proc/on_chain_zap(mob/living/target)
	target.electrocute_act(shock_damage = 0, source = "lightning chain")
	target.visible_message(
		span_danger("[target] 被闪电链电击了！"),
		span_userdanger("你被闪电链电击了！"),
		span_hear("你听到一声沉重的电击爆裂声。"),
	)

/// Beam definition for our lightning chain
/obj/effect/ebeam/chain
	name = "闪电链"
	layer = LYING_MOB_LAYER
