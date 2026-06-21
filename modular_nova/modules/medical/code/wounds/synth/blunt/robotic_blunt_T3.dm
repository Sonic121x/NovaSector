/datum/wound/blunt/robotic/secures_internals/critical
	name = "上层结构塌陷"
	desc = "上层结构在一处或多处位置完全塌陷，导致每次移动时内部剧烈振荡及肢体功能严重障碍。"
	treat_text_short = "Repair surgically, start by superheating the limb until you can mold it by aggressively grabbing it and follow the tier 2 wound instructions \
		when it's done, use gauze to reduce negative effects."
	treat_text = "Reforming of superstructure via either RCD or manual molding, followed by typical treatment of loosened internals. \
				To manually mold, the limb must be aggressively grabbed and welded held to it to make it malleable (though attacking it til thermal overload may be adequate) \
				followed by firmly grasping and molding the limb with heat-resistant gloves."
	occur_text = "caves in on itself, damaged solder and shrapnel flying out in a miniature explosion"
	examine_desc = "has caved in, with internal components visible through gaps in the metal"
	severity = WOUND_SEVERITY_CRITICAL

	disabling = TRUE

	simple_treat_text = "If on the <b>chest</b>, <b>walk</b>, <b>grasp it</b>, <b>splint</b>, <b>rest</b> or <b>buckle yourself</b> to something to reduce movement effects. \
	Afterwards, get someone, ideally a <b>robo/engi</b> to <b>firmly grasp</b> the limb and hold a <b>welder</b> to it. Then, have them <b>use their hands</b> to <b>mold the metal</b> - \
	careful though, it's <b>hot</b>! An <b>RCD</b> can skip all this, but is hard to come by. Afterwards, have them <b>screw/wrench</b> and then <b>re-solder</b> the limb!"

	homemade_treat_text = "The metal can be made <b>malleable</b> by repeated application of a welder, to a <b>severe burn</b>. Afterwards, a <b>plunger</b> can reset the metal, \
	as can <b>percussive maintenance</b>. After the metal is reset, if <b>unable to screw/wrench</b>, <b>bone gel</b> can, over time, secure inner components at risk of <b>corrossion</b>. \
	Alternatively, <b>crowbar</b> the limb open to expose the internals - this will make it <b>easier</b> to re-secure them, but has a <b>high risk</b> of <b>shocking</b> you, \
	so use insulated gloves. This will <b>cripple the limb</b>, so use it only as a last resort!"

	interaction_efficiency_penalty = 2.8
	limp_slowdown = 8
	limp_chance = 80
	threshold_penalty = 60

	brain_trauma_group = BRAIN_TRAUMA_SEVERE
	trauma_cycle_cooldown = 2.5 MINUTES

	scar_keyword = "bluntcritical"

	status_effect_type = /datum/status_effect/wound/blunt/robotic/critical

	sound_effect = 'sound/effects/wounds/crack2.ogg'

	wound_flags = (ACCEPTS_GAUZE|MANGLES_EXTERIOR|SPLINT_OVERLAY|CAN_BE_GRASPED)
	treatable_by = list(/obj/item/stack/medical/bone_gel)
	status_effect_type = /datum/status_effect/wound/blunt/robotic/critical
	treatable_tools = list(TOOL_WELDER, TOOL_CROWBAR)

	base_movement_stagger_score = 50

	base_aftershock_camera_shake_duration = 1.75 SECONDS
	base_aftershock_camera_shake_strength = 1

	chest_attacked_stagger_chance_ratio = 6.5
	chest_attacked_stagger_mult = 4

	chest_movement_stagger_chance = 8

	aftershock_stopped_moving_score_mult = 0.3

	stagger_aftershock_knockdown_ratio = 0.5
	stagger_aftershock_knockdown_movement_ratio = 0.3

	percussive_maintenance_repair_chance = 3
	percussive_maintenance_damage_max = 6

	regen_time_needed = 60 SECONDS
	gel_damage = 20

	ready_to_secure_internals = FALSE
	ready_to_resolder = FALSE

	a_or_from = "a"

	/// Has the first stage of our treatment been completed? E.g. RCDed, manually molded...
	var/superstructure_remedied = FALSE

