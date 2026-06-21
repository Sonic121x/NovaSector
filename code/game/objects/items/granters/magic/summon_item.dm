/obj/item/book/granter/action/spell/summonitem
	granted_action = /datum/action/cooldown/spell/summonitem
	action_name = "instant summons"
	icon_state ="booksummons"
	desc = "这本书色彩鲜艳花哨，非常显眼。"
	remarks = list(
		"I can't look away from the book!",
		"The words seem to pop around the page...",
		"I just need to focus on one item...",
		"Make sure to have a good grip on it when casting...",
		"Slow down, book. I still haven't finished this page...",
		"Sounds pretty great with some other magical artifacts...",
		"Magicians must love this one.",
	)

/obj/item/book/granter/action/spell/summonitem/recoil(mob/living/user)
	. = ..()
	to_chat(user,span_warning("[src]突然消失了！"))
	qdel(src)
