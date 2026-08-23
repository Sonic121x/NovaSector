// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/action/changeling_expel_worm
	name = "Expel Worm"
	desc = "Forcefully expel the blood worm in your body."

	background_icon_state = "bg_changeling"
	overlay_icon_state = "bg_changeling_border"
	button_icon = 'icons/mob/actions/actions_changeling.dmi'
	button_icon_state = "expel_worm"

/datum/action/changeling_expel_worm/IsAvailable(feedback)
	if (!IS_CHANGELING(owner))
		return FALSE
	if (!istype(owner, /mob/living/blood_worm_host))
		return FALSE
	if (!HAS_TRAIT(owner.loc, TRAIT_BLOOD_WORM_HOST))
		return FALSE
	if (!locate(/mob/living/basic/blood_worm) in owner.loc)
		return FALSE
	return TRUE

/datum/action/changeling_expel_worm/Trigger(mob/clicker, trigger_flags)
	. = ..()
	if(!.)
		return
	var/mob/living/basic/blood_worm/invader = locate() in owner.loc
	to_chat(owner, span_danger(LANG("datum.8c780588b34aed84", list(invader))))
	to_chat(invader, span_userdanger(LANG("datum.d803423a547e90b1", list(owner.loc))))
	invader.leave_host() // hasta la vista, worm
	return TRUE
