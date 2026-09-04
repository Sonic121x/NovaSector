// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
// Describes the three modes of scanning available for health analyzers
#define SCANMODE_HEALTH 0
#define SCANMODE_WOUND 1
#define SCANMODE_COUNT 2 // Update this to be the number of scan modes if you add more

/obj/item/healthanalyzer
	name = "health analyzer"
	icon = 'icons/obj/devices/scanner.dmi'
	icon_state = "health"
	inhand_icon_state = "healthanalyzer"
	worn_icon_state = "healthanalyzer"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	desc = "A hand-held body scanner capable of distinguishing vital signs of the subject. Has a side button to scan for chemicals, and can be toggled to scan wounds."
	obj_flags = CONDUCTS_ELECTRICITY
	item_flags = NOBLUDGEON
	slot_flags = ITEM_SLOT_BELT
	throwforce = 3
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 3
	throw_range = 7
	custom_materials = list(/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 0.5)
	interaction_flags_click = NEED_LITERACY|NEED_LIGHT|ALLOW_RESTING
	custom_price = PAYCHECK_COMMAND
	sound_vary = TRUE
	pickup_sound = SFX_GENERIC_DEVICE_PICKUP
	drop_sound = SFX_GENERIC_DEVICE_DROP
	/// Verbose/condensed
	var/mode = SCANNER_VERBOSE
	/// HEALTH/WOUND
	var/scanmode = SCANMODE_HEALTH
	/// Health analyzing power
	var/scanpower = SCANPOWER_BASIC
	/// If this analyzer will give a bonus to wound treatments apon woundscan.
	var/give_wound_treatment_bonus = FALSE
	var/last_scan_text
	var/scanner_busy = FALSE
	/// Weakref to the last mob scanned by a health analyzer. Used to generate official medical reports.
	var/datum/weakref/last_healthy_scanned

/obj/item/healthanalyzer/Initialize(mapload)
	. = ..()
	register_item_context()

/obj/item/healthanalyzer/examine(mob/user)
	. = ..()
	if(src.mode != SCANNER_NO_MODE)
		. += span_notice(LANG("obj.70d11c6e331606e0", list(src)))

/obj/item/healthanalyzer/suicide_act(mob/living/user)
	user.visible_message(span_suicide(LANG("obj.1cd52c32807c3847", list(user, user.p_them(), src, user.p_theyre()))))
	return BRUTELOSS

/obj/item/healthanalyzer/attack_self(mob/user)
	if(!user.can_read(src)) //NOVA EDIT: Blind People Can Analyze Again
		return

	scanmode = (scanmode + 1) % SCANMODE_COUNT
	switch(scanmode)
		if(SCANMODE_HEALTH)
			to_chat(user, span_notice(LANG("obj.7ad4b9bb70c1c663", null)))
		if(SCANMODE_WOUND)
			to_chat(user, span_notice(LANG("obj.7ed4e3873e23477f", null)))

/obj/item/healthanalyzer/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!isliving(interacting_with))
		return NONE

	var/mob/living/M = interacting_with

	. = ITEM_INTERACT_SUCCESS

	flick("[icon_state]-scan", src) //makes it so that it plays the scan animation upon scanning, including clumsy scanning

	// Clumsiness/brain damage check
	if ((HAS_TRAIT(user, TRAIT_CLUMSY) || HAS_TRAIT(user, TRAIT_DUMB)) && prob(50))
		var/turf/scan_turf = get_turf(user)
		user.visible_message(
			span_warning(LANG("obj.2316cc3b714ee434", list(user, scan_turf))),
			span_notice(LANG("obj.f9872b0aea30650f", list(scan_turf))),
		)

		var/floor_text = "<span class='info'>Analyzing results for <b>[scan_turf]</b> ([round_timestamp()]):</span><br>"
		floor_text += "<span class='info ml-1'>Overall status: <i>Unknown</i></span><br>"
		floor_text += "<span class='alert ml-1'>Subject lacks a brain.</span><br>"
		floor_text += "<span class='info ml-1'>Body temperature: [scan_turf?.return_air()?.return_temperature() || "???"]</span><br>"

		if(user.can_read(src) && !user.is_blind())
			to_chat(user, custom_boxed_message("blue_box", floor_text))
		last_scan_text = floor_text
		return

	if(HAS_TRAIT(M, TRAIT_REQUIRED_ADV_HEALTH_SCANNER) && scanpower < SCANPOWER_ADVANCED)
		to_chat(user, span_info(LANG("obj.58992497079b19e2", list(M))))
		return

	user.visible_message(span_notice(LANG("obj.e9abb56d7bbcc95b", list(user, M))))
	balloon_alert(user, LANG("obj.2cbcf7799aed9199", null))
	playsound(user.loc, 'sound/items/healthanalyzer.ogg', 50)

	var/readability_check = user.can_read(src) // NOVA EDIT CHANGE - Blind people can analyze again - ORIGINAL: var/readability_check = user.can_read(src) && !user.is_blind()
	switch (scanmode)
		if (SCANMODE_HEALTH)
			last_scan_text = healthscan(user, M, mode, scanpower, tochat = readability_check)
			if((M.health / M.maxHealth) > CLEAN_BILL_OF_HEALTH_RATIO)
				last_healthy_scanned = WEAKREF(M)
			else
				last_healthy_scanned = null
		if (SCANMODE_WOUND)
			if(readability_check)
				woundscan(user, M, src)

	add_fingerprint(user)

/obj/item/healthanalyzer/interact_with_atom_secondary(atom/interacting_with, mob/living/user, list/modifiers)
	if(!isliving(interacting_with))
		return NONE
	if(user.can_read(src)) // NOVA EDIT CHANGE - Blind people can analyze again - ORIGINAL: if(user.can_read(src) || !user.is_blind())
		chemscan(user, interacting_with)
	return ITEM_INTERACT_SUCCESS

/obj/item/healthanalyzer/add_item_context(
	obj/item/source,
	list/context,
	atom/target,
)
	if (!isliving(target))
		return NONE

	switch (scanmode)
		if (SCANMODE_HEALTH)
			context[SCREENTIP_CONTEXT_LMB] = "Scan health"
		if (SCANMODE_WOUND)
			context[SCREENTIP_CONTEXT_LMB] = "Scan wounds"

	context[SCREENTIP_CONTEXT_RMB] = "Scan chemicals"

	return CONTEXTUAL_SCREENTIP_SET

