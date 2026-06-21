
/datum/supply_pack/goody
	access = NONE
	group = "Goodies"
	order_flags = ORDER_GOODY
	crate_type = null
	discountable = SUPPLY_PACK_STD_DISCOUNTABLE

/datum/supply_pack/goody/clear_pda
	name = "崭新出厂纳米传讯透明PDA"
	desc = "崭新出厂，刚重新包装！一件通常价值超过250万信用点的珍贵收藏品，现在可以低价入手！"
	cost = 100000
	contains = list(/obj/item/modular_computer/pda/clear)

/datum/supply_pack/goody/dumdum38
	name = ".38 达姆弹快速装弹器单包"
	desc = "配备了.38达姆弹，适合嵌入软目标。"
	cost = PAYCHECK_CREW * 2
	access_view = ACCESS_WEAPONS
	contains = list(/obj/item/ammo_box/speedloader/c38/dumdum)

/datum/supply_pack/goody/match38
	name = ".38 比赛级快速装弹器单包"
	desc = "包含一个速装弹器，内装比赛级.38弹药，非常适合展示特技射击。"
	cost = PAYCHECK_CREW * 2
	access_view = ACCESS_WEAPONS
	contains = list(/obj/item/ammo_box/speedloader/c38/match)

/datum/supply_pack/goody/rubber
	name = ".38橡胶弹速装弹器单件包"
	desc = "包含一个速装弹器，内装弹性橡胶.38弹药，适用于你想让子弹在任何物体上弹跳的场景。"
	cost = PAYCHECK_CREW * 1.5
	access_view = ACCESS_WEAPONS
	contains = list(/obj/item/ammo_box/speedloader/c38/match/bouncy)

/datum/supply_pack/goody/dumdum38br
	name = ".38达姆弹弹匣单件包"
	desc = "包含一个弹匣的.38达姆弹弹药，适合嵌入软目标。"
	cost = PAYCHECK_CREW * 2
	access_view = ACCESS_WEAPONS
	contains = list(/obj/item/ammo_box/magazine/m38/dumdum)

/datum/supply_pack/goody/match38br
	name = ".38比赛级弹匣单件包"
	desc = "包含一个弹匣的比赛级.38弹药，非常适合展示特技射击。"
	cost = PAYCHECK_CREW * 2
	access_view = ACCESS_WEAPONS
	contains = list(/obj/item/ammo_box/magazine/m38/match)

/datum/supply_pack/goody/rubber
	name = ".38橡胶弹弹匣单件包"
	desc = "Contains one magazine of bouncy rubber .38 ammunition, for when you want to bounce your shots off anything and everything."
	cost = PAYCHECK_CREW * 1.5
	access_view = ACCESS_WEAPONS
	contains = list(/obj/item/ammo_box/magazine/m38/match/bouncy)

/datum/supply_pack/goody/mars_single
	name = "柯尔特警探特装单箱"
	desc = "安保部长把你的枪和警徽都拿走了？没问题！只需支付荒谬的税费，你就可以重新拥有一把.38手枪的致命力量！"
	cost = PAYCHECK_CREW * 40 //they really mean a premium here
	access_view = ACCESS_WEAPONS
	contains = list(/obj/item/gun/ballistic/revolver/c38/detective)

/datum/supply_pack/goody/stingbang
	name = "毒刺单箱"
	desc = "包含一个“毒刺”手榴弹，非常适合玩卑鄙的恶作剧。"
	cost = PAYCHECK_COMMAND * 2.5
	access_view = ACCESS_WEAPONS
	contains = list(/obj/item/grenade/stingbang)

/datum/supply_pack/goody/Survivalknives_single
	name = "求生刀包"
	desc = "Contains one sharpened survival knife. Guaranteed to fit snugly inside any Nanotrasen-standard boot."
	cost = PAYCHECK_COMMAND * 1.75
	contains = list(/obj/item/knife/combat/survival)

/datum/supply_pack/goody/ballistic_single
	name = "战斗霰弹枪单箱"
	desc = "当敌人必须被彻底消灭时使用。包含一把由奥塞克设计的战斗霰弹枪，以及一条霰弹枪弹药带。"
	cost = PAYCHECK_COMMAND * 15
	access_view = ACCESS_ARMORY
	contains = list(
		/obj/item/gun/ballistic/shotgun/automatic/combat,
		/obj/item/storage/belt/bandolier
	)

/datum/supply_pack/goody/disabler_single
	name = "Disabler Single-Pack"
	desc = "Contains one disabler, the non-lethal workhorse of Nanotrasen security everywhere. Comes in an energy holster, just in case you happen to have an extra disabler."
	cost = PAYCHECK_COMMAND * 3
	access_view = ACCESS_WEAPONS
	contains = list(/obj/item/storage/belt/holster/energy/disabler)

