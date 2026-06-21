// Resurrection crystal

/obj/item/resurrection_crystal
	name = "复活水晶"
	desc = "当任何持有者使用它时，若其死亡，此水晶将给予他们第二次生命的机会。"
	icon = 'icons/obj/mining.dmi'
	icon_state = "demonic_crystal"

/obj/item/resurrection_crystal/attack_self(mob/living/user)
	if(!iscarbon(user))
		to_chat(user, span_notice("一股黑暗的存在阻止你吸收水晶。"))
		return
	forceMove(user)
	to_chat(user, span_notice("你感觉安全了一些……但一个恶魔般的存在潜伏在你的脑海深处……"))
	RegisterSignal(user, COMSIG_LIVING_DEATH, PROC_REF(resurrect))

/// Resurrects the target when they die by moving them and dusting a clone in their place, one life for another
/obj/item/resurrection_crystal/proc/resurrect(mob/living/carbon/user, gibbed)
	SIGNAL_HANDLER
	if(gibbed)
		to_chat(user, span_notice("如果你的整个凡人之躯都被彻底湮灭，此力量将无法使用……"))
		return
	user.visible_message(span_notice("你看到 [user] 的灵魂被从他们的身体里拖了出来！"), span_notice("你感觉自己的灵魂被拖向一具崭新的躯体！"))
	var/typepath = user.type
	var/mob/living/carbon/clone = new typepath(user.loc)
	clone.real_name = user.real_name
	INVOKE_ASYNC(user.dna, TYPE_PROC_REF(/datum/dna, copy_dna), clone.dna, COPY_DNA_SE|COPY_DNA_SPECIES)
	clone.updateappearance(mutcolor_update=1)
	var/turf/T = find_maintenance_spawn(atmos_sensitive = TRUE, require_darkness = TRUE) || find_safe_turf()
	user.forceMove(T)
	user.revive(ADMIN_HEAL_ALL)
	INVOKE_ASYNC(user, TYPE_PROC_REF(/mob/living/carbon, set_species), /datum/species/shadow)
	to_chat(user, span_notice("你眨了眨眼，发现自己身处[get_area_name(T)]……感觉内心更阴暗了一些。"))
	clone.dust()
	qdel(src)

// Cursed boots

/obj/item/clothing/shoes/winterboots/ice_boots/ice_trail
	name = "受诅咒的冰地徒步靴"
	desc = "一双由魔鬼按契约制作的冬靴，一旦穿上就无法脱下。"
	actions_types = list(/datum/action/item_action/toggle)
	var/on = FALSE
	var/change_turf = /turf/open/misc/ice/icemoon/no_planet_atmos
	var/duration = 6 SECONDS

/obj/item/clothing/shoes/winterboots/ice_boots/ice_trail/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_SHOES_STEP_ACTION, PROC_REF(on_step))

/obj/item/clothing/shoes/winterboots/ice_boots/ice_trail/equipped(mob/user, slot)
	. = ..()
	if(slot & ITEM_SLOT_FEET)
		ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT(type))

/obj/item/clothing/shoes/winterboots/ice_boots/ice_trail/dropped(mob/user)
	. = ..()
	// Could have been blown off in an explosion from the previous owner
	REMOVE_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT(type))

/obj/item/clothing/shoes/winterboots/ice_boots/ice_trail/ui_action_click(mob/user)
	on = !on
	to_chat(user, span_notice("你 [on ? "activate" : "deactivate"] [src]。"))

/obj/item/clothing/shoes/winterboots/ice_boots/ice_trail/examine(mob/user)
	. = ..()
	. += span_notice("这双鞋 [on ? "enabled" : "disabled"]。")

/obj/item/clothing/shoes/winterboots/ice_boots/ice_trail/proc/on_step()
	SIGNAL_HANDLER

	var/turf/T = get_turf(loc)
	if(!on || isclosedturf(T) || istype(T, change_turf))
		return
	var/reset_turf = T.type
	T.ChangeTurf(change_turf, flags = CHANGETURF_INHERIT_AIR)
	addtimer(CALLBACK(T, TYPE_PROC_REF(/turf, ChangeTurf), reset_turf, null, CHANGETURF_INHERIT_AIR), duration, TIMER_OVERRIDE|TIMER_UNIQUE)

// Demonic jackhammer

/obj/item/pickaxe/drill/jackhammer/demonic
	name = "恶魔风镐"
	desc = "能以非人的速度凿开岩石，同时也为战斗目的进行了强化。"
	toolspeed = 0

/obj/item/pickaxe/drill/jackhammer/demonic/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/knockback, 4, TRUE, FALSE)
	AddElement(/datum/element/lifesteal, 5)

/obj/item/pickaxe/drill/jackhammer/demonic/use_tool(atom/target, mob/living/user, delay, amount=0, volume=0, datum/callback/extra_checks)
	var/turf/T = get_turf(target)
	mineral_scan_pulse(T, world.view + 1, src)
	. = ..()

// Ice energy crystal

/obj/item/ice_energy_crystal
	name = "冰能水晶"
	desc = "恶魔霜冻矿工冰之能量的残留物。"
	icon = 'icons/obj/mining_zones/artefacts.dmi'
	icon_state = "ice_crystal"
	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
