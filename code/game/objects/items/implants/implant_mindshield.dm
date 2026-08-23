// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/implant/mindshield
	name = "mindshield implant"
	desc = "Protects against brainwashing."
	actions_types = null

	implant_info = "Automatically activates upon implantation. Provides protection against brainwashing."

	implant_lore = "The Nanotrasen Employee Management Implant is a specialized subdermal nanite manufactory that \
		both protects the host's mental faculties from, and reverses, external forms of manipulation, \
		such as reprogrammed flashbulbs, hypnotic suggestion, and, theoretically, magical induction into cults."

/obj/item/implant/mindshield/implant(mob/living/target, mob/user, silent = FALSE, force = FALSE)
	. = ..()
	if(!.)
		return FALSE
	if(target.mind)
		if((SEND_SIGNAL(target.mind, COMSIG_PRE_MINDSHIELD_IMPLANT, user) & COMPONENT_MINDSHIELD_RESISTED))
			if(!silent)
				target.visible_message(span_warning(LANG("obj.67a3d80b8f263ac5", list(target))), span_warning(LANG("obj.ba69e512c5ce7bb6", null)))
			removed(target, TRUE)
			qdel(src)
			return TRUE
		if(SEND_SIGNAL(target.mind, COMSIG_MINDSHIELD_IMPLANTED, user) & COMPONENT_MINDSHIELD_DECONVERTED)
			if(prob(1) || check_holidays(APRIL_FOOLS))
				target.say(LANG("obj.6c45651ba7688a89", null), forced = "They're out! They quit! Whose kidneys do they have?")

	target.add_traits(list(TRAIT_MINDSHIELD, TRAIT_UNCONVERTABLE), IMPLANT_TRAIT)
	target.sec_hud_set_implants()
	if(!silent)
		to_chat(target, span_notice(LANG("obj.e1a5c467d88ec36a", null)))
	return TRUE

/obj/item/implant/mindshield/removed(mob/target, silent = FALSE, special = FALSE)
	. = ..()
	if(!.)
		return FALSE
	if(isliving(target))
		var/mob/living/L = target
		target.remove_traits(list(TRAIT_MINDSHIELD, TRAIT_UNCONVERTABLE), IMPLANT_TRAIT)
		L.sec_hud_set_implants()
	if(target.stat != DEAD && !silent)
		to_chat(target, span_boldnotice(LANG("obj.5efb3da75ce0cd61", null)))
	return TRUE

/obj/item/implanter/mindshield
	name = "implanter (mindshield)"
	imp_type = /obj/item/implant/mindshield

/obj/item/implantcase/mindshield
	name = "implant case - 'Mindshield'"
	desc = "A glass case containing a mindshield implant."
	imp_type = /obj/item/implant/mindshield
