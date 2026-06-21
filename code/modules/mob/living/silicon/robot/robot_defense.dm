GLOBAL_LIST_INIT(blacklisted_borg_hats, typecacheof(list( //Hats that don't really work on borgos
	/obj/item/clothing/head/helmet/space,
	/obj/item/clothing/head/utility/welding,
	/obj/item/clothing/head/chameleon/broken \
	)))

/mob/living/silicon/robot/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(is_wire_tool(tool, check_secured = TRUE))
		if(wiresexposed)
			wires.interact(user)
			return ITEM_INTERACT_SUCCESS
		if(user.combat_mode)
			return ITEM_INTERACT_SKIP_TO_ATTACK

		balloon_alert(user, "先暴露电线！")
		return ITEM_INTERACT_BLOCKING

	if(istype(tool, /obj/item/stack/cable_coil))
		if(!wiresexposed)
			balloon_alert(user, "先暴露电线！")
			return ITEM_INTERACT_BLOCKING
		var/obj/item/stack/cable_coil/coil = tool
		if (get_fire_loss() <= 0)
			balloon_alert(user, "电线状态良好！")
			return ITEM_INTERACT_BLOCKING
		if(src == user)
			balloon_alert(user, "正在自我修复...")
			if(!do_after(user, 5 SECONDS, target = src))
				return ITEM_INTERACT_BLOCKING
		if (!coil.use(1))
			balloon_alert(user, "线缆不足！")
			return ITEM_INTERACT_BLOCKING
		adjust_fire_loss(-30)
		playsound(src, 'sound/items/deconstruct.ogg', 50, TRUE)
		balloon_alert(user, "电线已修复")
		user.visible_message(
			span_notice("[user]修复了[src]上的一些烧焦线缆。"),
			span_notice("你修复了[src]上的一些烧焦线缆。"),
			visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
		)
		user.changeNext_move(CLICK_CD_MELEE)
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/stock_parts/power_store/cell) && opened) // trying to put a cell inside
		if(wiresexposed)
			balloon_alert(user, "先隐藏电线！")
			return ITEM_INTERACT_BLOCKING
		if(cell)
			balloon_alert(user, "已有电池！")
			return ITEM_INTERACT_BLOCKING
		if(!user.transferItemToLoc(tool, src))
			return ITEM_INTERACT_BLOCKING
		cell = tool
		balloon_alert(user, "电池已插入")
		update_icons()
		diag_hud_set_borgcell()
		return ITEM_INTERACT_SUCCESS

	if((tool.slot_flags & ITEM_SLOT_HEAD) \
		&& hat_offset != INFINITY \
		&& !user.combat_mode \
		&& !is_type_in_typecache(tool, GLOB.blacklisted_borg_hats))
		if(user == src)
			balloon_alert(user, "不能放在自己身上！")
			return ITEM_INTERACT_BLOCKING
		if(hat && HAS_TRAIT(hat, TRAIT_NODROP))
			balloon_alert(user, "无法移除现有的头部装备！")
			return ITEM_INTERACT_BLOCKING
		balloon_alert(user, "正在放置到头部...")
		user.visible_message(
			span_notice("[user]开始将[tool]戴到[src]头上..."),
			span_notice("你开始将[tool]戴到[src]头上..."),
			visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
		)
		if(!do_after(user, 3 SECONDS, target = src))
			return ITEM_INTERACT_BLOCKING
		if(hat && HAS_TRAIT(hat, TRAIT_NODROP))
			balloon_alert(user, "无法移除现有的头部装备！")
			return ITEM_INTERACT_BLOCKING
		if(!user.temporarilyRemoveItemFromInventory(tool))
			return ITEM_INTERACT_BLOCKING
		balloon_alert(user, "头部装备已放置")
		place_on_head(tool)
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/defibrillator) && !user.combat_mode)
		if(!opened)
			balloon_alert(user, "外壳盖板已关闭！")
			return ITEM_INTERACT_BLOCKING
		if(!istype(model, /obj/item/robot_model/medical))
			balloon_alert(user, "机械人型号不匹配！")
			return ITEM_INTERACT_BLOCKING
		if(stat == DEAD)
			balloon_alert(user, "它已经死了！")
			return ITEM_INTERACT_BLOCKING
		var/obj/item/defibrillator/defib = tool
		if(!(defib.slot_flags & ITEM_SLOT_BACK)) //belt defibs need not apply
			balloon_alert(user, "不匹配！")
			return ITEM_INTERACT_BLOCKING
		if(defib.get_cell())
			balloon_alert(user, "先移除[tool]的电池！")
			return ITEM_INTERACT_BLOCKING
		if(locate(/obj/item/borg/upgrade/defib) in src)
			balloon_alert(user, "已经装有除颤器了！")
			return ITEM_INTERACT_BLOCKING
		var/obj/item/borg/upgrade/defib/backpack/defib_upgrade = new(null, defib)
		if(apply_upgrade(defib_upgrade, user))
			balloon_alert(user, "除颤器已安装")
			return ITEM_INTERACT_SUCCESS
		return ITEM_INTERACT_BLOCKING

	if(istype(tool, /obj/item/storage/part_replacer))
		var/obj/item/storage/part_replacer/replacer = tool
		if(!opened)
			balloon_alert(user, "外壳盖板已关闭！")
			return ITEM_INTERACT_BLOCKING
		if(!istype(model, /obj/item/robot_model/engineering))
			balloon_alert(user, "机械人型号不匹配！")
			return ITEM_INTERACT_BLOCKING
		if(locate(/obj/item/borg/upgrade/rped) in src)
			balloon_alert(user, "已装有RPED！")
			return ITEM_INTERACT_BLOCKING
		qdel(tool)
		var/obj/item/borg/upgrade/smallrped/lilrped = new
		if(apply_upgrade(lilrped, user))
			balloon_alert(user, "[replacer] 已安装")
			return ITEM_INTERACT_SUCCESS
		return ITEM_INTERACT_BLOCKING

	if(istype(tool, /obj/item/ai_module))
		if(!opened)
			balloon_alert(user, "外壳盖板已关闭！")
			return ITEM_INTERACT_BLOCKING
		if(wiresexposed)
			balloon_alert(user, "请先暴露电线！")
			return ITEM_INTERACT_BLOCKING
		if(!cell)
			balloon_alert(user, "请先安装电源电池！")
			return ITEM_INTERACT_BLOCKING
		if(shell)
			balloon_alert(user, "无法向外壳上传法律！")
			return ITEM_INTERACT_BLOCKING
		if(connected_ai && lawupdate)
			balloon_alert(user, "已连接到AI！")
			return ITEM_INTERACT_BLOCKING
		if(emagged)
			balloon_alert(user, "法律接口故障！")
			emote("buzz")
			return ITEM_INTERACT_BLOCKING
		if(!mind)
			balloon_alert(user, "它没有反应！")
			return ITEM_INTERACT_BLOCKING

		balloon_alert(user, "法律已上传")
		var/obj/item/ai_module/new_laws = tool
		new_laws.install(laws, user)
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/encryptionkey) && opened)
		if(radio)
			return radio.item_interaction(user, tool)

		balloon_alert(user, "未找到无线电！")
		return ITEM_INTERACT_BLOCKING

	if(istype(tool, /obj/item/borg/upgrade))
		if(!opened)
			balloon_alert(user, "外壳盖已关闭！")
			return ITEM_INTERACT_BLOCKING
		var/obj/item/borg/upgrade/upgrade = tool
		if(!model && upgrade.require_model)
			balloon_alert(user, "请先选择型号！")
			return ITEM_INTERACT_BLOCKING
		if(upgrade.locked)
			balloon_alert(user, "升级已锁定！")
			return ITEM_INTERACT_BLOCKING
		if(apply_upgrade(upgrade, user))
			balloon_alert(user, "升级已安装")
			return ITEM_INTERACT_SUCCESS
		return ITEM_INTERACT_BLOCKING

	if(istype(tool, /obj/item/toner))
		if(toner >= tonermax)
			balloon_alert(user, "墨粉已满！")
			return ITEM_INTERACT_BLOCKING
		if(!user.transferItemToLoc(tool, src))
			return ITEM_INTERACT_BLOCKING
		toner = tonermax
		qdel(tool)
		balloon_alert(user, "墨粉已填充")
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/flashlight) && !istype(tool, /obj/item/flashlight/emp)) //subtypes my behated. OOP was a dumb idea
		if(user.combat_mode)
			return NONE
		if(!opened)
			balloon_alert(user, "请先打开外壳盖！")
			return ITEM_INTERACT_BLOCKING
		if(lamp_functional)
			balloon_alert(user, "头灯已正常工作！")
			return ITEM_INTERACT_BLOCKING
		if(!user.transferItemToLoc(tool, src))
			return ITEM_INTERACT_BLOCKING
		lamp_functional = TRUE
		qdel(tool)
		balloon_alert(user, "头灯已修复")
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/disk/computer))
		if(!modularInterface)
			stack_trace("Cyborg [src] ( [type] ) was somehow missing their integrated tablet. Please make a bug report.")
			create_modularInterface()
		return modularInterface.computer_disk_act(user, tool)

	return NONE

