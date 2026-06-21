/obj/effect/mob_spawn/ghost_role/human/hc_officer
	name = "HC Patrol Officer"
	desc = "A comfortable-looking sleeper unit adorned with the insignia of the Heliostatic Coalition Internal Affairs Department."
	prompt_name = "一名HC远征巡逻警官"
	icon = 'modular_nova/modules/cryosleep/icons/cryogenics.dmi'
	icon_state = "cryopod"
	mob_species = /datum/species/human
	faction = list(FACTION_NEUTRAL)
	you_are_text = "你是日心联盟远征巡逻队的一名警官。"
	flavour_text = "你的巡逻舰正在对这个偏远设施进行标准合规与检查行动。你的授权源自联盟协定，赋予你检查、没收违禁品以及使用必要武力保护联盟利益的权力。保持警惕至关重要；这些空间站是自治的，并非天生可信。务必始终遵守标准操作程序。"
	important_text = "遵循指挥链。你的巡逻队长呼号后缀为'Actual'。保持专业纪律，并根据情况需要做好适当升级的准备。"
	outfit = /datum/outfit/hc_officer
	allow_custom_character = GHOSTROLE_TAKE_PREFS_APPEARANCE
	quirks_enabled = TRUE
	show_flavor = TRUE
	/// To know whether or not we have an officer already, keep a ref to them
	var/static/first_officer

/obj/effect/mob_spawn/ghost_role/human/hc_officer/proc/apply_codename(mob/living/spawned_mob, mob/mob_possessor, apply_prefs)
	var/callsign = pick(GLOB.callsigns_nri)
	var/number = pick(GLOB.phonetic_alphabet_numbers)
	var/full_name = "[callsign] [number]"
	if(first_officer == REF(spawned_mob))
		full_name += " Actual"
	spawned_mob.fully_replace_character_name(spawned_mob.real_name, full_name)

/obj/effect/mob_spawn/ghost_role/human/hc_officer/post_transfer_prefs(mob/living/spawned_mob)
	. = ..()
	spawned_mob.mind.add_antag_datum(/datum/antagonist/cop)
	spawned_mob.grant_language(/datum/language/spinwarder, source = LANGUAGE_SPAWNER)
	spawned_mob.grant_language(/datum/language/uncommon, source = LANGUAGE_SPAWNER)
	spawned_mob.grant_language(/datum/language/yangyu, source = LANGUAGE_SPAWNER)
	spawned_mob.grant_language(/datum/language/akulan, source = LANGUAGE_SPAWNER)

	// if this is the first officer, keep a reference to them
	if(!first_officer)
		first_officer = REF(spawned_mob)
		to_chat(spawned_mob, span_bold("You are the Patrol Leader (Actual). You hold ultimate authority and responsibility for this mission. \
			Your directives are to: Ensure the safety of your personnel and vessel. Conduct a thorough inspection for contraband and violations per \
			SOP Section V. Project Coalition authority and assess the facility's compliance. Declare Alert Status changes based on observed threats. \
			Your discretion in the field is final. Consult your Field Guide and SOP documents." \
		))

	to_chat(spawned_mob, "[span_boldnotice("Your primary duty is to the Heliostatic Coalition. \
		This inspection is a right granted by treaty, not a request. \
		Be firm, professional, and by-the-book. Trust must be earned, \
		and violations of procedure are to be met with immediate challenges \
		and elevated alert statuses. Your ship contains your SOP documents; \
		consult them for rules of engagement, contraband categories, and Bluespace Artillery countermeasures.")] <br><br>\
		[span_info("OOC Note: Your objectives are narrative guides for creating collaborative roleplay. \
		They are not mechanical 'greentext' goals. Focus on the experience. If you have a creative idea for a gimmick or story direction, \
		communicating with the admins and other players is encouraged.")]")
	apply_codename(spawned_mob)

/obj/effect/mob_spawn/ghost_role/human/hc_officer/equip(mob/living/spawned_mob)
	. = ..()
	var/obj/item/card/id/advanced/card = spawned_mob.get_idcard()
	if(first_officer == REF(spawned_mob))
		card.assignment = pick(HC_LEADER_JOB_LIST)
		card.trim.sechud_icon_state = "hud_hc_police_lead"
	else
		card.assignment = pick(HC_JOB_LIST)
		card.trim.sechud_icon_state = "hud_hc_police"

	card.update_label()

/obj/effect/mob_spawn/ghost_role/human/hc_officer/Destroy(force)
	var/atom/drop_location = drop_location()
	if(!QDELETED(drop_location))
		new /obj/structure/showcase/machinery/oldpod/used(drop_location)
	return ..()
