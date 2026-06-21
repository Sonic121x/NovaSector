
// this costume has so many fugging parts 😭. fuck it, it's a file.
//in fact, we should strive to make the chaplain kits of this quality, moreso than the other way around.

/// undersuit
/obj/item/clothing/under/rank/civilian/chaplain/divine_archer
	name = "神圣射手装束"
	desc = "神圣射手的贴身装束。"
	icon_state = "archergarb"
	inhand_icon_state = "archergarb"
	can_adjust = TRUE

/// suit
/obj/item/clothing/suit/hooded/chaplain_hoodie/divine_archer
	name = "神圣射手外套"
	desc = "神圣射手的外套。提供一定的保护。"
	icon_state = "archercoat"
	inhand_icon_state = "archercoat"
	body_parts_covered = CHEST|GROIN|LEGS
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	armor_type = /datum/armor/chaplainsuit_armor_weaker
	strip_delay = 8 SECONDS
	equip_delay_other = 6 SECONDS
	hoodtype = /obj/item/clothing/head/hooded/chaplain_hood/divine_archer
	hood_up_affix = ""

/datum/armor/chaplainsuit_armor_weaker
	melee = 40
	bullet = 5
	laser = 5
	energy = 5
	fire = 60
	acid = 60
	wound = 10

/// hood
/obj/item/clothing/head/hooded/chaplain_hood/divine_archer
	name = "神射手兜帽"
	desc = "附带一顶神圣兜帽，因为你在射箭时有没有被阳光晃过眼睛？哦，那真是太糟糕了。"
	icon_state = "archerhood"
	armor_type = /datum/armor/chaplainsuit_armor_weaker

/// gloves
/obj/item/clothing/gloves/divine_archer
	name = "神圣射手护腕"
	desc = "护腕，对于不想让服装妨碍拉弓和射击的弓箭手来说，这是个明智的选择。"
	icon_state = "archerbracers"
	inhand_icon_state = "archerbracers"
	body_parts_covered = ARMS|HANDS
	strip_delay = 4 SECONDS
	equip_delay_other = 2 SECONDS
	resistance_flags = NONE
	armor_type = /datum/armor/chaplainsuit_armor_weaker

/// boots
/obj/item/clothing/shoes/divine_archer
	name = "神圣射手靴"
	desc = "靴子，用于瞄准时保持稳定。"
	icon_state = "archerboots"
	inhand_icon_state = "archerboots"
	body_parts_covered = LEGS|FEET
	strip_delay = 3 SECONDS
	equip_delay_other = 5 SECONDS
	resistance_flags = NONE
	fastening_type = SHOES_SLIPON
	armor_type = /datum/armor/shoes_divine_archer

/datum/armor/shoes_divine_archer
	melee = 10
	bullet = 5
	laser = 5
	energy = 5
	fire = 60
	acid = 60
	wound = 10
