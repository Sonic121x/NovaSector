/obj/item/reactive_armor_shell
	name = "反应装甲外壳"
	desc = "一套实验性装甲，等待安装异常核心。"
	icon_state = "reactiveoff"
	icon = 'icons/obj/clothing/suits/armor.dmi'
	w_class = WEIGHT_CLASS_BULKY

/obj/item/reactive_armor_shell/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	. = ..()
	var/static/list/anomaly_armour_types = list(
		/obj/effect/anomaly/grav = /obj/item/clothing/suit/armor/reactive/repulse,
		/obj/effect/anomaly/flux = /obj/item/clothing/suit/armor/reactive/tesla,
		/obj/effect/anomaly/bluespace = /obj/item/clothing/suit/armor/reactive/teleport,
		/obj/effect/anomaly/bioscrambler = /obj/item/clothing/suit/armor/reactive/bioscrambling,
		/obj/effect/anomaly/hallucination = /obj/item/clothing/suit/armor/reactive/hallucinating,
		/obj/effect/anomaly/dimensional = /obj/item/clothing/suit/armor/reactive/barricade,
		/obj/effect/anomaly/ectoplasm = /obj/item/clothing/suit/armor/reactive/ectoplasm,
		/obj/effect/anomaly/weather = /obj/item/clothing/suit/armor/reactive/weather,
	)

	if(istype(tool, /obj/item/assembly/signaler/anomaly))
		var/obj/item/assembly/signaler/anomaly/anomaly = tool
		var/armour_path = is_path_in_list(anomaly.anomaly_type, anomaly_armour_types, TRUE)
		if(!armour_path)
			armour_path = /obj/item/clothing/suit/armor/reactive/stealth //Lets not cheat the player if an anomaly type doesnt have its own armour coded
		to_chat(user, span_notice("你将[anomaly]插入胸甲，装甲随之轻柔地嗡鸣启动。"))
		new armour_path(get_turf(src))
		qdel(src)
		qdel(anomaly)
		return ITEM_INTERACT_SUCCESS

//Reactive armor
/obj/item/clothing/suit/armor/reactive
	name = "反应装甲"
	desc = "不知道为什么，好像没什么用。"
	icon_state = "reactiveoff"
	inhand_icon_state = null
	blood_overlay_type = "armor"
	armor_type = /datum/armor/armor_reactive
	actions_types = list(/datum/action/item_action/toggle)
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	hit_reaction_chance = 50
	///Whether the armor will try to react to hits (is it on)
	var/active = FALSE
	///This will be true for 30 seconds after an EMP, it makes the reaction effect dangerous to the user.
	var/bad_effect = FALSE
	///Message sent when the armor is emp'd. It is not the message for when the emp effect goes off.
	var/emp_message = span_warning("反应装甲被电磁脉冲击中了！该死，现在它真的啥也干不了了！")
	///Message sent when the armor is still on cooldown, but activates.
	var/cooldown_message = span_danger("反应装甲没起什么作用，因为它正在充能！充什么能？只有反应装甲自己知道。")
	///Duration of the cooldown specific to reactive armor for when it can activate again.
	var/reactivearmor_cooldown_duration = 10 SECONDS
	///The cooldown itself of the reactive armor for when it can activate again.
	var/reactivearmor_cooldown = 0

/datum/armor/armor_reactive
	fire = 100
	acid = 100

/obj/item/clothing/suit/armor/reactive/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/clothing/suit/armor/reactive/update_icon_state()
	. = ..()
	icon_state = "reactive[active ? null : "off"]"

/obj/item/clothing/suit/armor/reactive/attack_self(mob/user)
	active = !active
	to_chat(user, span_notice("[src] 现在是 [active ? "active" : "inactive"]状态。"))
	update_icon()
	add_fingerprint(user)

/obj/item/clothing/suit/armor/reactive/hit_reaction(owner, hitby, attack_text, final_block_chance, damage, attack_type, damage_type = BRUTE)
	if(!active || !prob(hit_reaction_chance))
		return FALSE
	if(world.time < reactivearmor_cooldown)
		cooldown_activation(owner)
		return FALSE
	if(bad_effect)
		return emp_activation(owner, hitby, attack_text, final_block_chance, damage, attack_type)
	else
		return reactive_activation(owner, hitby, attack_text, final_block_chance, damage, attack_type)

