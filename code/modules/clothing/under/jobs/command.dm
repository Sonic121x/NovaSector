/obj/item/clothing/under/rank/captain
	desc = "那是件蓝色的连身衣，上面有一些金色的标记，代表着“上尉”的军衔。"
	name = "舰长连身衣"
	icon_state = "captain"
	inhand_icon_state = "b_suit"
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE
	icon = 'icons/obj/clothing/under/captain.dmi'
	worn_icon = 'icons/mob/clothing/under/captain.dmi'
	armor_type = /datum/armor/clothing_under/rank_captain

/datum/armor/clothing_under/rank_captain
	wound = 15

/obj/item/clothing/under/rank/captain/skirt
	name = "舰长连身裙"
	desc = "那是件蓝色的连身裙，上面有一些金色的标记，代表着“上尉”的军衔。"
	icon_state = "captain_skirt"
	inhand_icon_state = "b_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/captain/parade
	name = "舰长的正装制服"
	desc = "船长的豪华服装，在特殊场合穿上."
	icon_state = "captain_parade"
	inhand_icon_state = null
	can_adjust = FALSE

/obj/item/clothing/under/rank/captain/royal
	name = "captain's royal uniform"
	desc = "A captain's royal uniform. Fit for commanding your Officers in the midst of a nuclear incursion."
	icon_state = "caproyal"