/datum/supply_pack/goody/energy_single
	name = "能量枪单箱"
	desc = "Contains one energy gun, capable of firing both non-lethal and lethal blasts of light."
	cost = PAYCHECK_COMMAND * 12
	access_view = ACCESS_WEAPONS
	contains = list(/obj/item/gun/energy/e_gun)

/datum/supply_pack/goody/laser_single
	name = "Type 5 Laser Gun Single-Pack"
	desc = "Contains one Type 5 laser gun, the lethal workhorse of Nanotrasen security everywhere."
	cost = PAYCHECK_COMMAND * 6
	access_view = ACCESS_WEAPONS
	contains = list(/obj/item/gun/energy/laser)

/datum/supply_pack/goody/carbine_single
	name = "Type 5/R Laser Carbine Single-Pack"
	desc = "Contains one laser carbine. Fires a rapid burst of slightly weaker laser projectiles."
	cost = PAYCHECK_COMMAND * 8
	access_view = ACCESS_WEAPONS
	contains = list(/obj/item/gun/energy/laser/carbine)

/datum/supply_pack/goody/laser_pistol_single
	name = "Type 5/C Laser Pistol Single-Pack"
	desc = "Contains one Type 5C laser pistol in an energy shoulder holster. Groovy."
	cost = PAYCHECK_COMMAND * 2
	access_view = ACCESS_WEAPONS
	contains = list(/obj/item/storage/belt/holster/energy/laser_pistol)

/datum/supply_pack/goody/laser_single_soul
	name = "Type 3 Laser Gun Single-Pack"
	desc = "Contains one Type 3 laser gun. They don't make 'em like they used to."
	cost = PAYCHECK_COMMAND * 6
	access_view = ACCESS_WEAPONS
	contains = list(/obj/item/gun/energy/laser/soul)

/datum/supply_pack/goody/smg_single
	name = "Disabler SMG Single_Pack"
	desc = "Contains one disabler SMG, capable of rapidly firing weak disabler beams."
	cost = PAYCHECK_COMMAND * 6
	access_view = ACCESS_WEAPONS
	contains = list(/obj/item/gun/energy/disabler/smg)

/datum/supply_pack/goody/hell_single
	name = "地狱激光器套件单箱"
	desc = "Contains one hellgun degradation kit, to convert regular laser guns into an older pattern of laser gun, \
		infamous for its ability to horribly disfigure targets with burns. \
		Technically violates the Space Geneva Convention when used on humanoids."
	cost = PAYCHECK_CREW * 2
	access_view = ACCESS_WEAPONS
	contains = list(/obj/item/weaponcrafting/gunkit/hellgun)

/datum/supply_pack/goody/thermal_single
	name = "热能手枪枪套单箱"
	desc = "配有两把配套的热能手枪，装在枪套中，随时可用于野外作战。"
	cost = PAYCHECK_COMMAND * 15
	access_view = ACCESS_WEAPONS
	contains = list(/obj/item/storage/belt/holster/energy/thermal)

/datum/supply_pack/goody/sologamermitts
	name = "绝缘手套单箱"
	desc = "现代社会的支柱。却鲜少因实际工程需求而被订购。"
	cost = PAYCHECK_CREW * 8
	contains = list(/obj/item/clothing/gloves/color/yellow)

/datum/supply_pack/goody/gorilla_single
	name = "Gorilla Gloves Single-Pack"
	desc = "A spare pair of gorilla gloves. Better for tackles than grippers from the security vendor."
	cost = PAYCHECK_COMMAND * 6
	contains = list(/obj/item/clothing/gloves/tackler/combat)

/datum/supply_pack/goody/firstaidbruises_single
	name = "创伤医疗箱单包"
	desc = "一个创伤医疗箱，专为从气闸压伤中恢复而准备。你知道人们总在气闸里被压扁吗？有意思……"
	cost = PAYCHECK_CREW * 4
	contains = list(/obj/item/storage/medkit/brute)

/datum/supply_pack/goody/firstaidburns_single
	name = "烧伤医疗箱单包"
	desc = "一个烧伤医疗箱。其广告上画着一位眨眼的大气技术员，竖起大拇指说： \"失误在所难免！\""
	cost = PAYCHECK_CREW * 4
	contains = list(/obj/item/storage/medkit/fire)

/datum/supply_pack/goody/firstaid_single
	name = "急救箱单单包"
	desc = "一个医疗箱,适用于治疗大多数类型的身体损伤。"
	cost = PAYCHECK_CREW * 3
	contains = list(/obj/item/storage/medkit/regular)

