// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/structure/sign/eyechart
	icon_state = "eyechart"
	name = "eye chart"
	desc = "A poster with a series of colored bars and letters of different sizes, \
		used to test color vision and blindness - I mean, visual acuity."
	is_editable = TRUE

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/eyechart, 32)

/obj/structure/sign/eyechart/examine(mob/user)
	. = ..()
	if(isobserver(user))
		return

	if(!user.can_read(src, READING_CHECK_LITERACY, silent = TRUE) || !user.has_language(/datum/language/common, UNDERSTOOD_LANGUAGE))
		if(!user.is_blind())
			. += LANG("obj.965934eb18ea8157", null)
			. += span_warning(LANG("obj.3b924ced9d607335", null))
		return

	if(user.is_blind())
		. += LANG("obj.f1b34eb5012ecee7", null)
		. += span_notice(LANG("obj.cc8187e2f9c2994d", null))
		return

	if(!user.can_read(src, READING_CHECK_LIGHT, silent = TRUE))
		. += LANG("obj.f2d4c8a372f37fba", null)
		. += span_warning(LANG("obj.acb1aee2995b2b6d", null))
		return

	var/colorblind = HAS_TRAIT(user, TRAIT_COLORBLIND)
	var/obj/item/organ/eyes/eye = user.get_organ_slot(ORGAN_SLOT_EYES)
	// eye null checks here are for mobs without eyes.
	// humans missing eyes will be caught by the is_blind check above.
	var/eye_goodness = isnull(eye) ? 0 : eye.damage
	var/little_bad = isnull(eye) ? 20 : eye.low_threshold
	var/very_bad = isnull(eye) ? 30 : eye.high_threshold

	if(user.has_status_effect(/datum/status_effect/eye_blur))
		eye_goodness = max(eye_goodness, very_bad + 1)
	if(user.is_nearsighted_currently())
		eye_goodness = max(eye_goodness, little_bad + 1)
	eye_goodness += ((get_dist(user, src) - 2) * 5) // add a modifier based on distance, so closer = "better", further = "worse"

	. += LANG("obj.de52c1c8985dc022", null)
	if(eye_goodness <= 0)
		. += span_notice(LANG("obj.16193f6b680c5139", list(colorblind ? "brown - wait, isn't it supposed to be red? -" : "red")))
	else if(eye_goodness < little_bad)
		. += span_notice(LANG("obj.28ffaa7b0e43b820", list(colorblind ? "grey - wait, isn't it supposed to be green? -" : "green")))
	else if(eye_goodness < very_bad)
		. += span_warning(LANG("obj.c7ec3655965b8b54", null))
	else
		. += span_warning(LANG("obj.d45e9dadb106388e", null))