/**
 * healthscan
 * returns a list of everything a health scan should give to a player.
 * Examples of where this is used is Health Analyzer and the Physical Scanner tablet app.
 * Args:
 * user - The person with the scanner
 * target - The person being scanned
 * mode - Uses SCANNER_CONDENSED or SCANNER_VERBOSE to decide whether to give a list of all individual limb damage
 * advanced - Whether it will give more advanced details, such as husk source.
 * tochat - Whether to immediately post the result into the chat of the user, otherwise it will return the results.
 */
/proc/healthscan(mob/user, mob/living/target, mode = SCANNER_VERBOSE, scanpower = SCANPOWER_BASIC, tochat = TRUE)
	if(user.incapacitated)
		return

	// the final list of strings to render
	var/list/render_list = list()

	// Damage specifics
	var/oxy_loss = target.get_oxy_loss()
	var/tox_loss = target.get_tox_loss()
	var/fire_loss = target.get_fire_loss()
	var/brute_loss = target.get_brute_loss()
	var/mob_status = (IS_DEAD_OR_FAKING(target) ? span_alert("<b>Deceased</b>") : "<b>[round(target.health / target.maxHealth, 0.01) * 100]% healthy</b>")

	if(HAS_TRAIT(target, TRAIT_FAKEDEATH) && target.stat != DEAD)
		// if we don't appear to actually be in a "dead state", add fake oxyloss
		if(oxy_loss + tox_loss + fire_loss + brute_loss < 200)
			oxy_loss += 200 - (oxy_loss + tox_loss + fire_loss + brute_loss)
			oxy_loss = clamp(oxy_loss, 0, 200)

	render_list += LANG("_root.6c29e48e5c6d78bf", list(span_info("Analyzing results for <b>[target]</b> ([round_timestamp()]):"), mob_status))

	if(!scanpower == SCANPOWER_BASIC && target.has_reagent(/datum/reagent/inverse/technetium))
		scanpower = SCANPOWER_ADVANCED

	SEND_SIGNAL(target, COMSIG_LIVING_HEALTHSCAN, render_list, scanpower, user, mode, tochat)

	// Husk detection
	if(HAS_TRAIT(target, TRAIT_HUSK))
		if(scanpower >= SCANPOWER_ADVANCED)
			if(HAS_TRAIT_FROM(target, TRAIT_HUSK, CHANGELING_DRAIN))
				render_list += "<span class='alert ml-1'>Subject has been husked by [conditional_tooltip("desiccation", "Perform blood transfusion and apply a de-husking agent such as [/datum/reagent/medicine/c2/synthflesh::name]. Full restoration will require more than usual.", tochat)].</span><br>" // NOVA EDIT CHANGE - ORIGINAL: render_list += "<span class='alert ml-1'>Subject has been husked by [conditional_tooltip("desiccation", "Irreparable. Under normal circumstances, revival can only proceed via brain transplant.", tochat)].</span><br>"
			else if(HAS_TRAIT_FROM(target, TRAIT_HUSK, SKELETON_TRAIT))
				render_list += LANG("_root.3b0d10c9ff7935c5", null)
			else if(HAS_TRAIT_FROM(target, TRAIT_HUSK, /datum/status_effect/zombie::id))
				render_list += LANG("_root.1b3d0810e63fae52", list(conditional_tooltip("zombification", \
					"Surgically remove the source of the infection, typically located in the head. If no source is found, it is otherwise irreparable.", tochat)))
			else if(!HAS_TRAIT_FROM(target, TRAIT_HUSK, BURN)) // prioritize showing unknown causes over burns
				render_list += LANG("_root.a2853cd25755308e", null)
			else
				render_list += LANG("_root.1b3d0810e63fae52", list(conditional_tooltip("severe burns", "Tend burns and apply a de-husking agent, such as [/datum/reagent/medicine/c2/synthflesh::name].", tochat)))

		else
			render_list += LANG("_root.5d597fa073e965ab", null)

	if(target.get_stamina_loss())
		if(scanpower >= SCANPOWER_ADVANCED)
			render_list += LANG("_root.67df8050445f846c", list(target.get_stamina_loss()))
		else
			render_list += LANG("_root.8270cfd6231faea2", null)

	// Check for brain - both organic (carbon) and synthetic (cyborg MMI)
	var/has_brain = FALSE
	if(target.get_organ_slot(ORGAN_SLOT_BRAIN))
		has_brain = TRUE
	else if(iscyborg(target))
		var/mob/living/silicon/robot/cyborg_target = target
		if(cyborg_target.mmi?.brain)
			has_brain = TRUE

	if(!has_brain) // kept exclusively for soul purposes
		render_list += LANG("_root.252964ecae5d10ab", null)

	if(iscarbon(target))
		var/mob/living/carbon/carbontarget = target
		if(LAZYLEN(carbontarget.quirks))
			render_list += LANG("_root.f3b9c31a01a52bdf", list(carbontarget.get_quirk_string(FALSE, CAT_QUIRK_MAJOR_DISABILITY, from_scan = TRUE)))
			if(scanpower >= SCANPOWER_ADVANCED)
				render_list += LANG("_root.44c1cb74dfec86af", list(carbontarget.get_quirk_string(FALSE, CAT_QUIRK_MINOR_DISABILITY, TRUE)))

	// NOVA EDIT ADDITION START -- Show increased/decreased brute/burn mods, to "leave a paper trail" for the fragility quirk
	if(ishuman(target))
		var/mob/living/carbon/human/humantarget = target

		var/brute_mod = GET_PHYSIOLOGY(humantarget, BRUTE)
		var/burn_mod = GET_PHYSIOLOGY(humantarget, BURN)
		if (brute_mod != 1)
			render_list += LANG("_root.e1bc60a540f2a238", list(brute_mod * 100))
		if (burn_mod != 1)
			render_list += LANG("_root.59c9d296074008e9", list(burn_mod * 100))
	// NOVA EDIT ADDITION END
	// Body part damage report
	if(iscarbon(target))
		var/mob/living/carbon/carbontarget = target
		var/any_damage = brute_loss > 0 || fire_loss > 0 || oxy_loss > 0 || tox_loss > 0 || fire_loss > 0
		var/any_missing = length(carbontarget.get_missing_limbs())
		var/any_wounded = length(carbontarget.all_wounds)
		var/any_embeds = carbontarget.has_embedded_objects()
		if(any_damage || (mode == SCANNER_VERBOSE && (any_missing || any_wounded || any_embeds)))
			render_list += "<hr>"
			var/dmgreport = "<span class='info ml-1'>Body status:</span>\
							<font face='Verdana'>\
							<table class='ml-2'>\
							<tr>\
							<td style='width:7em;'><font color='#ff0000'><b>Damage:</b></font></td>\
							<td style='width:5em;'><font color='#ff3333'><b>Brute</b></font></td>\
							<td style='width:4em;'><font color='#ff9933'><b>Burn</b></font></td>\
							<td style='width:4em;'><font color='#00cc66'><b>Toxin</b></font></td>\
							<td style='width:8em;'><font color='#00cccc'><b>Suffocation</b></font></td>\
							</tr>\
							<tr>\
							<td><font color='#ff3333'><b>Overall:</b></font></td>\
							<td><font color='#ff3333'><b>[ceil(brute_loss)]</b></font></td>\
							<td><font color='#ff9933'><b>[ceil(fire_loss)]</b></font></td>\
							<td><font color='#00cc66'><b>[ceil(tox_loss)]</b></font></td>\
							<td><font color='#33ccff'><b>[ceil(oxy_loss)]</b></font></td>\
							</tr>"

			if(mode == SCANNER_VERBOSE)
				// Follow same body zone list every time so it's consistent across all humans
				for(var/zone in carbontarget.get_all_limbs())
					var/obj/item/bodypart/limb = carbontarget.get_bodypart(zone)
					if(isnull(limb))
						dmgreport += "<tr>"
						dmgreport += "<td><font color='#cc3333'>[capitalize(parse_zone(zone))]:</font></td>"
						dmgreport += "<td><font color='#cc3333'>-</font></td>"
						dmgreport += "<td><font color='#ff9933'>-</font></td>"
						dmgreport += "</tr>"
						dmgreport += LANG("_root.f7c2daead083eef5", list(conditional_tooltip("Dismembered", "Reattach or replace surgically.", tochat)))
						continue
					var/has_any_embeds = LAZYLEN(limb.embedded_objects) >= 1
					var/has_any_wounds = length(limb.wounds) >= 1
					var/is_damaged = limb.burn_dam > 0 || limb.brute_dam > 0
					if(!is_damaged && (zone != BODY_ZONE_CHEST || (tox_loss <= 0 && oxy_loss <= 0)) && !has_any_embeds && !has_any_wounds)
						continue
					dmgreport += "<tr>"
					dmgreport += "<td><font color='#cc3333'>[capitalize((limb.bodytype & BODYTYPE_ROBOTIC) ? limb.name : limb.plaintext_zone)]:</font></td>"
					dmgreport += "<td><font color='#cc3333'>[limb.brute_dam > 0 ? ceil(limb.brute_dam) : "0"]</font></td>"
					dmgreport += "<td><font color='#ff9933'>[limb.burn_dam > 0 ? ceil(limb.burn_dam) : "0"]</font></td>"
					if(zone == BODY_ZONE_CHEST) // tox/oxy is stored in the chest
						dmgreport += "<td><font color='#00cc66'>[tox_loss > 0 ? ceil(tox_loss) : "0"]</font></td>"
						dmgreport += "<td><font color='#33ccff'>[oxy_loss > 0 ? ceil(oxy_loss) : "0"]</font></td>"
					dmgreport += "</tr>"
					if(has_any_embeds)
						var/list/embedded_names = list()
						for(var/obj/item/embed as anything in limb.embedded_objects)
							embedded_names[capitalize(embed.name)] += 1
						for(var/embedded_name in embedded_names)
							var/displayed = embedded_name
							var/embedded_amt = embedded_names[embedded_name]
							if(embedded_amt > 1)
								displayed = "[embedded_amt]x [embedded_name]"
							dmgreport += LANG("_root.d8311121e0377dde", list(conditional_tooltip(displayed, "Use a hemostat to remove.", tochat)))
					if(has_any_wounds)
						for(var/datum/wound/wound as anything in limb.wounds)
							// NOVA EDIT CHANGE - i18n: reverse-localize the treat-text tooltip (whole-string; bypasses sink/AC) - ORIGINAL: wound.treat_text_short
							dmgreport += LANG("_root.f7c2daead083eef5", list(conditional_tooltip("[wound.name] ([wound.severity_text()])", lang_reverse_text(wound.treat_text_short), tochat)))

			dmgreport += "</table></font>"
			render_list += dmgreport // tables do not need extra linebreak

	if(ishuman(target))
		var/mob/living/carbon/human/humantarget = target

		// Organ damage, missing organs
		var/render = FALSE
		var/toReport = "<span class='info ml-1'>Organ status:</span>\
			<font face='Verdana'>\
			<table class='ml-2'>\
			<tr>\
			<td style='width:8em;'><font color='#ff0000'><b>Organ:</b></font></td>\
			[scanpower >= SCANPOWER_ADVANCED ? "<td style='width:4em;'><font color='#ff0000'><b>Dmg</b></font></td>" : ""]\
			<td style='width:30em;'><font color='#ff0000'><b>Status</b></font></td>\
			</tr>"

		var/list/missing_organs = humantarget.get_missing_organs()
		// Follow same order as in the organ_process_order so it's consistent across all humans
		for(var/sorted_slot in GLOB.organ_process_order)
			var/obj/item/organ/organ = humantarget.get_organ_slot(sorted_slot)
			if(isnull(organ))
				if(missing_organs[sorted_slot])
					render = TRUE
					// NOVA EDIT CHANGE - i18n: reverse-localize the missing-organ name - ORIGINAL: [missing_organs[sorted_slot]]
					toReport += LANG("_root.29ae2426ae7122ec", list(lang_reverse_text(missing_organs[sorted_slot]), scanpower >= SCANPOWER_ADVANCED ? "<td><font color='#ff3333'>-</font></td>" : ""))
				continue
			if(mode != SCANNER_VERBOSE && !organ.show_on_condensed_scans())
				continue
			var/status = organ.get_status_text(scanpower, tochat)
			var/appendix = organ.get_status_appendix(scanpower, tochat)
			if(status || appendix)
				status ||= "<font color='#ffcc33'>OK</font>" // otherwise flawless organs have no status reported by default
				render = TRUE
				// NOVA EDIT CHANGE - i18n: reverse-localize organ name at the display point — some organ names miss the
				// Initialize name-reverse (post-Initialize renames) - ORIGINAL: <td>…[capitalize(organ.name)]:</font></td>
				toReport += "<tr>\
					<td><font color='#cc3333'>[capitalize(lang_reverse_text(organ.name))]:</font></td>\
					[scanpower >= SCANPOWER_ADVANCED ? "<td><font color='#ff3333'>[organ.damage > 0 ? ceil(organ.damage) : "0"]</font></td>" : ""]\
					<td>[status]</td>\
					</tr>"
				if(appendix)
					toReport += LANG("_root.f46ffddbf6563299", list(appendix))

		if(render)
			render_list += "<hr>"
			render_list += toReport + "</table></font>" // tables do not need extra linebreak

		// Cybernetics & mutant
		var/mutant = HAS_TRAIT(humantarget, TRAIT_HULK)
		var/list/cyberimps
		for(var/obj/item/organ/target_organ as anything in humantarget.organs)
			if(IS_ROBOTIC_ORGAN(target_organ) && !(target_organ.organ_flags & ORGAN_HIDDEN))
				LAZYADD(cyberimps, target_organ.examine_title(user))
			if(target_organ.organ_flags & ORGAN_MUTANT)
				mutant = TRUE
		if(LAZYLEN(cyberimps))
			if(!render)
				render_list += "<hr>"
			render_list += LANG("_root.20628086e5dfef74", null)
			render_list += "<span class='notice ml-2'>[english_list(cyberimps, and_text = ", and ")]</span><br>"

		render_list += "<hr>"

		//Genetic stability
		if(scanpower >= SCANPOWER_ADVANCED && humantarget.has_dna() && humantarget.dna.stability != initial(humantarget.dna.stability))
			render_list += LANG("_root.1e9bd33cb05f48b2", list(humantarget.dna.stability))

		//body temperature
		var/datum/species/targetspecies = humantarget.dna.species
		var/disguised = !ishumanbasic(humantarget) && istype(humantarget.head, /obj/item/clothing/head/hooded/human_head) && istype(humantarget.wear_suit, /obj/item/clothing/suit/hooded/bloated_human)
		var/species_name = "[disguised ? "\"[/datum/species/human::name]\"" : targetspecies.name][mutant ? "-derived mutant" : ""]"

		render_list += "<span class='info ml-1'>Species: [lang_reverse_text(species_name)]</span><br>" // NOVA EDIT CHANGE - i18n: reverse-localize species name (exact; label handled by lang_localize_health_scan) - ORIGINAL: render_list += "<span class='info ml-1'>Species: [species_name]</span><br>"
		var/core_temperature_message = "Core temperature: [round(humantarget.coretemperature-T0C, 0.1)] &deg;C ([round(humantarget.coretemperature*1.8-459.67,0.1)] &deg;F)"
		if(humantarget.coretemperature >= humantarget.get_body_temp_heat_damage_limit())
			render_list += "<span class='alert ml-1'>☼ [core_temperature_message] ☼</span><br>"
		else if(humantarget.coretemperature <= humantarget.get_body_temp_cold_damage_limit())
			render_list += "<span class='alert ml-1'>❄ [core_temperature_message] ❄</span><br>"
		else
			render_list += "<span class='info ml-1'>[core_temperature_message]</span><br>"

	var/body_temperature_message = "Body temperature: [round(target.bodytemperature-T0C, 0.1)] &deg;C ([round(target.bodytemperature*1.8-459.67,0.1)] &deg;F)"
	if(target.bodytemperature >= target.get_body_temp_heat_damage_limit())
		render_list += "<span class='alert ml-1'>☼ [body_temperature_message] ☼</span><br>"
	else if(target.bodytemperature <= target.get_body_temp_cold_damage_limit())
		render_list += "<span class='alert ml-1'>❄ [body_temperature_message] ❄</span><br>"
	else
		render_list += "<span class='info ml-1'>[body_temperature_message]</span><br>"

	// Blood Level
	var/datum/blood_type/blood_type = target.get_bloodtype()
	if(blood_type)
		var/cached_blood_volume = target.get_blood_volume(apply_modifiers = TRUE)
		var/blood_percent = round((cached_blood_volume / BLOOD_VOLUME_NORMAL) * 100)
		var/blood_type_format
		var/level_format
		if(cached_blood_volume <= BLOOD_VOLUME_SAFE && cached_blood_volume > BLOOD_VOLUME_OKAY)
			level_format = "LOW [blood_percent]%, [cached_blood_volume] cl"
			if (blood_type.restoration_chem)
				level_format = conditional_tooltip(level_format, "Recommendation: [blood_type.restoration_chem::name] supplement.", tochat)
		else if(cached_blood_volume <= BLOOD_VOLUME_OKAY)
			level_format = "<b>CRITICAL [blood_percent]%</b>, [cached_blood_volume] cl"
			var/recommendation = list()
			if (blood_type.restoration_chem)
				recommendation += LANG("_root.05da585062b36da0", list(blood_type.restoration_chem::name))
			if (blood_type.restoration_chem == /datum/reagent/iron)
				recommendation += "[/datum/reagent/medicine/salglu_solution::name]"
			if (length(recommendation))
				recommendation += LANG("_root.f56971abbc6ecbba", list(blood_type.get_blood_name()))
			else
				recommendation += LANG("_root.25495c523617585e", list(blood_type.get_blood_name()))
			level_format = conditional_tooltip(level_format, "Recommendation: [english_list(recommendation, and_text = " or ")].", tochat)
		else
			level_format = "[blood_percent]%, [cached_blood_volume] cl"

		if (blood_type.get_type())
			blood_type_format = "[blood_type.get_type()]"
			if(tochat && length(blood_type.compatible_types))
				var/list/compatible_types_readable = list()
				for(var/datum/blood_type/comp_blood_type as anything in blood_type.compatible_types)
					compatible_types_readable |= initial(comp_blood_type.name)
				blood_type_format = span_tooltip("Can receive from types [english_list(compatible_types_readable)].", blood_type_format)

		render_list += LANG("_root.5fb7490182fcd8b8", list(cached_blood_volume < BLOOD_VOLUME_SAFE ? "alert" : "info", blood_type.get_blood_name(), level_format, blood_type_format))

	var/blood_alcohol_content = target.get_blood_alcohol_content()
	if(blood_alcohol_content > 0)
		if(blood_alcohol_content >= 0.24)
			// "Oil alcohol content" is kinda funny if you think about it from a technical standpoint
			render_list += LANG("_root.c5581b9598f90cbe", list(blood_type?.get_blood_name() || "Blood", blood_alcohol_content))
		else
			render_list += LANG("_root.5ca363db8a600703", list(blood_type?.get_blood_name() || "Blood", blood_alcohol_content))

	// Ethereal Charge
	if(istype(target.get_organ_slot(ORGAN_SLOT_STOMACH), /obj/item/organ/stomach/ethereal))
		var/obj/item/organ/stomach/ethereal/battery_stomach = target.get_organ_slot(ORGAN_SLOT_STOMACH)
		var/charge = battery_stomach.cell.charge
		var/charge_dangerous = charge > ETHEREAL_CHARGE_FULL || charge < ETHEREAL_CHARGE_LOWPOWER
		var/charge_format = "[display_power(charge)] / [display_power(ETHEREAL_CHARGE_FULL)]"

		if(charge_dangerous)
			var/recommendation = "Recommendation: "
			switch(charge)
				if(-INFINITY to ETHEREAL_CHARGE_LOWPOWER)
					recommendation += LANG("_root.fb5af5c8f9ff8fb3", null)
				if(ETHEREAL_CHARGE_FULL to ETHEREAL_CHARGE_OVERLOAD)
					recommendation += LANG("_root.fa287e01bc0d32f7", null)
				if(ETHEREAL_CHARGE_OVERLOAD to ETHEREAL_CHARGE_DANGEROUS)
					recommendation += LANG("_root.9451da0223e5b6eb", null)
					recommendation = uppertext(recommendation)
			charge_format = span_tooltip("[recommendation] followed with toxins treatment.", charge_format)

		render_list += LANG("_root.8f7bfa5491be2c7f", list(charge_dangerous ? "alert" : "info", charge_format))

	//Diseases
	var/disease_hr = FALSE
	for(var/datum/disease/disease as anything in target.diseases)
		if(disease.visibility_flags & HIDDEN_SCANNER)
			continue
		if(!disease_hr)
			render_list += "<hr>"
			disease_hr = TRUE
		var/cure_text
		if(istype(disease, /datum/disease/advance))
			var/datum/disease/advance/advanced_disease = disease
			var/cure_count = 2
			switch(scanpower)
				if(SCANPOWER_ADVANCED)
					cure_count = 3
				if(SCANPOWER_SUPER)
					cure_count = INFINITY
			cure_text = advanced_disease.generate_cure_text(cure_count)
		else
			cure_text = disease.cure_text
		// NOVA EDIT CHANGE START - I18N: 整块改 LANG。原为逐行拼插值，整串非目录键、AC 只会在半句
		// 处替换。ORIGINAL: 见 git 历史（"<b>Warning: [disease.form] detected</b>" 起的续行块）。
		render_list += "<span class='alert ml-1'>\
			[conditional_tooltip("<b>[LANG("obj.91316a71286b9e71", list(disease.form))]</b>", LANG("obj.42f2953affea6965", list(/datum/reagent/medicine/spaceacillin::name)), tochat)]<br>\
			<div class='ml-2'>\
			[LANG("obj.f9ef6cb2c0edc742", list(disease.name, disease.spread_text, disease.stage, disease.max_stages, cure_text))]</div>\
			</span>"
		// NOVA EDIT CHANGE END
	// NOVA EDIT ADDITION - Mutant stuff + death consequences quirk
	if(iscarbon(target))
		if(target.GetComponent(/datum/component/mutant_infection))
			render_list += span_userdanger(LANG("_root.8848965dfc83301d", null))

		var/mob/living/carbon/carbon_target = target
		for(var/datum/brain_trauma/trauma in carbon_target.get_traumas())
			if(istype(trauma, /datum/brain_trauma/severe/death_consequences))
				var/datum/brain_trauma/severe/death_consequences/consequences_trauma = trauma
				render_list += consequences_trauma.get_health_analyzer_link_text(user)
	// NOVA EDIT ADDITION END

	// Time of death
	if(target.station_timestamp_timeofdeath && IS_DEAD_OR_FAKING(target))
		render_list += "<hr>"
		render_list += LANG("_root.b68ee8e3dde816d6", list(target.station_timestamp_timeofdeath))
		render_list += LANG("_root.c1cc23e52102bb26", list(DisplayTimeText(round(world.time - target.timeofdeath))))

	. = lang_localize_health_scan(jointext(render_list, "")) // NOVA EDIT CHANGE - i18n: localize composed scan-report structural labels (bypasses sink/P1) - ORIGINAL: . = jointext(render_list, "")
	if(tochat)
		to_chat(user, custom_boxed_message("blue_box", .), trailing_newline = FALSE, type = MESSAGE_TYPE_INFO)
	return .

