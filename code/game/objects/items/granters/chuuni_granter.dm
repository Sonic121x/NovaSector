/// Turns the user into a chuunibyou.
/obj/item/book/granter/chuunibyou
	starting_title = "I Found a Mysterious Book in the Library That Teaches Me How to Become a Chuunibyou, But It Turns Out It's Actually a Grimoire That Unlocks My Hidden Powers!"
	starting_author = "Anonymous"
	name = "我在图书馆找到了一本神秘的书，它教我如何成为中二病，但结果它其实是一本解锁我隐藏力量的魔法书！"
	desc = "说实话，我宁愿被抓到拿着一把辛迪加左轮手枪。"
	icon_state ="chuuni_manga"
	remarks = list(
		"How can anyone believe this stuff?",
		"...Why am I wasting my time on this?",
		"Coming up with the invocations on demand is actually a skill...",
		"I should get a medical eyepatch to complete the look...",
		"According to this manga, my power goes up by 5000% by using invocations...",
		"Who is this \"dark lord\" fellow? Why does he grant all the powers?",
	)

/obj/item/book/granter/chuunibyou/can_learn(mob/living/user)
	if (!isliving(user))
		return
	if (user.GetComponent(/datum/component/chuunibyou))
		to_chat(user, span_warning("你已经是个中二病了！"))
		return
	return TRUE

/obj/item/book/granter/chuunibyou/recoil(mob/living/user)
	to_chat(user, span_warning("You just can't bring yourself to read it... it's just not worth the cringe..."))

/obj/item/book/granter/chuunibyou/on_reading_finished(mob/living/user)
	..()
	to_chat(user, span_notice("你学会了如何以更中二病的方式施放法术！"))
	user.AddComponent(/datum/component/chuunibyou/no_healing)
