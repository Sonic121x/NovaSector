//肝
/obj/item/food/donkpocket/liver
	name = "\improper 肝口袋饼"
	desc = "Donk 公司声明：本口袋饼生产过程中没有任何肝脏受到伤害"
	icon = 'modular_z121/icons/obj/food/pocket/liverpocket.dmi'
	icon_state = "liverpocket"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/iron = 5,
		/datum/reagent/consumable/nutriment/organ_tissue = 2,
		/datum/reagent/consumable/nutriment/peptides = 3,
		/datum/reagent/medicine/higadrite = 4
		)
	tastes = list("earthly pungent" = 2, "iron" = 1)
	foodtypes = GORE | MEAT
	crafting_complexity = FOOD_COMPLEXITY_2
	warm_type = /obj/item/food/donkpocket/warm/liver

/obj/item/food/donkpocket/warm/liver
	name = "温肝口袋饼"
	desc = "冰冷的肝脏化为了温暖的口袋饼"
	icon = 'modular_z121/icons/obj/food/pocket/liverpocket.dmi'
	icon_state = "warm_liverpocket"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/iron = 5,
		/datum/reagent/consumable/nutriment/organ_tissue = 2,
		/datum/reagent/consumable/nutriment/peptides = 3,
		/datum/reagent/medicine/omnizine = 5,
		/datum/reagent/medicine/higadrite = 4
	)
	tastes = list("meat" = 2, "iron" = 1)
	foodtypes = GRAIN | MEAT
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/storage/box/donkpockets/donkpocketliver
	name = "一盒肝口袋饼"
	icon = 'modular_z121/icons/obj/food/pocket/liverpocket.dmi'
	icon_state = "donkpocketliver"
	donktype = /obj/item/food/donkpocket/liver

/datum/crafting_recipe/food/liverpocket
	time = 15
	name = "肝口袋饼"
	reqs = list(
		/obj/item/food/doughslice = 1,
		/obj/item/organ/liver = 1
	)
	result = /obj/item/food/donkpocket/liver
	category = CAT_PASTRY
  
//默剧
/obj/item/food/donkpocket/mime
	name = "\improper 默剧口袋饼"
	desc = "..."
	icon = 'modular_z121/icons/obj/food/pocket/mimepocket.dmi'
	icon_state = "mimepocket"
	food_reagents = list(
		/datum/reagent/nitrogen = 4,
		/datum/reagent/oxygen = 1,
        /datum/reagent/toxin/slimejelly = 6,
		/datum/reagent/consumable/nutriment = 6,
        /datum/reagent/consumable/nutriment/protein = 4,
		)
	tastes = list("nothing" = 2)
	foodtypes = GRAIN
	crafting_complexity = FOOD_COMPLEXITY_2
	warm_type = /obj/item/food/donkpocket/warm/mime

/obj/item/food/donkpocket/warm/mime
	name = "温默剧口袋饼"
	desc = "..."
	icon = 'modular_z121/icons/obj/food/pocket/mimepocket.dmi'
	icon_state = "warm_mimepocket"
	food_reagents = list(
		/datum/reagent/nitrogen = 4,
		/datum/reagent/oxygen = 1,
		/datum/reagent/toxin/mutetoxin,
		/datum/reagent/consumable/nutriment = 6,
        /datum/reagent/consumable/nutriment/protein = 4
	)
	tastes = list("nothing" = 2)
	foodtypes = GRAIN
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/storage/box/donkpockets/donkpocketmime
	name = "一盒默剧口袋饼"
	icon = 'modular_z121/icons/obj/food/pocket/mimepocket.dmi'
	icon_state = "donkpocketmime"
	donktype = /obj/item/food/donkpocket/mime

/datum/crafting_recipe/food/mimepocket
	time = 15
	name = "默剧口袋饼"
	reqs = list(
		/obj/item/food/doughslice = 1,
		/datum/reagent/nitrogen = 20,
		/datum/reagent/oxygen = 5
	)
	result = /obj/item/food/donkpocket/mime
	category = CAT_PASTRY