/obj/item/healthanalyzer/click_ctrl_shift(mob/user)
	. = ..()
	if(!LAZYLEN(last_scan_text))
		balloon_alert(user, LANG("obj.e9bab8942f6e3e81", null))
		return
	if(scanner_busy)
		balloon_alert(user, LANG("obj.0a57825b64ade85f", null))
		return
	scanner_busy = TRUE
	balloon_alert(user, LANG("obj.6a68c3d7638f1ac2", null))
	addtimer(CALLBACK(src, PROC_REF(print_report), user), 2 SECONDS)

/obj/item/healthanalyzer/proc/print_report(mob/user)
	var/obj/item/paper/medical_report/report_paper = new(get_turf(src))

	report_paper.color = "#99ccff"
	report_paper.name = "health scan report - [server_timestamp(format = "hh:mm", ic_time = TRUE)]"
	var/report_text = "<center><B>Health scan report</br>\
		Time of retrieval: [UNDERLINED_HTML_TEXT("[server_timestamp(format = "hh:mm", ic_time = TRUE)]", "Shift Time: [round_timestamp(format = "hh:mm")]")]</B></center><HR>"
	report_text += last_scan_text

	report_paper.add_raw_text(report_text, advanced_html = TRUE)
	report_paper.update_appearance()

	user.put_in_hands(report_paper)
	balloon_alert(user, LANG("obj.f994178879c12924", null))

	resolve_patient_eligibility(report_paper, user)
	report_text = list()
	scanner_busy = FALSE