/datum/supply_pack/goody/firstaidoxygen_single
	name = "窒息医疗箱单包"
	desc = "一份缺氧医疗箱，在那些对窒息怀有严重恐惧的人群中大力推广。"
	cost = PAYCHECK_CREW * 4
	contains = list(/obj/item/storage/medkit/o2)

/datum/supply_pack/goody/firstaidtoxins_single
	name = "毒素医疗箱单包"
	desc = "一个急救箱，专注于治疗由重毒素造成的伤害。"
	cost = PAYCHECK_CREW * 4
	contains = list(/obj/item/storage/medkit/toxin)

/datum/supply_pack/goody/bandagebox_singlepack
	name = "Box of Bandages Single-Pack"
	desc = "A single box of DeForest brand bandages. For when you don't want to see your doctor."
	cost = PAYCHECK_CREW * 3
	contains = list(/obj/item/storage/box/bandages)

/datum/supply_pack/goody/toolbox // mostly just to water down coupon probability
	name = "机械工具箱"
	desc = "一个储备充足的机械工具箱，当你懒得打印出来的时候可以用这个。"
	cost = PAYCHECK_CREW * 3
	contains = list(/obj/item/storage/toolbox/mechanical)

/datum/supply_pack/goody/autolatheboard
	name = "Autolathe Circuit Board"
	desc = "A single autolathe circuit board for your construction needs."
	cost = PAYCHECK_CREW * 2
	contains = list(/obj/item/circuitboard/machine/autolathe)

/datum/supply_pack/goody/valentine
	name = "情人节贺卡"
	desc = "给那个特别的人留下深刻印象！附赠一张情人节贺卡和一颗免费的心形糖果！"
	cost = PAYCHECK_CREW * 2
	contains = list(/obj/item/paper/valentine, /obj/item/food/candyheart)

/datum/supply_pack/goody/beeplush
	name = "蜜蜂玩偶"
	desc = "这是你花费你的血汗钱换来的最值得的结果。"
	cost = PAYCHECK_CREW * 4
	contains = list(/obj/item/toy/plush/beeplushie)

/datum/supply_pack/goody/blahaj
	name = "Shark Plushie"
	desc = "A soft, warm companion for midday naps."
	cost = PAYCHECK_CREW * 5
	contains = list(/obj/item/toy/plush/shark)

/datum/supply_pack/goody/horseplush
	name = "Horse Plushie"
	desc = "A horse friend to keep you company. You're basically a cowboy now."
	cost = PAYCHECK_CREW * 4
	contains = list(/obj/item/toy/plush/horse)

/datum/supply_pack/goody/unicornplush
	name = "Unicorn Plushie"
	desc = "Good for someone who likes unicorns. Wait, that's everybody!"
	cost = PAYCHECK_CREW * 5
	contains = list(/obj/item/toy/plush/unicorn)

/datum/supply_pack/goody/dog_bone
	name = "Jumbo Dog Bone"
	desc = "The best dog bone money can have exported to a space station. A perfect gift for a dog."
	cost = PAYCHECK_COMMAND * 4
	contains = list(/obj/item/dog_bone)

/datum/supply_pack/goody/dyespray
	name = "染发喷剂"
	desc = "一个很酷的喷雾，把你的头发染成令人敬畏的颜色！"
	cost = PAYCHECK_CREW * 2
	contains = list(/obj/item/dyespray)

/datum/supply_pack/goody/beach_ball
	name = "Beach Ball Single-Pack"
	// uses desc from item
	cost = PAYCHECK_CREW
	contains = list(/obj/item/toy/beach_ball/branded)

/datum/supply_pack/goody/beach_ball/New()
	..()
	var/obj/item/toy/beach_ball/branded/beachball_type = /obj/item/toy/beach_ball/branded
	desc = initial(beachball_type.desc)

/datum/supply_pack/goody/medipen_twopak
	name = "医疗笔两支装"
	desc = "包含一支标准肾上腺素自动注射器和一支标准紧急自动注射器。当你想为最坏情况做好准备时使用."
	cost = PAYCHECK_CREW * 2
	contains = list(
		/obj/item/reagent_containers/hypospray/medipen,
		/obj/item/reagent_containers/hypospray/medipen/ekit
	)

/datum/supply_pack/goody/mothic_rations
	name = "蛾类盈余口粮包"
	desc = "来自摩蒂斯舰队的一份单独的补给包。内含 3 块随机的营养补给条，以及一包阿蒂文口香糖。"
	cost = PAYCHECK_COMMAND * 2
	contains = list(/obj/item/storage/box/mothic_rations)

