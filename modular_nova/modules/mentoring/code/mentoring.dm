#define AUTHOR_LEVEL_NOVICE 2
#define AUTHOR_LEVEL_APPRENTICE 3
#define AUTHOR_LEVEL_JOURNEYMAN 4
#define AUTHOR_LEVEL_EXPERT 5
#define AUTHOR_LEVEL_MASTER 6

/datum/crafting_recipe/mentoring_book
	name = "导师之书"
	result = /obj/item/mentoring_book
	time = 5 SECONDS
	reqs = list(
		/obj/item/stack/sheet/leather = 1,
		/obj/item/paper = 5,
	)
	category = CAT_ENTERTAINMENT

/obj/item/mentoring_book
	name = "导师之书"
	desc = "书页上写满了作者在特定技能方面的无数经历。或许阅读会对你有所帮助。"
	icon = 'modular_nova/modules/mentoring/icons/mentoring.dmi'
	icon_state = "book"
	custom_materials = list(/datum/material/paper = SHEET_MATERIAL_AMOUNT * 1.25)

	///the skill that is written within the book that will be taught
	var/datum/skill/taught_skill

	///the skill level of the author minus one; people will be one level below the author
	var/author_level

	///if selected, this is the language that will be taught to the reader
	var/datum/language/taught_language

	///if selected, will teach sign-language-- because it isn't a language...?
	var/teach_sign = FALSE

	/// whether the book should have a limited amount of uses
	var/limit_uses = FALSE

	/// if limit_use is true, how many times should we be able to be used before disappearing
	var/allowed_uses = 1

	///the list of sentences sent to the author as they write the book
	var/static/list/writing_sentences = list(
		"You philosophize the pedagogical approach for this term...",
		"You wonder if this concept is important for learning...",
		"You have a grand epiphany regarding the societal connections of the skill...",
		"You give pause for marvels of the geniuses that came before...",
		"You write down the creator and father of the skill...",
		"You tap your pen softly against the book, then resume writing...",
	)

	/// Tracks reading progress per user (by ckey) so they can resume if interrupted
	var/list/reading_progress

	/// Tracks writing progress per user (by ckey) so they can resume if interrupted
	var/list/writing_progress

	var/static/list/learning_sentences = list(
		"You look at the new word and try to gain context...",
		"You gaze down at the sentence, and wonder how the author arrived at this conclusion...",
		"You ponder the connections between the last word, this word, and the next word...",
		"You realize a commonality between the geniuses written down...",
		"You touch the spine of the book, and then resume reading...",
		"You jot down some notes in the book, then scribble it out...",
	)

/obj/item/mentoring_book/limited
	limit_uses = TRUE

/// A mentoring book that comes pre-written with a specific language
/obj/item/mentoring_book/limited/preset_language
	/// The language type to pre-load into the book
	var/preset_language_type = /datum/language/common

/obj/item/mentoring_book/limited/preset_language/Initialize(mapload)
	. = ..()
	if(preset_language_type)
		taught_language = preset_language_type
		name = "导师之书 - [initial(taught_language.name)]"

/obj/item/mentoring_book/examine(mob/user)
	. = ..()
	var/level_name
	if(author_level)
		switch(author_level)
			if(AUTHOR_LEVEL_NOVICE)
				level_name = "novice"

			if(AUTHOR_LEVEL_APPRENTICE)
				level_name = "apprentice"

			if(AUTHOR_LEVEL_JOURNEYMAN)
				level_name = "journeyman"

			if(AUTHOR_LEVEL_EXPERT)
				level_name = "expert"

			if(AUTHOR_LEVEL_MASTER)
				level_name = "master"

	if(taught_skill)
		. += span_notice("这本书可以教你成为一名\a [level_name] [initial(taught_skill.title)]。")

	if(taught_language)
		. += span_notice("这本书可以教你流利掌握[initial(taught_language.name)]。")

	if(teach_sign)
		. += span_notice("这本书可以教你手语。")

	if(!(taught_skill || taught_language || teach_sign))
		. += span_notice("书页是空白的。")

	. += span_notice("使用笔可以将你关于语言或技能的知识注入书中！")

	if(limit_uses)
		. += span_warning("This book can only be used [allowed_uses] more time\s!")

