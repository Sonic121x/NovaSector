/*
 * Newbie guard - the round-level bookkeeping.
 *
 * Restrictions are keyed on ckey rather than on the mob, so progress survives cloning,
 * body swaps and ghosting. The per-mob enforcement lives in component.dm.
 *
 * Two things here exist purely to keep the cost down:
 *   - a single shared survival timer drives every restricted player, instead of one looping
 *     timer per mob;
 *   - `newbie_guard_active` is an explicit registry of live components, so the admin panel
 *     and the kill switch never have to walk GLOB.mob_living_list (thousands of entries,
 *     nearly all of them simple animals).
 */

GLOBAL_DATUM_INIT(newbie_guard, /datum/newbie_guard, new)

/// ckey -> world.realtime of the admin approval. Persisted to disk.
GLOBAL_LIST_EMPTY(newbie_guard_bypass)
/// ckeys that finished their survival requirement (or were released) this round.
GLOBAL_LIST_EMPTY(newbie_guard_cleared)
/// ckey -> whole minutes survived while restricted this round.
GLOBAL_LIST_EMPTY(newbie_guard_progress)
/// ckey -> world.time the player last filed an appeal.
GLOBAL_LIST_EMPTY(newbie_guard_appeal_time)
/// ckey -> TRUE/FALSE, cached for the round. See [/datum/newbie_guard/proc/should_restrict].
GLOBAL_LIST_EMPTY(newbie_guard_verdict)
/// Every live /datum/component/newbie_guard.
GLOBAL_LIST_EMPTY(newbie_guard_active)

/datum/newbie_guard
	/// Set once the on-disk bypass list has been read.
	var/bypass_loaded = FALSE
	/// Handle of the shared survival timer, or null when nobody is restricted.
	var/survival_timer

/datum/newbie_guard/proc/load_bypass()
	if(bypass_loaded)
		return
	bypass_loaded = TRUE

	var/bypass_file = file(NEWBIE_GUARD_BYPASS_PATH)
	if(!fexists(bypass_file))
		return

	var/list/decoded
	try
		decoded = json_decode(file2text(bypass_file))
	catch
		log_world("newbie guard: [NEWBIE_GUARD_BYPASS_PATH] is not valid JSON, ignoring it.")
		return

	if(!islist(decoded) || !islist(decoded["data"]))
		return

	var/list/stored = decoded["data"]
	var/expiry_days = CONFIG_GET(number/newbie_guard_bypass_days)
	for(var/stored_ckey in stored)
		if(daysSince(stored[stored_ckey]) >= expiry_days)
			continue
		GLOB.newbie_guard_bypass[stored_ckey] = stored[stored_ckey]

/datum/newbie_guard/proc/save_bypass()
	var/bypass_file = file(NEWBIE_GUARD_BYPASS_PATH)
	var/list/payload = list("data" = GLOB.newbie_guard_bypass)
	fdel(bypass_file)
	WRITE_FILE(bypass_file, json_encode(payload))

/**
 * Decides whether `player` should be restricted right now.
 *
 * The verdict is cached per ckey for the round. Without the cache, every Login by a player
 * with no cached playtime records would fire another blocking `set_exp_from_db()` query -
 * and Login fires on cloning, body swaps and aghosting, not just on joining.
 *
 * Every exemption is checked before the region lookup so that a missing or broken GeoIP
 * table can only ever make the guard more permissive.
 */
/datum/newbie_guard/proc/should_restrict(client/player)
	if(!istype(player))
		return FALSE
	if(!CONFIG_GET(flag/newbie_guard))
		return FALSE
	if(player.holder || GLOB.deadmins[player.ckey])
		return FALSE

	load_bypass()
	if(GLOB.newbie_guard_bypass[player.ckey])
		return FALSE
	if(player.ckey in GLOB.newbie_guard_cleared)
		return FALSE

	var/cached = GLOB.newbie_guard_verdict[player.ckey]
	if(!isnull(cached))
		return cached

	var/verdict = TRUE

	// Career playtime. Mirrors SSipintel.is_exempt(): prefs.exp is often empty on a fresh
	// connection, so pull it from the database before trusting it.
	var/playtime_threshold = CONFIG_GET(number/newbie_guard_playtime)
	if(playtime_threshold > 0)
		var/list/play_records = player.prefs?.exp
		if(!length(play_records))
			player.set_exp_from_db()
			play_records = player.prefs?.exp
		if(length(play_records) && text2num(play_records[EXP_TYPE_LIVING]) >= playtime_threshold)
			verdict = FALSE

	if(verdict)
		verdict = !newbie_guard_address_in_region(player.address)

	GLOB.newbie_guard_verdict[player.ckey] = verdict
	return verdict

