/obj/item/clothing/under/rank/expeditionary_corps
	name = "远征军团制服"
	desc = "为那些在银河边缘见识最险恶景象之人准备的耐用制服。"
	icon_state = "exp_corps"
	icon = 'modular_nova/master_files/icons/obj/clothing/uniforms.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/uniform.dmi'
	armor_type = /datum/armor/clothing_under/rank_expeditionary_corps
	strip_delay = 7 SECONDS
	alt_covers_chest = TRUE
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE

/datum/armor/clothing_under/rank_expeditionary_corps
	fire = 15
	acid = 15

/datum/atom_skin/expeditionary_corps_chest_rig
	abstract_type = /datum/atom_skin/expeditionary_corps_chest_rig

/datum/atom_skin/expeditionary_corps_chest_rig/webbing
	preview_name = "Webbing"
	new_icon_state = "webbing_exp_corps"

/datum/atom_skin/expeditionary_corps_chest_rig/belt
	preview_name = "Belt"
	new_icon_state = "belt_exp_corps"

/obj/item/storage/belt/military/expeditionary_corps
	name = "远征军团胸挂"
	desc = "一套由现已解散的先驱者远征军团穿戴的战术携行具。"
	icon_state = "webbing_exp_corps"
	worn_icon_state = "webbing_exp_corps"
	icon = 'modular_nova/master_files/icons/obj/clothing/belts.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/belt.dmi'

/obj/item/storage/belt/military/expeditionary_corps/setup_reskins()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/expeditionary_corps_chest_rig)

/obj/item/storage/belt/military/expeditionary_corps/combat_tech
	name = "战斗技术员胸挂"

/obj/item/storage/belt/military/expeditionary_corps/combat_tech/PopulateContents()
	new /obj/item/screwdriver(src)
	new /obj/item/wrench(src)
	new /obj/item/weldingtool(src)
	new /obj/item/crowbar(src)
	new /obj/item/wirecutters(src)
	new /obj/item/multitool(src)
	new /obj/item/stack/cable_coil(src)

/obj/item/storage/belt/military/expeditionary_corps/field_medic
	name = "战地医护兵胸挂"

/obj/item/storage/belt/military/expeditionary_corps/field_medic/PopulateContents()
	new /obj/item/scalpel(src)
	new /obj/item/circular_saw/field_medic(src)
	new /obj/item/hemostat(src)
	new /obj/item/retractor(src)
	new /obj/item/cautery(src)
	new /obj/item/surgical_drapes(src)
	new /obj/item/bonesetter(src)

/obj/item/storage/belt/military/expeditionary_corps/pointman
	name = "尖兵胸挂"

/obj/item/storage/belt/military/expeditionary_corps/pointman/PopulateContents()
	new /obj/item/reagent_containers/cup/glass/bottle/whiskey(src)
	new /obj/item/stack/sheet/plasteel(src,5)
	new /obj/item/reagent_containers/cup/bottle/morphine(src)

/obj/item/storage/belt/military/expeditionary_corps/marksman
	name = "神射手胸挂"

/obj/item/storage/belt/military/expeditionary_corps/marksman/PopulateContents()
	new /obj/item/binoculars(src)
	new /obj/item/storage/fancy/cigarettes/cigpack_robust(src)
	new /obj/item/lighter(src)
	new /obj/item/clothing/mask/bandana/skull(src)

/obj/item/clothing/shoes/combat/expeditionary_corps
	name = "远征军军靴"
	desc = "高速低阻作战靴。"
	icon = 'modular_nova/master_files/icons/obj/clothing/shoes.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/feet.dmi'
	icon_state = "exp_corps"
	inhand_icon_state = "jackboots"

/obj/item/clothing/gloves/color/black/expeditionary_corps
	name = "远征军手套"
	icon_state = "exp_corps"
	icon = 'modular_nova/master_files/icons/obj/clothing/gloves.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/hands.dmi'
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF

/obj/item/clothing/gloves/chief_engineer/expeditionary_corps
	name = "远征军绝缘手套"
	icon_state = "exp_corps_eng"
	icon = 'modular_nova/master_files/icons/obj/clothing/gloves.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/hands.dmi'
	worn_icon_state = "exp_corps"
	resistance_flags = FIRE_PROOF
	armor_type = /datum/armor/chief_engineer_expeditionary_corps
	clothing_traits = list(TRAIT_FAST_CUFFING) // parity with other black-gloves-likes

/datum/armor/chief_engineer_expeditionary_corps
	fire = 80
	acid = 50

/obj/item/clothing/gloves/latex/nitrile/expeditionary_corps
	name = "远征军医疗手套"
	icon_state = "exp_corps_med"
	icon = 'modular_nova/master_files/icons/obj/clothing/gloves.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/hands.dmi'
	worn_icon_state = "exp_corps"
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF
	armor_type = /datum/armor/nitrile_expeditionary_corps

/datum/armor/nitrile_expeditionary_corps
	fire = 80
	acid = 50

/datum/atom_skin/expeditionary_corps_bag
	abstract_type = /datum/atom_skin/expeditionary_corps_bag

/datum/atom_skin/expeditionary_corps_bag/backpack
	preview_name = "Backpack"
	new_icon_state = "exp_corps"

/datum/atom_skin/expeditionary_corps_bag/belt
	preview_name = "Belt"
	new_icon_state = "exp_corps_satchel"

