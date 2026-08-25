// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/skillchip/musical
	name = "\improper Old Copy of \"Space Station 13: The Musical\""
	desc = "An old copy of \"Space Station 13: The Musical\", \
		ran on the station's 100th anniversary...Or maybe it was the 200th?"
	skill_name = "Memory of a Musical"
	skill_description = "Allows you to hit that high note, like those that came a century before us."
	skill_icon = FA_ICON_MUSIC
	activate_message = span_notice("You feel like you could \u2669 sing a soooong! \u266B")
	deactivate_message = span_notice("The musical fades from your mind, leaving you with a sense of nostalgia.")
	custom_premium_price = PAYCHECK_CREW * 4

/obj/item/skillchip/musical/Initialize(mapload, is_removable)
	. = ..()
	name = replacetext(name, "Old", round(CURRENT_STATION_YEAR - pick(50, 100, 150, 200, 250), 5))

/obj/item/skillchip/musical/on_activate(mob/living/carbon/user, silent = FALSE)
	. = ..()
	RegisterSignal(user, COMSIG_MOB_SAY, PROC_REF(make_music))

/obj/item/skillchip/musical/on_deactivate(mob/living/carbon/user, silent)
	. = ..()
	UnregisterSignal(user, COMSIG_MOB_SAY)

/obj/item/skillchip/musical/proc/make_music(mob/living/carbon/source, list/say_args)
	SIGNAL_HANDLER

	var/raw_message = say_args[SPEECH_MESSAGE]
	var/list/words = splittext(raw_message, " ")
	if(length(words) <= 1)
		say_args[SPEECH_MODS][MODE_SING] = TRUE
		return
	var/last_word = words[length(words)]
	var/num_chars = length_char(last_word)
	var/last_vowel = ""
	// find the last vowel present in the word
	for(var/i in 1 to num_chars)
		var/char = copytext_char(last_word, i, i + 1)
		if(char in VOWELS)
			last_vowel = char

	// now we'll reshape the final word to make it sound like they're singing it
	var/final_word = ""
	var/has_ellipsis = copytext(last_word, -3) == "..."
	for(var/i in 1 to num_chars)
		var/char = copytext_char(last_word, i, i + 1)
		// replacing any final periods with exclamation marks (so long as it's not an ellipsis)
		if(char == "." && i == num_chars && !has_ellipsis)
			final_word += "!"
		// or if it's the vowel we found, we're gonna repeat it a few times (holding the note)
		else if(char == last_vowel)
			for(var/j in 1 to 4)
				final_word += char
			// if we dragged out the last character of the word, just period it
			if(i == num_chars)
				final_word += "."
		// no special handing otherwise
		else
			final_word += char

	if(!has_ellipsis)
		// adding an extra exclamation mark at the end if there's no period
		var/last_char = copytext_char(final_word, -1)
		if(last_char != ".")
			final_word += "!"

	words[length(words)] = final_word
	// now we siiiiiiing
	say_args[SPEECH_MESSAGE] = jointext(words, " ")
	say_args[SPEECH_MODS][MODE_SING] = TRUE

/obj/item/skillchip/musical/examine(mob/user)
	. = ..()
	. += span_tinynoticeital(LANG("obj.bc1546fbf814e47e", null))

/obj/item/skillchip/musical/examine_more(mob/user)
	. = ..()
	var/list/songs = list()
	songs += LANG("obj.c68db4682f47bc70", null)
	songs += LANG("obj.6bb3af7d1e431925", null)
	songs += LANG("obj.b3e7bf32d51c6d0e", null)
	songs += LANG("obj.a55638f18c7377b9", null)
	songs += LANG("obj.4f816f3bac96aaa6", null)
	songs += LANG("obj.dd0d5c6ce9ee3551", null)
	songs += LANG("obj.410d13b21669cbf8", null)
	songs += LANG("obj.bce9bd0cad5d5b09", null)
	songs += LANG("obj.6f8d86915c4a2309", null)
	songs += LANG("obj.e73474cbd879a774", null)
	songs += LANG("obj.4d4da9166cb611e9", null)

	. += span_notice(LANG("obj.dd15f82532c11408", null))
	. += span_smallnotice("<i>[jointext(songs, "<br>")]</i>")
