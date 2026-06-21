// Closets for specific jobs

/obj/structure/closet/gmcloset
	name = "正装衣橱"
	desc = "这是一个存放正装的储藏柜。"
	icon_door = "bar_wardrobe"

/obj/structure/closet/gmcloset/PopulateContents()
	..()
	var/list/items_inside = list(
		/obj/item/clothing/head/hats/tophat = 2,
		/obj/item/radio/headset/headset_srv = 2,
		/obj/item/clothing/under/costume/buttondown/slacks/service = 2,
		/obj/item/clothing/accessory/waistcoat = 2,
		/obj/item/clothing/head/soft/black = 2,
		/obj/item/clothing/shoes/sneakers/black = 2,
		/obj/item/rag = 2,
		/obj/item/storage/box/beanbag = 1,
		/obj/item/clothing/suit/armor/vest/alt = 1,
		/obj/item/circuitboard/machine/dish_drive = 1,
		/obj/item/clothing/glasses/sunglasses/reagent = 1,
		/obj/item/clothing/neck/petcollar = 1,
		/obj/item/storage/belt/bandolier = 1)
	generate_items_inside(items_inside,src)

/obj/structure/closet/chefcloset
	name = "厨师的衣橱"
	desc = "这是一个存放餐饮服务服装和捕鼠夹的储物单元。"
	icon_door = "chef_wardrobe"

/obj/structure/closet/chefcloset/PopulateContents()
	..()
	var/list/items_inside = list(
		/obj/item/clothing/under/suit/waiter = 2,
		/obj/item/radio/headset/headset_srv = 2,
		/obj/item/clothing/accessory/waistcoat = 2,
		/obj/item/clothing/suit/apron/chef = 3,
		/obj/item/clothing/head/soft/mime = 2,
		/obj/item/storage/box/mousetraps = 2,
		/obj/item/circuitboard/machine/dish_drive = 1,
		/obj/item/clothing/suit/toggle/chef = 1,
		/obj/item/clothing/under/costume/buttondown/slacks/service = 1,
		/obj/item/clothing/head/utility/chefhat = 1,
		/obj/item/rag = 1)
	generate_items_inside(items_inside,src)

/obj/structure/closet/jcloset
	name = "清洁储物柜"
	desc = "一个专门用于存放清洁工服装和工具的存储单元。"
	icon_door = "jani_wardrobe"

/obj/structure/closet/jcloset/PopulateContents()
	..()
	new /obj/item/clothing/under/rank/civilian/janitor(src)
	new /obj/item/clothing/gloves/color/black(src)
	new /obj/item/clothing/head/soft/purple(src)
	new /obj/item/paint/paint_remover(src)
	new /obj/item/melee/flyswatter(src)
	new /obj/item/flashlight(src)
	for(var/i in 1 to 3)
		new /obj/item/clothing/suit/caution(src)
	new /obj/item/holosign_creator(src)
	new /obj/item/lightreplacer(src)
	new /obj/item/soap(src)
	new /obj/item/storage/bag/trash(src)
	new /obj/item/clothing/shoes/galoshes(src)
	new /obj/item/watertank/janitor(src)
	new /obj/item/storage/belt/janitor(src)

	//NOVA EDIT ADDITION
	new /obj/item/air_refresher(src)
	new /obj/item/air_refresher(src)
	//NOVA EDIT END

/obj/structure/closet/lawcloset
	name = "法律衣橱"
	desc = "一个专门用于存放法庭相关服装和物品的存储单元。"
	icon_door = "law_wardrobe"

