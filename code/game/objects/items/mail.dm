/// Mail is tamper-evident and unresealable, postmarked by CentCom for an individual recepient.
/obj/item/mail
	name = "邮件"
	gender = NEUTER
	desc = "一个由中央司令部监管、带有官方邮戳、防拆封的高质量材料包裹。"
	icon = 'icons/obj/service/bureaucracy.dmi'
	icon_state = "mail_small"
	inhand_icon_state = "paper"
	worn_icon_state = "paper"
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_SMALL
	drop_sound = 'sound/items/handling/paper_drop.ogg'
	pickup_sound = 'sound/items/handling/paper_pickup.ogg'
	mouse_drag_pointer = MOUSE_ACTIVE_POINTER
	/// Destination tagging for the mail sorter.
	var/sort_tag = 0
	/// Weak reference to who this mail is for and who can open it.
	var/datum/weakref/recipient_ref
	/// How many goodies this mail contains.
	var/goodie_count = 1
	/// Goodies which can be given to anyone. The base weight is 50. For there to be a 50/50 chance of getting a department item, they need 50 weight as well.
	var/list/generic_goodies = list(
		/obj/effect/spawner/random/entertainment/money_medium = 25,
		/obj/effect/spawner/random/food_or_drink/refreshing_beverage = 10,
		/obj/effect/spawner/random/food_or_drink/snack = 5,
		/obj/effect/spawner/random/food_or_drink/donkpockets_single = 5,
		/obj/effect/spawner/random/entertainment/toy = 3,
		/obj/effect/spawner/random/entertainment/coin = 2,
	)
	// Overlays (pure fluff)
	/// Does the letter have the postmark overlay?
	var/postmarked = TRUE
	/// Does the letter have a stamp overlay?
	var/stamped = TRUE
	/// List of all stamp overlays on the letter.
	var/list/stamps = list()
	/// Maximum number of stamps on the letter.
	var/stamp_max = 1
	/// Physical offset of stamps on the object. X direction.
	var/stamp_offset_x = 0
	/// Physical offset of stamps on the object. Y direction.
	var/stamp_offset_y = 2

	///mail will have the color of the department the recipient is in.
	var/static/list/department_colors

/obj/item/mail/envelope
	name = "信封"
	icon_state = "mail_large"
	goodie_count = 2
	stamp_max = 2
	stamp_offset_y = 5

/obj/item/mail/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_MOVABLE_DISPOSING, PROC_REF(disposal_handling))
	AddElement(/datum/element/item_scaling, 0.75, 1)
	if(isnull(department_colors))
		department_colors = list(
			ACCOUNT_CIV = COLOR_WHITE,
			ACCOUNT_ENG = COLOR_PALE_ORANGE,
			ACCOUNT_SCI = COLOR_PALE_PURPLE_GRAY,
			ACCOUNT_MED = COLOR_PALE_BLUE_GRAY,
			ACCOUNT_SRV = COLOR_PALE_GREEN_GRAY,
			ACCOUNT_CAR = COLOR_BEIGE,
			ACCOUNT_SEC = COLOR_PALE_RED_GRAY,
			ACCOUNT_CMD = COLOR_BLUE_GRAY, // NOVA EDIT ADDITION
			ACCOUNT_CCM = COLOR_DARK_MODERATE_LIME_GREEN, // NOVA EDIT ADDITION
		)

	// Icons
	// Add some random stamps.
	if(stamped == TRUE)
		var/stamp_count = rand(1, stamp_max)
		for(var/i in 1 to stamp_count)
			stamps += list("stamp_[rand(2, 6)]")
	update_icon()

/obj/item/mail/update_overlays()
	. = ..()
	var/bonus_stamp_offset = 0
	for(var/stamp in stamps)
		var/image/stamp_image = image(
			icon = icon,
			icon_state = stamp
		)
		stamp_image.pixel_w = pixel_w = stamp_offset_x
		stamp_image.pixel_z = stamp_offset_y + bonus_stamp_offset
		stamp_image.appearance_flags |= RESET_COLOR|KEEP_APART
		bonus_stamp_offset -= 5
		. += stamp_image

	if(postmarked == TRUE)
		var/image/postmark_image = image(
			icon = icon,
			icon_state = "postmark"
		)
		postmark_image.pixel_w = stamp_offset_x + rand(-3, 1)
		postmark_image.pixel_z = stamp_offset_y + rand(bonus_stamp_offset + 3, 1)
		postmark_image.appearance_flags |= RESET_COLOR|KEEP_APART
		. += postmark_image