/**
 * A proc for doing cooldown effects (like the sparks on the tesla armor, or the semi-stealth on stealth armor)
 * Called from the suit activating whilst on cooldown.
 * You should be calling ..()
 */
/obj/item/clothing/suit/armor/reactive/proc/cooldown_activation(mob/living/carbon/human/owner)
	owner.visible_message(cooldown_message)

/**
 * A proc for doing reactive armor effects.
 * Called from the suit activating while off cooldown, with no emp.
 * Returning TRUE will block the attack that triggered this
 */
/obj/item/clothing/suit/armor/reactive/proc/reactive_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	owner.visible_message(span_danger("反应装甲没起什么作用！毫不意外。"))
	return TRUE

/**
 * A proc for doing owner unfriendly reactive armor effects.
 * Called from the suit activating while off cooldown, while the armor is still suffering from the effect of an EMP.
 * Returning TRUE will block the attack that triggered this
 */
/obj/item/clothing/suit/armor/reactive/proc/emp_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	owner.visible_message(span_danger("反应装甲没起什么作用，尽管被电磁脉冲击中了！当然，除了显示一条特殊消息之外。"))
	return TRUE

/obj/item/clothing/suit/armor/reactive/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF || bad_effect || !active) //didn't get hit or already emp'd, or off
		return
	visible_message(emp_message)
	bad_effect = TRUE
	addtimer(VARSET_CALLBACK(src, bad_effect, FALSE), 30 SECONDS)

//When the wearer gets hit, this armor will teleport the user a short distance away (to safety or to more danger, no one knows. That's the fun of it!)
/obj/item/clothing/suit/armor/reactive/teleport
	name = "反应传送装甲"
	desc = "有人把我们的研究主任和他自己的脑袋分开了！"
	emp_message = span_warning("反应装甲的传送计算开始报错！")
	cooldown_message = span_danger("反应传送系统仍在充能！它未能激活！")
	reactivearmor_cooldown_duration = 10 SECONDS
	var/tele_range = 6

/obj/item/clothing/suit/armor/reactive/teleport/reactive_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	owner.visible_message(span_danger("反应传送系统将 [owner] 从 [attack_text] 中抛飞出去！"))
	playsound(get_turf(owner),'sound/effects/magic/blink.ogg', 100, TRUE)
	do_teleport(owner, get_turf(owner), tele_range, no_effects = TRUE, channel = TELEPORT_CHANNEL_BLUESPACE)
	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return TRUE

/obj/item/clothing/suit/armor/reactive/teleport/emp_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	owner.visible_message(span_danger("反应传送系统将自己从 [attack_text] 中抛飞出去，过程中把某人留在了原地！"))
	owner.dropItemToGround(src, TRUE, TRUE)
	playsound(get_turf(owner),'sound/machines/buzz/buzz-sigh.ogg', 50, TRUE)
	playsound(get_turf(owner),'sound/effects/magic/blink.ogg', 100, TRUE)
	do_teleport(src, get_turf(owner), tele_range, no_effects = TRUE, channel = TELEPORT_CHANNEL_BLUESPACE)
	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return FALSE //you didn't actually evade the attack now did you

//Fire

/obj/item/clothing/suit/armor/reactive/fire
	name = "反应燃烧装甲"
	desc = "一种实验性的盔甲，内置的传感器与火焰喷射器连接，专为那些酷爱燃烧的人量身定制。"
	cooldown_message = span_danger("反应燃烧装甲激活了，但未能喷出火焰，因为它的火焰喷射器仍在充能！")
	emp_message = span_warning("反应燃烧装甲的瞄准系统开始重启...")