/datum/wound_pregen_data/blunt_metal/superstructure
	abstract = FALSE
	wound_path_to_generate = /datum/wound/blunt/robotic/secures_internals/critical
	threshold_minimum = 125

/datum/wound/blunt/robotic/secures_internals/critical/item_can_treat(obj/item/potential_treater)
	if(!superstructure_remedied)
		if(istype(potential_treater, /obj/item/construction/rcd))
			return TRUE
		if(limb_malleable() && istype(potential_treater, /obj/item/plunger))
			return TRUE
	return ..()

/datum/wound/blunt/robotic/secures_internals/critical/check_grab_treatments(obj/item/potential_treater, mob/user)
	if(potential_treater.tool_behaviour == TOOL_WELDER && (!superstructure_remedied && !limb_malleable()))
		return TRUE
	return ..()

/datum/wound/blunt/robotic/secures_internals/critical/treat(obj/item/item, mob/user)
	if(!superstructure_remedied)
		if(istype(item, /obj/item/construction/rcd))
			return rcd_superstructure(item, user)
		if(uses_percussive_maintenance() && istype(item, /obj/item/plunger))
			return plunge(item, user)
		if(item.tool_behaviour == TOOL_WELDER && !limb_malleable() && isliving(victim.pulledby))
			var/mob/living/living_puller = victim.pulledby
			if (living_puller.grab_state >= GRAB_AGGRESSIVE) // only let other people do this
				return heat_metal(item, user)
	return ..()

/datum/wound/blunt/robotic/secures_internals/critical/try_handling(mob/living/carbon/human/user)
	if(user.pulling != victim || user.zone_selected != limb.body_zone)
		return FALSE

	if(superstructure_remedied || !limb_malleable())
		return FALSE

	if(user.grab_state < GRAB_AGGRESSIVE)
		to_chat(user, span_warning("你必须以强制抓握控制[victim]才能操作[victim.p_their()]的[LOWER_TEXT(name)]！"))
		return TRUE

	user.visible_message(span_danger("[user]开始轻轻按压[victim]塌陷的[limb.plaintext_zone]..."), \
	span_notice("你开始轻轻按压[victim]塌陷的[limb.plaintext_zone]..."), \
	ignored_mobs = victim)
	to_chat(victim, span_userdanger("[user]开始按压你塌陷的[limb.plaintext_zone]！"))

	var/delay_mult = 1
	if (HAS_TRAIT(src, TRAIT_WOUND_SCANNED))
		delay_mult *= 0.75

	if(!do_after(user, 4 SECONDS, target = victim, extra_checks = CALLBACK(src, PROC_REF(still_exists))))
		return
	mold_metal(user)
	return TRUE

/// If the user turns combat mode on after they start to mold metal, our limb takes this much brute damage.
#define MOLD_METAL_SABOTAGE_BRUTE_DAMAGE 30 // really punishing
/// Our limb takes this much brute damage on a failed mold metal attempt.
#define MOLD_METAL_FAILURE_BRUTE_DAMAGE 5
/// If the user's hand is unprotected from heat when they mold metal, we do this much burn damage to it.
#define MOLD_METAL_HAND_BURNT_BURN_DAMAGE 5
/// Gloves must be above or at this threshold to cause the user to not be burnt apon trying to mold metal.
#define MOLD_METAL_HEAT_RESISTANCE_THRESHOLD 1000 // less than the black gloves max resist
/**
 * Standard treatment for 1st step of T3, after the limb has been made malleable. Done via aggrograb.
 * High chance to work, very high with robo/engi wires and diag hud.
 * Can be sabotaged by switching to combat mode.
 * Deals brute to the limb on failure.
 * Burns the hand of the user if it's not insulated.
 */