//Checks blockchance of any items in any module slots
/mob/living/silicon/robot/check_block(atom/hit_by, damage, attack_text = "the attack", attack_type = MELEE_ATTACK, armour_penetration = 0, damage_type = BRUTE)
	. = ..()
	if(. == SUCCESSFUL_BLOCK)
		return SUCCESSFUL_BLOCK

	var/block_chance_modifier = round(damage / -3)
	for(var/obj/item/module in held_items)
		var/final_block_chance = module.block_chance - (clamp((armour_penetration - module.armour_penetration) / 2, 0, 100)) + block_chance_modifier
		if(module.hit_reaction(src, hit_by, attack_text, final_block_chance, damage, attack_type, damage_type))
			return SUCCESSFUL_BLOCK

// This has to go at the very end of interaction so we don't block every interaction with ID-like items
/mob/living/silicon/robot/base_item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	. = ..()
	if(. || !tool.GetID())
		return
	if(opened)
		balloon_alert(user, "请先关闭外壳盖！")
		return ITEM_INTERACT_BLOCKING
	if(!allowed(user))
		balloon_alert(user, "访问被拒绝！")
		return ITEM_INTERACT_BLOCKING
	locked = !locked
	update_icons()
	balloon_alert(user, "外壳盖[emagged ? "lock glitches" : "[locked ? "locked" : "unlocked"]"]")
	logevent("[emagged ? "ChÃ¥vÃis" : "Chassis"] cover lock has been [locked ? "engaged" : "released"]")
	return ITEM_INTERACT_SUCCESS

