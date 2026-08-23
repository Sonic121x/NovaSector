// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/// How long it takes from the gunpoint is initiated to reach stage 2
#define GUNPOINT_DELAY_STAGE_2 (2.5 SECONDS)
/// How long it takes from stage 2 starting to move up to stage 3
#define GUNPOINT_DELAY_STAGE_3 (7.5 SECONDS)
/// If the projectile doesn't have a wound_bonus of CANT_WOUND, we add (this * the stage mult) to their wound_bonus and exposed_wound_bonus upon triggering
#define GUNPOINT_BASE_WOUND_BONUS 5
/// How much the damage and wound bonus mod is multiplied when you're on stage 1
#define GUNPOINT_MULT_STAGE_1 1.25
/// As above, for stage 2
#define GUNPOINT_MULT_STAGE_2 2
/// As above, for stage 3
#define GUNPOINT_MULT_STAGE_3 2.5


/datum/component/gunpoint
	dupe_mode = COMPONENT_DUPE_UNIQUE

	/// Who we're holding up
	var/mob/living/target
	/// The gun we're holding them up with
	var/obj/item/gun/weapon

	/// Which stage we're on
	var/stage = 1
	/// How much the damage and wound values will be multiplied by
	var/damage_mult = GUNPOINT_MULT_STAGE_1
	/// If TRUE, we're committed to firing the shot, for async purposes
	var/point_of_no_return = FALSE

// *extremely bad russian accent* no!
/datum/component/gunpoint/Initialize(mob/living/targ, obj/item/gun/wep)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	var/mob/living/shooter = parent
	target = targ
	weapon = wep

	RegisterSignals(targ, list(
		COMSIG_MOB_ATTACK_HAND,
		COMSIG_MOB_ITEM_ATTACK,
		COMSIG_MOVABLE_MOVED,
		COMSIG_MOB_FIRED_GUN,
		COMSIG_MOVABLE_SET_GRAB_STATE,
		COMSIG_LIVING_START_PULL), PROC_REF(trigger_reaction))
	RegisterSignal(targ, COMSIG_ATOM_EXAMINE, PROC_REF(examine_target))
	RegisterSignal(targ, COMSIG_LIVING_PRE_MOB_BUMP, PROC_REF(block_bumps_target))
	RegisterSignals(targ, list(COMSIG_LIVING_DISARM_HIT, COMSIG_LIVING_GET_PULLED), PROC_REF(cancel))
	RegisterSignals(weapon, list(COMSIG_ITEM_DROPPED, COMSIG_ITEM_EQUIPPED), PROC_REF(cancel))

	var/distance = max(get_dist(shooter, target), 1) // treat 0 distance as adjacent
	var/distance_description = (distance <= 1 ? "point blank " : "")

	shooter.visible_message(span_danger(LANG("datum.7833d4dc3af75be8", list(shooter, weapon, distance_description, target))),
		span_danger(LANG("datum.6a1af96dedc65de5", list(weapon, distance_description, target))), ignored_mobs = target)
	to_chat(target, span_userdanger(LANG("datum.75e558aaf0259be5", list(shooter, weapon, distance_description))))

	shooter.Immobilize(0.75 SECONDS / distance)
	if(!HAS_TRAIT(target, TRAIT_NOFEAR_HOLDUPS))
		target.Immobilize(0.75 SECONDS / distance)
		target.emote("gaspshock", intentional = FALSE)
		add_memory_in_range(target, 7, /datum/memory/held_at_gunpoint, protagonist = target, deuteragonist = shooter, antagonist = weapon)

	shooter.apply_status_effect(/datum/status_effect/holdup, shooter)
	target.apply_status_effect(/datum/status_effect/grouped/heldup, REF(shooter))
	target.do_alert_animation()
	target.playsound_local(target.loc, 'sound/machines/chime.ogg', 50, TRUE)
	target.add_mood_event("gunpoint", /datum/mood_event/gunpoint)

	if(istype(weapon, /obj/item/gun/ballistic/rocketlauncher) && weapon.chambered)
		if(!IS_UNCONSCIOUS_OR_CRIT(target) && IS_NUKE_OP(shooter) && !IS_NUKE_OP(target) && (locate(/obj/item/disk/nuclear) in target.get_contents()) && shooter.client)
			shooter.client.give_award(/datum/award/achievement/misc/rocket_holdup, shooter)

	addtimer(CALLBACK(src, PROC_REF(update_stage), 2), GUNPOINT_DELAY_STAGE_2)

/datum/component/gunpoint/Destroy(force)
	var/mob/living/shooter = parent
	shooter.remove_status_effect(/datum/status_effect/holdup)
	target.remove_status_effect(/datum/status_effect/grouped/heldup, REF(shooter))
	target.clear_mood_event("gunpoint")
	return ..()

