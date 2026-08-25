/*
 * Newbie guard - per-mob enforcement.
 *
 * Everything hangs off COMSIG_MOB_CLICKON (code/_onclick/click.dm), which fires before
 * tool_act, attack chains and machinery interaction alike. Hooking anything further down
 * would miss tool deconstruction, because base_item_interaction() runs tool_act() *before*
 * it sends any user-side signal.
 *
 * That signal fires on *every* click a restricted player makes, so get_refusal() is written
 * to be cheap: plain istype() checks (a native type comparison, and unlike a typecache it
 * costs no memory) ordered so the overwhelmingly common "clicked a floor / a mob / an item"
 * case exits after one or two comparisons. Type caches were deliberately avoided here -
 * typecacheof(/obj/machinery/atmospherics) alone would have interned ~900 paths.
 */

/datum/component/newbie_guard
	/// Whole minutes the owner has survived while restricted, mirrored into GLOB per ckey.
	var/survived = 0
	/// Throttles the refusal message so spam-clicking does not flood chat.
	var/next_refusal_message = 0

/datum/component/newbie_guard/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/newbie_guard/RegisterWithParent()
	var/mob/living/owner = parent
	ADD_TRAIT(owner, TRAIT_PACIFISM, NEWBIE_GUARD_TRAIT)
	RegisterSignal(owner, COMSIG_MOB_CLICKON, PROC_REF(on_clickon))

	survived = GLOB.newbie_guard_progress[owner.ckey] || 0
	GLOB.newbie_guard.register_active(src)

	announce_to(owner)

/datum/component/newbie_guard/UnregisterFromParent()
	var/mob/living/owner = parent
	REMOVE_TRAIT(owner, TRAIT_PACIFISM, NEWBIE_GUARD_TRAIT)
	UnregisterSignal(owner, COMSIG_MOB_CLICKON)
	GLOB.newbie_guard.unregister_active(src)

/// Tells the player, privately and in both languages, what is happening and what to do about it.
/datum/component/newbie_guard/proc/announce_to(mob/living/owner)
	var/required = CONFIG_GET(number/newbie_guard_survival)
	var/remaining = max(required - survived, 0)
	var/playtime = CONFIG_GET(number/newbie_guard_playtime)
	var/appeal_link = "<a href='byond://?src=[REF(GLOB.newbie_guard)];newbie_guard_appeal=1'>提交申诉 / File an appeal</a>"

	// One boxed message rather than a dozen to_chat calls: at round start the chat is a wall
	// of text, and a notice the player must actually read cannot afford to be scattered
	// through it. skip_i18n_fallback keeps the chat AC layer away from the English half,
	// which it would otherwise happily translate into Chinese.
	var/list/lines = list(
		span_boldannounce("【新人软管制 / New Player Safeguard】"),
		span_warning("你的账号游戏时长不足 [playtime] 分钟，且连接来源不在本服的常规地区名单内，因此本回合暂时受到以下限制："),
		span_warning("Your account has under [playtime] minutes of playtime and connects from outside this server's usual region, so the following limits apply for this round:"),
		"<br>",
		span_notice("· 无法主动攻击他人 / You cannot attack others"),
		span_notice("· 无法用扳手、螺丝刀、剪线钳、焊枪、万用表拆解设备与结构 / You cannot deconstruct machines or structures with a wrench, screwdriver, wirecutter, welder or multitool"),
		span_notice("· 无法操作火警、空气警报、大气管道、气罐、APC、电缆、按钮等设施 / You cannot operate fire alarms, air alarms, atmospherics, canisters, APCs, cables or buttons"),
		span_notice("· 无法使用手雷、气罐炸弹、RCD、RPD 等爆破与快速施工道具 / You cannot use grenades, tank bombs, RCDs or RPDs"),
		"<br>",
		span_notice("检查（Shift 点击）、对话、移动、开门、使用电脑与工作台都不受影响。"),
		span_notice("Examining (shift-click), talking, moving, opening doors and using computers are all unaffected."),
		"<br>",
		span_greenannounce("在本回合存活满 [remaining] 分钟后，限制会自动全部解除。"),
		span_greenannounce("Stay alive for [remaining] more minutes this round and every limit lifts automatically."),
		"<br>",
		span_notice("如果你认为这是误判（例如你在使用代理、或身在境外但并非新玩家），[appeal_link]，管理员批准后将永久豁免。"),
		span_notice("If this is a mistake (you use a proxy, or you play from abroad but are not a new player), [appeal_link] and an admin can exempt you permanently."),
	)

	to_chat(
		owner,
		boxed_message(lines.Join("<br>")),
		type = MESSAGE_TYPE_ADMINPM,
		skip_i18n_fallback = TRUE,
	)

/// Called once a minute by the controller's shared timer. Returns TRUE once the requirement is met.
/datum/component/newbie_guard/proc/survival_tick()
	var/mob/living/owner = parent
	if(QDELETED(owner) || isnull(owner.client) || owner.stat == DEAD)
		return FALSE

	survived++
	GLOB.newbie_guard_progress[owner.ckey] = survived

	var/required = CONFIG_GET(number/newbie_guard_survival)
	if(survived >= required)
		return TRUE

	// One nudge at the halfway mark so the player knows the timer is real and running.
	if(survived == round(required / 2))
		to_chat(
			owner,
			span_greenannounce(LANG("datum.8e945017b1286386", list(required - survived, required - survived))),
			type = MESSAGE_TYPE_ADMINPM,
			skip_i18n_fallback = TRUE,
		)
	return FALSE

