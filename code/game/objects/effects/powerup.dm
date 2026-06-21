/obj/effect/powerup
	name = "启动"
	icon = 'icons/effects/effects.dmi'
	density = FALSE
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE
	/// How long in deciseconds it will take for the powerup to respawn, if no value it won't respawn
	var/respawn_time
	/// How long the powerup stays on the ground, if no value it will stay forever
	var/lifetime
	/// Message given when powerup is picked up
	var/pickup_message
	/// Sound played when powerup is picked up
	var/pickup_sound
	/// Cooldown for the powerup to respawn after it's been used
	COOLDOWN_DECLARE(respawn_cooldown)

/obj/effect/powerup/Initialize(mapload)
	. = ..()
	if(lifetime)
		QDEL_IN(src, lifetime)
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/effect/powerup/proc/on_entered(datum/source, atom/movable/movable_atom)
	SIGNAL_HANDLER
	trigger(movable_atom)

/obj/effect/powerup/Bump(atom/bumped_atom)
	trigger(bumped_atom)

/obj/effect/powerup/Bumped(atom/movable/movable_atom)
	trigger(movable_atom)

/// Triggers the effect of the powerup on the target, returns FALSE if the target is not /mob/living, is dead or the cooldown hasn't finished, returns TRUE otherwise
/obj/effect/powerup/proc/trigger(mob/living/target)
	if(!istype(target) || target.stat == DEAD)
		return FALSE
	if(respawn_time)
		if(!COOLDOWN_FINISHED(src, respawn_cooldown))
			return FALSE
		COOLDOWN_START(src, respawn_cooldown, respawn_time)
		alpha = 100
		addtimer(VARSET_CALLBACK(src, alpha, initial(alpha)), respawn_time)
	else
		qdel(src)
	if(pickup_message)
		to_chat(target, span_notice("[pickup_message]"))
	if(pickup_sound)
		playsound(get_turf(target), pickup_sound, 50, TRUE, -1)
	return TRUE

/obj/effect/powerup/health
	name = "健康拾取"
	desc = "来自天堂的祝福。"
	icon = 'icons/obj/storage/backpack.dmi'
	icon_state = "backpack-medical"
	respawn_time = 30 SECONDS
	pickup_message = "Health restored!"
	pickup_sound = 'sound/effects/magic/staff_healing.ogg'
	/// How much the pickup heals when picked up
	var/heal_amount = 50
	/// Does this pickup fully heal when picked up
	var/full_heal = FALSE
	/// If full heal, what flags do we pass?
	var/heal_flags = HEAL_ALL

/obj/effect/powerup/health/trigger(mob/living/target)
	. = ..()
	if(!.)
		return
	if(full_heal)
		target.fully_heal(heal_flags)
	else if(heal_amount)
		target.heal_ordered_damage(heal_amount, list(BRUTE, BURN))

/obj/effect/powerup/health/full
	name = "超级生命值拾取物"
	desc = "这就是我正要说的。"
	icon_state = "duffel-medical"
	full_heal = TRUE

/obj/effect/powerup/ammo
	name = "弹药捡取"
	desc = "你喜欢复仇对嘛？每个人都喜欢复仇！好吧，让我们去整点！"
	icon = 'icons/obj/storage/toolbox.dmi'
	icon_state = "ammobox"
	respawn_time = 30 SECONDS
	pickup_message = "Ammunition reloaded!"
	pickup_sound = 'sound/items/weapons/gun/shotgun/rack.ogg'

/obj/effect/powerup/ammo/trigger(mob/living/target)
	. = ..()
	if(!.)
		return
	for(var/obj/item/gun in target.get_all_contents())
		if(!isgun(gun) && !istype(gun, /obj/item/flamethrower))
			continue
		SEND_SIGNAL(gun, COMSIG_ITEM_RECHARGED)

/obj/effect/powerup/ammo/ctf
	icon = 'icons/effects/effects.dmi'
	icon_state = "at_shield1"
	respawn_time = FALSE
	lifetime = 30 SECONDS

/obj/effect/powerup/speed
	name = "闪电球"
	desc = "只是看着它你就觉得更快了。"
	icon_state = "speed"
	pickup_sound = 'sound/effects/magic/lightningshock.ogg'

/obj/effect/powerup/speed/trigger(mob/living/target)
	. = ..()
	if(!.)
		return
	target.apply_status_effect(/datum/status_effect/lightningorb)

/obj/effect/powerup/mayhem
	name = "混乱之球"
	desc = "光看它一眼，就让你愤怒不已。"
	icon_state = "impact_laser"

/obj/effect/powerup/mayhem/trigger(mob/living/target)
	. = ..()
	if(!.)
		return
	target.apply_status_effect(/datum/status_effect/mayhem)