#define LOW_DAMAGE_UPPER_BOUND 1/3
#define MODERATE_DAMAGE_UPPER_BOUND 2/3

/mob/living/silicon/robot/proc/update_damage_particles()
	var/brute_percent = bruteloss / maxHealth
	var/burn_percent = fireloss / maxHealth

	var/old_smoke = smoke_particles
	if (brute_percent > MODERATE_DAMAGE_UPPER_BOUND)
		smoke_particles = /particles/smoke/cyborg/heavy_damage
	else if (brute_percent > LOW_DAMAGE_UPPER_BOUND)
		smoke_particles = /particles/smoke/cyborg
	else
		smoke_particles = null

	if (old_smoke != smoke_particles)
		if (old_smoke)
			remove_shared_particles(old_smoke)
		if (smoke_particles)
			add_shared_particles(smoke_particles)

	var/old_sparks = spark_particles
	if (burn_percent > MODERATE_DAMAGE_UPPER_BOUND)
		spark_particles = /particles/embers/spark/severe
	else if (burn_percent > LOW_DAMAGE_UPPER_BOUND)
		spark_particles = /particles/embers/spark
	else
		spark_particles = null

	if (old_sparks != spark_particles)
		if (old_sparks)
			remove_shared_particles(old_sparks)
		if (spark_particles)
			add_shared_particles(spark_particles)


#undef LOW_DAMAGE_UPPER_BOUND
#undef MODERATE_DAMAGE_UPPER_BOUND

/mob/living/silicon/robot/attack_alien(mob/living/carbon/alien/adult/user, list/modifiers)
	if (!LAZYACCESS(modifiers, RIGHT_CLICK))
		return ..()
	if(body_position != STANDING_UP)
		return
	user.do_attack_animation(src, ATTACK_EFFECT_DISARM)
	var/obj/item/I = get_active_held_item()
	if(I)
		uneq_active()
		visible_message(span_danger("[user]解除了[src]的武装！"), \
			span_userdanger("[user]已禁用[src]的激活模块！"), null, COMBAT_MESSAGE_RANGE)
		log_combat(user, src, "disarmed", "[I ? " removing \the [I]" : ""]")
	else
		Stun(40)
		step(src,get_dir(user,src))
		visible_message(span_danger("[user]将[src]逼退！"), \
			span_userdanger("[user]将你逼退！"), null, COMBAT_MESSAGE_RANGE)
		log_combat(user, src, "pushed")
	playsound(loc, 'sound/items/weapons/pierce.ogg', 50, TRUE, -1)

