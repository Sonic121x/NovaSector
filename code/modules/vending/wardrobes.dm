GLOBAL_VAR_INIT(roaches_deployed, FALSE)
#define MOTHROACH_START_CHANCE 5
#define MAX_MOTHROACH_AMOUNT 3

/obj/item/vending_refill/wardrobe
	icon_state = "refill_clothes"

/obj/machinery/vending/wardrobe
	default_price = PAYCHECK_CREW
	extra_price = PAYCHECK_COMMAND
	payment_department = NO_FREEBIES
	panel_type = "panel19"
	light_mask = "wardrobe-light-mask"

/obj/machinery/vending/wardrobe/Initialize(mapload)
	. = ..()
	if(!mapload)
		return
	if(GLOB.roaches_deployed || !is_station_level(z) || !prob(MOTHROACH_START_CHANCE))
		return
	for(var/count in 1 to rand(1, MAX_MOTHROACH_AMOUNT))
		new /mob/living/basic/mothroach(src)
	GLOB.roaches_deployed = TRUE


/obj/machinery/vending/wardrobe/on_dispense(obj/item/clothing/food, dispense_returned = FALSE)
	if(!istype(food))
		return
	for(var/mob/living/basic/mothroach/roach in contents)
		// Be slightly nicer on returned items
		var/damage_mult = dispense_returned ? 0.1 : 0.5
		food.take_damage(food.get_integrity() * damage_mult)

/obj/machinery/vending/wardrobe/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir)
	. = ..()
	for(var/mob/living/basic/mothroach/roach in contents)
		roach.ai_controller.set_blackboard_key(BB_BASIC_MOB_FLEE_TARGET, src) //scatter away!
		roach.forceMove(drop_location())

/obj/machinery/vending/wardrobe/sec_wardrobe
	name = "\improper 安全服装售货机"
	desc = "一个安保与安全相关服装的服装售货机！"
	icon_state = "secdrobe"
	product_ads = "Beat perps in style!;It's red so you can't see the blood!;You have the right to be fashionable!;Now you can be the fashion police you always wanted to be!"
	vend_reply = "Thank you for using the SecDrobe!"
	/* NOVA EDIT - LISTS OVERRIDDEN IN 'modular_nova\modules\sec_haul\code\misc\vending.dm'
	products = list(
		/obj/item/clothing/head/beret/sec = 3,
		/obj/item/clothing/head/soft/sec = 3,
		/obj/item/clothing/head/costume/ushanka/sec = 3,
		/obj/item/clothing/mask/bandana/striped/security = 3,
		/obj/item/clothing/under/rank/security/officer = 3,
		/obj/item/clothing/under/rank/security/officer/skirt = 3,
		/obj/item/clothing/under/rank/security/officer/grey = 3,
		/obj/item/clothing/under/pants/slacks = 3,
		/obj/item/clothing/under/rank/security/officer/blueshirt = 3,
		/obj/item/clothing/gloves/color/black/security/blu = 3,
		/obj/item/clothing/suit/armor/vest/secjacket = 3,
		/obj/item/clothing/suit/hooded/wintercoat/security = 3,
		/obj/item/clothing/suit/armor/vest = 3,
		/obj/item/clothing/gloves/color/black/security = 3,
		/obj/item/clothing/shoes/jackboots/sec = 3,
		/obj/item/storage/backpack/security = 3,
		/obj/item/storage/backpack/satchel/sec = 3,
		/obj/item/storage/backpack/duffelbag/sec = 3,
		/obj/item/storage/backpack/messenger/sec = 3,
	)
	premium = list(
		/obj/item/clothing/under/rank/security/officer/formal = 3,
		/obj/item/clothing/suit/jacket/officer/blue = 3,
		/obj/item/clothing/head/beret/sec/navyofficer = 3,
		)
	*/
	refill_canister = /obj/item/vending_refill/wardrobe/sec_wardrobe
	payment_department = ACCOUNT_SEC
	light_color = COLOR_MOSTLY_PURE_RED

/obj/item/vending_refill/wardrobe/sec_wardrobe
	machine_name = "SecDrobe"