/datum/wound/blunt/robotic/secures_internals/critical/proc/mold_metal(mob/living/carbon/human/user)
	var/chance = 60

	var/knows_wires = FALSE
	if (HAS_TRAIT(user, TRAIT_KNOW_ROBO_WIRES))
		chance *= 2
		knows_wires = TRUE
	else if (HAS_TRAIT(user, TRAIT_KNOW_ENGI_WIRES))
		chance *= 1.25
		knows_wires = TRUE
	if (HAS_TRAIT(src, TRAIT_WOUND_SCANNED))
		chance *= 2
	if (HAS_TRAIT(user, TRAIT_DIAGNOSTIC_HUD))
		if (knows_wires)
			chance *= 1.25
		else
			chance *= 2

	var/their_or_other = (user == victim ? "[user.p_their()]" : "[victim]'s")
	var/your_or_other = (user == victim ? "your" : "[victim]'s")

	if ((user != victim && user.combat_mode))
		user.visible_message(span_bolddanger("[user]把[their_or_other]的[limb.plaintext_zone]捏成了一个非常滑稽的形状！真是个活宝！"), \
			span_danger("你恶意地将[victim]的[limb.plaintext_zone]捏成一个奇怪的形状，在此过程中对其造成了损伤！"), ignored_mobs = victim)
		to_chat(victim, span_userdanger("[user]把你的[limb.plaintext_zone]捏成了一个奇怪的形状，在此过程中对其造成了损伤！"))

		limb.receive_damage(brute = MOLD_METAL_SABOTAGE_BRUTE_DAMAGE, wound_bonus = CANT_WOUND, damage_source = user)
	else if (prob(chance))
		user.visible_message(span_green("[user]小心地将[their_or_other]的[limb.plaintext_zone]塑造成正确的形状！"), \
			span_green("你小心地将[victim]的[limb.plaintext_zone]塑造成正确的形状！"), ignored_mobs = victim)
		to_chat(victim, span_green("[user]小心地将你的[limb.plaintext_zone]塑造成正确的形状！"))
		to_chat(user, span_green("[capitalize(your_or_other)]的[limb.plaintext_zone]已被塑造成正确的形状！下一步是使用螺丝刀/扳手来固定内部组件。"))
		set_superstructure_status(TRUE)
	else
		user.visible_message(span_danger("[user]不小心把[their_or_other]的[limb.plaintext_zone]塑造成了错误的形状！"), \
			span_danger("你不小心把[your_or_other]的[limb.plaintext_zone]塑造成了错误的形状！"), ignored_mobs = victim)
		to_chat(victim, span_userdanger("[user]不小心把你的[limb.plaintext_zone]塑造成了错误的形状！"))

		limb.receive_damage(brute = MOLD_METAL_FAILURE_BRUTE_DAMAGE, damage_source = user, wound_bonus = CANT_WOUND)

	var/sufficiently_insulated_gloves = FALSE
	var/obj/item/clothing/gloves/worn_gloves = user.gloves
	if ((worn_gloves?.heat_protection & HANDS) && worn_gloves?.max_heat_protection_temperature && worn_gloves.max_heat_protection_temperature >= MOLD_METAL_HEAT_RESISTANCE_THRESHOLD)
		sufficiently_insulated_gloves = TRUE

	if (sufficiently_insulated_gloves || HAS_TRAIT(user, TRAIT_RESISTHEAT) || HAS_TRAIT(user, TRAIT_RESISTHEATHANDS))
		return

	to_chat(user, span_danger("你的手被[victim]的[limb.plaintext_zone]烫伤了！"))
	var/obj/item/bodypart/affecting = user.get_bodypart("[(user.active_hand_index % 2 == 0) ? "r" : "l" ]_arm")
	affecting?.receive_damage(burn = MOLD_METAL_HAND_BURNT_BURN_DAMAGE, damage_source = limb)

#undef MOLD_METAL_SABOTAGE_BRUTE_DAMAGE
#undef MOLD_METAL_FAILURE_BRUTE_DAMAGE
#undef MOLD_METAL_HAND_BURNT_BURN_DAMAGE
#undef MOLD_METAL_HEAT_RESISTANCE_THRESHOLD

