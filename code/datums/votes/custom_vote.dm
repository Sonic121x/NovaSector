// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/// The max amount of options someone can have in a custom vote.
#define MAX_CUSTOM_VOTE_OPTIONS 10

/datum/vote/custom_vote
	name = "Custom"
	default_message = "Click here to start a custom vote."

// Custom votes ares always accessible.
/datum/vote/custom_vote/is_accessible_vote()
	return TRUE

/datum/vote/custom_vote/reset()
	default_choices = null
	override_question = null
	count_method = VOTE_COUNT_METHOD_SINGLE
	return ..()

/datum/vote/custom_vote/can_be_initiated(forced)
	. = ..()
	if(. != VOTE_AVAILABLE)
		return .
	if(forced)
		return .

	// Custom votes can only be created if they're forced to be made.
	// (Either an admin makes it, or otherwise.)
	return "Only admins can create custom votes."

/datum/vote/custom_vote/create_vote(mob/vote_creator)
	var/custom_count_method = tgui_input_list(
		user = vote_creator,
		message = LANG("datum.bbe82c356b82235c", null),
		title = LANG("datum.84e9a377ea157578", null),
		items = list("Single", "Multiple"),
		default = "Single",
	)
	switch(custom_count_method)
		if("Single")
			count_method = VOTE_COUNT_METHOD_SINGLE
		if("Multiple")
			count_method = VOTE_COUNT_METHOD_MULTI
		if(null)
			return FALSE
		else
			stack_trace("Got '[custom_count_method]' in create_vote() for custom voting.")
			to_chat(vote_creator, span_boldwarning(LANG("datum.af39741091b78e82", null)))
			return FALSE

	var/custom_win_method = tgui_input_list(
		user = vote_creator,
		message = LANG("datum.607a30ba21af44a8", null),
		title = LANG("datum.5553562d2fd6336a", null),
		items = list("Simple", "Weighted Random", "No Winner"),
		default = "Simple",
	)
	switch(custom_win_method)
		if("Simple")
			winner_method = VOTE_WINNER_METHOD_SIMPLE
		if("Weighted Random")
			winner_method = VOTE_WINNER_METHOD_WEIGHTED_RANDOM
		if("No Winner")
			winner_method = VOTE_WINNER_METHOD_NONE
		if(null)
			return FALSE
		else
			stack_trace("Got '[custom_win_method]' in create_vote() for custom voting.")
			to_chat(vote_creator, span_boldwarning(LANG("datum.52bffd7fcbfdd95c", null)))
			return FALSE

	var/display_stats = tgui_alert(
		vote_creator,
		LANG("datum.7998d1d2c53dba24", null),
		LANG("datum.8c4cf8fef3b2b93c", null),
		list("Yes", "No"),
	)

	if(isnull(display_stats))
		return FALSE
	display_statistics = display_stats == "Yes"

	if (!display_statistics)
		var/set_print_result = tgui_alert(
			vote_creator,
			LANG("datum.52aba783adabfc19", null),
			LANG("datum.136c1bae7036305c", null),
			list("Yes", "No"),
		)

		if (isnull(set_print_result))
			return FALSE

		print_results = set_print_result == "Yes"

	override_question = tgui_input_text(vote_creator, LANG("datum.499af3807ef2b8c8", null), LANG("datum.43aff5cd95e8d9aa", null))
	if(!override_question)
		return FALSE

	default_choices = list()
	for(var/i in 1 to MAX_CUSTOM_VOTE_OPTIONS)
		var/option = tgui_input_text(vote_creator, LANG("datum.f2cced25a446e307", list(MAX_CUSTOM_VOTE_OPTIONS)), LANG("datum.9cb8b82064c9e7e8", null), max_length = MAX_NAME_LEN)
		if(!vote_creator?.client)
			return FALSE
		if(!option)
			break

		default_choices += capitalize(option)

	if(!length(default_choices))
		return FALSE
	// Sanity for all the tgui input stalling we are doing
	if(isnull(vote_creator.client?.holder))
		return FALSE

	return ..()

/datum/vote/custom_vote/initiate_vote(initiator, duration)
	. = ..()
	. += LANG("datum.65aac1b5abce675a", list(override_question))

#undef MAX_CUSTOM_VOTE_OPTIONS