/**
 * Checks the mob and the medical report that the scanner is trying to print, checks the traits and statuses of the mob, and then resolves by true or false.
 * Applies traits to the patient if the scanning is eligable to turn in for a bounty, with callbacks to remove after a cooldown.
 */
/obj/item/healthanalyzer/proc/resolve_patient_eligibility(obj/item/paper/medical_report/report_paper, mob/scanner)
	var/mob/living/patient = last_healthy_scanned?.resolve()
	if(!patient)
		return FALSE

	if(scanner == patient)
		return FALSE //You can't just scan yourself.

	if(HAS_TRAIT(patient, TRAIT_RECENTLY_TREATED))
		return FALSE

	report_paper.last_healthy_scanned_mob = last_healthy_scanned
	ADD_TRAIT(patient, TRAIT_RECENTLY_TREATED, ANALYZER_TRAIT)
	addtimer(TRAIT_CALLBACK_REMOVE(patient, RECENTLY_HEALED_COOLDOWN, ANALYZER_TRAIT), RECENTLY_HEALED_COOLDOWN)
	return TRUE

/obj/item/healthanalyzer/proc/clear_treatment(mob/living/target)
	if(!target)
		return
	if(QDELETED(target))
		return
	REMOVE_TRAIT(target, TRAIT_RECENTLY_TREATED, ANALYZER_TRAIT)
	return TRUE

