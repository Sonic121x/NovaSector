
#define TEXT_NO_TASTE "something indescribable"

//=============================== TASTE GRAPH ====================================
//                                                                              //
// Flavor Intensity Thresholds (Relative to Detection Threshold % 'DT'):        //
// 0%             1x DT              2x DT              4x DT             100%  //
// |----------------|------------------|------------------|-----------------|   //
// |   Undetected   |       Weak       |       Mild       |      Strong     |   //
// |----------------|------------------|------------------|-----------------|   //
//                                                                              //
//==============================================================================//

/**
 * Returns what the reagents in our given list taste like
 *
 * Arguments:
 * * list/reagent_list - List of reagents to taste.
 * * mob/living/taster - Who is doing the tasting. Some mobs can pick up specific flavours.
 * * detection_threshold_percent - The minimum relative percentage a flavor must reach to be tasted.
 */
/proc/generate_reagents_taste_message(list/reagent_list, mob/living/taster, detection_threshold_percent)
	// We can't taste anything
	if(detection_threshold_percent > 100)
		return TEXT_NO_TASTE

	// Associative list of our tastes - list("taste description" = strength)
	var/list/tastes = list()
	var/total_taste_strength = 0

	for(var/datum/reagent/reagent as anything in reagent_list)
		if(!reagent.taste_mult)
			continue

		var/list/taste_data = reagent.get_taste_description(taster)
		for(var/taste_desc in taste_data)
			var/taste_strength = taste_data[taste_desc] * reagent.volume * reagent.taste_mult
			tastes[taste_desc] += taste_strength
			total_taste_strength += taste_strength

	// None of our reagents had any flavour
	if(total_taste_strength <= 0)
		return TEXT_NO_TASTE

	// If we have exactly one taste, don't bother with relative strengths
	if(length(tastes) == 1)
		return GLOB.i18n_server_locale != DEFAULT_UI_LOCALE ? lang_reverse_text(tastes[1]) : tastes[1] // ZH EDIT - I18N - localize single taste component

	// Sort tastes descending by strength, so strong flavours come first
	sortTim(tastes, cmp = GLOBAL_PROC_REF(cmp_numeric_dsc), associative = TRUE)

	// Lazylists for different taste strength categories, no need to initialize if we don't have such flavors
	var/list/strong_tastes
	var/list/mild_tastes
	var/list/weak_tastes

	// ZH EDIT ADDITION - I18N - reverse each taste component (food tastes / reagent descriptions) so catalog-present flavor words show in zh
	var/i18n_zh = GLOB.i18n_server_locale != DEFAULT_UI_LOCALE
	// ZH EDIT END
	for(var/taste_desc in tastes)
		var/relative_taste_percent = (tastes[taste_desc] / total_taste_strength) * 100
		var/taste_disp = i18n_zh ? lang_reverse_text(taste_desc) : taste_desc // ZH EDIT - I18N - localized component

		// From weakest to strongest
		if(relative_taste_percent < detection_threshold_percent)
			continue // too weak to detect
		else if(relative_taste_percent <= detection_threshold_percent * 2)
			LAZYADD(weak_tastes, taste_disp) // ZH EDIT - I18N - ORIGINAL: LAZYADD(weak_tastes, taste_desc)
		else if(relative_taste_percent <= detection_threshold_percent * 4)
			LAZYADD(mild_tastes, taste_disp) // ZH EDIT - I18N - ORIGINAL: LAZYADD(mild_tastes, taste_desc)
		else
			LAZYADD(strong_tastes, taste_disp) // ZH EDIT - I18N - ORIGINAL: LAZYADD(strong_tastes, taste_desc)

	var/list/taste_messages = list()

	// ZH EDIT ADDITION START - I18N - Chinese taste connectors + 顿号 separators (components already localized above)
	if(i18n_zh)
		if(LAZYLEN(strong_tastes))
			taste_messages += "浓郁的[english_list(strong_tastes, TEXT_NO_TASTE, "、", "、")]味"
		if(LAZYLEN(mild_tastes))
			taste_messages += "[LAZYLEN(strong_tastes) ? "些许" : ""][english_list(mild_tastes, TEXT_NO_TASTE, "、", "、")]"
		if(LAZYLEN(weak_tastes))
			taste_messages += "一丝[english_list(weak_tastes, TEXT_NO_TASTE, "、", "、")]味"
		return english_list(taste_messages, TEXT_NO_TASTE, "，", "，")
	// ZH EDIT ADDITION END

	if(LAZYLEN(strong_tastes))
		taste_messages += "the strong flavor of [english_list(strong_tastes, TEXT_NO_TASTE)]"
	if(LAZYLEN(mild_tastes))
		// Prefix "some " if there are strong flavors to avoid seeming like a strong flavor
		taste_messages += "[LAZYLEN(strong_tastes) ? "some " : ""][english_list(mild_tastes, TEXT_NO_TASTE)]"
	if(LAZYLEN(weak_tastes))
		taste_messages += "a hint of [english_list(weak_tastes, TEXT_NO_TASTE)]"

	return english_list(taste_messages, TEXT_NO_TASTE)

#undef TEXT_NO_TASTE