/obj/item/mail/attackby(obj/item/W, mob/user, list/modifiers, list/attack_modifiers)
	// Destination tagging
	if(istype(W, /obj/item/dest_tagger))
		var/obj/item/dest_tagger/destination_tag = W

		if(sort_tag != destination_tag.currTag)
			var/tag = uppertext(GLOB.TAGGERLOCATIONS[destination_tag.currTag])
			to_chat(user, span_notice("*[tag]*"))
			sort_tag = destination_tag.currTag
			playsound(loc, 'sound/machines/beep/twobeep_high.ogg', vol = 100, vary = TRUE)

/obj/item/mail/multitool_act(mob/living/user, obj/item/tool)
	if(user.get_inactive_held_item() == src)
		balloon_alert(user, "没有可禁用的东西！")
		return TRUE
	balloon_alert(user, "拿稳了！")
	return FALSE


/obj/item/mail/attack_self(mob/user)
	if(!unwrap(user))
		return FALSE
	return after_unwrap(user)

/// proc for unwrapping a mail. Goes just for an unwrapping procces, returns FALSE if it fails.
/obj/item/mail/proc/unwrap(mob/user)
	if(recipient_ref)
		var/datum/mind/recipient = recipient_ref.resolve()
		// If the recipient's mind has gone, then anyone can open their mail
		// whether a mind can actually be qdel'd is an exercise for the reader
		if(recipient && recipient != user?.mind)
			to_chat(user, span_notice("你不能打开别人的信件！那是 <em>违法</em>的!"))
			return FALSE

	balloon_alert(user, "正在拆开...")
	if(!do_after(user, 1.5 SECONDS, target = user))
		return FALSE
	return TRUE

// proc that goes after unwrapping a mail.
/obj/item/mail/proc/after_unwrap(mob/user)
	user.temporarilyRemoveItemFromInventory(src, force = TRUE)
	for(var/obj/stuff as anything in contents) // Mail and envelope actually can have more than 1 item.
		if(isitem(stuff))
			user.put_in_hands(stuff)
		else
			stuff.forceMove(drop_location())
	playsound(loc, 'sound/items/poster/poster_ripped.ogg', vol = 50, vary = TRUE)
	qdel(src)
	return TRUE


/obj/item/mail/examine_more(mob/user)
	. = ..()
	if(!postmarked)
		. += span_info("这封邮件没有任何形式的邮戳...")
	else
		. += span_notice("<i>你注意到信件上正面的邮戳...</i>")
	var/datum/mind/recipient = recipient_ref.resolve()
	if(recipient)
		. += span_info("[postmarked ? "Certified NT" : "Uncertfieid"] 给 [recipient] 的邮件。")
	else if(postmarked)
		. += span_info("给[GLOB.station_name]的认证信件.")
	else
		. += span_info("这是一封无主邮件，没有收件人。")
	. += span_info("手动派送或使用目的地标记器通过纳米传讯认证的处置系统进行分发.")

/// Accepts a mind to initialize goodies for a piece of mail.
/obj/item/mail/proc/initialize_for_recipient(datum/mind/recipient)
	name = "给 [recipient.name] ([recipient.assigned_role.title]) 的 [initial(name)]"
	recipient_ref = WEAKREF(recipient)

	var/mob/living/body = recipient.current
	var/list/goodies = generic_goodies

	var/datum/job/this_job = recipient.assigned_role
	var/is_mail_restricted = FALSE // certain roles and jobs (prisoner) do not receive generic gifts

	if(this_job)
		if(this_job.paycheck_department && department_colors[this_job.paycheck_department])
			color = department_colors[this_job.paycheck_department]

		var/list/job_goodies = this_job.get_mail_goodies()
		is_mail_restricted = this_job.exclusive_mail_goodies
		if(LAZYLEN(job_goodies))
			if(is_mail_restricted)
				goodies = job_goodies
			else
				goodies += job_goodies

	if(!is_mail_restricted)
		// the weighted list is 50 (generic items) + 50 (job items)
		// every quirk adds 5 to the final weighted list (regardless the number of items or weights in the quirk list)
		// 5% is not too high or low so that stacking multiple quirks doesn't tilt the weighted list too much
		for(var/datum/quirk/quirk as anything in body.quirks)
			if(LAZYLEN(quirk.mail_goodies))
				var/quirk_goodie = pick(quirk.mail_goodies)
				goodies[quirk_goodie] = 5

		if(LAZYLEN(GLOB.holiday_mail))
			var/holiday_goodie = pick(GLOB.holiday_mail)
			goodies[holiday_goodie] = 5

	for(var/iterator in 1 to goodie_count)
		var/target_good = pick_weight(goodies)
		var/atom/movable/target_atom = new target_good(src)
		body.log_message("received [target_atom.name] in the mail ([target_good])", LOG_GAME)

	return TRUE

