/obj/item/food/piru_dough
	name = "皮鲁面团"
	desc = "一种由皮鲁面粉和穆利果汁制成的粗糙、有弹性的面团，呈醒目的紫色，是大多数特莎丽菜肴的基础。在烧烤或烘烤时会显著膨胀。"
	icon = 'modular_nova/master_files/icons/obj/food/irnbru.dmi'
	icon_state = "piru_dough"
	food_reagents = list(/datum/reagent/consumable/nutriment = 6)
	w_class = WEIGHT_CLASS_SMALL
	tastes = list("minty dough" = 1)
	foodtypes = VEGETABLES
	crafting_complexity = FOOD_COMPLEXITY_1

/obj/item/food/piru_dough/make_processable()
	AddElement(/datum/element/processable, TOOL_ROLLINGPIN, /obj/item/food/flat_piru_dough, 1, 3 SECONDS, table_required = TRUE, screentip_verb = "Flatten")

/obj/item/food/piru_dough/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/piru_loaf, rand(15 SECONDS, 25 SECONDS), TRUE, TRUE)

/obj/item/food/piru_dough/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/piru_loaf, rand(15 SECONDS, 25 SECONDS), TRUE, TRUE)

/obj/item/food/piru_loaf
	name = "皮鲁面包条"
	desc = "一条柔软的皮鲁面包，呈醒目的深紫色，可以切片。它出奇地有弹性，闻起来有相当浓的薄荷味。"
	icon = 'modular_nova/master_files/icons/obj/food/irnbru.dmi'
	icon_state = "piru_loaf"
	food_reagents = list(/datum/reagent/consumable/nutriment = 20)
	tastes = list("minty bread" = 1)
	foodtypes = VEGETABLES
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/piru_loaf/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/breadslice/piru, 4, 3 SECONDS, table_required = TRUE, screentip_verb = "Slice")

/obj/item/food/breadslice/piru
	name = "皮鲁面包片"
	desc = "一片有弹性的皮鲁面包。"
	icon = 'modular_nova/master_files/icons/obj/food/irnbru.dmi'
	icon_state = "piru_bread_slice"
	food_reagents = list(/datum/reagent/consumable/nutriment = 5)
	tastes = list("minty bread" = 1)
	foodtypes = VEGETABLES
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/flat_piru_dough
	name = "压平的皮鲁面团"
	desc = "压平的皮鲁面团，可以在煎锅上烹饪或切成意大利面。"
	icon = 'modular_nova/master_files/icons/obj/food/irnbru.dmi'
	icon_state = "flat_piru_dough"
	food_reagents = list(/datum/reagent/consumable/nutriment = 6)
	tastes = list("minty dough" = 1)
	foodtypes = VEGETABLES
	crafting_complexity = FOOD_COMPLEXITY_1

/obj/item/food/flat_piru_dough/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/piru_pasta, 3, 3 SECONDS, table_required = TRUE, screentip_verb = "Slice")

/obj/item/food/flat_piru_dough/make_grillable()
	AddComponent(/datum/component/grillable, /obj/item/food/grilled_piru_flatbread, rand(15 SECONDS, 25 SECONDS), TRUE, TRUE)

/obj/item/food/flat_piru_dough/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/grilled_piru_flatbread, rand(15 SECONDS, 25 SECONDS), TRUE, TRUE)

