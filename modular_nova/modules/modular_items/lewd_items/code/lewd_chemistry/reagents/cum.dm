/datum/reagent/consumable/femcum
	name = "femcum"
	description = "呃……有人玩得挺开心。"
	taste_description = "astringent and sweetish"
	color = "#ffffffb0"

/datum/glass_style/drinking_glass/femcum
	required_drink_type = /datum/reagent/consumable/femcum
	name = "一杯 girlcum"
	desc = "一种奇怪的白色液体... 呃！"

/datum/glass_style/shot_glass/femcum
	required_drink_type = /datum/reagent/consumable/femcum
	icon_state ="shotglasscream"
	name = "一杯 girlcum"
	desc = "一种奇怪的白色液体... 呃！"

/datum/reagent/consumable/cum
	name = "cum"
	description = "一种由许多物种的性器官分泌的液体。"
	taste_description = "musky and salty"
	color = "#ffffffff"

/datum/glass_style/drinking_glass/cum
	required_drink_type = /datum/reagent/consumable/cum
	name = "一杯 cum"
	desc = "哦-哦，天哪...~"

/datum/glass_style/shot_glass/cum
	required_drink_type = /datum/reagent/consumable/cum
	icon_state ="shotglasscream"
	name = "一杯 cum"
	desc = "哦-哦，天哪...~"

/datum/chemical_reaction/cum
	results = list(/datum/reagent/consumable/cum = 5)
	required_reagents = list(/datum/reagent/blood = 2, /datum/reagent/consumable/milk = 2, /datum/reagent/consumable/salt = 1) // Iiiinteresting...
	mix_message = "The mixture turns into a gooey, musky white liquid..."
	erp_reaction = TRUE