/obj/item/clothing/suit/armor/reactive/fire/reactive_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	owner.visible_message(span_danger("[src] 格挡了 [attack_text]，并喷出火焰！"))
	playsound(get_turf(owner),'sound/effects/magic/fireball.ogg', 100, TRUE)
	for(var/mob/living/carbon/carbon_victim in range(6, get_turf(src)))
		if(carbon_victim != owner)
			carbon_victim.adjust_fire_stacks(8)
			carbon_victim.ignite_mob()
	owner.set_wet_stacks(20)
	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return TRUE

/obj/item/clothing/suit/armor/reactive/fire/emp_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	owner.visible_message(span_danger("[src] 只是让 [attack_text] 变得更糟，因为它向 [owner] 喷出了熔融的死亡！"))
	playsound(get_turf(owner),'sound/effects/magic/fireball.ogg', 100, TRUE)
	owner.adjust_fire_stacks(12)
	owner.ignite_mob()
	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return FALSE

//Stealth

/obj/item/clothing/suit/armor/reactive/stealth
	name = "反应隐身装甲"
	desc = "一种实验性的盔甲，检测到危险时会使使用者隐身，并产生一个会随机运动的使用者假象，敌人无法与一个看不见的东西对抗。"
	cooldown_message = span_danger("反应隐形系统激活了，但充能不足，无法完全隐形！")
	emp_message = span_warning("反应隐形装甲的威胁评估系统崩溃了...")
	///when triggering while on cooldown will only flicker the alpha slightly. this is how much it removes.
	var/cooldown_alpha_removal = 50
	///cooldown alpha flicker- how long it takes to return to the original alpha
	var/cooldown_animation_time = 3 SECONDS
	///how long they will be fully stealthed
	var/stealth_time = 4 SECONDS
	///how long it will animate back the alpha to the original
	var/animation_time = 2 SECONDS
	var/in_stealth = FALSE

/obj/item/clothing/suit/armor/reactive/stealth/cooldown_activation(mob/living/carbon/human/owner)
	if(in_stealth)
		return //we don't want the cooldown message either)
	owner.alpha = max(0, owner.alpha - cooldown_alpha_removal)
	animate(owner, alpha = initial(owner.alpha), time = cooldown_animation_time)
	..()

/obj/item/clothing/suit/armor/reactive/stealth/reactive_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	var/mob/living/basic/illusion/escape/decoy = new(owner.loc)
	decoy.full_setup(
		owner,
		target_mob = owner,
		life = 5 SECONDS,
		hp = owner.health / 4,
		damage = 5,
		replicate = 0,
	)
	owner.alpha = 0
	in_stealth = TRUE
	owner.visible_message(span_danger("[owner] 的胸部被 [attack_text] 击中了！")) //We pretend to be hit, since blocking it would stop the message otherwise
	addtimer(CALLBACK(src, PROC_REF(end_stealth), owner), stealth_time)
	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return TRUE

/obj/item/clothing/suit/armor/reactive/stealth/proc/end_stealth(mob/living/carbon/human/owner)
	in_stealth = FALSE
	animate(owner, alpha = initial(owner.alpha), time = animation_time)

/obj/item/clothing/suit/armor/reactive/stealth/emp_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(!isliving(hitby))
		return FALSE //it just doesn't activate
	var/mob/living/attacker = hitby
	owner.visible_message(span_danger("[src] 激活了，但隐形了错误的人！"))
	attacker.alpha = 0
	addtimer(VARSET_CALLBACK(attacker, alpha, initial(attacker.alpha)), 4 SECONDS)
	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return FALSE

//Tesla

/obj/item/clothing/suit/armor/reactive/tesla
	name = "反应特斯拉装甲"
	desc = "一种实验性的盔甲，内置了灵敏传感器，并与一个巨大的电容器相连,其表面还布满了发射器。"
	siemens_coefficient = -1
	cooldown_message = span_danger("反应特斯拉装甲上的特斯拉电容器仍在充能！装甲只是冒出了一些火花。")
	emp_message = span_warning("特斯拉电容器发出不祥的哔哔声。")
	clothing_traits = list(TRAIT_TESLA_SHOCKIMMUNE)
	/// How strong are the zaps we give off?
	var/zap_power = 2.5e4
	/// How far to the zaps we give off go?
	var/zap_range = 20
	/// What flags do we pass to the zaps we give off?
	var/zap_flags = ZAP_MOB_DAMAGE | ZAP_OBJ_DAMAGE

