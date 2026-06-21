/obj/item/knife/hotknife
	name = "千度刀"
	icon = 'modular_nova/modules/modular_ert/icons/pizza/hotknife.dmi'
	icon_state = "hotknife"
	inhand_icon_state = "hotknife"
	desc = "这把剑曾被称为“光明使者”，如今已降级为简单的披萨切刀……它可能仍保留着火焰攻击能力。"
	righthand_file = 'modular_nova/modules/modular_ert/icons/pizza/righthand.dmi'
	lefthand_file = 'modular_nova/modules/modular_ert/icons/pizza/lefthand.dmi'

	/// How many fire stacks to apply on attack
	var/fire_stacks = 4

/obj/item/knife/hotknife/attack(mob/living/victim, mob/living/attacker, params)
	victim.adjust_fire_stacks(fire_stacks)
	victim.ignite_mob()
	return ..()
