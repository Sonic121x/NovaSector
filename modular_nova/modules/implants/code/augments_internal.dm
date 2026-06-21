/obj/item/organ/cyberimp/brain/anti_sleep
	name = "CNS 启动器"
	desc = "当检测到你在非快速眼动睡眠周期内失去意识时，该植入物会自动尝试将你电击唤醒。具有短暂冷却时间。与CNS重启器冲突，两者互不兼容。"
	icon_state = "brain_implant_rebooter"
	slot = ORGAN_SLOT_BRAIN_CNS //One or the other, not both.
	var/cooldown

/obj/item/organ/cyberimp/brain/anti_sleep/on_life(seconds_per_tick)
	. = ..()
	if(timeleft(cooldown))
		return

	var/mob/living/carbon/human/human_owner = owner
	if(human_owner.stat != UNCONSCIOUS)
		return

	human_owner.AdjustUnconscious(-5 SECONDS * seconds_per_tick, FALSE)
	human_owner.AdjustSleeping(-5 SECONDS * seconds_per_tick, FALSE)
	to_chat(owner, span_notice("你感到一股能量流遍全身！"))
	cooldown = addtimer(CALLBACK(src, PROC_REF(sleepytimerend)), 5 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE | TIMER_STOPPABLE | TIMER_DELETE_ME)

/obj/item/organ/cyberimp/brain/anti_sleep/proc/sleepytimerend()
	to_chat(owner, span_notice("你听到脑中传来一声轻微的哔哔声，你的CNS启动器已完成充能。"))
	cooldown = null

/obj/item/organ/cyberimp/brain/anti_sleep/emp_act(severity)
	. = ..()
	var/mob/living/carbon/human/human_owner = owner
	if((organ_flags & ORGAN_FAILING) || . & EMP_PROTECT_SELF)
		return
	organ_flags |= ORGAN_FAILING
	human_owner.AdjustUnconscious(20 SECONDS)
	cooldown = addtimer(CALLBACK(src, PROC_REF(reboot)), (9 SECONDS / severity), TIMER_UNIQUE | TIMER_OVERRIDE | TIMER_STOPPABLE | TIMER_DELETE_ME)

/obj/item/organ/cyberimp/brain/anti_sleep/proc/reboot()
	organ_flags &= ~ORGAN_FAILING
