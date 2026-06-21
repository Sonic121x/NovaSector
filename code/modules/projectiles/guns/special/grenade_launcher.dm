/obj/item/gun/grenadelauncher
	name = "pneumatic grenade launcher"
	desc = "一件极其糟糕的事情。真是太糟糕了！"
	icon = 'icons/obj/weapons/guns/ballistic.dmi'
	icon_state = "riotgun"
	inhand_icon_state = "riotgun"
	w_class = WEIGHT_CLASS_BULKY
	can_muzzle_flash = FALSE
	throw_speed = 2
	throw_range = 7
	force = 5
	var/list/grenades = new/list()
	var/max_grenades = 3
	custom_materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT)

/obj/item/gun/grenadelauncher/examine(mob/user)
	. = ..()
	. += "[grenades.len] / [max_grenades] grenades loaded."

/obj/item/gun/grenadelauncher/apply_fantasy_bonuses(bonus)
	. = ..()
	max_grenades = modify_fantasy_variable("max_syringes", max_grenades, bonus, minimum = 1)

/obj/item/gun/grenadelauncher/remove_fantasy_bonuses(bonus)
	max_grenades = reset_fantasy_variable("max_syringes", max_grenades)
	return ..()

/obj/item/gun/grenadelauncher/attackby(obj/item/I, mob/user, list/modifiers, list/attack_modifiers)

	if(istype(I, /obj/item/grenade/c4))
		return
	if((isgrenade(I)))
		if(grenades.len < max_grenades)
			if(!user.transferItemToLoc(I, src))
				return
			grenades += I
			balloon_alert(user, "已装载 [grenades.len] / [max_grenades] 枚榴弹")
		else
			balloon_alert(user, "已经装满了！")

/obj/item/gun/grenadelauncher/can_shoot()
	return grenades.len

/obj/item/gun/grenadelauncher/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	user.visible_message(span_danger("[user]发射了一枚手榴弹！"), \
						span_danger("你发射了榴弹发射器！"))
	var/obj/item/grenade/F = grenades[1] //Now with less copypasta!
	grenades -= F
	F.forceMove(user.loc)
	F.throw_at(target, 30, 2, user)
	message_admins("[ADMIN_LOOKUPFLW(user)] fired a grenade ([F.name]) from a grenade launcher ([src]) from [AREACOORD(user)] at [target] [AREACOORD(target)].")
	user.log_message("fired a grenade ([F.name]) with a grenade launcher ([src]) from [AREACOORD(user)] at [target] [AREACOORD(target)].", LOG_GAME)
	user.log_message("fired a grenade ([F.name]) with a grenade launcher ([src]) from [AREACOORD(user)] at [target] [AREACOORD(target)].", LOG_ATTACK, log_globally = FALSE)
	F.active = 1
	F.icon_state = initial(F.icon_state) + "_active"
	playsound(user.loc, 'sound/items/weapons/armbomb.ogg', 75, TRUE, -3)
	addtimer(CALLBACK(F, TYPE_PROC_REF(/obj/item/grenade, detonate)), 1.5 SECONDS)
	return TRUE
