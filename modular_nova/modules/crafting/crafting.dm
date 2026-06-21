/datum/crafting_recipe/sm_sword/New()
	..()
	crafting_flags |= CRAFT_MUST_BE_LEARNED

/datum/crafting_recipe/beam_rifle/New()
	..()
	crafting_flags |= CRAFT_MUST_BE_LEARNED

// Makes it so only ghost roles can make it, as DS2 use it for their bounties and adds to their evil league of evil thing, item doesnt really do anything.
/datum/design/beamrifle/New()
	..()
	build_type  = AWAY_LATHE

/datum/crafting_recipe/armband/cargo
	name = "棕色臂章"
	reqs = list(/obj/item/stack/sheet/cloth = 1)
	result = /obj/item/clothing/accessory/armband/cargo/nonsec
	tool_paths = list(/obj/item/toy/crayon/spraycan)
	time = 3 SECONDS
	category = CAT_CLOTHING

/datum/crafting_recipe/armband/purple
	name = "紫色臂章"
	reqs = list(/obj/item/stack/sheet/cloth = 1)
	result = /obj/item/clothing/accessory/armband/science/nonsec
	tool_paths = list(/obj/item/toy/crayon/spraycan)
	time = 3 SECONDS
	category = CAT_CLOTHING

/datum/crafting_recipe/armband/orange
	name = "橙色臂章"
	reqs = list(/obj/item/stack/sheet/cloth = 1)
	result = /obj/item/clothing/accessory/armband/engine/nonsec
	tool_paths = list(/obj/item/toy/crayon/spraycan)
	time = 3 SECONDS
	category = CAT_CLOTHING

/datum/crafting_recipe/armband/green
	name = "绿蓝臂章"
	reqs = list(/obj/item/stack/sheet/cloth = 1)
	result = /obj/item/clothing/accessory/armband/hydro/nonsec
	tool_paths = list(/obj/item/toy/crayon/spraycan)
	time = 3 SECONDS
	category = CAT_CLOTHING

/datum/crafting_recipe/armband/white
	name = "白色臂章"
	reqs = list(/obj/item/stack/sheet/cloth = 1)
	result = /obj/item/clothing/accessory/armband/med/nonsec
	tool_paths = list(/obj/item/toy/crayon/spraycan)
	time = 3 SECONDS
	category = CAT_CLOTHING

/datum/crafting_recipe/armband/white_blue
	name = "白蓝臂章"
	reqs = list(/obj/item/stack/sheet/cloth = 1)
	result = /obj/item/clothing/accessory/armband/medblue/nonsec
	tool_paths = list(/obj/item/toy/crayon/spraycan)
	time = 3 SECONDS
	category = CAT_CLOTHING

/datum/crafting_recipe/armband/red
	name = "红色臂章"
	reqs = list(/obj/item/stack/sheet/cloth = 1)
	result = /obj/item/clothing/accessory/armband/nonsec
	tool_paths = list(/obj/item/toy/crayon/spraycan)
	time = 3 SECONDS
	category = CAT_CLOTHING
