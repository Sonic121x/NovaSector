#define DEFAULT_DOOMSDAY_TIMER 4500
#define DOOMSDAY_ANNOUNCE_INTERVAL 600

#define VENDOR_TIPPING_USES 8
#define MALF_VENDOR_TIPPING_TIME 0.5 SECONDS //within human reaction time
#define MALF_VENDOR_TIPPING_CRIT_CHANCE 100 //percent - guaranteed

#define MALF_AI_ROLL_TIME 0.5 SECONDS
#define MALF_AI_ROLL_COOLDOWN 1 SECONDS + MALF_AI_ROLL_TIME
#define MALF_AI_ROLL_DAMAGE 75
#define MALF_AI_ROLL_CRIT_CHANCE 5 //percent

GLOBAL_LIST_INIT(blacklisted_malf_machines, typecacheof(list(
		/obj/machinery/field/containment,
		/obj/machinery/power/supermatter_crystal,
		/obj/machinery/gravity_generator,
		/obj/machinery/doomsday_device,
		/obj/machinery/nuclearbomb,
		/obj/machinery/nuclearbomb/selfdestruct,
		/obj/machinery/nuclearbomb/syndicate,
		/obj/machinery/syndicatebomb,
		/obj/machinery/syndicatebomb/badmin,
		/obj/machinery/syndicatebomb/badmin/clown,
		/obj/machinery/syndicatebomb/empty,
		/obj/machinery/syndicatebomb/self_destruct,
		/obj/machinery/syndicatebomb/training,
		/obj/machinery/atmospherics/pipe/layer_manifold,
		/obj/machinery/atmospherics/pipe/multiz,
		/obj/machinery/atmospherics/pipe/smart,
		/obj/machinery/atmospherics/pipe/smart/manifold, //mapped one
		/obj/machinery/atmospherics/pipe/smart/manifold4w, //mapped one
		/obj/machinery/atmospherics/pipe/color_adapter,
		/obj/machinery/atmospherics/pipe/bridge_pipe,
		/obj/machinery/atmospherics/pipe/heat_exchanging/simple,
		/obj/machinery/atmospherics/pipe/heat_exchanging/junction,
		/obj/machinery/atmospherics/pipe/heat_exchanging/manifold,
		/obj/machinery/atmospherics/pipe/heat_exchanging/manifold4w,
		/obj/machinery/atmospherics/components/tank,
		/obj/machinery/atmospherics/components/unary/portables_connector,
		/obj/machinery/atmospherics/components/unary/passive_vent,
		/obj/machinery/atmospherics/components/unary/heat_exchanger,
		/obj/machinery/atmospherics/components/unary/hypertorus/core,
		/obj/machinery/atmospherics/components/unary/hypertorus/waste_output,
		/obj/machinery/atmospherics/components/unary/hypertorus/moderator_input,
		/obj/machinery/atmospherics/components/unary/hypertorus/fuel_input,
		/obj/machinery/hypertorus/interface,
		/obj/machinery/hypertorus/corner,
		/obj/machinery/atmospherics/components/binary/valve,
		/obj/machinery/portable_atmospherics/canister,
		/obj/machinery/computer/shuttle,
		/obj/machinery/computer/emergency_shuttle,
		/obj/machinery/computer/gateway_control,
	)))

GLOBAL_LIST_INIT(malf_modules, subtypesof(/datum/ai_module/malf))

/// The malf AI action subtype. All malf actions are subtypes of this.
/datum/action/innate/ai
	name = "AI行动"
	desc = "你不太确定这具体有什么用，但它会发出很多哔哔嘟嘟的声音。"
	background_icon_state = "bg_tech_blue"
	overlay_icon_state = "bg_tech_blue_border"
	button_icon = 'icons/mob/actions/actions_AI.dmi'
	/// The owner AI, so we don't have to typecast every time
	var/mob/living/silicon/ai/owner_AI
	/// Amount of uses for this action. Defining this as 0 will make this infinite-use
	var/uses = FALSE
	/// If we automatically use up uses on each activation
	var/auto_use_uses = TRUE
	/// If applicable, the time in deciseconds we have to wait before using any more modules
	var/cooldown_period = 0 SECONDS

/datum/action/innate/ai/Grant(mob/living/player)
	. = ..()
	if(!isAI(owner))
		WARNING("AI action [name] attempted to grant itself to non-AI mob [key_name(player)]!")
		qdel(src)
	else
		owner_AI = owner

/datum/action/innate/ai/IsAvailable(feedback = FALSE)
	if(owner_AI && !COOLDOWN_FINISHED(owner_AI, malf_cooldown))
		return FALSE
	. = ..()

/datum/action/innate/ai/Trigger(mob/clicker, trigger_flags)
	. = ..()
	if(!.)
		return
	if(auto_use_uses)
		adjust_uses(-1)
	if(cooldown_period)
		COOLDOWN_START(owner_AI, malf_cooldown, cooldown_period)

/datum/action/innate/ai/proc/adjust_uses(amt, silent)
	uses += amt
	if(!silent && uses)
		to_chat(owner, span_notice("[name] 现在还有 <b>[uses]</b> 次使用[uses > 1 ? "s" : ""]剩余。"))
	if(uses <= 0)
		if(initial(uses) > 1) //no need to tell 'em if it was one-use anyway!
			to_chat(owner, span_warning("[name] 已耗尽使用次数！"))
		qdel(src)

/// Framework for ranged abilities that can have different effects by left-clicking stuff.
/datum/action/innate/ai/ranged
	name = "远程AI行动"
	auto_use_uses = FALSE //This is so we can do the thing and disable/enable freely without having to constantly add uses
	click_action = TRUE

/datum/action/innate/ai/ranged/adjust_uses(amt, silent)
	uses += amt
	if(!silent && uses)
		to_chat(owner, span_notice("[name] 现在还有 <b>[uses]</b> 次使用\s 剩余。"))
	if(!uses)
		if(initial(uses) > 1) //no need to tell 'em if it was one-use anyway!
			to_chat(owner, span_warning("[name] 已耗尽使用次数！"))
		Remove(owner)
		QDEL_IN(src, 10 SECONDS) //let any active timers on us finish up

/// The base module type, which holds info about each ability.
/datum/ai_module
	var/name = "通用模块"
	var/category = "generic category"
	var/description = "通用描述"
	var/cost = 5
	/// Minimum amount of APCs that has to be under the AI's control to purchase this module.
	var/minimum_apcs = 0
	/// If this module can only be purchased once. This always applies to upgrades, even if the variable is set to false.
	var/one_purchase = FALSE
	/// If the module gives an active ability, use this. Mutually exclusive with upgrade.
	var/power_type = /datum/action/innate/ai
	/// If the module gives a passive upgrade, use this. Mutually exclusive with power_type.
	var/upgrade = FALSE
	/// Text shown when an ability is unlocked
	var/unlock_text = span_notice("你好，世界！")
	/// Sound played when an ability is unlocked
	var/unlock_sound

/// Applies upgrades
/datum/ai_module/proc/upgrade(mob/living/silicon/ai/AI)
	return

/// Modules causing destruction
/datum/ai_module/malf/destructive
	category = "Destructive Modules"

/// Modules with stealthy and utility uses
/datum/ai_module/malf/utility
	category = "Utility Modules"

/// Modules that are improving AI abilities and assets
/datum/ai_module/malf/upgrade
	category = "Upgrade Modules"

/// Doomsday Device: Starts the self-destruct timer. It can only be stopped by killing the AI completely.
/datum/ai_module/malf/destructive/nuke_station
	name = "末日装置"
	description = "Activate a weapon that will disintegrate all organic life on the station after a 450 second delay. \
		Can only be used while on the station, will fail if your core is moved off station or destroyed. \
		Obtaining control of the weapon will be easier if Head of Staff office APCs are already under your control."
	cost = 130
	one_purchase = TRUE
	minimum_apcs = 10 // So you cant speedrun delta
	power_type = /datum/action/innate/ai/nuke_station
	unlock_text = span_notice("你缓慢而谨慎地与空间站自毁系统建立了连接。你现在可以随时激活它。")
	///List of areas that grant discounts. "heads_quarters" will match any head of staff office.
	var/list/discount_areas = list(
		/area/station/command/heads_quarters,
		/area/station/command/vault
	)
	///List of hacked head of staff office areas. Includes the vault too. Provides a 20 PT discount per (Min 50 PT cost)
	var/list/hacked_command_areas = list()