/// Alternate setup, just complete garbage inside and anyone can open
/obj/item/mail/proc/junk_mail()

	var/obj/junk = /obj/item/paper/fluff/junkmail_generic
	var/special_name = FALSE

	if(prob(25))
		special_name = TRUE
		junk = pick(list(
			/obj/item/paper/pamphlet/gateway,
			/obj/item/paper/pamphlet/violent_video_games,
			/obj/item/paper/fluff/junkmail_redpill,
			/obj/effect/decal/cleanable/ash,
		))

	var/list/junk_names = list(
		/obj/item/paper/pamphlet/gateway = "[initial(name)] for [pick(GLOB.adjectives)] adventurers",
		/obj/item/paper/pamphlet/violent_video_games = "[initial(name)] for the truth about the arcade centcom doesn't want to hear",
		/obj/item/paper/fluff/junkmail_redpill = "[initial(name)] for those feeling [pick(GLOB.adjectives)] working at Nanotrasen",
		/obj/effect/decal/cleanable/ash = "[initial(name)] with INCREDIBLY IMPORTANT ARTIFACT- DELIVER TO SCIENCE DIVISION. HANDLE WITH CARE.",
	)

	color = pick(department_colors) //eh, who gives a shit.
	name = special_name ? junk_names[junk] : "重要的 [initial(name)]"

	junk = new junk(src)
	return TRUE

/obj/item/mail/proc/disposal_handling(disposal_source, obj/structure/disposalholder/disposal_holder, obj/machinery/disposal/disposal_machine, hasmob)
	SIGNAL_HANDLER
	if(!hasmob)
		disposal_holder.destinationTag = sort_tag

/// Subtype that's always junkmail
/obj/item/mail/junkmail/Initialize(mapload)
	. = ..()
	junk_mail()

/// Crate for mail from CentCom.
/obj/structure/closet/crate/mail
	name = "邮件板条箱"
	desc = "一个来自中央司令部的认证邮政板条箱。"
	icon_state = "mail"
	base_icon_state = "mail"
	can_install_electronics = FALSE
	lid_icon_state = "maillid"
	lid_w = -26
	lid_z = 2
	weld_w = 1
	weld_z = 4
	paint_jobs = null
	///if it'll show the nt mark on the crate
	var/postmarked = TRUE

/obj/structure/closet/crate/mail/update_icon_state()
	. = ..()
	if(opened)
		icon_state = "[base_icon_state]open"
		if(locate(/obj/item/mail) in src)
			icon_state = base_icon_state
	else
		icon_state = "[base_icon_state]sealed"

/obj/structure/closet/crate/mail/update_overlays()
	. = ..()
	if(postmarked)
		. += "mail_nt"

/// Fills this mail crate with N pieces of mail, where N is the lower of the amount var passed, and the maximum capacity of this crate. If N is larger than the number of alive human players, the excess will be junkmail.
/obj/structure/closet/crate/mail/proc/populate(amount)
	var/mail_count = min(amount, storage_capacity)
	// Fills the
	var/list/mail_recipients = list()

	for(var/mob/living/carbon/human/human in GLOB.player_list)
		if(human.stat == DEAD || !human.mind)
			continue
		// Skip wizards, nuke ops, cyborgs; Centcom does not send them mail
		if(!(human.mind.assigned_role.job_flags & JOB_CREW_MEMBER))
			continue

		mail_recipients += human.mind

	for(var/i in 1 to mail_count)
		var/obj/item/mail/new_mail
		if(prob(FULL_CRATE_LETTER_ODDS))
			new_mail = new /obj/item/mail(src)
		else
			new_mail = new /obj/item/mail/envelope(src)

		var/datum/mind/recipient = pick_n_take(mail_recipients)
		if(recipient)
			new_mail.initialize_for_recipient(recipient)
		else
			new_mail.junk_mail()

	update_icon()