/datum/component/newbie_guard/proc/on_clickon(mob/living/source, atom/target, list/modifiers)
	SIGNAL_HANDLER

	// Examining and pointing must keep working - a restricted player is by definition someone
	// who needs to read the world more than anyone else.
	if(LAZYACCESS(modifiers, SHIFT_CLICK) || LAZYACCESS(modifiers, MIDDLE_CLICK))
		return

	var/obj/item/held = source.get_active_held_item()
	var/refusal = get_refusal(target, held)
	if(!refusal)
		return

	if(world.time >= next_refusal_message)
		next_refusal_message = world.time + NEWBIE_GUARD_REFUSAL_COOLDOWN
		show_refusal(source, refusal, target, held)
	return COMSIG_MOB_CANCEL_CLICKON

/**
 * Returns a NEWBIE_GUARD_REFUSE_* code, or NEWBIE_GUARD_REFUSE_NONE to let the click through.
 *
 * Hot path. Ordered cheapest-first and formats nothing; see the file header.
 */
/datum/component/newbie_guard/proc/get_refusal(atom/target, obj/item/held)
	if(isnull(target))
		return NEWBIE_GUARD_REFUSE_NONE

	var/tool_behaviour = held?.tool_behaviour
	var/deconstructing = tool_behaviour && (tool_behaviour == TOOL_WRENCH \
		|| tool_behaviour == TOOL_SCREWDRIVER \
		|| tool_behaviour == TOOL_WIRECUTTER \
		|| tool_behaviour == TOOL_WELDER \
		|| tool_behaviour == TOOL_MULTITOOL)
	// Crowbar is deliberately absent above: prying a door open is how a trapped newbie
	// saves their own life.

	if(held)
		if(istype(held, /obj/item/grenade) \
			|| istype(held, /obj/item/transfer_valve) \
			|| istype(held, /obj/item/construction/rcd) \
			|| istype(held, /obj/item/pipe_dispenser))
			return NEWBIE_GUARD_REFUSE_ITEM

	// Almost every guarded target is machinery, so one check filters out the common cases
	// (floors, mobs, items, walls) before any of the narrow comparisons run.
	if(ismachinery(target))
		if(istype(target, /obj/machinery/atmospherics) \
			|| istype(target, /obj/machinery/airalarm) \
			|| istype(target, /obj/machinery/firealarm) \
			|| istype(target, /obj/machinery/button) \
			|| istype(target, /obj/machinery/light_switch) \
			|| istype(target, /obj/machinery/flasher) \
			|| istype(target, /obj/machinery/nuclearbomb) \
			|| istype(target, /obj/machinery/portable_atmospherics/canister) \
			|| istype(target, /obj/machinery/power/apc) \
			|| istype(target, /obj/machinery/power/terminal) \
			|| istype(target, /obj/machinery/power/emitter) \
			|| istype(target, /obj/machinery/power/supermatter_crystal) \
			|| istype(target, /obj/machinery/gravity_generator) \
			|| istype(target, /obj/machinery/computer/atmos_control) \
			|| istype(target, /obj/machinery/computer/communications))
			return NEWBIE_GUARD_REFUSE_TARGET
		return deconstructing ? NEWBIE_GUARD_REFUSE_TOOL : NEWBIE_GUARD_REFUSE_NONE

	if(istype(target, /obj/structure/cable) || istype(target, /obj/item/disk/nuclear))
		return NEWBIE_GUARD_REFUSE_TARGET

	if(deconstructing)
		if(istype(target, /obj/structure/grille) || istype(target, /obj/structure/window) || iswallturf(target))
			return NEWBIE_GUARD_REFUSE_TOOL

	return NEWBIE_GUARD_REFUSE_NONE

/// Formats and sends the refusal. Only ever reached once per NEWBIE_GUARD_REFUSAL_COOLDOWN.
/datum/component/newbie_guard/proc/show_refusal(mob/living/source, refusal, atom/target, obj/item/held)
	var/reason
	switch(refusal)
		if(NEWBIE_GUARD_REFUSE_ITEM)
			reason = "你目前无法使用 [held.name]。<br>You cannot use the [held.name] right now."
		if(NEWBIE_GUARD_REFUSE_TOOL)
			reason = "你目前无法用 [held.name] 拆解 [target.name]。<br>You cannot deconstruct the [target.name] right now."
		else
			reason = "你目前无法操作 [target.name]。<br>You cannot operate the [target.name] right now."

	var/appeal_link = "<a href='byond://?src=[REF(GLOB.newbie_guard)];newbie_guard_appeal=1'>提交申诉 / appeal</a>"
	to_chat(
		source,
		span_warning(LANG("datum.2b22349ca5d431d9", list(reason, CONFIG_GET(number/newbie_guard_survival), appeal_link, CONFIG_GET(number/newbie_guard_survival), appeal_link))),
		type = MESSAGE_TYPE_ADMINPM,
		skip_i18n_fallback = TRUE,
	)