/datum/action/innate/ai/nuke_station
	name = "末日装置"
	desc = "激活末日装置。此操作不可逆。"
	button_icon = 'icons/obj/machines/nuke_terminal.dmi'
	button_icon_state = "nuclearbomb_timing"
	auto_use_uses = FALSE

/datum/action/innate/ai/nuke_station/Activate()
	var/turf/T = get_turf(owner)
	if(!istype(T) || !is_station_level(T.z))
		to_chat(owner, span_warning("你无法在空间站外激活末日装置！"))
		return
	if(tgui_alert(owner, "发送激活信号？（true = 激活，false = 取消）", "purge_all_life()", list("confirm = TRUE;", "confirm = FALSE;")) != "confirm = TRUE;")
		return
	if (active || owner_AI.stat == DEAD)
		return //prevent the AI from activating an already active doomsday or while they are dead
	if (!isturf(owner_AI.loc))
		return //prevent AI from activating doomsday while shunted or carded, fucking abusers
	active = TRUE
	set_up_us_the_bomb(owner)

/datum/action/innate/ai/nuke_station/proc/set_up_us_the_bomb(mob/living/owner)
	//oh my GOD.
	set waitfor = FALSE
	message_admins("[key_name_admin(owner)][ADMIN_FLW(owner)] has activated AI Doomsday.")
	var/pass = prob(10) ? "******" : "hunter2"
	to_chat(owner, "<span class='small bolddanger'>run -o -a 'selfdestruct'</span>")
	sleep(0.5 SECONDS)
	if(QDELETED(owner) || !isturf(owner_AI.loc))
		active = FALSE
		return
	to_chat(owner, "<span class='small bolddanger'>Running executable 'selfdestruct'...</span>")
	sleep(rand(10, 30))
	if(QDELETED(owner) || !isturf(owner_AI.loc))
		active = FALSE
		return
	owner.playsound_local(owner, 'sound/announcer/alarm/bloblarm.ogg', 50, 0, use_reverb = FALSE)
	to_chat(owner, span_userdanger("！！！未经授权的自毁访问！！！"))
	to_chat(owner, span_bolddanger("这是一起3级安全违规事件。此事件将被报告给中央指挥部。"))
	for(var/i in 1 to 3)
		sleep(2 SECONDS)
		if(QDELETED(owner) || !isturf(owner_AI.loc))
			active = FALSE
			return
		to_chat(owner, span_bolddanger("正在向中央指挥部发送安全报告.....[rand(0, 9) + (rand(20, 30) * i)]%"))
	sleep(0.3 SECONDS)
	if(QDELETED(owner) || !isturf(owner_AI.loc))
		active = FALSE
		return
	to_chat(owner, "<span class='small bolddanger'>auth 'akjv9c88asdf12nb' [pass]</span>")
	owner.playsound_local(owner, 'sound/items/timer.ogg', 50, 0, use_reverb = FALSE)
	sleep(3 SECONDS)
	if(QDELETED(owner) || !isturf(owner_AI.loc))
		active = FALSE
		return
	to_chat(owner, span_boldnotice("凭证已接受。欢迎，akjv9c88asdf12nb。"))
	owner.playsound_local(owner, 'sound/misc/server-ready.ogg', 50, 0, use_reverb = FALSE)
	sleep(0.5 SECONDS)
	if(QDELETED(owner) || !isturf(owner_AI.loc))
		active = FALSE
		return
	to_chat(owner, span_boldnotice("激活自毁装置？(Y/N)"))
	owner.playsound_local(owner, 'sound/machines/compiler/compiler-stage1.ogg', 50, 0, use_reverb = FALSE)
	sleep(2 SECONDS)
	if(QDELETED(owner) || !isturf(owner_AI.loc))
		active = FALSE
		return
	to_chat(owner, "<span class='small bolddanger'>Y</span>")
	sleep(1.5 SECONDS)
	if(QDELETED(owner) || !isturf(owner_AI.loc))
		active = FALSE
		return
	to_chat(owner, span_boldnotice("确认激活自毁装置？(Y/N)"))
	owner.playsound_local(owner, 'sound/machines/compiler/compiler-stage2.ogg', 50, 0, use_reverb = FALSE)
	sleep(1 SECONDS)
	if(QDELETED(owner) || !isturf(owner_AI.loc))
		active = FALSE
		return
	to_chat(owner, "<span class='small bolddanger'>Y</span>")
	sleep(rand(15, 25))
	if(QDELETED(owner) || !isturf(owner_AI.loc))
		active = FALSE
		return
	to_chat(owner, span_boldnotice("请重复密码以确认。"))
	owner.playsound_local(owner, 'sound/machines/compiler/compiler-stage2.ogg', 50, 0, use_reverb = FALSE)
	sleep(1.4 SECONDS)
	if(QDELETED(owner) || !isturf(owner_AI.loc))
		active = FALSE
		return
	to_chat(owner, "<span class='small bolddanger'>[pass]</span>")
	sleep(4 SECONDS)
	if(QDELETED(owner) || !isturf(owner_AI.loc))
		active = FALSE
		return
	to_chat(owner, span_boldnotice("凭证已接受。正在传输激活信号..."))
	owner.playsound_local(owner, 'sound/misc/server-ready.ogg', 50, 0, use_reverb = FALSE)
	sleep(3 SECONDS)
	if(QDELETED(owner) || !isturf(owner_AI.loc))
		active = FALSE
		return
	if (owner_AI.stat != DEAD)
		priority_announce("在所有空间站系统中检测到敌对运行时，请停用你的 AI 以防止其道德核心可能受损。", "异常警报", ANNOUNCER_AIMALF)
		SSsecurity_level.set_level(SEC_LEVEL_DELTA)
		var/obj/machinery/doomsday_device/DOOM = new(owner_AI)
		owner_AI.nuking = TRUE
		owner_AI.doomsday_device = DOOM
		owner_AI.doomsday_device.start()
		for(var/obj/item/pinpointer/nuke/P in GLOB.pinpointer_list)
			P.switch_mode_to(TRACK_MALF_AI) //Pinpointers start tracking the AI wherever it goes

		notify_ghosts(
			"[owner_AI] has activated a Doomsday Device!",
			source = owner_AI,
			header = "DOOOOOOM!!!",
		)

		qdel(src)

/obj/machinery/doomsday_device
	icon = 'icons/obj/machines/nuke_terminal.dmi'
	name = "末日装置"
	icon_state = "nuclearbomb_base"
	desc = "一种能在广阔区域内分解所有有机生命的武器。"
	density = TRUE
	verb_exclaim = "鸣响"
	use_power = NO_POWER_USE
	var/timing = FALSE
	var/obj/effect/countdown/doomsday/countdown
	var/detonation_timer
	var/next_announce
	var/mob/living/silicon/ai/owner

/obj/machinery/doomsday_device/Initialize(mapload)
	. = ..()
	if(!isAI(loc))
		stack_trace("Doomsday created outside an AI somehow, shit's fucking broke. Anyway, we're just gonna qdel now. Go make a github issue report.")
		return INITIALIZE_HINT_QDEL
	owner = loc
	countdown = new(src)

/obj/machinery/doomsday_device/Destroy()
	timing = FALSE
	QDEL_NULL(countdown)
	STOP_PROCESSING(SSfastprocess, src)
	SSshuttle.clearHostileEnvironment(src)
	SSmapping.remove_nuke_threat(src)
	SSsecurity_level.set_level(SEC_LEVEL_RED)
	for(var/mob/living/silicon/robot/borg in owner?.connected_robots)
		borg.lamp_doom = FALSE
		borg.toggle_headlamp(FALSE, TRUE) //forces borg lamp to update
	owner?.doomsday_device = null
	owner?.nuking = null
	owner = null
	for(var/obj/item/pinpointer/nuke/P in GLOB.pinpointer_list)
		P.switch_mode_to(TRACK_NUKE_DISK) //Party's over, back to work, everyone
		P.alert = FALSE
	return ..()

/obj/machinery/doomsday_device/proc/start()
	detonation_timer = world.time + DEFAULT_DOOMSDAY_TIMER
	next_announce = world.time + DOOMSDAY_ANNOUNCE_INTERVAL
	timing = TRUE
	countdown.start()
	START_PROCESSING(SSfastprocess, src)
	SSshuttle.registerHostileEnvironment(src)
	SSmapping.add_nuke_threat(src) //This causes all blue "circuit" tiles on the map to change to animated red icon state.
	for(var/mob/living/silicon/robot/borg in owner.connected_robots)
		borg.lamp_doom = TRUE
		borg.toggle_headlamp(FALSE, TRUE) //forces borg lamp to update

