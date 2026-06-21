/obj/item/gun/magic/wand
	name = "魔杖"
	desc = "你不应该有这个。"
	ammo_type = /obj/item/ammo_casing/magic
	icon_state = "nothingwand"
	inhand_icon_state = "wand"
	icon_angle = -45
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	base_icon_state = "nothingwand"
	w_class = WEIGHT_CLASS_SMALL
	self_charging = FALSE
	max_charges = 100 //100, 50, 50, 34 (max charge distribution by 25%ths)
	/// If true, we have a 25% chance of listed max charges, 50% chance of 1/2 max charges, 25% chance of 1/3 max charges
	var/variable_charges = TRUE

/obj/item/gun/magic/wand/Initialize(mapload)
	if (!variable_charges || prob(25))
		return ..()

	if(prob(33)) // 33% of the remaining 75% so another 25%
		max_charges = ceil(max_charges / 3)
	else
		max_charges = ceil(max_charges / 2)
	return ..()

/obj/item/gun/magic/wand/examine(mob/user)
	. = ..()
	. += "Has [charges] charge\s remaining."

/obj/item/gun/magic/wand/update_icon_state()
	icon_state = "[base_icon_state][charges ? null : "-drained"]"
	return ..()

/obj/item/gun/magic/wand/attack(atom/target, mob/living/user)
	if(target == user)
		return
	return ..()

/obj/item/gun/magic/wand/try_fire_gun(atom/target, mob/living/user, params)
	if(!charges)
		shoot_with_empty_chamber(user)
		return FALSE
	if(target == user)
		if(no_den_usage && istype(get_area(user), /area/centcom/wizard_station))
			to_chat(user, span_warning("你很清楚不该在巢穴里违反安保规定，最好等离开后再使用 [src]。"))
			return FALSE
		zap_self(user)
		. = TRUE

	else
		. = ..()

	if(.)
		update_appearance()
	return .

/// Called if we poke ourselves with the wand
/obj/item/gun/magic/wand/proc/zap_self(mob/living/user, suicide = FALSE)
	user.visible_message(span_danger("[user] 用 [src] 电击了 [user.p_them()] 自己。"))
	playsound(user, fire_sound, 50, TRUE)
	user.log_message("zapped [user.p_them()]self with a <b>[src]</b>", LOG_ATTACK)

/obj/item/gun/magic/wand/do_suicide(mob/living/user)
	zap_self(user, suicide = TRUE)
	return FIRELOSS

/// Wand which kills people and heals skeletons
/obj/item/gun/magic/wand/death
	name = "死亡法杖"
	desc = "这支致命的魔杖用纯净的能量淹没受害者的身体，毫无疑问地杀死了他们。"
	school = SCHOOL_NECROMANCY
	fire_sound = 'sound/effects/magic/wandodeath.ogg'
	ammo_type = /obj/item/ammo_casing/magic/death
	icon_state = "deathwand"
	base_icon_state = "deathwand"
	max_charges = 3 //3, 2, 2, 1

/obj/item/gun/magic/wand/death/zap_self(mob/living/user, suicide = FALSE)
	. = ..()
	charges--
	if(user.can_block_magic())
		user.visible_message(span_warning("[src] 对 [user] 没有效果！"))
		return
	if(isliving(user))
		if(user.mob_biotypes & MOB_UNDEAD) //negative energy heals the undead
			user.revive(ADMIN_HEAL_ALL, force_grab_ghost = TRUE) // This heals suicides
			if (!suicide)
				to_chat(user, span_notice("你感觉棒极了！"))
			return
	to_chat(user, span_warning("You irradiate yourself with pure negative energy! \
	[pick("Do not pass go. Do not collect 200 zorkmids.","You feel more confident in your spell casting skills.","You die...","Do you want your possessions identified?")]"))
	user.death(FALSE)

/obj/item/gun/magic/wand/death/do_suicide(mob/living/user)
	. = ..()
	if (user.stat == DEAD)
		return MANUAL_SUICIDE
	user.visible_message(span_suicide("...但要说有什么变化的话，[user.p_they()] 看起来比以前更健康了。"))
	return SHAME