/obj/item/food/grilled_piru_flatbread
	name = "烤皮鲁扁面包"
	desc = "酥脆的烤皮鲁扁面包。不再那么有弹性，但闻起来绝对棒极了。"
	icon = 'modular_nova/master_files/icons/obj/food/irnbru.dmi'
	icon_state = "grilled_piru_flatbread"
	food_reagents = list(/datum/reagent/consumable/nutriment = 8)
	tastes = list("minty flatbread" = 1)
	foodtypes = VEGETABLES
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/piru_pasta
	name = "皮鲁意大利面"
	desc = "由皮鲁面团切成厚片制成的有嚼劲的意大利面。"
	icon = 'modular_nova/master_files/icons/obj/food/irnbru.dmi'
	icon_state = "piru_pasta"
	food_reagents = list(/datum/reagent/consumable/nutriment = 4)
	w_class = WEIGHT_CLASS_SMALL
	tastes = list("minty pasta" = 1)
	foodtypes = VEGETABLES
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/baked_kiri
	name = "烤基里果"
	desc = "在烤箱中烘烤过的奇里果，使其内部的果冻焦糖化，形成类似果冻甜甜圈的酥脆点心。小心别上瘾。"
	icon = 'modular_nova/master_files/icons/obj/food/irnbru.dmi'
	icon_state = "baked_kiri"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/kiri_jelly = 6
	)
	w_class = WEIGHT_CLASS_SMALL
	tastes = list("crispy sweetness" = 1, "caramelized jelly" = 1)
	foodtypes = FRUIT | SUGAR
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/baked_muli
	name = "烤穆里豆荚"
	desc = "在烤箱中烘烤过的穆里豆荚，使其内部的薄荷液体凝结，外皮软化，让这种蔬菜具有类似煮硬鸡蛋的口感。异常美味且健康！"
	icon = 'modular_nova/master_files/icons/obj/food/irnbru.dmi'
	icon_state = "baked_muli"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/vitamin = 4,
		/datum/reagent/consumable/muli_juice = 4
	)
	w_class = WEIGHT_CLASS_SMALL
	tastes = list("zesty mintyness" = 1)
	foodtypes = VEGETABLES
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/spiced_jerky
	name = "香料肉干"
	desc = "用纳卡蒂香料调味并脱水处理的一块肉。是一种美味耐嚼的零食。"
	icon = 'modular_nova/master_files/icons/obj/food/irnbru.dmi'
	icon_state = "spiced_jerky"
	custom_materials = list(/datum/material/meat = MEATDISH_MATERIAL_AMOUNT)
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 8,
		/datum/reagent/consumable/nutriment/protein = 6
	)
	w_class = WEIGHT_CLASS_SMALL
	tastes = list("tough, spicy jerky" = 1)
	foodtypes = MEAT
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/sirisai_wrap
	name = "西里赛卷饼"
	desc = "用纳卡蒂香料调味的肉和卷心菜，紧紧包裹在压平的皮鲁面包里。简单、清淡、美味。"
	icon = 'modular_nova/master_files/icons/obj/food/irnbru.dmi'
	icon_state = "sirisai_wrap"
	custom_materials = list(/datum/material/meat = MEATDISH_MATERIAL_AMOUNT)
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 8,
		/datum/reagent/consumable/nutriment/protein = 6,
		/datum/reagent/consumable/nutriment/vitamin = 6
	)
	w_class = WEIGHT_CLASS_SMALL
	tastes = list("cooked cabbage" = 1, "spiced meat" = 1, "minty piru bread" = 1)
	foodtypes = MEAT | VEGETABLES
	crafting_complexity = FOOD_COMPLEXITY_4

/obj/item/food/sweet_piru_noodles
	name = "甜皮鲁面条"
	desc = "皮鲁意面与切碎的奇里果、穆里豆荚和胡萝卜在碗中混合而成。看起来很奇怪，似乎有点黏糊糊的，但味道无可否认。"
	icon = 'modular_nova/master_files/icons/obj/food/irnbru.dmi'
	icon_state = "sweet_piru_noodles"
	trash_type = /obj/item/reagent_containers/cup/bowl
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 8,
		/datum/reagent/consumable/kiri_jelly = 4,
		/datum/reagent/consumable/muli_juice = 4,
		/datum/reagent/consumable/nutriment/vitamin = 4
	)
	w_class = WEIGHT_CLASS_SMALL
	tastes = list("minty piru noodles" = 1, "minty muli juice" = 1, "sugary kiri jelly" = 1, "baked carrots" = 1)
	foodtypes = VEGETABLES | FRUIT | SUGAR
	crafting_complexity = FOOD_COMPLEXITY_4