/obj/machinery/vending/wardrobe/medi_wardrobe
	name = "\improper 医疗服装售货机"
	desc = "一台据称为医疗人员提供服装的自动贩卖机。"
	icon_state = "medidrobe"
	product_ads = "Make those blood stains look fashionable!!"
	vend_reply = "Thank you for using the MediDrobe!"
	products = list(
		/obj/item/clothing/accessory/pocketprotector = 4,
		/obj/item/clothing/head/costume/nursehat = 4,
		/obj/item/clothing/head/beret/medical = 4,
		/obj/item/clothing/head/utility/surgerycap = 4,
		/obj/item/clothing/head/utility/surgerycap/purple = 4,
		/obj/item/clothing/head/utility/surgerycap/green = 4,
		/obj/item/clothing/head/beret/medical/paramedic = 4,
		/obj/item/clothing/head/soft/paramedic = 4,
		/obj/item/clothing/head/utility/head_mirror = 4,
		/obj/item/clothing/mask/bandana/striped/medical = 4,
		/obj/item/clothing/mask/surgical = 4,
		/obj/item/clothing/under/rank/medical/doctor = 4,
		/obj/item/clothing/under/rank/medical/doctor/skirt = 4,
		/obj/item/clothing/under/rank/medical/scrubs/blue = 4,
		/obj/item/clothing/under/rank/medical/scrubs/green = 4,
		/obj/item/clothing/under/rank/medical/scrubs/purple = 4,
		/obj/item/clothing/under/rank/medical/paramedic = 4,
		/obj/item/clothing/under/rank/medical/paramedic/skirt = 4,
		/obj/item/clothing/suit/toggle/labcoat = 4,
		/obj/item/clothing/suit/toggle/labcoat/paramedic = 4,
		/obj/item/clothing/suit/apron/surgical = 4,
		/obj/item/clothing/suit/hooded/wintercoat/medical = 4,
		/obj/item/clothing/suit/hooded/wintercoat/medical/paramedic = 4,
		/obj/item/clothing/shoes/sneakers/white = 4,
		/obj/item/clothing/shoes/sneakers/blue = 4,
		/obj/item/clothing/gloves/latex/nitrile = 4,
		/obj/item/clothing/gloves/latex = 4,
		/obj/item/storage/backpack/duffelbag/med = 4,
		/obj/item/storage/backpack/medic = 4,
		/obj/item/storage/backpack/satchel/med = 4,
		/obj/item/storage/backpack/messenger/med = 4,
		/obj/item/radio/headset/headset_med = 4,
	)
	refill_canister = /obj/item/vending_refill/wardrobe/medi_wardrobe
	payment_department = ACCOUNT_MED

/obj/item/vending_refill/wardrobe/medi_wardrobe
	machine_name = "MediDrobe"

/obj/machinery/vending/wardrobe/engi_wardrobe
	name = "工程服装售货机"
	desc = "以出售工业级服装而闻名的自动售货机。"
	icon_state = "engidrobe"
	product_ads = "Guaranteed to protect your feet from industrial accidents!;Afraid of radiation? Then wear yellow!"
	vend_reply = "Thank you for using the EngiDrobe!"
	products = list(
		/obj/item/clothing/accessory/pocketprotector = 3,
		/obj/item/clothing/head/utility/hardhat = 3,
		/obj/item/clothing/head/utility/hardhat/welding = 3,
		/obj/item/clothing/head/beret/engi = 3,
		/obj/item/clothing/mask/bandana/striped/engineering = 3,
		/obj/item/clothing/under/rank/engineering/engineer = 3,
		/obj/item/clothing/under/rank/engineering/engineer/skirt = 3,
		/obj/item/clothing/under/rank/engineering/engineer/hazard = 3,
		/obj/item/clothing/suit/hazardvest = 3,
		/obj/item/clothing/suit/hooded/wintercoat/engineering = 3,
		/obj/item/clothing/shoes/workboots = 3,
		/obj/item/storage/backpack/industrial = 3,
		/obj/item/storage/backpack/satchel/eng = 3,
		/obj/item/storage/backpack/duffelbag/engineering = 3,
		/obj/item/storage/backpack/messenger/eng = 3,
	)
	refill_canister = /obj/item/vending_refill/wardrobe/engi_wardrobe
	payment_department = ACCOUNT_ENG
	light_color = COLOR_VIVID_YELLOW

/obj/item/vending_refill/wardrobe/engi_wardrobe
	machine_name = "EngiDrobe"

/obj/machinery/vending/wardrobe/atmos_wardrobe
	name = "大气服装售货机"
	desc = "这台相对不为人知的自动售货机为大气技术员提供衣服，这也是一份同样不为人知的工作。"
	icon_state = "atmosdrobe"
	product_slogans = "Get your inflammable clothing right here!!!"
	vend_reply = "Thank you for using the AtmosDrobe!"
	products = list(
		/obj/item/clothing/accessory/pocketprotector = 3,
		/obj/item/clothing/under/rank/engineering/atmospheric_technician = 3,
		/obj/item/clothing/under/rank/engineering/atmospheric_technician/skirt = 3,
		/obj/item/clothing/suit/atmos_overalls = 3,
		/obj/item/clothing/suit/hooded/wintercoat/engineering/atmos = 3,
		/obj/item/clothing/shoes/sneakers/black = 3,
		/obj/item/storage/backpack/satchel/eng = 3,
		/obj/item/storage/backpack/industrial = 3,
		/obj/item/storage/backpack/duffelbag/engineering = 3,
		/obj/item/storage/backpack/messenger/eng = 3,
	)
	refill_canister = /obj/item/vending_refill/wardrobe/atmos_wardrobe
	payment_department = ACCOUNT_ENG
	light_color = COLOR_VIVID_YELLOW

/obj/item/vending_refill/wardrobe/atmos_wardrobe
	machine_name = "AtmosDrobe"

