/obj/machinery/deployable_healer
	name = "应急纳米治疗信标"
	desc = "向周围缓慢持续地释放纳米治疗药物，治疗其周围 3x3 格范围内的所有生物体损伤."

	anchored = TRUE
	use_power = NO_POWER_USE

	icon = 'modular_z121/icons/obj/deployable_healer.dmi'
	icon_state = "machinery"

	max_integrity = 25

	var/duration = 300 SECONDS
	var/interval = 2 SECONDS

	//	每次脉冲的治疗量
	var/heal_per_pulse = 1

	var/start_time

//	初始化时记录时间戳并注册定时器
/obj/machinery/deployable_healer/Initialize(mapload)
	. = ..()

	//	记录部署时的时间戳并播放部署音效
	start_time = world.time
	playsound(src, 'sound/machines/synth/synth_yes.ogg', 25, TRUE)

	//	启动治疗循环与关闭计时器
	addtimer(CALLBACK(src, /obj/machinery/deployable_healer/proc/heal_pulse), interval)
	addtimer(CALLBACK(src, /obj/machinery/deployable_healer/proc/finished), duration)

	//	让信标发出蓝色荧光
	set_light(1, 3, "#36C5F4")

//	获取目标的伤害类型
/obj/machinery/deployable_healer/proc/get_priority_damage_type(mob/living/carbon/M)
	// 获取所有伤害值
	var/brute = M.getBruteLoss()
	var/burn = M.getFireLoss()
	var/tox = M.getToxLoss()
	var/oxy = M.getOxyLoss()

	// 找出最大伤害值
	var/max_damage = max(brute, burn, tox, oxy)

	// 如果没有伤害，返回null
	if(max_damage <= 0)
		return null

	// 收集所有达到最大伤害值的类型
	var/list/priority_types = list()
	if(brute == max_damage)
		priority_types += BRUTE
	if(burn == max_damage)
		priority_types += BURN
	if(tox == max_damage)
		priority_types += TOX
	if(oxy == max_damage)
		priority_types += OXY

	// 随机选择一个最高伤害类型（如果有多个相同值）
	return pick(priority_types)

//	每次间隔结束后，尝试对范围内的玩家进行治疗
/obj/machinery/deployable_healer/proc/heal_pulse()
	//	如果已经被删除，那么直接返回
	if (QDELETED(src))
		return

	//	查找 3x3 范围内的所有实体
	//	如果是碳基生物且未死亡，则进行治疗
	for (var/mob/living/L in view(1, src))
		//	如果目标死亡，则不考虑
		if (L.stat == DEAD)
			continue

		//	如果不是碳基生物，则不考虑
		if (!istype(L, /mob/living/carbon))
			continue

		//	获取目标目前所有的伤害类型
		//	若为空则不治疗
		var/chosen_type = get_priority_damage_type(L)
		if (!chosen_type)
			continue

		heal_mob(L, chosen_type)

	//	播放治疗音效
	playsound(src, 'sound/items/healthanalyzer.ogg', 25, TRUE)

	if (world.time < start_time + duration)
		//	（逻辑意义上的）链式调用
		addtimer(CALLBACK(src, /obj/machinery/deployable_healer/proc/heal_pulse), interval)

//	实际治疗目标的函数
/obj/machinery/deployable_healer/proc/heal_mob(mob/living/carbon/M, var/chosen_type)
	switch(chosen_type)
		if(BRUTE)
			M.adjustBruteLoss(-heal_per_pulse)
		if(BURN)
			M.adjustFireLoss(-heal_per_pulse)
		if(TOX)
			M.adjustToxLoss(-heal_per_pulse, forced = TRUE)
		if(OXY)
			M.adjustOxyLoss(-heal_per_pulse)

	//	播放治疗效果
	var/obj/effect/temp_visual/heal/heal_effect = new(get_turf(M))
	heal_effect.color = "#36C5F4"

/obj/machinery/deployable_healer/proc/finished()
	if (QDELETED(src))
		return

	//	播放关闭音效并播放粒子动画
	playsound(src, 'sound/machines/steam_hiss.ogg', 25, TRUE)
	new /obj/effect/temp_visual/nano_smoke(get_turf(src))

	//	提示其他人纳米治疗仪已经用尽
	visible_message(span_warning("[src]发出一阵柔和的嗡鸣声，化作纳米云消散在空气中..."))

	//	在原地留下灰烬
	new /obj/effect/decal/cleanable/ash(get_turf(src))

	qdel(src)

/obj/machinery/deployable_healer/Destroy(force)
	. = ..()

//	销毁时释放的粒子动画
/obj/effect/temp_visual/nano_smoke
    icon = 'icons/effects/effects.dmi'
    icon_state = "shieldsparkles"
    duration = 70
    layer = BELOW_MOB_LAYER
    color = "#36C5F4"