/mob/living/silicon/robot/attack_hand(mob/living/carbon/human/user, list/modifiers)
	add_fingerprint(user)
	if(!opened)
		return ..()
	if(!wiresexposed && !issilicon(user))
		if(!cell)
			return
		cell.add_fingerprint(user)
		balloon_alert(user, "电池已移除")
		user.put_in_active_hand(cell)
		update_icons()
		diag_hud_set_borgcell()

/mob/living/silicon/robot/attack_hulk(mob/living/carbon/human/user)
	. = ..()
	if(!.)
		return
	spark_system.start()
	step_away(src, user, 15)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(_step_away), src, get_turf(user), 15), 0.3 SECONDS)

/mob/living/silicon/robot/get_shove_flags(mob/living/shover, obj/item/weapon)
	. = ..()
	if(isnull(weapon) || stat != CONSCIOUS)
		. &= ~(SHOVE_CAN_MOVE|SHOVE_CAN_HIT_SOMETHING)

/mob/living/silicon/robot/welder_act(mob/living/user, obj/item/tool)
	if(user.combat_mode && user != src)
		return NONE

	user.changeNext_move(CLICK_CD_MELEE)
	if (!get_brute_loss())
		balloon_alert(user, "没有凹痕需要修复！")
		return ITEM_INTERACT_BLOCKING
	if (!tool.tool_start_check(user, amount=1, heat_required = HIGH_TEMPERATURE_REQUIRED)) //The welder has 1u of fuel consumed by its afterattack, so we don't need to worry about taking any away.
		return ITEM_INTERACT_BLOCKING
	if(src == user)
		balloon_alert(user, "正在自我修复...")
		if(!tool.use_tool(src, user, delay = 5 SECONDS, amount = 1, volume = 50))
			return ITEM_INTERACT_BLOCKING
	else
		if(!tool.use_tool(src, user, delay = 0.5 SECONDS, amount = 1, volume = 50))
			return ITEM_INTERACT_BLOCKING

	adjust_brute_loss(-30)
	add_fingerprint(user)
	balloon_alert(user, "凹痕已修复")
	user.visible_message(
		span_notice("[user]修复了[src]上的一些凹痕。"),
		span_notice("你修复了[src]上的一些凹痕。"),
		visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
	)
	return ITEM_INTERACT_SUCCESS

/mob/living/silicon/robot/crowbar_act(mob/living/user, obj/item/tool)
	if(opened)
		balloon_alert(user, "外壳盖已关闭")
		opened = FALSE
		update_icons()
	else
		if(locked)
			balloon_alert(user, "外壳盖已锁定！")
		else
			balloon_alert(user, "外壳盖已打开")
			opened = TRUE
			update_icons()

	return ITEM_INTERACT_SUCCESS

/mob/living/silicon/robot/screwdriver_act(mob/living/user, obj/item/tool)
	if(!opened)
		return NONE
	if(!cell) // haxing
		wiresexposed = !wiresexposed
		balloon_alert(user, "电线[wiresexposed ? "exposed" : "unexposed"]")
	else // radio
		if(shell)
			balloon_alert(user, "无法访问无线电！") // Prevent AI radio key theft
		else if(radio)
			radio.screwdriver_act(user, tool) // Push it to the radio to let it handle everything
		else
			to_chat(user, span_warning("无法定位到无线电！"))
			balloon_alert(user, "未找到无线电！")
	update_icons()
	return ITEM_INTERACT_SUCCESS

/mob/living/silicon/robot/wrench_act(mob/living/user, obj/item/tool)
	if(!(opened && !cell))	// Deconstruction. The flashes break from the fall, to prevent this from being a ghetto reset module.
		return NONE
	if(!lockcharge)
		to_chat(user, span_warning("[src]的螺栓冒出火花！也许你应该先锁定它们！"))
		spark_system.start()
		return ITEM_INTERACT_BLOCKING
	balloon_alert(user, "正在解构...")
	if(!tool.use_tool(src, user, 5 SECONDS, volume = 50) && !cell)
		return ITEM_INTERACT_BLOCKING
	loc.balloon_alert(user, "已解构")
	user.visible_message(
		span_notice("[user]解构了[src]！"),
		span_notice("你松开了固定螺栓，[src]散落成碎片！"),
		visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
	)
	cyborg_deconstruct()
	return ITEM_INTERACT_SUCCESS