/obj/structure/closet/lawcloset/PopulateContents()
	..()
	new /obj/item/clothing/under/suit/black(src)
	new /obj/item/clothing/under/rank/civilian/lawyer/beige(src)
	new /obj/item/clothing/under/rank/civilian/lawyer/black(src)
	new /obj/item/clothing/under/rank/civilian/lawyer/red(src)
	new /obj/item/clothing/under/rank/civilian/lawyer/bluesuit(src)
	new /obj/item/clothing/neck/tie/blue(src)
	new /obj/item/clothing/suit/toggle/lawyer(src)
	new /obj/item/clothing/under/rank/civilian/lawyer/purpsuit(src)
	new /obj/item/clothing/suit/toggle/lawyer/purple(src)
	new /obj/item/clothing/under/costume/buttondown/slacks/service(src)
	new /obj/item/clothing/neck/tie/black(src)
	new /obj/item/clothing/suit/toggle/lawyer/black(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/clothing/shoes/laceup(src)

/obj/structure/closet/lawcloset/populate_contents_immediate()
	. = ..()
	new /obj/item/clothing/accessory/lawyers_badge(src)
	new /obj/item/clothing/accessory/lawyers_badge(src)

/obj/structure/closet/wardrobe/chaplain_black
	name = "礼拜堂衣柜"
	desc = "一个专门用于存放被纳米传讯批准的宗教服饰的存储单元。"
	icon_door = "chap_wardrobe"

/obj/structure/closet/wardrobe/chaplain_black/PopulateContents()
	new /obj/item/choice_beacon/holy(src)
	new /obj/item/clothing/accessory/pocketprotector/cosmetology(src)
	new /obj/item/clothing/under/rank/civilian/chaplain(src)
	new /obj/item/clothing/shoes/sneakers/black(src)
	new /obj/item/clothing/suit/chaplainsuit/nun(src)
	new /obj/item/clothing/head/chaplain/nun_hood(src)
	new /obj/item/clothing/suit/hooded/chaplainsuit/monkhabit(src)
	new /obj/item/clothing/suit/chaplainsuit/holidaypriest(src)
	new /obj/item/storage/backpack/cultpack(src)
	new /obj/item/storage/fancy/candle_box(src)
	new /obj/item/storage/fancy/candle_box(src)
	return

/obj/structure/closet/wardrobe/red
	name = "安保衣柜"
	icon_door = "sec_wardrobe"

/obj/structure/closet/wardrobe/red/PopulateContents()
	var/list/items_inside = list(
		/obj/item/clothing/suit/hooded/wintercoat/security = 1,
		/obj/item/storage/backpack/security = 1,
		/obj/item/storage/backpack/satchel/sec = 1,
		/obj/item/storage/backpack/duffelbag/sec = 2,
		/obj/item/storage/backpack/messenger/sec = 1,
		/obj/item/clothing/under/rank/security/officer = 3,
		/obj/item/clothing/under/rank/security/officer/skirt = 2,
		/obj/item/clothing/shoes/jackboots = 3,
		/obj/item/clothing/head/beret/sec = 3,
		/obj/item/clothing/head/soft/sec = 3,
		/obj/item/clothing/mask/bandana/red = 2)
	generate_items_inside(items_inside,src)
	return

/obj/structure/closet/wardrobe/cargotech
	name = "货舱衣柜"
	icon_door = "cargo_wardrobe"

/obj/structure/closet/wardrobe/cargotech/PopulateContents()
	var/list/items_inside = list(
		/obj/item/clothing/suit/hooded/wintercoat/cargo = 1,
		/obj/item/clothing/under/rank/cargo/tech = 3,
		/obj/item/clothing/shoes/sneakers/black = 3,
		/obj/item/clothing/gloves/fingerless = 3,
		/obj/item/clothing/head/soft = 3,
		/obj/item/radio/headset/headset_cargo = 1)
	generate_items_inside(items_inside,src)

/obj/structure/closet/wardrobe/atmospherics_yellow
	name = "大气衣柜"
	icon_door = "atmos_wardrobe"

/obj/structure/closet/wardrobe/atmospherics_yellow/PopulateContents()
	var/list/items_inside = list(
		/obj/item/clothing/accessory/pocketprotector = 1,
		/obj/item/storage/backpack/duffelbag/engineering = 1,
		/obj/item/storage/backpack/satchel/eng = 1,
		/obj/item/storage/backpack/industrial = 1,
		/obj/item/storage/backpack/messenger/eng = 1,
		/obj/item/clothing/suit/atmos_overalls = 3,
		/obj/item/clothing/suit/hooded/wintercoat/engineering/atmos = 3,
		/obj/item/clothing/under/rank/engineering/atmospheric_technician = 3,
		/obj/item/clothing/shoes/sneakers/black = 3)
	generate_items_inside(items_inside,src)
	return

/obj/structure/closet/wardrobe/engineering_yellow
	name = "工程衣柜"
	icon_door = "engi_wardrobe"

/obj/structure/closet/wardrobe/engineering_yellow/PopulateContents()
	var/list/items_inside = list(
		/obj/item/clothing/accessory/pocketprotector = 1,
		/obj/item/storage/backpack/duffelbag/engineering = 1,
		/obj/item/storage/backpack/industrial = 1,
		/obj/item/storage/backpack/satchel/eng = 1,
		/obj/item/storage/backpack/messenger/eng = 1,
		/obj/item/clothing/suit/hooded/wintercoat/engineering = 1,
		/obj/item/clothing/under/rank/engineering/engineer = 3,
		/obj/item/clothing/suit/hazardvest = 3,
		/obj/item/clothing/shoes/workboots = 3,
		/obj/item/clothing/head/utility/hardhat = 3)
	generate_items_inside(items_inside,src)
	return

/obj/structure/closet/wardrobe/white/medical
	name = "医生衣柜"
	icon_door = "med_wardrobe"

/obj/structure/closet/wardrobe/white/medical/PopulateContents()
	var/list/items_inside = list(
		/obj/item/clothing/accessory/pocketprotector = 1,
		/obj/item/storage/backpack/duffelbag/med = 1,
		/obj/item/storage/backpack/medic = 1,
		/obj/item/storage/backpack/satchel/med = 1,
		/obj/item/storage/backpack/messenger/med = 1,
		/obj/item/clothing/suit/hooded/wintercoat/medical = 1,
		/obj/item/clothing/head/costume/nursehat = 1,
		/obj/item/clothing/under/rank/medical/scrubs/blue = 1,
		/obj/item/clothing/under/rank/medical/scrubs/green = 1,
		/obj/item/clothing/under/rank/medical/scrubs/purple = 1,
		/obj/item/clothing/suit/toggle/labcoat = 3,
		/obj/item/clothing/suit/toggle/labcoat/paramedic = 3,
		/obj/item/clothing/shoes/sneakers/white = 3,
		/obj/item/clothing/head/soft/paramedic = 3)
	generate_items_inside(items_inside,src)
	return

/obj/structure/closet/wardrobe/robotics_black
	name = "机器人学衣柜"
	icon_door = "robo_wardrobe"

/obj/structure/closet/wardrobe/robotics_black/PopulateContents()
	var/list/items_inside = list(
		/obj/item/clothing/glasses/hud/diagnostic = 2,
		/obj/item/clothing/under/rank/rnd/roboticist = 2,
		/obj/item/clothing/suit/toggle/labcoat = 2,
		/obj/item/clothing/shoes/sneakers/black = 2,
		/obj/item/clothing/gloves/fingerless = 2,
		/obj/item/clothing/head/soft/black = 2)
	generate_items_inside(items_inside,src)
	if(prob(40))
		new /obj/item/clothing/mask/bandana/skull/black(src)
	if(prob(40))
		new /obj/item/clothing/mask/bandana/skull/black(src)
	return


/obj/structure/closet/wardrobe/chemistry_white
	name = "化学衣柜"
	icon_door = "chem_wardrobe"

/obj/structure/closet/wardrobe/chemistry_white/PopulateContents()
	var/list/items_inside = list(
		/obj/item/clothing/under/rank/medical/chemist = 2,
		/obj/item/clothing/shoes/sneakers/white = 2,
		/obj/item/clothing/suit/toggle/labcoat/chemist = 2,
		/obj/item/storage/backpack/chemistry = 2,
		/obj/item/storage/backpack/satchel/chem = 2,
		/obj/item/storage/backpack/messenger/chem = 2,
		/obj/item/storage/backpack/duffelbag/chemistry = 2,
		/obj/item/storage/bag/chemistry = 2)
	generate_items_inside(items_inside,src)
	return


/obj/structure/closet/wardrobe/genetics_white
	name = "基因学衣柜"
	icon_door = "gen_wardrobe"

/obj/structure/closet/wardrobe/genetics_white/PopulateContents()
	var/list/items_inside = list(
		/obj/item/clothing/under/rank/rnd/geneticist = 2,
		/obj/item/clothing/shoes/sneakers/white = 2,
		/obj/item/clothing/suit/toggle/labcoat/genetics = 2,
		/obj/item/storage/backpack/genetics = 2,
		/obj/item/storage/backpack/satchel/gen = 2,
		/obj/item/storage/backpack/messenger/gen = 2,
		/obj/item/storage/backpack/duffelbag/genetics = 2)
	generate_items_inside(items_inside,src)
	return


/obj/structure/closet/wardrobe/virology_white
	name = "病毒学衣柜"
	icon_door = "viro_wardrobe"

/obj/structure/closet/wardrobe/virology_white/PopulateContents()
	var/list/items_inside = list(
		/obj/item/clothing/under/rank/medical/virologist = 2,
		/obj/item/clothing/shoes/sneakers/white = 2,
		/obj/item/clothing/suit/toggle/labcoat/virologist = 2,
		/obj/item/clothing/mask/surgical = 2,
		/obj/item/storage/backpack/virology = 2,
		/obj/item/storage/backpack/satchel/vir = 2,
		/obj/item/storage/backpack/messenger/vir = 2,
		/obj/item/storage/backpack/duffelbag/virology = 2,)
	generate_items_inside(items_inside,src)
	return

/obj/structure/closet/wardrobe/science_white
	name = "科学衣柜"
	icon_door = "sci_wardrobe"

/obj/structure/closet/wardrobe/science_white/PopulateContents()
	var/list/items_inside = list(
		/obj/item/clothing/accessory/pocketprotector = 1,
		/obj/item/storage/backpack/science = 2,
		/obj/item/storage/backpack/satchel/science = 2,
		/obj/item/storage/backpack/duffelbag/science = 2,
		/obj/item/clothing/suit/hooded/wintercoat/science = 1,
		/obj/item/clothing/under/rank/rnd/scientist = 3,
		/obj/item/clothing/suit/toggle/labcoat/science = 3,
		/obj/item/clothing/shoes/sneakers/white = 3,
		/obj/item/radio/headset/headset_sci = 2,
		/obj/item/clothing/mask/gas/alt = 3) //NOVA EDIT CHANGE - ORIGINAL: /obj/item/clothing/mask/gas = 3)
	generate_items_inside(items_inside,src)
	return

/obj/structure/closet/wardrobe/botanist
	name = "植物学衣柜"
	icon_door = "botany_wardrobe"

/obj/structure/closet/wardrobe/botanist/PopulateContents()
	var/list/items_inside = list(
		/obj/item/storage/backpack/botany = 2,
		/obj/item/storage/backpack/satchel/hyd = 2,
		/obj/item/storage/backpack/messenger/hyd = 2,
		/obj/item/storage/backpack/duffelbag/hydroponics = 2,
		/obj/item/clothing/suit/hooded/wintercoat/hydro = 1,
		/obj/item/clothing/suit/apron = 2,
		/obj/item/clothing/suit/apron/overalls = 2,
		/obj/item/clothing/under/rank/civilian/hydroponics = 3,
		/obj/item/clothing/mask/bandana/striped/botany = 3)
	generate_items_inside(items_inside,src)

/obj/structure/closet/wardrobe/curator
	name = "寻宝衣柜"
	icon_door = "curator_wardrobe"

/obj/structure/closet/wardrobe/curator/PopulateContents()
	new /obj/item/clothing/head/fedora/curator(src)
	new /obj/item/clothing/suit/jacket/curator(src)
	new /obj/item/clothing/under/rank/civilian/curator/treasure_hunter(src)
	new /obj/item/clothing/shoes/workboots/mining(src)
	new /obj/item/storage/backpack/satchel/explorer(src)
	new /obj/item/storage/backpack/messenger/explorer(src)