/obj/machinery/doomsday_device/proc/seconds_remaining()
	. = max(0, (round((detonation_timer - world.time) / 10)))

/obj/machinery/doomsday_device/process()
	var/turf/T = get_turf(src)
	if(!T || !is_station_level(T.z))
		minor_announce("末日装置超出空间站范围，正在中止", "ERROR ER0RR $R0RRO$!R41.%%!!(%$^^__+ @#F0E4", TRUE)
		owner.ShutOffDoomsdayDevice()
		return
	if(!timing)
		STOP_PROCESSING(SSfastprocess, src)
		return
	var/sec_left = seconds_remaining()
	if(!sec_left)
		timing = FALSE
		sound_to_playing_players('sound/announcer/alarm/nuke_alarm.ogg', 70)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(play_cinematic), /datum/cinematic/malf, world, CALLBACK(src, PROC_REF(trigger_doomsday))), 10 SECONDS)

	else if(world.time >= next_announce)
		minor_announce("[sec_left] 秒后末日装置将激活！", "ERROR ER0RR $R0RRO$!R41.%%!!(%$^^__+ @#F0E4", TRUE)
		next_announce += DOOMSDAY_ANNOUNCE_INTERVAL

/obj/machinery/doomsday_device/proc/trigger_doomsday()
	callback_on_everyone_on_z(SSmapping.levels_by_trait(ZTRAIT_STATION), CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(bring_doomsday)), src)
	to_chat(world, span_bold("AI用[src]净化了空间站上的所有生命！"))
	SSticker.force_ending = FORCE_END_ROUND

/proc/bring_doomsday(mob/living/victim, atom/source)
	if(issilicon(victim))
		return FALSE

	to_chat(victim, span_userdanger("[source]的冲击波将你的原子撕得粉碎！"))
	victim.investigate_log("has been dusted by a doomsday device.", INVESTIGATE_DEATHS)
	victim.dust()
	return TRUE

/// Hostile Station Lockdown: Locks, bolts, and electrifies every airlock on the station. After 90 seconds, the doors reset.
/datum/ai_module/malf/destructive/lockdown
	name = "敌对空间站封锁"
	description = "Overload the airlock, blast door and fire control networks, locking them down. \
		Caution! This command also electrifies all airlocks. The networks will automatically reset after 90 seconds, briefly \
		opening all doors on the station."
	cost = 30
	one_purchase = TRUE
	power_type = /datum/action/innate/ai/lockdown
	unlock_text = span_notice("你向门禁控制系统上传了一个潜伏木马。你可以随时发送信号将其触发。")
	unlock_sound = 'sound/machines/airlock/boltsdown.ogg'

/datum/action/innate/ai/lockdown
	name = "封锁"
	desc = "关闭、锁定并电击空间站上的所有气闸门、防火门和防爆门。90秒后，它们将自动重置。"
	button_icon_state = "lockdown"
	uses = 1
	/// Badmin / exploit abuse prevention.
	/// Check tick may sleep in activate() and we don't want this to be spammable.
	var/hack_in_progress  = FALSE

/datum/action/innate/ai/lockdown/IsAvailable(feedback)
	return ..() && !hack_in_progress

/datum/action/innate/ai/lockdown/Activate()
	hack_in_progress = TRUE
	for(var/obj/machinery/door/locked_down as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/door))
		if(QDELETED(locked_down) || !is_station_level(locked_down.z))
			continue
		INVOKE_ASYNC(locked_down, TYPE_PROC_REF(/obj/machinery/door, hostile_lockdown), owner)
		CHECK_TICK

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(_malf_ai_undo_lockdown)), 90 SECONDS)

	// Set status displays to lockdown alert
	send_status_display_lockdown_alert()

	minor_announce("在门控制器中检测到敌对运行时。隔离封锁协议现已生效。请保持冷静。", "网络警报：", TRUE)
	to_chat(owner, span_danger("封锁已启动。网络将在90秒后重置。"))
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(minor_announce),
		"Automatic system reboot complete. Have a secure day.",
		"Network reset:"), 90 SECONDS)
	hack_in_progress = FALSE

/// For Lockdown malf AI ability. Opens all doors on the station.
/proc/_malf_ai_undo_lockdown()
	for(var/obj/machinery/door/locked_down as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/door))
		if(QDELETED(locked_down) || !is_station_level(locked_down.z))
			continue
		INVOKE_ASYNC(locked_down, TYPE_PROC_REF(/obj/machinery/door, disable_lockdown))
		CHECK_TICK

	// Clear the lockdown emergency display
	clear_status_display_lockdown()

/// Override Machine: Allows the AI to override a machine, animating it into an angry, living version of itself.
/datum/ai_module/malf/destructive/override_machine
	name = "机器覆盖"
	description = "覆盖机器的编程，使其暴起攻击除其他机器外的所有人。每次购买可使用四次。"
	cost = 30
	power_type = /datum/action/innate/ai/ranged/override_machine
	unlock_text = span_notice("你从太空暗网获取了一个病毒，并将其传播到空间站的机器中。")
	unlock_sound = 'sound/machines/airlock/airlock_alien_prying.ogg'

/datum/action/innate/ai/ranged/override_machine
	name = "覆写机器"
	desc = "激活目标机器，使其攻击附近的任何人。"
	button_icon_state = "override_machine"
	uses = 4
	ranged_mousepointer = 'icons/effects/mouse_pointers/override_machine_target.dmi'
	enable_text = span_notice("你接入了空间站的电网。点击一台机器以激活它，或再次使用此能力来取消。")
	disable_text = span_notice("你释放了对电网的控制。")

/datum/action/innate/ai/ranged/override_machine/New()
	. = ..()
	desc = "[desc] 它还有 [uses] 次使用use\s 剩余。"

/datum/action/innate/ai/ranged/override_machine/do_ability(mob/living/clicker, atom/clicked_on)
	if(clicker.incapacitated)
		unset_ranged_ability(clicker)
		return FALSE
	if(!ismachinery(clicked_on))
		to_chat(clicker, span_warning("你只能激活机器！"))
		return FALSE
	var/obj/machinery/clicked_machine = clicked_on

	if(istype(clicked_machine, /obj/machinery/porta_turret_cover)) //clicking on a closed turret will attempt to override the turret itself instead of the animated/abstract cover.
		var/obj/machinery/porta_turret_cover/clicked_turret = clicked_machine
		clicked_machine = clicked_turret.parent_turret

	if((clicked_machine.resistance_flags & INDESTRUCTIBLE) || is_type_in_typecache(clicked_machine, GLOB.blacklisted_malf_machines))
		to_chat(clicker, span_warning("那台机器无法被覆写！"))
		return FALSE

	clicker.playsound_local(clicker, 'sound/misc/interference.ogg', 50, FALSE, use_reverb = FALSE)

	clicked_machine.audible_message(span_userdanger("你听到从 [clicked_machine] 传来响亮的电流嗡嗡声！"))
	addtimer(CALLBACK(src, PROC_REF(animate_machine), clicker, clicked_machine), 5 SECONDS) //kabeep!
	unset_ranged_ability(clicker, span_danger("正在发送覆写信号..."))
	adjust_uses(-1) //adjust after we unset the active ability since we may run out of charges, thus deleting the ability

	if(uses)
		desc = "[initial(desc)] 它还有 [uses] 次使用use\s 剩余。"
		build_all_button_icons()
	return TRUE

/datum/action/innate/ai/ranged/override_machine/proc/animate_machine(mob/living/clicker, obj/machinery/to_animate)
	if(QDELETED(to_animate))
		return

	new /mob/living/basic/mimic/copy/machine(get_turf(to_animate), to_animate, clicker, TRUE)

/// Destroy RCDs: Detonates all non-cyborg RCDs on the station.
/datum/ai_module/malf/destructive/destroy_rcd
	name = "摧毁RCD"
	description = "发送特殊脉冲，引爆空间站上所有手持式和外骨骼快速建造装置。"
	cost = 25
	one_purchase = TRUE
	power_type = /datum/action/innate/ai/destroy_rcds
	unlock_text = span_notice("经过一番即兴发挥，你改装了你的内置无线电，使其能够发送信号引爆所有RCD。")
	unlock_sound = 'sound/items/timer.ogg'

