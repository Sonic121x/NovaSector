/obj/item/weaponcrafting/silkstring
	name = "丝线"
	desc = "一根看起来像电缆卷的长线。"
	icon = 'modular_nova/modules/tribal_extended/icons/crafting.dmi'
	icon_state = "silkstring"

/obj/item/dice/d6/bone
	name = "骨制骰子"
	desc = "一个用生物骨头雕刻而成的骰子。干涸的血迹标记着凹陷的点数坑。"
	icon = 'modular_nova/modules/tribal_extended/icons/dice.dmi'
	icon_state = "db6"
	microwave_riggable = FALSE // You can't melt bone in the microwave
	resistance_flags = FIRE_PROOF | LAVA_PROOF
	custom_materials = list(/datum/material/bone = SHEET_MATERIAL_AMOUNT)

/obj/item/reagent_containers/cup/bowl/wood_bowl
	name = "木碗"
	desc = "一个用木头制成的碗。原始，但有效。"
	icon = 'modular_nova/modules/tribal_extended/icons/crafting.dmi'
	base_icon_state = "wood_bowl"
	icon_state = "wood_bowl"
	fill_icon_state = "fullbowl"
	fill_icon = 'icons/obj/mining_zones/ash_flora.dmi'
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 3)