/obj/machinery/vending/wardrobe/cargo_wardrobe
	name = "货舱服装售货机"
	desc = "一个非常先进的自动售货机，用于免费购买与货舱相关的服装。"
	icon_state = "cargodrobe"
	product_ads = "Upgraded Assistant Style! Pick yours today!;These shorts are comfy and easy to wear, get yours now!"
	vend_reply = "Thank you for using the CargoDrobe!"
	products = list(
		/obj/item/clothing/head/beret/cargo = 3,
		/obj/item/clothing/mask/bandana/striped/cargo = 3,
		/obj/item/clothing/head/soft = 3,
		/obj/item/clothing/head/utility/hardhat/orange = 3,
		/obj/item/clothing/under/rank/cargo/tech = 3,
		/obj/item/clothing/under/rank/cargo/tech/skirt = 3,
		/obj/item/clothing/under/rank/cargo/tech/alt = 3,
		/obj/item/clothing/under/rank/cargo/tech/skirt/alt = 3,
		/obj/item/clothing/suit/toggle/cargo_tech = 3,
		/obj/item/clothing/suit/hooded/wintercoat/cargo = 3,
		/obj/item/clothing/suit/hazardvest = 3,
		/obj/item/clothing/gloves/fingerless = 3,
		/obj/item/clothing/shoes/sneakers/black = 3,
		/obj/item/storage/backpack = 3,
		/obj/item/storage/backpack/satchel = 3,
		/obj/item/storage/backpack/satchel/leather = 3,
		/obj/item/storage/backpack/duffelbag = 3,
		/obj/item/storage/backpack/messenger = 3,
		/obj/item/radio/headset/headset_cargo = 3,
		/obj/item/clothing/accessory/pocketprotector = 3,
	)
	premium = list(
		/obj/item/storage/bag/mail = 3,
		/obj/item/clothing/head/costume/mailman = 1,
		/obj/item/clothing/under/misc/mailman = 1,
		/obj/item/flatpack/mailsorter = 1,
		/obj/item/clothing/under/rank/cargo/miner = 3,
		/obj/item/clothing/under/rank/cargo/miner/lavaland = 3,
		/obj/item/clothing/under/rank/cargo/bitrunner = 3,
	)
	refill_canister = /obj/item/vending_refill/wardrobe/cargo_wardrobe
	payment_department = ACCOUNT_CAR

/obj/item/vending_refill/wardrobe/cargo_wardrobe
	machine_name = "CargoDrobe"

/obj/machinery/vending/wardrobe/robo_wardrobe
	name = "机器人学家服装售货机"
	desc = "一台专为机器人学家设计的自动售货机,其出售的物品只有机械师们知道。"
	icon_state = "robodrobe"
	product_ads = "You turn me TRUE, use defines!;0110001101101100011011110111010001101000011001010111001101101000011001010111001001100101"
	vend_reply = "Thank you for using the RoboDrobe!"
	products = list(
		/obj/item/clothing/glasses/hud/diagnostic = 2,
		/obj/item/clothing/head/soft/black = 2,
		/obj/item/clothing/mask/bandana/skull/black = 2,
		/obj/item/clothing/under/rank/rnd/roboticist = 2,
		/obj/item/clothing/under/rank/rnd/roboticist/skirt = 2,
		/obj/item/clothing/suit/toggle/labcoat/roboticist = 2,
		/obj/item/clothing/suit/hooded/wintercoat/science/robotics = 2,
		/obj/item/clothing/gloves/fingerless = 2,
		/obj/item/clothing/shoes/sneakers/black = 2,
		/obj/item/storage/backpack/science = 3,
		/obj/item/storage/backpack/satchel/science = 3,
		/obj/item/storage/backpack/duffelbag/science = 3,
		/obj/item/storage/backpack/messenger/science = 3,
		/obj/item/radio/headset/headset_sci = 2,
	)
	contraband = list(
		/obj/item/clothing/under/costume/mech_suit = 2,
		/obj/item/clothing/suit/hooded/techpriest = 2,
		/obj/item/organ/tongue/robot = 2,
	)
	refill_canister = /obj/item/vending_refill/wardrobe/robo_wardrobe
	extra_price = PAYCHECK_COMMAND * 1.2
	payment_department = ACCOUNT_SCI

/obj/item/vending_refill/wardrobe/robo_wardrobe
	machine_name = "RoboDrobe"

/obj/machinery/vending/wardrobe/science_wardrobe
	name = "科学服装售货机"
	desc = "一个简单的自动售货机，适合分发精心剪裁的科学服装。由太空人代言。"
	icon_state = "scidrobe"
	product_ads = "Longing for the smell of plasma burnt flesh? Buy your science clothing now!;Made with 10% Auxetics, so you don't have to worry about losing your arm!"
	vend_reply = "Thank you for using the SciDrobe!"
	products = list(
		/obj/item/clothing/accessory/pocketprotector = 3,
		/obj/item/clothing/head/beret/science = 3,
		/obj/item/clothing/mask/gas = 3,
		/obj/item/clothing/mask/bandana/striped/science = 3,
		/obj/item/clothing/under/rank/rnd/scientist = 3,
		/obj/item/clothing/under/rank/rnd/scientist/skirt = 3,
		/obj/item/clothing/suit/toggle/labcoat/science = 3,
		/obj/item/clothing/suit/hooded/wintercoat/science = 3,
		/obj/item/clothing/gloves/latex = 3,
		/obj/item/clothing/shoes/sneakers/white = 3,
		/obj/item/storage/backpack/science = 3,
		/obj/item/storage/backpack/satchel/science = 3,
		/obj/item/storage/backpack/duffelbag/science = 3,
		/obj/item/storage/backpack/messenger/science = 3,
		/obj/item/radio/headset/headset_sci = 3,
	)
	refill_canister = /obj/item/vending_refill/wardrobe/science_wardrobe
	payment_department = ACCOUNT_SCI

