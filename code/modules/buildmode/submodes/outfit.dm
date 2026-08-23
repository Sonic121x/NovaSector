// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/buildmode_mode/outfit
	key = "outfit"
	var/datum/outfit/dressuptime

/datum/buildmode_mode/outfit/Destroy()
	dressuptime = null
	return ..()

/datum/buildmode_mode/outfit/show_help(client/builder)
	to_chat(builder, span_purple(boxed_message(
		LANG("datum.016855a1f304fb1c", list(span_bold("Select outfit to equip"), span_bold("Equip the selected outfit"), span_bold("Strip and delete current outfit")))))
	)

/datum/buildmode_mode/outfit/Reset()
	. = ..()
	dressuptime = null

/datum/buildmode_mode/outfit/change_settings(client/c)
	dressuptime = c.robust_dress_shop()

/datum/buildmode_mode/outfit/handle_click(client/c, params, object)
	var/list/modifiers = params2list(params)

	if(!ishuman(object))
		return
	var/mob/living/carbon/human/dollie = object

	if(LAZYACCESS(modifiers, LEFT_CLICK))
		if(isnull(dressuptime))
			to_chat(c, span_warning(LANG("datum.b9a1525dd7af56c7", null)))
			return

		for (var/item in dollie.get_equipped_items(INCLUDE_POCKETS))
			qdel(item)
		if(dressuptime != "Naked")
			dollie.equipOutfit(dressuptime)

	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		for (var/item in dollie.get_equipped_items(INCLUDE_POCKETS))
			qdel(item)
