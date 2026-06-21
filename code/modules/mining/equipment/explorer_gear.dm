/****************Explorer's Suit and Mask****************/
/obj/item/clothing/suit/hooded/explorer
	name = "探险者套装"
	desc = "用于探索恶劣环境的盔甲。"
	icon_state = "explorer"
	icon = 'icons/obj/clothing/suits/utility.dmi'
	worn_icon = 'icons/mob/clothing/suits/utility.dmi'
	inhand_icon_state = null
	supports_variations_flags = CLOTHING_DIGITIGRADE_MASK
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	cold_protection = CHEST|GROIN|LEGS|ARMS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN|LEGS|ARMS
	max_heat_protection_temperature = SPACE_SUIT_MAX_TEMP_PROTECT
	hoodtype = /obj/item/clothing/head/hooded/explorer
	armor_type = /datum/armor/hooded_explorer
	resistance_flags = FIRE_PROOF

/obj/item/clothing/suit/hooded/explorer/get_general_color(icon/base_icon)
	return "#796755"

/datum/armor/hooded_explorer
	melee = 30
	bullet = 10
	laser = 10
	energy = 20
	bomb = 50
	fire = 50
	acid = 50
	wound = 10

/obj/item/clothing/head/hooded/explorer
	name = "探险者头罩"
	desc = "用于探索恶劣环境的装甲兜帽。"
	icon = 'icons/obj/clothing/head/utility.dmi'
	worn_icon = 'icons/mob/clothing/head/utility.dmi'
	icon_state = "explorer"
	body_parts_covered = HEAD
	flags_inv = HIDEHAIR|HIDEFACE|HIDEEARS
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_HELM_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = SPACE_SUIT_MAX_TEMP_PROTECT
	armor_type = /datum/armor/hooded_explorer
	resistance_flags = FIRE_PROOF

/obj/item/clothing/suit/hooded/explorer/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/armor_plate)
	allowed = GLOB.mining_suit_allowed

/obj/item/clothing/head/hooded/explorer/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/armor_plate)

/obj/item/clothing/mask/gas/explorer
	name = "探险者防毒面具"
	desc = "军用防毒面具，可以连接到空气供应系统。"
	icon_state = "gas_mining"
	inhand_icon_state = "explorer_gasmask"
	flags_cover = MASKCOVERSEYES | MASKCOVERSMOUTH
	visor_flags = BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS
	visor_flags_inv = HIDEFACIALHAIR
	visor_flags_cover = MASKCOVERSMOUTH
	actions_types = list(/datum/action/item_action/adjust)
	armor_type = /datum/armor/gas_explorer
	resistance_flags = FIRE_PROOF

/datum/armor/gas_explorer
	melee = 10
	bullet = 5
	laser = 5
	energy = 5
	bio = 50
	fire = 20
	acid = 40
	wound = 5

/obj/item/clothing/mask/gas/explorer/plasmaman
	starting_filter_type = /obj/item/gas_filter/plasmaman

/obj/item/clothing/mask/gas/explorer/attack_self(mob/user)
	adjust_visor(user)

/obj/item/clothing/mask/gas/explorer/visor_toggling()
	. = ..()
	// adjusted = out of the way = smaller = can fit in boxes
	update_weight_class(up ? WEIGHT_CLASS_SMALL : WEIGHT_CLASS_NORMAL)

/obj/item/clothing/mask/gas/explorer/update_icon_state()
	. = ..()
	inhand_icon_state = "[initial(inhand_icon_state)][up ? "_up" : ""]"

/obj/item/clothing/mask/gas/explorer/examine(mob/user)
	. = ..()
	if(up || w_class == WEIGHT_CLASS_SMALL)
		return
	. += span_notice("如果你调整一下，可以把它放进盒子里。")

/obj/item/clothing/mask/gas/explorer/folded
	w_class = WEIGHT_CLASS_SMALL

/obj/item/clothing/mask/gas/explorer/folded/Initialize(mapload)
	. = ..()
	visor_toggling()

/obj/item/clothing/suit/hooded/cloak
	icon = 'icons/obj/clothing/suits/armor.dmi'
	worn_icon = 'icons/mob/clothing/suits/armor.dmi'

/obj/item/clothing/suit/hooded/cloak/goliath
	name = "歌利亚斗篷"
	desc = "一件由多种稀有材料制成的坚固实用的披风，深受流亡者和隐士们的喜爱。"
	icon_state = "goliath_cloak"
	alternate_worn_layer = NECK_LAYER
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	cold_protection = CHEST|GROIN|LEGS|ARMS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN|LEGS|ARMS
	max_heat_protection_temperature = SPACE_SUIT_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF
	armor_type = /datum/armor/hooded_goliath
	hoodtype = /obj/item/clothing/head/hooded/cloakhood/goliath

/obj/item/clothing/suit/hooded/cloak/goliath/Initialize(mapload)
	. = ..()
	allowed = GLOB.mining_suit_allowed

