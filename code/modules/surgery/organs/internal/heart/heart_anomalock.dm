/*!
 * Contains Voltaic Combat Cyberheart
 */
#define DOAFTER_IMPLANTING_HEART "implanting"

/obj/item/organ/heart/cybernetic/anomalock
	name = "伏打战斗赛博心脏"
	desc = "一款尖端赛博心脏，最初为纳米传讯杀戮小队设计，后解密用于常规研究。伏打技术使心脏能在危急情况下维持身体站立，同时能重导异常通量能量，为用户提供完全的电击与电磁脉冲防护。需要一颗精炼的通量核心作为能源。"
	icon_state = "anomalock_heart"
	beat_noise = "an astonishing <b>BZZZ</b> of immense electrical power"
	bleed_prevention = TRUE
	toxification_probability = 0

	COOLDOWN_DECLARE(survival_cooldown)
	///Cooldown for the activation of the organ
	var/survival_cooldown_time = 5 MINUTES
	///The lightning effect on our mob when the implant is active
	var/mutable_appearance/lightning_overlay
	///how long the lightning lasts
	var/lightning_timer

	//---- Anomaly core variables:
	///The core item the organ runs off.
	var/obj/item/assembly/signaler/anomaly/core
	///Accepted types of anomaly cores.
	var/required_anomaly = /obj/item/assembly/signaler/anomaly/flux
	///If this one starts with a core in.
	var/prebuilt = FALSE
	///If the core is removable once socketed.
	var/core_removable = TRUE

/obj/item/organ/heart/cybernetic/anomalock/Destroy()
	if(lightning_timer)
		deltimer(lightning_timer)
	if(lightning_overlay)
		lightning_overlay = null
	QDEL_NULL(core)
	return ..()

/obj/item/organ/heart/cybernetic/anomalock/examine(mob/user)
	. = ..()
	. += span_info("伏打增强功能将完全避免治疗黏液基人形生物的毒素伤害，以防止有害副作用。")

/obj/item/organ/heart/cybernetic/anomalock/on_mob_insert(mob/living/carbon/organ_owner, special, movement_flags)
	. = ..()
	if(!core)
		return
	add_lightning_overlay(30 SECONDS)
	playsound(organ_owner, 'sound/items/eshield_recharge.ogg', 40)
	// organ_owner.AddElement(/datum/element/empprotection, EMP_PROTECT_SELF|EMP_PROTECT_CONTENTS|EMP_NO_EXAMINE) // NOVA EDIT REMOVAL
	RegisterSignal(organ_owner, SIGNAL_ADDTRAIT(TRAIT_CRITICAL_CONDITION), PROC_REF(activate_survival))
	RegisterSignal(organ_owner, COMSIG_ATOM_PRE_EMP_ACT, PROC_REF(on_emp_act)) // NOVA EDIT CHANGE - ORIGINAL: RegisterSignal(organ_owner, COMSIG_ATOM_EMP_ACT, PROC_REF(on_emp_act))

/obj/item/organ/heart/cybernetic/anomalock/on_mob_remove(mob/living/carbon/organ_owner, special, movement_flags)
	. = ..()
	if(!core)
		return
	clear_lightning_overlay(organ_owner)
	UnregisterSignal(organ_owner, SIGNAL_ADDTRAIT(TRAIT_CRITICAL_CONDITION))
	UnregisterSignal(organ_owner, COMSIG_ATOM_EMP_ACT)
	organ_owner.RemoveElement(/datum/element/empprotection, EMP_PROTECT_SELF|EMP_PROTECT_CONTENTS|EMP_NO_EXAMINE)
	tesla_zap(source = organ_owner, zap_range = 20, power = 2.5e5, cutoff = 1e3)
	// QDEL_IN(src, 0) // NOVA EDIT REMOVAL - no delete on removal

/* //NOVA EDIT REMOVAL - no self-implant (that only nearly kills you)
/obj/item/organ/heart/cybernetic/anomalock/attack(mob/living/target_mob, mob/living/user, list/modifiers, list/attack_modifiers)
	if(target_mob != user || !istype(target_mob) || !core)
		return ..()

	if(DOING_INTERACTION(user, DOAFTER_IMPLANTING_HEART))
		return
	user.balloon_alert(user, "this will hurt...")
	to_chat(user, span_userdanger("Black cyberveins tear your skin apart, pulling the heart into your ribcage. This feels unwise.."))
	if(!do_after(user, 5 SECONDS, interaction_key = DOAFTER_IMPLANTING_HEART))
		return ..()
	playsound(target_mob, 'sound/items/weapons/slice.ogg', 100, TRUE)
	user.temporarilyRemoveItemFromInventory(src, TRUE)
	Insert(user)
	user.apply_damage(100, BRUTE, BODY_ZONE_CHEST)
	user.emote("scream")
	return TRUE
*/ // NOVA EDIT REMOVAL END

