/**
 * Virus disk
 * Can't hold apps, instead does unique actions.
 */
/obj/item/disk/computer/virus
	name = "\improper 通用病毒磁盘"
	icon_state = "virusdisk"
	max_capacity = 0
	///How many charges the virus has left
	var/charges = 5

/obj/item/disk/computer/virus/proc/send_virus(obj/item/modular_computer/pda/source, obj/item/modular_computer/pda/target, mob/living/user, message)
	if(charges <= 0)
		to_chat(user, span_notice("错误：使用次数已耗尽。"))
		return FALSE
	if(!target)
		to_chat(user, span_notice("错误：无法找到设备。"))
		return FALSE
	return TRUE

/**
 * Clown virus
 * Makes people's PDA honk
 * Can also be used on open panel airlocks to make them honk on opening.
 */
/obj/item/disk/computer/virus/clown
	name = "\improper H.O.N.K. 磁盘"

/obj/item/disk/computer/virus/clown/send_virus(obj/item/modular_computer/pda/source, obj/item/modular_computer/pda/target, mob/living/user, message)
	. = ..()
	if(!.)
		return FALSE

	user.show_message(span_notice("成功！"))
	charges--
	target.honkvirus_amount = rand(15, 25)
	return TRUE

/**
 * Mime virus
 * Makes PDA's silent, removing their ringtone.
 */
/obj/item/disk/computer/virus/mime
	name = "\improper 寂静之声磁盘"

/obj/item/disk/computer/virus/mime/send_virus(obj/item/modular_computer/pda/source, obj/item/modular_computer/pda/target, mob/living/user, message)
	. = ..()
	if(!.)
		return FALSE

	var/datum/computer_file/program/messenger/app = locate() in target.stored_files
	if(!app)
		return FALSE
	user.show_message(span_notice("成功！"))
	charges--
	app.alert_silenced = TRUE
	app.ringtone = ""

/**
 * Detomatix virus
 * Sends a false message, and blows the PDA up if the target responds to it (or opens their messenger before a timer)
 */
/obj/item/disk/computer/virus/detomatix
	name = "\improper D.E.T.O.M.A.T.I.X. 磁盘"
	charges = 6

/obj/item/disk/computer/virus/detomatix/send_virus(obj/item/modular_computer/pda/source, obj/item/modular_computer/pda/target, mob/living/user, message)
	. = ..()
	if(!.)
		return FALSE

	var/difficulty = target.get_detomatix_difficulty()
	if(SEND_SIGNAL(target, COMSIG_TABLET_CHECK_DETONATE) & COMPONENT_TABLET_NO_DETONATE || prob(difficulty * 15))
		user.show_message(span_danger("错误：无法轰炸目标。"), MSG_VISUAL)
		charges--
		return

	var/original_host = source
	var/fakename = sanitize_name(tgui_input_text(user, "为伪造消息输入一个名字。", "伪造消息", max_length = MAX_NAME_LEN), allow_numbers = TRUE)
	if(!fakename || source != original_host || !user.can_perform_action(source))
		return
	var/fakejob = sanitize_name(tgui_input_text(user, "为伪造消息输入一个职位。", "伪造消息", max_length = MAX_NAME_LEN), allow_numbers = TRUE)
	if(!fakejob || source != original_host || !user.can_perform_action(source))
		return
	var/attach_fake_photo = tgui_alert(user, "附加一张伪造照片？", "伪造消息", list("Yes", "No")) == "Yes"

	var/datum/computer_file/program/messenger/app = locate() in source.stored_files
	var/datum/computer_file/program/messenger/target_app = locate() in target.stored_files
	if(!app || charges <= 0 || !app.send_rigged_message(user, message, list(target_app), fakename, fakejob, attach_fake_photo))
		return FALSE
	charges--
	user.show_message(span_notice("成功！"))
	var/reference = REF(src)
	target.add_traits(list(TRAIT_PDA_CAN_EXPLODE, TRAIT_PDA_MESSAGE_MENU_RIGGED), reference)
	addtimer(TRAIT_CALLBACK_REMOVE(target, TRAIT_PDA_MESSAGE_MENU_RIGGED, reference), 10 SECONDS)
	addtimer(TRAIT_CALLBACK_REMOVE(target, TRAIT_PDA_CAN_EXPLODE, reference), 1 MINUTES)
	return TRUE

/**
 * Frame cartridge
 * Creates and opens a false uplink on someone's PDA
 * Can be loaded with TC to show up on the false uplink.
 */
/obj/item/disk/computer/virus/frame
	name = "\improper F.R.A.M.E. 磁盘"

	///How many telecrystals the uplink should have
	var/telecrystals = 0
	///How much progression should be shown in the uplink, set on purchase of the item.
	var/current_progression = 0

/obj/item/disk/computer/virus/frame/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	. = ..()
	if(!istype(attacking_item, /obj/item/stack/telecrystal))
		return
	if(!charges)
		to_chat(user, span_notice("[src] 使用次数已耗尽，它拒绝接受 [attacking_item]。"))
		return
	var/obj/item/stack/telecrystal/telecrystal_stack = attacking_item
	telecrystals += telecrystal_stack.amount
	to_chat(user, span_notice("你将 [telecrystal_stack] 插入 [src]。下次使用时，它也将提供远程水晶。"))
	telecrystal_stack.use(telecrystal_stack.amount)


/obj/item/disk/computer/virus/frame/send_virus(obj/item/modular_computer/pda/source, obj/item/modular_computer/pda/target, mob/living/user, message)
	. = ..()
	if(!.)
		return FALSE

	charges--
	var/unlock_code = "[rand(100,999)] [pick(GLOB.phonetic_alphabet)]"
	to_chat(user, span_notice("成功！目标的解锁代码是：[unlock_code]"))
	var/datum/component/uplink/hidden_uplink = target.GetComponent(/datum/component/uplink)
	if(!hidden_uplink)
		var/datum/mind/target_mind
		var/list/backup_players = list()
		for(var/datum/mind/player as anything in get_crewmember_minds())
			if(player.assigned_role?.title == target.saved_job)
				backup_players += player
			if(player.name == target.saved_identification)
				target_mind = player
				break
		if(!target_mind)
			if(!length(backup_players))
				target_mind = user.mind
			else
				target_mind = pick(backup_players)
		hidden_uplink = target.AddComponent(/datum/component/uplink, target_mind, enabled = TRUE, starting_tc = telecrystals, has_progression = TRUE)
		hidden_uplink.unlock_code = unlock_code
		hidden_uplink.uplink_handler.owner = target_mind
		hidden_uplink.uplink_handler.progression_points = min(SStraitor.current_global_progression, current_progression)
		SStraitor.register_uplink_handler(hidden_uplink.uplink_handler)
	else
		hidden_uplink.uplink_handler.add_telecrystals(telecrystals)
	telecrystals = 0
	hidden_uplink.locked = FALSE
	hidden_uplink.active = TRUE
