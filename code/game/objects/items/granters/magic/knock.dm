// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/book/granter/action/spell/knock
	granted_action = /datum/action/cooldown/spell/aoe/knock
	action_name = "knock"
	icon_state ="bookknock"
	desc = "This book is hard to hold closed properly."
	remarks = list(
		"Open Sesame!",
		"So THAT'S the magic password!",
		"Slow down, book. I still haven't finished this page...",
		"The book won't stop moving!",
		"I think this is hurting the spine of the book...",
		"I can't get to the next page, it's stuck t- I'm good, it just turned to the next page on its own.",
		"Yeah, staff of doors does the same thing. Go figure...",
	)

/obj/item/book/granter/action/spell/knock/recoil(mob/living/user)
	. = ..()
	to_chat(user, span_warning(LANG("obj.dc89d29ffc123821", null)))
	user.Paralyze(4 SECONDS)