/// Crate for mail that automatically depletes the economy subsystem's pending mail counter.
/obj/structure/closet/crate/mail/economy/Initialize(mapload)
	. = ..()
	populate(SSeconomy.mail_waiting)
	SSeconomy.mail_waiting = 0

/// Crate for mail that automatically generates a lot of mail. Usually only normal mail, but on lowpop it may end up just being junk.
/obj/structure/closet/crate/mail/full
	name = "满溢的邮件板条箱"
	desc = "一个来自中央司令部的认证邮政板条箱。看起来塞得满满当当。"

/obj/structure/closet/crate/mail/full/Initialize(mapload)
	. = ..()
	populate(INFINITY)

///Used in the mail strike shuttle loan event
/obj/structure/closet/crate/mail/full/mail_strike
	desc = "一个来自其他地方的邮政板条箱。上面没有NT标志。"
	postmarked = FALSE

/obj/structure/closet/crate/mail/full/mail_strike/populate(amount)
	var/strike_mail_to_spawn = rand(1, storage_capacity-1)
	for(var/i in 1 to strike_mail_to_spawn)
		if(prob(95))
			new /obj/item/mail/mail_strike(src)
		else
			new /obj/item/mail/traitor/mail_strike(src)
	return ..(storage_capacity - strike_mail_to_spawn)

/// Opened mail crate
/obj/structure/closet/crate/mail/preopen
	opened = TRUE
	icon_state = "mailopen"

/// Mailbag.
/obj/item/storage/bag/mail
	name = "邮件袋"
	desc = "一个用于存放信件、信封和其他邮件的袋子。"
	icon = 'icons/obj/service/bureaucracy.dmi'
	icon_state = "mailbag"
	worn_icon_state = "mailbag"
	resistance_flags = FLAMMABLE
	custom_premium_price = PAYCHECK_LOWER
	storage_type = /datum/storage/bag/mail

/obj/item/paper/fluff/junkmail_redpill
	name = "污迹斑斑的纸张"
	icon_state = "scrap"
	show_written_words = FALSE
	var/nuclear_option_odds = 0.1

/obj/item/paper/fluff/junkmail_redpill/Initialize(mapload)
	var/obj/machinery/nuclearbomb/selfdestruct/self_destruct = locate() in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/nuclearbomb/selfdestruct)
	if(!self_destruct || !prob(nuclear_option_odds)) // 1 in 1000 chance of getting 2 random nuke code characters.
		add_raw_text("<i>You need to escape the simulation. Don't forget the numbers, they help you remember:</i> '[rand(0,9)][rand(0,9)][rand(0,9)]...'")
		return ..()

	if(self_destruct.r_code == NUKE_CODE_UNSET)
		self_destruct.r_code = random_nukecode()
		message_admins("Through junkmail, the self-destruct code was set to \"[self_destruct.r_code]\".")
	add_raw_text("<i>You need to escape the simulation. Don't forget the numbers, they help you remember:</i> '[self_destruct.r_code[rand(1,5)]][self_destruct.r_code[rand(1,5)]]...'")
	return ..()

/obj/item/paper/fluff/junkmail_redpill/true //admin letter enabling players to brute force their way through the nuke code if they're so inclined.
	nuclear_option_odds = 100

/obj/item/paper/fluff/junkmail_generic
	name = "重要文件"
	icon_state = "paper_words"
	show_written_words = FALSE

/obj/item/paper/fluff/junkmail_generic/Initialize(mapload)
	default_raw_text = pick(GLOB.junkmail_messages)
	return ..()

/obj/item/mail/traitor
	var/armed = FALSE
	var/datum/weakref/made_by_ref
	/// Cached information about who made it for logging purposes
	var/made_by_cached_name
	/// Cached information about who made it for logging purposes
	var/made_by_cached_ckey
	goodie_count = 0

