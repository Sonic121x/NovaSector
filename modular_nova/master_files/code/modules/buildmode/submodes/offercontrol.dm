/datum/buildmode_mode/offercontrol
	key = "offercontrol"
	button_icon = 'modular_nova/master_files/icons/misc/buildmode.dmi' // if you are making a modular build mode, use this icon path.

/datum/buildmode_mode/offercontrol/show_help(client/target_client)
	to_chat(target_client, span_notice(LANG("datum.6a93028bba3dffb1", null)))

/datum/buildmode_mode/offercontrol/handle_click(client/target_client, params, object)
	if(!ismob(object))
		return

	var/mob/living/mob_to_offer = object

	if(mob_to_offer.key)
		var/response = tgui_alert(target_client, LANG("datum.0375aae9a9a97bb6", null), LANG("datum.5a31f6e659a968d9", null), list("Continue", "Cancel"))
		if(response != "Continue")
			return

	offer_control(mob_to_offer)
