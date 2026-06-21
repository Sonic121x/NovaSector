/mob/living/basic/hivebot
	name = "蜂巢机器人"
	desc = "一个小型机器人。"
	icon = 'icons/mob/simple/hivebot.dmi'
	icon_state = "basic"
	icon_living = "basic"
	icon_dead = "basic"
	basic_mob_flags = DEL_ON_DEATH
	gender = NEUTER
	mob_biotypes = MOB_ROBOTIC

	health = 15
	maxHealth = 15
	melee_damage_lower = 2
	melee_damage_upper = 3

	attack_verb_continuous = "claws"
	attack_verb_simple = "claw"
	attack_sound = 'sound/items/weapons/bladeslice.ogg'
	attack_vis_effect = ATTACK_EFFECT_CLAW
	verb_say = "陈述"
	verb_ask = "询问"
	verb_exclaim = "宣告"
	verb_yell = "警报"
	bubble_icon = "machine"

	faction = list(FACTION_HIVEBOT)
	combat_mode = TRUE
	speech_span = SPAN_ROBOT
	death_message = "blows apart!"

	habitable_atmos = null
	minimum_survivable_temperature = TCMB
	ai_controller = /datum/ai_controller/basic_controller/hivebot
	damage_coeff = list(BRUTE = 1, BURN = 1, TOX = 1, STAMINA = 0, OXY = 1)
	///does this type do range attacks?
	var/ranged_attacker = FALSE
	/// How often can we shoot?
	var/ranged_attack_cooldown = 3 SECONDS


/mob/living/basic/hivebot/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/death_drops, /obj/effect/decal/cleanable/blood/gibs/robot_debris)
	AddComponent(/datum/component/appearance_on_aggro, overlay_icon = icon, overlay_state = "[initial(icon_state)]_attack")
	if(!ranged_attacker)
		return
	AddComponent(/datum/component/ranged_attacks, /obj/item/ammo_casing/hivebot, cooldown_time = ranged_attack_cooldown)

/mob/living/basic/hivebot/death(gibbed)
	do_sparks(number = 3, cardinal_only = TRUE, source = src)
	return ..()

/mob/living/basic/hivebot/range
	name = "蜂巢机器人"
	desc = "一个小型机器人，这个有武装！"
	icon_state = "ranged"
	icon_living = "ranged"
	icon_dead = "ranged"
	ranged_attacker = TRUE
	ai_controller = /datum/ai_controller/basic_controller/hivebot/ranged

/mob/living/basic/hivebot/rapid
	icon_state = "ranged"
	icon_living = "ranged"
	icon_dead = "ranged"
	ranged_attacker = TRUE
	ai_controller = /datum/ai_controller/basic_controller/hivebot/ranged/rapid
	ranged_attack_cooldown = 1.5 SECONDS

/mob/living/basic/hivebot/strong
	name = "强力蜂巢机器人"
	icon_state = "strong"
	icon_living = "strong"
	icon_dead = "strong"
	desc = "一个机器人，这个有武装而且看起来很结实！"
	health = 80
	maxHealth = 80
	ranged_attacker = TRUE
	ai_controller = /datum/ai_controller/basic_controller/hivebot/ranged

/mob/living/basic/hivebot/mechanic
	name = "蜂巢机器人技工"
	icon_state = "strong"
	icon_living = "strong"
	icon_dead = "strong"
	desc = "为基地维护而建造的机器人，旨在用于蜂巢机器人殖民地内部。"
	health = 60
	maxHealth = 60
	gold_core_spawnable = HOSTILE_SPAWN
	ranged_attacker = TRUE
	ai_controller = /datum/ai_controller/basic_controller/hivebot/mechanic
	///cooldown to repair machines
	COOLDOWN_DECLARE(repair_cooldown)

/mob/living/basic/hivebot/mechanic/Initialize(mapload)
	. = ..()
	GRANT_ACTION(/datum/action/cooldown/spell/conjure/foam_wall)

/mob/living/basic/hivebot/mechanic/early_melee_attack(atom/target, list/modifiers, ignore_cooldown)
	. = ..()
	if(.)
		return

	if(ismachinery(target))
		repair_machine(target)
		return BASIC_MOB_END_ATTACK_CHAIN_COOLDOWN

	if(istype(target, /mob/living/basic/hivebot))
		repair_hivebot(target)
		return BASIC_MOB_END_ATTACK_CHAIN_COOLDOWN

/mob/living/basic/hivebot/mechanic/proc/repair_machine(obj/machinery/fixable)
	if(fixable.get_integrity() >= fixable.max_integrity)
		to_chat(src, span_warning("诊断表明这台机器处于峰值完整性。"))
		return
	if(!COOLDOWN_FINISHED(src, repair_cooldown))
		balloon_alert(src, "正在充能！")
		return
	fixable.repair_damage(fixable.max_integrity - fixable.get_integrity())
	do_sparks(number = 3, cardinal_only = TRUE, source = fixable)
	to_chat(src, span_warning("维修完成！"))
	COOLDOWN_START(src, repair_cooldown, 50 SECONDS)

/mob/living/basic/hivebot/mechanic/proc/repair_hivebot(mob/living/basic/bot_target)
	if(bot_target.health >= bot_target.maxHealth)
		to_chat(src, span_warning("诊断显示此单元处于峰值完整性状态。"))
		return
	if(!COOLDOWN_FINISHED(src, repair_cooldown))
		balloon_alert(src, "正在充能！")
		return
	bot_target.revive(HEAL_ALL)
	do_sparks(number = 3, cardinal_only = TRUE, source = bot_target)
	to_chat(src, span_warning("维修完成！"))
	COOLDOWN_START(src, repair_cooldown, 50 SECONDS)

/obj/item/ammo_casing/hivebot
	name = "蜂巢机器人弹壳"
	projectile_type = /obj/projectile/hivebotbullet

/obj/projectile/hivebotbullet
	damage = 10
	damage_type = BRUTE
