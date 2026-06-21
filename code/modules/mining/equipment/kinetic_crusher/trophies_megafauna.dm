/*!
 * Contains crusher trophies you can obtain from megafauna
 */

//blood-drunk hunter
/obj/item/crusher_trophy/miner_eye
	name = "嗜血猎人之眼"
	desc = "它的瞳孔已经塌陷并化为了糊状。适合作为动能粉碎机的战利品。"
	icon_state = "hunter_eye"
	trophy_id = TROPHY_MINER_EYE
	denied_type = /obj/item/crusher_trophy/miner_eye

/obj/item/crusher_trophy/miner_eye/effect_desc()
	return "mark detonation to grant stun immunity and <b>90%</b> damage reduction for <b>1</b> second"

/obj/item/crusher_trophy/miner_eye/on_mark_detonation(mob/living/target, mob/living/user)
	. = ..()
	user.apply_status_effect(/datum/status_effect/blooddrunk)

//ash drake
/obj/item/crusher_trophy/tail_spike
	desc = "一根取自灰烬龙尾部的尖刺。适合作为动能粉碎机的战利品。"
	denied_type = /obj/item/crusher_trophy/tail_spike
	trophy_id = TROPHY_TAIL_SPIKE
	bonus_value = 5

/obj/item/crusher_trophy/tail_spike/effect_desc()
	return "mark detonation to do <b>[bonus_value]</b> damage to nearby creatures and push them back"

/obj/item/crusher_trophy/tail_spike/on_mark_detonation(mob/living/target, mob/living/user)
	. = ..()
	for(var/mob/living/living_target in oview(2, user))
		if(user.faction_check_atom(living_target) || living_target.stat == DEAD)
			continue
		playsound(living_target, 'sound/effects/magic/fireball.ogg', 20, TRUE)
		new /obj/effect/temp_visual/fire(living_target.loc)
		addtimer(CALLBACK(src, PROC_REF(pushback), living_target, user), 1) //no free backstabs, we push AFTER module stuff is done
		living_target.adjust_fire_loss(bonus_value, forced = TRUE)

/obj/item/crusher_trophy/tail_spike/proc/pushback(mob/living/target, mob/living/user)
	if(!QDELETED(target) && !QDELETED(user) && (!target.anchored || ismegafauna(target)) && target.move_resist < INFINITY) //megafauna will always be pushed
		step(target, get_dir(user, target))

//bubblegum
/obj/item/crusher_trophy/demon_claws
	name = "恶魔利爪"
	desc = "一副来自巨型恶魔之手的、浸满鲜血的利爪。适合作为动能粉碎机的战利品。"
	icon_state = "demon_claws"
	gender = PLURAL
	denied_type = /obj/item/crusher_trophy/demon_claws
	bonus_value = 10
	trophy_id = TROPHY_DEMON_CLAWS
	var/static/list/damage_heal_order = list(BRUTE, BURN, OXY)

/obj/item/crusher_trophy/demon_claws/effect_desc()
	return "melee hits to do <b>[bonus_value * 0.2]</b> more damage and heal you for <b>[bonus_value * 0.1]</b>, with <b>5X</b> effect on mark detonation"

/obj/item/crusher_trophy/demon_claws/add_to(obj/item/kinetic_crusher/pkc, mob/living/user)
	. = ..()
	if(!.)
		return
	pkc.force_wielded += bonus_value * 0.2
	pkc.detonation_damage += bonus_value * 0.8
	pkc.update_wielding()

/obj/item/crusher_trophy/demon_claws/remove_from(obj/item/kinetic_crusher/pkc, mob/living/user)
	. = ..()
	if(!.)
		return
	pkc.force_wielded -= bonus_value * 0.2
	pkc.detonation_damage -= bonus_value * 0.8
	pkc.update_wielding()

/obj/item/crusher_trophy/demon_claws/on_melee_hit(mob/living/target, mob/living/user)
	user.heal_ordered_damage(bonus_value * 0.1, damage_heal_order)

/obj/item/crusher_trophy/demon_claws/on_mark_detonation(mob/living/target, mob/living/user)
	. = ..()
	user.heal_ordered_damage(bonus_value * 0.4, damage_heal_order)

