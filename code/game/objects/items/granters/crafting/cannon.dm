/obj/item/book/granter/crafting_recipe/trash_cannon
	name = "被降职工程师的日记"
	desc = "一本遗失的日志。这位工程师似乎对自己的降职感到非常狂乱。"
	crafting_recipe_types = list(
		/datum/crafting_recipe/trash_cannon,
		/datum/crafting_recipe/trashball,
	)
	icon_state = "book1"
	remarks = list(
		"\"I'll show them! I'll build a CANNON!\"",
		"\"Gunpowder is ideal, but i'll have to improvise...\"",
		"\"I savor the look on the CE's face when I BLOW down the walls to engineering!\"",
		"\"If the supermatter gets loose from my rampage, so be it!\"",
		"\"I'VE GONE COMPLETELY MENTAL!\"",
	)

/obj/item/book/granter/crafting_recipe/trash_cannon/recoil(mob/living/user)
	to_chat(user, span_warning("这本书在你手中化为尘埃。"))
	qdel(src)