//鼠鼠
/obj/item/food/donkpocket/rat
	name = "\improper 鼠口袋饼"
	desc = "Donk 公司声明：本口袋饼生产过程中没有任何鼠鼠受到伤害"
	icon = 'modular_z121/icons/obj/food/pocket/ratpocket.dmi'
	icon_state = "ratpocket"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/blood = 2,
		/datum/reagent/consumable/nutriment/protein = 4,
		)
	tastes = list("meat" = 2, "blood" = 1)
	foodtypes = RAW | MEAT | GRAIN
	crafting_complexity = FOOD_COMPLEXITY_2
	warm_type = /obj/item/food/donkpocket/warm/rat

/obj/item/food/donkpocket/warm/rat
	name = "温鼠口袋饼"
	desc = "老实说，你不知道为什么加热鼠口袋饼会带来奶酪的味道。"
	icon = 'modular_z121/icons/obj/food/pocket/ratpocket.dmi'
	icon_state = "warm_ratpocket"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 9,
		/datum/reagent/consumable/nutriment/protein = 6,
		/datum/reagent/consumable/nutriment/fat = 2,
		/datum/reagent/medicine/omnizine = 4,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("meat" = 2, "cheese" = 3)
	foodtypes = GRAIN | MEAT
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/storage/box/donkpockets/donkpocketrat
	name = "一盒鼠口袋饼"
	icon = 'modular_z121/icons/obj/food/pocket/ratpocket.dmi'
	icon_state = "donkpocketrat"
	donktype = /obj/item/food/donkpocket/rat

/datum/crafting_recipe/food/ratpocket
	time = 15
	name = "鼠口袋饼"
	reqs = list(
		/obj/item/food/doughslice = 1,
		/obj/item/food/deadmouse = 1
	)
	result = /obj/item/food/donkpocket/rat
	category = CAT_PASTRY

//史莱姆
/obj/item/food/donkpocket/slime
	name = "\improper 史莱姆口袋饼"
	desc = "为什么一个看起来就是坨史莱姆的饼里会有营养物质，这河里吗？——Donk 首席研究员 ZIPT\ 注:在加热前对非史莱姆人剧毒。"
	icon = 'modular_z121/icons/obj/food/pocket/slimepocket.dmi'
	icon_state = "slimepocket"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 10,
		/datum/reagent/consumable/nutriment/protein = 5,
        /datum/reagent/toxin/slimejelly = 8,
		)
	tastes = list("stickiness" = 2, "sweetness" = 1)
	foodtypes = TOXIC | GRAIN
	crafting_complexity = FOOD_COMPLEXITY_2
	warm_type = /obj/item/food/donkpocket/warm/slime

/obj/item/food/donkpocket/warm/slime
	name = "温史莱姆口袋饼"
	desc = "Donk 公司严肃声明:本公司不为食用本口袋饼造成的任何头发变色问题负责。非史莱姆人请磨碎本产品后注射使用。"
	icon = 'modular_z121/icons/obj/food/pocket/slimepocket.dmi'
	icon_state = "warm_slimepocket"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 14,
        /datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/medicine/regen_jelly = 6
	)
	tastes = list("stickiness" = 2, "sweetness" = 1)
	foodtypes = GRAIN | TOXIC
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/storage/box/donkpockets/donkpocketslime
	name = "一盒史莱姆口袋饼"
	icon = 'modular_z121/icons/obj/food/pocket/slimepocket.dmi'
	icon_state = "donkpocketslime"
	donktype = /obj/item/food/donkpocket/slime

/datum/crafting_recipe/food/slimepocket
	time = 15
	name = "史莱姆口袋饼"
	reqs = list(
		/obj/item/food/doughslice = 1,
		/obj/item/slime_extract/grey = 1
	)
	result = /obj/item/food/donkpocket/slime
	category = CAT_PASTRY