/proc/chemscan(mob/living/user, mob/living/target, reagent_types_to_check = null, tochat = TRUE)
	if(user.incapacitated)
		return

	if(istype(target) && target.reagents)
		var/list/render_list = list() //The master list of readouts, including reagents in the blood/stomach, addictions, quirks, etc.
		var/list/render_block = list() //A second block of readout strings. If this ends up empty after checking stomach/blood contents, we give the "empty" header.

		// NOVA EDIT ADDITION BEGIN - Neuroware
		var/list/neuroware_list = list()
		// NOVA EDIT ADDITION END
		// Blood reagents
		if(target.reagents.reagent_list.len)
			for(var/r in target.reagents.reagent_list)
				var/datum/reagent/reagent = r
				// NOVA EDIT ADDITION BEGIN - Neuroware
				if(reagent.chemical_flags & REAGENT_NEUROWARE)
					neuroware_list += LANG("_root.016db5537f9e312c", list(reagent.name, round(reagent.volume, 0.001), reagent.overdosed ? "</span> - [span_bolddanger("OVERLOADING")]" : ".</span>"))
				// NOVA EDIT ADDITION END
				if(reagent.chemical_flags & REAGENT_INVISIBLE) //Don't show hidden chems on scanners
					continue
				if(reagent_types_to_check)
					if(!istype(reagent, reagent_types_to_check))
						continue
				render_block += LANG("_root.43838dc2f1da996c", list(round(reagent.volume, 0.001), reagent.name, reagent.overdosed ? "</span> - [span_bolddanger("OVERDOSING")]" : ".</span>"))

		// NOVA EDIT ADDITION BEGIN - Neuroware
		if(target.is_neuroware_compatible())
			if(length(neuroware_list))
				render_list += LANG("_root.ca74910e81f51783", null)
				render_list += jointext(neuroware_list + "<br>", "")
			else
				render_list += LANG("_root.613b5f653c74cd19", null)
		// NOVA EDIT ADDITION END
		if(!length(render_block)) //If no VISIBLY DISPLAYED reagents are present, we report as if there is nothing.
			render_list += LANG("_root.eed489e0024590f0", list(LOWER_TEXT(target.get_bloodtype()?.get_blood_name()) || "blood"))
		else
			render_list += LANG("_root.53ae9b87e8df66de", list(LOWER_TEXT(target.get_bloodtype()?.get_blood_name()) || "blood"))
			render_list += render_block //Otherwise, we add the header, reagent readouts, and clear the readout block for use on the stomach.
			render_block.Cut()

		// Stomach reagents
		var/obj/item/organ/stomach/belly = target.get_organ_slot(ORGAN_SLOT_STOMACH)
		if(belly)
			if(belly.reagents.reagent_list.len)
				for(var/bile in belly.reagents.reagent_list)
					var/datum/reagent/bit = bile
					if(bit.chemical_flags & REAGENT_INVISIBLE)
						continue
					if(reagent_types_to_check)
						if(!istype(bit, reagent_types_to_check))
							continue
					if(!belly.food_reagents[bit.type])
						render_block += LANG("_root.43838dc2f1da996c", list(round(bit.volume, 0.001), bit.name, bit.overdosed ? "</span> - [span_bolddanger("OVERDOSING")]" : ".</span>"))
					else
						var/bit_vol = bit.volume - belly.food_reagents[bit.type]
						if(bit_vol > 0)
							render_block += LANG("_root.43838dc2f1da996c", list(round(bit_vol, 0.001), bit.name, bit.overdosed ? "</span> - [span_bolddanger("OVERDOSING")]" : ".</span>"))

			if(!length(render_block))
				render_list += LANG("_root.5007d456792b3dff", null)
			else
				render_list += LANG("_root.11fd00daf9078a4d", null)
				render_list += render_block

		// Addictions
		if(LAZYLEN(target.mind?.active_addictions))
			render_list += LANG("_root.06dfb47a7e09e24d", null)
			for(var/datum/addiction/addiction_type as anything in target.mind.active_addictions)
				render_list += "<span class='alert ml-2'>[initial(addiction_type.name)]</span><br>"

		// Special eigenstasium addiction
		if(target.has_status_effect(/datum/status_effect/eigenstasium))
			render_list += LANG("_root.a8bfa0b5414aa908", null)

		// Allergies
		for(var/datum/quirk/quirky as anything in target.quirks)
			if(istype(quirky, /datum/quirk/item_quirk/allergic))
				var/datum/quirk/item_quirk/allergic/allergies_quirk = quirky
				var/allergies = allergies_quirk.allergy_string
				render_list += "<span class='alert ml-1'>[LANG("obj.3baac8acac2e44a5", null)]</span><br>" // NOVA EDIT - I18N
				render_list += "<span class='alert ml-2'>[allergies]</span><br>"

		// we handled the last <br> so we don't need handholding
		if(tochat)
			to_chat(user, custom_boxed_message("blue_box", jointext(render_list, "")), trailing_newline = FALSE, type = MESSAGE_TYPE_INFO)
		else
			return jointext(render_list, "")

