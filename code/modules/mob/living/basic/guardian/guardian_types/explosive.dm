/// A durable guardian which can convert objects into hidden explosives.
/mob/living/basic/guardian/explosive
	guardian_type = GUARDIAN_EXPLOSIVE
	melee_damage_lower = 15
	melee_damage_upper = 15
	damage_coeff = list(BRUTE = 0.6, BURN = 0.6, TOX = 0.6, STAMINA = 0, OXY = 0.6)
	range = 13
	playstyle_string = span_holoparasite("作为<b>爆破</b>类型，你拥有中等的近战能力，并且能够通过右键点击将附近的物品和物体转化为伪装炸弹。")
	creator_name = "Explosive"
	creator_desc = "High damage resist and medium power attack. Can turn any object, including objects too large to pick up, into a bomb, dealing explosive damage to the next person to touch it. The object will return to normal after the trap is triggered or after a delay."
	creator_icon = "explosive"
	/// Ability which plants bombs
	var/datum/action/cooldown/mob_cooldown/explosive_booby_trap/bomb

/mob/living/basic/guardian/explosive/Initialize(mapload, datum/guardian_fluff/theme)
	. = ..()
	bomb = new(src)
	bomb.Grant(src)

/mob/living/basic/guardian/explosive/Destroy()
	QDEL_NULL(bomb)
	return ..()

/mob/living/basic/guardian/explosive/UnarmedAttack(atom/attack_target, proximity_flag, list/modifiers)
	if(LAZYACCESS(modifiers, RIGHT_CLICK) && proximity_flag && isobj(attack_target) && can_unarmed_attack())
		bomb.Trigger(target = attack_target)
		return
	return ..()


/// An ability which can turn an object into a bomb
/datum/action/cooldown/mob_cooldown/explosive_booby_trap
	name = "爆破陷阱"
	desc = "将一个无生命的物体转化为致命且基本无法检测的爆炸物，触发方式为接触。"
	button_icon = 'icons/mob/actions/actions_spells.dmi'
	button_icon_state = "smoke"
	cooldown_time = 20 SECONDS
	background_icon = 'icons/hud/guardian.dmi'
	background_icon_state = "base"
	default_button_position = ui_guardian_special
	/// After this amount of time passses, bomb deactivates.
	var/decay_time = 1 MINUTES
	/// Static list of signals that activate the bomb.
	var/static/list/boom_signals = list(COMSIG_ATOM_ATTACKBY, COMSIG_ATOM_BUMPED, COMSIG_ATOM_ATTACK_HAND)

/datum/action/cooldown/mob_cooldown/explosive_booby_trap/PreActivate(atom/target)
	if (!isobj(target))
		return FALSE
	if (!owner.Adjacent(target))
		return FALSE
	return ..()

/datum/action/cooldown/mob_cooldown/explosive_booby_trap/Activate(atom/target)
	var/glow_colour = COLOR_RED
	var/mob/living/basic/guardian/guardian_owner = owner
	if (istype(guardian_owner))
		glow_colour = guardian_owner.guardian_colour
	target.AddComponent(\
		/datum/component/direct_explosive_trap, \
		saboteur = owner, \
		expire_time = decay_time, \
		glow_colour = glow_colour,\
		explosive_checks = CALLBACK(src, PROC_REF(validate_target)), \
		triggering_signals = boom_signals, \
	)
	target.balloon_alert(owner, "炸弹已安放")
	StartCooldown()
	return TRUE

/// Validate that we should blow up on this thing, preferably not on one of our allies
/datum/action/cooldown/mob_cooldown/explosive_booby_trap/proc/validate_target(mob/living/target)
	if (target == owner)
		return FALSE
	var/mob/living/basic/guardian/guardian_owner = owner
	if (!istype(guardian_owner))
		return TRUE
	return target != guardian_owner.summoner && !guardian_owner.shares_summoner(target)
