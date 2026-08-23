//Overrides TG's version of the proc - only changes are the examine texts, and the extra DNR check
/mob/living/carbon/human/generate_death_examine_text()
	var/mob/dead/observer/ghost = get_ghost(TRUE, TRUE)
	var/t_He = p_They()
	var/t_is = p_are()
	//This checks to see if the body is revivable
	if((key || !get_organ_by_type(/obj/item/organ/brain) || ghost?.can_reenter_corpse) && (!HAS_TRAIT(src, TRAIT_DNR)))
		return span_deadsay(LANG("mob.1fae1ac91d531067", list(t_He, t_is, p_they())))
	else
		return span_deadsay(LANG("mob.2c6866d27b826158", list(t_He, t_is)))

///copies over clothing preferences like underwear to another human
/mob/living/carbon/human/copy_clothing_prefs(mob/living/carbon/human/destination)
	. = ..()

	destination.bra = bra
	destination.bra_color = bra_color