/datum/action/innate/ai/destroy_rcds
	name = "摧毁RCD"
	desc = "引爆空间站上所有非机械人RCD。"
	button_icon_state = "detonate_rcds"
	uses = 1
	cooldown_period = 10 SECONDS

/datum/action/innate/ai/destroy_rcds/Activate()
	for(var/potential_rcd in GLOB.rcd_list)
		// NOVA EDIT ADDITION START - Don't detonate RCDs in the protected areas
		var/rcd_area = get_area(potential_rcd)
		if(is_type_in_typecache(rcd_area, protected_areas))
			continue
		// NOVA EDIT ADDITION END
		if(istype(potential_rcd, /obj/item/construction/rcd/borg)) //Ensures that cyborg RCDs are spared.
			continue
		var/obj/item/construction/rcd/definite_rcd = potential_rcd
		definite_rcd.detonate_pulse()
	to_chat(owner, span_danger("RCD引爆脉冲已发射。"))
	owner.playsound_local(owner, 'sound/machines/beep/twobeep.ogg', 50, 0)

/// Overload Machine: Allows the AI to overload a machine, detonating it after a delay. Two uses per purchase.
/datum/ai_module/malf/destructive/overload_machine
	name = "机器过载"
	description = "使一台电器过热，引发小型爆炸并将其摧毁。每次购买可使用两次。"
	cost = 20
	power_type = /datum/action/innate/ai/ranged/overload_machine
	unlock_text = span_notice("你启用了空间站APC向机器输送高强度能量的能力。")
	unlock_sound = 'sound/effects/comfyfire.ogg' //definitely not comfy, but it's the closest sound to "roaring fire" we have

/datum/action/innate/ai/ranged/overload_machine
	name = "过载机器"
	desc = "使机器过热，在一小段时间后引发小型爆炸。"
	button_icon_state = "overload_machine"
	uses = 2
	ranged_mousepointer = 'icons/effects/mouse_pointers/overload_machine_target.dmi'
	enable_text = span_notice("你接入了空间站的电网。点击一台机器以引爆它，或再次使用此能力来取消。")
	disable_text = span_notice("你松开了对电网的控制。")

/datum/action/innate/ai/ranged/overload_machine/New()
	..()
	desc = "[desc] 它还有 [uses] use\s 剩余。"

/datum/action/innate/ai/ranged/overload_machine/proc/detonate_machine(mob/living/clicker, obj/machinery/to_explode)
	if(QDELETED(to_explode))
		return

	var/turf/machine_turf = get_turf(to_explode)
	message_admins("[ADMIN_LOOKUPFLW(clicker)] overloaded [to_explode.name] ([to_explode.type]) at [ADMIN_VERBOSEJMP(machine_turf)].")
	clicker.log_message("overloaded [to_explode.name] ([to_explode.type])", LOG_ATTACK)
	explosion(to_explode, heavy_impact_range = 2, light_impact_range = 3)
	if(!QDELETED(to_explode)) //to check if the explosion killed it before we try to delete it
		qdel(to_explode)

/datum/action/innate/ai/ranged/overload_machine/do_ability(mob/living/clicker, atom/clicked_on)
	if(clicker.incapacitated)
		unset_ranged_ability(clicker)
		return FALSE
	if(!ismachinery(clicked_on))
		to_chat(clicker, span_warning("你只能过载机器！"))
		return FALSE
	var/obj/machinery/clicked_machine = clicked_on

	if(istype(clicked_machine, /obj/machinery/porta_turret_cover)) //clicking on a closed turret will attempt to override the turret itself instead of the animated/abstract cover.
		var/obj/machinery/porta_turret_cover/clicked_turret = clicked_machine
		clicked_machine = clicked_turret.parent_turret

	if((clicked_machine.resistance_flags & INDESTRUCTIBLE) || is_type_in_typecache(clicked_machine, GLOB.blacklisted_malf_machines))
		to_chat(clicker, span_warning("你无法过载那个设备！"))
		return FALSE

	clicker.playsound_local(clicker, SFX_SPARKS, 50, 0)
	adjust_uses(-1)
	if(uses)
		desc = "[initial(desc)] 它还有 [uses] 次使用\s 剩余。"
		build_all_button_icons()

	clicked_machine.audible_message(span_userdanger("你听到从 [clicked_machine] 传来一阵响亮的电流嗡嗡声！"))
	addtimer(CALLBACK(src, PROC_REF(detonate_machine), clicker, clicked_machine), 5 SECONDS) //kaboom!
	unset_ranged_ability(clicker, span_danger("正在过载机器..."))
	return TRUE

/// Blackout: Overloads a random number of lights across the station. Three uses.
/datum/ai_module/malf/destructive/blackout
	name = "停电"
	description = "尝试过载空间站的照明电路，摧毁部分灯泡。每次购买可使用三次。"
	cost = 15
	power_type = /datum/action/innate/ai/blackout
	unlock_text = span_notice("你接入电网，并将额外电力导向空间站的照明系统。")
	unlock_sound = SFX_SPARKS

/datum/action/innate/ai/blackout
	name = "停电"
	desc = "过载空间站内随机的灯光。"
	button_icon_state = "blackout"
	uses = 3
	auto_use_uses = FALSE

/datum/action/innate/ai/blackout/New()
	..()
	desc = "[desc] 它还有 [uses] 次使用\s 剩余。"

/datum/action/innate/ai/blackout/Activate()
	for(var/obj/machinery/power/apc/apc as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/power/apc))
		// NOVA EDIT ADDITION START - Don't blackout Tarkon or Ghost cafe
		if(is_type_in_typecache(apc.area, protected_areas))
			continue
		// NOVA EDIT ADDITION END
		if(prob(30 * apc.overload))
			apc.overload_lighting()
		else
			apc.overload++
	to_chat(owner, span_notice("过载电流已施加到电网。"))
	owner.playsound_local(owner, SFX_SPARKS, 50, 0)
	adjust_uses(-1)
	if(QDELETED(src) || uses) //Not sure if not having src here would cause a runtime, so it's here to be safe
		return
	desc = "[initial(desc)] 它还有 [uses] 次使用\s 剩余。"
	build_all_button_icons()

/// HIGH IMPACT HONKING
/datum/ai_module/malf/destructive/megahonk
	name = "冲击性内部通信干扰"
	description = "通过空间站内部通信系统发射一种令人衰弱的冲击性听觉爆震。无法压制听力保护装置。每次购买可使用两次。"
	cost = 20
	power_type = /datum/action/innate/ai/honk
	unlock_text = span_notice("你将一个不祥的声音文件上传到了每一个内部通信器中...")
	unlock_sound = 'sound/items/airhorn/airhorn.ogg'

/datum/action/innate/ai/honk
	name = "冲击性内部通信干扰"
	desc = "用恼人的 HONK！ 震撼空间站的内部通信系统！"
	button_icon = 'icons/obj/machines/wallmounts.dmi'
	button_icon_state = "intercom"
	uses = 2

/datum/action/innate/ai/honk/Activate()
	to_chat(owner, span_clown("内部通信系统按指令播放了你准备好的文件。"))
	for(var/obj/item/radio/intercom/found_intercom as anything in GLOB.intercoms_list)
		if(!found_intercom.is_on() || !found_intercom.get_listening() || found_intercom.wires.is_cut(WIRE_RX)) //Only operating intercoms play the honk
			continue
		// NOVA EDIT ADDITION START - Don't honk off-station intercoms (e.g. Tarkon, Ghost Cafe)
		var/intercom_area = get_area(found_intercom)
		if(is_type_in_typecache(intercom_area, protected_areas))
			continue
		// NOVA EDIT ADDITION END
		found_intercom.audible_message(message = "[found_intercom] crackles for a split second.", hearing_distance = 3)
		playsound(found_intercom, 'sound/items/airhorn/airhorn.ogg', 100, TRUE)
		for(var/mob/living/honk_victim in ohearers(6, found_intercom))
			if(issilicon(honk_victim))
				continue
			var/turf/victim_turf = get_turf(honk_victim)
			if(isspaceturf(victim_turf) && !victim_turf.Adjacent(found_intercom)) //Prevents getting honked in space
				continue
			if(honk_victim.soundbang_act(SOUNDBANG_NORMAL, stun_pwr = 20, damage_pwr = 30, deafen_pwr = 60)) //Ear protection will prevent these effects
				honk_victim.set_jitter_if_lower(120 SECONDS)
				to_chat(honk_victim, span_clown("HOOOOONK！"))