/obj/item/clothing/suit/armor/reactive/tesla/cooldown_activation(mob/living/carbon/human/owner)
	do_sparks(1, TRUE, src)
	..()

/obj/item/clothing/suit/armor/reactive/tesla/reactive_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	owner.visible_message(span_danger("[src] 格挡了 [attack_text]，并释放出闪电弧！"))
	tesla_zap(source = owner, zap_range = zap_range, power = zap_power, cutoff = 1e3, zap_flags = zap_flags)
	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return TRUE

/obj/item/clothing/suit/armor/reactive/tesla/emp_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	owner.visible_message(span_danger("[src] 格挡了 [attack_text]，但从周围环境中向 [owner] 汲取了大量能量！"))
	REMOVE_CLOTHING_TRAIT(owner, TRAIT_TESLA_SHOCKIMMUNE) //oops! can't shock without this!
	electrocute_mob(owner, get_area(src), src, 1)
	ADD_CLOTHING_TRAIT(owner, TRAIT_TESLA_SHOCKIMMUNE)
	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return TRUE

//Repulse

/obj/item/clothing/suit/armor/reactive/repulse
	name = "反应击退装甲"
	desc = "一套实验性盔甲，可以猛烈的击退攻击者。"
	cooldown_message = span_danger("斥力发生器仍在充能！它未能产生足够强大的波！")
	emp_message = span_warning("斥力发生器已重置为默认设置...")
	var/repulse_force = MOVE_FORCE_EXTREMELY_STRONG

/obj/item/clothing/suit/armor/reactive/repulse/reactive_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	playsound(get_turf(owner),'sound/effects/magic/repulse.ogg', 100, TRUE)
	owner.visible_message(span_danger("[src] 格挡了 [attack_text]，将攻击转化为一股力场波！"))
	var/turf/owner_turf = get_turf(owner)
	var/list/thrown_items = list()
	for(var/atom/movable/repulsed in range(owner_turf, 7))
		if(repulsed == owner || repulsed.anchored || thrown_items[repulsed])
			continue
		var/throwtarget = get_edge_target_turf(owner_turf, get_dir(owner_turf, get_step_away(repulsed, owner_turf)))
		repulsed.safe_throw_at(throwtarget, 10, 1, force = repulse_force)
		thrown_items[repulsed] = repulsed

	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return TRUE

/obj/item/clothing/suit/armor/reactive/repulse/emp_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	playsound(get_turf(owner),'sound/effects/magic/repulse.ogg', 100, TRUE)
	owner.visible_message(span_danger("[src] 未能格挡 [attack_text]，反而产生了一股吸引力！"))
	var/turf/owner_turf = get_turf(owner)
	var/list/thrown_items = list()
	for(var/atom/movable/repulsed in range(owner_turf, 7))
		if(repulsed == owner || repulsed.anchored || thrown_items[repulsed])
			continue
		repulsed.safe_throw_at(owner, 10, 1, force = repulse_force)
		thrown_items[repulsed] = repulsed

	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return FALSE

/obj/item/clothing/suit/armor/reactive/table
	name = "反应桌式装甲"
	desc = "如果你喜欢上桌吃饭，那就来吧！！"
	cooldown_message = span_danger("反应式桌甲制造器仍在冷却中！")
	emp_message = span_danger("反应式桌甲的制造器咔哒作响并发出不祥的嗡鸣声...")
	var/tele_range = 10

/obj/item/clothing/suit/armor/reactive/table/reactive_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	owner.visible_message(span_danger("反应式传送系统将 [owner] 从 [attack_text] 旁弹开，并将 [owner.p_them()] 猛摔到一张人造桌子上！"))
	owner.visible_message("<font color='red' size='3'>[owner] GOES ON THE TABLE!!!</font>")
	owner.Knockdown(30)
	owner.apply_damage(10, BRUTE)
	owner.apply_damage(40, STAMINA)
	playsound(owner, 'sound/effects/tableslam.ogg', 90, TRUE)
	owner.add_mood_event("table", /datum/mood_event/table)
	do_teleport(owner, get_turf(owner), tele_range, no_effects = TRUE, channel = TELEPORT_CHANNEL_BLUESPACE)
	new /obj/structure/table(get_turf(owner))
	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return TRUE

