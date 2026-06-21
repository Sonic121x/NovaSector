/*!
 * Contains the baseline of kinetic crusher trophies.
 */

/obj/item/crusher_trophy
	name = "尾刺"
	desc = "一根用途不明的奇怪尖刺。"
	icon = 'icons/obj/mining_zones/artefacts.dmi'
	icon_state = "tail_spike"
	/// if it has a bonus effect, this is how much that effect is
	var/bonus_value = 10
	/// id of the trophy to be sent by the signal
	var/trophy_id
	/// what type of trophies will block this trophy from being added, must be overriden
	var/denied_type = /obj/item/crusher_trophy
	/// what item will drop if you cut it with wildhunter's knife
	var/wildhunter_drop = null

/obj/item/crusher_trophy/examine(mob/living/user)
	. = ..()
	. += span_notice("当安装到动能粉碎器上时，会触发[effect_desc()]效果。")

/// Returns a string to get added to the examine
/obj/item/crusher_trophy/proc/effect_desc()
	SHOULD_CALL_PARENT(FALSE)
	return "errors"

/// Tries to add the trophy to our crusher
/obj/item/crusher_trophy/proc/add_to(obj/item/kinetic_crusher/crusher, mob/living/user)
	for(var/obj/item/crusher_trophy/trophy as anything in crusher.trophies)
		if(istype(trophy, denied_type) || istype(src, trophy.denied_type))
			to_chat(user, span_warning("你似乎无法将[src]安装到[crusher]上。也许先移除几个战利品？"))
			return FALSE
	if(!user.transferItemToLoc(src, crusher))
		return
	crusher.trophies += src
	to_chat(user, span_notice("你将[src]安装到了[crusher]上。"))
	return TRUE

/// Removes the trophy from our crusher
/obj/item/crusher_trophy/proc/remove_from(obj/item/kinetic_crusher/crusher, mob/living/user)
	forceMove(get_turf(crusher))
	return TRUE

/// Does an effect when you hit a mob with a crusher
/obj/item/crusher_trophy/proc/on_melee_hit(mob/living/target, mob/living/user) //the target and the user
	return

/obj/item/crusher_trophy/proc/on_projectile_fire(obj/projectile/destabilizer/marker, mob/living/user) //the projectile fired and the user
	return

/// Does an effect when you hit a mob with the projectile
/obj/item/crusher_trophy/proc/on_projectile_hit_mob(mob/living/target, mob/living/user) //the target and the user
	return

/// Does an effect when you hit a mineral turf with the projectile
/obj/item/crusher_trophy/proc/on_projectile_hit_mineral(turf/closed/mineral, mob/living/user) //the target and the user
	return

/// Does an effect when you hit a mob that is marked via the projectile
/// Returns additional damage for detonation
/obj/item/crusher_trophy/proc/on_mark_detonation(mob/living/target, mob/living/user) //the target and the user
	SHOULD_CALL_PARENT(TRUE)
	//if we dont have a set id, use the typepath as identifier
	SEND_SIGNAL(target, COMSIG_MOB_TROPHY_ACTIVATED(trophy_id || type), src, user)