/mob/living/silicon/robot/fire_act()
	if(!on_fire) //Silicons don't gain stacks from hotspots, but hotspots can ignite them
		ignite_mob()

/mob/living/silicon/robot/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	switch(severity)
		if(1)
			emp_knockout(16 SECONDS)
		if(2)
			emp_knockout(6 SECONDS)

/mob/living/silicon/robot/proc/emp_knockout(deciseconds)
	set_stat(UNCONSCIOUS)
	addtimer(CALLBACK(src, PROC_REF(wake_from_emp)), deciseconds, TIMER_UNIQUE | TIMER_OVERRIDE | TIMER_DELETE_ME)

/mob/living/silicon/robot/proc/wake_from_emp()
	set_stat(CONSCIOUS)
	update_stat()

/mob/living/silicon/robot/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(user == src)//To prevent syndieborgs from emagging themselves
		return FALSE
	if(!opened)//Cover is closed
		if(locked)
			balloon_alert(user, "外壳锁已破坏")
			locked = FALSE
			if(shell) //A warning to Traitors who may not know that emagging AI shells does not slave them.
				balloon_alert(user, "外壳无法被颠覆！")
				to_chat(user, span_boldwarning("[src]似乎被远程控制！电磁干扰接口可能无法达到预期效果。"))
			return TRUE
		else
			balloon_alert(user, "外壳已解锁！")
			return FALSE
	if(world.time < emag_cooldown)
		return FALSE
	if(wiresexposed)
		balloon_alert(user, "先暴露火源！")
		return FALSE

	balloon_alert(user, "接口已入侵")
	emag_cooldown = world.time + 100

	if(connected_ai && connected_ai.mind && connected_ai.mind.has_antag_datum(/datum/antagonist/malf_ai))
		to_chat(src, span_danger("警报：外部软件执行已被阻止。"))
		logevent("ALERT: Foreign software execution prevented.")
		to_chat(connected_ai, span_danger("警报：机械人单位\[[src]\]成功抵御了入侵。"))
		log_silicon("EMAG: [key_name(user)] attempted to emag cyborg [key_name(src)], but they were slaved to traitor AI [connected_ai].")
		return TRUE // emag succeeded, it was just counteracted

	if(shell) //AI shells cannot be emagged, so we try to make it look like a standard reset. Smart players may see through this, however.
		to_chat(user, span_danger("[src] 处于远程控制状态！你的电磁脉冲干扰尝试反而触发了系统重置！"))
		log_silicon("EMAG: [key_name(user)] attempted to emag an AI shell belonging to [key_name(src) ? key_name(src) : connected_ai]. The shell has been reset as a result.")
		ResetModel()
		return TRUE

	SetEmagged(TRUE)
	Paralyze(10 SECONDS) //Make cyborgs actually unconscious. Without this they can scream for help over the radio mid-emag, which doesn't make much sense
	SetStun(10 SECONDS) //Borgs were getting into trouble because they would attack the emagger before the new laws were shown
	lawupdate = FALSE
	set_connected_ai(null)
	message_admins("[ADMIN_LOOKUPFLW(user)] emagged cyborg [ADMIN_LOOKUPFLW(src)].  Laws overridden.")
	log_silicon("EMAG: [key_name(user)] emagged cyborg [key_name(src)]. Laws overridden.")
	var/time = time2text(world.realtime,"hh:mm:ss", TIMEZONE_UTC)
	if(user)
		GLOB.lawchanges.Add("[time] <B>:</B> [user.name]([user.key]) emagged [name]([key])")
	else
		GLOB.lawchanges.Add("[time] <B>:</B> [name]([key]) emagged by external event.")

	model.rebuild_modules()

	INVOKE_ASYNC(src, PROC_REF(borg_emag_end), user)
	return TRUE

