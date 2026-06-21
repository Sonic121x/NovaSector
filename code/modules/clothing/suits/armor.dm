/obj/item/clothing/suit/armor
	name = "armor"
	icon = 'icons/obj/clothing/suits/armor.dmi'
	worn_icon = 'icons/mob/clothing/suits/armor.dmi'
	abstract_type = /obj/item/clothing/suit/armor
	allowed = null
	body_parts_covered = CHEST
	cold_protection = CHEST|GROIN
	min_cold_protection_temperature = ARMOR_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN
	max_heat_protection_temperature = ARMOR_MAX_TEMP_PROTECT
	strip_delay = 6 SECONDS
	equip_delay_other = 4 SECONDS
	max_integrity = 250
	resistance_flags = NONE
	armor_type = /datum/armor/suit_armor

/datum/armor/suit_armor
	melee = 35
	bullet = 30
	laser = 30
	energy = 40
	bomb = 25
	fire = 50
	acid = 50
	wound = 10

/obj/item/clothing/suit/armor/Initialize(mapload)
	. = ..()
	if(!allowed)
		allowed = GLOB.security_vest_allowed

/obj/item/clothing/suit/armor/apply_fantasy_bonuses(bonus)
	. = ..()
	slowdown = modify_fantasy_variable("slowdown", slowdown, -bonus * 0.1, 0)
	if(ismob(loc))
		var/mob/wearer = loc
		wearer.update_equipment_speed_mods()

/obj/item/clothing/suit/armor/remove_fantasy_bonuses(bonus)
	slowdown = reset_fantasy_variable("slowdown", slowdown)
	if(ismob(loc))
		var/mob/wearer = loc
		wearer.update_equipment_speed_mods()
	return ..()

/obj/item/clothing/suit/armor/vest
	name = "防弹背心"
	desc = "一种细长的I型装甲背心，可以提供体面的保护，防止大多数类型的伤害。"
	icon_state = "armoralt"
	inhand_icon_state = "armor"
	blood_overlay_type = "armor"
	dog_fashion = /datum/dog_fashion/back/armorvest

/obj/item/clothing/suit/armor/vest/alt
	desc = "一种I型装甲背心，可以提供体面的保护，防止大多数类型的伤害。"
	icon_state = "armor"
	inhand_icon_state = "armor"

/obj/item/clothing/suit/armor/vest/alt/sec
	icon_state = "armor_sec"

/obj/item/clothing/suit/armor/vest/press
	name = "press armor vest"
	desc = "A blue armor vest used to distinguish <i>non-combatant</i> \"PRESS\" members, like if anyone cares."
	icon_state = "armor_press"

/obj/item/clothing/suit/armor/vest/press/worn_overlays(mutable_appearance/standing, isinhands, icon_file)
	. = ..()
	if(!isinhands)
		. += emissive_appearance(icon_file, "[icon_state]-emissive", src, alpha = src.alpha, effect_type = EMISSIVE_SPECULAR)

/obj/item/clothing/suit/armor/vest/marine
	name = "战术防弹背心"
	desc = "一套精心批量生产的等离子钢装甲，配备了能够适应各种环境的踹门保护装置。"
	icon_state = "marine_command"
	inhand_icon_state = "armor"
	clothing_flags = STOPSPRESSUREDAMAGE | THICKMATERIAL
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	armor_type = /datum/armor/vest_marine
	cold_protection = CHEST | GROIN | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT_OFF
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	resistance_flags = FIRE_PROOF | ACID_PROOF

/datum/armor/vest_marine
	melee = 50
	bullet = 50
	laser = 30
	energy = 25
	bomb = 50
	bio = 100
	fire = 40
	acid = 50
	wound = 20

/datum/armor/pmc
	melee = 40
	bullet = 50
	laser = 60
	energy = 50
	bomb = 50
	bio = 100
	acid = 50
	wound = 20

/obj/item/clothing/suit/armor/vest/marine/security
	name = "宽战术防弹背心"
	icon_state = "marine_security"

/obj/item/clothing/suit/armor/vest/marine/engineer
	name = "战术多用防弹背心"
	icon_state = "marine_engineer"

/obj/item/clothing/suit/armor/vest/marine/medic
	name = "战术医疗防弹背心"
	icon_state = "marine_medic"
	body_parts_covered = CHEST|GROIN