/obj/item/clothing/suit/armor/reactive/table/emp_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	owner.visible_message(span_danger("反应式传送系统将 [owner] 从 [attack_text] 旁弹开，并将 [owner.p_them()] 猛摔到一张人造玻璃桌子上！"))
	owner.visible_message("<font color='red' size='3'>[owner] GOES ON THE GLASS TABLE!!!</font>")
	do_teleport(owner, get_turf(owner), tele_range, no_effects = TRUE, channel = TELEPORT_CHANNEL_BLUESPACE)
	var/obj/structure/table/glass/shattering_table = new /obj/structure/table/glass(get_turf(owner))
	shattering_table.table_shatter(owner)

	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return TRUE

//Hallucinating

/obj/item/clothing/suit/armor/reactive/hallucinating
	name = "反应幻惑装甲"
	desc = "这是一件实验性的盔甲，它的敏感探测器连接到穿戴者的思想上，发送思维脉冲，在你周围引发幻觉。"
	cooldown_message = span_danger("连接目前不同步... 重新校准中。")
	emp_message = span_warning("你感觉到一股心灵脉冲的回涌。")
	clothing_traits = list(TRAIT_MADNESS_IMMUNE)

/obj/item/clothing/suit/armor/reactive/hallucinating/cooldown_activation(mob/living/carbon/human/owner)
	do_sparks(1, TRUE, src)
	return ..()

/obj/item/clothing/suit/armor/reactive/hallucinating/reactive_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	owner.visible_message(span_danger("[src] 格挡了 [attack_text]，并释放出心灵脉冲！"))
	visible_hallucination_pulse(
		center = get_turf(owner),
		radius = 3,
		hallucination_duration = 50 SECONDS,
		hallucination_max_duration = 300 SECONDS,
	)
	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return TRUE

/obj/item/clothing/suit/armor/reactive/hallucinating/emp_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	owner.visible_message(span_danger("[src] 格挡了 [attack_text]，但从周围环境中向 [owner] 汲取了大量心灵能量！"))
	owner.adjust_hallucinations_up_to(50 SECONDS, 240 SECONDS)
	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return TRUE