/obj/item/healthanalyzer/click_alt(mob/user)
	if(mode == SCANNER_NO_MODE)
		return CLICK_ACTION_BLOCKING

	mode = !mode
	to_chat(user, mode == SCANNER_VERBOSE ? "The scanner now shows specific limb damage." : "The scanner no longer shows limb damage.")
	return CLICK_ACTION_SUCCESS

/obj/item/healthanalyzer/advanced
	name = "advanced health analyzer"
	icon_state = "health_adv"
	desc = "A hand-held body scanner able to distinguish vital signs of the subject with high accuracy."
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/glass = SHEET_MATERIAL_AMOUNT * 1.25, /datum/material/silver = SHEET_MATERIAL_AMOUNT, /datum/material/gold = SHEET_MATERIAL_AMOUNT * 0.75)
	scanpower = SCANPOWER_ADVANCED

/obj/item/healthanalyzer/super
	name = "super health analyzer"
	icon_state = "health_super"
	desc = "A health scanner for debuggers. Functions the same as ghost healthscans."
	scanpower = SCANPOWER_SUPER

#define AID_EMOTION_NEUTRAL "neutral"
#define AID_EMOTION_HAPPY "happy"
#define AID_EMOTION_WARN "cautious"
#define AID_EMOTION_ANGRY "angery"
#define AID_EMOTION_SAD "sad"