/obj/item/clothing/suit/armor/vest/marine/pmc
	desc = "A set of the finest mass produced, stamped plasteel armor plates, for an all-around door-kicking and ass-smashing. Its stellar survivability making up is for its lack of space worthiness"
	min_cold_protection_temperature = HELMET_MIN_TEMP_PROTECT
	max_heat_protection_temperature = HELMET_MAX_TEMP_PROTECT
	clothing_flags = THICKMATERIAL
	w_class = WEIGHT_CLASS_BULKY
	armor_type = /datum/armor/pmc

/obj/item/clothing/suit/armor/vest/old
	name = "老化防弹背心"
	desc = "老一代的Type 1防弹背心.由于随时间流逝的老化，该背心的灵活性大大降低，移动起来较为困难."
	icon_state = "armor"
	inhand_icon_state = "armor"
	slowdown = 1

/obj/item/clothing/suit/armor/vest/blueshirt
	name = "宽防弹背心"
	desc = "一件大但舒适的盔甲，保护你免受某些威胁。"
	icon_state = "blueshift"
	inhand_icon_state = null
	custom_premium_price = PAYCHECK_COMMAND

/obj/item/clothing/suit/armor/vest/cuirass
	name = "胸甲"
	desc = "一款轻型板甲，在不影响运动的同时，还可以抵挡那些讨厌的箭矢。"
	icon_state = "cuirass"
	inhand_icon_state = "armor"
	dog_fashion = null

/obj/item/clothing/suit/armor/vest/cuirass/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_PLATE_ARMOR_RUSTLE, 8)

/obj/item/clothing/suit/armor/hos
	name = "防弹厚大衣"
	desc = "一件用特殊合金强化的大衣，为那些威严的人提供额外的保护和风度."
	icon_state = "hos"
	inhand_icon_state = "greatcoat"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	armor_type = /datum/armor/armor_hos
	cold_protection = CHEST|GROIN|LEGS|ARMS
	heat_protection = CHEST|GROIN|LEGS|ARMS
	strip_delay = 8 SECONDS

/datum/armor/armor_hos
	melee = 30
	bullet = 30
	laser = 30
	energy = 40
	bomb = 25
	fire = 70
	acid = 90
	wound = 10

/obj/item/clothing/suit/armor/hos/trenchcoat
	name = "防弹风衣"
	desc = "一件用特殊的轻质凯夫拉纤维增强的风衣.战术便衣的典范."
	icon_state = "hostrench"
	inhand_icon_state = "hostrench"
	flags_inv = 0
	strip_delay = 8 SECONDS

/obj/item/clothing/suit/armor/hos/trenchcoat/winter
	name = "安保部长防寒风衣"
	desc = "一种配有特殊轻质凯夫拉材料的风衣，衣领以及内部填充了羊毛。你穿着这件外套会感到莫名的孤独。"
	icon_state = "hoswinter"
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT

/obj/item/clothing/suit/armor/hos/hos_formal
	name = "\improper 安保部长的检阅夹克"
	desc = "当防弹背心不够时尚的时候。"
	icon_state = "hosformal"
	inhand_icon_state = "hostrench"
	body_parts_covered = CHEST|GROIN|ARMS

/obj/item/clothing/suit/armor/hos/hos_formal/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon)

/obj/item/clothing/suit/armor/vest/warden
	name = "典狱长夹克"
	desc = "A navy-blue armored jacket with blue shoulder designations and '/Warden/' stitched into one of the chest pockets."
	icon_state = "warden_alt"
	inhand_icon_state = "armor"
	body_parts_covered = CHEST|GROIN|ARMS
	cold_protection = CHEST|GROIN|ARMS|HANDS
	heat_protection = CHEST|GROIN|ARMS|HANDS
	strip_delay = 7 SECONDS
	resistance_flags = FLAMMABLE
	dog_fashion = null

/obj/item/clothing/suit/armor/vest/warden/alt
	name = "典狱长的防弹夹克"
	desc = "一件镶着银色徽章的红色夹克，上面系着防弹衣。"
	icon_state = "warden_jacket"

/obj/item/clothing/suit/armor/vest/secjacket
	name = "security jacket"
	desc = "A red jacket in red Security colors. It has hi-vis stripes all over it."
	icon_state = "secjacket"
	inhand_icon_state = "armor"
	armor_type = /datum/armor/armor_secjacket
	body_parts_covered = CHEST|GROIN|ARMS
	cold_protection = CHEST|GROIN|ARMS|HANDS
	heat_protection = CHEST|GROIN|ARMS|HANDS
	resistance_flags = FLAMMABLE
	dog_fashion = null

