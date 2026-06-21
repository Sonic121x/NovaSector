/datum/skill/language
	name = "语言"
	title = "Linguist"
	desc = "不要将自己局限于一种语言。语言是通往不同文化的大门。"
	modifiers = list(SKILL_SPEED_MODIFIER = list(1, 0.95, 0.9, 0.85, 0.75, 0.6, 0.5))
	skill_item_path = /obj/item/clothing/accessory/language

/datum/skill/language/level_gained(datum/mind/mind, new_level, old_level, silent)
	. = ..()
	if(new_level >= SKILL_LEVEL_APPRENTICE && old_level < SKILL_LEVEL_APPRENTICE)
		ADD_TRAIT(mind.current, TRAIT_LITERATE, SKILL_TRAIT)

	var/datum/language_holder/language_holder = mind.current.get_language_holder()
	var/list/learnable_languages = GLOB.all_languages.Copy() - language_holder.understood_languages
	if(!length(learnable_languages)) // Once there are no more languages to learn, we make sure we stop running
		return

	var/language_amount = (new_level > SKILL_LEVEL_MASTER ? length(learnable_languages) : min(length(learnable_languages), new_level)) // If we're legendary, learn em all
	var/learned_string = ""
	for(var/index in 1 to language_amount)
		var/datum/language/language = pick_n_take(learnable_languages)
		mind.current.grant_language(language, source = LANGUAGE_MIND)
		var/separator = ""
		if(index > 1)
			separator = (index == language_amount) ? " and" : ","

		learned_string = "[learned_string][separator][index > 1 ? " " : ""][initial(language.name)]"

	to_chat(mind.current, span_nicegreen("我感觉我对[learned_string]的理解变得更好了！"))

/obj/item/clothing/accessory/language
	name = "语言大师徽章"
	desc = "一枚小小的奖章，彰显了你学习银河系所有语言的奉献精神"
	icon_state = "bronze"

/obj/item/clothing/accessory/language/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/skill_reward, /datum/skill/language)

/datum/job/curator/after_spawn(mob/living/spawned, client/player_client)
	. = ..()
	spawned.mind?.set_level(/datum/skill/language, SKILL_LEVEL_LEGENDARY, silent = TRUE)
