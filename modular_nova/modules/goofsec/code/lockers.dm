// Departmental guard lockers
/obj/structure/closet/secure_closet/security/cargo
	name = "\proper 海关特工储物柜"
	req_access = list(ACCESS_BRIG_ENTRANCE, ACCESS_CARGO)
	icon_state = "qm"
	icon = 'icons/obj/storage/closet.dmi'

/obj/structure/closet/secure_closet/security/cargo/PopulateContents()
	new /obj/item/ammo_box/advanced/pepperballs(src)
	new /obj/item/restraints/handcuffs/cable/orange(src)
	new /obj/item/assembly/flash/handheld(src)
	new /obj/item/storage/bag/garment/customs_agent(src)

/obj/structure/closet/secure_closet/security/engine
	name = "\proper 工程守卫储物柜"
	req_access = list(ACCESS_BRIG_ENTRANCE, ACCESS_ENGINEERING)
	icon_state = "eng_secure"
	icon = 'icons/obj/storage/closet.dmi'

/obj/structure/closet/secure_closet/security/engine/PopulateContents()
	new /obj/item/ammo_box/advanced/pepperballs(src)
	new /obj/item/restraints/handcuffs/cable/yellow(src)
	new /obj/item/assembly/flash/handheld(src)
	new /obj/item/storage/bag/garment/engineering_guard(src)

/obj/structure/closet/secure_closet/security/science
	name = "\proper 科研守卫储物柜"
	req_access = list(ACCESS_BRIG_ENTRANCE, ACCESS_RESEARCH)
	icon_state = "science"
	icon = 'icons/obj/storage/closet.dmi'

/obj/structure/closet/secure_closet/security/science/PopulateContents()
	new /obj/item/ammo_box/advanced/pepperballs(src)
	new /obj/item/restraints/handcuffs/cable/pink(src)
	new /obj/item/assembly/flash/handheld(src)
	new /obj/item/storage/bag/garment/science_guard(src)

/obj/structure/closet/secure_closet/security/med
	name = "\proper 医护兵储物柜"
	req_access = list(ACCESS_BRIG_ENTRANCE, ACCESS_MEDICAL)
	icon_state = "med_secure"
	icon = 'icons/obj/storage/closet.dmi'

/obj/structure/closet/secure_closet/security/med/PopulateContents()
	new /obj/item/ammo_box/advanced/pepperballs(src)
	new /obj/item/restraints/handcuffs/cable/blue(src)
	new /obj/item/assembly/flash/handheld(src)
	new /obj/item/storage/bag/garment/orderly(src)

/obj/structure/closet/secure_closet/security/service
	name = "\proper 服务区守卫储物柜"
	req_access = list(ACCESS_BRIG_ENTRANCE, ACCESS_SERVICE)
	icon_state = "serviceguard"
	icon = 'modular_nova/master_files/icons/obj/closet.dmi'

/obj/structure/closet/secure_closet/security/service/PopulateContents()
	new /obj/item/ammo_box/advanced/pepperballs(src)
	new /obj/item/restraints/handcuffs/cable/green(src)
	new /obj/item/assembly/flash/handheld(src)
	new /obj/item/storage/bag/garment/service_guard(src)

//Prisoner Lockers

/obj/structure/closet/secure_closet/brig/PopulateContents()
	..()

	new /obj/item/clothing/head/playbunnyears/prisoner(src)
	new /obj/item/clothing/under/rank/security/prisoner_bunnysuit(src)
	new /obj/item/clothing/neck/tie/bunnytie/prisoner(src)