/obj/item/clothing/suit/armor/vest/secjacket/worn_overlays(mutable_appearance/standing, isinhands, icon_file)
	. = ..()
	if(!isinhands)
		. += emissive_appearance(icon_file, "[icon_state]-emissive", src, alpha = src.alpha, effect_type = EMISSIVE_SPECULAR)

/datum/armor/armor_secjacket //Gotta compensate those extra covered limbs
	melee = 25
	bullet = 25
	laser = 25
	energy = 35
	bomb = 20
	fire = 30
	acid = 30
	wound = 5

/obj/item/clothing/suit/armor/vest/leather
	name = "安保外套"
	desc = "轻装皮质外套，用于高级军官的休闲服装，.上面印有纳米传讯安保部门的徽章."
	icon_state = "leathercoat-sec"
	inhand_icon_state = "hostrench"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	cold_protection = CHEST|GROIN|LEGS|ARMS
	heat_protection = CHEST|GROIN|LEGS|ARMS
	dog_fashion = null

/obj/item/clothing/suit/armor/vest/capcarapace
	name = "舰长甲壳甲"
	desc = "一种防火装甲胸甲，配陶瓷板和等离子钢制成的护肩，能提供额外的保护，同时还能保障最大的机动性和灵活性。只发给空间站最优秀的人，不过会让你乳头发炎。"
	icon_state = "capcarapace"
	inhand_icon_state = "armor"
	body_parts_covered = CHEST|GROIN
	armor_type = /datum/armor/vest_capcarapace
	dog_fashion = null
	resistance_flags = FIRE_PROOF

/datum/armor/vest_capcarapace
	melee = 50
	bullet = 40
	laser = 50
	energy = 50
	bomb = 25
	fire = 100
	acid = 90
	wound = 10

/obj/item/clothing/suit/armor/vest/capcarapace/syndicate
	name = "辛迪加舰长背心"
	desc = "一件看上去不怀好意的先进护甲背心，穿在红黑相间的防火夹克外。金色的衣领和肩章表明它属于一位辛迪加高级军官。"
	icon_state = "syndievest"

/obj/item/clothing/suit/armor/vest/capcarapace/captains_formal
	name = "舰长检阅大衣"
	desc = "当防弹背心不够时尚的时候。"
	icon_state = "capformal"
	inhand_icon_state = null
	body_parts_covered = CHEST|GROIN|ARMS

/obj/item/clothing/suit/armor/vest/capcarapace/captains_formal/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon)

/obj/item/clothing/suit/armor/riot
	name = "防暴服"
	desc = "一套半柔性的聚碳酸酯防弹护具，有着厚重的填充材料,用于抵御近身攻击。并帮助穿戴者抵抗近距离的推挤。"
	icon_state = "riot"
	inhand_icon_state = "swat_suit"
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	armor_type = /datum/armor/armor_riot
	strip_delay = 8 SECONDS
	equip_delay_other = 6 SECONDS
	clothing_traits = list(TRAIT_BRAWLING_KNOCKDOWN_BLOCKED)

/obj/item/clothing/suit/armor/riot/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, 5)
	init_rustle_component()

/obj/item/clothing/suit/armor/riot/proc/init_rustle_component()
	AddComponent(/datum/component/item_equipped_movement_rustle)

/datum/armor/armor_riot
	melee = 50
	bullet = 10
	laser = 10
	energy = 10
	fire = 80
	acid = 80
	wound = 20

/obj/item/clothing/suit/armor/balloon_vest
	name = "balloon vest"
	desc = "A vest made entirely from balloons, resistant to any evil forces a mime could throw at you, including electricity and fire. Just a strike with something sharp, though..."
	icon_state = "balloon-vest"
	inhand_icon_state = "balloon_armor"
	blood_overlay_type = "armor"
	armor_type = /datum/armor/balloon_vest
	siemens_coefficient = 0
	strip_delay = 7 SECONDS
	equip_delay_other = 5 SECONDS

/datum/armor/balloon_vest
	melee = 10
	laser = 10
	energy = 10
	fire = 60
	acid = 50