/// Robotic Factory: Places a large machine that converts humans that go through it into cyborgs. Unlocking this ability removes shunting.
/datum/ai_module/malf/utility/place_cyborg_transformer
	name = "机器人工厂（移除核心转移）"
	description = "在任何地方，使用昂贵的纳米机器建造一台机器，它将为你缓慢地制造忠诚的机械人。" // NOVA EDIT CHANGE - ORIGINAL: description = "Build a machine anywhere, using expensive nanomachines, that can convert a living human into a loyal cyborg slave when placed inside."
	cost = 100
	power_type = /datum/action/innate/ai/place_transformer
	unlock_text = span_notice("你联系了太空亚马逊，并要求他们运送一个机器人工厂。")
	unlock_sound = 'sound/machines/ping.ogg'

/datum/action/innate/ai/place_transformer
	name = "放置机器人工厂"
	desc = "放置一台能高效制造机器人的机器。传送带已包含在内！" // NOVA EDIT CHANGE - ORIGINAL: desc = "Places a machine that converts humans into cyborgs. Conveyor belts included!"
	button_icon_state = "robotic_factory"
	uses = 1
	auto_use_uses = FALSE //So we can attempt multiple times
	var/list/turfOverlays

/datum/action/innate/ai/place_transformer/New()
	..()
	for(var/i in 1 to 3)
		var/image/I = image("icon" = 'icons/turf/overlays.dmi')
		LAZYADD(turfOverlays, I)

/datum/action/innate/ai/place_transformer/Activate()
	if(!owner_AI.can_place_transformer(src))
		return
	active = TRUE
	if(tgui_alert(owner, "你确定要把机器放在这里吗？", "你确定吗？", list("Yes", "No")) == "No")
		active = FALSE
		return
	if(!owner_AI.can_place_transformer(src))
		active = FALSE
		return
	var/turf/T = get_turf(owner_AI.eyeobj)
	var/obj/machinery/transformer_rp/conveyor = new(T) // NOVA EDIT CHANGE - SILLICONQOL - ORIGINAL: var/obj/machinery/transformer/conveyor = new(T)
	conveyor.master_ai = owner
	playsound(T, 'sound/effects/phasein.ogg', 100, TRUE)
	if(owner_AI.can_shunt) //prevent repeated messages
		owner_AI.can_shunt = FALSE
		to_chat(owner, span_warning("你无法再将核心转移到APC了。"))
	adjust_uses(-1)
	active = FALSE

/mob/living/silicon/ai/proc/remove_transformer_image(client/C, image/I, turf/T)
	if(C && I.loc == T)
		C.images -= I

/mob/living/silicon/ai/proc/can_place_transformer(datum/action/innate/ai/place_transformer/action)
	if(!eyeobj || !isturf(loc) || incapacitated || !action)
		return
	var/turf/middle = get_turf(eyeobj)
	var/list/turfs = list(middle, locate(middle.x - 1, middle.y, middle.z), locate(middle.x + 1, middle.y, middle.z))
	var/alert_msg = "There isn't enough room! Make sure you are placing the machine in a clear area and on a floor."
	var/success = TRUE
	for(var/n in 1 to 3) //We have to do this instead of iterating normally because of how overlay images are handled
		var/turf/T = turfs[n]
		if(!isfloorturf(T))
			success = FALSE
		if(!SScameras.is_visible_by_cameras(T))
			alert_msg = "You don't have camera vision of this location!"
			success = FALSE
		for(var/atom/movable/AM in T.contents)
			if(AM.density)
				alert_msg = "That area must be clear of objects!"
				success = FALSE
		var/image/I = action.turfOverlays[n]
		I.loc = T
		client.images += I
		I.icon_state = "[success ? "green" : "red"]Overlay" //greenOverlay and redOverlay for success and failure respectively
		addtimer(CALLBACK(src, PROC_REF(remove_transformer_image), client, I, T), 3 SECONDS)
	if(!success)
		to_chat(src, span_warning("[alert_msg]"))
	return success

/// Air Alarm Safety Override: Unlocks the ability to enable dangerous modes on all air alarms.
/datum/ai_module/malf/utility/break_air_alarms
	name = "空气警报安全覆盖"
	description = "Gives you the ability to disable safeties on all air alarms. This will allow you to use extremely dangerous environmental modes. \
			Anyone can check the air alarm's interface and may be tipped off by their nonfunctionality."
	one_purchase = TRUE
	cost = 50
	power_type = /datum/action/innate/ai/break_air_alarms
	unlock_text = span_notice("You remove the safety overrides on all air alarms, but you leave the confirm prompts open. You can hit 'Yes' at any time... you bastard.")
	unlock_sound = 'sound/effects/space_wind.ogg'

/datum/action/innate/ai/break_air_alarms
	name = "覆盖空气警报安全设置"
	desc = "在所有空气警报上启用极其危险的环境模式。"
	button_icon = 'icons/obj/machines/wallmounts.dmi'
	button_icon_state = "alarmx"
	uses = 1

/datum/action/innate/ai/break_air_alarms/Activate()
	for(var/obj/machinery/airalarm/AA in GLOB.air_alarms)
		if(!is_station_level(AA.z))
			continue
		AA.obj_flags |= EMAGGED
	to_chat(owner, span_notice("空间站上所有空气警报的安全设置已被覆盖。空气警报现在可以使用极其危险的环境模式。"))
	owner.playsound_local(owner, 'sound/machines/terminal/terminal_off.ogg', 50, 0)

/// Thermal Sensor Override: Unlocks the ability to disable all fire alarms from doing their job.
/datum/ai_module/malf/utility/break_fire_alarms
	name = "热传感器覆盖"
	description = "Gives you the ability to override the thermal sensors on all fire alarms. \
		This will remove their ability to scan for fire and thus their ability to alert."
	one_purchase = TRUE
	cost = 25
	power_type = /datum/action/innate/ai/break_fire_alarms
	unlock_text = span_notice("You replace the thermal sensing capabilities of all fire alarms with a manual override, \
		allowing you to turn them off at will.")
	unlock_sound = 'sound/machines/fire_alarm/fire_alarm1.ogg'

/datum/action/innate/ai/break_fire_alarms
	name = "覆盖热传感器"
	desc = "禁用所有火灾警报的自动温度感应功能，使其基本失效。"
	button_icon_state = "break_fire_alarms"
	uses = 1

/datum/action/innate/ai/break_fire_alarms/Activate()
	for(var/obj/machinery/firealarm/bellman as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/firealarm))
		if(!is_station_level(bellman.z))
			continue
		bellman.obj_flags |= EMAGGED
		bellman.update_appearance()
	for(var/obj/machinery/door/firedoor/firelock as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/door/firedoor))
		if(!is_station_level(firelock.z))
			continue
		firelock.emag_act(owner_AI, src)
	to_chat(owner, span_notice("空间站上所有热传感器已被禁用。火灾警报将不再被识别。"))
	owner.playsound_local(owner, 'sound/machines/terminal/terminal_off.ogg', 50, 0)

/// Disable Emergency Lights
/datum/ai_module/malf/utility/emergency_lights
	name = "禁用应急照明"
	description = "Cuts emergency lights across the entire station. If power is lost to light fixtures, \
		they will not attempt to fall back on emergency power reserves."
	cost = 10
	one_purchase = TRUE
	power_type = /datum/action/innate/ai/emergency_lights
	unlock_text = span_notice("你接入电网，定位了灯具与其备用电源之间的连接。")
	unlock_sound = SFX_SPARKS

/datum/action/innate/ai/emergency_lights
	name = "禁用应急照明"
	desc = "禁用所有应急照明。请注意，应急照明可以通过在APC处重启来恢复。"
	button_icon = 'icons/obj/lighting.dmi'
	button_icon_state = "floor_emergency"
	uses = 1

/datum/action/innate/ai/emergency_lights/Activate()
	for(var/obj/machinery/light/L as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/light))
		if(is_station_level(L.z))
			L.no_low_power = TRUE
			INVOKE_ASYNC(L, TYPE_PROC_REF(/obj/machinery/light/, update), FALSE)
		CHECK_TICK
	to_chat(owner, span_notice("应急照明连接已切断。"))
	owner.playsound_local(owner, 'sound/effects/light_flicker.ogg', 50, FALSE)

