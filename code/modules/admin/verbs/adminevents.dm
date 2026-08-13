// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
// Admin Tab - Event Verbs

ADMIN_VERB_ONLY_CONTEXT_MENU(cmd_admin_subtle_message, R_ADMIN, "私密消息", /mob)
	VERB_ARG_TYPED(target, VERB_ARG_TYPE_MOB, VERB_ARG_SOURCE_WORLD, /mob)
	message_admins("[key_name_admin(user)] has started answering [ADMIN_LOOKUPFLW(target)]'s prayer.")
	var/msg = input(user, LANG("datum.008d3052", null), LANG("datum.03de8cc3", list(target.key))) as text|null

	if(!msg)
		message_admins("[key_name_admin(user)] decided not to answer [ADMIN_LOOKUPFLW(target)]'s prayer")
		return

	msg = user.reformat_narration(msg)

	target.balloon_alert(target, LANG("datum.d955e950", null))
	to_chat(target, LANG("datum.5ea2cf68", list(msg)), confidential = TRUE)

	log_admin("SubtlePM: [key_name(user)] -> [key_name(target)] : [msg]")
	msg = span_adminnotice("<b> SubtleMessage: [key_name_admin(user)] -> [key_name_admin(target)] :</b> [msg]")
	message_admins(msg)
	admin_ticket_log(target, msg)
	BLACKBOX_LOG_ADMIN_VERB("Subtle Message")

ADMIN_VERB_ONLY_CONTEXT_MENU(cmd_admin_headset_message, R_ADMIN, "耳机消息", /mob)
	VERB_ARG_TYPED(target, VERB_ARG_TYPE_MOB, VERB_ARG_SOURCE_WORLD, /mob)
	user.admin_headset_message(target)

/client/proc/admin_headset_message(mob/target in GLOB.mob_list, sender = null)
	var/mob/living/carbon/human/human_recipient
	var/mob/living/silicon/silicon_recipient

	if(!check_rights(R_ADMIN))
		return


	if(ishuman(target))
		human_recipient = target
		if(!istype(human_recipient.ears, /obj/item/radio/headset))
			to_chat(usr, LANG("client.eab59e40", null), confidential = TRUE)
			return
	else if(issilicon(target))
		silicon_recipient = target
		if(!istype(silicon_recipient.radio, /obj/item/radio))
			to_chat(usr, LANG("client.eda1e55f", null), confidential = TRUE)
			return
	else
		to_chat(usr, LANG("client.fde4ec38", null), confidential = TRUE)
		return

	if (!sender)
		sender = input(LANG("client.25741089", null), LANG("client.2bc502a9", null)) as null|anything in list(RADIO_CHANNEL_CENTCOM,RADIO_CHANNEL_SYNDICATE)
		if(!sender)
			return

	message_admins("[key_name_admin(src)] has started answering [key_name_admin(target)]'s [sender] request.")
	var/input = input(LANG("client.deaf7443", list(key_name(target))),LANG("client.3bc3c9ab", list(sender)), "") as text|null
	if(!input)
		message_admins("[key_name_admin(src)] decided not to answer [key_name_admin(target)]'s [sender] request.")
		return

	input = reformat_narration(input)

	log_directed_talk(mob, target, input, LOG_ADMIN, "reply")
	message_admins("[key_name_admin(src)] replied to [key_name_admin(target)]'s [sender] message with: \"[input]\"")
	target.balloon_alert(target, LANG("client.d955e950", null))
	to_chat(target, span_hear(LANG("client.06743bb0", list(human_recipient ? "ears" : "radio receiver", sender == "Syndicate" ? "your benefactor" : "Central Command", sender == "Syndicate" ? ", agent." : ":", input))), confidential = TRUE)

	BLACKBOX_LOG_ADMIN_VERB("Headset Message")

ADMIN_VERB(cmd_admin_world_narrate, R_ADMIN, "全局旁白", "Send a direct narration to all connected players.", ADMIN_CATEGORY_EVENTS)
	var/msg = input(user, LANG("datum.008d3052", null), LANG("datum.7c26d5bd", null)) as text|null
	if (!msg)
		return
	msg = user.reformat_narration(msg)
	to_chat(world, "[msg]", confidential = TRUE)
	log_admin("GlobalNarrate: [key_name(user)] : [msg]")
	message_admins(span_adminnotice("[key_name_admin(user)] Sent a global narrate"))
	BLACKBOX_LOG_ADMIN_VERB("Global Narrate")