/obj/item/mail/traitor/envelope
	name = "信封"
	icon_state = "mail_large"
	stamp_max = 2
	stamp_offset_y = 5

/obj/item/mail/traitor/after_unwrap(mob/user)
	user.temporarilyRemoveItemFromInventory(src, force = TRUE)
	playsound(loc, 'sound/items/poster/poster_ripped.ogg', vol = 50, vary = TRUE)
	for(var/obj/item/stuff as anything in contents) // Mail and envelope actually can have more than 1 item.
		if(!armed)
			continue
		var/whomst = made_by_cached_name ? "[made_by_cached_name] ([made_by_cached_ckey])" : "no one in particular"
		log_bomber(user, "opened armed mail made by [whomst], activating", stuff)

		if(SEND_SIGNAL(stuff, COMSIG_ITEM_IN_UNWRAPPED_TRAITOR_MAIL, user, src) & COMPONENT_TRAITOR_MAIL_HANDLED)
			continue

		if(!user.put_in_hands(stuff))
			continue

		INVOKE_ASYNC(stuff, TYPE_PROC_REF(/obj/item, attack_self), user)
	qdel(src)
	return TRUE

/obj/item/mail/traitor/multitool_act(mob/living/user, obj/item/tool)
	if(armed == FALSE || user.get_inactive_held_item() != src)
		return ..()
	if(IS_WEAKREF_OF(user.mind, made_by_ref))
		balloon_alert(user, "正在解除陷阱...")
		if(!do_after(user, 2 SECONDS, target = src))
			return FALSE
		balloon_alert(user, "已解除")
		playsound(src, 'sound/machines/defib/defib_ready.ogg', vol = 100, vary = TRUE)
		armed = FALSE
		return TRUE
	balloon_alert(user, "正在摆弄着什么...")

	if(!do_after(user, 2 SECONDS, target = src))
		after_unwrap(user)
		return FALSE
	if(prob(50))
		balloon_alert(user, "解除了什么...？")
		playsound(src, 'sound/machines/defib/defib_ready.ogg', vol = 100, vary = TRUE)
		armed = FALSE
		return TRUE
	after_unwrap(user)
	return TRUE

///Generic mail used in the mail strike shuttle loan event
/obj/item/mail/mail_strike
	name = "死信"
	desc = "一个来源不明的未标记包裹，实际上无法投递。"
	postmarked = FALSE
	generic_goodies = list(
		/obj/effect/spawner/random/entertainment/money_medium = 2,
		/obj/effect/spawner/random/contraband = 2,
		/obj/effect/spawner/random/entertainment/money_large = 1,
		/obj/effect/spawner/random/entertainment/coin = 1,
		/obj/effect/spawner/random/food_or_drink/any_snack_or_beverage = 1,
		/obj/effect/spawner/random/entertainment/drugs = 1,
		/obj/effect/spawner/random/contraband/grenades = 1,
	)

/obj/item/mail/mail_strike/Initialize(mapload)
	if(prob(35))
		stamped = FALSE
	if(prob(35))
		name = "死信信封"
		icon_state = "mail_large"
		goodie_count = 2
		stamp_max = 2
		stamp_offset_y = 5
	. = ..()
	color = pick(COLOR_SILVER, COLOR_DARK, COLOR_DRIED_TAN, COLOR_ORANGE_BROWN, COLOR_BROWN, COLOR_SYNDIE_RED)
	for(var/goodie in 1 to goodie_count)
		var/target_good = pick_weight(generic_goodies)
		new target_good(src)

///Also found in the mail strike shuttle loan. It contains a random grenade that'll be triggered when unwrapped
/obj/item/mail/traitor/mail_strike
	name = "死信"
	desc = "一个来源不明的未标记包裹，实际上无法投递。"
	postmarked = FALSE

/obj/item/mail/traitor/mail_strike/Initialize(mapload)
	if(prob(35))
		stamped = FALSE
	if(prob(35))
		name = "死信信封"
		icon_state = "mail_large"
		goodie_count = 2
		stamp_max = 2
		stamp_offset_y = 5
	. = ..()
	color = pick(COLOR_SILVER, COLOR_DARK, COLOR_DRIED_TAN, COLOR_ORANGE_BROWN, COLOR_BROWN, COLOR_SYNDIE_RED)
	new /obj/effect/spawner/random/contraband/grenades/dangerous(src)

