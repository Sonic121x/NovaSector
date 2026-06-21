/obj/item/book/granter/action/spell/blind
	granted_action = /datum/action/cooldown/spell/pointed/blind
	action_name = "blind"
	icon_state = "bookblind"
	desc = "这本书看起来总是模糊不清，无论你怎么看。"
	remarks = list(
		"Well I can't learn anything if I can't read the damn thing!",
		"Why would you use a dark font on a dark background...",
		"Ah, I can't see an Oh, I'm fine...",
		"I can't see my hand...!",
		"I'm manually blinking, damn you book...",
		"I can't read this page, but somehow I feel like I learned something from it...",
		"Hey, who turned off the lights?",
	)

/obj/item/book/granter/action/spell/blind/recoil(mob/living/user)
	. = ..()
	to_chat(user, span_warning("你失明了!"))
	user.adjust_temp_blindness(20 SECONDS)

/obj/item/book/granter/action/spell/blind/wgw
	name = "伍迪有木头"
	pages_to_mastery = 69 // Andy's favorite number
	uses = 0 // it's spent
	desc = "这本书看起来很危险。只有苦难等待着阅读它的人。"
	remarks = list( // Death awaits
		"T-T-This is bad...",
		"This is REALLY bad...",
		"I think my eyes are starting to bleed...",
		"Please, make it stop...",
		"HELP ME SOMEONE, WHY AM I READING THIS...",
	)
