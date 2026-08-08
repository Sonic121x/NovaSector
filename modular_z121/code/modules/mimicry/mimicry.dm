/obj/item/nullrod/mimicry
	name = "拟态"
	desc = "对这种怪异的类人型生物的组织仿制是失败的，当那武器上不可名状的眼睛注视着你的时候，你的身体会不由得颤抖起来。\
	持有者能够将这把武器的能力发挥到极致，那么挥舞它足以造成毁灭性的后果。"
	icon = 'modular_z121/icons/obj/melee/mimicry/mimicry.dmi'
	icon_state = "mimicry"
	inhand_icon_state = "mimicry"
	worn_icon = 'modular_z121/icons/obj/melee/mimicry/mimicry_belt.dmi'
	icon_angle = -45
	lefthand_file = 'modular_z121/icons/mob/melee/mimicry/mimi_left_64x64.dmi'
	righthand_file = 'modular_z121/icons/mob/melee/mimicry/mimi_left_64x64.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	hitsound = 'sound/items/weapons/bladeslice.ogg'
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK|ITEM_SLOT_BELT
	block_chance = 30
	block_sound = 'sound/items/weapons/parry.ogg'
	sharpness = SHARP_EDGED
	attack_verb_continuous = list("attacks", "slashes", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("attack", "slash", "slice", "tear", "lacerate", "rip", "dice", "cut")
	menu_description = "A sharp claymore which provides a low chance of blocking incoming melee attacks. Can be worn on the back or belt."
	var/list/alt_continuous = list("stabs", "pierces", "impales")
	var/list/alt_simple = list("stab", "pierce", "impale")
	menu_description = "一把有轻微格挡机会的利刃，可以佩戴在腰带位或背包位"