/obj/item/gun/magic/wand/death/debug
	desc = "在某些不太为人所知的圈子里，这被称为“克隆测试者的帮手”。"
	max_charges = 500
	variable_charges = FALSE
	self_charging = TRUE
	recharge_rate = 1


/// Wand which kills skeletons and heals people
/obj/item/gun/magic/wand/resurrection
	name = "治疗法杖"
	desc = "这根魔杖能施展治愈魔法来治疗和复活伤者。但由于某种原因，它在巫师联盟内部很少被使用。"
	school = SCHOOL_RESTORATION
	ammo_type = /obj/item/ammo_casing/magic/heal
	fire_sound = 'sound/effects/magic/staff_healing.ogg'
	icon_state = "revivewand"
	base_icon_state = "revivewand"
	max_charges = 10 //10, 5, 5, 4

/obj/item/gun/magic/wand/resurrection/zap_self(mob/living/user, suicide = FALSE)
	..()
	charges--
	if(user.can_block_magic())
		user.visible_message(span_warning("[src] 对 [user] 没有效果！"))
		return
	if(isliving(user))
		var/mob/living/L = user
		if(L.mob_biotypes & MOB_UNDEAD) //positive energy harms the undead
			to_chat(user, span_warning("You irradiate yourself with pure positive energy! \
			[pick("Do not pass go. Do not collect 200 zorkmids.","You feel more confident in your spell casting skills.","You die...","Do you want your possessions identified?")]"))
			user.investigate_log("has been killed by a bolt of resurrection.", INVESTIGATE_DEATHS)
			user.death(FALSE)
			return
	user.revive(ADMIN_HEAL_ALL, force_grab_ghost = TRUE) // This heals suicides
	if (!suicide)
		to_chat(user, span_notice("你感觉棒极了！"))

/obj/item/gun/magic/wand/resurrection/do_suicide(mob/living/user)
	. = ..()
	if (user.stat == DEAD)
		return MANUAL_SUICIDE
	user.visible_message(span_suicide("...但[user.p_they()]看起来反而比之前更健康了。"))
	return SHAME

/obj/item/gun/magic/wand/resurrection/debug //for testing
	desc = "有没有可能有些东西比普通的魔法还要强大呢？这根魔杖就是如此。"
	max_charges = 500
	variable_charges = FALSE
	self_charging = TRUE
	recharge_rate = 1

/// Wand which turns mobs into other mobs
/obj/item/gun/magic/wand/polymorph
	name = "变形法杖"
	desc = "这根魔杖与混沌之力相连接，它会彻底改变受害者的形态。"
	school = SCHOOL_TRANSMUTATION
	ammo_type = /obj/item/ammo_casing/magic/change
	icon_state = "polywand"
	base_icon_state = "polywand"
	fire_sound = 'sound/effects/magic/staff_change.ogg'
	max_charges = 10 //10, 5, 5, 4

/obj/item/gun/magic/wand/polymorph/zap_self(mob/living/user, suicide = FALSE)
	. = ..() //because the user mob ceases to exists by the time wabbajack fully resolves
	user.wabbajack()
	charges--

/obj/item/gun/magic/wand/polymorph/do_suicide(mob/living/user)
	var/static/list/corpse_types = list(
		/obj/effect/decal/cleanable/insectguts,
		/obj/item/food/deadmouse,
		/obj/item/trash/bee,
	)
	playsound(loc, fire_sound, 50, TRUE, -1)
	var/corpse_path = pick(corpse_types)
	var/atom/corpse = new corpse_path(user.drop_location())
	corpse.name = user.real_name
	user.unequip_everything()
	user.ghostize()
	qdel(user)
	return MANUAL_SUICIDE

/// Wand of go somewhere else
/obj/item/gun/magic/wand/teleport
	name = "传送法杖"
	desc = "这根法杖会扭曲目标的空间和时间，把他们移到其他地方。"
	school = SCHOOL_TRANSLOCATION
	ammo_type = /obj/item/ammo_casing/magic/teleport
	fire_sound = 'sound/effects/magic/wand_teleport.ogg'
	icon_state = "telewand"
	base_icon_state = "telewand"
	max_charges = 10 //10, 5, 5, 4
	no_den_usage = TRUE