/datum/armor/hooded_goliath
	melee = 60
	bullet = 10
	laser = 10
	energy = 20
	bomb = 50
	fire = 50
	acid = 50
	wound = 10

/obj/item/clothing/suit/hooded/cloak/goliath/click_alt(mob/user)
	if(!iscarbon(user))
		return NONE
	var/mob/living/carbon/char = user
	if((char.get_item_by_slot(ITEM_SLOT_NECK) == src) || (char.get_item_by_slot(ITEM_SLOT_OCLOTHING) == src))
		to_chat(user, span_warning("你不能在穿着[src]时调整它！"))
		return CLICK_ACTION_BLOCKING
	if(!user.is_holding(src))
		to_chat(user, span_warning("你必须手持[src]才能调整它！"))
		return CLICK_ACTION_BLOCKING
	if(slot_flags & ITEM_SLOT_OCLOTHING)
		slot_flags = ITEM_SLOT_NECK
		cold_protection = null
		heat_protection = null
		set_armor(/datum/armor/none)
		user.visible_message(span_notice("[user]将他们的[src]调整为仪式用途。"), span_notice("你将你的[src]调整为仪式用途。"))
	else
		slot_flags = initial(slot_flags)
		cold_protection = initial(cold_protection)
		heat_protection = initial(heat_protection)
		set_armor(initial(armor_type))
		user.visible_message(span_notice("[user]将他们的[src]调整为防御用途。"), span_notice("你将你的[src]调整为防御用途。"))
	return CLICK_ACTION_SUCCESS

/obj/item/clothing/head/hooded/cloakhood/goliath
	name = "歌利亚斗篷头罩"
	icon = 'icons/obj/clothing/head/helmet.dmi'
	worn_icon = 'icons/mob/clothing/head/helmet.dmi'
	icon_state = "golhood"
	desc = "一种具有保护性和遮蔽性的头罩。"
	armor_type = /datum/armor/hooded_goliath
	body_parts_covered = HEAD
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_HELM_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = SPACE_SUIT_MAX_TEMP_PROTECT
	clothing_flags = SNUG_FIT
	flags_inv = HIDEEARS|HIDEEYES|HIDEHAIR|HIDEFACIALHAIR
	transparent_protection = HIDEMASK
	resistance_flags = FIRE_PROOF

/obj/item/clothing/head/hooded/cloakhood/goliath/Initialize(mapload)
	. = ..()

/obj/item/clothing/suit/armor/bone
	name = "骨制护甲"
	desc = "一件部落护甲板，由动物骨骼制成。"
	icon_state = "bonearmor"
	inhand_icon_state = null
	blood_overlay_type = "armor"
	armor_type = /datum/armor/hooded_explorer
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS
	cold_protection = CHEST|GROIN|LEGS|ARMS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS
	max_heat_protection_temperature = SPACE_SUIT_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF
	custom_materials = list(/datum/material/bone = SHEET_MATERIAL_AMOUNT * 6)

/obj/item/clothing/suit/armor/bone/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/armor_plate, upgrade_item = /obj/item/clothing/accessory/talisman)
	allowed = GLOB.mining_suit_allowed

/obj/item/clothing/head/helmet/skull
	name = "颅骨头盔"
	desc = "一顶令人生畏的部落头盔，看起来不太舒服。"
	icon_state = "skull"
	inhand_icon_state = null
	strip_delay = 10 SECONDS
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDESNOUT
	flags_cover = HEADCOVERSEYES
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_HELM_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = SPACE_SUIT_MAX_TEMP_PROTECT
	armor_type = /datum/armor/hooded_explorer
	resistance_flags = FIRE_PROOF
	custom_materials = list(/datum/material/bone = SHEET_MATERIAL_AMOUNT * 4)

/obj/item/clothing/head/helmet/skull/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/armor_plate, upgrade_item = /obj/item/clothing/accessory/talisman)

/obj/item/clothing/suit/hooded/explorer/syndicate
	name = "辛迪加勘探服"
	desc = "一件用于探索恶劣环境的装甲服，染上了辛迪加那险恶的红黑色。这件似乎比纳米传讯发放的那些防护更好。"
	icon_state = "explorer_syndicate"
	icon = 'icons/obj/clothing/suits/utility.dmi'
	worn_icon = 'icons/mob/clothing/suits/utility.dmi'
	hoodtype = /obj/item/clothing/head/hooded/explorer/syndicate
	armor_type = /datum/armor/hooded_explorer_syndicate

/datum/armor/hooded_explorer_syndicate
	melee = 30
	bullet = 15
	laser = 25
	energy = 35
	bomb = 50
	fire = 60
	acid = 60
	wound = 10

/obj/item/clothing/head/hooded/explorer/syndicate
	name = "辛迪加勘探兜帽"
	desc = "用于探索恶劣环境的装甲兜帽。"
	icon_state = "explorer_syndicate"
	armor_type = /datum/armor/hooded_explorer_syndicate