/obj/item/vending_refill/wardrobe/science_wardrobe
	machine_name = "SciDrobe"

/obj/machinery/vending/wardrobe/hydro_wardrobe
	name = "植物学服装售货机"
	desc = "一台名字朗朗上口的机器。它出售与植物学有关的衣服和装备。"
	icon_state = "hydrobe"
	product_ads = "Do you love soil? Then buy our clothes!;Get outfits to match your green thumb here!"
	vend_reply = "Thank you for using the Hydrobe!"
	products = list(
		/obj/item/clothing/accessory/armband/hydro = 3,
		/obj/item/clothing/mask/bandana/striped/botany = 3,
		/obj/item/clothing/under/rank/civilian/hydroponics = 3,
		/obj/item/clothing/under/rank/civilian/hydroponics/skirt = 3,
		/obj/item/clothing/suit/apron = 3,
		/obj/item/clothing/suit/apron/overalls = 3,
		/obj/item/clothing/suit/apron/waders = 3,
		/obj/item/clothing/suit/hooded/wintercoat/hydro = 3,
		/obj/item/storage/backpack/botany = 3,
		/obj/item/storage/backpack/satchel/hyd = 3,
		/obj/item/storage/backpack/duffelbag/hydroponics = 3,
		/obj/item/storage/backpack/messenger/hyd = 3,
		/obj/item/radio/headset/headset_srv = 3,
	)
	refill_canister = /obj/item/vending_refill/wardrobe/hydro_wardrobe
	payment_department = ACCOUNT_SRV
	light_color = LIGHT_COLOR_ELECTRIC_GREEN

/obj/item/vending_refill/wardrobe/hydro_wardrobe
	machine_name = "HyDrobe"

/obj/machinery/vending/wardrobe/curator_wardrobe
	name = "图书管理员服装售货机"
	desc = "一款低库存的贩卖机，仅能提供馆长和图书管理员所需的服装。"
	icon_state = "curadrobe"
	product_slogans = "Glasses for your eyes and literature for your soul, Curadrobe has it all!; Impress & enthrall your library guests with Curadrobe's extended line of pens!"
	vend_reply = "Thank you for using the CuraDrobe!"
	products = list(
		/obj/item/clothing/accessory/pocketprotector = 2,
		/obj/item/pen = 4,
		/obj/item/pen/red = 2,
		/obj/item/pen/blue = 2,
		/obj/item/pen/fourcolor = 1,
		/obj/item/pen/fountain = 2,
		/obj/item/clothing/glasses/regular = 2,
		/obj/item/clothing/glasses/regular/jamjar = 1,
		/obj/item/clothing/under/rank/civilian/curator = 1,
		/obj/item/clothing/under/rank/civilian/curator/skirt = 1,
		/obj/item/clothing/under/costume/captain = 1,
		/obj/item/clothing/under/costume/captain/skirt = 1,
		/obj/item/clothing/under/costume/head_of_personnel = 1,
		/obj/item/clothing/under/costume/head_of_personnel/skirt = 1,
		/obj/item/clothing/suit/toggle/lawyer/greyscale = 1,
		/obj/item/storage/backpack/satchel/explorer = 1,
		/obj/item/storage/backpack/messenger/explorer = 1,
		/obj/item/storage/bag/books = 1,
		/obj/item/radio/headset/headset_srvent = 2,
	)
	refill_canister = /obj/item/vending_refill/wardrobe/curator_wardrobe
	payment_department = ACCOUNT_SRV

/obj/item/vending_refill/wardrobe/curator_wardrobe
	machine_name = "CuraDrobe"

/obj/machinery/vending/wardrobe/coroner_wardrobe
	name = "殓尸衣橱"
	desc = "虚无主义者的最爱。"
	icon_state = "coroner_drobe"
	product_ads = "Any day above ground is a good one!;My day starts when yours ends!;And they call this a dying business!;See you when you're dead!"
	vend_reply = "Don't forget your \"Buy one get one free\" burial deal!"
	products = list(
		/obj/item/clothing/head/utility/surgerycap/black = 1,
		/obj/item/clothing/mask/surgical = 1,
		/obj/item/clothing/suit/apron/surgical = 1,
		/obj/item/clothing/suit/hooded/wintercoat/medical/coroner = 1,
		/obj/item/clothing/suit/toggle/labcoat/coroner = 1,
		/obj/item/clothing/under/rank/medical/coroner = 1,
		/obj/item/clothing/under/rank/medical/coroner/skirt = 1,
		/obj/item/clothing/under/rank/medical/scrubs/coroner = 1,
		/obj/item/clothing/shoes/sneakers/black = 1,
		/obj/item/clothing/gloves/latex/coroner = 1,
		/obj/item/cautery/cruel = 1,
		/obj/item/hemostat/cruel = 1,
		/obj/item/retractor/cruel = 1,
		/obj/item/scalpel/cruel = 1,
		/obj/item/surgicaldrill/cruel = 1,
		/obj/item/circular_saw/cruel = 1,
		/obj/item/bonesetter/cruel = 1,
		/obj/item/blood_filter/cruel = 1,
		/obj/item/storage/backpack/coroner = 1,
		/obj/item/storage/backpack/duffelbag/coroner = 1,
		/obj/item/storage/backpack/messenger/coroner = 1,
		/obj/item/storage/backpack/satchel/coroner = 1,
		/obj/item/storage/box/bodybags = 3,
		/obj/item/radio/headset/headset_srvmed = 2,
		/obj/item/toy/crayon/white = 2,
	)
	contraband = list(
		/obj/item/knife/ritual = 1,
		/obj/item/scythe = 1,
		/obj/item/storage/fancy/pickles_jar = 1,
		/obj/item/table_clock = 1,
	)
	premium = list(
		/obj/item/autopsy_scanner = 1,
		/obj/item/storage/medkit/coroner = 1,
	)
	refill_canister = /obj/item/vending_refill/wardrobe/coroner_wardrobe
	payment_department = ACCOUNT_MED

