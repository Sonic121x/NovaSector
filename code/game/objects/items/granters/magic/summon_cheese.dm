/obj/item/book/granter/action/spell/summon_cheese
	name = "《欲望异形女仆 卷三 - 奶酪烘焙坊》"
	desc = "太棒了！是时候庆祝一下了...人人都有奶酪！"
	icon_state = "bookcheese"
	action_name = "summon cheese"
	granted_action = /datum/action/cooldown/spell/conjure/cheese
	remarks = list(
		"Always forward, never back...",
		"Are these pages... cheese slices?..",
		"Healthy snacks for unsuspecting victims...",
		"I never knew so many types of cheese existed...",
		"Madness reeks of goat cheese...",
		"Madness tastes of gouda...",
		"Madness tastes of parmesan...",
		"Time is an artificial construct...",
		"Was it order or biscuits?..",
		"What's this about sacrificing cheese?!..",
		"Who wouldn't like that?..",
		"Why cheese, of all things?..",
		"Why do I need a reason for everything?..",
	)

/obj/item/book/granter/action/spell/summon_cheese/recoil(mob/living/user)
	to_chat(user, span_warning("\The [src]变成了一块楔形奶酪！"))
	var/obj/item/food/cheese/wedge/book_cheese = new
	user.temporarilyRemoveItemFromInventory(src, force = TRUE)
	user.put_in_hands(book_cheese)
	qdel(src)
