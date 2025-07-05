/obj/machinery/deployable_healer
	name = "应急纳米治疗信标"
	desc = "向周围缓慢持续地释放纳米治疗药物，治疗其周围 3x3 格范围内的所有生物体损伤."

	anchored = TRUE
	use_power = NO_POWER_USE

	icon = 'modular_nova/modules/medical/icons/obj/machinery.dmi'
	icon_state = "breath_machine"

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

	//	让信标发出绿色荧光
	set_light(1, 1.5, LIGHT_COLOR_GREEN)

//	获取目标的伤害类型
/obj/machinery/deployable_healer/proc/get_damage_types(mob/living/carbon/M)
	var/list/damage_types = list()

	//	根据是否存在伤害获取伤害类型
	if(M.getBruteLoss() > 0)
		damage_types += BRUTE
	if(M.getFireLoss() > 0)
		damage_types += BURN
	if(M.getToxLoss() > 0)
		damage_types += TOX
	if(M.getOxyLoss() > 0)
		damage_types += OXY

	return damage_types

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
		var/list/damage_types = get_damage_types(L)
		if (!length(damage_types))
			continue

		heal_mob(L, pick(damage_types))

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
	new /obj/effect/temp_visual/heal(get_turf(M))
	to_chat(M, span_notice("纳米机器人修复了你的[chosen_type]伤害"))

/obj/machinery/deployable_healer/proc/finished()
	if (QDELETED(src))
		return

	//	提示其他人纳米治疗仪已经用尽
	visible_message(span_warning("[src] 发出一阵嗡鸣声，化作纳米粉尘消散了！"))

	//	播放销毁音效以及效果，并留下灰烬
	playsound(src, 'sound/effects/sparks/sparks4.ogg', 25, TRUE)
	do_admin_sparks(5, TRUE, src)
	new /obj/effect/decal/cleanable/ash(get_turf(src))

	qdel(src)

/obj/machinery/deployable_healer/Destroy(force)
	. = ..()
