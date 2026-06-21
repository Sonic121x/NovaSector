/obj/item/storage/box/foodpack
	name = "包装餐盒"
	desc = "一个普通的棕色纸质食品包装袋，你不太确定它来自哪里。"
	icon = 'modular_nova/modules/imported_vendors/icons/imported_quick_foods.dmi'
	icon_state = "foodpack_generic_big"
	illustration = null
	custom_price = PAYCHECK_CREW * 1.8
	///What the main course of this package is
	var/main_course = /obj/item/trash/empty_food_tray
	///What the side of this package should be
	var/side_item = /obj/item/food/vendor_snacks
	///What kind of condiment pack should we give the package
	var/condiment_pack = /obj/item/reagent_containers/condiment/pack/ketchup

/obj/item/storage/box/foodpack/PopulateContents()
	. = ..()
	new main_course(src)
	new side_item(src)
	new condiment_pack(src)

/obj/item/storage/box/foodpack/nt
	name = "\improper NT-套餐 - 索尔兹伯里牛排"
	desc = "A relatively bland package made of reflective metal foil, it has a blue sprite and the letters 'NT' printed on the top."
	icon_state = "foodpack_nt_big"
	main_course = /obj/item/food/vendor_tray_meal
	side_item = /obj/effect/spawner/random/vendor_meal_sides/nt
	condiment_pack = /obj/item/reagent_containers/condiment/pack/ketchup

/obj/item/storage/box/foodpack/nt/burger
	name = "\improper 纳米传讯-套餐 - 芝士汉堡"
	main_course = /obj/item/food/vendor_tray_meal/burger

/obj/item/storage/box/foodpack/nt/chicken_sammy
	name = "\improper 纳米传讯-套餐 - 香辣鸡肉三明治"
	main_course = /obj/item/food/vendor_tray_meal/chicken_sandwich

/obj/item/storage/box/foodpack/yangyu
	name = "\improper 暖食 - 家常面条"
	desc = "一个装饰精美的红白塑料包装，上面布满了几乎难以理解的阳鱼文字。"
	icon_state = "foodpack_yangyu_big"
	main_course = /obj/item/food/vendor_tray_meal/ramen
	side_item = /obj/effect/spawner/random/vendor_meal_sides/yangyu
	condiment_pack = /obj/item/reagent_containers/condiment/pack/hotsauce

/obj/item/storage/box/foodpack/yangyu/sushi
	name = "\improper 暖食 - 鲤鱼寿司卷"
	main_course = /obj/item/food/vendor_tray_meal/sushi

/obj/item/storage/box/foodpack/yangyu/beef_rice
	name = "\improper 暖食 - 牛肉米饭"
	main_course = /obj/item/food/vendor_tray_meal/beef_rice

/obj/item/storage/box/foodpack/moth
	name = "\improper M型口粮 - 香草披萨"
	desc = "一个纸板色的纸包装，上面印着游牧舰队的标志。"
	icon_state = "foodpack_moth_big"
	main_course = /obj/item/food/vendor_tray_meal/pesto_pizza
	side_item = /obj/effect/spawner/random/vendor_meal_sides/moth
	condiment_pack = /obj/item/reagent_containers/condiment/pack/astrotame

/obj/item/storage/box/foodpack/moth/baked_rice
	name = "\improper M型口粮 - 焗饭配烤奶酪"
	main_course = /obj/item/food/vendor_tray_meal/baked_rice

/obj/item/storage/box/foodpack/moth/fuel_jack
	name = "\improper M型口粮 - 燃料工的盛宴"
	main_course = /obj/item/food/vendor_tray_meal/fueljack

/obj/item/storage/box/foodpack/tizira
	name = "\improper 提兹拉进口包 - 月鱼尼扎亚"
	desc = "一个暗淡的金属箔包装，上面印有提兹拉国旗的条纹，以及提兹拉出口办公室的合法原产地印章。"
	icon_state = "foodpack_tizira_big"
	main_course = /obj/item/food/vendor_tray_meal/moonfish_nizaya
	side_item = /obj/effect/spawner/random/vendor_meal_sides/tizira
	condiment_pack = /obj/item/reagent_containers/condiment/pack/bbqsauce
	custom_price = PAYCHECK_CREW * 2 //Tiziran imports are a bit more expensive

/obj/item/storage/box/foodpack/tizira/examine_more(mob/user)
	. = ..()
	. += span_notice("<b>现在仔细一看，这个原产地印章似乎是真品的拙劣仿冒！</b>")
	return .

/obj/item/storage/box/foodpack/tizira/roll
	name = "\improper 提兹拉进口包 - 帝王卷"
	main_course = /obj/item/food/vendor_tray_meal/emperor_roll

/obj/item/storage/box/foodpack/tizira/stir_fry
	name = "\improper 提兹拉进口包 - 蘑菇炒菜"
	main_course = /obj/item/food/vendor_tray_meal/mushroom_fry