//colossus
/obj/item/crusher_trophy/blaster_tubes
	name = "爆破管"
	desc = "来自巨像手臂的爆破管。适合作为动能粉碎机的战利品。"
	icon_state = "blaster_tubes"
	gender = PLURAL
	denied_type = /obj/item/crusher_trophy/blaster_tubes
	bonus_value = 15
	trophy_id = TROPHY_BLASTER_TUBES
	var/deadly_shot = FALSE

/obj/item/crusher_trophy/blaster_tubes/effect_desc()
	return "mark detonation to make the next destabilizer shot deal <b>[bonus_value]</b> damage but move slower"

/obj/item/crusher_trophy/blaster_tubes/on_projectile_fire(obj/projectile/destabilizer/marker, mob/living/user)
	if(deadly_shot)
		marker.name = "致命的[marker.name]"
		marker.icon_state = "chronobolt"
		marker.damage = bonus_value
		marker.speed = 2
		deadly_shot = FALSE

/obj/item/crusher_trophy/blaster_tubes/on_mark_detonation(mob/living/target, mob/living/user)
	. = ..()
	deadly_shot = TRUE
	addtimer(CALLBACK(src, PROC_REF(reset_deadly_shot)), 300, TIMER_UNIQUE|TIMER_OVERRIDE)

/obj/item/crusher_trophy/blaster_tubes/proc/reset_deadly_shot()
	deadly_shot = FALSE

//hierophant
/obj/item/crusher_trophy/vortex_talisman
	name = "漩涡护符"
	desc = "一个发光的饰品，原本是教皇的信标。适合作为动能粉碎机的战利品。"
	icon_state = "vortex_talisman"
	trophy_id = TROPHY_VORTEX
	denied_type = /obj/item/crusher_trophy/vortex_talisman

/obj/item/crusher_trophy/vortex_talisman/effect_desc()
	return "mark detonation to create a homing hierophant chaser"

/obj/item/crusher_trophy/vortex_talisman/on_mark_detonation(mob/living/target, mob/living/user)
	. = ..()
	if(isliving(target))
		var/obj/effect/temp_visual/hierophant/chaser/chaser = new(get_turf(user), user, target, 3, TRUE)
		chaser.monster_damage_boost = FALSE // Weaker cuz no cooldown
		chaser.damage = 20
		log_combat(user, target, "fired a chaser at", src)

// Demonic frost miner
/obj/item/crusher_trophy/ice_block_talisman
	name = "冰封护符"
	desc = "一个发光的饰品，来自一个恶魔矿工身上，他似乎因某种原因无法使用它。"
	icon_state = "ice_trap_talisman"
	trophy_id = TROPHY_ICE_BLOCK
	denied_type = /obj/item/crusher_trophy/ice_block_talisman

/obj/item/crusher_trophy/ice_block_talisman/effect_desc()
	return "mark detonation to freeze a creature in a block of ice for a period, preventing them from moving"

/obj/item/crusher_trophy/ice_block_talisman/on_mark_detonation(mob/living/target, mob/living/user)
	. = ..()
	target.apply_status_effect(/datum/status_effect/ice_block_talisman)

// Wendigo
/obj/item/crusher_trophy/wendigo_horn
	name = "温迪戈之角"
	desc = "从温迪戈头骨上扯下的扭曲犄角。适合作为动能粉碎机的战利品。"
	icon_state = "wendigo_horn"
	denied_type = /obj/item/crusher_trophy/wendigo_horn

/obj/item/crusher_trophy/wendigo_horn/effect_desc()
	return "melee hits to inflict twice as much damage"

/obj/item/crusher_trophy/wendigo_horn/add_to(obj/item/kinetic_crusher/crusher, mob/living/user)
	. = ..()
	if(!.)
		return
	crusher.force_wielded += 20
	crusher.update_wielding()

/obj/item/crusher_trophy/wendigo_horn/remove_from(obj/item/kinetic_crusher/crusher, mob/living/user)
	. = ..()
	if(!.)
		return
	crusher.force_wielded -= 20
	crusher.update_wielding()

// Goliath Broodmother
/obj/item/crusher_trophy/broodmother_tongue
	name = "育母之舌"
	desc = "育母的舌头。如果以某种方式安装，可以成为合适的粉碎机战利品。它摸起来非常柔软有弹性，我在想如果你捏一下会发生什么？..."
	icon = 'icons/obj/mining_zones/elite_trophies.dmi'
	icon_state = "broodmother_tongue"
	denied_type = /obj/item/crusher_trophy/broodmother_tongue
	bonus_value = 10
	trophy_id = TROPHY_BROOD_TONGUE
	/// Time at which the item becomes usable again
	var/use_time

