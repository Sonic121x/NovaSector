/// Sign language book adds the sign language component to the reading Human.
/// Grants reader the ability to toggle sign language using a HUD button.
/obj/item/book/granter/sign_language
	name = "银河标准手语"
	desc = "一本学习手语和指语拼写的综合指南。"
	remarks = list(
		"Signing comprises a range of techniques...",
		"Words can be spelled out through sequences of signs...",
		"The way your palm faces?",
		"With questions, the eyebrows are lowered...",
		"Cool! Extensive coverage of common phrases!",
		"Communicate just about anything through signing...",
	)

/obj/item/book/granter/sign_language/can_learn(mob/living/user)
	if (!iscarbon(user))
		return
	if (user.GetComponent(/datum/component/sign_language))
		to_chat(user, span_warning("你已经完全掌握手语了！"))
		return
	return TRUE

/obj/item/book/granter/sign_language/recoil(mob/living/user)
	to_chat(user, span_warning("你读不了，书页太模糊了！"))

/// Called when the reading is completely finished. This is where the actual granting should happen.
/obj/item/book/granter/sign_language/on_reading_finished(mob/living/user)
	..()
	user.AddComponent(/datum/component/sign_language)