/**
 * A "safe" way to give our victim a T2 burn wound. Requires an aggrograb, and a welder. This is required to mold metal, the 1st step of treatment.
 * Guaranteed to work. After a delay, causes a T2 burn wound with no damage.
 * Can be sabotaged by enabling combat mode to cause a T3.
 */
/datum/wound/blunt/robotic/secures_internals/critical/proc/heat_metal(obj/item/welder, mob/living/user)
	if (!welder.tool_use_check())
		return TRUE

	var/their_or_other = (user == victim ? "[user.p_their()]" : "[victim]'s")
	var/your_or_other = (user == victim ? "your" : "[victim]'s")

	user?.visible_message(span_danger("[user]小心地将[welder]对准[their_or_other]的[limb.plaintext_zone]，慢慢加热它..."), \
		span_warning("你小心地将[welder]对准[your_or_other]的[limb.plaintext_zone]，慢慢加热它..."), ignored_mobs = victim)

	var/delay_mult = 1
	if (HAS_TRAIT(src, TRAIT_WOUND_SCANNED))
		delay_mult *= 0.75

	if (!welder.use_tool(target = victim, user = user, delay = 3 SECONDS * delay_mult, volume = 50, extra_checks = CALLBACK(src, PROC_REF(still_exists))))
		return TRUE

	var/wound_path = /datum/wound/burn/robotic/overheat/moderate
	if (user != victim && user.combat_mode)
		wound_path = /datum/wound/burn/robotic/overheat/critical // it really isnt that bad, overheat wounds are a bit funky
		user.visible_message(span_danger("[user]猛烈地加热[victim]的[limb.plaintext_zone]，使其温度远超必要点！"), \
			span_danger("你猛烈地加热[victim]的[limb.plaintext_zone]，使其温度远超必要点！"), ignored_mobs = victim)
		to_chat(victim, span_userdanger("[user]猛烈地加热你的[limb.plaintext_zone]，使其温度远超必要点！"))

	var/datum/wound/burn/robotic/overheat/overheat_wound = new wound_path
	overheat_wound.apply_wound(limb, wound_source = welder)

	to_chat(user, span_green("[capitalize(your_or_other)]的[limb.plaintext_zone]现在已加热，可以进行塑形了！下一步是让某人用手物理重置其超结构。"))
	return TRUE

/// Cost of an RCD to quickly fix our broken in raw matter
#define ROBOTIC_T3_BLUNT_WOUND_RCD_COST 25
/// Cost of an RCD to quickly fix our broken in silo material
#define ROBOTIC_T3_BLUNT_WOUND_RCD_SILO_COST ROBOTIC_T3_BLUNT_WOUND_RCD_COST / 4

