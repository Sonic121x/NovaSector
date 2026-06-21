/obj/item/reagent_containers/hash
	name = "哈希"
	desc = "浓缩大麻提取物。在烟枪中使用时能带来更强烈的快感。"
	icon = 'modular_nova/modules/morenarcotics/icons/crack.dmi'
	icon_state = "hash"
	volume = 20
	has_variable_transfer_amount = FALSE
	list_reagents = list(/datum/reagent/drug/thc = 15, /datum/reagent/toxin/lipolicide = 5)

/obj/item/reagent_containers/hash/dabs
	name = "浓缩大麻油"
	desc = "从大麻植物中提取的油。只是提供另一种类型的冲击。"
	icon = 'modular_nova/modules/morenarcotics/icons/crack.dmi'
	icon_state = "dab"
	volume = 40
	has_variable_transfer_amount = FALSE
	list_reagents = list(/datum/reagent/drug/thc/concentrated = 40) //horrendously powerful

/obj/item/reagent_containers/hashbrick
	name = "哈希砖块"
	desc = "一块大麻砖。便于运输！"
	icon = 'modular_nova/modules/morenarcotics/icons/crack.dmi'
	icon_state = "hashbrick"
	volume = 80
	has_variable_transfer_amount = FALSE
	list_reagents = list(/datum/reagent/drug/thc = 60, /datum/reagent/toxin/lipolicide = 20)


/obj/item/reagent_containers/hashbrick/attack_self(mob/user)
	user.visible_message(span_notice("[user] 开始拆解 [src]。"))
	if(do_after(user,10))
		to_chat(user, span_notice("你完成了对[src]的粉碎。"))
		for(var/i = 1 to 4)
			new /obj/item/reagent_containers/hash(user.loc)
		qdel(src)

/datum/crafting_recipe/hashbrick
	name = "哈希砖块"
	result = /obj/item/reagent_containers/hashbrick
	reqs = list(/obj/item/reagent_containers/hash = 4)
	parts = list(/obj/item/reagent_containers/hash = 4)
	time = 20
	category = CAT_CHEMISTRY

//export values
/datum/export/hash
	cost = CARGO_CRATE_VALUE * 0.35
	unit_name = "hash"
	export_types = list(/obj/item/reagent_containers/hash)
	include_subtypes = FALSE

/datum/export/crack/hashbrick
	cost = CARGO_CRATE_VALUE * 2
	unit_name = "hash brick"
	export_types = list(/obj/item/reagent_containers/hashbrick)
	include_subtypes = FALSE

/datum/export/dab
	cost = CARGO_CRATE_VALUE * 0.4
	unit_name = "dab"
	export_types = list(/obj/item/reagent_containers/hash/dabs)
	include_subtypes = FALSE

/obj/item/food/brownie/thc
	name = "哈希布朗尼"
	desc = "一块方形的美味耐嚼布朗尼，注入了四氢大麻酚。是大麻爱好者的最爱。"
	icon = 'modular_nova/modules/morenarcotics/icons/thcsnacks.dmi'
	icon_state = "brownieweed"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 5,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/drug/thc = 10, // These brownies and no joke.
	)

/obj/item/storage/fancy/cigarettes/crownhaze
	name = "\improper 皇冠烟王之雾"
	desc = "这些预卷烟丝来自最优质的大麻植株，保证让你感觉如同皇室成员。请负责任地吸食。"
	icon = 'modular_nova/modules/morenarcotics/icons/thcsnacks.dmi'
	icon_state = "weedpack"
	base_icon_state = "weedpack"
	spawn_type = /obj/item/cigarette/rollie/thc

/obj/item/cigarette/rollie/thc
	list_reagents = list(/datum/reagent/drug/thc = 15)

/obj/item/reagent_containers/cup/soda_cans/thc
	name = "\improper 果园绿"
	desc = "液态星辰的味道。加入了橙子味的THC混合物，让日子过得轻松一点。"
	icon = 'modular_nova/modules/morenarcotics/icons/thcsnacks.dmi'
	icon_state = "thcdrink"
	list_reagents = list(/datum/reagent/consumable/space_cola = 11, /datum/reagent/consumable/orangejuice = 11, /datum/reagent/drug/thc = 8)
	drink_type = SUGAR | FRUIT | JUNKFOOD

/obj/item/food/thcgummies
	name = "酸苹果味THC软糖"
	desc = "嚼起来有点太硬了，不太舒服，但味道都对。本产品含有四氢大麻酚。"
	icon = 'modular_nova/modules/morenarcotics/icons/thcsnacks.dmi'
	icon_state = "thcgummy"
	bite_consumption = 1
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 1,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/drug/thc = 8,
	)
	junkiness = 20
	tastes = list("cannabis" = 1, "sour... apple?" = 1, "something sweet" = 1)
	foodtypes = FRUIT|JUNKFOOD //Fruity Twist
	w_class = WEIGHT_CLASS_SMALL

/obj/item/food/cookie/thc
	name = "THC曲奇"
	desc = "饼干！！！但有点不一样！"
	icon = 'modular_nova/modules/morenarcotics/icons/thcsnacks.dmi'
	icon_state = "thccookie"
	bite_consumption = 1
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/drug/thc = 10,
	)
	tastes = list("cookie" = 1, "cannabis" = 1)
	foodtypes = GRAIN | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_2
