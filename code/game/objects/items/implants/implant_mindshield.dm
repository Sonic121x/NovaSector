/obj/item/implant/mindshield
	name = "思维护盾植入物"
	desc = "防止洗脑。"
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
				target.visible_message(span_warning("[target] 似乎在抵抗植入物！"), span_warning("你感觉到有什么东西在干扰你的精神调节，但你抵抗住了它！"))
			removed(target, TRUE)
			qdel(src)
			return TRUE
		if(SEND_SIGNAL(target.mind, COMSIG_MINDSHIELD_IMPLANTED, user) & COMPONENT_MINDSHIELD_DECONVERTED)
			if(prob(1) || check_holidays(APRIL_FOOLS))
				target.say("I'm out! I quit! Whose kidneys are these?", forced = "They're out! They quit! Whose kidneys do they have?")

	target.add_traits(list(TRAIT_MINDSHIELD, TRAIT_UNCONVERTABLE), IMPLANT_TRAIT)
	target.sec_hud_set_implants()
	if(!silent)
		to_chat(target, span_notice("你感到一种平静与安全感。你现在已受到保护，不会受到洗脑。"))
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
		to_chat(target, span_boldnotice("你的思维突然感到极度脆弱。你不再安全，可能受到洗脑。"))
	return TRUE

/obj/item/implanter/mindshield
	name = "植入器（思维盾）"
	imp_type = /obj/item/implant/mindshield

/obj/item/implantcase/mindshield
	name = "implant case - 'Mindshield'"
	desc = "一个装有思维盾植入体的玻璃盒。"
	imp_type = /obj/item/implant/mindshield
