/obj/item/shrapnel // frag grenades
	name = "弹片碎片"
	custom_materials = list(/datum/material/iron= SMALL_MATERIAL_AMOUNT * 0.5)
	weak_against_armour = TRUE
	icon = 'icons/obj/debris.dmi'
	icon_state = "large"
	icon_angle = -45
	w_class = WEIGHT_CLASS_TINY
	item_flags = DROPDEL
	sharpness = SHARP_EDGED

/obj/item/shrapnel/stingball // stingbang grenades
	name = "刺痛球"
	icon_state = "tiny"
	sharpness = NONE

/obj/item/shrapnel/bullet // bullets
	name = "子弹"
	icon = 'icons/obj/weapons/guns/ammo.dmi'
	icon_state = "s-casing"
	embed_type = null

/obj/item/shrapnel/plastic
	name = "塑料碎片"
	custom_materials = list(/datum/material/plastic = SMALL_MATERIAL_AMOUNT * 0.5)
	icon_state = "titaniummedium"
	sharpness = SHARP_EDGED
	embed_type = /datum/embedding/shrapnel

/obj/projectile/bullet/shrapnel
	name = "飞行的弹片碎片"
	damage = 14
	range = 20
	weak_against_armour = TRUE
	dismemberment = 5
	ricochets_max = 2
	ricochet_chance = 70
	shrapnel_type = /obj/item/shrapnel
	ricochet_incidence_leeway = 60
	hit_prone_targets = TRUE
	ignore_range_hit_prone_targets = TRUE
	sharpness = SHARP_EDGED
	wound_bonus = 30
	embed_type = /datum/embedding/shrapnel

/datum/embedding/shrapnel
	embed_chance = 70
	ignore_throwspeed_threshold = TRUE
	fall_chance = 1
	stealthy_embed = TRUE

/obj/projectile/bullet/shrapnel/short_range
	range = 5

/obj/projectile/bullet/shrapnel/mega
	name = "飞行的弹片大块"
	range = 45
	dismemberment = 15
	ricochets_max = 6
	ricochet_chance = 130
	ricochet_incidence_leeway = 0
	ricochet_decay_chance = 0.9

/obj/projectile/bullet/shrapnel/ied
	name = "飞行的玻璃弹片"
	damage = 15
	range = 6
	ricochets_max = 1
	ricochet_chance = 40
	shrapnel_type = /obj/item/shard
	ricochet_incidence_leeway = 60

/obj/projectile/bullet/pellet/stingball
	name = "刺痛球弹丸"
	damage = 3
	stamina = 8
	ricochets_max = 4
	ricochet_chance = 66
	ricochet_decay_chance = 1
	ricochet_decay_damage = 0.9
	ricochet_auto_aim_angle = 10
	ricochet_auto_aim_range = 2
	ricochet_incidence_leeway = 0
	embed_falloff_tile = -2
	shrapnel_type = /obj/item/shrapnel/stingball
	embed_type = /datum/embedding/stingball

/datum/embedding/stingball
	embed_chance = 55
	fall_chance = 2
	jostle_chance = 7
	ignore_throwspeed_threshold = TRUE
	pain_stam_pct = 0.7
	pain_mult = 3
	jostle_pain_mult = 3
	rip_time = 1.5 SECONDS

/obj/projectile/bullet/pellet/stingball/on_ricochet(atom/A)
	hit_prone_targets = TRUE // ducking will save you from the first wave, but not the rebounds
	ignore_range_hit_prone_targets = TRUE

/obj/projectile/bullet/pellet/stingball/mega
	name = "巨型刺痛球弹丸"
	ricochets_max = 6
	ricochet_chance = 110

/obj/projectile/bullet/pellet/capmine
	name = "\improper 穿甲弹片碎片"
	range = 7
	damage = 8
	stamina = 8
	sharpness = SHARP_EDGED
	wound_bonus = 5
	exposed_wound_bonus = 5
	ricochets_max = 2
	ricochet_chance = 140
	shrapnel_type = /obj/item/shrapnel/capmine
	embed_type = /datum/embedding/capmine
	wound_falloff_tile = 0
	embed_falloff_tile = 0

/datum/embedding/capmine
	embed_chance = 90
	fall_chance = 3
	jostle_chance = 7
	ignore_throwspeed_threshold = TRUE
	pain_stam_pct = 0.7
	pain_mult = 5
	jostle_pain_mult = 6
	rip_time = 1.5 SECONDS

/obj/item/shrapnel/capmine
	name = "\improper 穿甲弹片碎片"
	custom_materials = list(/datum/material/iron= SMALL_MATERIAL_AMOUNT * 0.5)
	weak_against_armour = TRUE
