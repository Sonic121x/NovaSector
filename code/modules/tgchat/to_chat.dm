/*!
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */

/**
 * Circumvents the message queue and sends the message
 * to the recipient (target) as soon as possible.
 */
/proc/to_chat_immediate(
	target,
	html,
	type = null,
	text = null,
	avoid_highlighting = FALSE,
	// FIXME: These flags are now pointless and have no effect
	handle_whitespace = TRUE,
	trailing_newline = TRUE,
	confidential = FALSE,
	skip_i18n_fallback = FALSE // NOVA EDIT ADDITION - i18n - lets a caller opt a player-authored message (e.g. heard speech) out of the chat AC fallback so the player's own words aren't auto-translated
)
	// Useful where the integer 0 is the entire message. Use case is enabling to_chat(target, some_boolean) while preventing to_chat(target, "")
	html = "[html]"
	text = "[text]"

	if(!target)
		return
	if(!html && !text)
		CRASH("Empty or null string in to_chat proc call.")
	if(target == world)
		target = GLOB.clients

	// NOVA EDIT ADDITION START - i18n - 聊天层 AC 子串兜底（默认关，config I18N_CHAT_FALLBACK 开；英文服/未开启 no-op）。跳过玩家/管理员自己输入的频道（按类型）与显式 skip_i18n_fallback（玩家发言），避免误翻玩家原话。
	if(GLOB.i18n_chat_fallback && GLOB.i18n_server_locale != DEFAULT_UI_LOCALE && !skip_i18n_fallback && !GLOB.i18n_player_chat_types[type])
		if(html) html = lang_fallback_apply_html(html)
		if(text) text = lang_fallback_apply(text)
	// NOVA EDIT ADDITION END

	// Build a message
	var/message = list()
	if(type) message["type"] = type
	if(text) message["text"] = text
	if(html) message["html"] = html
	if(avoid_highlighting) message["avoidHighlighting"] = avoid_highlighting

	// send it immediately
	SSchat.send_immediate(target, message)

/**
 * Sends the message to the recipient (target).
 *
 * Recommended way to write to_chat calls:
 * ```
 * to_chat(client,
 *     type = MESSAGE_TYPE_INFO,
 *     html = "You have found <strong>[object]</strong>")
 * ```
 */
/proc/to_chat(
	target,
	html,
	type = null,
	text = null,
	avoid_highlighting = FALSE,
	// FIXME: These flags are now pointless and have no effect
	handle_whitespace = TRUE,
	trailing_newline = TRUE,
	confidential = FALSE,
	skip_i18n_fallback = FALSE // NOVA EDIT ADDITION - i18n - see to_chat_immediate
)
	if(isnull(Master) || !SSchat?.initialized || !MC_RUNNING(SSchat.init_stage))
		to_chat_immediate(target, html, type, text, avoid_highlighting, skip_i18n_fallback = skip_i18n_fallback) // NOVA EDIT - i18n - thread skip_i18n_fallback
		return

	// Useful where the integer 0 is the entire message. Use case is enabling to_chat(target, some_boolean) while preventing to_chat(target, "")
	html = "[html]"
	text = "[text]"

	if(!target)
		return
	if(!html && !text)
		CRASH("Empty or null string in to_chat proc call.")
	if(target == world)
		target = GLOB.clients

	// NOVA EDIT ADDITION START - i18n - 聊天层 AC 子串兜底（默认关，config I18N_CHAT_FALLBACK 开；英文服/未开启 no-op）。跳过玩家/管理员自己输入的频道（按类型）与显式 skip_i18n_fallback（玩家发言），避免误翻玩家原话。
	if(GLOB.i18n_chat_fallback && GLOB.i18n_server_locale != DEFAULT_UI_LOCALE && !skip_i18n_fallback && !GLOB.i18n_player_chat_types[type])
		if(html) html = lang_fallback_apply_html(html)
		if(text) text = lang_fallback_apply(text)
	// NOVA EDIT ADDITION END

	// Build a message
	var/message = list()
	if(type) message["type"] = type
	if(text) message["text"] = text
	if(html) message["html"] = html
	if(avoid_highlighting) message["avoidHighlighting"] = avoid_highlighting
	SSchat.queue(target, message)
