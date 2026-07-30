// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
ADMIN_VERB(makepAI, R_FUN, "制作 pAI", "Specify a location to spawn a pAI device, then specify a key to play that pAI", ADMIN_CATEGORY_FUN, turf/target)
	var/list/available = list()
	for(var/mob/player as anything in GLOB.player_list)
		if(player.client && player.key)
			available.Add(player)
	var/mob/choice = tgui_input_list(user, LANG("datum.9693a445", null), LANG("datum.39711a9b", null), sort_names(available))
	if(isnull(choice))
		return

	var/chosen_name = input(choice, LANG("datum.cbd93c97", null), LANG("datum.cbfd823f", null), "Personal AI") as text|null
	if (isnull(chosen_name))
		return

	if(!isobserver(choice))
		var/confirm = tgui_alert(user, LANG("datum.ae34e922", list(choice.key)), LANG("datum.a84188a3", null), list("Yes", "No"))
		if(confirm != "Yes")
			return
	var/obj/item/pai_card/card = new(target)
	var/mob/living/silicon/pai/pai = new(card)

	pai.name = chosen_name
	pai.real_name = pai.name
	pai.PossessByPlayer(choice.key)
	card.set_personality(pai)
	if(SSpai.candidates[user.key])
		SSpai.candidates -= user.key
	BLACKBOX_LOG_ADMIN_VERB("Make pAI")

/**
 * Creates a new pAI.
 *
 * @param {boolean} delete_old - If TRUE, deletes the old pAI.
 */
/mob/proc/make_pai(delete_old)
	var/obj/item/pai_card/card = new(src)
	var/mob/living/silicon/pai/pai = new(card)
	pai.PossessByPlayer(key)
	pai.name = name
	card.set_personality(pai)
	if(delete_old)
		qdel(src)