/datum/component/gunpoint/RegisterWithParent()
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(check_deescalate))
	RegisterSignal(parent, COMSIG_MOB_APPLY_DAMAGE, PROC_REF(flinch))
	RegisterSignal(parent, COMSIG_MOB_ATTACK_HAND, PROC_REF(check_shove))
	RegisterSignal(parent, COMSIG_MOB_UPDATE_SIGHT, PROC_REF(check_deescalate))
	RegisterSignals(parent, list(COMSIG_LIVING_START_PULL, COMSIG_MOVABLE_BUMP), PROC_REF(check_bump))
	RegisterSignal(parent, COMSIG_ATOM_EXAMINE, PROC_REF(examine))
	RegisterSignal(parent, COMSIG_LIVING_PRE_MOB_BUMP, PROC_REF(block_bumps_parent))
	RegisterSignal(parent, COMSIG_LIVING_DISARM_HIT, PROC_REF(cancel))

/datum/component/gunpoint/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(parent, COMSIG_MOB_APPLY_DAMAGE)
	UnregisterSignal(parent, COMSIG_MOB_UPDATE_SIGHT)
	UnregisterSignal(parent, COMSIG_MOB_ATTACK_HAND)
	UnregisterSignal(parent, list(COMSIG_LIVING_START_PULL, COMSIG_MOVABLE_BUMP))
	UnregisterSignal(parent, COMSIG_ATOM_EXAMINE)
	UnregisterSignal(parent, COMSIG_LIVING_PRE_MOB_BUMP)
	UnregisterSignal(parent, COMSIG_LIVING_DISARM_HIT)

///If the shooter bumps the target, cancel the holdup to avoid cheesing and forcing the charged shot
/datum/component/gunpoint/proc/check_bump(atom/B, atom/A)
	SIGNAL_HANDLER

	if(A != target)
		return
	var/mob/living/shooter = parent
	shooter.visible_message(span_danger(LANG("datum.c34d9d9042b2587e", list(shooter, target, shooter.p_their()))), \
		span_danger(LANG("datum.fdd20516c5dbbe65", list(target))), ignored_mobs = target)
	to_chat(target, span_userdanger(LANG("datum.56f417cd92871f4f", list(shooter, shooter.p_their()))))
	qdel(src)

///If the shooter shoves or grabs the target, cancel the holdup to avoid cheesing and forcing the charged shot
/datum/component/gunpoint/proc/check_shove(mob/living/carbon/shooter, mob/shooter_again, mob/living/T, datum/martial_art/attacker_style, modifiers)
	SIGNAL_HANDLER

	if(T != target || LAZYACCESS(modifiers, RIGHT_CLICK))
		return
	shooter.visible_message(span_danger(LANG("datum.c34d9d9042b2587e", list(shooter, target, shooter.p_their()))), \
		span_danger(LANG("datum.fdd20516c5dbbe65", list(target))), ignored_mobs = target)
	to_chat(target, span_userdanger(LANG("datum.56f417cd92871f4f", list(shooter, shooter.p_their()))))
	qdel(src)

///Update the damage multiplier for whatever stage we're entering into
/datum/component/gunpoint/proc/update_stage(new_stage)
	if(check_deescalate())
		return
	stage = new_stage
	if(stage == 2)
		to_chat(parent, span_danger(LANG("datum.bd9c19f08392a9f2", list(weapon, target))))
		to_chat(target, span_userdanger(LANG("datum.9d556a32cda49bff", list(parent, weapon))))
		damage_mult = GUNPOINT_MULT_STAGE_2
		addtimer(CALLBACK(src, PROC_REF(update_stage), 3), GUNPOINT_DELAY_STAGE_3)
	else if(stage == 3)
		to_chat(parent, span_danger(LANG("datum.828cbbef400ef54a", list(weapon, target))))
		to_chat(target, span_userdanger(LANG("datum.20465151787f7da7", list(parent, weapon))))
		damage_mult = GUNPOINT_MULT_STAGE_3

///Cancel the holdup if the shooter moves out of sight or out of range of the target
/datum/component/gunpoint/proc/check_deescalate()
	SIGNAL_HANDLER

	if(!can_see(parent, target, GUNPOINT_SHOOTER_STRAY_RANGE))
		cancel()
		return TRUE

///Bang bang, we're firing a charged shot off
/datum/component/gunpoint/proc/trigger_reaction()
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(async_trigger_reaction))