/obj/item/clothing/suit/armor/balloon_vest/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK, damage_type = BRUTE)
	if(isitem(hitby))
		var/obj/item/item_hit = hitby
		if(item_hit.get_sharpness())
			pop()

	if(istype(hitby, /obj/projectile/bullet))
		pop()

	return ..()

/obj/item/clothing/suit/armor/balloon_vest/proc/pop()
	playsound(src, 'sound/effects/cartoon_sfx/cartoon_pop.ogg', 50, vary = TRUE)
	qdel(src)


/obj/item/clothing/suit/armor/bulletproof
	name = "防弹盔甲"
	desc = "III型重型防弹背心，能在一定程度上保护穿着者免受传统投射武器和炸药的伤害。"
	icon_state = "bulletproof"
	inhand_icon_state = "armor"
	blood_overlay_type = "armor"
	armor_type = /datum/armor/armor_bulletproof
	strip_delay = 7 SECONDS
	equip_delay_other = 5 SECONDS

/datum/armor/armor_bulletproof
	melee = 15
	bullet = 60
	laser = 10
	energy = 10
	bomb = 40
	fire = 50
	acid = 50
	wound = 20

/obj/item/clothing/suit/armor/laserproof
	name = "反射背心"
	desc = "一件能够保护佩戴者免受能量射弹伤害，偶尔还能反射这些射弹的反射背心。"
	icon_state = "armor_reflec"
	inhand_icon_state = "armor_reflec"
	blood_overlay_type = "armor"
	body_parts_covered = CHEST|GROIN|ARMS
	cold_protection = CHEST|GROIN|ARMS
	heat_protection = CHEST|GROIN|ARMS
	armor_type = /datum/armor/armor_laserproof
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	var/hit_reflect_chance = 50

/datum/armor/armor_laserproof
	melee = 10
	bullet = 10
	laser = 60
	energy = 60
	fire = 100
	acid = 100

/obj/item/clothing/suit/armor/laserproof/IsReflect(def_zone)
	if(!(def_zone in list(BODY_ZONE_CHEST, BODY_ZONE_PRECISE_GROIN, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))) //If not shot where ablative is covering you, you don't get the reflection bonus!
		return FALSE
	if (prob(hit_reflect_chance))
		return TRUE

/obj/item/clothing/suit/armor/vest/det_suit
	name = "detective's flak vest"
	desc = "一件有警探徽章的防弹背心。"
	icon_state = "detective-armor"
	resistance_flags = FLAMMABLE
	dog_fashion = null

/obj/item/clothing/suit/armor/vest/det_suit/Initialize(mapload)
	. = ..()
	allowed = GLOB.detective_vest_allowed

/obj/item/clothing/suit/armor/swat
	name = "MK.I SWAT Suit"
	desc = "A tactical suit first developed in a joint effort by the defunct IS-ERI and Nanotrasen in 2321 for military operations. \
		It has a minor slowdown, but offers decent protection and helps the wearer resist shoving in close quarters."
	icon_state = "heavy"
	inhand_icon_state = "swat_suit"
	armor_type = /datum/armor/armor_swat
	strip_delay = 12 SECONDS
	resistance_flags = FIRE_PROOF | ACID_PROOF
	clothing_flags = THICKMATERIAL
	cold_protection = CHEST | GROIN | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT_OFF
	heat_protection = CHEST | GROIN | LEGS | FEET | ARMS | HANDS
	max_heat_protection_temperature = SPACE_SUIT_MAX_TEMP_PROTECT
	slowdown = 0.7
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	clothing_traits = list(TRAIT_BRAWLING_KNOCKDOWN_BLOCKED)

/obj/item/clothing/suit/armor/swat/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, 5)
	init_rustle_component()

/obj/item/clothing/suit/armor/swat/proc/init_rustle_component()
	AddComponent(/datum/component/item_equipped_movement_rustle)


//All of the armor below is mostly unused

/datum/armor/armor_swat
	melee = 40
	bullet = 30
	laser = 30
	energy = 40
	bomb = 50
	bio = 90
	fire = 100
	acid = 100
	wound = 15

/obj/item/clothing/suit/armor/heavy
	name = "重型盔甲"
	desc = "一套防弹能力极强的防弹装备，能够抵御中等程度的伤害。"
	icon_state = "heavy"
	inhand_icon_state = "swat_suit"
	w_class = WEIGHT_CLASS_BULKY
	clothing_flags = THICKMATERIAL
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	slowdown = 3
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	armor_type = /datum/armor/armor_heavy