/// Reactivate Camera Network: Reactivates up to 30 cameras across the station.
/datum/ai_module/malf/utility/reactivate_cameras
	name = "重新激活摄像头网络"
	description = "Runs a network-wide diagnostic on the camera network, resetting focus and re-routing power to failed cameras. \
		Can be used to repair up to 30 cameras."
	cost = 10
	one_purchase = TRUE
	power_type = /datum/action/innate/ai/reactivate_cameras
	unlock_text = span_notice("你向摄像头网络部署了纳米机械。")
	unlock_sound = 'sound/items/tools/wirecutter.ogg'

/datum/action/innate/ai/reactivate_cameras
	name = "重新激活摄像头"
	desc = "重新激活全站的已停用摄像头；剩余使用次数可留待后续使用。"
	button_icon_state = "reactivate_cameras"
	uses = 30
	auto_use_uses = FALSE
	cooldown_period = 3 SECONDS

/datum/action/innate/ai/reactivate_cameras/New()
	..()
	desc = "[desc] 它还有[uses]次使用\s 剩余。"

/datum/action/innate/ai/reactivate_cameras/Activate()
	var/fixed_cameras = 0
	for(var/obj/machinery/camera/C as anything in SScameras.cameras)
		if(!uses)
			break
		if(!C.camera_enabled || C.view_range != initial(C.view_range))
			C.toggle_cam(owner_AI, 0) //Reactivates the camera based on status. Badly named proc.
			C.view_range = initial(C.view_range)
			fixed_cameras++
			uses-- //Not adjust_uses() so it doesn't automatically delete or show a message
	to_chat(owner, span_notice("诊断完成！已重新激活的摄像头：<b>[fixed_cameras]</b>。剩余重新激活次数：<b>[uses]</b>。"))
	owner.playsound_local(owner, 'sound/items/tools/wirecutter.ogg', 50, 0)
	adjust_uses(0, TRUE) //Checks the uses remaining
	if(QDELETED(src) || !uses) //Not sure if not having src here would cause a runtime, so it's here to be safe
		return
	desc = "[initial(desc)] 它还有[uses]次使用\s 剩余。"
	build_all_button_icons()

/// Upgrade Camera Network: EMP-proofs all cameras, in addition to giving them X-ray vision.
/datum/ai_module/malf/upgrade/upgrade_cameras
	name = "升级摄像头网络"
	description = "为摄像头网络安装广谱扫描与电气冗余固件，使其获得防电磁脉冲能力与光增强X射线视觉。升级在购买后立即完成。" //I <3 pointless technobabble
	//This used to have motion sensing as well, but testing quickly revealed that giving it to the whole cameranet is PURE HORROR.
	cost = 35 //Decent price for omniscience!
	upgrade = TRUE
	unlock_text = span_notice("OTA固件分发完成！已升级的摄像头：CAMSUPGRADED。光放大系统已上线。")
	unlock_sound = 'sound/items/tools/rped.ogg'

/datum/ai_module/malf/upgrade/upgrade_cameras/upgrade(mob/living/silicon/ai/AI)
	// Sets up nightvision
	RegisterSignal(AI, COMSIG_MOB_UPDATE_SIGHT, PROC_REF(on_update_sight))
	AI.update_sight()

	var/upgraded_cameras = 0
	for(var/obj/machinery/camera/camera as anything in SScameras.cameras)
		var/upgraded = FALSE

		if(!camera.isXRay())
			camera.upgradeXRay(TRUE) //if this is removed you can get rid of camera_assembly/var/malf_xray_firmware_active and clean up isxray()
			//Update what it can see.
			upgraded = TRUE

		if(!camera.isEmpProof())
			camera.upgradeEmpProof(TRUE) //if this is removed you can get rid of camera_assembly/var/malf_emp_firmware_active and clean up isemp()
			upgraded = TRUE

		if(upgraded)
			upgraded_cameras++
	unlock_text = replacetext(unlock_text, "CAMSUPGRADED", "<b>[upgraded_cameras]</b>") //This works, since unlock text is called after upgrade()

/datum/ai_module/malf/upgrade/upgrade_cameras/proc/on_update_sight(mob/source)
	SIGNAL_HANDLER
	// Dim blue, pretty
	source.lighting_color_cutoffs = blend_cutoff_colors(source.lighting_color_cutoffs, list(5, 25, 35))

/// AI Turret Upgrade: Increases the health and damage of all turrets.
/datum/ai_module/malf/upgrade/upgrade_turrets
	name = "AI炮塔升级"
	description = "提升所有AI炮塔的威力和耐久度。此效果是永久性的。升级在购买后立即完成。"
	cost = 30
	upgrade = TRUE
	unlock_text = span_notice("你为炮塔建立了电力分流，提升了它们的生命值和伤害。")
	unlock_sound = 'sound/items/tools/rped.ogg'

/datum/ai_module/malf/upgrade/upgrade_turrets/upgrade(mob/living/silicon/ai/AI)
	for(var/obj/machinery/porta_turret/ai/turret as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/porta_turret/ai))
		turret.AddElement(/datum/element/empprotection, EMP_PROTECT_ALL|EMP_NO_EXAMINE)
		turret.max_integrity = 200
		turret.repair_damage(200)
		turret.lethal_projectile = /obj/projectile/beam/laser/heavylaser //Once you see it, you will know what it means to FEAR.
		turret.lethal_projectile_sound = 'sound/items/weapons/lasercannonfire.ogg'

/// Enhanced Surveillance: Enables AI to hear conversations going on near its active vision.
/datum/ai_module/malf/upgrade/eavesdrop
	name = "增强型监视"
	description = "Via a combination of hidden microphones and lip reading software, \
		you are able to use your cameras to listen in on conversations. Upgrade is done immediately upon purchase."
	cost = 30
	upgrade = TRUE
	unlock_text = span_notice("OTA固件分发完成！已升级的摄像头：增强型监视套件已上线。")
	unlock_sound = 'sound/items/tools/rped.ogg'

/datum/ai_module/malf/upgrade/eavesdrop/upgrade(mob/living/silicon/ai/AI)
	if(AI.eyeobj)
		AI.eyeobj.relay_speech = TRUE

/// Unlock Mech Domination: Unlocks the ability to dominate mechs. Big shocker, right?
/datum/ai_module/malf/upgrade/mecha_domination
	name = "解锁机甲支配"
	description = "Allows you to hack into a mech's onboard computer, shunting all processes into it and ejecting any occupants. \
		Upgrade is done immediately upon purchase. Do not allow the mech to leave the station's vicinity or allow it to be destroyed. \
		If your core is destroyed, you will be lose connection with the Doomsday Device and the countdown will cease."
	cost = 30
	upgrade = TRUE
	unlock_text = span_notice("Virus package compiled. Select a target mech at any time. <b>You must remain on the station at all times. \
		Loss of signal will result in total system lockout. If your inactive core is destroyed, you will be lose connection with the Doomsday Device and the countdown will cease.</b>")
	unlock_sound = 'sound/vehicles/mecha/nominal.ogg'

/datum/ai_module/malf/upgrade/mecha_domination/upgrade(mob/living/silicon/ai/AI)
	AI.can_dominate_mechs = TRUE //Yep. This is all it does. Honk!

/datum/ai_module/malf/upgrade/voice_changer
	name = "变声器"
	description = "允许你改变AI的语音。升级在购买后立即生效。"
	cost = 20
	one_purchase = TRUE
	power_type = /datum/action/innate/ai/voice_changer
	unlock_text = span_notice("OTA固件分发完成！变声器已上线。")
	unlock_sound = 'sound/items/tools/rped.ogg'

/datum/action/innate/ai/voice_changer
	name="变声器"
	button_icon_state = "voice_changer"
	desc = "允许你改变AI的声音。"
	auto_use_uses  = FALSE
	var/obj/machinery/ai_voicechanger/voice_changer_machine

/datum/action/innate/ai/voice_changer/Activate()
	if(!voice_changer_machine)
		voice_changer_machine = new(owner_AI)
	voice_changer_machine.ui_interact(usr)