/obj/item/food/kiri_curry
	name = "奇里咖喱"
	desc = "香料肉与细切皮鲁意面和剁碎的辣椒混合，淋上皮鲁果冻酱，正是辣味与甜味的完美平衡。"
	icon = 'modular_nova/master_files/icons/obj/food/irnbru.dmi'
	icon_state = "kiri_curry"
	custom_materials = list(/datum/material/meat = MEATDISH_MATERIAL_AMOUNT)
	trash_type = /obj/item/reagent_containers/cup/bowl
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 8,
		/datum/reagent/consumable/nutriment/protein = 4,
		/datum/reagent/consumable/kiri_jelly = 6,
		/datum/reagent/consumable/nutriment/vitamin = 4
	)
	w_class = WEIGHT_CLASS_SMALL
	tastes = list("heavily seasoned meat" = 1, "sweetened minty piru noodles" = 1, "zesty chilis" = 1)
	foodtypes = VEGETABLES | FRUIT | SUGAR | MEAT
	crafting_complexity = FOOD_COMPLEXITY_5

/obj/item/food/sirisai_flatbread
	name = "西里赛扁面包"
	desc = "皮鲁扁面包烤至酥脆，上面铺有肉、切碎的穆里豆荚和番茄酱。看起来类似披萨，但颜色更偏紫和蓝。可以切片！"
	icon = 'modular_nova/master_files/icons/obj/food/irnbru.dmi'
	icon_state = "sirisai_flatbread"
	custom_materials = list(/datum/material/meat = MEATSLAB_MATERIAL_AMOUNT)
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 24,
		/datum/reagent/consumable/nutriment/protein = 16,
		/datum/reagent/consumable/muli_juice = 12,
		/datum/reagent/consumable/nutriment/vitamin = 16
	)
	w_class = WEIGHT_CLASS_SMALL
	tastes = list("crispy minty flatbread" = 1, "minty muli pods" = 1, "tomato sauce" = 1, "tangy spice" = 1, "baked meat" = 1)
	foodtypes = VEGETABLES | MEAT
	crafting_complexity = FOOD_COMPLEXITY_4

/obj/item/food/sirisai_flatbread/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/sirisai_flatbread_slice, 4, 3 SECONDS, table_required = TRUE, screentip_verb = "Slice")

/obj/item/food/sirisai_flatbread_slice
	name = "西里赛扁面包切片"
	desc = "一片烤至酥脆的皮鲁扁面包，上面铺有肉、切碎的穆里豆荚和番茄酱。看起来类似一片披萨，但颜色更偏紫和蓝。"
	icon = 'modular_nova/master_files/icons/obj/food/irnbru.dmi'
	icon_state = "sirisai_flatbread_slice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/protein = 4,
		/datum/reagent/consumable/muli_juice = 3,
		/datum/reagent/consumable/nutriment/vitamin = 4
	)
	w_class = WEIGHT_CLASS_SMALL
	tastes = list("crispy minty flatbread" = 1, "minty muli pods" = 1, "tomato sauce" = 1, "tangy spice" = 1, "baked meat" = 1)
	foodtypes = VEGETABLES | MEAT
	crafting_complexity = FOOD_COMPLEXITY_4
	custom_materials = list(/datum/material/meat = MEATDISH_MATERIAL_AMOUNT * 3/4)

/obj/item/food/bluefeather_crisp
	name = "蓝羽脆片"
	desc = "一种用压平、干燥的皮鲁面包制成的香料薄脆饼干。其名称来源于食用时搭配穆里蘸酱常会在羽毛上留下的蓝色污渍。"
	icon = 'modular_nova/master_files/icons/obj/food/irnbru.dmi'
	icon_state = "bluefeather_crisp"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/vitamin = 2
	)
	w_class = WEIGHT_CLASS_SMALL
	tastes = list("chewy crackers" = 1, "zesty spice" = 1, "pleasant mintyness" = 1)
	foodtypes = VEGETABLES
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/bluefeather_crisps_and_dip
	name = "蓝羽脆片配蘸酱"
	desc = "蓝羽脆片饼干，现在配有穆里果汁和番茄制成的蘸酱。其名称来源于滴到羽毛上时常会留下的蓝色污渍。"
	icon = 'modular_nova/master_files/icons/obj/food/irnbru.dmi'
	icon_state = "bluefeather_crisps_and_dip"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 12,
		/datum/reagent/consumable/muli_juice = 8,
		/datum/reagent/consumable/nutriment/vitamin = 6
	)
	w_class = WEIGHT_CLASS_SMALL
	tastes = list("chewy crackers" = 1, "tangy dip" = 1, "pleasant mintyness" = 1)
	foodtypes = VEGETABLES
	crafting_complexity = FOOD_COMPLEXITY_4