/datum/armor/armor_heavy
	melee = 80
	bullet = 80
	laser = 50
	energy = 50
	bomb = 100
	bio = 100
	fire = 90
	acid = 90

/obj/item/clothing/suit/armor/tdome
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	clothing_flags = THICKMATERIAL
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	armor_type = /datum/armor/armor_tdome

/datum/armor/armor_tdome
	melee = 80
	bullet = 80
	laser = 50
	energy = 50
	bomb = 100
	bio = 100
	fire = 90
	acid = 90

/obj/item/clothing/suit/armor/tdome/red
	name = "竞技场服"
	desc = "淡红色的盔甲。"
	icon_state = "tdred"
	inhand_icon_state = "tdred"

/obj/item/clothing/suit/armor/tdome/green
	name = "竞技场服"
	desc = "作呕的护甲" //classy.
	icon_state = "tdgreen"
	inhand_icon_state = "tdgreen"

/obj/item/clothing/suit/armor/tdome/holosuit
	name = "竞技场服"
	armor_type = /datum/armor/tdome_holosuit
	cold_protection = null
	heat_protection = null

/datum/armor/tdome_holosuit
	melee = 10
	bullet = 10

/obj/item/clothing/suit/armor/tdome/holosuit/red
	desc = "淡红色的盔甲。"
	icon_state = "tdred"
	inhand_icon_state = "tdred"

/obj/item/clothing/suit/armor/tdome/holosuit/green
	desc = "作呕的护甲"
	icon_state = "tdgreen"
	inhand_icon_state = "tdgreen"

/obj/item/clothing/suit/armor/riot/knight
	name = "板甲"
	desc = "一款经典的板甲，具有较强的抗近战击打能力。"
	icon_state = "knight_green"
	inhand_icon_state = null
	allowed = list(
		/obj/item/banner,
		/obj/item/claymore,
		/obj/item/nullrod,
		/obj/item/tank/internals/emergency_oxygen,
		/obj/item/tank/internals/plasmaman,
		)
/obj/item/clothing/suit/armor/riot/knight/init_rustle_component()
	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_PLATE_ARMOR_RUSTLE, 8)

/obj/item/clothing/suit/armor/riot/knight/yellow
	icon_state = "knight_yellow"
	inhand_icon_state = null

/obj/item/clothing/suit/armor/riot/knight/blue
	icon_state = "knight_blue"
	inhand_icon_state = null

/obj/item/clothing/suit/armor/riot/knight/red
	icon_state = "knight_red"
	inhand_icon_state = null

/obj/item/clothing/suit/armor/riot/knight/greyscale
	name = "骑士甲"
	desc = "一款经典的盔甲，可由不同种类的材料制成。"
	icon_state = "knight_greyscale"
	inhand_icon_state = null
	material_flags = MATERIAL_EFFECTS | MATERIAL_ADD_PREFIX | MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS // Can change color and add prefix
	armor_type = /datum/armor/knight_greyscale

/datum/armor/knight_greyscale
	melee = 35
	bullet = 10
	laser = 10
	energy = 10
	bomb = 10
	bio = 10
	fire = 40
	acid = 40

/obj/item/clothing/suit/armor/vest/durathread
	name = "杜拉棉背心"
	desc = "一件由杜拉棉织成的背心，其边缘处有皮革条作为防冲击护板。"
	icon_state = "durathread"
	inhand_icon_state = null
	strip_delay = 6 SECONDS
	equip_delay_other = 4 SECONDS
	max_integrity = 200
	resistance_flags = FLAMMABLE
	armor_type = /datum/armor/vest_durathread
	dog_fashion = null

/obj/item/clothing/suit/armor/vest/durathread/Initialize(mapload)
	. = ..()
	allowed |= /obj/item/clothing/suit/apron::allowed

/datum/armor/vest_durathread
	melee = 20
	bullet = 10
	laser = 30
	energy = 40
	bomb = 15
	fire = 40
	acid = 50

/obj/item/clothing/suit/armor/vest/russian
	name = "俄式防弹背心"
	desc = "带有丛林迷彩涂装的防弹背心。好消息是，这周围全是树，有的是地方可以藏，对不对？"
	icon_state = "rus_armor"
	inhand_icon_state = null
	armor_type = /datum/armor/vest_russian
	dog_fashion = null