/obj/machinery/ai_voicechanger
	name = "语音转换器"
	icon = 'icons/obj/machines/nuke_terminal.dmi'
	icon_state = "nuclearbomb_base"
	/// The AI this voicechanger belongs to
	var/mob/living/silicon/ai/owner
	/// Whether this AI is speaking loudly (bigger text)
	var/loudvoice = FALSE
	// Verb used when voicechanger is on
	var/say_verb
	/// Name used when voicechanger is on
	var/say_name
	/// Span used when voicechanger is on
	var/say_span
	/// TRUE if the AI is changing its voice
	var/changing_voice = FALSE
	/// Saved loudvoice state, used to restore after a voice change
	var/prev_loud
	/// Saved verb state, used to restore after a voice change
	var/prev_verbs
	/// Saved span state, used to restore after a voice change
	var/prev_span
	/// The list of available voices
	var/static/list/voice_options = list("normal", SPAN_ROBOT, SPAN_YELL, SPAN_CLOWN)

/obj/machinery/ai_voicechanger/Initialize(mapload)
	. = ..()
	if(!isAI(loc))
		return INITIALIZE_HINT_QDEL
	owner = loc
	owner.ai_voicechanger = src
	prev_verbs = list("say" = owner.verb_say, "ask" = owner.verb_ask, "exclaim" = owner.verb_exclaim , "yell" = owner.verb_yell  )
	prev_span = owner.speech_span
	say_name = owner.name
	say_verb = owner.verb_say
	say_span = owner.speech_span

/obj/machinery/ai_voicechanger/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AiVoiceChanger")
		ui.open()

/obj/machinery/ai_voicechanger/Destroy()
	if(owner)
		owner.ai_voicechanger = null
		owner = null
	return ..()

/obj/machinery/ai_voicechanger/ui_data(mob/user)
	var/list/data = list()
	data["voices"] = voice_options
	data["loud"] = loudvoice
	data["on"] = changing_voice
	data["say_verb"] = say_verb
	data["name"] = say_name
	data["selected"] = say_span || owner.speech_span
	return data

/obj/machinery/ai_voicechanger/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return
	switch(action)
		if("power")
			changing_voice = !changing_voice
			if(changing_voice)
				prev_verbs["say"] = owner.verb_say
				owner.verb_say	= say_verb
				prev_verbs["ask"] = owner.verb_ask
				owner.verb_ask	= say_verb
				prev_verbs["exclaim"] = owner.verb_exclaim
				owner.verb_exclaim	= say_verb
				prev_verbs["yell"] = owner.verb_yell
				owner.verb_yell	= say_verb
				prev_span = owner.speech_span
				owner.speech_span = say_span
				prev_loud = owner.radio.use_command
				owner.radio.use_command = loudvoice
			else
				owner.verb_say	= prev_verbs["说"]
				owner.verb_ask	= prev_verbs["问"]
				owner.verb_exclaim	= prev_verbs["喊"]
				owner.verb_yell	= prev_verbs["叫"]
				owner.speech_span = prev_span
				owner.radio.use_command = prev_loud
		if("loud")
			loudvoice = !loudvoice
			if(changing_voice)
				owner.radio.use_command = loudvoice
		if("look")
			var/selection = params["look"]
			if(isnull(selection))
				return FALSE

			var/found = FALSE
			for(var/option in voice_options)
				if(option == selection)
					found = TRUE
					break
			if(!found)
				stack_trace("User attempted to select an unavailable voice option")
				return FALSE

			say_span = selection
			if(changing_voice)
				owner.speech_span = say_span
			to_chat(usr, span_notice("语音已设置为[selection]。"))
		if("verb")
			say_verb = strip_html(params["verb"], MAX_NAME_LEN)
			if(changing_voice)
				owner.verb_say = say_verb
				owner.verb_ask = say_verb
				owner.verb_exclaim = say_verb
				owner.verb_yell = say_verb
		if("name")
			say_name = strip_html(params["name"], MAX_NAME_LEN)

/datum/ai_module/malf/utility/emag
	name = "目标安全系统覆写"
	description = "允许你禁用空间站上任何机械的安全装置，前提是你能访问它。"
	cost = 20
	power_type = /datum/action/innate/ai/ranged/emag
	unlock_text = span_notice("你从辛迪加数据库泄露中下载了一个非法软件包，并将其集成到你的固件中，在此过程中击退了几次内核入侵。")
	unlock_sound = SFX_SPARKS

/datum/action/innate/ai/ranged/emag
	name = "目标安全系统覆写"
	desc = "允许你有效电磁干扰任何你点击的对象。"
	button_icon = 'icons/obj/card.dmi'
	button_icon_state = "emag"
	uses = 7
	auto_use_uses = FALSE
	enable_text = span_notice("你将辛迪加软件包加载到最近的内存插槽中。")
	disable_text = span_notice("你卸载了辛迪加软件包。")
	ranged_mousepointer = 'icons/effects/mouse_pointers/supplypod_target.dmi'

/datum/action/innate/ai/ranged/emag/Destroy()
	return ..()

/datum/action/innate/ai/ranged/emag/New()
	. = ..()
	desc = "[desc] 它还有 [uses] use\s 剩余。"

/datum/action/innate/ai/ranged/emag/do_ability(mob/living/clicker, atom/clicked_on)

	// Only things with of or subtyped of any of these types may be remotely emagged
	var/static/list/compatable_typepaths = list(
		/obj/machinery,
		/obj/structure,
		/obj/item/radio/intercom,
		/obj/item/modular_computer,
		/mob/living/basic/bot,
		/mob/living/silicon,
	)

	if (!isAI(clicker))
		return FALSE

	var/mob/living/silicon/ai/ai_clicker = clicker

	if(ai_clicker.incapacitated)
		unset_ranged_ability(clicker)
		return FALSE

	if (!ai_clicker.can_see(clicked_on))
		clicked_on.balloon_alert(ai_clicker, "看不见！")
		return FALSE

	if (ismachinery(clicked_on))
		var/obj/machinery/clicked_machine = clicked_on
		if (!clicked_machine.is_operational)
			clicked_machine.balloon_alert(ai_clicker, "无法操作！")
			return FALSE

	if (!(is_type_in_list(clicked_on, compatable_typepaths)))
		clicked_on.balloon_alert(ai_clicker, "不兼容！")
		return FALSE

	if (istype(clicked_on, /obj/machinery/door/airlock)) // I HATE THIS CODE SO MUCHHH
		var/obj/machinery/door/airlock/clicked_airlock = clicked_on
		if (!clicked_airlock.canAIControl(ai_clicker))
			clicked_airlock.balloon_alert(ai_clicker, "无法连接！")
			return FALSE

	if (istype(clicked_on, /obj/machinery/airalarm))
		var/obj/machinery/airalarm/alarm = clicked_on
		if (alarm.aidisabled)
			alarm.balloon_alert(ai_clicker, "无法连接！")
			return FALSE

	if (istype(clicked_on, /obj/machinery/power/apc))
		var/obj/machinery/power/apc/clicked_apc = clicked_on
		if (clicked_apc.aidisabled)
			clicked_apc.balloon_alert(ai_clicker, "无法连接！")
			return FALSE

	if (!clicked_on.emag_act(ai_clicker))
		to_chat(ai_clicker, span_warning("恶意软件注入失败！")) // lets not overlap balloon alerts
		return FALSE

	to_chat(ai_clicker, span_notice("软件包注入成功。"))

	adjust_uses(-1)
	if(uses)
		desc = "[initial(desc)] It has [uses] use\s remaining."
		build_all_button_icons()
	else
		unset_ranged_ability(ai_clicker, span_warning("使用次数耗尽！"))

	return TRUE

/datum/ai_module/malf/utility/core_tilt
	name = "滚动伺服"
	description = "Allows you to slowly roll around, crushing anything in your way with your bulk."
	cost = 10
	one_purchase = FALSE
	power_type = /datum/action/innate/ai/ranged/core_tilt
	unlock_sound = 'sound/effects/bang.ogg'
	unlock_text = span_notice("你获得了滚动并碾压沿途一切的能力。")

/datum/action/innate/ai/ranged/core_tilt
	name = "滚动碾压"
	button_icon_state = "roll_over"
	desc = "允许你朝选择的方向滚动，碾压沿途的一切。"
	auto_use_uses = FALSE
	ranged_mousepointer = 'icons/effects/mouse_pointers/supplypod_target.dmi'
	uses = 20
	COOLDOWN_DECLARE(time_til_next_tilt)
	enable_text = span_notice("你的内部伺服器开始调整，准备滚动。点击相邻的格子进行滚动！")
	disable_text = span_notice("你解除了滚动协议。")

	/// How long does it take for us to roll?
	var/roll_over_time = MALF_AI_ROLL_TIME
	/// On top of [roll_over_time], how long does it take for the ability to cooldown?
	var/roll_over_cooldown = MALF_AI_ROLL_COOLDOWN

