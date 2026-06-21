/* Utility Closets
 * Contains:
 * Emergency Closet
 * Fire Closet
 * Tool Closet
 * Radiation Closet
 * Bombsuit Closet
 * Hydrant
 * First Aid
 */

/*
 * Emergency Closet
 */
/obj/structure/closet/emcloset
	name = "应急储藏柜"
	desc = "这是一个应急口罩和氧气罐的存储单元。"
	icon_state = "emergency"

/obj/structure/closet/emcloset/anchored
	anchored = TRUE

/obj/structure/closet/emcloset/Initialize(mapload)
	if(HAS_TRAIT(SSstation, STATION_TRAIT_RADIOACTIVE_NEBULA) && prob(30))
		new /obj/structure/closet/radiation(loc)
		return INITIALIZE_HINT_QDEL

	. = ..()

	if (prob(1))
		return INITIALIZE_HINT_QDEL

/obj/structure/closet/emcloset/PopulateContents()
	..()

	new /obj/item/storage/box/emergency_spacesuit(src) // NOVA EDIT ADD

	if (prob(40))
		new /obj/item/storage/toolbox/emergency(src)

	switch (pick_weight(list("small" = 20, "aid" = 20, "tank" = 20, "both" = 30))) // NOVA EDIT CHANGE - ORIGINAL: switch (pick_weight(list("small" = 20, "aid" = 20, "tank" = 20, "both" = 30, "nothing" = 10)))
		if ("small")
			new /obj/item/tank/internals/emergency_oxygen(src)
			new /obj/item/tank/internals/emergency_oxygen(src)
			new /obj/item/clothing/mask/breath(src)
			new /obj/item/clothing/mask/breath(src)

		if ("aid")
			new /obj/item/tank/internals/emergency_oxygen(src)
			new /obj/item/storage/medkit/emergency(src)
			new /obj/item/clothing/mask/breath(src)

		if ("tank")
			new /obj/item/tank/internals/oxygen(src)
			new /obj/item/clothing/mask/breath(src)

		if ("both")
			new /obj/item/tank/internals/emergency_oxygen(src)
			new /obj/item/clothing/mask/breath(src)

		// NOVA EDIT REMOVAL START
		/*
		if ("nothing")
			// doot
			pass()
		*/
		// NOVA EDIT REMOVAL END

/*
 * Fire Closet
 */
/obj/structure/closet/firecloset
	name = "消防安全柜"
	desc = "这是一个储存消防物资的单元。"
	icon_state = "fire"

/obj/structure/closet/firecloset/PopulateContents()
	..()
	new /obj/item/clothing/suit/utility/fire/firefighter(src)
	new /obj/item/clothing/mask/gas/alt(src) //NOVA EDIT CHANGE - ORIGINAL: /obj/item/clothing/mask/gas(src)
	new /obj/item/tank/internals/oxygen/red(src)
	new /obj/item/extinguisher(src)
	new /obj/item/clothing/head/utility/hardhat/red(src)
	new /obj/item/crowbar/large/emergency(src)
	new /obj/item/storage/inflatable(src) //NOVA EDIT ADDITION - INFLATABLES

/obj/structure/closet/firecloset/full/PopulateContents()
	new /obj/item/clothing/suit/utility/fire/firefighter(src)
	new /obj/item/clothing/mask/gas/alt(src) //NOVA EDIT CHANGE - ORIGINAL: /obj/item/clothing/mask/gas(src)
	new /obj/item/flashlight(src)
	new /obj/item/tank/internals/oxygen/red(src)
	new /obj/item/extinguisher(src)
	new /obj/item/clothing/head/utility/hardhat/red(src)
	new /obj/item/crowbar/large/emergency(src)


/*
 * Tool Closet
 */
/obj/structure/closet/toolcloset
	name = "工具柜"
	desc = "这是一个工具储存单元。"
	icon_state = "eng"
	icon_door = "eng_tool"

/obj/structure/closet/toolcloset/PopulateContents()
	..()
	if(prob(40))
		new /obj/item/clothing/suit/hazardvest(src)
	if(prob(70))
		new /obj/item/flashlight(src)
	if(prob(70))
		new /obj/item/screwdriver(src)
	if(prob(70))
		new /obj/item/wrench(src)
	if(prob(70))
		new /obj/item/weldingtool(src)
	if(prob(70))
		new /obj/item/crowbar(src)
	if(prob(70))
		new /obj/item/wirecutters(src)
	if(prob(70))
		new /obj/item/t_scanner(src)
	if(prob(20))
		new /obj/item/storage/belt/utility(src)
	if(prob(30))
		new /obj/item/stack/cable_coil(src)
	if(prob(30))
		new /obj/item/stack/cable_coil(src)
	if(prob(30))
		new /obj/item/stack/cable_coil(src)
	if(prob(20))
		new /obj/item/multitool(src)

	if(prob(40))
		new /obj/item/clothing/head/utility/hardhat(src)


/obj/structure/closet/toolcloset/populate_contents_immediate()
	. = ..()

	// Since they're a traitor objective, they have to be generated immediately.
	if(prob(5))
		new /obj/item/clothing/gloves/color/yellow(src)

/*
 * Radiation Closet
 */
/obj/structure/closet/radiation
	name = "防辐射衣柜"
	desc = "这是一个辐射防护服的储存单元。"
	icon_state = "eng"
	icon_door = "eng_rad"

/obj/structure/closet/radiation/PopulateContents()
	..()
	new /obj/item/geiger_counter(src)
	new /obj/item/clothing/suit/utility/radiation(src)
	new /obj/item/clothing/head/utility/radiation(src)

/*
 * Bombsuit closet
 */
/obj/structure/closet/bombcloset
	name = "\improper 排爆柜"
	desc = "这是防爆服的储藏柜。"
	icon_state = "bomb"

/obj/structure/closet/bombcloset/PopulateContents()
	..()
	new /obj/item/clothing/suit/utility/bomb_suit(src)
	new /obj/item/clothing/under/color/black(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/head/utility/bomb_hood(src)

/obj/structure/closet/bombcloset/security/PopulateContents()
	new /obj/item/clothing/suit/utility/bomb_suit/security(src)
	new /obj/item/clothing/under/rank/security/officer(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/clothing/head/utility/bomb_hood/security(src)

/obj/structure/closet/bombcloset/white/PopulateContents()
	new /obj/item/clothing/suit/utility/bomb_suit/white(src)
	new /obj/item/clothing/under/color/black(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/head/utility/bomb_hood/white(src)