//Bioscrambling
/obj/item/clothing/suit/armor/reactive/bioscrambling
	name = "反应生物扰乱装甲"
	desc = "一种实验性的盔甲，内置了灵敏传感器，并与一个生物危害阀相连，这套盔甲可以让周围人的身体发生变形。"
	cooldown_message = span_danger("连接目前不同步... 重新校准中。")
	emp_message = span_warning("你感觉到盔甲在蠕动。")
	///Range of the effect.
	var/range = 5
	///Lists for zones and bodyparts to swap and randomize
	var/static/list/zones = list(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
	var/static/list/chests
	var/static/list/heads
	var/static/list/l_arms
	var/static/list/r_arms
	var/static/list/l_legs
	var/static/list/r_legs

/obj/item/clothing/suit/armor/reactive/bioscrambling/Initialize(mapload)
	. = ..()
	if(!chests)
		chests = typesof(/obj/item/bodypart/chest)
	if(!heads)
		heads = typesof(/obj/item/bodypart/head)
	if(!l_arms)
		l_arms = typesof(/obj/item/bodypart/arm/left)
	if(!r_arms)
		r_arms = typesof(/obj/item/bodypart/arm/right)
	if(!l_legs)
		l_legs = typesof(/obj/item/bodypart/leg/left)
	if(!r_legs)
		r_legs = typesof(/obj/item/bodypart/leg/right)

/obj/item/clothing/suit/armor/reactive/bioscrambling/cooldown_activation(mob/living/carbon/human/owner)
	do_sparks(1, TRUE, src)
	..()

/obj/item/clothing/suit/armor/reactive/bioscrambling/reactive_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	owner.visible_message(span_danger("[src] 格挡了 [attack_text]，生物危害身体扰乱已释放！"))
	bioscrambler_pulse(owner, FALSE)
	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return TRUE

/obj/item/clothing/suit/armor/reactive/bioscrambling/emp_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	owner.visible_message(span_danger("[src] 格挡了 [attack_text]，但从周围环境中向 [owner] 汲取了大量生物危害物质！"))
	bioscrambler_pulse(owner, TRUE)
	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return TRUE

/obj/item/clothing/suit/armor/reactive/bioscrambling/proc/bioscrambler_pulse(mob/living/carbon/human/owner, can_hit_owner = FALSE)
	for(var/mob/living/carbon/nearby in range(range, get_turf(src)))
		if(!can_hit_owner && nearby == owner)
			continue
		nearby.bioscramble(name)

// When the wearer gets hit, this armor will push people nearby and spawn some blocking objects.
/obj/item/clothing/suit/armor/reactive/barricade
	name = "环境反应装甲"
	desc = "一套实验性的盔甲，当它探测到它的使用者处于危险中时，会从异化周围的世界并产生屏障。"
	emp_message = span_warning("反应装甲的维度坐标被扰乱了！")
	cooldown_message = span_danger("反应屏障系统仍在充能！激活失败！")
	reactivearmor_cooldown_duration = 10 SECONDS

/obj/item/clothing/suit/armor/reactive/barricade/reactive_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	playsound(get_turf(owner),'sound/effects/magic/repulse.ogg', 100, TRUE)
	owner.visible_message(span_danger("反应装甲在[src]与[attack_text]之间插入了来自另一个世界的物质！"))
	for (var/atom/movable/target in repulse_targets(owner))
		repulse(target, owner)

	var/datum/armour_dimensional_theme/theme = new()
	theme.apply_random(get_turf(owner), dangerous = FALSE)
	qdel(theme)

	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return TRUE

/**
 * Returns a list of all atoms around the source which can be moved away from it.
 *
 * Arguments
 * * source - Thing to try to move things away from.
 */
/obj/item/clothing/suit/armor/reactive/barricade/proc/repulse_targets(atom/source)
	var/list/push_targets = list()
	for (var/atom/movable/nearby_movable in view(1, source))
		if(nearby_movable == source)
			continue
		if(nearby_movable.anchored)
			continue
		push_targets += nearby_movable
	return push_targets

/**
 * Pushes something one tile away from the source.
 *
 * Arguments
 * * victim - Thing being moved.
 * * source - Thing to move it away from.
 */
/obj/item/clothing/suit/armor/reactive/barricade/proc/repulse(atom/movable/victim, atom/source)
	var/dist_from_caster = get_dist(victim, source)

	if(dist_from_caster == 0)
		return

	if (isliving(victim))
		to_chat(victim, span_userdanger("你被一股压力波震退了！"))
	var/turf/throwtarget = get_edge_target_turf(source, get_dir(source, get_step_away(victim, source, 1)))
	victim.safe_throw_at(throwtarget, 1, 1, source, force = MOVE_FORCE_EXTREMELY_STRONG)

/obj/item/clothing/suit/armor/reactive/barricade/emp_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	owner.visible_message(span_danger("反应装甲从某个不稳定的维度转移了物质！"))
	var/datum/armour_dimensional_theme/theme = new()
	theme.apply_random(get_turf(owner), dangerous = TRUE)
	qdel(theme)
	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return FALSE

/obj/item/clothing/suit/armor/reactive/ectoplasm
	name = "反应附身装甲"
	desc = "一套实验性装甲，能够通过幽灵附身激活附近的物体。"
	emp_message = span_warning("反应装甲发出一阵可怕的噪音，幽灵般的低语在你耳边回响……")
	cooldown_message = span_danger("灵质矩阵失衡。请等待校准完成！")
	reactivearmor_cooldown_duration = 40 SECONDS

/obj/item/clothing/suit/armor/reactive/ectoplasm/reactive_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	playsound(get_turf(owner),'sound/effects/hallucinations/veryfar_noise.ogg', 100, TRUE)
	owner.visible_message(span_danger("[src]释放出一股异界能量！"))

	haunt_outburst(epicenter = get_turf(owner), range = 5, haunt_chance = 85, duration = 30 SECONDS)

	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return TRUE

/obj/item/clothing/suit/armor/reactive/ectoplasm/emp_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	owner.reagents?.add_reagent(/datum/reagent/inverse/helgrasp, 20)

/obj/item/clothing/suit/armor/reactive/weather
	name = "反应天气装甲"
	desc = "一套实验性装甲，能在穿戴者遇到危险时操控周围的天气。"
	emp_message = span_warning("反应装甲的天气控制单元发出噼啪声和呻吟……")
	cooldown_message = span_danger("反应天气系统仍在充能！激活失败！")
	reactivearmor_cooldown_duration = 30 SECONDS

/obj/item/clothing/suit/armor/reactive/weather/reactive_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	owner.visible_message(span_danger("反应装甲改变了[owner]周围的天气，保护[owner.p_them()]免受[attack_text]的伤害！"))
	playsound(src, 'sound/effects/magic/lightningshock.ogg', 33, TRUE, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)

	var/datum/effect_system/basic/steam_spread/steam = new(owner.loc, 10, FALSE)
	steam.start()

	var/list/affected_turfs = list()
	for(var/mob/living/attacker in oview(2, owner))
		attacker.adjust_wet_stacks(5)
		attacker.extinguish_mob()
		if((attacker.loc in affected_turfs) || !isopenturf(attacker.loc))
			continue

		for(var/turf/open/to_affect in view(1, attacker.loc))
			affected_turfs += to_affect

		shock_turf_windup(attacker.loc)

	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return TRUE

/obj/item/clothing/suit/armor/reactive/weather/emp_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text, final_block_chance, damage, attack_type)
	owner.visible_message(span_danger("反应装甲发生故障，在[owner.p_them()]上方召唤了一场风暴！"))
	playsound(src, 'sound/effects/magic/lightningshock.ogg', 33, TRUE, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)

	var/datum/effect_system/basic/steam_spread/steam = new(owner.loc, 2, FALSE)
	steam.start()

	owner.adjust_wet_stacks(10)
	owner.extinguish_mob()
	if(!isopenturf(owner.loc))
		return
	shock_turf_windup(owner.loc)