/obj/item/storage/backpack/duffelbag/expeditionary_corps
	name = "远征军背包"
	desc = "用于存放额外战术补给的大型背包。"
	icon_state = "exp_corps"
	inhand_icon_state = "backpack"
	icon = 'modular_nova/modules/exp_corps/icons/backpack.dmi'
	worn_icon = 'modular_nova/modules/exp_corps/icons/mob_backpack.dmi'

/obj/item/storage/backpack/duffelbag/expeditionary_corps/setup_reskins()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/expeditionary_corps_bag)

/obj/item/clothing/suit/armor/vest/expeditionary_corps
	name = "远征军装甲背心"
	desc = "一件能对大多数类型伤害提供尚可防护的装甲背心。包含可隐藏的臂套。"
	icon = 'modular_nova/master_files/icons/obj/clothing/suits/armor.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/suits/armor.dmi'
	icon_state = "exp_corps"
	body_parts_covered = CHEST|GROIN|ARMS
	armor_type = /datum/armor/vest_expeditionary_corps
	cold_protection = CHEST|GROIN|ARMS
	heat_protection = CHEST|GROIN|ARMS
	dog_fashion = null
	allowed = list(
		/obj/item/melee,
		/obj/item/ammo_box,
		/obj/item/ammo_casing,
		/obj/item/flashlight,
		/obj/item/gun,
		/obj/item/knife,
		/obj/item/reagent_containers,
		/obj/item/restraints/handcuffs,
		/obj/item/tank/internals/emergency_oxygen,
		/obj/item/tank/internals/plasmaman,
		/obj/item/storage/belt/holster,
		/obj/item/storage/belt/machete,
		)


/datum/armor/vest_expeditionary_corps
	melee = 30
	bullet = 30
	laser = 30
	energy = 30
	bomb = 40
	fire = 80
	acid = 100
	wound = 10

/obj/item/clothing/head/helmet/expeditionary_corps
	name = "远征军头盔"
	desc = "远征军士兵佩戴的坚固头盔。Alt+点击以切换夜视系统。"
	icon_state = "exp_corps"
	icon = 'modular_nova/master_files/icons/obj/clothing/head/helmet.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/head/helmet.dmi'
	armor_type = /datum/armor/helmet_expeditionary_corps
	supports_variations_flags = CLOTHING_SNOUTED_VARIATION_NO_NEW_ICON
	var/nightvision = FALSE
	var/mob/living/carbon/current_user
	actions_types = list(/datum/action/item_action/toggle_nv_helmet)

/datum/armor/helmet_expeditionary_corps
	melee = 20
	bullet = 20
	laser = 20
	energy = 20
	bomb = 30
	fire = 80
	acid = 100
	wound = 10

/datum/action/item_action/toggle_nv_helmet
	name = "切换夜视"

/datum/action/item_action/toggle_nv_helmet/Trigger(trigger_flags)
	. = ..()
	if(!.)
		return
	var/obj/item/clothing/head/helmet/expeditionary_corps/my_helmet = target
	if(!my_helmet.current_user)
		return
	my_helmet.nightvision = !my_helmet.nightvision
	if(my_helmet.nightvision)
		to_chat(owner, span_notice("你将夜视护目镜翻了下来。"))
		my_helmet.enable_nv()
	else
		to_chat(owner, span_notice("你将夜视护目镜翻了上去。"))
		my_helmet.disable_nv()
	my_helmet.update_appearance()

/obj/item/clothing/head/helmet/expeditionary_corps/equipped(mob/user, slot)
	. = ..()
	current_user = user

/obj/item/clothing/head/helmet/expeditionary_corps/proc/enable_nv(mob/user)
	if(current_user)
		var/obj/item/organ/eyes/my_eyes = current_user.get_organ_by_type(/obj/item/organ/eyes)
		if(my_eyes)
			my_eyes.color_cutoffs = list(10, 30, 10)
			my_eyes.flash_protect = FLASH_PROTECTION_SENSITIVE
		current_user.add_client_colour(/datum/client_colour/glass_colour/lightgreen, REF(src))

/obj/item/clothing/head/helmet/expeditionary_corps/proc/disable_nv()
	if(current_user)
		var/obj/item/organ/eyes/my_eyes = current_user.get_organ_by_type(/obj/item/organ/eyes)
		if(my_eyes)
			my_eyes.color_cutoffs = initial(my_eyes.color_cutoffs)
			my_eyes.flash_protect = initial(my_eyes.flash_protect)
		current_user.remove_client_colour(/datum/client_colour/glass_colour/lightgreen, REF(src))
		current_user.update_sight()

/obj/item/clothing/head/helmet/expeditionary_corps/click_alt(mob/user)
	if(!current_user)
		return

	nightvision = !nightvision
	if(nightvision)
		to_chat(user, span_notice("你将夜视护目镜翻了下来。"))
		enable_nv()
	else
		to_chat(user, span_notice("你将夜视护目镜翻了上去。"))
		disable_nv()
	update_appearance()
	return CLICK_ACTION_SUCCESS

/obj/item/clothing/head/helmet/expeditionary_corps/dropped(mob/user)
	. = ..()
	disable_nv()
	current_user = null

/obj/item/clothing/head/helmet/expeditionary_corps/Destroy()
	disable_nv()
	current_user = null
	return ..()

/obj/item/clothing/head/helmet/expeditionary_corps/update_icon_state()
	. = ..()
	if(nightvision)
		icon_state = "exp_corps_on"
	else
		icon_state = "exp_corps"