/// Applies the guard to a freshly logged-in mob, if its player qualifies.
/datum/newbie_guard/proc/try_apply(mob/living/target)
	if(!istype(target) || isnull(target.client))
		return FALSE
	if(!should_restrict(target.client))
		return FALSE
	if(target.GetComponent(/datum/component/newbie_guard))
		return FALSE

	target.AddComponent(/datum/component/newbie_guard)
	return TRUE

/datum/newbie_guard/proc/register_active(datum/component/newbie_guard/guard)
	GLOB.newbie_guard_active |= guard
	if(!survival_timer)
		survival_timer = addtimer(CALLBACK(src, PROC_REF(survival_tick)), NEWBIE_GUARD_TICK, TIMER_STOPPABLE | TIMER_LOOP)

/datum/newbie_guard/proc/unregister_active(datum/component/newbie_guard/guard)
	GLOB.newbie_guard_active -= guard
	if(!length(GLOB.newbie_guard_active) && survival_timer)
		deltimer(survival_timer)
		survival_timer = null

/// The one timer that drives every restricted player's survival counter.
/datum/newbie_guard/proc/survival_tick()
	var/list/finished
	for(var/datum/component/newbie_guard/guard as anything in GLOB.newbie_guard_active)
		if(guard.survival_tick())
			var/mob/living/owner = guard.parent
			LAZYADD(finished, owner.ckey)

	// Released outside the loop: release() destroys components, which mutates the registry.
	for(var/graduate_ckey as anything in finished)
		release(graduate_ckey, "你已在本回合存活足够长的时间，欢迎正式加入。<br>You have survived long enough this round. Welcome aboard.")

/**
 * Releases `target_ckey` for the rest of the round and tells them why.
 *
 * `permanent` also writes them into the on-disk bypass list, which is what an approved
 * appeal does; the survival timer only clears the current round.
 */
/datum/newbie_guard/proc/release(target_ckey, reason, permanent = FALSE)
	target_ckey = ckey(target_ckey)
	if(!target_ckey)
		return FALSE

	GLOB.newbie_guard_cleared |= target_ckey
	GLOB.newbie_guard_progress -= target_ckey

	if(permanent)
		load_bypass()
		GLOB.newbie_guard_bypass[target_ckey] = world.realtime
		save_bypass()

	var/client/target_client = GLOB.directory[target_ckey]
	var/mob/living/target_mob = target_client?.mob
	if(istype(target_mob))
		qdel(target_mob.GetComponent(/datum/component/newbie_guard))

	if(target_client)
		to_chat(
			target_client,
			span_greenannounce("【新人软管制 / New Player Safeguard】限制已解除。Restrictions lifted.<br>[reason]"),
			type = MESSAGE_TYPE_ADMINPM,
			skip_i18n_fallback = TRUE,
		)
	return TRUE

/**
 * Drops every active restriction without marking anybody as cleared.
 *
 * Used when an admin switches the guard off: `release()` would write the ckeys into
 * `newbie_guard_cleared`, so switching it back on again would silently skip everyone who
 * happened to be restricted at the moment it was switched off.
 */
/datum/newbie_guard/proc/disable_all()
	for(var/datum/component/newbie_guard/guard as anything in GLOB.newbie_guard_active.Copy())
		var/mob/living/owner = guard.parent
		qdel(guard)
		if(owner?.client)
			to_chat(
				owner,
				span_greenannounce("【新人软管制 / New Player Safeguard】管理员已关闭该功能，限制解除。<br>An admin disabled this feature; your restrictions are lifted."),
				type = MESSAGE_TYPE_ADMINPM,
				skip_i18n_fallback = TRUE,
			)