/obj/item/organ/heart/cybernetic/anomalock/proc/on_emp_act(severity)
	SIGNAL_HANDLER
	add_lightning_overlay(10 SECONDS)
	// NOVA EDIT ADDITION START: EMP resistance handling moved to the status effect
	if(owner.has_status_effect(/datum/status_effect/voltaic_overdrive))
		var/datum/status_effect/voltaic_overdrive/our_drive = owner.has_status_effect(/datum/status_effect/voltaic_overdrive)
		if(our_drive.emp_resist)
			to_chat(owner, span_danger("你的伏打战斗赛博心脏因电磁脉冲而颤动！"))
			return EMP_PROTECT_ALL
	if(activate_survival(owner))
		to_chat(owner, span_userdanger("你的伏打战斗赛博心脏在胸腔内狂野地轰鸣，能量涌动以抵御电磁脉冲！"))
		return EMP_PROTECT_ALL
	to_chat(owner, span_danger("你的伏打战斗赛博心脏微弱地颤动，未能抵御电磁脉冲！"))
	// NOVA EDIT ADDITION END

/obj/item/organ/heart/cybernetic/anomalock/proc/add_lightning_overlay(time_to_last = 10 SECONDS)
	if(lightning_overlay)
		lightning_timer = addtimer(CALLBACK(src, PROC_REF(clear_lightning_overlay), owner), time_to_last, (TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_STOPPABLE|TIMER_DELETE_ME))
		return
	lightning_overlay = mutable_appearance(icon = 'icons/effects/effects.dmi', icon_state = "lightning")
	owner.add_overlay(lightning_overlay)
	lightning_timer = addtimer(CALLBACK(src, PROC_REF(clear_lightning_overlay), owner), time_to_last, (TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_STOPPABLE|TIMER_DELETE_ME))

/obj/item/organ/heart/cybernetic/anomalock/proc/clear_lightning_overlay(mob/organ_owner)
	organ_owner?.cut_overlay(lightning_overlay)
	if(lightning_timer)
		deltimer(lightning_timer)
	lightning_overlay = null

/* // NOVA EDIT REMOVAL START - no self-implant for you buddy
/obj/item/organ/heart/cybernetic/anomalock/attack_self(mob/user, modifiers)
	. = ..()
	if(.)
		return

	if(core)
		return attack(user, user, modifiers)
*/ // NOVA EDIT REMOVAL END

/obj/item/organ/heart/cybernetic/anomalock/on_life(seconds_per_tick)
	. = ..()
	if(!core)
		return

	owner.adjust_blood_volume(5 * seconds_per_tick, maximum = BLOOD_VOLUME_NORMAL)

	if(owner.health <= owner.crit_threshold)
		activate_survival(owner)

	if(SSmobs.times_fired % (1 SECONDS))
		return

	var/list/batteries = list()
	for(var/obj/item/stock_parts/power_store/cell in assoc_to_values(owner.get_all_cells()))
		if(cell.used_charge())
			batteries += cell

	if(!length(batteries))
		return

	var/obj/item/stock_parts/power_store/cell = pick(batteries)
	cell.give(cell.max_charge() * 0.1)

///Does a few things to try to help you live whatever you may be going through. Returns TRUE if it activated successfully.
/obj/item/organ/heart/cybernetic/anomalock/proc/activate_survival(mob/living/carbon/organ_owner)
	if(!COOLDOWN_FINISHED(src, survival_cooldown))
		return FALSE

	organ_owner.apply_status_effect(overdrive_type) // NOVA EDIT ORIGINAL - organ_owner.apply_status_effect(/datum/status_effect/voltaic_overdrive)
	add_lightning_overlay(30 SECONDS)
	COOLDOWN_START(src, survival_cooldown, survival_cooldown_time)
	addtimer(CALLBACK(src, PROC_REF(notify_cooldown), organ_owner), COOLDOWN_TIMELEFT(src, survival_cooldown))
	return TRUE

///Alerts our owner that the organ is ready to do its thing again
/obj/item/organ/heart/cybernetic/anomalock/proc/notify_cooldown(mob/living/carbon/organ_owner)
	balloon_alert(organ_owner, "你的心脏变得更强韧了")
	playsound(organ_owner, 'sound/items/eshield_recharge.ogg', 40)

/obj/item/organ/heart/cybernetic/anomalock/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, required_anomaly))
		return NONE
	if(core)
		balloon_alert(user, "核心已装入！")
		return ITEM_INTERACT_BLOCKING
	if(!user.transferItemToLoc(tool, src))
		return ITEM_INTERACT_BLOCKING
	core = tool
	balloon_alert(user, "核心已安装")
	playsound(src, 'sound/machines/click.ogg', 30, TRUE)
	add_organ_trait(TRAIT_SHOCKIMMUNE)
	update_icon_state()
	return ITEM_INTERACT_SUCCESS

