// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/// Gives the target bad luck, optionally permanently
/datum/smite/bad_luck
	name = "Bad Luck"

	/// Should the target know they've received bad luck?
	var/silent

	/// Is this permanent?
	var/incidents

/datum/smite/bad_luck/configure(client/user)
	silent = tgui_alert(user, LANG("datum.c5311705fc5c309a", null), LANG("datum.d2553aea1224a89e", null), list("Notify", "Silent")) == "Silent"
	incidents = tgui_input_number(user, LANG("datum.d285fd8da4e6d55d", null), LANG("datum.fe7116d6cab25e4b", null), default = 0, round_value = 1)
	if(incidents == 0)
		incidents = INFINITY

/datum/smite/bad_luck/effect(client/user, mob/living/target)
	. = ..()
	//if permanent, replace any existing omen
	if(incidents == INFINITY)
		qdel(target.GetComponent(/datum/component/omen))
	target.AddComponent( \
		/datum/component/omen, \
		incidents_left = incidents, \
		on_death = CALLBACK(src, PROC_REF(on_death)), \
		bless_fixable = incidents != INFINITY, \
	)
	if(silent)
		return
	to_chat(target, span_warning(LANG("datum.b1f835cf5c2e503d", null)))
	if(incidents == INFINITY)
		to_chat(target, span_warning(LANG("datum.d475bfb9505f55ac", null)))

/datum/smite/bad_luck/proc/on_death(datum/component/omen/omen)
	if(omen.incidents_left == INFINITY)
		return

	var/mob/living/our_guy = omen.parent
	omen.death_explode(our_guy)
	our_guy.gib(DROP_ALL_REMAINS)
