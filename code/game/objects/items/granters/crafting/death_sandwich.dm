/obj/item/book/granter/crafting_recipe/death_sandwich
	name = "\improper 死亡三明治秘制配方"
	desc = "一本古老的活页笔记本，其散页上潦草地写着一个古老且终极三明治的制作说明。标题是用永久性记号笔涂写上去的。"
	crafting_recipe_types = list(
		/datum/crafting_recipe/food/death_sandwich
	)
	icon_state = "cooking_learning_sandwich"
	remarks = list(
		"A meatball sub, but what makes it so special?",
		"I just need to grease back my hair...?",
		"What kind of ancient civilization wore jorts?",
		"So it DOES matter what angle you fold the salami in...",
	)

/obj/item/book/granter/crafting_recipe/death_sandwich/recoil(mob/living/user)
	to_chat(user, span_warning("这本书在你手中滑稽地爆炸了，没留下任何痕迹。"))
	qdel(src)
