
/obj/item/book/granter/crafting_recipe/fletching
	name = "《为我削制：现代太空人的箭羽制作》"
	desc = "一本关于制作和维护木弓、为箭矢装羽以及……制作小提琴的指南？"
	crafting_recipe_types = list(
		/datum/crafting_recipe/arrow,
		/datum/crafting_recipe/plastic_arrow,
		/datum/crafting_recipe/shortbow,
		/datum/crafting_recipe/holy_arrow,
		///datum/crafting_recipe/arrow_quiver, // NOVA EDIT REMOVAL: public-knowledge quiver
		/datum/crafting_recipe/violin,
	)
	icon_state = "book4"
	uses = INFINITY
	remarks = list(
		"Okay, so the quality of the wood has some impact.",
		"I feel like the violin chapter is in here as a joke, surely...",
		"The author seems oddly proud about how many years they've been hunting in 'these parts'...",
		"i really wish they'd stop with all the marriage euphemisms...",
		"I need membership? Membership with what?",
		"Okay, I think I get the point already...",
	)
