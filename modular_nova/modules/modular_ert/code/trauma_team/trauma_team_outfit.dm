/datum/outfit/centcom/ert/medic/traumateam //Medical ERT Trauma Team, Admin spawn only obviously
	name = "创伤小组"
	id = /obj/item/card/id/advanced/centcom/ert/medical/ntrauma
	uniform = /obj/item/clothing/under/rank/medical/paramedic
	suit = /obj/item/clothing/suit/space/ntrauma
	head = /obj/item/clothing/head/helmet/space/ntrauma
	glasses = /obj/item/clothing/glasses/hud/health/night
	ears = /obj/item/radio/headset/headset_cent/alt
	gloves = /obj/item/clothing/gloves/latex/nitrile/ntrauma
	l_hand = /obj/item/gun/energy/e_gun/stun
	r_hand = null //prevents giving them a second energy gun
	shoes = /obj/item/clothing/shoes/combat
	belt = /obj/item/storage/belt/medical/ntrauma
	back = /obj/item/storage/backpack/medic
	mask = /obj/item/clothing/mask/breath/medical
	l_pocket = /obj/item/healthanalyzer/advanced
	r_pocket = /obj/item/reagent_containers/hypospray/combat
	backpack_contents = list(
		/obj/item/melee/baton/security/loaded,\
		/obj/item/gun/energy/cell_loaded/medigun/upgraded,\
		/obj/item/storage/box/plastic/medicells,\
		/obj/item/storage/medkit/tactical/ntrauma,\
		/obj/item/emergency_bed,\
	)
	//Chosen cells are based off the worst things to deal with: TraumaTeam is built for worst-case scenarios, so they get a temperature cell and a better toxin cell

/datum/outfit/centcom/ert/medic/traumateam/leader //Very few differences, mostly just unique leader items - namely, a medbeam rather than a Veymed, a surgical implant, and a compact defib
	name = "创伤小组组长"
	belt = /obj/item/defibrillator/compact/combat/loaded/nanotrasen
	backpack_contents = list(
		/obj/item/melee/baton/security/loaded ,\
		/obj/item/gun/medbeam,\
		/obj/item/storage/medkit/tactical/ntrauma,\
		/obj/item/emergency_bed,\
		/obj/item/holosign_creator/medical/treatment_zone,\
		/obj/item/autosurgeon/syndicate/emaggedsurgerytoolset/single_use,\
	)

/*
*	UNIQUE ITEMS
*/

//A box of VeyGun cells, because storage is hell and these take up a LOT more than they're worth.
/obj/item/storage/box/plastic/medicells
	name = "医疗细胞盒"
	desc = "一个装有几种基础医疗细胞的盒子，专为维医疗CWM电池供电的医疗枪设计。"
	illustration = "medgel"

/obj/item/storage/box/plastic/medicells/PopulateContents()
	. = ..()
	new /obj/item/weaponcell/medical/brute(src)
	new /obj/item/weaponcell/medical/burn(src)
	new /obj/item/weaponcell/medical/toxin/tier_2(src)
	new /obj/item/weaponcell/medical/utility/temperature(src)
	new /obj/item/weaponcell/medical/utility/bed(src)

/datum/id_trim/centcom/ert/medical/ntrauma
	assignment = "Trauma Team Specialist"
	trim_state = "trim_highcleric"	//This is the CMO trim for the RPG Titles; considering it's 'angelic' sprite, it's fitting for these guardian angels
	sechud_icon_state = SECHUD_SCRAMBLED

/obj/item/card/id/advanced/centcom/ert/medical/ntrauma
	registered_name = "Trauma Team Specialist"
	trim = /datum/id_trim/centcom/ert/medical/ntrauma
	icon_state = "battlecruisercaller"	//Read desc
	desc = "一张半标准的黑色身份卡，上面似乎装有一个小型发射器，连接着一个可能装满访问令牌的小磁盘。虽然不是NT标准，但本质上和他们ERT的卡是一样的。"

