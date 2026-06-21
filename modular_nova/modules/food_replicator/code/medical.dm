/obj/item/stack/medical/suture/bloody
	name = "止血缝合线"
	desc = "注入凝血剂的灭菌缝合线，用于封闭伤口和撕裂伤，并逆转危重出血。"
	icon = 'modular_nova/modules/food_replicator/icons/medicine.dmi'
	icon_state = "hemo_suture"
	heal_brute = 7
	stop_bleeding = 1
	merge_type = /obj/item/stack/medical/suture/bloody

/obj/item/stack/medical/suture/bloody/grind_results()
	return list(/datum/reagent/medicine/coagulant = 2)

/obj/item/stack/medical/suture/bloody/post_heal_effects(amount_healed, mob/living/carbon/healed_mob, mob/user)
	. = ..()
	if(healed_mob.get_blood_volume() <= BLOOD_VOLUME_SAFE)
		healed_mob.reagents.add_reagent(/datum/reagent/medicine/salglu_solution, 2)
		healed_mob.adjust_oxy_loss(-amount_healed)

/obj/item/stack/medical/mesh/bloody
	name = "止血网"
	desc = "一种用于包扎烧伤并刺激造血的止血网。由于其与血液相关的用途，它在消毒感染方面效果较差。"
	icon = 'modular_nova/modules/food_replicator/icons/medicine.dmi'
	icon_state = "hemo_mesh"
	heal_burn = 7
	sanitization = 0.5
	flesh_regeneration = 1.75
	stop_bleeding = 0.25
	merge_type = /obj/item/stack/medical/mesh/bloody

/obj/item/stack/medical/mesh/bloody/grind_results()
	return list(/datum/reagent/medicine/coagulant = 2)

/obj/item/stack/medical/mesh/bloody/update_icon_state()
	if(is_open)
		return ..()

	icon_state = "hemo_mesh_closed"

/obj/item/stack/medical/mesh/bloody/post_heal_effects(amount_healed, mob/living/carbon/healed_mob, mob/user)
	. = ..()
	if(healed_mob.get_blood_volume() <= BLOOD_VOLUME_SAFE)
		healed_mob.reagents.add_reagent(/datum/reagent/medicine/salglu_solution, 2)
		healed_mob.adjust_oxy_loss(-amount_healed)

/obj/item/reagent_containers/hypospray/medipen/glucose
	name = "加压葡萄糖医疗笔"
	desc = "一种用于在长时间的舱外活动轮班期间保持体力的医疗笔，将一剂葡萄糖注入你的血液。建议在低压环境下使用。"
	icon = 'modular_nova/modules/food_replicator/icons/medicine.dmi'
	icon_state = "glupen"
	inhand_icon_state = "stimpen"
	base_icon_state = "glupen"
	volume = 15
	amount_per_transfer_from_this = 15
	list_reagents = list(/datum/reagent/consumable/nutriment/glucose = 15)

/obj/item/reagent_containers/hypospray/medipen/glucose/inject(mob/living/affected_mob, mob/user)
	if(lavaland_equipment_pressure_check(get_turf(user)))
		amount_per_transfer_from_this = initial(amount_per_transfer_from_this)
		return ..()

	if(DOING_INTERACTION(user, DOAFTER_SOURCE_SURVIVALPEN))
		to_chat(user,span_notice("You are too busy to use \the [src]!"))
		return

	to_chat(user,span_notice("你开始手动释放低压表..."))
	if(!do_after(user, 10 SECONDS, affected_mob, interaction_key = DOAFTER_SOURCE_SURVIVALPEN))
		return

	amount_per_transfer_from_this = initial(amount_per_transfer_from_this) * 0.5
	return ..()