/// will lower the use by one (if allowed) and check if it should be destroyed
/obj/item/mentoring_book/proc/check_limit(mob/user)
	if(!limit_uses)
		return

	allowed_uses -= 1
	if(allowed_uses > 0)
		to_chat(user, span_notice("[src]看起来又破损了一些..."))
		return

	to_chat(user, span_warning("[src]撕裂并破碎了！"))
	qdel(src)

/// when given a message and an amount of time, requires the user to stand still while receiving the message
/obj/item/mentoring_book/proc/timed_sentence(user, sent_message, time_amount)
	to_chat(user, span_notice(sent_message))
	playsound(src, SFX_PAGE_TURN, 30, TRUE)
	if(!do_after(user, time_amount, target = src))
		to_chat(user, span_notice("你放下了书..."))
		return FALSE

	return TRUE

/**
 * Performs a progress-tracked loop of timed sentences, saving progress if interrupted.
 *
 * Arguments:
 * * user - The mob performing the action
 * * progress_list - The list to track progress in (reading_progress or writing_progress)
 * * sentence_list - The list of sentences to randomly pick from
 * * iterations - How many successful iterations are needed (default 5)
 * * time_per_iteration - How long each iteration takes (default 60 SECONDS)
 * * resume_message - Optional message shown when resuming from saved progress
 *
 * Returns TRUE if all iterations completed, FALSE if interrupted
 */
/obj/item/mentoring_book/proc/do_progress_loop(mob/user, list/progress_list, list/sentence_list, iterations = 5, time_per_iteration = 60 SECONDS, resume_message = "You resume from where you left off...")
	var/user_key = user.ckey || REF(user)
	var/starting_iteration = LAZYACCESS(progress_list, user_key) || 1

	if(starting_iteration > 1)
		to_chat(user, span_notice(resume_message))

	for(var/current_iteration in starting_iteration to iterations)
		if(!timed_sentence(user, pick(sentence_list), time_per_iteration))
			LAZYSET(progress_list, user_key, current_iteration)
			return FALSE

	LAZYREMOVE(progress_list, user_key) // Clear progress on completion
	return TRUE

