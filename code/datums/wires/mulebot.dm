// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
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
				holder.audible_message(span_hear(LANG("datum.6b8849b8228a3cc4", list(mule))), null,  1)
			else if(HAS_TRAIT_FROM(mule, TRAIT_IMMOBILIZED, MOTOR_LACK_TRAIT))
				REMOVE_TRAIT(mule, TRAIT_IMMOBILIZED, MOTOR_LACK_TRAIT)
				holder.audible_message(span_hear(LANG("datum.a500826b8548b177", list(mule))), null,  1)

			if(is_cut(WIRE_MOTOR1))
				mule.set_varspeed(FAST_MOTOR_SPEED)
				holder.audible_message(span_hear(LANG("datum.f22cc863fa0fb7d7", list(mule))), null,  1)
			else if(is_cut(WIRE_MOTOR2))
				mule.set_varspeed(AVERAGE_MOTOR_SPEED)
				holder.audible_message(span_hear(LANG("datum.461be0bdb5785104", list(mule))), null,  1)
			else
				mule.set_varspeed(SLOW_MOTOR_SPEED)
				holder.audible_message(span_hear(LANG("datum.c934ba147ed3a5eb", list(mule))), null,  1)
		if(WIRE_AVOIDANCE)
			if (!isnull(source))
				log_combat(source, mule, "[is_cut(WIRE_AVOIDANCE) ? "cut" : "mended"] the MULE safety wire of")
				holder.audible_message(span_hear(LANG("datum.59ef5566ebc9f900", list(mule))), null,  1)

/datum/wires/mulebot/on_pulse(wire)
	var/mob/living/basic/bot/mulebot/mule = holder
	if(!mule.has_power(TRUE))
		return //logically mulebots can't flash and beep if they don't have power.
	switch(wire)
		if(WIRE_POWER1, WIRE_POWER2)
			holder.visible_message(span_notice(LANG("datum.82ffb0089c1d6274", list(icon2html(mule, viewers(holder))))))
		if(WIRE_AVOIDANCE)
			holder.visible_message(span_notice(LANG("datum.2997b6afce41462f", list(icon2html(mule, viewers(holder))))))
			flick("[mule.base_icon_state]1", mule)
		if(WIRE_LOADCHECK)
			holder.visible_message(span_notice(LANG("datum.e6ba3e510d701f9a", list(icon2html(mule, viewers(holder))))))
		if(WIRE_MOTOR1, WIRE_MOTOR2)
			holder.visible_message(span_notice(LANG("datum.3408e3ad323a4c47", list(icon2html(mule, viewers(holder))))))
		else
			holder.visible_message(span_notice(LANG("datum.01d6c417bf03dbf5", list(icon2html(mule, viewers(holder))))))


#undef FAST_MOTOR_SPEED
#undef AVERAGE_MOTOR_SPEED
#undef SLOW_MOTOR_SPEED
