/obj/projectile/energy/flora
	damage = 0
	damage_type = TOX
	armor_flag = ENERGY

/obj/projectile/energy/flora/on_hit(atom/target, blocked, pierce_hit)
	if(!isliving(target))
		return ..()

	var/mob/living/hit_plant = target
	if(!(hit_plant.mob_biotypes & MOB_PLANT))
		hit_plant.show_message(span_notice("辐射光束无害地穿过你的身体消散了。"))
		return BULLET_ACT_BLOCK

	. = ..()
	if(. == BULLET_ACT_HIT && blocked < 100)
		on_hit_plant_effect(target)

	return .

/// Called when we hit a mob with plant biotype
/obj/projectile/energy/flora/proc/on_hit_plant_effect(mob/living/hit_plant)
	return

/obj/projectile/energy/flora/mut
	name = "阿尔法特征"
	icon_state = "energy"

/obj/projectile/energy/flora/mut/on_hit_plant_effect(mob/living/hit_plant)
	if(prob(85))
		hit_plant.adjust_fire_loss(rand(5, 15))
		hit_plant.show_message(span_userdanger("辐射光束烧灼了你！"))
		return

	hit_plant.adjust_tox_loss(rand(3, 6))
	hit_plant.Paralyze(10 SECONDS)
	hit_plant.visible_message(
		span_warning("[hit_plant]痛苦地扭动着，因为[hit_plant.p_their()]液泡沸腾了。"),
		span_userdanger("你痛苦地扭动着，因为你的液泡在沸腾！"),
		span_hear("你听到树叶的碎裂声。"),
	)
	if(iscarbon(hit_plant) && hit_plant.has_dna())
		var/mob/living/carbon/carbon_plant = hit_plant
		if(prob(80))
			carbon_plant.easy_random_mutate(NEGATIVE + MINOR_NEGATIVE)
		else
			carbon_plant.easy_random_mutate(POSITIVE)
		carbon_plant.random_mutate_unique_identity()
		carbon_plant.random_mutate_unique_features()
		carbon_plant.domutcheck()

/obj/projectile/energy/flora/yield
	name = "贝塔特征"
	icon_state = "energy2"

/obj/projectile/energy/flora/yield/on_hit_plant_effect(mob/living/hit_plant)
	hit_plant.set_nutrition(min(hit_plant.nutrition + 30, NUTRITION_LEVEL_FULL))

/obj/projectile/energy/flora/evolution
	name = "伽马特征"
	icon_state = "energy3"

/obj/projectile/energy/flora/evolution/on_hit_plant_effect(mob/living/hit_plant)
	hit_plant.show_message(span_notice("辐射光束让你感到晕头转向！"))
	hit_plant.set_dizzy_if_lower(30 SECONDS)
	hit_plant.emote("flip")
	hit_plant.emote("spin")
