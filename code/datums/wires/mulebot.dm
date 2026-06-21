#define FAST_MOTOR_SPEED 1
#define AVERAGE_MOTOR_SPEED 2
#define SLOW_MOTOR_SPEED 3

/datum/wires/mulebot
	holder_type = /mob/living/basic/bot/mulebot
	proper_name = "Mulebot"
	randomize = TRUE

/datum/wires/mulebot/New(atom/holder)
	wires = list(
		WIRE_POWER1, WIRE_POWER2,
		WIRE_AVOIDANCE, WIRE_LOADCHECK,
		WIRE_MOTOR1, WIRE_MOTOR2,
		WIRE_RX, WIRE_TX, WIRE_BEACON
	)
	..()

/datum/wires/mulebot/interactable(mob/user)
	if(!..())
		return FALSE
	var/mob/living/basic/bot/mulebot/mule = holder
	if(mule.bot_access_flags & BOT_COVER_MAINTS_OPEN)
		return TRUE

/datum/wires/mulebot/on_cut(wire, mend, source)
	var/mob/living/basic/bot/mulebot/mule = holder
	switch(wire)
		if(WIRE_MOTOR1, WIRE_MOTOR2)
			if(is_cut(WIRE_MOTOR1) && is_cut(WIRE_MOTOR2))
				ADD_TRAIT(mule, TRAIT_IMMOBILIZED, MOTOR_LACK_TRAIT)
				holder.audible_message(span_hear("[mule]的电机安静了下来。"), null,  1)
			else if(HAS_TRAIT_FROM(mule, TRAIT_IMMOBILIZED, MOTOR_LACK_TRAIT))
				REMOVE_TRAIT(mule, TRAIT_IMMOBILIZED, MOTOR_LACK_TRAIT)
				holder.audible_message(span_hear("[mule]的电机嗡嗡作响，恢复了活力！"), null,  1)

			if(is_cut(WIRE_MOTOR1))
				mule.set_varspeed(FAST_MOTOR_SPEED)
				holder.audible_message(span_hear("[mule]的电机加速了！"), null,  1)
			else if(is_cut(WIRE_MOTOR2))
				mule.set_varspeed(AVERAGE_MOTOR_SPEED)
				holder.audible_message(span_hear("[mule]的电机发出嗡嗡声。"), null,  1)
			else
				mule.set_varspeed(SLOW_MOTOR_SPEED)
				holder.audible_message(span_hear("[mule]的电机轻柔地转动着。"), null,  1)
		if(WIRE_AVOIDANCE)
			if (!isnull(source))
				log_combat(source, mule, "[is_cut(WIRE_AVOIDANCE) ? "cut" : "mended"] the MULE safety wire of")
				holder.audible_message(span_hear("[mule]内部有什么东西不祥地咔哒作响！"), null,  1)

/datum/wires/mulebot/on_pulse(wire)
	var/mob/living/basic/bot/mulebot/mule = holder
	if(!mule.has_power(TRUE))
		return //logically mulebots can't flash and beep if they don't have power.
	switch(wire)
		if(WIRE_POWER1, WIRE_POWER2)
			holder.visible_message(span_notice("[icon2html(mule, viewers(holder))] 充电指示灯闪烁了一下。"))
		if(WIRE_AVOIDANCE)
			holder.visible_message(span_notice("[icon2html(mule, viewers(holder))] 外部警告灯短暂地闪烁了一下。"))
			flick("[mule.base_icon_state]1", mule)
		if(WIRE_LOADCHECK)
			holder.visible_message(span_notice("[icon2html(mule, viewers(holder))] 载物平台发出咔哒声。"))
		if(WIRE_MOTOR1, WIRE_MOTOR2)
			holder.visible_message(span_notice("[icon2html(mule, viewers(holder))] 驱动电机短暂地发出嗡鸣。"))
		else
			holder.visible_message(span_notice("[icon2html(mule, viewers(holder))] 你听到无线电的噼啪声。"))


#undef FAST_MOTOR_SPEED
#undef AVERAGE_MOTOR_SPEED
#undef SLOW_MOTOR_SPEED
