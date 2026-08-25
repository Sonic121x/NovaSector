// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/book/granter/action/spell/summonitem
	granted_action = /datum/action/cooldown/spell/summonitem
	action_name = "instant summons"
	icon_state ="booksummons"
	desc = "This book is bright and garish, very hard to miss."
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
	to_chat(user,span_warning(LANG("obj.04d9e36cc032366d", list(src))))
	qdel(src)