/obj/item/crusher_trophy/broodmother_tongue/effect_desc()
	return "mark detonation to have a <b>[bonus_value]%</b> chance to summon a patch of goliath tentacles at the target's location"

/obj/item/crusher_trophy/broodmother_tongue/on_mark_detonation(mob/living/target, mob/living/user)
	. = ..()
	if(prob(bonus_value) && target.stat != DEAD)
		new /obj/effect/goliath_tentacle/broodmother/patch(get_turf(target), user)

/obj/item/crusher_trophy/broodmother_tongue/attack_self(mob/user)
	if(!isliving(user))
		return
	var/mob/living/living_user = user
	if(use_time > world.time)
		to_chat(living_user, "<b>舌头看起来干枯了。你需要等待更长时间才能再次使用它。</b>")
		return
	else if(HAS_TRAIT(living_user, TRAIT_LAVA_IMMUNE))
		to_chat(living_user, "<b>你盯着舌头看。你觉得这对你没什么用。</b>")
		return
	ADD_TRAIT(living_user, TRAIT_LAVA_IMMUNE, type)
	to_chat(living_user, "<b>你捏了捏舌头，一些半透明的液体喷了你一身。</b>")
	addtimer(TRAIT_CALLBACK_REMOVE(user, TRAIT_LAVA_IMMUNE, type), 10 SECONDS)
	use_time = world.time + 60 SECONDS

// Legionnaire
/obj/item/crusher_trophy/legionnaire_spine
	name = "军团士兵脊柱"
	desc = "军团士兵的脊柱。发挥一点创意，你可以把它用作粉碎机战利品。或者，摇晃它可能也会发生些什么。"
	icon = 'icons/obj/mining_zones/elite_trophies.dmi'
	icon_state = "legionnaire_spine"
	denied_type = /obj/item/crusher_trophy/legionnaire_spine
	bonus_value = 20
	trophy_id = TROPHY_LEGIONNAIRE_SPINE
	/// Time at which the item becomes usable again
	var/next_use_time

/obj/item/crusher_trophy/legionnaire_spine/effect_desc()
	return "mark detonation to have a <b>[bonus_value]%</b> chance to summon a loyal legion skull"

/obj/item/crusher_trophy/legionnaire_spine/on_mark_detonation(mob/living/target, mob/living/user)
	. = ..()
	if(!prob(bonus_value) || target.stat == DEAD)
		return
	var/mob/living/basic/mining/legion_brood/minion = new (user.loc)
	minion.assign_creator(user)
	minion.ai_controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, target)

/obj/item/crusher_trophy/legionnaire_spine/attack_self(mob/user)
	if(!isliving(user))
		return
	var/mob/living/LivingUser = user
	if(next_use_time > world.time)
		LivingUser.visible_message(span_warning("[LivingUser]摇晃着[src]，但什么都没发生..."))
		to_chat(LivingUser, "<b>你需要等待更长时间才能再次使用这个。</b>")
		return
	LivingUser.visible_message(span_boldwarning("[LivingUser]摇晃着[src]并召唤出了一个军团颅骨！"))

	var/mob/living/basic/mining/legion_brood/minion = new (LivingUser.loc)
	minion.assign_creator(LivingUser)
	next_use_time = world.time + 4 SECONDS

//The Thing
/obj/item/crusher_trophy/flesh_glob
	name = "蠕动肉块"
	desc = "一团被永久封存的蠕动血肉。适合作为动能粉碎机的战利品。"
	icon_state = "glob"
	denied_type = /obj/item/crusher_trophy/flesh_glob
	bonus_value = 20
	/// the order in which we heal damage
	var/static/list/damage_heal_order = list(BRUTE, BURN, OXY, TOX)

/obj/item/crusher_trophy/flesh_glob/effect_desc()
	return "melee hits heal you for <b>[bonus_value * 0.2]</b>, and for <b>[bonus_value * 0.5]</b> on mark detonation"

/obj/item/crusher_trophy/flesh_glob/on_melee_hit(mob/living/target, mob/living/user)
	user.heal_ordered_damage(bonus_value * 0.2, damage_heal_order)

/obj/item/crusher_trophy/flesh_glob/on_mark_detonation(mob/living/target, mob/living/user)
	. = ..()
	user.heal_ordered_damage(bonus_value * 0.5, damage_heal_order)