/// Displays wounds with extended information on their status vs medscanners
/proc/woundscan(mob/user, mob/living/carbon/patient, obj/item/healthanalyzer/scanner, simple_scan = FALSE)
	if(!istype(patient) || user.incapacitated)
		return

	var/render_list = ""
	var/advised = FALSE
	for(var/limb in patient.get_wounded_bodyparts())
		var/obj/item/bodypart/wounded_part = limb
		render_list += LANG("_root.e5c30b2c62eb9546", list(LAZYLEN(wounded_part.wounds) > 1? "s" : "", wounded_part.name))
		for(var/limb_wound in wounded_part.wounds)
			var/datum/wound/current_wound = limb_wound
			render_list += "<div class='ml-2'>[simple_scan ? current_wound.get_simple_scanner_description() : current_wound.get_scanner_description()]</div><br>"
			if (scanner.give_wound_treatment_bonus)
				ADD_TRAIT(current_wound, TRAIT_WOUND_SCANNED, ANALYZER_TRAIT)
				if(!advised)
					to_chat(user, span_notice(LANG("_root.77738b07ae57cdc4", list((length(wounded_part.wounds) || length(patient.get_wounded_bodyparts()) ) > 1 ? "various wounds" : "wound"))))
					advised = TRUE
		render_list += "</span>"

	if(render_list == "")
		if(simple_scan)
			var/obj/item/healthanalyzer/simple/simple_scanner = scanner
			// Only emit the cheerful scanner message if this scan came from a scanner
			playsound(simple_scanner, 'sound/machines/ping.ogg', 50, FALSE)
			to_chat(user, span_notice(LANG("_root.5d90facdc7aafb44", list(simple_scanner, patient))))
			simple_scanner.show_emotion(AID_EMOTION_HAPPY)
		to_chat(user, LANG("_root.de87838d8996ce7d", null))
	else
		to_chat(user, custom_boxed_message("blue_box", jointext(render_list, "")), type = MESSAGE_TYPE_INFO)
		if(simple_scan)
			var/obj/item/healthanalyzer/simple/simple_scanner = scanner
			simple_scanner.show_emotion(AID_EMOTION_WARN)
			playsound(simple_scanner, 'sound/machines/beep/twobeep.ogg', 50, FALSE)


/obj/item/healthanalyzer/simple
	name = "wound analyzer"
	icon_state = "first_aid"
	desc = "A helpful, child-proofed, and most importantly, extremely cheap MeLo-Tech medical scanner used to diagnose injuries and recommend treatment for serious wounds. While it might not sound very informative for it to be able to tell you if you have a gaping hole in your body or not, it applies a temporary holoimage near the wound with information that is guaranteed to double the efficacy and speed of treatment."
	mode = SCANNER_NO_MODE
	give_wound_treatment_bonus = TRUE

	/// Cooldown for when the analyzer will allow you to ask it for encouragement. Don't get greedy!
	var/next_encouragement
	/// The analyzer's current emotion. Affects the sprite overlays and if it's going to prick you for being greedy or not.
	var/emotion = AID_EMOTION_NEUTRAL
	/// Encouragements to play when attack_selfing
	var/list/encouragements = list("briefly displays a happy face, gazing emptily at you", "briefly displays a spinning cartoon heart", "displays an encouraging message about eating healthy and exercising", \
			"reminds you that everyone is doing their best", "displays a message wishing you well", "displays a sincere thank-you for your interest in first-aid", "formally absolves you of all your sins")
	/// How often one can ask for encouragement
	var/patience = 10 SECONDS
	/// What do we scan for, only used in descriptions
	var/scan_for_what = "serious injuries"

/obj/item/healthanalyzer/simple/attack_self(mob/user)
	if(next_encouragement < world.time)
		playsound(src, 'sound/machines/ping.ogg', 50, FALSE)
		to_chat(user, span_notice(LANG("obj.2d52a7f174abd03c", list(src, pick(encouragements)))))
		next_encouragement = world.time + 10 SECONDS
		show_emotion(AID_EMOTION_HAPPY)
	else if(emotion != AID_EMOTION_ANGRY)
		greed_warning(user)
	else
		violence(user)

/obj/item/healthanalyzer/simple/proc/greed_warning(mob/user)
	to_chat(user, span_warning(LANG("obj.232b1012ac681159", list(src))))
	show_emotion(AID_EMOTION_ANGRY)

/obj/item/healthanalyzer/simple/proc/violence(mob/user)
	playsound(src, 'sound/machines/buzz/buzz-sigh.ogg', 50, FALSE)
	if(isliving(user))
		var/mob/living/L = user
		to_chat(L, span_warning(LANG("obj.f5a2025dcfa9b6f3", list(src))))
		flick(icon_state + "_pinprick", src)
		violence_damage(user)
		user.dropItemToGround(src)
		show_emotion(AID_EMOTION_HAPPY)

/obj/item/healthanalyzer/simple/proc/violence_damage(mob/living/user)
	user.adjust_brute_loss(4)

/obj/item/healthanalyzer/simple/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!isliving(interacting_with))
		return NONE
	if(!user.can_read(src)) //NOVA EDIT CHANGE - Blind People Can Analyze Again - ORIGINAL: if(!user.can_read(src) || user.is_blind())
		return ITEM_INTERACT_BLOCKING

	add_fingerprint(user)
	user.visible_message(
		span_notice(LANG("obj.2369a9097ebbc9a8", list(user, interacting_with, scan_for_what))),
		span_notice(LANG("obj.3ff3ac734f6f0c33", list(interacting_with, scan_for_what))),
	)

	if(!iscarbon(interacting_with))
		playsound(src, 'sound/machines/buzz/buzz-sigh.ogg', 30, TRUE)
		to_chat(user, span_notice(LANG("obj.7804b646e1faceaf", list(src, interacting_with))))
		show_emotion(AI_EMOTION_SAD)
		return ITEM_INTERACT_BLOCKING

	do_the_scan(interacting_with, user)
	flick(icon_state + "_pinprick", src)
	update_appearance(UPDATE_OVERLAYS)
	return ITEM_INTERACT_SUCCESS