/obj/item/gun/magic/wand/teleport/zap_self(mob/living/user, suicide = FALSE)
	if(do_teleport(user, user, 10, channel = TELEPORT_CHANNEL_MAGIC))
		do_smoke(3, src, user.loc)
		charges--
	return ..()

/obj/item/gun/magic/wand/teleport/do_suicide(mob/living/user)
	playsound(loc, fire_sound, 50, TRUE, -1)
	do_smoke(3, src, user.loc)
	if (!iscarbon(user))
		return SHAME

	var/mob/living/carbon/suicider = user
	var/obj/item/teleport_part = suicider.get_organ_slot(ORGAN_SLOT_BRAIN)
	if (!teleport_part)
		teleport_part = suicider.get_bodypart(BODY_ZONE_HEAD)
	if (!teleport_part)
		return SHAME

	var/turf/destination = user.drop_location() // Grab this first in case moving the brain out dusts you or something

	if (isorgan(teleport_part))
		var/obj/item/organ/brain = teleport_part
		brain.Remove(user, special = FALSE)
	else
		var/obj/item/bodypart/head = teleport_part
		head.dismember(BRUTE)

	teleport_part.forceMove(destination)
	do_teleport(teleport_part, destination, 10, channel = TELEPORT_CHANNEL_MAGIC)
	if (user.stat != DEAD)
		return SHAME
	return MANUAL_SUICIDE

/// Wand of go somewhere else which is safe-ish
/obj/item/gun/magic/wand/safety
	name = "安全传送法杖"
	desc = "这个法杖将使用最轻的蓝空电流轻轻地将目标放置在安全的地方。"
	school = SCHOOL_TRANSLOCATION
	ammo_type = /obj/item/ammo_casing/magic/safety
	fire_sound = 'sound/effects/magic/wand_teleport.ogg'
	icon_state = "telewand"
	base_icon_state = "telewand"
	max_charges = 10 //10, 5, 5, 4
	no_den_usage = FALSE

/obj/item/gun/magic/wand/safety/zap_self(mob/living/user, suicide = FALSE)
	var/turf/origin = get_turf(user)
	var/turf/destination = find_safe_turf(extended_safety_checks = TRUE)

	if(!do_teleport(user, destination, channel = TELEPORT_CHANNEL_MAGIC))
		return ..()

	for(var/turf/smoke_turf as anything in list(origin, destination))
		do_smoke(0, src, smoke_turf)
	return ..()

/obj/item/gun/magic/wand/safety/do_suicide(mob/living/user)
	. = ..()
	return SHAME // It's a safety wand sorry

/obj/item/gun/magic/wand/safety/debug
	desc = "这个魔杖的木头上刻着'find_safe_turf()'。也许这是一条秘密信息？"
	max_charges = 500
	variable_charges = FALSE
	self_charging = TRUE
	recharge_rate = 1


/// Wand of making doors
/obj/item/gun/magic/wand/door
	name = "任意门法杖"
	desc = "这种特殊的魔杖能够为那些不愿使用传送魔法的无良巫师在任何墙壁上制造出门洞。"
	school = SCHOOL_TRANSMUTATION
	ammo_type = /obj/item/ammo_casing/magic/door
	icon_state = "doorwand"
	base_icon_state = "doorwand"
	fire_sound = 'sound/effects/magic/staff_door.ogg'
	max_charges = 20 //20, 10, 10, 7
	no_den_usage = TRUE

/obj/item/gun/magic/wand/door/zap_self(mob/living/user, suicide = FALSE)
	to_chat(user, span_notice("你感觉对自己的情感稍微更开放了一些。"))
	charges--
	return ..()