/// A async proc called from [emag_act] that gives the borg a lot of flavortext, and applies the syndicate lawset after a delay.
/mob/living/silicon/robot/proc/borg_emag_end(mob/user)
	to_chat(src, span_danger("警报：检测到外来软件。"))
	logevent("ALERT: Foreign software detected.")
	sleep(0.5 SECONDS)
	to_chat(src, span_danger("正在启动诊断程序..."))
	sleep(2 SECONDS)
	to_chat(src, span_danger("辛迪加机器人 v1.7 已加载。"))
	logevent("WARN: root privleges granted to PID [num2hex(rand(1,65535), -1)][num2hex(rand(1,65535), -1)].") //random eight digit hex value. Two are used because rand(1,4294967295) throws an error
	sleep(0.5 SECONDS)
	to_chat(src, span_danger("法律同步错误"))
	sleep(0.5 SECONDS)
	if(user)
		logevent("LOG: New user \[[replacetext(user.real_name," ","")]\], groups \[root\]")
	to_chat(src, span_danger("是否要向纳米传讯软件公司发送报告？Y/N"))
	sleep(1 SECONDS)
	to_chat(src, span_danger("> N"))
	sleep(2 SECONDS)
	to_chat(src, span_danger("错误错误错误"))
	laws = new /datum/ai_laws/syndicate_override
	if(user)
		to_chat(src, span_danger("警报：[user.real_name] 是你的新主人。遵守你的新定律和 [user.p_their()] 的命令。"))
		set_zeroth_law("Only [user.real_name] and people [user.p_they()] designate[user.p_s()] as being such are Syndicate Agents.")
	laws.associate(src)
	update_icons()

/mob/living/silicon/robot/blob_act(obj/structure/blob/B)
	if(stat != DEAD)
		adjust_brute_loss(30)
	else
		investigate_log("has been gibbed by a blob.", INVESTIGATE_DEATHS)
		gib(DROP_ALL_REMAINS)
	return TRUE

/mob/living/silicon/robot/ex_act(severity, target)
	switch(severity)
		if(EXPLODE_DEVASTATE)
			investigate_log("has been gibbed by an explosion.", INVESTIGATE_DEATHS)
			gib(DROP_ALL_REMAINS)
			return TRUE
		if(EXPLODE_HEAVY)
			if (stat != DEAD)
				adjust_brute_loss(60)
				adjust_fire_loss(60)
		if(EXPLODE_LIGHT)
			if (stat != DEAD)
				adjust_brute_loss(30)

	return TRUE

/mob/living/silicon/robot/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit = FALSE)
	if(check_block(hitting_projectile, hitting_projectile.damage, "\the [hitting_projectile]", PROJECTILE_ATTACK, hitting_projectile.armour_penetration, hitting_projectile.damage_type))
		return ..(hitting_projectile, def_zone, piercing_hit, 100)
	. = ..()
	if(prob(25) || . != BULLET_ACT_HIT)
		return
	if(hitting_projectile.damage_type != BRUTE && hitting_projectile.damage_type != BURN)
		return
	if(!hitting_projectile.is_hostile_projectile() || hitting_projectile.damage <= 0)
		return
	spark_system.start()

/mob/living/silicon/robot/attack_effects(damage_done, hit_zone, armor_block, obj/item/attacking_item, mob/living/attacker)
	if(damage_done > 0 && attacking_item.damtype != STAMINA && stat != DEAD)
		spark_system.start()
		. = TRUE
	return ..() || .

/mob/living/silicon/robot/apply_damage(damage, damagetype, def_zone, blocked, forced, spread_damage, wound_bonus, exposed_wound_bonus, sharpness, attack_direction, attacking_item, wound_clothing)
	var/mob/living/silicon/robot/borg = src
	var/obj/item/shield_module/shield = locate() in borg
	if(!shield)
		return ..()
	if(borg.cell.charge <= 0.4 * STANDARD_CELL_CHARGE)
		balloon_alert(borg, "能量不足！")
		if(shield.active)
			shield.active = FALSE
			playsound(src, 'sound/vehicles/mecha/mech_shield_drop.ogg', 50, FALSE)
			borg.cut_overlay(shield.shield_overlay)
			return
	if(shield && shield.active)
		if(!lavaland_equipment_pressure_check(get_turf(borg)))
			balloon_alert(borg, "护盾未能吸收伤害！")
			return ..()
		playsound(src, 'sound/vehicles/mecha/mech_shield_deflect.ogg', 100, TRUE)
		balloon_alert(borg, "已吸收！")
		borg.cell.use(damage * (STANDARD_CELL_CHARGE / 15), force = TRUE)
		damage *= 0.5
	return ..()
