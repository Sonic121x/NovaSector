/obj/item/clothing/under/rank/civilian/curator
	name = "得体的西装"
	desc = "很……明智的。"
	icon = 'icons/obj/clothing/under/suits.dmi'
	icon_state = "red_suit"
	inhand_icon_state = null
	worn_icon = 'icons/mob/clothing/under/suits.dmi'
	can_adjust = FALSE

/obj/item/clothing/under/rank/civilian/curator/skirt
	name = "得体的西装裙"
	desc = "It's very... sensible."
	icon = 'icons/obj/clothing/under/suits.dmi'
	icon_state = "red_suit_skirt"
	inhand_icon_state = null
	worn_icon = 'icons/mob/clothing/under/suits.dmi'
	body_parts_covered = CHEST|GROIN|ARMS
	can_adjust = FALSE
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/civilian/curator/treasure_hunter
	name = "赏金猎人制服"
	desc = "一件很适合寻宝的坚固制服。"
	icon = 'icons/obj/clothing/under/civilian.dmi'
	icon_state = "curator"
	inhand_icon_state = null
	worn_icon = 'icons/mob/clothing/under/civilian.dmi'

/obj/item/clothing/under/rank/civilian/curator/treasure_hunter/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, -5)

/obj/item/clothing/under/rank/civilian/curator/nasa
	name = "\improper NASA连身衣"
	desc = "它上面有美国国家航空航天局（NASA）的标志，由太空防护材料制成."
	icon = 'icons/map_icons/clothing/under/color.dmi'
	icon_state = "/obj/item/clothing/under/color"
	post_init_icon_state = "jumpsuit"
	inhand_icon_state = "jumpsuit"
	flags_1 = parent_type::flags_1 | NO_NEW_GAGS_PREVIEW_1
	greyscale_config = /datum/greyscale_config/jumpsuit
	greyscale_config_worn = /datum/greyscale_config/jumpsuit/worn
	greyscale_config_inhand_left = /datum/greyscale_config/jumpsuit/inhand_left
	greyscale_config_inhand_right = /datum/greyscale_config/jumpsuit/inhand_right
	greyscale_colors = "#3f3f3f"
	w_class = WEIGHT_CLASS_BULKY
	armor_type = /datum/armor/clothing_under/curator_nasa
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST | GROIN | LEGS | ARMS //Needs gloves and shoes with cold protection to be fully protected.
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = SPACE_SUIT_MAX_TEMP_PROTECT
	can_adjust = FALSE
	resistance_flags = NONE

/datum/armor/clothing_under/curator_nasa
	bio = 95
