/obj/item/clothing/suit/jacket/straight_jacket
	name = "束缚衣"
	desc = "能完全束缚穿着者的套装，由‘Antyphun’公司制造。" //Straight jacket is antifun
	icon_state = "straight_jacket"
	inhand_icon_state = "straight_jacket"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	equip_delay_self = 5 SECONDS
	strip_delay = 6 SECONDS
	breakouttime = 5 MINUTES

/obj/item/clothing/suit/jacket/straight_jacket/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_DANGEROUS_OBJECT, INNATE_TRAIT)