/obj/item/vending_refill/wardrobe/coroner_wardrobe
	machine_name = "MortiDrobe"

/obj/machinery/vending/wardrobe/bar_wardrobe
	name = "酒保服装售货机"
	desc = "一个时尚的小贩分发最时尚的酒吧服装！"
	icon_state = "bardrobe"
	product_ads = "Guaranteed to prevent stains from spilled drinks!"
	vend_reply = "Thank you for using the BarDrobe!"
	products = list(
		/obj/item/clothing/glasses/sunglasses/reagent = 1,
		/obj/item/clothing/accessory/waistcoat = 2,
		/obj/item/clothing/head/hats/tophat = 2,
		/obj/item/clothing/head/soft/black = 2,
		/obj/item/clothing/neck/petcollar = 1,
		/obj/item/clothing/neck/bowtie = 2,
		/obj/item/clothing/under/costume/buttondown/slacks/service = 2,
		/obj/item/clothing/under/costume/buttondown/skirt/service = 2,
		/obj/item/clothing/under/rank/civilian/purple_bartender = 2,
		/obj/item/clothing/suit/toggle/lawyer/greyscale = 1,
		/obj/item/clothing/suit/armor/vest/alt = 1,
		/obj/item/clothing/shoes/sneakers/black = 2,
		/obj/item/storage/belt/bandolier = 1,
		/obj/item/storage/bag/money = 2,
		/obj/item/storage/dice/hazard = 1,
		/obj/item/storage/box/beanbag = 1,
		/obj/item/circuitboard/machine/dish_drive = 1,
		/obj/item/rag = 2,
		/obj/item/radio/headset/headset_srv = 2,
	)
	premium = list(
		/obj/item/storage/box/dishdrive = 1,
		/obj/item/construction/plumbing/service = 1,
	)
	refill_canister = /obj/item/vending_refill/wardrobe/bar_wardrobe
	payment_department = ACCOUNT_MED
	extra_price = PAYCHECK_COMMAND

/obj/item/vending_refill/wardrobe/bar_wardrobe
	machine_name = "BarDrobe"

/obj/machinery/vending/wardrobe/chef_wardrobe
	name = "厨师服装售货机"
	desc = "这个自动贩卖机可能不卖肉，但它肯定卖厨师相关的衣服。"
	icon_state = "chefdrobe"
	product_ads = "Our clothes are guaranteed to protect you from food splatters!"
	vend_reply = "Thank you for using the ChefDrobe!"
	products = list(
		/obj/item/clothing/accessory/waistcoat = 2,
		/obj/item/clothing/head/soft/mime = 2,
		/obj/item/clothing/head/utility/chefhat = 2,
		/obj/item/clothing/under/costume/buttondown/slacks/service = 2,
		/obj/item/clothing/under/costume/buttondown/skirt/service = 2,
		/obj/item/clothing/under/rank/civilian/cookjorts = 2,
		/obj/item/clothing/under/suit/waiter = 2,
		/obj/item/clothing/suit/apron/chef = 2,
		/obj/item/clothing/suit/toggle/chef = 2,
		/obj/item/clothing/suit/hooded/wintercoat = 2,
		/obj/item/clothing/shoes/cookflops = 2,
		/obj/item/clothing/shoes/sneakers/black = 2,
		/obj/item/storage/box/mousetraps = 2,
		/obj/item/circuitboard/machine/dish_drive = 1,
		/obj/item/rag = 2,
		/obj/item/radio/headset/headset_srv = 2,
	)
	refill_canister = /obj/item/vending_refill/wardrobe/chef_wardrobe
	payment_department = ACCOUNT_SRV

/obj/item/vending_refill/wardrobe/chef_wardrobe
	machine_name = "ChefDrobe"

