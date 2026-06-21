/// Essentially a rewritten version of Hilbert's Hotel that supports multiple map templates; and a reference to GMTower's beautiful condo system. You should play it's successor... :3
/obj/machinery/cafe_condo_teleporter
	name = "矩阵化传送装置"
	desc = "一个细分、稳定的传送系统，带有一个不可见的中央处理枢纽。"
	icon = /obj/machinery/teleport/hub::icon
	icon_state = /obj/machinery/teleport/hub::icon_state
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/machinery/cafe_condo_teleporter/examine(mob/user)
	. = ..()
	. += span_notice("你可以用它来退入一个私人房间。")
	. += span_warning("注意：一旦所有居住者离开房间，房间就会重置。")

/obj/machinery/cafe_condo_teleporter/attack_robot(mob/user)
	if(user.Adjacent(src))
		prompt_and_check_in(user, user)
	return TRUE

/obj/machinery/cafe_condo_teleporter/attack_hand(mob/living/user, list/modifiers)
	prompt_and_check_in(user, user)
	return TRUE

/obj/machinery/cafe_condo_teleporter/attack_tk(mob/user)
	to_chat(user, span_notice("\The [src] 主动排斥你的意念，因为周围的蓝空能量干扰了你的心灵传动。"))
	return COMPONENT_CANCEL_ATTACK_CHAIN

/// They're adjacent - ask them for their desired room number and, if it's new; what archetype they want.
/obj/machinery/cafe_condo_teleporter/proc/prompt_and_check_in(mob/user, mob/target)
	var/requested_condo = tgui_input_number(target, "您要登记入住哪个房间号？", "房间号", 1, min_value = 1)
	if(!requested_condo)
		return
	if(requested_condo > SHORT_REAL_LIMIT)
		to_chat(target, span_warning("该网络仅连接了 [SHORT_REAL_LIMIT] 个房间！"))
		return
	if((requested_condo < 1) || (requested_condo != round(requested_condo)))
		to_chat(target, span_warning("这不是一个有效的房间号！"))
		return
	if(!check_target_eligibility(target))
		return

	if(SScondos.active_condos["[requested_condo]"])
		SScondos.enter_active_room(requested_condo, target)

	else
		var/datum/map_template/chosen_condo
		var/map = tgui_input_list(user, "您要登记入住哪种公寓？","公寓原型", sort_list(SScondos.condo_templates))
		if(!map || !check_target_eligibility(target))
			return
		// Possible the room became active after we opened this UI - just enter it with a warning.
		if(SScondos.active_condos["[requested_condo]"])
			to_chat(target, span_warning("你请求的房间号在你选择期间已被占用！正在将你传送至已被占用的公寓..."))
			SScondos.enter_active_room(requested_condo, target)
			return
		chosen_condo = SScondos.condo_templates[map]
		SScondos.create_and_enter_condo(requested_condo, chosen_condo, user, src)

/// Sanitycheck to prevent exploitation
/obj/machinery/cafe_condo_teleporter/proc/check_target_eligibility(mob/to_be_checked)
	if(!src.Adjacent(to_be_checked))
		to_chat(to_be_checked, span_warning("You too far away from \the [src] to enter it!"))
		return FALSE
	if(to_be_checked.incapacitated)
		to_chat(to_be_checked, span_warning("You aren't able to activate \the [src] anymore!"))
		return FALSE
	return TRUE