/datum/newbie_guard/Topic(href, list/href_list)
	..()

	if(href_list["newbie_guard_appeal"])
		handle_appeal(usr)
		return

	if(href_list["newbie_guard_approve"])
		if(!check_rights(R_ADMIN))
			return
		var/target_ckey = ckey(href_list["newbie_guard_approve"])
		if(!target_ckey)
			return
		release(target_ckey, "管理员已批准你的申诉。<br>An admin approved your appeal.", permanent = TRUE)
		log_admin("[key_name(usr)] approved the newbie guard appeal of [target_ckey].")
		message_admins("[key_name_admin(usr)] 批准了 [target_ckey] 的新人软管制申诉。")
		return

	if(href_list["newbie_guard_revoke"])
		if(!check_rights(R_ADMIN))
			return
		var/target_ckey = ckey(href_list["newbie_guard_revoke"])
		if(!target_ckey)
			return
		load_bypass()
		GLOB.newbie_guard_bypass -= target_ckey
		save_bypass()
		log_admin("[key_name(usr)] revoked the newbie guard exemption of [target_ckey].")
		message_admins("[key_name_admin(usr)] 撤销了 [target_ckey] 的新人软管制永久豁免。")
		return

	if(href_list["newbie_guard_deny"])
		if(!check_rights(R_ADMIN))
			return
		var/target_ckey = ckey(href_list["newbie_guard_deny"])
		if(!target_ckey)
			return
		var/client/target_client = GLOB.directory[target_ckey]
		if(target_client)
			to_chat(
				target_client,
				span_warning("【新人软管制 / New Player Safeguard】管理员驳回了你的申诉。你仍然可以通过存活来自动解除限制。<br>An admin declined your appeal. Staying alive still lifts the limits automatically."),
				type = MESSAGE_TYPE_ADMINPM,
				skip_i18n_fallback = TRUE,
			)
		log_admin("[key_name(usr)] denied the newbie guard appeal of [target_ckey].")
		message_admins("[key_name_admin(usr)] 驳回了 [target_ckey] 的新人软管制申诉。")
		return

/// Handles a player clicking the appeal link in their restriction notice.
/datum/newbie_guard/proc/handle_appeal(mob/appealing_mob)
	var/client/appealing = appealing_mob?.client
	if(!appealing)
		return

	var/mob/living/appealing_living = appealing.mob
	if(!istype(appealing_living) || !appealing_living.GetComponent(/datum/component/newbie_guard))
		to_chat(appealing, span_warning("你当前没有受到新人软管制，无需申诉。<br>You are not under the newbie safeguard; there is nothing to appeal."), type = MESSAGE_TYPE_ADMINPM, skip_i18n_fallback = TRUE)
		return

	var/last_appeal = GLOB.newbie_guard_appeal_time[appealing.ckey]
	if(last_appeal && (world.time - last_appeal) < NEWBIE_GUARD_APPEAL_COOLDOWN)
		var/wait_seconds = round((NEWBIE_GUARD_APPEAL_COOLDOWN - (world.time - last_appeal)) / 10)
		to_chat(appealing, span_warning("你刚刚已经提交过申诉，请等待 [wait_seconds] 秒后再试。<br>You just filed an appeal; try again in [wait_seconds] seconds."), type = MESSAGE_TYPE_ADMINPM, skip_i18n_fallback = TRUE)
		return

	GLOB.newbie_guard_appeal_time[appealing.ckey] = world.time

	var/approve_link = "<a href='byond://?src=[REF(src)];newbie_guard_approve=[appealing.ckey]'>批准</a>"
	var/deny_link = "<a href='byond://?src=[REF(src)];newbie_guard_deny=[appealing.ckey]'>驳回</a>"
	message_admins("【新人软管制申诉】[key_name_admin(appealing)]（IP [appealing.address]）请求解除限制。 \[[approve_link]\] \[[deny_link]\]")
	log_admin("[key_name(appealing)] filed a newbie guard appeal.")
	to_chat(appealing, span_notice("【新人软管制 / New Player Safeguard】申诉已提交，请等待管理员处理。<br>Your appeal has been sent; please wait for an admin."), type = MESSAGE_TYPE_ADMINPM, skip_i18n_fallback = TRUE)

/// Called from /mob/living/Login().
/proc/newbie_guard_on_login(mob/living/target)
	// Cheapest possible early-out: this runs on every living Login in the round, and on a
	// normal shift the feature is switched off.
	if(!CONFIG_GET(flag/newbie_guard))
		return
	GLOB.newbie_guard.try_apply(target)