/datum/component/gunpoint/proc/async_trigger_reaction()
	var/mob/living/shooter = parent
	shooter.remove_status_effect(/datum/status_effect/holdup) // try doing these before the trigger gets pulled since the target (or shooter even) may not exist after pulling the trigger, dig?
	target.remove_status_effect(/datum/status_effect/grouped/heldup, REF(shooter))
	target.clear_mood_event("gunpoint")

	if(point_of_no_return)
		return
	point_of_no_return = TRUE

	if(weapon.chambered && weapon.chambered.loaded_projectile)
		weapon.chambered.loaded_projectile.damage *= damage_mult
		if(weapon.chambered.loaded_projectile.wound_bonus != CANT_WOUND)
			weapon.chambered.loaded_projectile.wound_bonus += damage_mult * GUNPOINT_BASE_WOUND_BONUS
			weapon.chambered.loaded_projectile.exposed_wound_bonus += damage_mult * GUNPOINT_BASE_WOUND_BONUS

	var/fired = weapon.fire_gun(target, shooter)
	if(!fired && weapon.chambered?.loaded_projectile)
		weapon.chambered.loaded_projectile.damage /= damage_mult
		if(weapon.chambered.loaded_projectile.wound_bonus != CANT_WOUND)
			weapon.chambered.loaded_projectile.wound_bonus -= damage_mult * GUNPOINT_BASE_WOUND_BONUS
			weapon.chambered.loaded_projectile.exposed_wound_bonus -= damage_mult * GUNPOINT_BASE_WOUND_BONUS

	qdel(src)

///Shooter canceled their shot, either by dropping/equipping their weapon, leaving sight/range, or clicking on the alert
/datum/component/gunpoint/proc/cancel()
	SIGNAL_HANDLER

	var/mob/living/shooter = parent
	shooter.visible_message(span_danger(LANG("datum.fc37767760e34bc4", list(shooter, shooter.p_their(), target))), \
		span_danger(LANG("datum.96ac5fb7ad683fc8", list(weapon, target))), ignored_mobs = target)
	to_chat(target, span_userdanger(LANG("datum.c51526b30cc568a1", list(shooter, shooter.p_their()))))
	qdel(src)

///If the shooter is hit by an attack, they have a 50% chance to flinch and fire. If it hit the arm holding the trigger, it's an 80% chance to fire instead
/datum/component/gunpoint/proc/flinch(mob/living/source, damage_amount, damagetype, def_zone, blocked, wound_bonus, exposed_wound_bonus, sharpness, attack_direction, attacking_item)
	SIGNAL_HANDLER

	if(!attack_direction) // No fliching from yourself
		return

	var/flinch_chance = 50
	var/gun_hand = IS_LEFT_INDEX(source.get_held_index_of_item(weapon)) ? BODY_ZONE_L_ARM : BODY_ZONE_R_ARM

	if(isbodypart(def_zone))
		var/obj/item/bodypart/hitting = def_zone
		def_zone = hitting.body_zone

	if(def_zone == gun_hand)
		flinch_chance = 80

	if(prob(flinch_chance))
		source.visible_message(
			span_danger(LANG("datum.ab8ea3796ebd806a", list(source))),
			span_danger(LANG("datum.ae3f04e77b984409", null)),
		)
		INVOKE_ASYNC(src, PROC_REF(trigger_reaction))

///Shows if the parent is holding someone at gunpoint
/datum/component/gunpoint/proc/examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	if(user in viewers(target))
		examine_list += span_boldwarning(LANG("datum.13ef5812224b15da", list(parent, parent.p_are(), target, weapon)))

///Shows if the examine target is being held at gunpoint
/datum/component/gunpoint/proc/examine_target(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	if(user in viewers(parent))
		examine_list += span_boldwarning(LANG("datum.94725e2005bce593", list(target, target.p_are(), parent)))

///Prevents bumping the shooter to break gunpoint since shove does that
/datum/component/gunpoint/proc/block_bumps_parent(mob/bumped, mob/living/bumper)
	SIGNAL_HANDLER
	to_chat(bumper, span_warning(LANG("datum.3e08d9722dcd66f5", list(bumped, bumped.p_are(), target))))
	return COMPONENT_LIVING_BLOCK_PRE_MOB_BUMP

///Prevents bumping the target by an ally to cheese and force the charged shot
/datum/component/gunpoint/proc/block_bumps_target(mob/bumped, mob/living/bumper)
	SIGNAL_HANDLER
	to_chat(bumper, span_warning(LANG("datum.8b2a4a6e1525116f", list(bumped, bumped.p_are(), bumped.p_them()))))
	return COMPONENT_LIVING_BLOCK_PRE_MOB_BUMP

#undef GUNPOINT_DELAY_STAGE_2
#undef GUNPOINT_DELAY_STAGE_3
#undef GUNPOINT_BASE_WOUND_BONUS
#undef GUNPOINT_MULT_STAGE_1
#undef GUNPOINT_MULT_STAGE_2
#undef GUNPOINT_MULT_STAGE_3