/obj/item/storage/mail_counterfeit_device
	name = "GLA-2 邮件伪造装置"
	desc = "一种用于伪造官方 NT 信封的一次性装置。可容纳一个正常大小的物品，并可编程设定在打开时启动其内容物。"
	w_class = WEIGHT_CLASS_NORMAL
	icon = 'icons/obj/antags/syndicate_tools.dmi'
	icon_state = "mail_counterfeit_device"
	storage_type = /datum/storage/mail_counterfeit

/obj/item/storage/mail_counterfeit_device/examine_more(mob/user)
	. = ..()
	. += span_notice("<i>你注意到装置侧面的制造商信息...</i>")
	. += "\t[span_info("Guerilla Letter Assembler")]"
	. += "\t[span_info("GLA Postal Service, right on schedule.")]"
	return .

/obj/item/storage/mail_counterfeit_device/attack_self(mob/user, modifiers)
	var/mail_type = tgui_alert(user, "让它看起来像一个信封还是像普通邮件？", "邮件伪造", list("Mail", "Envelope"))
	if(isnull(mail_type))
		return FALSE
	if(loc != user)
		return FALSE
	mail_type = LOWER_TEXT(mail_type)

	var/mail_armed = tgui_alert(user, "要设置陷阱吗？", "邮件伪造", list("Yes", "No")) == "Yes"
	if(isnull(mail_armed))
		return FALSE
	if(loc != user)
		return FALSE

	var/list/mail_recipients = list("Anyone")
	var/list/mail_recipients_for_input = list("Anyone")
	var/list/used_names = list()
	for(var/datum/record/locked/person in sort_record(GLOB.manifest.locked))
		var/datum/mind/locked_mind = person.mind_ref.resolve()
		if(isnull(locked_mind))
			continue
		mail_recipients += locked_mind
		mail_recipients_for_input += avoid_assoc_duplicate_keys(person.name, used_names)

	var/recipient = tgui_input_list(user, "选择收件人", "邮件伪造", mail_recipients_for_input)
	if(isnull(recipient))
		return FALSE
	if(!(src in user.contents))
		return FALSE

	var/index = mail_recipients_for_input.Find(recipient)

	var/obj/item/mail/traitor/shady_mail
	if(mail_type == "mail")
		shady_mail = new /obj/item/mail/traitor
	else
		shady_mail = new /obj/item/mail/traitor/envelope

	shady_mail.made_by_cached_ckey = user.ckey
	shady_mail.made_by_cached_name = user.mind.name

	if(index == 1)
		var/mail_name = tgui_input_text(user, "输入邮件标题，或留空", "邮件伪造", max_length = MAX_LABEL_LEN)
		if(!(src in user.contents))
			return FALSE
		if(reject_bad_text(mail_name, max_length = MAX_LABEL_LEN, ascii_only = FALSE))
			shady_mail.name = mail_name
		else
			shady_mail.name = mail_type
	else
		shady_mail.initialize_for_recipient(mail_recipients[index])

	atom_storage.hide_contents(user)
	user.temporarilyRemoveItemFromInventory(src, force = TRUE)
	shady_mail.contents += contents
	shady_mail.armed = mail_armed
	shady_mail.made_by_ref = WEAKREF(user.mind)
	user.put_in_hands(shady_mail)
	qdel(src)

/// Unobtainable item mostly for (b)admin purposes.
/obj/item/storage/mail_counterfeit_device/advanced
	name = "GLA-MACRO邮件伪造装置"
	storage_type = /datum/storage/mail_counterfeit/advanced

/obj/item/storage/mail_counterfeit_device/advanced/Initialize(mapload)
	. = ..()
	desc += " This model is highly advanced and capable of compressing items, making mail's storage space comparable to standard backpack."

/// Unobtainable item mostly for (b)admin purposes.
/obj/item/storage/mail_counterfeit_device/bluespace
	name = "GLA-ULTRA邮件伪造装置"
	storage_type = /datum/storage/mail_counterfeit/bluespace

/obj/item/storage/mail_counterfeit_device/bluespace/Initialize(mapload)
	. = ..()
	desc += " This model is the most advanced and capable of performing crazy bluespace compressions, making mail's storage space comparable to bluespace backpack."
