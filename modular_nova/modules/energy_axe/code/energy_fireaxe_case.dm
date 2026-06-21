/obj/structure/closet/secure_closet/ds2atmos
	name = "能量斧柜"
	desc = "一个存放能量消防斧以及基本消防工具的柜子。"
	icon = 'modular_nova/modules/ds2_fluff/icons/closet_wide.dmi'
	icon_state = "energyaxe"
	req_access = list(ACCESS_SYNDICATE)

/obj/structure/closet/secure_closet/ds2atmos/PopulateContents()
	..()
	new /obj/item/fireaxe/energy(src)
	new /obj/item/extinguisher/advanced(src)
	new /obj/item/extinguisher/advanced(src)
	new /obj/item/clothing/suit/utility/fire/atmos(src)
	new /obj/item/tank/internals/oxygen/red(src)
	new /obj/item/clothing/gloves/atmos(src)
	new /obj/item/clothing/mask/gas/atmos(src)
	new /obj/item/clothing/head/utility/hardhat/welding/atmos(src)
