/obj/item/book/granter/action/spell/charge
	granted_action = /datum/action/cooldown/spell/charge
	action_name = "charge"
	icon_state ="bookcharge"
	desc = "这本书由100%回收巫师制成。"
	remarks = list(
		"I feel ALIVE!",
		"I CAN TASTE THE MANA!",
		"What a RUSH!",
		"I'm FLYING through these pages!",
		"THIS GENIUS IS MAKING IT!",
		"This book is ACTION PAcKED!",
		"HE'S DONE IT",
		"LETS GOOOOOOOOOOOO",
	)

/obj/item/book/granter/action/spell/charge/recoil(mob/living/user)
	. = ..()
	to_chat(user,span_warning("[src]突然变得温暖!"))
	empulse(src, 1, 1, emp_source = src)

