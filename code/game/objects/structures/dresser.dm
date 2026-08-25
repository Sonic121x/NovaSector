// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/structure/dresser
	name = "dresser"
	desc = "A nicely-crafted wooden dresser. It's filled with lots of undies."
	icon = 'icons/obj/fluff/general.dmi' //NOVA EDIT - ICON OVERRIDDEN IN AESTHETICS MODULE
	icon_state = "dresser"
	resistance_flags = FLAMMABLE
	density = TRUE
	anchored = TRUE
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 10)

/obj/structure/dresser/wrench_act(mob/living/user, obj/item/tool)
	to_chat(user, span_notice(LANG("obj.8b820c989748b0b7", list(anchored ? "unwrench" : "wrench", src))))
	if(!tool.use_tool(src, user, 20, volume=50))
		return ITEM_INTERACT_BLOCKING

	to_chat(user, span_notice(LANG("obj.5e680a27fb6982c5", list(anchored ? "unwrench" : "wrench", src))))
	set_anchored(!anchored)
	return ITEM_INTERACT_SUCCESS

/obj/structure/dresser/atom_deconstruct(disassembled = TRUE)
	new /obj/item/stack/sheet/mineral/wood(drop_location(), 10)

/obj/structure/dresser/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(!Adjacent(user))//no tele-grooming
		return
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/dressing_human = user
	if(HAS_TRAIT(dressing_human, TRAIT_NO_UNDERWEAR))
		to_chat(dressing_human, span_warning(LANG("obj.46fd52b3e6237981", null)))
		return

	var/choice = tgui_input_list(user, LANG("obj.e9f42888e0042be0", null), LANG("obj.e27ef6c68c6873f5", null), list("Underwear", "Underwear Color", "Bra", "Bra Color", "Undershirt", "Undershirt Color", "Socks", "Socks Color")) //NOVA EDIT ADDITION - Colorable Undershirt/Socks/Bra
	if(isnull(choice))
		return

	if(!Adjacent(user))
		return
	switch(choice)
		if("Underwear")
			var/new_undies = tgui_input_list(user, LANG("obj.c22948feef15725e", null), LANG("obj.e27ef6c68c6873f5", null), SSaccessories.underwear_list)
			if(new_undies)
				dressing_human.underwear = new_undies
		if("Underwear Color")
			var/new_underwear_color = tgui_color_picker(dressing_human, "Choose your underwear color", "Underwear Color", dressing_human.underwear_color)
			if(new_underwear_color)
				dressing_human.underwear_color = sanitize_hexcolor(new_underwear_color)
		if("Undershirt")
			var/new_undershirt = tgui_input_list(user, LANG("obj.af3cd6d57d8d4f67", null), LANG("obj.e27ef6c68c6873f5", null), SSaccessories.undershirt_list)
			if(new_undershirt)
				dressing_human.undershirt = new_undershirt
		if("Socks")
			var/new_socks = tgui_input_list(user, LANG("obj.0931151191970d02", null), LANG("obj.e27ef6c68c6873f5", null), SSaccessories.socks_list)
			if(new_socks)
				dressing_human.socks = new_socks
		//NOVA EDIT ADDITION BEGIN - Colorable Undershirt/Socks/Bras
		if("Undershirt Color")
			var/new_undershirt_color = tgui_color_picker(dressing_human, "Choose your undershirt color", "Undershirt Color", dressing_human.undershirt_color)
			if(new_undershirt_color)
				dressing_human.undershirt_color = sanitize_hexcolor(new_undershirt_color)
		if("Socks Color")
			var/new_socks_color = tgui_color_picker(dressing_human, "Choose your socks color", "Socks Color", dressing_human.socks_color)
			if(new_socks_color)
				dressing_human.socks_color = sanitize_hexcolor(new_socks_color)

		if("Bra")
			var/new_bra = tgui_input_list(user, LANG("obj.a52637d72683479b", null), LANG("obj.e27ef6c68c6873f5", null), SSaccessories.bra_list)
			if(new_bra)
				dressing_human.bra = new_bra

		if("Bra Color")
			var/new_bra_color = tgui_color_picker(dressing_human, "Choose your Bra color", "Bra Color", dressing_human.bra_color)
			if(new_bra_color)
				dressing_human.bra_color = sanitize_hexcolor(new_bra_color)

		//NOVA EDIT ADDITION END - Colorable Undershirt/Socks/Bras

	add_fingerprint(dressing_human)
	dressing_human.update_body()
