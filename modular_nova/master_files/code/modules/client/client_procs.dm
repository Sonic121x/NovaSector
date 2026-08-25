
////  Toggles Selected quirks on selected mobs
/client/proc/toggle_quirk(mob/living/carbon/human/selected_mob)
	if (!istype(selected_mob))
		to_chat(usr, LANG("client.7d5ef419b6dc3426", null))
		return

	var/list/options = list("Clear"="Clear")
	for(var/quirk_variable in subtypesof(/datum/quirk))
		var/datum/quirk/applicable_quirk = quirk_variable
		var/qname = initial(applicable_quirk.name)
		options[selected_mob.has_quirk(applicable_quirk) ? "[qname] (Remove)" : "[qname] (Add)"] = applicable_quirk

	var/result = tgui_input_list(usr, LANG("client.b1be79e5649e97ba", null), LANG("client.dbe7a3d7aa20fd69", null), options)

	if(QDELETED(selected_mob))
		to_chat(usr, LANG("client.4068a4c39ab7926b", null))
		return

	if(result)
		if(result == "Clear")
			for(var/datum/quirk/selected_quirk in selected_mob.quirks)
				selected_mob.remove_quirk(selected_quirk.type)
		else
			var/toggle_quirk = options[result]
			if(selected_mob.has_quirk(toggle_quirk))
				selected_mob.remove_quirk(toggle_quirk)
			else
				selected_mob.add_quirk(toggle_quirk,TRUE)

////  "Teaches" Martial arts to the selected mob
/client/proc/teach_martial_art(mob/living/carbon/selected_mob)
	if (!istype(selected_mob))
		to_chat(usr, LANG("client.5519505c2d10dd12", null))
		return

	var/list/artpaths = subtypesof(/datum/martial_art)
	var/list/artnames = list()
	for(var/martial_art_skill in artpaths)
		var/datum/martial_art/martial_skill = martial_art_skill
		artnames[initial(martial_skill.name)] = martial_skill
	var/result = tgui_input_list(usr, LANG("client.5962091364ccf470", null), LANG("client.918a4230a25a86ef", null), artnames)
	if(isnull(result))
		return

	if(QDELETED(selected_mob))
		to_chat(usr, LANG("client.4068a4c39ab7926b", null))
		return
	if(result)
		var/chosenart = artnames[result]
		var/datum/martial_art/martial_skill = new chosenart
		martial_skill.teach(selected_mob)
		log_admin("[key_name(usr)] has taught [martial_skill] to [key_name(selected_mob)].")
		message_admins(span_notice("[key_name_admin(usr)] has taught [martial_skill] to [key_name_admin(selected_mob)]."))

////  Sets species of the selected client
/client/proc/set_species(mob/living/carbon/human/selected_mob)
	if (istype(selected_mob))
		var/result = tgui_input_list(usr, LANG("client.ae3418a89c0ef66d", null),LANG("client.85a5d525356ee5fa", null), GLOB.species_list)
		if(QDELETED(selected_mob))
			to_chat(usr, LANG("client.4068a4c39ab7926b", null))
			return
		if(result)
			admin_ticket_log("[key_name_admin(usr)] has modified the bodyparts of [selected_mob] to [result]")
			selected_mob.set_species(GLOB.species_list[result])
