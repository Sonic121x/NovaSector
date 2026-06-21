// Interdyne survival box
/obj/item/storage/box/survival/interdyne
	name = "行动就绪生存箱"
	desc = "一个装有您行动必需品的箱子。这个箱子的标签显示它内含一个扩展容量气罐。"
	icon_state = "syndiebox"
	illustration = "extendedtank"
	mask_type = /obj/item/clothing/mask/neck_gaiter
	internal_type = /obj/item/tank/internals/emergency_oxygen/engi

/obj/item/storage/box/survival/interdyne/PopulateContents()
	..()
	new /obj/item/crowbar/red(src)
	new /obj/item/screwdriver/red(src)
	new /obj/item/weldingtool/mini(src)

