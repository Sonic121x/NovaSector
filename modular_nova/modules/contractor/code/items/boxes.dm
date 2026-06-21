#define SMALL_ITEM_AMOUNT 2

/obj/item/storage/box/syndicate/contract_kit
	desc = "它只是个普通的盒子。"
	special_desc = "Supplied to Syndicate contractors."
	special_desc_requirement = EXAMINE_CHECK_CONTRACTOR
	/// Extra items to insert modularly into the list of random small item candidates
	var/static/list/modular_item_list = list(
		/obj/item/crowbar/power/syndicate,
		/obj/item/clothing/gloves/tackler/combat/insulated,
		/obj/item/storage/box/syndie_kit/emp,
		/obj/item/radio/headset/chameleon/advanced,
		/obj/item/shield/energy,
		/obj/item/healthanalyzer/rad_laser
		)

/obj/item/storage/box/syndicate/contractor_loadout
	desc = "它只是个普通的盒子。"
	special_desc_requirement = EXAMINE_CHECK_CONTRACTOR
	special_desc = "Supplied to Syndicate contractors, providing their specialised MODSuit and chameleon uniform."

/obj/item/storage/box/contractor/fulton_extraction/PopulateContents()
	new /obj/item/extraction_pack/contractor(src)
	new /obj/item/fulton_core(src)

/obj/item/storage/box/syndicate/contract_kit/midround/PopulateContents()
	new	/obj/item/crowbar/power/syndicate(src)
	new	/obj/item/storage/box/syndie_kit/emp(src)
	new	/obj/item/shield/energy(src)

	// finally. a real gun
	new /obj/item/storage/toolbox/guncase/traitor/contractor_fisher(src)

	// Paper guide
	new /obj/item/paper/contractor_guide/midround(src)
	new /obj/item/reagent_containers/hypospray/medipen/atropine(src)
	new /obj/item/jammer(src)
	new /obj/item/storage/fancy/cigarettes/cigpack_syndicate(src)
	new /obj/item/lighter(src)

#undef SMALL_ITEM_AMOUNT

/obj/item/storage/box/syndicate/contractor_loadout/stealth_contractor
	name = "潜行装备包"
	desc = "它只是个普通的盒子。"
	special_desc = "Supplied to Syndicate contractors. Intended to support stealthy operations."

/obj/item/storage/box/syndicate/contractor_loadout/stealth_contractor/PopulateContents()
	new /obj/item/fake_identity_kit(src)
	new /obj/item/clothing/head/chameleon(src)
	new /obj/item/clothing/mask/chameleon(src)
	new /obj/item/clothing/under/chameleon(src)
	new /obj/item/clothing/shoes/chameleon(src)

/obj/item/storage/box/syndicate/contractor_loadout/tools
	name = "紧凑工具箱"
	desc = "严格来说只是个工具箱，毕竟它只是个装着工具的盒子。"

/obj/item/storage/box/syndicate/contractor_loadout/tools/PopulateContents()
	new /obj/item/screwdriver/nuke(src)
	new /obj/item/wirecutters(src, "red")
	new /obj/item/multitool(src)
	new /obj/item/crowbar/red(src)
	new /obj/item/wrench(src)
	new /obj/item/weldingtool/largetank(src)
	new /obj/item/stack/cable_coil/thirty(src) // dual purpose: cablecuffs or fixing wires. no spare gloves because you already have them

/obj/item/gun/ballistic/automatic/pistol/clandestine/fisher/contractor
	spawn_magazine_type = /obj/item/ammo_box/magazine/m10mm/downer

/obj/item/storage/toolbox/guncase/traitor/contractor_fisher
	name = "承包商枪盒"
	weapon_to_spawn = /obj/item/gun/ballistic/automatic/pistol/clandestine/fisher/contractor // preloaded with sleeper bullets
	extra_to_spawn = /obj/item/ammo_box/magazine/m10mm/downer
	/// What other magazine do we spawn in our case?
	var/extra2_to_spawn = /obj/item/ammo_box/magazine/m10mm
	ammo_box_to_spawn = /obj/item/ammo_box/c10mm/downer

/obj/item/storage/toolbox/guncase/traitor/contractor_fisher/PopulateContents()
	new weapon_to_spawn (src) // 1 pistol
	new extra_to_spawn (src) // 1 spare sleeper mag, because oftentimes you'd rather not kill a guy
	new extra2_to_spawn (src) // 1 spare lethal mag, because sometimes you DO have to just kill a guy
	new ammo_box_to_spawn(src) // spare sleeper bullets