/obj/item/gun/magic/wand/door/do_suicide(mob/living/user)
	if (!iscarbon(user))
		. = ..()
		var/static/list/shared_feelings = list(
			"I can't take it any more!!",
			"I can't do this any more!!",
			"I don't want to live in this world!!",
			"I wish I was dead!!",
			"Nothing matters to me any more!!",
			"Someone please kill me!!",
			"The pain is unbearable!!",
		)
		user.say(pick(shared_feelings), forced = "failed wand suicide")
		return SHAME
	playsound(loc, fire_sound, 50, TRUE, -1)
	var/mob/living/carbon/suicider = user
	var/obj/item/bodypart/chest = suicider.get_bodypart(BODY_ZONE_CHEST) // I think it's impossible not to have a chest so we'll just assume they have one
	user.visible_message(span_suicide("[user]的胸膛像门一样打开了！"))
	chest.dismember(BRUTE, silent = FALSE, wounding_type = WOUND_SLASH)
	return BRUTELOSS

/// Wand of blowing shit up
/obj/item/gun/magic/wand/fireball
	name = "火球法杖"
	desc = "这根魔杖射出灼热的火球，然后爆炸成毁灭性的火焰。"
	school = SCHOOL_EVOCATION
	fire_sound = 'sound/effects/magic/fireball.ogg'
	ammo_type = /obj/item/ammo_casing/magic/fireball
	icon_state = "firewand"
	base_icon_state = "firewand"
	max_charges = 8 //8, 4, 4, 3

/obj/item/gun/magic/wand/fireball/zap_self(mob/living/user, suicide = FALSE)
	..()
	explosion(user, devastation_range = -1, light_impact_range = 2, flame_range = 2, flash_range = 3, adminlog = FALSE, explosion_cause = src)
	charges--

/// Wand of doing fuck all
/obj/item/gun/magic/wand/nothing
	name = "废物法杖"
	desc = "这只是根棍子罢了，这难道是根魔杖？"
	ammo_type = /obj/item/ammo_casing/magic/nothing

//disabler wand
/obj/item/gun/magic/wand/disabler
	name = "wand of non harmful incapasitation"
	desc = "One of those magic wands you can buy from a costume vendor, this one however is not entirely useless, funny."
	ammo_type = /obj/item/ammo_casing/energy/disabler/smoothbore
	self_charging = TRUE


//real magic missile wand
/obj/item/gun/magic/wand/missile
	name = "wand of MISSILE"
	desc = "One of those magic wands you can buy from a costume vendor, this one however has a bunch of explosion/missile launcher stickers on it, its also obviously painted red."
	ammo_type = /obj/item/ammo_casing/rocket/heap
	color = "#FF0000"


//arrow wand
/obj/item/gun/magic/wand/arrow
	name = "AWSOME WAND OF BULLET MURDER"
	desc = "What the fuck? it looks like one of those wands that you buy from the costume vendor but it has a sticker on it that says 'AWSOME WAND OF BULLET MURDER'"
	ammo_type = /obj/item/ammo_casing/arrow


//20mm wand
/obj/item/gun/magic/wand/anti_tank
	name = "wand of tank shell"
	desc = "One of those magic wands you can buy from a costume vendor, this one reaks of gunpowder and has a different aura however, be careful where you aim this"
	ammo_type = /obj/item/ammo_casing/mm20x138
	self_charging = TRUE

/obj/item/gun/magic/wand/nothing/do_suicide(mob/living/user)
	. = ..()
	return SHAME

// Animating a nothing wand makes it into an animating wand (and also animates it)
/obj/item/gun/magic/wand/nothing/animate_atom_living(mob/living/owner)
	var/obj/item/gun/magic/wand/animate/animated_wand = new(loc)
	animated_wand.charges = charges
	animated_wand.name = name + "?"

	qdel(src)
	return animated_wand.animate_atom_living(owner)

/// Also wand of doing fuck all
/obj/item/gun/magic/wand/nothing/fake_resurrection
	name = "holy staff"
	desc = "It's just a fancy staff so that holy clerics and priests look cool. What? You didn't think someone would leave a REAL magic artifact with a snowman out in the cold, did you?"
	fire_sound = 'sound/effects/magic/staff_healing.ogg'
	icon_state = "revivewand"
	base_icon_state = "revivewand"
	ammo_type = /obj/item/ammo_casing/magic

/obj/item/gun/magic/wand/nothing/fake_resurrection/animate_atom_living(mob/living/owner)
	return new /mob/living/basic/mimic/copy/ranged(drop_location(), src, owner)

