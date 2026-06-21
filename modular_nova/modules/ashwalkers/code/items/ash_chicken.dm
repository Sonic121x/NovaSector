/datum/language_holder/ashmob
	understood_languages = list(
		/datum/language/common = list(LANGUAGE_ATOM),
		/datum/language/ashtongue = list(LANGUAGE_ATOM),
	)
	spoken_languages = list(
		/datum/language/common = list(LANGUAGE_ATOM),
		/datum/language/ashtongue = list(LANGUAGE_ATOM),
	)
	selected_language = /datum/language/ashtongue

/mob/living/basic/chicken/gunther
	name = "\improper 冈瑟"
	desc = "一只长相奇特的肠宴兽，这只似乎有羽毛还会下蛋，不过你对此应该没什么好抱怨的。"
	unsuitable_atmos_damage = 0
	initial_language_holder = /datum/language_holder/ashmob

/mob/living/basic/chicken/gunther/jr
	name = "\improper 小冈瑟"
	fertile = FALSE

/mob/living/basic/chicken/gunther/egg_laid(obj/item/egg)
	if(GLOB.chicken_count <= MAX_CHICKENS && fertile && prob(10))
		egg.AddComponent(\
			/datum/component/fertile_egg,\
			embryo_type = /mob/living/basic/chick/gunther,\
			minimum_growth_rate = 1,\
			maximum_growth_rate = 2,\
			total_growth_required = 200,\
			current_growth = 0,\
			location_allowlist = typecacheof(list(/turf)),\
			spoilable = TRUE,\
		)

/mob/living/basic/chick/gunther
	name = "\improper 冈瑟小鸡"
	desc = "一只长相奇特的肠宴兽幼崽，这只似乎有羽毛还会下蛋，不过你对此应该没什么好抱怨的。"
	unsuitable_atmos_damage = 0
	grow_as = /mob/living/basic/chicken/gunther/jr
	initial_language_holder = /datum/language_holder/ashmob