/obj/item/clothing/suit/armor/reactive/weather/proc/shock_turf_windup(turf/target)
	new /obj/effect/temp_visual/telegraphing/thunderbolt(target)
	addtimer(CALLBACK(src, PROC_REF(shock_turf), target), 1 SECONDS)

/obj/item/clothing/suit/armor/reactive/weather/proc/shock_turf(turf/target)
	playsound(target, 'sound/effects/magic/lightningbolt.ogg', 66, TRUE)
	new /obj/effect/temp_visual/thunderbolt(target)
	for(var/turf/open/adjacent_turf in oview(1, target))
		new /obj/effect/temp_visual/electricity(adjacent_turf)

	for(var/mob/living/hit_mob in target)
		if(hit_mob == loc) // avoid hitting the wearer
			continue
		to_chat(hit_mob, span_userdanger("你被闪电击中了！"))
		hit_mob.electrocute_act(30, src, flags = SHOCK_TESLA|SHOCK_NOSTUN)
		hit_mob.Knockdown(2.5 SECONDS, 10 SECONDS)

	for(var/mob/living/nearby_target in oview(1, target))
		if(nearby_target == loc) // avoid hitting the wearer
			continue
		to_chat(nearby_target, span_userdanger("你被一道闪电弧击中了！"))
		nearby_target.electrocute_act(10, src, flags = SHOCK_TESLA|SHOCK_NOSTUN)

	for(var/obj/hit_thing in target)
		hit_thing.take_damage(20, BURN, ENERGY, FALSE)

	for(var/obj/nearby_thing in oview(1, target))
		nearby_thing.take_damage(5, BURN, ENERGY, FALSE)