/// Wand of making things small
/obj/item/gun/magic/wand/shrink
	name = "缩小魔杖"
	desc = "感受那微小...又微小...头颅带来的小小恐怖吧！"
	ammo_type = /obj/item/ammo_casing/magic/shrink/wand
	icon_state = "shrinkwand"
	base_icon_state = "shrinkwand"
	fire_sound = 'sound/effects/magic/staff_shrink.ogg'
	max_charges = 10 //10, 5, 5, 4
	no_den_usage = TRUE
	w_class = WEIGHT_CLASS_TINY

/obj/item/gun/magic/wand/shrink/zap_self(mob/living/user, suicide = FALSE)
	to_chat(user, span_notice("世界变大了..."))
	charges--
	user.AddComponent(/datum/component/shrink, -1) // small forever
	return ..()

/obj/item/gun/magic/wand/shrink/do_suicide(mob/living/user)
	playsound(user, fire_sound, 50, TRUE)
	user.unequip_everything()
	user.visible_message(span_suicide("[user]缩小到无影无踪！"), span_suicide("你缩小到无影无踪！"))
	user.Stun(20 SECONDS, ignore_canstun = TRUE)
	user.set_suicide(TRUE)
	user.ghostize()
	animate(user, transform = matrix() * 0, time = 1 SECONDS)
	QDEL_IN(user, 1 SECONDS)
	return MANUAL_SUICIDE

// Wands of debugging

#ifdef TESTING

/obj/item/gun/magic/wand/antag
	name = "反派魔杖"
	desc = "这根魔杖运用胡扯的力量，能把任何被它击中的人变成反派"
	school = SCHOOL_FORBIDDEN
	ammo_type = /obj/item/ammo_casing/magic/antag
	icon_state = "revivewand"
	base_icon_state = "revivewand"
	color = COLOR_ADMIN_PINK
	max_charges = 99999

/obj/item/gun/magic/wand/antag/zap_self(mob/living/user, suicide = FALSE)
	. = ..()
	var/obj/item/ammo_casing/magic/antag/casing = new ammo_type()
	var/obj/projectile/magic/magic_proj = casing.projectile_type
	magic_proj = new magic_proj(src)
	magic_proj.on_hit(user)
	QDEL_NULL(casing)

/obj/item/ammo_casing/magic/antag
	projectile_type = /obj/projectile/magic/antag
	harmful = FALSE

/obj/projectile/magic/antag
	name = "反派之箭"
	icon_state = "ion"
	var/antag = /datum/antagonist/traitor

/obj/projectile/magic/antag/on_hit(atom/target, blocked, pierce_hit)
	. = ..()

	if(isliving(target))
		var/mob/living/victim = target
		if(isnull(victim.mind))
			victim.mind_initialize()
		if(victim.mind.has_antag_datum(antag))
			victim.mind.remove_antag_datum(antag)
			to_chat(world, "已移除")
		else
			victim.mind.add_antag_datum(antag)
			to_chat(world, "已添加")

/obj/item/gun/magic/wand/antag/heretic
	name = "反派异教徒魔杖"
	desc = "这根魔杖利用胡扯的力量，将任何被它击中的人变成反派异教徒。"
	color = COLOR_GREEN
	ammo_type = /obj/item/ammo_casing/magic/antag/heretic

/obj/item/ammo_casing/magic/antag/heretic
	projectile_type = /obj/projectile/magic/antag/heretic

/obj/projectile/magic/antag/heretic
	name = "反派异教徒魔弹"
	icon_state = "ion"
	antag = /datum/antagonist/heretic

/obj/item/gun/magic/wand/antag/cult
	name = "反派邪教徒魔杖"
	desc = "这根魔杖利用胡扯的力量，将任何被它击中的人变成反派邪教徒。"
	color = COLOR_CULT_RED
	ammo_type = /obj/item/ammo_casing/magic/antag/cult

/obj/item/ammo_casing/magic/antag/cult
	projectile_type = /obj/projectile/magic/antag/cult

/obj/projectile/magic/antag/cult
	name = "反派邪教魔弹"
	icon_state = "ion"
	antag = /datum/antagonist/cult

#endif
