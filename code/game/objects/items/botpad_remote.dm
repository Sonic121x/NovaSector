// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/botpad_remote
	name = "Bot pad controller"
	desc = "Use this device to control the connected bot pad."
	desc_controls = "Left-click for launch, right-click for recall."
	icon = 'icons/obj/devices/remote.dmi'
	icon_state = "botpad_controller"
	w_class = WEIGHT_CLASS_SMALL
	custom_materials = list(/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT, /datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT)
	// ID of the remote, used for linking up
	var/id = "botlauncher"
	var/obj/machinery/botpad/connected_botpad

/obj/item/botpad_remote/Destroy()
	if(connected_botpad)
		connected_botpad.connected_remote = null
		connected_botpad = null
	return ..()

/obj/item/botpad_remote/attack_self(mob/living/user)
	playsound(src, SFX_TERMINAL_TYPE, 25, FALSE)
	try_launch(user)
	return

/obj/item/botpad_remote/attack_self_secondary(mob/living/user)
	playsound(src, SFX_TERMINAL_TYPE, 25, FALSE)
	if(connected_botpad)
		connected_botpad.recall(user)
		return
	user?.balloon_alert(user, LANG("obj.44f11f6b98b8f44f", null))
	return

/obj/item/botpad_remote/multitool_act(mob/living/user, obj/item/multitool/multitool)
	. = NONE
	if(!istype(multitool.buffer, /obj/machinery/botpad))
		return

	var/obj/machinery/botpad/buffered_remote = multitool.buffer
	if(buffered_remote == connected_botpad)
		to_chat(user, span_warning(LANG("obj.712d8f3783d7b94d", null)))
		return ITEM_INTERACT_BLOCKING

	if(!connected_botpad && istype(buffered_remote, /obj/machinery/botpad))
		connected_botpad = buffered_remote
		connected_botpad.connected_remote = src
		connected_botpad.id = id
		multitool.set_buffer(null)
		to_chat(user, span_notice(LANG("obj.5e1089f2fea1ba22", list(multitool))))
		return ITEM_INTERACT_SUCCESS

/obj/item/botpad_remote/proc/try_launch(mob/living/user)
	if(!connected_botpad)
		user?.balloon_alert(user, LANG("obj.44f11f6b98b8f44f", null))
		return
	if(connected_botpad.panel_open)
		user?.balloon_alert(user, LANG("obj.e56d08f4d57865aa", null))
		return
	if(!(locate(/mob/living) in get_turf(connected_botpad)))
		user?.balloon_alert(user, LANG("obj.f4abdb270a020600", null))
		return
	connected_botpad.launch(user)
