/client/proc/makepAI(turf/target in GLOB.mob_list)
	set category = "Admin.Fun"
	set name = "Make pAI"
	set desc = "Specify a location to spawn a pAI device, then specify a key to play that pAI"

	var/list/available = list()
	for(var/mob/player as anything in GLOB.player_list)
		if(player.client && player.key)
			available.Add(player)
	var/mob/choice = tgui_input_list(usr, "选择一名玩家来扮演pAI", "生成pAI", sort_names(available))
	if(isnull(choice))
		return

	var/chosen_name = input(choice, "输入你的pAI名称：", "pAI名称", "个人AI") as text|null
	if (isnull(chosen_name))
		return

	if(!isobserver(choice))
		var/confirm = tgui_alert(usr, "[choice.key]目前并非幽灵状态。你确定要将他们从其身体中拽出并放入这个pAI中吗？", "生成pAI确认", list("Yes", "No"))
		if(confirm != "Yes")
			return
	var/obj/item/pai_card/card = new(target)
	var/mob/living/silicon/pai/pai = new(card)

	pai.name = chosen_name
	pai.real_name = pai.name
	pai.PossessByPlayer(choice.key)
	card.set_personality(pai)
	if(SSpai.candidates[key])
		SSpai.candidates -= key
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
