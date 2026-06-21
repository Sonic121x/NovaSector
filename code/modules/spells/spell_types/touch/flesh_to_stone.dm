/datum/action/cooldown/spell/touch/flesh_to_stone
	name = "点肉成石"
	desc = "这个咒语使你的手在很长一段时间内拥有将受害者变成惰性雕像的能力。"
	button_icon_state = "statue"
	sound = 'sound/effects/magic/fleshtostone.ogg'

	school = SCHOOL_TRANSMUTATION
	cooldown_time = 1 MINUTES
	cooldown_reduction_per_rank = 10 SECONDS

	invocation = "STAUN EI!!"

	hand_path = /obj/item/melee/touch_attack/flesh_to_stone

/datum/action/cooldown/spell/touch/flesh_to_stone/on_antimagic_triggered(obj/item/melee/touch_attack/hand, mob/living/victim, mob/living/carbon/caster)
	to_chat(caster, span_warning("法术似乎无法影响[victim]！"))
	to_chat(victim, span_warning("你感觉自己的血肉瞬间变成了石头，然后又恢复了原状！"))

/datum/action/cooldown/spell/touch/flesh_to_stone/cast_on_hand_hit(obj/item/melee/touch_attack/hand, mob/living/victim, mob/living/carbon/caster)
	var/mob/living/living_victim = victim
	if(living_victim.can_block_magic(antimagic_flags))
		return TRUE

	living_victim.Stun(4 SECONDS)
	living_victim.petrify()
	return TRUE

/obj/item/melee/touch_attack/flesh_to_stone
	name = "\improper 惩戒之触"
	desc = "这就是事实真相，因为“肉变石”就是这么写的！"
	icon = 'icons/obj/weapons/hand.dmi'
	icon_state = "fleshtostone"
	inhand_icon_state = "fleshtostone"