/obj/item/mentoring_book/attack_self(mob/user, modifiers)
	if(isnull(taught_skill) && isnull(taught_language) && !teach_sign)
		to_chat(user, span_notice("书页是空白的。先用笔把知识写进书里。"))
		return

	if(taught_skill)
		var/user_level = user.mind?.get_skill_level(taught_skill)
		if(user_level >= author_level)
			to_chat(user, span_notice("你已经掌握了这本书里的所有内容。"))
			return

		var/user_key = user.ckey || REF(user)
		var/starting_iteration = LAZYACCESS(reading_progress, user_key) || 0
		var/learning_exp = 10 + (starting_iteration * 5) // Resume exp calculation from saved progress
		var/current_iteration = starting_iteration

		if(starting_iteration > 0)
			to_chat(user, span_notice("你从上次中断的地方继续阅读……"))

		while(user_level < author_level)
			if(!timed_sentence(user, pick(learning_sentences), 60 SECONDS))
				LAZYSET(reading_progress, user_key, current_iteration)
				if(current_iteration > 0) // don't consume any charges if we have not gained any xp yet.
					check_limit(user)
				return
			user.mind?.adjust_experience(taught_skill, learning_exp)
			user_level = user.mind?.get_skill_level(taught_skill)
			learning_exp += 5 //this means that it won't take 40 minutes to get from beginner to master... I definitely wouldn't know ;-;
			current_iteration++

		LAZYREMOVE(reading_progress, user_key) // Clear progress on completion
		to_chat(user, span_notice("你已经从[src]中学到了所有能学的东西。"))
		check_limit(user)
		return

	if(taught_language)
		if(user.has_language(taught_language))
			to_chat(user, span_notice("你已经懂得[initial(taught_language.name)]了。"))
			return

		if(!do_progress_loop(user, reading_progress, learning_sentences, 5, 60 SECONDS, "You resume reading from where you left off..."))
			return

		user.remove_blocked_language(taught_language, source = LANGUAGE_BABEL)
		user.grant_language(taught_language, source = LANGUAGE_BABEL)
		to_chat(user, span_notice("你已经完全学会了[initial(taught_language.name)]"))
		check_limit(user)
		return

	if(teach_sign)
		if(isliving(user))
			var/mob/living/living_user = user
			if(living_user.has_quirk(/datum/quirk/item_quirk/signer))
				to_chat(living_user, span_warning("你已经完全懂得手语了！"))
				return

			if(!do_progress_loop(living_user, reading_progress, learning_sentences, 5, 60 SECONDS, "You resume reading from where you left off..."))
				return

			living_user.add_quirk(/datum/quirk/item_quirk/signer)
			to_chat(living_user, span_notice("你已经完全学会了手语！"))
			check_limit(user)
			return

		else
			if(user.GetComponent(/datum/component/sign_language))
				to_chat(user, span_warning("你已经完全懂得手语了！"))
				return

			if(!do_progress_loop(user, reading_progress, learning_sentences, 5, 60 SECONDS, "You resume reading from where you left off..."))
				return

			user.AddComponent(/datum/component/sign_language)
			to_chat(user, span_notice("你已经完全学会了手语！"))
			check_limit(user)
			return

	return ..()