ADMIN_VERB_ONLY_CONTEXT_MENU(cmd_admin_local_narrate, R_ADMIN, "本地旁白", /atom)
	VERB_ARG_TYPED(locale, VERB_ARG_TYPE_ATOM, VERB_ARG_SOURCE_WORLD, /atom)
	var/range = input(user, LANG("datum.c5d1936b", null), LANG("datum.520ed99b", null), 7) as num|null
	if(!range)
		return
	var/msg = input(user, LANG("datum.008d3052", null), LANG("datum.4d8da095", null)) as text|null
	if (!msg)
		return
	msg = user.reformat_narration(msg)
	for(var/mob/M in view(range, locale))
		to_chat(M, msg, confidential = TRUE)

	log_admin("LocalNarrate: [key_name(user)] at [AREACOORD(locale)]: [msg]")
	message_admins(span_adminnotice("<b> LocalNarrate: [key_name_admin(user)] at [ADMIN_VERBOSEJMP(locale)]:</b> [msg]<BR>"))
	BLACKBOX_LOG_ADMIN_VERB("Local Narrate")

ADMIN_VERB_ONLY_CONTEXT_MENU(cmd_admin_direct_narrate, R_ADMIN, "直接旁白", /mob)
	VERB_ARG_TYPED(target, VERB_ARG_TYPE_MOB, VERB_ARG_SOURCE_WORLD, /mob)
	var/msg = input(user, LANG("datum.008d3052", null), LANG("datum.5d97ad04", null)) as text|null

	if( !msg )
		return

	msg = user.reformat_narration(msg)

	to_chat(target, msg, confidential = TRUE)
	log_admin("DirectNarrate: [key_name(user)] to ([key_name(target)]): [msg]")
	msg = span_adminnotice("<b> DirectNarrate: [key_name_admin(user)] to ([key_name_admin(target)]):</b> [msg]<BR>")
	message_admins(msg)
	admin_ticket_log(target, msg)
	BLACKBOX_LOG_ADMIN_VERB("Direct Narrate")

ADMIN_VERB(cmd_admin_add_freeform_ai_law, R_ADMIN, "添加自定义 AI 法则", "Add a custom law to the Silicons.", ADMIN_CATEGORY_EVENTS)
	var/input = input(user, LANG("datum.d01816bc", null), LANG("datum.29297405", null), "") as text|null
	if(!input)
		return

	log_admin("Admin [key_name(user)] has added a new AI law - [input]")
	message_admins("Admin [key_name_admin(user)] has added a new AI law - [input]")

	var/show_log = tgui_alert(user, LANG("datum.5d9fa149", null), LANG("datum.affb7d7e", null), list("Yes", "No"))
	var/announce_ion_laws = (show_log == "Yes" ? 100 : 0)

	var/datum/round_event/ion_storm/ion = new
	ion.announce_chance = announce_ion_laws
	ion.ionMessage = input
	ion.replaceLawsetChance = 0
	ion.removeRandomLawChance = 0
	ion.removeDontImproveChance = 0
	ion.shuffleLawsChance = 0
	ion.botEmagChance = 0

	BLACKBOX_LOG_ADMIN_VERB("Add Custom AI Law")

ADMIN_VERB(toggle_nuke, R_DEBUG|R_ADMIN, "切换核弹", "Arm or disarm a nuke.", ADMIN_CATEGORY_EVENTS)
	var/list/nukes = list()
	for (var/obj/machinery/nuclearbomb/bomb in world)
		nukes += bomb
	var/obj/machinery/nuclearbomb/nuke = tgui_input_list(user, "", LANG("datum.dc37cb91", null), nukes)
	if (isnull(nuke))
		return
	if(!nuke.timing)
		var/newtime = tgui_input_number(user, LANG("datum.fe354fbd", null), LANG("datum.f03e09c8", null), nuke.timer_set)
		if(!newtime)
			return
		nuke.timer_set = newtime
	nuke.toggle_nuke_safety()
	nuke.toggle_nuke_armed()

	log_admin("[key_name(user)] [nuke.timing ? "activated" : "deactivated"] a nuke at [AREACOORD(nuke)].")
	message_admins("[ADMIN_LOOKUPFLW(user)] [nuke.timing ? "activated" : "deactivated"] a nuke at [ADMIN_VERBOSEJMP(nuke)].")
	SSblackbox.record_feedback("nested tally", "admin_toggle", 1, list("Toggle Nuke", "[nuke.timing]")) // If you are copy-pasting this, ensure the 4th parameter is unique to the new proc!

