// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/*
 * Attempts to grant the target all organs from a given DNA infuser entry.area
 * Returns the entry if all organs were successfully replaced.
 * If no infusion was picked, the infusion had no organs, or if one or more organs could not be granted, returns FALSE
*/
GAME_VERB_PROC(/client, grant_dna_infusion, "应用 DNA 灌注", "Debug", mob/living/carbon/human/target)

	var/list/infusions = list()
	for(var/datum/infuser_entry/path as anything in sort_list(subtypesof(/datum/infuser_entry), GLOBAL_PROC_REF(cmp_typepaths_asc)))
		var/str = "[initial(path.name)] ([path])"
		infusions[str] = path

	var/datum/infuser_entry/picked_infusion = tgui_input_list(usr, LANG("client.d9c73f66", null), LANG("client.a8cd614e", null), infusions)

	if(isnull(picked_infusion))
		return FALSE

	// This is necessary because list propererties are not defined until initialization
	picked_infusion = infusions[picked_infusion]
	picked_infusion = new picked_infusion()

	if(!length(picked_infusion.output_organs))
		return FALSE

	. = picked_infusion
	for(var/obj/item/organ/infusion_organ as anything in picked_infusion.output_organs)
		var/obj/item/organ/new_organ = new infusion_organ()
		new_organ.replace_into(target)
		if(new_organ.owner != target)
			to_chat(usr, span_notice(LANG("client.41edee27", list(target, new_organ))))
			qdel(new_organ)
			. = FALSE
			continue
		log_admin("[key_name(usr)] has added organ [new_organ.type] to [key_name(target)]")
		message_admins("[key_name_admin(usr)] has added organ [new_organ.type] to [ADMIN_LOOKUPFLW(target)]")
