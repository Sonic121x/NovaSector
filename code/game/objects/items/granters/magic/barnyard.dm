// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/book/granter/action/spell/barnyard
	granted_action = /datum/action/cooldown/spell/pointed/barnyardcurse
	action_name = "barnyard"
	icon_state ="bookhorses"
	desc = "This book is more horse than your mind has room for."
	remarks = list(
		"Moooooooo!",
		"Moo!",
		"Moooo!",
		"NEEIIGGGHHHH!",
		"NEEEIIIIGHH!",
		"NEIIIGGHH!",
		"HAAWWWWW!",
		"HAAAWWW!",
		"Oink!",
		"Squeeeeeeee!",
		"Oink Oink!",
		"Ree!!",
		"Reee!!",
		"REEE!!",
		"REEEEE!!",
	)

/obj/item/book/granter/action/spell/barnyard/recoil(mob/living/user)
	if(ishuman(user))
		to_chat(user, LANG("obj.191feb243430a057", null))
		var/obj/item/clothing/magic_mask = new /obj/item/clothing/mask/animal/horsehead/cursed(user.drop_location())
		var/mob/living/carbon/human/human_user = user
		if(!user.dropItemToGround(human_user.wear_mask))
			qdel(human_user.wear_mask)
		user.equip_to_slot_if_possible(magic_mask, ITEM_SLOT_MASK, TRUE, TRUE)
		qdel(src)
	else
		to_chat(user,span_notice(LANG("obj.f3e612fd8d63164b", null))) //It still lives here