/datum/supply_pack/goody/ready_donk
	name = "Ready-Donk Single Meal"
	desc = "A complete meal package for the terminally lazy. Contains one Ready-Donk meal."
	cost = PAYCHECK_CREW * 2
	contains = list(/obj/item/food/ready_donk)

/datum/supply_pack/goody/pill_mutadone
	name = "Emergency Mutadone Pill Single-Pack"
	desc = "一颗药就能治愈遗传缺陷。当你不能从医疗药柜买到的时候很有用。"
	cost = PAYCHECK_CREW * 2.5
	contains = list(/obj/item/reagent_containers/applicator/pill/mutadone)

/datum/supply_pack/goody/rapid_lighting_device
	name = "Rapid Lighting Device (RLD) Single-Pack"
	desc = "一种用于快速为某一区域提供光源的装置。用铁、等离子铁、玻璃或压缩物质筒重新装填。"
	cost = PAYCHECK_CREW * 10
	contains = list(/obj/item/construction/rld)

/datum/supply_pack/goody/fishing_toolbox
	name = "钓鱼工具箱"
	desc = "Complete toolbox set for your fishing adventure. Contains a valuable tip. Advanced hooks and lines sold separately."
	cost = PAYCHECK_CREW * 2
	contains = list(/obj/item/storage/toolbox/fishing)

/datum/supply_pack/goody/fishing_hook_set
	name = "钓鱼钩套装"
	desc = "一套不同类型的鱼钩."
	cost = PAYCHECK_CREW
	contains = list(/obj/item/storage/box/fishing_hooks)

/datum/supply_pack/goody/fishing_line_set
	name = "钓鱼线套装"
	desc = "一套不同类型的钓鱼线."
	cost = PAYCHECK_CREW
	contains = list(/obj/item/storage/box/fishing_lines)

/datum/supply_pack/goody/fishing_lure_set
	name = "Fishing Lures Set"
	desc = "A set of bite-resistant fishing lures to fish all (most) sort of fish. Beat randomness to a curb today!"
	cost = PAYCHECK_CREW * 8
	contains = list(/obj/item/storage/box/fishing_lures)

/datum/supply_pack/goody/fishing_hook_rescue
	name = "Rescue Fishing Hook Single-Pack"
	desc = "For when your fellow miner has inevitably fallen into a chasm, and it's up to you to save them."
	cost = PAYCHECK_CREW * 12
	contains = list(/obj/item/fishing_hook/rescue)

/datum/supply_pack/goody/premium_bait
	name = "Deluxe Fishing Bait Single-Pack"
	desc = "当普通的满足不了你的时候."
	cost = PAYCHECK_CREW
	contains = list(/obj/item/bait_can/worm/premium)

/datum/supply_pack/goody/fish_feed
	name = "Can of Fish Food Single-Pack"
	desc = "For keeping your little friends fed and alive."
	cost = PAYCHECK_CREW
	contains = list(/obj/item/reagent_containers/cup/fish_feed)

/datum/supply_pack/goody/naturalbait
	name = "Freshness Jars full of Natural Bait Single-Pack"
	desc = "Homemade in the Spinward Sector."
	cost = PAYCHECK_CREW * 4 //rock on
	contains = list(/obj/item/storage/pill_bottle/naturalbait)

/datum/supply_pack/goody/telescopic_fishing_rod
	name = "Telescopic Fishing Rod Single-Pack"
	desc = "A collapsible fishing rod that can fit within a backpack."
	cost = PAYCHECK_CREW * 8
	contains = list(/obj/item/fishing_rod/telescopic)

/datum/supply_pack/goody/fish_analyzer
	name = "Fish Analyzer Single-Pack"
	desc = "A single analyzer to monitor fish's status and traits with, in case you don't have the technology to print one."
	cost = PAYCHECK_CREW * 2.5
	contains = list(/obj/item/fish_analyzer)

/datum/supply_pack/goody/fish_catalog
	name = "Fishing Catalog Single-Pack"
	desc = "A catalog containing all the fishy info you'll ever need."
	cost = PAYCHECK_LOWER
	contains = list(/obj/item/book/manual/fish_catalog)

/datum/supply_pack/goody/aquarium_props
	name = "Aquarium Props Single-Pack"
	desc = "A box containing generic aquarium props. You'll still need an aquarium or fish tank for these."
	cost = PAYCHECK_LOWER
	contains = list(/obj/item/storage/box/aquarium_props)

/datum/supply_pack/goody/coffee_mug
	name = "Coffee Mug Single-Pack"
	desc = "一个普通的咖啡杯，用来喝咖啡."
	cost = PAYCHECK_LOWER
	contains = list(/obj/item/reagent_containers/cup/glass/mug)

