/obj/item/organ/cyberimp/eyes
	name = "赛博眼植入体"
	desc = "用于眼睛的植入体。"
	icon_state = "eye_implant"
	slot = ORGAN_SLOT_EYES
	zone = BODY_ZONE_PRECISE_EYES
	w_class = WEIGHT_CLASS_TINY

// HUD implants
/obj/item/organ/cyberimp/eyes/hud
	name = "HUD植入体"
	desc = "这些赛博眼会在你看到的一切事物上显示HUD。也许吧。"
	slot = ORGAN_SLOT_HUD
	actions_types = list(/datum/action/item_action/organ_action/toggle_hud)
	var/HUD_traits = list()
	/// Whether the HUD implant is on or off
	var/toggled_on = TRUE
	/// Eyecolor from the HUD
	var/hud_color = "#3CB8A5"

/obj/item/organ/cyberimp/eyes/hud/Initialize(mapload)
	. = ..()
	if(toggled_on)
		for(var/hud_trait in HUD_traits)
			add_organ_trait(hud_trait)

/obj/item/organ/cyberimp/eyes/hud/proc/toggle_hud(mob/living/carbon/human/eye_owner)
	if(toggled_on)
		toggled_on = FALSE
		for(var/hud_trait in HUD_traits)
			remove_organ_trait(hud_trait)
		balloon_alert(eye_owner, "hud 已禁用")
		if(hud_color)
			eye_owner.remove_eye_color(EYE_COLOR_HUD_PRIORITY)
		return
	toggled_on = TRUE
	for(var/hud_trait in HUD_traits)
		add_organ_trait(hud_trait)
	balloon_alert(eye_owner, "hud 已启用")
	if(hud_color)
		eye_owner.add_eye_color_right(hud_color, EYE_COLOR_HUD_PRIORITY)

/obj/item/organ/cyberimp/eyes/hud/on_mob_insert(mob/living/carbon/human/eye_owner, special = FALSE, movement_flags)
	. = ..()
	if(toggled_on && hud_color)
		eye_owner.add_eye_color_right(hud_color, EYE_COLOR_HUD_PRIORITY, !special)

/obj/item/organ/cyberimp/eyes/hud/on_mob_remove(mob/living/carbon/human/eye_owner, special, movement_flags)
	. = ..()
	if(toggled_on && hud_color)
		eye_owner.remove_eye_color(EYE_COLOR_HUD_PRIORITY, !special)

/obj/item/organ/cyberimp/eyes/hud/medical
	name = "医疗HUD植入体"
	desc = "这些赛博眼植入体会在你看到的一切事物上显示医疗HUD。"
	icon_state = "eye_implant_medical"
	HUD_traits = list(TRAIT_MEDICAL_HUD)
	hud_color = "#1D8FEC"

/obj/item/organ/cyberimp/eyes/hud/security
	name = "安保HUD植入体"
	desc = "这些赛博眼植入体将在你看到的一切事物上显示一个安保HUD。"
	icon_state = "eye_implant_security"
	HUD_traits = list(TRAIT_SECURITY_HUD)
	hud_color = "#9A151E"

/obj/item/organ/cyberimp/eyes/hud/diagnostic
	name = "诊断HUD植入体"
	desc = "这些赛博眼植入体将在你看到的一切事物上显示一个诊断HUD。"
	icon_state = "eye_implant_diagnostic"
	HUD_traits = list(TRAIT_DIAGNOSTIC_HUD, TRAIT_BOT_PATH_HUD)
	hud_color = "#CC6E33"

/obj/item/organ/cyberimp/eyes/hud/security/syndicate
	name = "违禁安保HUD植入体"
	desc = "一款Cybersun Industries品牌的安保HUD植入体。这些非法的赛博眼植入体将在你看到的一切事物上显示一个安保HUD。"
	icon_state = "eye_implant_syndicate"
	organ_flags = ORGAN_ROBOTIC | ORGAN_HIDDEN
	hud_color = null