/obj/machinery/vending/wardrobe/jani_wardrobe
	name = "清洁服装售货机"
	desc = "一种自动清洁自动售货机，出售看门人所需的衣物。"
	icon_state = "janidrobe"
	product_ads = "Come and get your janitorial clothing, now endorsed by lizard janitors everywhere!"
	vend_reply = "Thank you for using the JaniDrobe!"
	products = list(
		/obj/item/clothing/head/soft/purple = 2,
		/obj/item/clothing/mask/bandana/purple = 2,
		/obj/item/clothing/under/rank/civilian/janitor = 2,
		/obj/item/clothing/under/rank/civilian/janitor/skirt = 2,
		/obj/item/clothing/suit/hooded/wintercoat/janitor = 2,
		/obj/item/clothing/shoes/sneakers/black = 2,
		/obj/item/clothing/gloves/color/black = 2,
		/obj/item/clothing/shoes/galoshes = 2,
		/obj/item/storage/belt/janitor = 2,
		/obj/item/watertank/janitor = 1,
		/obj/item/flashlight = 2,
		/obj/item/pushbroom = 2,
		/obj/item/paint/paint_remover = 2,
		/obj/item/melee/flyswatter = 2,
		/obj/item/clothing/suit/caution = 6,
		/obj/item/holosign_creator = 2,
		/obj/item/lightreplacer = 2,
		/obj/item/soap/nanotrasen = 2,
		/obj/item/storage/bag/trash = 2,
		/obj/item/plunger = 2,
		/obj/item/wirebrush = 2,
		/obj/item/radio/headset/headset_srv = 2,
	)
	refill_canister = /obj/item/vending_refill/wardrobe/jani_wardrobe
	default_price = PAYCHECK_CREW
	extra_price = PAYCHECK_COMMAND * 0.8
	payment_department = ACCOUNT_SRV
	light_color = COLOR_STRONG_MAGENTA

/obj/item/vending_refill/wardrobe/jani_wardrobe
	machine_name = "JaniDrobe"

/obj/machinery/vending/wardrobe/law_wardrobe
	name = "律师服装售货机"
	desc = "一斤鸭梨！这个服装售货机摒弃了法治……还有律师服。"
	icon_state = "lawdrobe"
	product_ads = "OBJECTION! Get the rule of law for yourself!"
	vend_reply = "Thank you for using the LawDrobe!"
	extra_price = PAYCHECK_COMMAND * 3
	products = list(
		/obj/item/clothing/accessory/lawyers_badge = 2,
		/obj/item/clothing/neck/tie = 3,
		/obj/item/clothing/under/rank/civilian/lawyer/bluesuit = 1,
		/obj/item/clothing/under/rank/civilian/lawyer/bluesuit/skirt = 1,
		/obj/item/clothing/suit/toggle/lawyer = 1,
		/obj/item/clothing/under/rank/civilian/lawyer/purpsuit = 1,
		/obj/item/clothing/under/rank/civilian/lawyer/purpsuit/skirt = 1,
		/obj/item/clothing/suit/toggle/lawyer/purple = 1,
		/obj/item/clothing/under/costume/buttondown/slacks/service = 1,
		/obj/item/clothing/under/costume/buttondown/skirt/service = 1,
		/obj/item/clothing/suit/toggle/lawyer/black = 1,
		/obj/item/clothing/suit/toggle/lawyer/greyscale = 1,
		/obj/item/clothing/under/suit/black = 1,
		/obj/item/clothing/under/suit/black/skirt = 1,
		/obj/item/clothing/under/rank/civilian/lawyer/beige = 1,
		/obj/item/clothing/under/rank/civilian/lawyer/beige/skirt = 1,
		/obj/item/clothing/under/suit/black_really = 1,
		/obj/item/clothing/under/suit/black_really/skirt = 1,
		/obj/item/clothing/under/rank/civilian/lawyer/blue = 1,
		/obj/item/clothing/under/rank/civilian/lawyer/blue/skirt = 1,
		/obj/item/clothing/under/rank/civilian/lawyer/red = 1,
		/obj/item/clothing/under/rank/civilian/lawyer/red/skirt = 1,
		/obj/item/clothing/under/rank/civilian/lawyer/black = 1,
		/obj/item/clothing/under/rank/civilian/lawyer/black/skirt = 1,
		/obj/item/clothing/shoes/laceup = 2,
		/obj/item/radio/headset/headset_srv = 2,
		/obj/item/storage/box/evidence = 2,
		/obj/item/reagent_containers/cup/fish_feed = 1,
		/obj/item/storage/box/stamps = 1,
	)
	premium = list(
		/obj/item/mod/control/pre_equipped/portable_suit = 1,
	)
	refill_canister = /obj/item/vending_refill/wardrobe/law_wardrobe
	payment_department = ACCOUNT_SRV

/obj/item/vending_refill/wardrobe/law_wardrobe
	machine_name = "LawDrobe"

