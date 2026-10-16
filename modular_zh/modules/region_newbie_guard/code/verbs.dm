ADMIN_VERB(toggle_newbie_guard, R_SERVER, "切换新人软管制", "Toggle the region-based soft restriction on low-playtime players.", ADMIN_CATEGORY_SERVER)
	var/enabling = !CONFIG_GET(flag/newbie_guard)

	if(enabling)
		if(!newbie_guard_load_geoip(force = TRUE))
			to_chat(user, span_adminnotice(LANG("datum.2e4f80cade030fbd", list(GLOB.newbie_guard_geo_source, NEWBIE_GUARD_GEOIP_PATH))), confidential = TRUE)
			return

		var/playtime = input(user, LANG("datum.486b5cdaba0bb6b5", null), LANG("datum.fc23f26f45d55301", null), CONFIG_GET(number/newbie_guard_playtime)) as num|null
		if(isnull(playtime))
			return
		var/survival = input(user, LANG("datum.e096c1b67c305f21", null), LANG("datum.fc23f26f45d55301", null), CONFIG_GET(number/newbie_guard_survival)) as num|null
		if(isnull(survival))
			return

		CONFIG_SET(number/newbie_guard_playtime, max(round(playtime), 0))
		CONFIG_SET(number/newbie_guard_survival, max(round(survival), 1))

	CONFIG_SET(flag/newbie_guard, enabling)
	// The cached per-ckey verdicts were computed against the old threshold.
	GLOB.newbie_guard_verdict.Cut()

	if(!enabling)
		// Drop restrictions immediately, otherwise they outlive the switch, and give the
		// region table back to the allocator - it is by far the largest thing we hold.
		GLOB.newbie_guard.disable_all()
		newbie_guard_unload_geoip()
	else
		for(var/client/connected as anything in GLOB.clients)
			if(isliving(connected.mob))
				GLOB.newbie_guard.try_apply(connected.mob)

	log_admin("[key_name(user)] has toggled the newbie guard, it is now [enabling ? "on (playtime [CONFIG_GET(number/newbie_guard_playtime)]m, survival [CONFIG_GET(number/newbie_guard_survival)]m)" : "off"].")
	message_admins("[key_name_admin(user)] [enabling ? "启用" : "关闭"]了新人软管制[enabling ? "（时长门槛 [CONFIG_GET(number/newbie_guard_playtime)] 分钟，存活解除 [CONFIG_GET(number/newbie_guard_survival)] 分钟，地区表 [GLOB.newbie_guard_geo_source]）" : ""]。")

ADMIN_VERB(newbie_guard_panel, R_ADMIN, "新人软管制名单", "List and release players currently under the newbie guard.", ADMIN_CATEGORY_MAIN)
	var/required = CONFIG_GET(number/newbie_guard_survival)
	var/list/lines = list()
	lines += "<b>状态：</b>[CONFIG_GET(flag/newbie_guard) ? "已启用" : "已关闭"]"
	lines += "<b>时长门槛：</b>[CONFIG_GET(number/newbie_guard_playtime)] 分钟　<b>存活解除：</b>[required] 分钟"
	lines += "<b>地区数据表：</b>[GLOB.newbie_guard_geo_source]"
	lines += "<hr>"

	// Walking the active registry rather than GLOB.mob_living_list: the latter is thousands
	// of entries, almost all of them simple animals that can never hold this component.
	if(!length(GLOB.newbie_guard_active))
		lines += "<i>当前没有玩家处于管制状态。</i>"
	else
		for(var/datum/component/newbie_guard/guard as anything in GLOB.newbie_guard_active)
			var/mob/living/restricted = guard.parent
			if(QDELETED(restricted))
				continue
			var/approve_link = "<a href='byond://?src=[REF(GLOB.newbie_guard)];newbie_guard_approve=[restricted.ckey]'>永久豁免</a>"
			lines += "[key_name_admin(restricted)] — IP [restricted.client?.address] — 已存活 [guard.survived]/[required] 分钟 \[[approve_link]\]"

	lines += "<hr><b>永久豁免名单（[length(GLOB.newbie_guard_bypass)] 人）：</b>"
	for(var/exempt_ckey in GLOB.newbie_guard_bypass)
		var/revoke_link = "<a href='byond://?src=[REF(GLOB.newbie_guard)];newbie_guard_revoke=[exempt_ckey]'>撤销</a>"
		lines += "[exempt_ckey] \[[revoke_link]\]"

	var/datum/browser/panel = new(user.mob, "newbieguard", "新人软管制", 700, 500)
	panel.set_content(lines.Join("<br>"))
	panel.open()

ADMIN_VERB(newbie_guard_exempt, R_ADMIN, "豁免新人软管制", "Permanently exempt a ckey from the newbie guard.", ADMIN_CATEGORY_MAIN)
	var/target_ckey = ckey(input(user, LANG("datum.fad72d41b63c9639", null), LANG("datum.fc23f26f45d55301", null)) as text|null)
	if(!target_ckey)
		return

	GLOB.newbie_guard.release(target_ckey, "管理员已为你永久豁免。<br>An admin has exempted you permanently.", permanent = TRUE)
	log_admin("[key_name(user)] permanently exempted [target_ckey] from the newbie guard.")
	message_admins("[key_name_admin(user)] 永久豁免了 [target_ckey] 的新人软管制。")

ADMIN_VERB(newbie_guard_reload_geoip, R_SERVER, "重载地区数据表", "Reload the newbie guard GeoIP table from disk.", ADMIN_CATEGORY_SERVER)
	var/loaded = newbie_guard_load_geoip(force = TRUE)
	// Verdicts were decided against the previous table.
	GLOB.newbie_guard_verdict.Cut()
	to_chat(user, span_adminnotice(LANG("datum.8fbbdda63b80bde5", list(GLOB.newbie_guard_geo_source, loaded))), confidential = TRUE)
	log_admin("[key_name(user)] reloaded the newbie guard GeoIP table ([loaded] ranges).")
