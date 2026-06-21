/obj/machinery/dryer
	name = "干手器"
	desc = "“蜥蜴之息-3000”，一款实验性干手器。"
	icon = 'modular_nova/modules/salon/icons/dryer.dmi'
	icon_state = "dryer"
	density = FALSE
	anchored = TRUE
	var/busy = FALSE

/obj/machinery/dryer/attack_hand(mob/user)
	if(iscyborg(user) || isAI(user))
		return

	if(!can_interact(user))
		return

	if(busy)
		to_chat(user, span_warning("已经有人在这里干手了。"))
		return

	to_chat(user, span_notice("你开始烘干双手。"))
	playsound(src, 'modular_nova/modules/salon/sound/drying.ogg', 50)
	add_fingerprint(user)
	busy = TRUE
	if(do_after(user, 4 SECONDS, src))
		busy = FALSE
		user.visible_message("[user] 用\the [src]擦干了手。")
	else
		busy = FALSE
