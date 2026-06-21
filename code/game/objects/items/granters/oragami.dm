/obj/item/book/granter/action/origami
	granted_action = /datum/action/innate/origami
	name = "折纸艺术"
	desc = "一本详尽阐述折纸艺术的手册。"
	icon_state = "origamibook"
	action_name = "origami"
	remarks = list(
		"Dead-stick stability...",
		"Symmetry seems to play a rather large factor...",
		"Accounting for crosswinds... really?",
		"Drag coefficients of various paper types...",
		"Thrust to weight ratios?",
		"Positive dihedral angle?",
		"Center of gravity forward of the center of lift...",
	)

/datum/action/innate/origami
	name = "折纸折叠"
	desc = "切换你折叠和接住强力纸飞机的能力。"
	button_icon_state = "origami_off"
	check_flags = NONE

/datum/action/innate/origami/Activate()
	ADD_TRAIT(owner, TRAIT_PAPER_MASTER, ACTION_TRAIT)
	to_chat(owner, span_notice("你现在会折纸飞机了。"))
	active = TRUE
	build_all_button_icons(UPDATE_BUTTON_ICON)

/datum/action/innate/origami/Deactivate()
	REMOVE_TRAIT(owner, TRAIT_PAPER_MASTER, ACTION_TRAIT)
	to_chat(owner, span_notice("你不再会折纸飞机了。"))
	active = FALSE
	build_all_button_icons(UPDATE_BUTTON_ICON)

/datum/action/innate/origami/apply_button_icon(atom/movable/screen/movable/action_button/current_button, force)
	button_icon_state = "origami_[active ? "on":"off"]"
	return ..()