/obj/item/organ/heart/cybernetic/anomalock/screwdriver_act(mob/living/user, obj/item/tool)
	. = ..()
	if(!core)
		balloon_alert(user, "没有核心！")
		return
	if(!core_removable)
		balloon_alert(user, "无法移除核心！")
		return
	balloon_alert(user, "正在移除核心...")
	if(!do_after(user, 3 SECONDS, target = src))
		balloon_alert(user, "被打断了！")
		return
	balloon_alert(user, "核心已移除")
	core.forceMove(drop_location())
	if(Adjacent(user) && !issilicon(user))
		user.put_in_hands(core)
	core = null
	remove_organ_trait(TRAIT_SHOCKIMMUNE)
	update_icon_state()

/obj/item/organ/heart/cybernetic/anomalock/update_icon_state()
	. = ..()
	icon_state = initial(icon_state) + (core ? "-core" : "")

/obj/item/organ/heart/cybernetic/anomalock/prebuilt/Initialize(mapload)
	. = ..()
	core = new /obj/item/assembly/signaler/anomaly/flux(src)
	add_organ_trait(TRAIT_SHOCKIMMUNE)
	update_icon_state()

/datum/status_effect/voltaic_overdrive
	id = "voltaic_overdrive"
	duration = 30 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/anomalock_active
	show_duration = TRUE
	processing_speed = STATUS_EFFECT_PRIORITY

/datum/status_effect/voltaic_overdrive/tick(seconds_between_ticks)
	. = ..()
	if(owner.health > owner.crit_threshold)
		return
	var/needs_update = FALSE
	needs_update += owner.heal_overall_damage(brute = 5, burn = 5, updating_health = FALSE)
	needs_update += owner.adjust_oxy_loss(-5, updating_health = FALSE)
	if(!HAS_TRAIT(owner, TRAIT_TOXINLOVER))
		needs_update += owner.adjust_tox_loss(-5, updating_health = FALSE)
	if(needs_update)
		owner.updatehealth()

/datum/status_effect/voltaic_overdrive/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_CARBON_LOSE_ORGAN, PROC_REF(on_organ_lost))
	owner.add_movespeed_mod_immunities(type, /datum/movespeed_modifier/damage_slowdown)
	REMOVE_TRAIT(src, TRAIT_CRITICAL_CONDITION, STAT_TRAIT)
	owner.reagents.add_reagent(/datum/reagent/medicine/coagulant, 5)
	owner.add_filter("emp_shield", 2, outline_filter(1, "#639BFF"))
	to_chat(owner, span_revendanger("你感到一股能量爆发！这是背水一战！"))
	owner.add_traits(list(TRAIT_NOSOFTCRIT, TRAIT_NOHARDCRIT, TRAIT_ANALGESIA), REF(src))

/datum/status_effect/voltaic_overdrive/on_remove()
	. = ..()
	UnregisterSignal(owner, COMSIG_CARBON_LOSE_ORGAN)
	owner.remove_movespeed_mod_immunities(type, /datum/movespeed_modifier/damage_slowdown)
	owner.remove_filter("emp_shield")
	owner.balloon_alert(owner, "你的心脏衰弱了")
	owner.remove_traits(list(TRAIT_NOSOFTCRIT, TRAIT_NOHARDCRIT, TRAIT_ANALGESIA), REF(src))

/// Called when an organ is lost in the owner. In the event the owner just lost their voltaic (presumably, the one giving this effect), ends the buff and clears the overlay.
/datum/status_effect/voltaic_overdrive/proc/on_organ_lost(mob/living/carbon/source, obj/item/organ/organ, special)
	SIGNAL_HANDLER
	if(istype(organ, /obj/item/organ/heart/cybernetic/anomalock))
		qdel(src)

/atom/movable/screen/alert/status_effect/anomalock_active
	name = "伏打过载"
	use_user_hud_icon = USER_HUD_STYLE_INHERIT
	overlay_state = "anomalock_heart"
	desc = "伏打能量正涌入你的肌肉，支撑着你的身体。你还有30秒时间，之后它就会失效！"

/obj/item/organ/heart/cybernetic/anomalock/hear_beat_noise(mob/living/hearer)
	if(prob(1))
		to_chat(hearer, span_danger("是啊。把金属盘按在一个活生生的电弧闪络危险源胸口上。看看会有什么后果。")) //the guy is LITERALLY sparking like a tesla coil.
	else
		to_chat(hearer, span_danger("一道电弧击中了你的听诊器，传导到你身上！"))
	if(hearer.electrocute_act(15, "stethoscope", flags = SHOCK_NOGLOVES)) //the stethoscope is in your ears. (returns true if it does damage so we only scream in that case)
		hearer.emote("scream")
	return span_danger("[owner.p_Their()] 心脏发出 [beat_noise]。")

#undef DOAFTER_IMPLANTING_HEART