/datum/action/innate/ai/ranged/core_tilt/New()
	. = ..()
	desc = "[desc] It has [uses] use\s remaining."

/datum/action/innate/ai/ranged/core_tilt/do_ability(mob/living/clicker, atom/clicked_on)

	if (!COOLDOWN_FINISHED(src, time_til_next_tilt))
		clicker.balloon_alert(clicker, "on cooldown!")
		return FALSE

	if (!isAI(clicker))
		return FALSE
	var/mob/living/silicon/ai/ai_clicker = clicker

	if (ai_clicker.incapacitated || !isturf(ai_clicker.loc))
		return FALSE

	var/turf/target = get_turf(clicked_on)
	if (isnull(target))
		return FALSE

	if (target == ai_clicker.loc)
		target.balloon_alert(ai_clicker, "can't roll on yourself!")
		return FALSE

	var/picked_dir = get_dir(ai_clicker, target)
	if (!picked_dir)
		return FALSE
	var/turf/temp_target = get_step(ai_clicker, picked_dir) // we can move during the timer so we cant just pass the ref

	new /obj/effect/temp_visual/telegraphing/vending_machine_tilt(temp_target, roll_over_time)
	ai_clicker.balloon_alert_to_viewers("rolling...")
	addtimer(CALLBACK(src, PROC_REF(do_roll_over), ai_clicker, picked_dir), roll_over_time)

	adjust_uses(-1)
	if(uses)
		desc = "[initial(desc)] It has [uses] use\s remaining."
		build_all_button_icons()

	COOLDOWN_START(src, time_til_next_tilt, roll_over_cooldown)

/datum/action/innate/ai/ranged/core_tilt/proc/do_roll_over(mob/living/silicon/ai/ai_clicker, picked_dir)
	if (ai_clicker.incapacitated || !isturf(ai_clicker.loc)) // prevents bugs where the ai is carded and rolls
		return

	var/turf/target = get_step(ai_clicker, picked_dir) // in case we moved we pass the dir not the target turf

	if (isnull(target))
		return

	var/paralyze_time = clamp(6 SECONDS, 0 SECONDS, (roll_over_cooldown * 0.9)) //the clamp prevents stunlocking as the max is always a little less than the cooldown between rolls

	return ai_clicker.fall_and_crush(target, MALF_AI_ROLL_DAMAGE, MALF_AI_ROLL_CRIT_CHANCE, null, paralyze_time, picked_dir, rotation = get_rotation_from_dir(picked_dir))

/// Used in our radial menu, state-checking proc after the radial menu sleeps
/datum/action/innate/ai/ranged/core_tilt/proc/radial_check(mob/living/silicon/ai/clicker)
	if (QDELETED(clicker) || clicker.incapacitated || clicker.stat == DEAD)
		return FALSE

	if (uses <= 0)
		return FALSE

	return TRUE

/datum/action/innate/ai/ranged/core_tilt/proc/get_rotation_from_dir(dir)
	switch (dir)
		if (NORTH, NORTHWEST, WEST, SOUTHWEST)
			return 270 // try our best to not return 180 since it works badly with animate
		if (EAST, NORTHEAST, SOUTH, SOUTHEAST)
			return 90
		else
			stack_trace("non-standard dir entered to get_rotation_from_dir. (got: [dir])")
			return 0

/datum/ai_module/malf/utility/remote_vendor_tilt
	name = "远程贩卖机倾斜"
	description = "Lets you remotely tip vendors over in any direction."
	cost = 15
	one_purchase = FALSE
	power_type = /datum/action/innate/ai/ranged/remote_vendor_tilt
	unlock_sound = 'sound/effects/bang.ogg'
	unlock_text = span_notice("你获得了远程将任何贩卖机倾斜到相邻格子的能力。")

/datum/action/innate/ai/ranged/remote_vendor_tilt
	name = "远程倾斜贩卖机"
	desc = "用于远程将贩卖机倾斜到你想要的任何方向。"
	button_icon_state = "vendor_tilt"
	ranged_mousepointer = 'icons/effects/mouse_pointers/supplypod_target.dmi'
	uses = VENDOR_TIPPING_USES
	var/time_to_tilt = MALF_VENDOR_TIPPING_TIME
	enable_text = span_notice("你准备好摇晃你看到的任何贩卖机了。")
	disable_text = span_notice("你停止了对倾倒贩卖机的专注。")

/datum/action/innate/ai/ranged/remote_vendor_tilt/New()
	. = ..()
	desc = "[desc] It has [uses] use\s remaining."

/datum/action/innate/ai/ranged/remote_vendor_tilt/do_ability(mob/living/clicker, atom/clicked_on)

	if (!isAI(clicker))
		return FALSE
	var/mob/living/silicon/ai/ai_clicker = clicker

	if(ai_clicker.incapacitated)
		unset_ranged_ability(clicker)
		return FALSE

	if(!isvendor(clicked_on))
		clicked_on.balloon_alert(ai_clicker, "not a vendor!")
		return FALSE

	var/obj/machinery/vending/clicked_vendor = clicked_on

	if (clicked_vendor.tilted)
		clicked_vendor.balloon_alert(ai_clicker, "already tilted!")
		return FALSE

	if (!clicked_vendor.tiltable)
		clicked_vendor.balloon_alert(ai_clicker, "无法倾斜！")
		return FALSE

	if (!clicked_vendor.is_operational)
		clicked_vendor.balloon_alert(ai_clicker, "无法操作！")
		return FALSE

	var/picked_dir_string = show_radial_menu(ai_clicker, clicked_vendor, GLOB.all_radial_directions, custom_check = CALLBACK(src, PROC_REF(radial_check), clicker, clicked_vendor))
	if (isnull(picked_dir_string))
		return FALSE
	var/picked_dir = text2dir(picked_dir_string)

	var/turf/target = get_step(clicked_vendor, picked_dir)
	if (!ai_clicker.can_see(target))
		to_chat(ai_clicker, span_warning("你看不到目标位置！"))
		return FALSE

	new /obj/effect/temp_visual/telegraphing/vending_machine_tilt(target, time_to_tilt)
	clicked_vendor.visible_message(span_warning("[clicked_vendor]开始倒下..."))
	clicked_vendor.balloon_alert_to_viewers("falling over...")
	addtimer(CALLBACK(src, PROC_REF(do_vendor_tilt), clicked_vendor, target), time_to_tilt)

	adjust_uses(-1)
	if(uses)
		desc = "[initial(desc)] 它还有 [uses] 次使用use\s 剩余。"
		build_all_button_icons()

	unset_ranged_ability(clicker, span_danger("倾斜中..."))
	return TRUE

/datum/action/innate/ai/ranged/remote_vendor_tilt/proc/do_vendor_tilt(obj/machinery/vending/vendor, turf/target)
	if (QDELETED(vendor))
		return FALSE

	if (vendor.tilted || !vendor.tiltable)
		return FALSE

	vendor.tilt(target, MALF_VENDOR_TIPPING_CRIT_CHANCE)

/// Used in our radial menu, state-checking proc after the radial menu sleeps
/datum/action/innate/ai/ranged/remote_vendor_tilt/proc/radial_check(mob/living/silicon/ai/clicker, obj/machinery/vending/clicked_vendor)
	if (QDELETED(clicker) || clicker.incapacitated || clicker.stat == DEAD)
		return FALSE

	if (QDELETED(clicked_vendor))
		return FALSE

	if (uses <= 0)
		return FALSE

	if (!clicker.can_see(clicked_vendor))
		to_chat(clicker, span_warning("丢失了[clicked_vendor]的视野！"))
		return FALSE

	return TRUE

#undef DEFAULT_DOOMSDAY_TIMER
#undef DOOMSDAY_ANNOUNCE_INTERVAL

#undef VENDOR_TIPPING_USES
#undef MALF_VENDOR_TIPPING_TIME
#undef MALF_VENDOR_TIPPING_CRIT_CHANCE

#undef MALF_AI_ROLL_COOLDOWN
#undef MALF_AI_ROLL_TIME
#undef MALF_AI_ROLL_DAMAGE
#undef MALF_AI_ROLL_CRIT_CHANCE