/// The "premium" treatment for 1st step of T3. Requires an RCD. Guaranteed to work, but can cause damage if delay is high.
/datum/wound/blunt/robotic/secures_internals/critical/proc/rcd_superstructure(obj/item/construction/rcd/treating_rcd, mob/user)
	if (!treating_rcd.tool_use_check())
		return TRUE

	var/has_enough_matter = (treating_rcd.get_matter(user) > ROBOTIC_T3_BLUNT_WOUND_RCD_COST)
	var/silo_has_enough_materials = (treating_rcd.get_silo_iron() > ROBOTIC_T3_BLUNT_WOUND_RCD_SILO_COST)

	if (!silo_has_enough_materials && !has_enough_matter) // neither the silo, nor the rcd, has enough
		user?.balloon_alert(user, "物质不足！")
		return TRUE

	var/their_or_other = (user == victim ? "[user.p_their()]" : "[victim]'s")
	var/your_or_other = (user == victim ? "your" : "[victim]'s")

	var/base_time = 7 SECONDS
	var/delay_mult = 1
	var/knows_wires = FALSE
	if (victim == user)
		delay_mult *= 2
	if (HAS_TRAIT(src, TRAIT_WOUND_SCANNED))
		delay_mult *= 0.75
	if (HAS_TRAIT(user, TRAIT_KNOW_ROBO_WIRES))
		delay_mult *= 0.5
		knows_wires = TRUE
	else if (HAS_TRAIT(user, TRAIT_KNOW_ENGI_WIRES))
		delay_mult *= 0.5 // engis are accustomed to using RCDs
		knows_wires = TRUE
	if (HAS_TRAIT(user, TRAIT_DIAGNOSTIC_HUD))
		if (knows_wires)
			delay_mult *= 0.85
		else
			delay_mult *= 0.5

	var/final_time = (base_time * delay_mult)
	var/misused = (final_time > base_time) // if we damage the limb when we're done

	if (user)
		var/misused_text = (misused ? "<b>unsteadily</b> " : "")

		var/message = "[user]'s RCD whirs to life as it begins [misused_text]replacing the damaged superstructure of [their_or_other] [limb.plaintext_zone]..."
		var/self_message = "Your RCD whirs to life as it begins [misused_text]replacing the damaged superstructure of [your_or_other] [limb.plaintext_zone]..."

		if (misused) // warning span if misused, notice span otherwise
			message = span_danger(message)
			self_message = span_danger(self_message)
		else
			message = span_notice(message)
			self_message = span_notice(self_message)

		user.visible_message(message, self_message)

	if (!treating_rcd.use_tool(target = victim, user = user, delay = final_time, volume = 50, extra_checks = CALLBACK(src, PROC_REF(still_exists))))
		return TRUE
	playsound(get_turf(treating_rcd), 'sound/machines/ping.ogg', 75) // celebration! we did it
	set_superstructure_status(TRUE)

	var/use_amount = (silo_has_enough_materials ? ROBOTIC_T3_BLUNT_WOUND_RCD_SILO_COST : ROBOTIC_T3_BLUNT_WOUND_RCD_COST)
	if (!treating_rcd.useResource(use_amount, user))
		return TRUE

	if (user)
		var/misused_text = (misused ? ", though it replaced a bit more than it should've..." : "!")
		var/message = "[user]'s RCD lets out a small ping as it finishes replacing the superstructure of [their_or_other] [limb.plaintext_zone][misused_text]"
		var/self_message = "Your RCD lets out a small ping as it finishes replacing the superstructure of [your_or_other] [limb.plaintext_zone][misused_text]"
		if (misused)
			message = span_danger(message)
			self_message = span_danger(self_message)
		else
			message = span_green(message)
			self_message = span_green(self_message)

		user.visible_message(message, self_message)
		if (misused)
			limb.receive_damage(brute = 10, damage_source = treating_rcd, wound_bonus = CANT_WOUND)
		// the double message is fine here, since the first message also tells you if you fucked up and did some damage
		to_chat(user, span_green("超结构已重塑完成！下一步是通过螺丝刀/扳手固定内部结构。"))
	return TRUE

#undef ROBOTIC_T3_BLUNT_WOUND_RCD_COST
#undef ROBOTIC_T3_BLUNT_WOUND_RCD_SILO_COST

/**
 * Goofy but practical, this is the superior ghetto self-tend of T3's first step compared to percussive maintenance.
 * Still requires the limb to be malleable, but has a high chance of success and doesn't burn your hand, but gives worse bonuses for wires/HUD.
 */
