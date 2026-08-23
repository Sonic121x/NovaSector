/mob/living/simple_animal/examine(mob/user)
	. = ..()
	//Temporary flavor text addition:
	if(temporary_flavor_text)
		if(length_char(temporary_flavor_text) <= 40)
			. += span_notice("[temporary_flavor_text]")
		else
			. += span_notice(LANG("mob.425018369937f479", list(copytext_char(temporary_flavor_text, 1, 37), REF(src))))