ADMIN_VERB(change_sec_level, R_ADMIN, "设置警戒等级", "Changes the security level. Announcement effects only.", ADMIN_CATEGORY_EVENTS)
	var/level = tgui_input_list(user, LANG("datum.2b07c557", null), LANG("datum.867fbc31", null), SSsecurity_level.available_levels)

	if(!level)
		return

	SSsecurity_level.set_level(level)

	log_admin("[key_name(user)] changed the security level to [level]")
	message_admins("[key_name_admin(user)] changed the security level to [level]")
	BLACKBOX_LOG_ADMIN_VERB("Set Security Level [capitalize(level)]")

ADMIN_VERB(command_report_footnote, R_ADMIN, "指挥部报告脚注", "Adds a footnote to the roundstart command report.", ADMIN_CATEGORY_EVENTS)
	var/datum/command_footnote/command_report_footnote = new /datum/command_footnote()
	GLOB.communications_controller.block_command_report += 1 //Add a blocking condition to the counter until the inputs are done.

	command_report_footnote.message = tgui_input_text(
		user,
		LANG("datum.0c3ef29f", null),
		LANG("datum.394670e9", null),
	)
	if(!command_report_footnote.message)
		GLOB.communications_controller.block_command_report -= 1
		qdel(command_report_footnote)
		return

	command_report_footnote.signature = tgui_input_text(
		user,
		LANG("datum.a004306f", null),
		LANG("datum.6221e12f", null),
	)

	if(!command_report_footnote.signature)
		command_report_footnote.signature = "Classified"

	GLOB.communications_controller.command_report_footnotes += command_report_footnote
	GLOB.communications_controller.block_command_report -= 1

	message_admins("[user] has added a footnote to the command report: [command_report_footnote.message], signed [command_report_footnote.signature]")

/datum/command_footnote
	var/message
	var/signature

ADMIN_VERB(command_report_content, R_FUN, "指挥部报告内容", "Sets the main content of the roundstart command report.", ADMIN_CATEGORY_EVENTS)
	GLOB.communications_controller.block_command_report += 1
	GLOB.communications_controller.command_report_main_content = tgui_input_text(
		user,
		LANG("datum.f7b6bce3", null),
		LANG("datum.57bd42d3", null),
	)
	GLOB.communications_controller.block_command_report -= 1
	message_admins("[key_name_admin(user)] has [GLOB.communications_controller.command_report_main_content ? "set" : "cleared"] the main content of the roundstart command report.")

ADMIN_VERB(delay_command_report, R_FUN, "延迟指挥部报告", "Prevents the roundstart command report from being sent; or forces it to send it delayed.", ADMIN_CATEGORY_EVENTS)
	GLOB.communications_controller.block_command_report = !GLOB.communications_controller.block_command_report
	message_admins("[key_name_admin(user)] has [(GLOB.communications_controller.block_command_report ? "delayed" : "sent")] the roundstart command report.")

///Reformats a narration message. First provides a prompt asking if the user wants to reformat their message, then allows them to pick from a list of spans to use.
/client/proc/reformat_narration(input)
	if(tgui_alert(mob, LANG("client.827ba886", null), LANG("client.7bdd69db", null), list("Yes", "No")) == "Yes")
		var/text_span = tgui_input_list(mob, LANG("client.ec1363e7", null), LANG("client.d6101a86", null), GLOB.spanname_to_formatting)
		if(isnull(text_span)) //In case the user just quit the prompt.
			return text_span
		text_span = GLOB.spanname_to_formatting[text_span]
		input = "<span class='[text_span]'>" + input + "</span>"

	return input
