/obj/item/book/granter/action/spell/mindswap
	granted_action = /datum/action/cooldown/spell/pointed/mind_transfer
	action_name = "mindswap"
	icon_state ="bookmindswap"
	desc = "这本书的封面崭新，但书页看起来破旧不堪。"
	remarks = list(
		"If you mindswap from a mouse, they will be helpless when you recover...",
		"Wait, where am I...?",
		"This book is giving me a horrible headache...",
		"This page is blank, but I feel words popping into my head...",
		"GYNU... GYRO... Ugh...",
		"The voices in my head need to stop, I'm trying to read here...",
		"I don't think anyone will be happy when I cast this spell...",
	)
	/// Mob used in book recoils to store an identity for mindswaps
	var/datum/weakref/stored_swap_ref

/obj/item/book/granter/action/spell/mindswap/on_reading_finished()
	. = ..()
	visible_message(span_notice("[src] 开始震动并变形。"))
	action_name = pick(
		"fireball",
		"smoke",
		"blind",
		"forcewall",
		"knock",
		"barnyard",
		"charge",
	)
	icon_state = "book[action_name]"
	name = "[action_name]的法术书"

/obj/item/book/granter/action/spell/mindswap/recoil(mob/living/user)
	. = ..()
	var/mob/living/real_stored_swap = stored_swap_ref?.resolve()
	if(QDELETED(real_stored_swap))
		stored_swap_ref = WEAKREF(user)
		to_chat(user, span_warning("有那么一瞬间，你感觉自己甚至不知道自己是谁了。"))
		return
	if(real_stored_swap.stat == DEAD)
		stored_swap_ref = null
		return
	if(real_stored_swap == user)
		to_chat(user, span_notice("你又盯着书看了一会儿，但似乎没什么可学的了..."))
		return

	var/datum/action/cooldown/spell/pointed/mind_transfer/swapper = new(src)

	if(swapper.swap_minds(user, real_stored_swap))
		to_chat(user, span_warning("你突然到了别处...还变成了别人？！"))
		to_chat(real_stored_swap, span_warning("突然你又盯着[src]了...你在哪，你是谁？！"))

	else
		// if the mind_transfer failed to transfer mobs (likely due to the target being catatonic).
		user.visible_message(span_warning("[src]微微嘶嘶作响，光芒随之熄灭！"))

	stored_swap_ref = null