/obj/item/mentoring_book/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/pen))
		if(taught_skill || taught_language)
			to_chat(user, span_warning("这本书里已经储存了一些知识——你想要擦除它吗？"))
			var/erase_choice = tgui_input_list(user, "Erase Knowledge?", "Book Choice", list("Yes", "No"))
			if(isnull(erase_choice))
				return ITEM_INTERACT_BLOCKING

			if(erase_choice != "Yes")
				return ITEM_INTERACT_BLOCKING

			to_chat(user, span_warning("你开始从[src]中擦除知识！"))
			if(!do_after(user, 10 SECONDS, target = src))
				to_chat(user, span_notice("你决定不擦除这些知识……"))
				return ITEM_INTERACT_BLOCKING

			to_chat(user, span_warning("你擦除了知识！"))
			playsound(src, SFX_WRITING_PEN, 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE, SOUND_FALLOFF_EXPONENT + 3, ignore_walls = FALSE)
			taught_skill = null
			author_level = null
			taught_language = null
			teach_sign = FALSE
			return ITEM_INTERACT_SUCCESS

		var/writing_choice = tgui_input_list(user, "What would you like to write in the book?", "Book Choice", list("Languages", "Skills"))
		if(isnull(writing_choice))
			return ITEM_INTERACT_BLOCKING

		switch(writing_choice)
			if("Languages")
				var/current_lang = user.mind?.get_skill_level(/datum/skill/language)
				var/datum/language_holder/lang_holder = user.get_language_holder()
				var/list/language_list = list()
				for(var/datum/language/language as anything in lang_holder.understood_languages)
					language_list += initial(language.name)

				if(user.GetComponent(/datum/component/sign_language))
					language_list += list("Galactic Standard Sign Language")

				if(length(language_list) < 1 || current_lang < SKILL_LEVEL_MASTER)
					to_chat(user, span_warning("你不是语言大师，因此无法撰写教授语言的书籍。"))
					return ITEM_INTERACT_BLOCKING

				var/language_choice = tgui_input_list(user, "Which language would you like to write about?", "Language Selection", language_list)
				if(isnull(language_choice))
					to_chat(user, span_notice("你决定不写了。"))
					return ITEM_INTERACT_BLOCKING

				if(!do_progress_loop(user, writing_progress, writing_sentences, 5, 60 SECONDS, "You resume writing from where you left off..."))
					return ITEM_INTERACT_BLOCKING

				to_chat(user, span_notice("你完成了关于你语言的书籍撰写。"))
				playsound(src, SFX_WRITING_PEN, 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE, SOUND_FALLOFF_EXPONENT + 3, ignore_walls = FALSE)
				if(language_choice == "Galactic Standard Sign Language")
					teach_sign = TRUE

				else
					taught_language = GLOB.language_types_by_name[language_choice]
					author_level = current_lang - 1

				return ITEM_INTERACT_SUCCESS

			if("Skills")
				var/list/our_skills = list()
				for(var/datum/skill/skill as anything in user.mind?.known_skills)
					var/level = user.mind?.get_skill_level(skill)
					if(level < SKILL_LEVEL_APPRENTICE)
						continue
					our_skills[initial(skill.name)] = skill

				if(!length(our_skills))
					to_chat(user, span_warning("你没有任何技能可以撰写！"))
					return ITEM_INTERACT_BLOCKING

				var/skill_choice = tgui_input_list(user, "Which skill would you like to write about?", "Skill Selection", our_skills)
				if(isnull(skill_choice))
					to_chat(user, span_notice("你决定不写了。"))
					return ITEM_INTERACT_BLOCKING

				var/skill_level = user.mind?.get_skill_level(our_skills[skill_choice])
				if(skill_level < SKILL_LEVEL_APPRENTICE)
					to_chat(user, span_warning("你的技能水平不足以撰写这项技能！"))
					return ITEM_INTERACT_BLOCKING

				if(!do_progress_loop(user, writing_progress, writing_sentences, 5, 60 SECONDS, "You resume writing from where you left off..."))
					return ITEM_INTERACT_BLOCKING

				to_chat(user, span_notice("你完成了在书中关于你技能的书写。"))
				playsound(src, SFX_WRITING_PEN, 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE, SOUND_FALLOFF_EXPONENT + 3, ignore_walls = FALSE)
				taught_skill = our_skills[skill_choice]
				author_level = skill_level - 1
				return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/stack/ore/bluespace_crystal))
		if(user.mind.get_skill_level(/datum/skill/language) < SKILL_LEVEL_JOURNEYMAN)
			to_chat(user, span_warning("你觉得你还没准备好用[tool]来操作[src]……或许需要再多学习一下！"))
			return ITEM_INTERACT_BLOCKING

		var/skill_modifier = user.mind.get_skill_modifier(/datum/skill/language, SKILL_SPEED_MODIFIER)
		to_chat(user, span_warning("你开始用[tool]操作[src]！"))
		if(!do_after(user, 5 SECONDS * skill_modifier, target = src))
			to_chat(user, span_notice("你放下了[src]。"))
			return ITEM_INTERACT_BLOCKING

		new /obj/item/book/random(get_turf(user))
		give_experience(user)
		playsound(src, SFX_WRITING_PEN, 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE, SOUND_FALLOFF_EXPONENT + 3, ignore_walls = FALSE)
		to_chat(user, span_notice("一道迅捷的蓝色闪电从[tool]中逸出，缠绕住[src]，使其闪烁消失……另一本书取代了它！"))
		qdel(src)
		return ITEM_INTERACT_SUCCESS

	return ..()

/// Gives experience to the person reading the book
/obj/item/mentoring_book/proc/give_experience(mob/living/user)
	var/gained_experience = 5
	if(locate(/obj/structure/bookcase) in range(2, user))
		gained_experience += 5

	if(user.mob_mood.mood_level > MOOD_LEVEL_HAPPY1)
		gained_experience += 5

	user.mind.adjust_experience(/datum/skill/language, gained_experience)

#undef AUTHOR_LEVEL_NOVICE
#undef AUTHOR_LEVEL_APPRENTICE
#undef AUTHOR_LEVEL_JOURNEYMAN
#undef AUTHOR_LEVEL_EXPERT
#undef AUTHOR_LEVEL_MASTER