/obj/item/healthanalyzer/simple/proc/do_the_scan(mob/living/carbon/scanning, mob/living/user)
	woundscan(user, scanning, src, simple_scan = TRUE)

/obj/item/healthanalyzer/simple/update_overlays()
	. = ..()
	switch(emotion)
		if(AID_EMOTION_HAPPY)
			. += mutable_appearance(icon, "+no_wounds")
		if(AID_EMOTION_WARN)
			. += mutable_appearance(icon, "+wound_warn")
		if(AID_EMOTION_ANGRY)
			. += mutable_appearance(icon, "+angry")
		if(AID_EMOTION_SAD)
			. += mutable_appearance(icon, "+fail_scan")

/// Sets a new emotion display on the scanner, and resets back to neutral in a moment
/obj/item/healthanalyzer/simple/proc/show_emotion(new_emotion)
	emotion = new_emotion
	update_appearance(UPDATE_OVERLAYS)
	if (emotion != AID_EMOTION_NEUTRAL)
		addtimer(CALLBACK(src, PROC_REF(reset_emotions), AID_EMOTION_NEUTRAL), 2 SECONDS)

// Resets visible emotion back to neutral
/obj/item/healthanalyzer/simple/proc/reset_emotions()
	emotion = AID_EMOTION_NEUTRAL
	update_appearance(UPDATE_OVERLAYS)

/obj/item/healthanalyzer/simple/miner
	name = "mining wound analyzer"
	icon_state = "miner_aid"
	desc = "A helpful, child-proofed, and most importantly, extremely cheap MeLo-Tech medical scanner used to diagnose injuries and recommend treatment for serious wounds. While it might not sound very informative for it to be able to tell you if you have a gaping hole in your body or not, it applies a temporary holoimage near the wound with information that is guaranteed to double the efficacy and speed of treatment. This one has a cool aesthetic antenna that doesn't actually do anything!"

/obj/item/healthanalyzer/simple/disease
	name = "disease state analyzer"
	desc = "Another of MeLo-Tech's dubiously useful medsci scanners, the disease analyzer is a pretty rare find these days - NT found out that giving their hospitals the lowest-common-denominator pandemic equipment resulted in too much financial loss of life to be profitable. There are rumours that the inbuilt AI is jealous of the first aid analyzer's success."
	icon_state = "disease_aid"
	mode = SCANNER_NO_MODE
	encouragements = list("encourages you to take your medication", "briefly displays a spinning cartoon heart", "reasures you about your condition", \
			"reminds you that everyone is doing their best", "displays a message wishing you well", "displays a message saying how proud it is that you're taking care of yourself", "formally absolves you of all your sins")
	patience = 20 SECONDS
	scan_for_what = "diseases"

/obj/item/healthanalyzer/simple/disease/violence_damage(mob/living/user)
	user.adjust_brute_loss(1)
	user.reagents.add_reagent(/datum/reagent/toxin, rand(1, 3))

/obj/item/healthanalyzer/simple/disease/do_the_scan(mob/living/carbon/scanning, mob/living/user)
	diseasescan(user, scanning, src)

/obj/item/healthanalyzer/simple/disease/update_overlays()
	. = ..()
	switch(emotion)
		if(AID_EMOTION_HAPPY)
			. += mutable_appearance(icon, "+not_infected")
		if(AID_EMOTION_WARN)
			. += mutable_appearance(icon, "+infected")
		if(AID_EMOTION_ANGRY)
			. += mutable_appearance(icon, "+rancurous")
		if(AID_EMOTION_SAD)
			. += mutable_appearance(icon, "+unknown_scan")
	if(emotion != AID_EMOTION_NEUTRAL)
		addtimer(CALLBACK(src, PROC_REF(reset_emotions)), 4 SECONDS) // longer on purpose

/// Checks the individual for any diseases that are visible to the scanner, and displays the diseases in the attacked to the attacker.
/proc/diseasescan(mob/user, mob/living/carbon/patient, obj/item/healthanalyzer/simple/scanner)
	if(!istype(patient) || user.incapacitated)
		return

	var/list/render = list()
	for(var/datum/disease/disease as anything in patient.diseases)
		if(!(disease.visibility_flags & HIDDEN_SCANNER))
			var/disease_cure = disease.cure_text
			if(istype(disease, /datum/disease/advance))
				var/datum/disease/advance/advanced_disease = disease
				disease_cure = advanced_disease.generate_cure_text(1)
			// NOVA EDIT CHANGE START - I18N: 同上，与 healthscan 共用同一批模板。
			render += "<span class='alert ml-1'><b>[LANG("obj.91316a71286b9e71", list(disease.form))]</b><br>\
			<div class='ml-2'>[LANG("obj.f9ef6cb2c0edc742", list(disease.name, disease.spread_text, disease.stage, disease.max_stages, disease_cure))]</div>\
			</span>"
			// NOVA EDIT CHANGE END

	if(!length(render))
		playsound(scanner, 'sound/machines/ping.ogg', 50, FALSE)
		to_chat(user, span_notice(LANG("_root.f44aa4bf4573835f", list(scanner, patient))))
		scanner.emotion = AID_EMOTION_HAPPY
	else
		to_chat(user, span_notice(render.Join("")))
		scanner.emotion = AID_EMOTION_WARN
		playsound(scanner, 'sound/machines/beep/twobeep.ogg', 50, FALSE)

/obj/item/paper/medical_report
	color = "#99ccff"
	desc = "An official medical bill of health generated by a computerized medical scanner."
	/// A reference to a mob's weakref that was last scanned by the medical scanner.
	var/datum/weakref/last_healthy_scanned_mob

/obj/item/paper/medical_report/examine(mob/user)
	. = ..()
	if(last_healthy_scanned_mob)
		. += span_notice(LANG("obj.138779eafa9069f6", null))


#undef SCANMODE_HEALTH
#undef SCANMODE_WOUND
#undef SCANMODE_COUNT

#undef AID_EMOTION_NEUTRAL
#undef AID_EMOTION_HAPPY
#undef AID_EMOTION_WARN
#undef AID_EMOTION_ANGRY
#undef AID_EMOTION_SAD