/datum/armor/vest_russian
	melee = 25
	bullet = 30
	energy = 10
	bomb = 10
	fire = 20
	acid = 50
	wound = 10

/obj/item/clothing/suit/armor/vest/russian_coat
	name = "俄式战斗外衣"
	desc = "Used in extremely cold fronts, made out of real bears."
	icon_state = "rus_coat"
	inhand_icon_state = null
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	armor_type = /datum/armor/vest_russian_coat
	dog_fashion = null

/datum/armor/vest_russian_coat
	melee = 25
	bullet = 20
	laser = 20
	energy = 30
	bomb = 20
	bio = 50
	fire = -10
	acid = 50
	wound = 10

/obj/item/clothing/suit/armor/elder_atmosian
	name = "\improper 资深大气技术员护甲"
	desc = "这是一件用人类能获取的最坚硬最稀有的材料制成的盔甲。"
	icon_state = "h2armor"
	inhand_icon_state = null
	material_flags = MATERIAL_EFFECTS
	armor_type = /datum/armor/armor_elder_atmosian
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS

/obj/item/clothing/suit/armor/elder_atmosian/Initialize(mapload)
	. = ..()
	allowed += list(
		/obj/item/fireaxe/metal_h2_axe,
	)

/datum/armor/armor_elder_atmosian
	melee = 25
	bullet = 20
	laser = 30
	energy = 30
	bomb = 85
	bio = 10
	fire = 65
	acid = 40
	wound = 15

/obj/item/clothing/suit/armor/centcom_formal
	name = "\improper 中央指挥部正装"
	desc = "一件发给中央司令部指挥官的华丽大衣。非常适合在派遣应急反应部队执行自杀式任务时保持优雅。"
	icon_state = "centcom_formal"
	inhand_icon_state = "centcom"
	body_parts_covered = CHEST|GROIN|ARMS
	armor_type = /datum/armor/armor_centcom_formal

/datum/armor/armor_centcom_formal
	melee = 35
	bullet = 40
	laser = 40
	energy = 50
	bomb = 35
	bio = 10
	fire = 10
	acid = 60

/obj/item/clothing/suit/armor/centcom_formal/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon)

/obj/item/clothing/suit/armor/vest/hop
	name = "人事部长大衣"
	desc = "发给人事部长的精致大衣。"
	icon_state = "hop_coat"
	inhand_icon_state = "b_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dog_fashion = null

/obj/item/clothing/suit/armor/militia
	name = "station defender's coat"
	desc = "A well worn uniform used by militia across the frontier, its thick padding useful for cushioning blows."
	icon_state = "militia"
	inhand_icon_state = "b_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	cold_protection = CHEST|GROIN|ARMS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	armor_type = /datum/armor/coat_militia

/datum/armor/coat_militia
	melee = 40
	bullet = 40
	laser = 30
	energy = 25
	bomb = 50
	fire = 40
	acid = 50
	wound = 30

/obj/item/clothing/suit/armor/vest/military
	name = "Crude chestplate"
	desc = "It may look rough, rusty and battered, but it's also made out of junk and uncomfortable to wear."
	icon_state = "military"
	inhand_icon_state = "armor"
	dog_fashion = null
	armor_type = /datum/armor/military
	allowed = list(
		/obj/item/banner,
		/obj/item/claymore/shortsword,
		/obj/item/nullrod,
		/obj/item/spear,
		/obj/item/gun/ballistic/bow
	)

/obj/item/clothing/suit/armor/vest/military/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, 5)

/datum/armor/military
	melee = 45
	bullet = 25
	laser = 25
	energy = 25
	bomb = 25
	fire = 10
	acid = 50
	wound = 20

/obj/item/clothing/suit/armor/riot/knight/warlord
	name = "golden plate armor"
	desc = "This bulky set of armor is coated with a shiny layer of gold. It seems to almost reflect all light sources."
	icon_state = "warlord"
	inhand_icon_state = null
	armor_type = /datum/armor/armor_warlord
	w_class = WEIGHT_CLASS_BULKY
	clothing_flags = THICKMATERIAL
	slowdown = 0.8

/datum/armor/armor_warlord
	melee = 70
	bullet = 60
	laser = 70
	energy = 70
	bomb = 40
	fire = 50
	acid = 50
	wound = 30