/obj/item/storage/belt/medical/ntrauma
	name = "创伤胸挂"
	desc = "创伤响应小组穿戴的一套战术织带。"
	icon = 'modular_nova/master_files/icons/obj/clothing/belts.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/belt.dmi'
	icon_state = "ert_ntrauma"
	worn_icon_state = "ert_ntrauma"

/obj/item/storage/belt/medical/ntrauma/PopulateContents()
	new /obj/item/surgical_drapes(src)
	new /obj/item/scalpel/advanced(src)
	new	/obj/item/cautery/advanced(src)
	new /obj/item/retractor/advanced(src)
	new /obj/item/blood_filter/advanced(src)
	new /obj/item/holosign_creator/medical/treatment_zone(src)

/obj/item/storage/medkit/tactical/ntrauma
	name = "创伤医疗包"
	desc = "希望你买了保险，因为创伤小组的保费可不便宜。"

/obj/item/storage/medkit/tactical/ntrauma/PopulateContents()
	new /obj/item/reagent_containers/hypospray/medipen/atropine(src)
	new /obj/item/reagent_containers/hypospray/medipen/atropine(src)
	new /obj/item/stack/medical/wrap/gauze(src)
	new /obj/item/stack/medical/suture/medicated(src)
	new /obj/item/stack/medical/suture/medicated(src)
	new /obj/item/stack/medical/mesh/advanced(src)
	new /obj/item/stack/medical/mesh/advanced(src)
	new /obj/item/sensor_device(src)
	new /obj/item/pinpointer/crew (src)

/obj/item/clothing/gloves/latex/nitrile/ntrauma
	name = "创伤专家手套"
	desc = "创伤小组专家使用的丁腈替代手套。可密封以抵御压力，并带有独特（且昂贵）的防酸涂层，在处理化学危害时也能防止损坏。不过，它无法保护你身体的其他部位。"
	icon = 'modular_nova/master_files/icons/obj/clothing/gloves.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/hands.dmi'
	icon_state = "ert_ntrauma"
	alternate_worn_layer = ABOVE_BODY_FRONT_LAYER	//So the LONG gloves can be shown off
	resistance_flags = FIRE_PROOF | ACID_PROOF
	clothing_flags = STOPSPRESSUREDAMAGE | THICKMATERIAL //Combines with spacesuit

/obj/item/clothing/suit/space/ntrauma
	name = "创伤小组软式太空服"
	desc = "创伤小组用于在各种潜在危险环境中操作的轻量、低防护且完全无菌的软式太空服。表面涂有防酸化学品。"
	icon = 'modular_nova/master_files/icons/obj/clothing/suits/spacesuit.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/suits/spacesuit.dmi'
	worn_icon_digi = 'modular_nova/master_files/icons/mob/clothing/suits/spacesuit_digi.dmi'
	icon_state = "ert_ntrauma"
	inhand_icon_state = "syndicate-blue"
	slowdown = 0.3
	armor_type = /datum/armor/space_ntrauma
	resistance_flags = ACID_PROOF
	body_parts_covered = CHEST|GROIN|LEGS|ARMS|FEET
	cell = /obj/item/stock_parts/power_store/cell/hyper
	allowed = list(/obj/item/gun/energy, /obj/item/gun/medbeam, /obj/item/melee/baton, /obj/item/storage/medkit, /obj/item/tank/internals)

/datum/armor/space_ntrauma
	melee = 10
	bullet = 10
	laser = 10
	energy = 10
	bomb = 10
	bio = 100
	fire = 80
	acid = 80

/obj/item/clothing/head/helmet/space/ntrauma
	name = "创伤小组头盔"
	desc = "一种无面罩的白色头盔，可与软式太空服密封配合，供创伤小组在潜在危险环境中操作使用。表面涂有防酸化学品。"
	icon = 'modular_nova/master_files/icons/obj/clothing/head/helmet.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/head/helmet.dmi'
	icon_state = "ert_ntrauma"
	resistance_flags = ACID_PROOF
	supports_variations_flags = NONE	//Also good GOD I didnt want to re-sprite this helmet
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