/datum/supply_pack/goody/nt_mug
	name = "Nanotrasen Coffee Mug Single-Pack"
	desc = "一个印有你公司老板标志的蓝色马克杯。通常是在入职仪式或活动中分发的，我们可以提供定制版，只需支付少量费用即可。"
	cost = PAYCHECK_LOWER
	contains = list(/obj/item/reagent_containers/cup/glass/mug/nanotrasen)

/datum/supply_pack/goody/coffee_cartridge
	name = "Coffee Cartridge Single-Pack"
	desc = "咖啡机的基本滤芯。可泡4壶咖啡。"
	cost = PAYCHECK_LOWER
	contains = list(/obj/item/coffee_cartridge)

/datum/supply_pack/goody/coffee_cartridge_fancy
	name = "Fancy Coffee Cartridge Single-Pack"
	desc = "用于咖啡机的高档咖啡胶囊.可以泡四壶咖啡."
	cost = PAYCHECK_CREW
	contains = list(/obj/item/coffee_cartridge/fancy)

/datum/supply_pack/goody/coffeepot
	name = "Coffeepot Single-Pack"
	desc = "一个标准尺寸的咖啡壶，用于咖啡机。"
	cost = PAYCHECK_CREW
	contains = list(/obj/item/reagent_containers/cup/coffeepot)

/datum/supply_pack/goody/climbing_hook
	name = "Climbing Hook Single-Pack"
	desc = "A less cheap imported climbing hook. Absolutely no use outside of multi-floor stations."
	cost = PAYCHECK_CREW * 5
	contains = list(/obj/item/climbing_hook)

/datum/supply_pack/goody/double_barrel
	name = "Double-barreled Shotgun Single-Pack"
	desc = "Lost your beloved bunny to a demonic invasion? Clown broke in and stole your beloved gun? No worries! Get a new gun as long as you can pay the absurd fees."
	cost = PAYCHECK_COMMAND * 18
	access_view = ACCESS_WEAPONS
	contains = list(/obj/item/gun/ballistic/shotgun/doublebarrel)

/datum/supply_pack/goody/experimental_medication
	name = "Experimental Medication Single-Pack"
	desc = "A single bottle of Interdyne brand experimental medication, used for treating people suffering from hereditary manifold disease."
	cost = PAYCHECK_CREW * 6.5
	contains = list(/obj/item/storage/pill_bottle/sansufentanyl)

/datum/supply_pack/goody/pet_mouse
	name = "Pet Mouse"
	desc = "Many people consider mice to be vermin, or dirty lab animals for experimentation, or a culinary delicacy. That's why we're not asking any questions, here."
	cost = PAYCHECK_CREW * 1.5
	contains = list(/obj/item/pet_carrier/small/mouse)

/datum/supply_pack/goody/shuttle_construction_kit
	name = "Shuttle Construction Starter Kit"
	desc = "Contains a set of shuttle blueprints, and the circuitboards necessary for constructing your own shuttle. \
			Well at least the ones you can't source yourself without Science's help."
	cost = PAYCHECK_COMMAND * 12 //You assistants with shipwrighting ambitions can do a couple bounties, can't you?
	access_view = ACCESS_AUX_BASE //Engineers have it, QM can give it to whoever, and scientists can just research the tech.
	contains = list(
		/obj/item/shuttle_blueprints,
		/obj/item/circuitboard/computer/shuttle/flight_control,
		/obj/item/circuitboard/computer/shuttle/docker,
		/obj/item/circuitboard/machine/engine/propulsion = 2,
	)

/datum/supply_pack/goody/golfcart_key
	name = "Spare Golf Cart Key"
	desc = "If you in your carelessness lost the key to your golfcart you can purchase one. Unfortunately not covered by warranty."
	cost = PAYCHECK_CREW * 5
	contains = list(/obj/item/key/golfcart)

/datum/supply_pack/goody/handheld_crew_monitor
	name = "Handheld Crew Monitor"
	desc = "A crate containing a handheld crew monitor."
	cost = /obj/item/sensor_device::custom_premium_price * 1.25 // 1.25X base vending machine value
	contains = list(
		/obj/item/sensor_device,
	)
	crate_name = "handheld crew monitor crate"

/datum/supply_pack/goody/camera
	name = "Broadcast Camera"
	desc = "A single broadcast camera which broadcasts to the station's entertainment monitors, for all your theatrical needs."
	cost = PAYCHECK_COMMAND * 8
	contains = list(/obj/item/broadcast_camera/cargo)
