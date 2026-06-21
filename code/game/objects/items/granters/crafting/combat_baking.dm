/obj/item/book/granter/crafting_recipe/combat_baking
	name = "无政府主义者烹饪书"
	desc = "一本广泛非法的食谱书，将教你如何烘焙出致命的羊角面包。"
	crafting_recipe_types = list(
		/datum/crafting_recipe/food/throwing_croissant,
	)
	icon_state = "cooking_learing_illegal"
	remarks = list(
		"\"Austrian? Not French?\"",
		"\"Got to get the butter ratio right...\"",
		"\"This is the greatest thing since sliced bread!\"",
		"\"I'll leave no trace except crumbs!\"",
		"\"Who knew that bread could hurt a man so badly?\"",
	)

/obj/item/book/granter/crafting_recipe/combat_baking/recoil(mob/living/user)
	to_chat(user, span_warning("这本书溶解成了烧焦的面粉！"))
	new /obj/effect/decal/cleanable/ash(get_turf(src))
	qdel(src)