/obj/item/clothing/suit/armor/durability
	abstract_type = /obj/item/clothing/suit/armor/durability

/obj/item/clothing/suit/armor/durability/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK, damage_type = BRUTE)
	take_damage(1, BRUTE, 0, 0)

/obj/item/clothing/suit/armor/durability/watermelon
	name = "watermelon armor"
	desc = "An armor, made from watermelons. Probably won't take too many hits, but at least it looks serious... As serious as worn watermelon can be."
	icon_state = "watermelon"
	inhand_icon_state = null
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	armor_type = /datum/armor/watermelon
	strip_delay = 6 SECONDS
	equip_delay_other = 4 SECONDS
	clothing_traits = list(TRAIT_BRAWLING_KNOCKDOWN_BLOCKED)
	max_integrity = 15

/obj/item/clothing/suit/armor/durability/watermelon/fire_resist
	resistance_flags = FIRE_PROOF
	armor_type = /datum/armor/watermelon_fr

/datum/armor/watermelon
	melee = 15
	bullet = 10
	energy = 10
	bomb = 10
	fire = 0
	acid = 25
	wound = 5

/datum/armor/watermelon_fr
	melee = 15
	bullet = 10
	energy = 10
	bomb = 10
	fire = 15
	acid = 30
	wound = 5

/obj/item/clothing/suit/armor/durability/holymelon
	name = "holymelon armor"
	desc = "An armor, made from holymelons. Inspires you to go on some sort of crusade... Perhaps spreading spinach to children?"
	icon_state = "holymelon"
	inhand_icon_state = null
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	armor_type = /datum/armor/watermelon
	strip_delay = 6 SECONDS
	equip_delay_other = 4 SECONDS
	clothing_traits = list(TRAIT_BRAWLING_KNOCKDOWN_BLOCKED)
	max_integrity = 15

/obj/item/clothing/suit/armor/durability/holymelon/fire_resist
	resistance_flags = FIRE_PROOF
	armor_type = /datum/armor/watermelon_fr

/obj/item/clothing/suit/armor/durability/holymelon/Initialize(mapload)
	. = ..()

	AddComponent(
		/datum/component/anti_magic, \
		antimagic_flags = MAGIC_RESISTANCE|MAGIC_RESISTANCE_HOLY, \
		inventory_flags = ITEM_SLOT_OCLOTHING, \
		charges = 1, \
		block_magic = CALLBACK(src, PROC_REF(drain_antimagic)), \
		expiration = CALLBACK(src, PROC_REF(decay)) \
	)

/obj/item/clothing/suit/armor/durability/holymelon/proc/drain_antimagic(mob/user)
	to_chat(user, span_warning("[src] looses a bit of its shimmer and glossiness..."))

/obj/item/clothing/suit/armor/durability/holymelon/proc/decay()
	take_damage(8, BRUTE, 0, 0)


/obj/item/clothing/suit/armor/durability/barrelmelon
	name = "barrelmelon armor"
	desc = "An armor, made from barrelmelons. Reeks of ale, inspiring to courageous deeds. Or, perhaps, a bar brawl."
	icon_state = "barrelmelon"
	inhand_icon_state = null
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	armor_type = /datum/armor/barrelmelon
	strip_delay = 6 SECONDS
	equip_delay_other = 4 SECONDS
	clothing_traits = list(TRAIT_BRAWLING_KNOCKDOWN_BLOCKED)
	max_integrity = 10

/obj/item/clothing/suit/armor/durability/barrelmelon/fire_resist
	resistance_flags = FIRE_PROOF
	armor_type = /datum/armor/barrelmelon_fr

/datum/armor/barrelmelon
	melee = 25
	bullet = 20
	energy = 15
	bomb = 10
	fire = 0
	acid = 35
	wound = 10

/datum/armor/barrelmelon_fr
	melee = 25
	bullet = 20
	energy = 15
	bomb = 10
	fire = 20
	acid = 40
	wound = 10

/obj/item/clothing/suit/armor/dragoon
	name = "drachen suit"
	desc = "A chainmail suit with dragon scales attached to the skeleton, with ash-covered mythril plate reinforcement covering it."
	icon_state = "dragoon"
	inhand_icon_state = "dragoon"
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	resistance_flags = FIRE_PROOF | ACID_PROOF
	allowed = list(/obj/item/spear/skybulge)