/obj/machinery/vending/wardrobe/chap_wardrobe
	name = "牧师服装售货机"
	desc = "太空神会批准你的订单。"
	icon_state = "chapdrobe"
	product_ads = "Are you being bothered by cultists or pesky revenants? Then come and dress like the holy man!;Clothes for men of the cloth!"
	vend_reply = "Thank you for using the DeusVend!"
	products = list(
		/obj/item/choice_beacon/holy = 1,
		/obj/item/clothing/accessory/pocketprotector/cosmetology = 1,
		/obj/item/clothing/under/rank/civilian/chaplain = 1,
		/obj/item/clothing/under/rank/civilian/chaplain/skirt = 2,
		/obj/item/clothing/shoes/sneakers/black = 1,
		/obj/item/clothing/suit/chaplainsuit/nun = 1,
		/obj/item/clothing/head/chaplain/nun_hood = 1,
		/obj/item/clothing/suit/chaplainsuit/holidaypriest = 1,
		/obj/item/clothing/suit/hooded/chaplainsuit/monkhabit = 1,
		/obj/item/clothing/head/chaplain/kippah = 3,
		/obj/item/clothing/suit/chaplainsuit/whiterobe = 1,
		/obj/item/clothing/head/chaplain/taqiyah/white = 1,
		/obj/item/clothing/head/chaplain/taqiyah/red = 3,
		/obj/item/clothing/suit/chaplainsuit/monkrobeeast = 1,
		/obj/item/clothing/head/rasta = 1,
		/obj/item/clothing/suit/chaplainsuit/shrinehand = 1,
		/obj/item/storage/backpack/cultpack = 1,
		/obj/item/storage/fancy/candle_box = 2,
		/obj/item/radio/headset/headset_srv = 2,
		/obj/item/clothing/suit/chaplainsuit/habit = 1,
		/obj/item/clothing/head/chaplain/habit_veil = 1,
		/obj/item/storage/box/purity_seal_box = 2,
	)
	contraband = list(
		/obj/item/toy/plush/ratplush = 1,
		/obj/item/toy/plush/narplush = 1,
		/obj/item/clothing/head/chaplain/medievaljewhat = 3,
		/obj/item/clothing/head/chaplain/clownmitre = 1,
		/obj/item/clothing/suit/chaplainsuit/clownpriest = 1,
	)
	premium = list(
		/obj/item/clothing/head/chaplain/bishopmitre = 1,
		/obj/item/clothing/suit/chaplainsuit/bishoprobe = 1,
	)
	refill_canister = /obj/item/vending_refill/wardrobe/chap_wardrobe
	payment_department = ACCOUNT_SRV

/obj/item/vending_refill/wardrobe/chap_wardrobe
	machine_name = "DeusVend"

/obj/machinery/vending/wardrobe/chem_wardrobe
	name = "化学服装售货机"
	desc = "一台用于提供化学相关衣物的自动售货机。"
	icon_state = "chemdrobe"
	product_ads = "Our clothes are 0.5% more resistant to acid spills! Get yours now!"
	vend_reply = "Thank you for using the ChemDrobe!"
	products = list(
		/obj/item/clothing/head/beret/medical = 2,
		/obj/item/clothing/under/rank/medical/chemist = 2,
		/obj/item/clothing/under/rank/medical/chemist/skirt = 2,
		/obj/item/clothing/suit/toggle/labcoat/chemist = 2,
		/obj/item/clothing/suit/hooded/wintercoat/medical/chemistry = 2,
		/obj/item/clothing/gloves/latex = 2,
		/obj/item/clothing/shoes/sneakers/white = 2,
		/obj/item/storage/backpack/chemistry = 2,
		/obj/item/storage/backpack/satchel/chem = 2,
		/obj/item/storage/backpack/duffelbag/chemistry = 2,
		/obj/item/storage/backpack/messenger/chem = 2,
		/obj/item/storage/bag/chemistry = 2,
		/obj/item/ph_booklet = 3,
		/obj/item/radio/headset/headset_med = 2,
	)
	contraband = list(
		/obj/item/reagent_containers/spray/syndicate = 2,
	)
	refill_canister = /obj/item/vending_refill/wardrobe/chem_wardrobe
	payment_department = ACCOUNT_MED

/obj/item/vending_refill/wardrobe/chem_wardrobe
	machine_name = "ChemDrobe"

/obj/machinery/vending/wardrobe/gene_wardrobe
	name = "基因服装售货机"
	desc = "一台提供遗传学相关衣物的自动售货机"
	icon_state = "genedrobe"
	product_ads = "Perfect for the mad scientist in you!"
	vend_reply = "Thank you for using the GeneDrobe!"
	products = list(
		/obj/item/clothing/under/rank/rnd/geneticist = 2,
		/obj/item/clothing/under/rank/rnd/geneticist/skirt = 2,
		/obj/item/clothing/suit/toggle/labcoat/genetics = 2,
		/obj/item/clothing/suit/hooded/wintercoat/science/genetics = 2,
		/obj/item/clothing/gloves/latex = 2,
		/obj/item/clothing/shoes/sneakers/white = 2,
		/obj/item/storage/backpack/genetics = 2,
		/obj/item/storage/backpack/satchel/gen = 2,
		/obj/item/storage/backpack/duffelbag/genetics = 2,
		/obj/item/storage/backpack/messenger/gen = 2,
		/obj/item/radio/headset/headset_sci = 2,
	)
	refill_canister = /obj/item/vending_refill/wardrobe/gene_wardrobe
	payment_department = ACCOUNT_SCI

/obj/item/vending_refill/wardrobe/gene_wardrobe
	machine_name = "GeneDrobe"

/obj/machinery/vending/wardrobe/viro_wardrobe
	name = "病毒学服装售货机"
	desc = "一台未经消毒、用于分发病毒学相关服装的机器。"
	icon_state = "virodrobe"
	product_slogans = " Viruses getting you down? Then upgrade to sterilized clothing today!"
	vend_reply = "Thank you for using the ViroDrobe"
	products = list(
		/obj/item/clothing/mask/surgical = 2,
		/obj/item/clothing/under/rank/medical/virologist = 2,
		/obj/item/clothing/under/rank/medical/virologist/skirt = 2,
		/obj/item/clothing/head/beret/medical = 2,
		/obj/item/clothing/shoes/sneakers/white = 2,
		/obj/item/clothing/suit/toggle/labcoat/virologist = 2,
		/obj/item/clothing/suit/hooded/wintercoat/medical/viro = 2,
		/obj/item/clothing/gloves/latex = 2,
		/obj/item/storage/backpack/virology = 2,
		/obj/item/storage/backpack/satchel/vir = 2,
		/obj/item/storage/backpack/duffelbag/virology = 2,
		/obj/item/storage/backpack/messenger/vir = 2,
		/obj/item/radio/headset/headset_med = 2,
	)
	refill_canister = /obj/item/vending_refill/wardrobe/viro_wardrobe
	payment_department = ACCOUNT_MED