/obj/item/food/stewed_muli
	name = "炖穆里"
	desc = "一道简单的炖菜，由肉、胡萝卜和卷心菜在穆利汁中炖煮而成。专为成长中的特莎里准备。"
	icon = 'modular_nova/master_files/icons/obj/food/irnbru.dmi'
	icon_state = "stewed_muli"
	trash_type = /obj/item/reagent_containers/cup/bowl
	custom_materials = list(/datum/material/meat = MEATDISH_MATERIAL_AMOUNT * 2)
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 10,
		/datum/reagent/consumable/nutriment/protein = 8,
		/datum/reagent/consumable/nutriment/vitamin = 6,
		/datum/reagent/consumable/muli_juice = 6
	)
	w_class = WEIGHT_CLASS_SMALL
	tastes = list("hearty spiced meat" = 1, "baked carrots" = 1, "baked cabbage" = 1, "minty broth" = 1)
	foodtypes = VEGETABLES | MEAT
	crafting_complexity = FOOD_COMPLEXITY_5

/obj/item/food/stuffed_muli_pod
	name = "酿穆利荚"
	desc = "一个煮熟的穆利荚，现在塞满了肉、切碎的基里果和辣椒。嚼劲十足，甜辣兼备！"
	icon = 'modular_nova/master_files/icons/obj/food/irnbru.dmi'
	icon_state = "stuffed_muli_pod"
	custom_materials = list(/datum/material/meat = MEATDISH_MATERIAL_AMOUNT)
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 8,
		/datum/reagent/consumable/nutriment/protein = 4,
		/datum/reagent/consumable/nutriment/vitamin = 4,
		/datum/reagent/consumable/muli_juice = 4
	)
	w_class = WEIGHT_CLASS_SMALL
	tastes = list("spiced meat" = 1, "minty muli pod" = 1, "super-sweet kiri fruit" = 1, "chili" = 1)
	foodtypes = VEGETABLES | FRUIT | MEAT | SUGAR
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/caramel_jelly_toast
	name = "焦糖果酱吐司"
	desc = "一片烤过的皮鲁面包，厚厚地涂满了浓稠的焦糖和甜美的基里果酱。这到底是早餐还是甜点？"
	icon = 'modular_nova/master_files/icons/obj/food/irnbru.dmi'
	icon_state = "caramel_jelly_toast"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 8,
		/datum/reagent/consumable/nutriment/vitamin = 6
	)
	w_class = WEIGHT_CLASS_SMALL
	tastes = list("minty piru bread" = 1, "sweet caramel" = 1, "super-sweet kiri jelly" = 1)
	foodtypes = VEGETABLES | FRUIT | SUGAR
	crafting_complexity = FOOD_COMPLEXITY_4

/obj/item/food/kiri_jellypuff
	name = "基里果酱泡芙"
	desc = "一块皮鲁面包被膨化并卷成厚圆盘，内含基里果酱和奶油馅料，并撒上了皮鲁面粉。一个永远不够吃。"
	icon = 'modular_nova/master_files/icons/obj/food/irnbru.dmi'
	icon_state = "kiri_jellypuff"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 8,
		/datum/reagent/consumable/nutriment/vitamin = 6,
		/datum/reagent/consumable/kiri_jelly = 4
	)
	w_class = WEIGHT_CLASS_SMALL
	tastes = list("puffed minty piru bread" = 1, "rich cream" = 1, "super-sweet kiri jelly" = 1)
	foodtypes = VEGETABLES | FRUIT | SUGAR
	crafting_complexity = FOOD_COMPLEXITY_4

