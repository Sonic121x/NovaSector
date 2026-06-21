/// Turns the user into a sliding puzzle
/datum/smite/puzzle
	name = "Puzzle-智力游戏"

/datum/smite/puzzle/effect(client/user, mob/living/target)
	. = ..()
	if(!puzzle_imprison(target))
		to_chat(user, span_warning("囚禁失败！"), confidential = TRUE)