/obj/item/vending_refill/wardrobe/viro_wardrobe
	machine_name = "ViroDrobe"

/obj/machinery/vending/wardrobe/det_wardrobe
	name = "\improper 侦探服装售货机"
	desc = "只要你需要衣服，一台自动售货机就能满足你侦探的一切需求。"
	icon_state = "detdrobe"
	product_ads = "Apply your brilliant deductive methods in style!"
	vend_reply = "Thank you for using the DetDrobe!"
	products = list(
		/obj/item/clothing/head/fedora/det_hat = 2,
		/obj/item/clothing/under/rank/security/detective = 2,
		/obj/item/clothing/under/rank/security/detective/skirt = 2,
		/obj/item/clothing/suit/toggle/jacket/det_trench = 2,
		/obj/item/clothing/suit/jacket/det_suit = 2,
		/obj/item/clothing/shoes/sneakers/brown = 2,
		/obj/item/clothing/gloves/latex = 2,
		/obj/item/clothing/gloves/color/black = 2,
		/obj/item/clothing/accessory/waistcoat = 2,
		/obj/item/clothing/under/rank/security/detective/noir = 2,
		/obj/item/clothing/under/rank/security/detective/noir/skirt = 2,
		/obj/item/clothing/shoes/laceup = 2,
		/obj/item/clothing/head/fedora/det_hat/noir = 1,
		/obj/item/clothing/suit/toggle/jacket/det_trench/noir = 1,
		/obj/item/clothing/suit/jacket/det_suit/noir = 1,
		/obj/item/clothing/neck/tie/disco = 1,
		/obj/item/clothing/under/rank/security/detective/disco = 1,
		/obj/item/clothing/suit/jacket/det_suit/disco = 1,
		/obj/item/clothing/shoes/discoshoes = 1,
		/obj/item/clothing/glasses/regular/kim = 1,
		/obj/item/clothing/under/rank/security/detective/kim = 1,
		/obj/item/clothing/suit/jacket/det_suit/kim = 1,
		/obj/item/clothing/gloves/kim = 1,
		/obj/item/clothing/shoes/jackboots/kim = 1,
		/obj/item/reagent_containers/cup/glass/flask/det = 2,
		/obj/item/storage/fancy/cigarettes = 5,
		/obj/item/storage/fancy/cigarettes/cigpack_candy = 5,
	)
	premium = list(
		/obj/item/clothing/head/flatcap = 1,
		/obj/item/clothing/glasses/sunglasses/noir = 1,
	)
	refill_canister = /obj/item/vending_refill/wardrobe/det_wardrobe
	extra_price = PAYCHECK_COMMAND * 1.75
	payment_department = ACCOUNT_SEC

/obj/item/vending_refill/wardrobe/det_wardrobe
	machine_name = "DetDrobe"

/obj/machinery/vending/wardrobe/cent_wardrobe
	name = "\improper 中央指挥部服装售货机"
	desc = "一台独一无二的自动售货机，满足您所有的中央指挥部美学需求！"
	icon_state = "centdrobe"
	product_ads = "Show those ERTs who's the most stylish in the briefing room!"
	vend_reply = "Thank you for using the CentDrobe!"
	products = list(
		/obj/item/clothing/glasses/sunglasses = 3,
		/obj/item/clothing/head/hats/centcom_cap = 3,
		/obj/item/clothing/head/hats/centhat = 3,
		/obj/item/clothing/head/hats/intern = 3,
		/obj/item/clothing/under/rank/centcom/commander = 3,
		/obj/item/clothing/under/rank/centcom/centcom_skirt = 3,
		/obj/item/clothing/under/rank/centcom/intern = 3,
		/obj/item/clothing/under/rank/centcom/official = 3,
		/obj/item/clothing/under/rank/centcom/officer = 3,
		/obj/item/clothing/under/rank/centcom/officer_skirt = 3,
		/obj/item/clothing/suit/armor/centcom_formal = 3,
		/obj/item/clothing/suit/space/officer = 3,
		/obj/item/clothing/suit/hooded/wintercoat/centcom = 3,
		/obj/item/clothing/shoes/laceup = 3,
		/obj/item/clothing/shoes/jackboots = 3,
		/obj/item/clothing/gloves/combat = 3,
	)
	refill_canister = /obj/item/vending_refill/wardrobe/cent_wardrobe

/obj/item/vending_refill/wardrobe/cent_wardrobe
	machine_name = "CentDrobe"
	icon_state = "refill_centdrobe"
	light_color = LIGHT_COLOR_ELECTRIC_GREEN

#undef MOTHROACH_START_CHANCE
#undef MAX_MOTHROACH_AMOUNT
