/obj/item/book/granter/crafting_recipe/regal_condor
	name = "陨落特工的回忆录"
	desc = "一本破旧的日记。它似乎沾满了唐克口袋饼的碎屑。"
	crafting_recipe_types = list(
		/datum/crafting_recipe/deagle_prime,
		/datum/crafting_recipe/deagle_prime_mag,
	)
	icon_state = "book1"
	remarks = list(
		"It says that she was once an assistant, before she was activated...",
		"I don't think you can make a pistol 'absorb' other pistols, but whatever...",
		"Wait, how much gold do you need to make this?",
		"So the Tiger Co-op can come up with some interesting things every now and again...",
		"Why not just give me an Ansem pistol? I'll just go find a bucket of black paint...",
		"Cleanse, or die trying...",
	)

/obj/item/book/granter/crafting_recipe/regal_condor/recoil(mob/living/user)
	to_chat(user, span_warning("这本书在你手中化为了尘埃。"))
	qdel(src)
