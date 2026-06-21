/obj/item/book/granter/martial/cqc
	martial = /datum/martial_art/cqc
	name = "旧手册"
	martial_name = "close quarters combat"
	desc = "一本小小的黑色手册。上面画着战术徒手格斗的示意图。"
	greet = span_bolddanger("你已掌握了CQC的基础。")
	icon_state = "cqcmanual"
	remarks = list(
		"Kick... Slam...",
		"Lock... Kick...",
		"Strike their abdomen, neck and back for critical damage...",
		"Slam... Lock...",
		"I could probably combine this with some other martial arts! ...Wait, that's illegal.",
		"Words that kill...",
		"The last and final moment is yours...",
	)

/obj/item/book/granter/martial/cqc/on_reading_finished(mob/living/carbon/user)
	. = ..()
	if(uses <= 0)
		to_chat(user, span_warning("[src]发出不祥的哔哔声..."))

/obj/item/book/granter/martial/cqc/recoil(mob/living/user)
	to_chat(user, span_warning("[src] 爆炸了！"))
	playsound(src,'sound/effects/explosion/explosion1.ogg',40,TRUE)
	user.flash_act(1, 1)
	user.adjust_brute_loss(6)
	user.adjust_fire_loss(6)
	qdel(src)