/datum/wound/blunt/robotic/secures_internals/critical/proc/plunge(obj/item/plunger/treating_plunger, mob/user)
	if (!treating_plunger.tool_use_check())
		return TRUE

	var/their_or_other = (user == victim ? "[user.p_their()]" : "[victim]'s")
	var/your_or_other = (user == victim ? "your" : "[victim]'s")
	user?.visible_message(span_notice("[user]开始用[treating_plunger]对[their_or_other]的[limb.plaintext_zone]上的凹痕进行抽吸..."), \
		span_green("你开始用[treating_plunger]对[your_or_other]的[limb.plaintext_zone]上的凹痕进行抽吸..."))

	var/delay_mult = 1
	if (HAS_TRAIT(src, TRAIT_WOUND_SCANNED))
		delay_mult *= 0.75

	delay_mult /= treating_plunger.plunge_mod

	if (!treating_plunger.use_tool(target = victim, user = user, delay = 6 SECONDS * delay_mult, volume = 50, extra_checks = CALLBACK(src, PROC_REF(still_exists))))
		return TRUE

	var/success_chance = 80
	if (victim == user)
		success_chance *= 0.6

	if (HAS_TRAIT(user, TRAIT_KNOW_ROBO_WIRES))
		success_chance *= 1.25
	else if (HAS_TRAIT(user, TRAIT_KNOW_ENGI_WIRES))
		success_chance *= 1.1
	if (HAS_TRAIT(user, TRAIT_DIAGNOSTIC_HUD))
		success_chance *= 1.25 // it's kinda alien to do this, so even people with the wires get the full bonus of diag huds
	if (HAS_TRAIT(src, TRAIT_WOUND_SCANNED))
		success_chance *= 1.5

	if (prob(success_chance))
		user?.visible_message(span_green("[victim]的[limb.plaintext_zone]随着[treating_plunger]将其推回正常位置而发出一声尖锐的“砰”响！"), \
			span_green("[victim]的[limb.plaintext_zone]随着你的[treating_plunger]将其推回正常位置而发出一声尖锐的“砰”响！"))
		to_chat(user, span_green("[capitalize(your_or_other)]的[limb.plaintext_zone]结构已重置到正确位置！下一步是用螺丝刀/扳手固定它，不过骨胶也可以。"))
		set_superstructure_status(TRUE)
	else
		user?.visible_message(span_danger("[victim]'s [limb.plaintext_zone] splinters from [treating_plunger]'s plunging!"), \
			span_danger("[capitalize(your_or_other)]的[limb.plaintext_zone]因你的[treating_plunger]的抽吸而碎裂了！"))
		limb.receive_damage(brute = 5, damage_source = treating_plunger)

	return TRUE

/datum/wound/blunt/robotic/secures_internals/critical/handle_percussive_maintenance_success(attacking_item, mob/living/user)
	var/your_or_other = (user == victim ? "your" : "[victim]'s")
	victim.visible_message(span_green("[victim]的[limb.plaintext_zone]被砸成了正确的形状！"), \
		span_green("你的[limb.plaintext_zone]被砸成了合适的形状！"))

	var/user_message = "[capitalize(your_or_other)] [limb.plaintext_zone]'s superstructure has been reset! Your next step is to screwdriver/wrench the internals, \
	though if you're desperate enough to use percussive maintenance, you might want to either use a crowbar or bone gel..."
	to_chat(user, span_green(user_message))

	set_superstructure_status(TRUE)

/datum/wound/blunt/robotic/secures_internals/critical/handle_percussive_maintenance_failure(attacking_item, mob/living/user)
	to_chat(victim, span_danger("你的[limb.plaintext_zone]在冲击下只是变形得更厉害了..."))
	limb.receive_damage(brute = 1, damage_source = attacking_item, wound_bonus = CANT_WOUND)

/datum/wound/blunt/robotic/secures_internals/critical/uses_percussive_maintenance()
	return (!superstructure_remedied && limb_malleable())

/// Transitions our steps by setting both superstructure and secure internals readiness.
/datum/wound/blunt/robotic/secures_internals/critical/proc/set_superstructure_status(remedied)
	superstructure_remedied = remedied
	ready_to_secure_internals = remedied

/datum/wound/blunt/robotic/secures_internals/critical/get_wound_step_info()
	. = ..()

	if (!superstructure_remedied)
		. = "The superstructure must be reformed."
		if (!limb_malleable())
			. += " The limb must be heated to thermal overload, then manually molded with a firm grasp"
		else
			. += " The limb has been sufficiently heated, and can be manually molded with a firm grasp/repeated application of a low-force object"
		. += " - OR an RCD may be used with little risk."
