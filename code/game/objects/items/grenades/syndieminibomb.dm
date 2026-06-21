/obj/item/grenade/syndieminibomb
	desc = "一种辛迪加制造的爆炸物，用于散播毁灭与混乱。"
	name = "辛迪加迷你炸弹"
	icon = 'icons/obj/weapons/grenade.dmi'
	icon_state = "syndicate"
	inhand_icon_state = "flashbang"
	worn_icon_state = "minibomb"
	ex_dev = 1
	ex_heavy = 2
	ex_light = 4
	ex_flame = 2

/obj/item/grenade/syndieminibomb/detonate(mob/living/lanced_by)
	. = ..()
	if(!.)
		return

	update_mob()
	qdel(src)

/obj/item/grenade/syndieminibomb/concussion
	name = "高爆手榴弹"
	desc = "一种紧凑的破片手榴弹，旨在摧毁附近的生物并在此过程中造成一些破坏。拔掉保险销，朝反方向投掷。"
	icon_state = "concussion"
	ex_heavy = 2
	ex_light = 3
	ex_flame = 3

/obj/item/grenade/frag
	name = "破片手榴弹"
	desc = "一种反人员破片手榴弹，这种武器擅长通过金属破片撕裂软目标来杀死它们。"
	icon_state = "frag"
	shrapnel_type = /obj/projectile/bullet/shrapnel
	shrapnel_radius = 4
	ex_heavy = 1
	ex_light = 3
	ex_flame = 4

/obj/item/grenade/frag/mega
	name = "破片手榴弹"
	desc = "一种反一切破片手榴弹，这种武器擅长通过金属破片撕裂任何一切来杀死它们。"
	shrapnel_type = /obj/projectile/bullet/shrapnel/mega
	shrapnel_radius = 12

/obj/item/grenade/frag/detonate(mob/living/lanced_by)
	. = ..()
	if(!.)
		return

	update_mob()
	qdel(src)

/obj/item/grenade/gluon
	desc = "一种先进的手榴弹，能释放有害的胶子流，对附近人员造成辐射。这些胶子流还会使受害者感到疲惫并引发颤抖。这种极寒也很可能弄湿附近的地板。"
	name = "胶子破片手榴弹"
	icon = 'icons/obj/weapons/grenade.dmi'
	icon_state = "bluefrag"
	inhand_icon_state = "flashbang"
	var/freeze_range = 4
	var/rad_range = 4
	var/rad_threshold = RAD_EXTREME_INSULATION
	var/stamina_damage = 30
	var/temp_adjust = -230

/obj/item/grenade/gluon/detonate(mob/living/lanced_by)
	. = ..()
	if(!.)
		return

	update_mob()
	playsound(loc, 'sound/effects/empulse.ogg', 50, TRUE)
	radiation_pulse(src, max_range = rad_range, threshold = rad_threshold, chance = 100)
	for (var/turf/open/floor/floor in view(freeze_range, loc))
		floor.MakeSlippery(TURF_WET_PERMAFROST, 6 MINUTES)
		for(var/mob/living/carbon/victim in floor)
			victim.adjust_stamina_loss(stamina_damage)
			victim.adjust_bodytemperature(temp_adjust)
	qdel(src)
