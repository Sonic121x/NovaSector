/obj/item/clothing/head/costume/kitty
	name = "猫耳"
	desc = "一双猫咪的耳朵。喵！"
	icon_state = "kitty"
	color = "#999999"

	dog_fashion = /datum/dog_fashion/head/kitty

/obj/item/clothing/head/costume/kitty/visual_equipped(mob/living/carbon/human/user, slot)
	if(ishuman(user) && (slot & ITEM_SLOT_HEAD))
		update_icon(ALL, user)
		user.update_worn_head() //Color might have been changed by update_appearance.
	return ..()

/obj/item/clothing/head/costume/kitty/update_icon(updates=ALL, mob/living/carbon/human/user)
	. = ..()
	if(ishuman(user))
		add_atom_colour(user.hair_color, FIXED_COLOUR_PRIORITY)

/obj/item/clothing/head/costume/kitty/genuine
	desc = "一对小猫耳朵。里面的标签上写着\"用真猫手工制作。\""

/obj/item/clothing/head/costume/rabbitears
	name = "兔耳"
	desc = "戴上这些会让你看起来很没用，而且只会增加你的性魅力。"
	icon_state = "bunny"

	dog_fashion = /datum/dog_fashion/head/rabbit
