/obj/item/mine_bot_upgrade
	name = "矿工机器人近战升级"
	desc = "一个矿工机器人升级模块。"
	icon_state = "door_electronics"
	icon = 'icons/obj/devices/circuitry_n_data.dmi'
	item_flags = NOBLUDGEON

/obj/item/mine_bot_upgrade/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!istype(interacting_with, /mob/living/basic/mining_drone))
		return NONE
	upgrade_bot(interacting_with, user)
	return ITEM_INTERACT_SUCCESS

/obj/item/mine_bot_upgrade/proc/upgrade_bot(mob/living/basic/mining_drone/minebot, mob/user)
	if(minebot.melee_damage_upper != initial(minebot.melee_damage_upper))
		user.balloon_alert(user, "已有护甲！")
		return
	minebot.melee_damage_lower += 7
	minebot.melee_damage_upper += 7
	to_chat(user, span_notice("你增强了[minebot]的近战格斗能力。"))
	qdel(src)

//Health

/obj/item/mine_bot_upgrade/health
	name = "矿工机器人护甲升级"

/obj/item/mine_bot_upgrade/health/upgrade_bot(mob/living/basic/mining_drone/minebot, mob/user)
	if(minebot.maxHealth != initial(minebot.maxHealth))
		to_chat(user, span_warning("[minebot]已有强化护甲！"))
		return
	minebot.maxHealth += 45
	minebot.updatehealth()
	to_chat(user, span_notice("你强化了[minebot]的护甲。"))
	qdel(src)

//AI

/obj/item/slimepotion/sentience/mining
	name = "矿工机器人AI升级"
	desc = "可用于赋予矿工机器人感知能力。它与矿工机器人护甲和近战升级不兼容，并会覆盖它们。"
	icon_state = "door_electronics"
	icon = 'icons/obj/devices/circuitry_n_data.dmi'
	sentience_type = SENTIENCE_MINEBOT
	///health boost to add
	var/base_health_add = 5
	///damage boost to add
	var/base_damage_add = 1
	///speed boost to add
	var/base_speed_add = 1
	///cooldown boost to add
	var/base_cooldown_add = 10

/obj/item/slimepotion/sentience/mining/after_success(mob/living/user, mob/living/basic_mob)
	if(!istype(basic_mob, /mob/living/basic/mining_drone))
		return
	var/mob/living/basic/mining_drone/minebot = basic_mob
	minebot.maxHealth = initial(minebot.maxHealth) + base_health_add
	minebot.melee_damage_lower = initial(minebot.melee_damage_lower) + base_damage_add
	minebot.melee_damage_upper = initial(minebot.melee_damage_upper) + base_damage_add
	minebot.stored_gun?.recharge_time += base_cooldown_add

/obj/item/mine_bot_upgrade/regnerative_shield
	name = "再生护盾"
	desc = "让你的矿工机器人能承受多次攻击！"

/obj/item/mine_bot_upgrade/regnerative_shield/upgrade_bot(mob/living/basic/mining_drone/minebot, mob/user)
	if(HAS_TRAIT(minebot, TRAIT_REGEN_SHIELD))
		user.balloon_alert(minebot, "已拥有此功能！")
		return
	var/static/list/shield_layers = list(
		/obj/effect/overlay/minebot_top_shield,
		/obj/effect/overlay/minebot_bottom_shield
	)
	minebot.AddComponent(/datum/component/regenerative_shield, shield_overlays = shield_layers)
	qdel(src)

/obj/effect/overlay/minebot_top_shield
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	anchored = TRUE
	vis_flags = VIS_INHERIT_DIR | VIS_INHERIT_PLANE
	icon = 'icons/mob/silicon/aibots.dmi'
	icon_state = "minebot_shield_top_layer"
	layer = ABOVE_ALL_MOB_LAYER

/obj/effect/overlay/minebot_bottom_shield
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	anchored = TRUE
	vis_flags = VIS_INHERIT_DIR | VIS_INHERIT_PLANE
	icon = 'icons/mob/silicon/aibots.dmi'
	icon_state = "minebot_shield_bottom_layer"
	layer = BELOW_MOB_LAYER
