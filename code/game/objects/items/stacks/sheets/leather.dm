/obj/item/stack/sheet/animalhide
	name = "皮革"
	desc = "出了点问题。"
	icon_state = "sheet-hide"
	inhand_icon_state = null
	novariants = TRUE
	merge_type = /obj/item/stack/sheet/animalhide
	pickup_sound = 'sound/items/handling/materials/skin_pick_up.ogg'
	drop_sound = 'sound/items/handling/materials/skin_drop.ogg'
	abstract_type = /obj/item/stack/sheet/animalhide

/// Subtype of skin to be dropped by carbon mobs as a result of being butchered, potentially inheriting their body color
/obj/item/stack/sheet/animalhide/carbon
	abstract_type = /obj/item/stack/sheet/animalhide/carbon
	/// Color of our skin, if we were created from a mob being butchered
	var/skin_color = null
	/// Should we recolor our sprite and prevent merging of stacks of different skin colors?
	var/uses_skin_color = FALSE

/obj/item/stack/sheet/animalhide/carbon/Initialize(mapload, new_amount, merge, list/mat_override, mat_amt, new_skin_color)
	. = ..()
	if (!skin_color)
		set_skin_color(new_skin_color || get_random_skin_color())

/obj/item/stack/sheet/animalhide/carbon/can_merge(obj/item/stack/sheet/animalhide/carbon/check, inhand)
	. = ..()
	if (!. || !uses_skin_color)
		return
	return check.skin_color == skin_color // segregation, in my human butcher shop? how queer!

/obj/item/stack/sheet/animalhide/carbon/proc/set_skin_color(new_skin_color)
	skin_color = new_skin_color
	if (skin_color && uses_skin_color)
		add_atom_colour(skin_color, FIXED_COLOUR_PRIORITY)
	else
		remove_atom_colour(FIXED_COLOUR_PRIORITY)

/obj/item/stack/sheet/animalhide/carbon/split_stack(amount)
	var/obj/item/stack/sheet/animalhide/carbon/new_stack = ..()
	if (!new_stack)
		return
	new_stack.set_skin_color(skin_color)
	return new_stack

/// Select a random skin color to spawn
/obj/item/stack/sheet/animalhide/carbon/proc/get_random_skin_color()
	return null

/obj/item/stack/sheet/animalhide/carbon/human
	name = "人皮"
	desc = "人类养殖的副产品。"
	singular_name = "human skin piece"
	novariants = FALSE
	merge_type = /obj/item/stack/sheet/animalhide/carbon/human

GLOBAL_LIST_INIT(human_recipes, list( \
	new/datum/stack_recipe("bloated human costume", /obj/item/clothing/suit/hooded/bloated_human, 5, crafting_flags = NONE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("human skin hat", /obj/item/clothing/head/fedora/human_leather, 1, crafting_flags = NONE, category = CAT_CLOTHING), \
	))

/obj/item/stack/sheet/animalhide/carbon/human/get_main_recipes()
	. = ..()
	. += GLOB.human_recipes

/obj/item/stack/sheet/animalhide/carbon/human/five
	amount = 5

/obj/item/stack/sheet/animalhide/generic
	name = "皮"
	desc = "一块皮。"
	singular_name = "skin piece"
	novariants = FALSE
	merge_type = /obj/item/stack/sheet/animalhide/generic

/obj/item/stack/sheet/animalhide/corgi
	name = "柯基皮"
	desc = "柯基养殖的副产品。"
	singular_name = "corgi hide piece"
	icon_state = "sheet-corgi"
	inhand_icon_state = null
	merge_type = /obj/item/stack/sheet/animalhide/corgi

/obj/item/stack/sheet/animalhide/corgi/five
	amount = 5

/obj/item/stack/sheet/animalhide/mothroach
	name = "蛾螂皮"
	desc = "一层薄薄的蛾螂皮。"
	singular_name = "mothroach hide piece"
	icon_state = "sheet-mothroach"
	inhand_icon_state = null
	merge_type = /obj/item/stack/sheet/animalhide/mothroach

/obj/item/stack/sheet/animalhide/mothroach/five
	amount = 5

GLOBAL_LIST_INIT(gondola_recipes, list ( \
	new/datum/stack_recipe("gondola mask", /obj/item/clothing/mask/gondola, 1, crafting_flags = NONE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("gondola suit", /obj/item/clothing/under/costume/gondola, 2, crafting_flags = NONE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("gondola bedsheet", /obj/item/bedsheet/gondola, 1, crafting_flags = NONE, category = CAT_FURNITURE), \
	))

/obj/item/stack/sheet/animalhide/gondola
	name = "冈多拉皮"
	desc = "冈多拉狩猎的极其珍贵的产物。"
	singular_name = "gondola hide piece"
	icon_state = "sheet-gondola"
	inhand_icon_state = null
	merge_type = /obj/item/stack/sheet/animalhide/gondola

/obj/item/stack/sheet/animalhide/gondola/get_main_recipes()
	. = ..()
	. += GLOB.gondola_recipes

GLOBAL_LIST_INIT(corgi_recipes, list ( \
	new/datum/stack_recipe("corgi costume", /obj/item/clothing/suit/hooded/ian_costume, 3, crafting_flags = NONE, category = CAT_CLOTHING), \
	))

/obj/item/stack/sheet/animalhide/corgi/get_main_recipes()
	. = ..()
	. += GLOB.corgi_recipes

/obj/item/stack/sheet/animalhide/cat
	name = "猫皮"
	desc = "猫咪养殖的副产品。"
	singular_name = "cat hide piece"
	icon_state = "sheet-cat"
	inhand_icon_state = null
	merge_type = /obj/item/stack/sheet/animalhide/cat

/obj/item/stack/sheet/animalhide/cat/five
	amount = 5

/obj/item/stack/sheet/animalhide/carbon/monkey
	name = "猴皮"
	desc = "猴子养殖的副产品。"
	singular_name = "monkey hide piece"
	icon_state = "sheet-monkey"
	inhand_icon_state = null
	merge_type = /obj/item/stack/sheet/animalhide/carbon/monkey

GLOBAL_LIST_INIT(monkey_recipes, list ( \
	new/datum/stack_recipe("monkey mask", /obj/item/clothing/mask/gas/monkeymask, 1, crafting_flags = NONE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("monkey suit", /obj/item/clothing/suit/costume/monkeysuit, 2, crafting_flags = NONE, category = CAT_CLOTHING), \
	))

/obj/item/stack/sheet/animalhide/carbon/monkey/get_main_recipes()
	. = ..()
	. += GLOB.monkey_recipes

/obj/item/stack/sheet/animalhide/carbon/monkey/five
	amount = 5

/obj/item/stack/sheet/animalhide/carbon/lizard
	name = "蜥蜴皮"
	desc = "嘶嘶嘶..."
	singular_name = "lizard skin piece"
	icon_state = "sheet-lizard"
	inhand_icon_state = null
	merge_type = /obj/item/stack/sheet/animalhide/carbon/lizard
	uses_skin_color = TRUE

/obj/item/stack/sheet/animalhide/carbon/lizard/get_random_skin_color()
	return sanitize_hexcolor("[pick("7F", "FF")][pick("7F", "FF")][pick("7F", "FF")]")

/obj/item/stack/sheet/animalhide/carbon/lizard/five
	amount = 5

/obj/item/stack/sheet/animalhide/xeno
	name = "异形甲壳"
	singular_name = "alien chitin piece"
	desc = "一种可怕生物的皮肤。"
	icon_state = "sheet-xeno"
	inhand_icon_state = null
	merge_type = /obj/item/stack/sheet/animalhide/xeno

GLOBAL_LIST_INIT(xeno_recipes, list ( \
	new/datum/stack_recipe("alien helmet", /obj/item/clothing/head/costume/xenos, 1, crafting_flags = NONE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("alien suit", /obj/item/clothing/suit/costume/xenos, 2, crafting_flags = NONE, category = CAT_CLOTHING), \
	))

/obj/item/stack/sheet/animalhide/xeno/get_main_recipes()
	. = ..()
	. += GLOB.xeno_recipes

/obj/item/stack/sheet/animalhide/xeno/five
	amount = 5

/obj/item/stack/sheet/animalhide/carp
	name = "鲤鱼鳞片"
	desc = "太空鲤鱼的鳞状皮肤。从曾经穿着它的丑陋生物身上剥离后，看起来相当美丽。"
	singular_name = "carp scale"
	icon_state = "sheet-carp"
	inhand_icon_state = null
	merge_type = /obj/item/stack/sheet/animalhide/carp

GLOBAL_LIST_INIT(carp_recipes, list ( \
	new/datum/stack_recipe("carp costume", /obj/item/clothing/suit/hooded/carp_costume, 4, crafting_flags = NONE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("carp mask", /obj/item/clothing/mask/gas/carp, 1, crafting_flags = NONE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("carpskin chair", /obj/structure/chair/comfy/carp, 2, crafting_flags = NONE, category = CAT_FURNITURE), \
	new/datum/stack_recipe("carpskin suit", /obj/item/clothing/under/suit/carpskin, 3, crafting_flags = NONE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("carpskin fedora", /obj/item/clothing/head/fedora/carpskin, 2, crafting_flags = NONE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("carpskin fishing bag", /obj/item/storage/bag/fishing/carpskin, 3, crafting_flags = NONE, category = CAT_CONTAINERS), \
	))

/obj/item/stack/sheet/animalhide/carp/get_main_recipes()
	. = ..()
	. += GLOB.carp_recipes

/obj/item/stack/sheet/animalhide/carp/five
	amount = 5

/obj/item/xenos_claw
	name = "异形爪"
	desc = "一只可怕生物的爪子。"
	icon = 'icons/mob/nonhuman-player/alien.dmi'
	icon_state = "claw"

/*
 * Leather SHeet
 */
/obj/item/stack/sheet/leather
	name = "皮革"
	desc = "生物研磨的副产品。"
	singular_name = "leather piece"
	icon_state = "sheet-leather"
	inhand_icon_state = null
	merge_type = /obj/item/stack/sheet/leather
	pickup_sound = 'sound/items/handling/materials/skin_pick_up.ogg'
	drop_sound = 'sound/items/handling/materials/skin_drop.ogg'

GLOBAL_LIST_INIT(leather_recipes, list ( \
	new/datum/stack_recipe("wallet", /obj/item/storage/wallet, 1, crafting_flags = NONE, category = CAT_CONTAINERS), \
	new/datum/stack_recipe("muzzle", /obj/item/clothing/mask/muzzle, 2, crafting_flags = NONE, category = CAT_ENTERTAINMENT), \
	new/datum/stack_recipe("basketball", /obj/item/toy/basketball, 20, crafting_flags = NONE, category = CAT_ENTERTAINMENT), \
	new/datum/stack_recipe("baseball", /obj/item/toy/beach_ball/baseball, 3, crafting_flags = NONE, category = CAT_ENTERTAINMENT), \
	new/datum/stack_recipe("saddle", /obj/item/goliath_saddle, 5, crafting_flags = NONE, category = CAT_EQUIPMENT), \
	new/datum/stack_recipe("leather shoes", /obj/item/clothing/shoes/laceup, 2, crafting_flags = NONE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("cowboy boots", /obj/item/clothing/shoes/cowboy, 2, crafting_flags = NONE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("botany gloves", /obj/item/clothing/gloves/botanic_leather, 3, crafting_flags = NONE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("leather satchel", /obj/item/storage/backpack/satchel/leather, 5, crafting_flags = NONE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("sheriff vest", /obj/item/clothing/accessory/vest_sheriff, 4, crafting_flags = NONE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("leather jacket", /obj/item/clothing/suit/jacket/leather, 7, crafting_flags = NONE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("biker jacket", /obj/item/clothing/suit/jacket/leather/biker, 7, crafting_flags = NONE, category = CAT_CLOTHING), \
	new/datum/stack_recipe_list("belts", list( \
		new/datum/stack_recipe("tool belt", /obj/item/storage/belt/utility, 4, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new/datum/stack_recipe("botanical belt", /obj/item/storage/belt/plant, 2, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new/datum/stack_recipe("janitorial belt", /obj/item/storage/belt/janitor, 2, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new/datum/stack_recipe("medical belt", /obj/item/storage/belt/medical, 2, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new/datum/stack_recipe("security belt", /obj/item/storage/belt/security, 2, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new/datum/stack_recipe("shoulder holster", /obj/item/storage/belt/holster, 3, crafting_flags = NONE, category = CAT_CONTAINERS), \
		new/datum/stack_recipe("bandolier", /obj/item/storage/belt/bandolier, 5, crafting_flags = NONE, category = CAT_CONTAINERS), \
	)),
	new/datum/stack_recipe_list("cowboy hats", list( \
		new/datum/stack_recipe("sheriff hat", /obj/item/clothing/head/cowboy/brown, 2, crafting_flags = NONE, category = CAT_CLOTHING), \
		new/datum/stack_recipe("desperado hat", /obj/item/clothing/head/cowboy/black, 2, crafting_flags = NONE, category = CAT_CLOTHING), \
		new/datum/stack_recipe("ten-gallon hat", /obj/item/clothing/head/cowboy/white, 2, crafting_flags = NONE, category = CAT_CLOTHING), \
		new/datum/stack_recipe("deputy hat", /obj/item/clothing/head/cowboy/red, 2, crafting_flags = NONE, category = CAT_CLOTHING), \
		new/datum/stack_recipe("drifter hat", /obj/item/clothing/head/cowboy/grey, 2, crafting_flags = NONE, category = CAT_CLOTHING), \
	)),
	new/datum/stack_recipe_list("sword sheaths", list( \
		new/datum/stack_recipe("katana sheath", /obj/item/storage/belt/sheath/katana/empty, 3, crafting_flags = NONE, category = CAT_CLOTHING), \
		new/datum/stack_recipe("hanzo katana sheath", /obj/item/storage/belt/sheath/hanzo_katana/empty, 3, crafting_flags = NONE, category = CAT_CLOTHING), \
		new/datum/stack_recipe("toy katana sheath", /obj/item/storage/belt/sheath/katana/toy/empty, 3, crafting_flags = NONE, category = CAT_CLOTHING), \
	)),
))

/obj/item/stack/sheet/leather/get_main_recipes()
	. = ..()
	. += GLOB.leather_recipes

/obj/item/stack/sheet/leather/five
	amount = 5

/*
 * Sinew
 */
/obj/item/stack/sheet/sinew
	name = "watcher sinew"
	icon = 'icons/obj/mining.dmi'
	desc = "长条状的细丝，可能来自观察者的翅膀。"
	singular_name = "观察者肌腱"
	icon_state = "sinew"
	novariants = TRUE
	merge_type = /obj/item/stack/sheet/sinew
	drop_sound = 'sound/effects/meatslap.ogg'
	pickup_sound = 'sound/effects/meatslap.ogg'
	resistance_flags = FIRE_PROOF | LAVA_PROOF

/obj/item/stack/sheet/sinew/Initialize(mapload, new_amount, merge, list/mat_override, mat_amt)
	. = ..()

	// As bone and sinew have just a little too many recipes for this, we'll just split them up.
	// Sinew slapcrafting will mostly-sinew recipes, and bones will have mostly-bones recipes.
	var/static/list/slapcraft_recipe_list = list(\
		/datum/crafting_recipe/goliathcloak, /datum/crafting_recipe/skilt, /datum/crafting_recipe/drakecloak,\
		)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/stack/sheet/sinew/wolf
	name = "wolf sinew"
	desc = "长条状的细丝，来自狼的体内。"
	singular_name = "狼肌腱"
	merge_type = /obj/item/stack/sheet/sinew/wolf

GLOBAL_LIST_INIT(sinew_recipes, list ( \
	new/datum/stack_recipe("sinew restraints", /obj/item/restraints/handcuffs/cable/sinew, 1, crafting_flags = NONE, category = CAT_EQUIPMENT), \
))

/obj/item/stack/sheet/sinew/get_main_recipes()
	. = ..()
	. += GLOB.sinew_recipes


/*Plates*/
/obj/item/stack/sheet/animalhide/goliath_hide
	name = "歌利亚兽皮板"
	desc = "歌利亚岩石外皮的碎片，或许能让你的防护服更能抵御当地野生动物的攻击。"
	icon = 'icons/obj/stack_objects.dmi'
	icon_state = "goliath_hide"
	singular_name = "hide plate"
	max_amount = 6
	novariants = FALSE
	item_flags = NOBLUDGEON
	resistance_flags = FIRE_PROOF | LAVA_PROOF
	w_class = WEIGHT_CLASS_NORMAL
	layer = MOB_LAYER
	merge_type = /obj/item/stack/sheet/animalhide/goliath_hide

/obj/item/stack/sheet/animalhide/goliath_hide/polar_bear_hide
	name = "北极熊皮"
	desc = "北极熊皮毛的碎片，或许能让你的防护服更能抵御当地野生动物的攻击。"
	icon_state = "polar_bear_hide"
	singular_name = "polar bear hide"
	merge_type = /obj/item/stack/sheet/animalhide/goliath_hide/polar_bear_hide

/obj/item/stack/sheet/animalhide/ashdrake
	name = "灰烬龙皮"
	desc = "灰烬龙强韧的鳞皮。"
	icon = 'icons/obj/stack_objects.dmi'
	icon_state = "dragon_hide"
	singular_name = "drake plate"
	max_amount = 10
	novariants = FALSE
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_NORMAL
	layer = MOB_LAYER
	merge_type = /obj/item/stack/sheet/animalhide/ashdrake

/obj/item/stack/sheet/animalhide/ashdrake/Initialize(mapload, new_amount, merge, list/mat_override, mat_amt)
	. = ..()

	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/drakecloak)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/stack/sheet/animalhide/bear
	name = "熊皮"
	desc = "熊的毛茸茸的毛皮。想象一下，用这东西做成大衣裹在身上该有多暖和。"
	icon_state = "bear_hide" //change
	singular_name = "bear pelt"
	merge_type = /obj/item/stack/sheet/animalhide/bear
	novariants = FALSE

GLOBAL_LIST_INIT(bear_pelt_recipes, list ( \
	new/datum/stack_recipe("bear costume", /obj/item/clothing/suit/costume/bear_suit, 5, crafting_flags = NONE, category = CAT_CLOTHING), \
	new/datum/stack_recipe("bear hat", /obj/item/clothing/head/costume/bearpelt, 2, crafting_flags = NONE, category = CAT_CLOTHING), \
))

/obj/item/stack/sheet/animalhide/bear/get_main_recipes()
	. = ..()
	. += GLOB.bear_pelt_recipes

//Step one - dehairing.

/obj/item/stack/sheet/animalhide/attackby(obj/item/W, mob/user, list/modifiers, list/attack_modifiers)
	if(W.get_sharpness())
		playsound(loc, 'sound/items/weapons/slice.ogg', 50, TRUE, -1)
		user.visible_message(span_notice("[user] 开始从\the [src]上割下毛发。"), span_notice("你开始从\the [src]上割下毛发..."), span_hear("你听到刀子摩擦皮肉的声音。"))
		if(do_after(user, 5 SECONDS, target = src))
			to_chat(user, span_notice("你从[src.name]上剪下了毛发。"))
			new /obj/item/stack/sheet/hairlesshide(user.drop_location(), amount)
			use(amount)
	else
		return ..()

/obj/item/stack/sheet/animalhide/examine(mob/user)
	. = ..()
	. += span_notice("你可以用任何锋利的物体去除毛发。")

//Step two - washing..... it's actually in washing machine code.

/obj/item/stack/sheet/hairlesshide
	name = "无毛兽皮"
	desc = "这张兽皮的毛发已被去除，但仍需清洗和鞣制。"
	singular_name = "hairless hide piece"
	icon_state = "sheet-hairlesshide"
	inhand_icon_state = null
	merge_type = /obj/item/stack/sheet/hairlesshide
	pickup_sound = 'sound/items/handling/materials/skin_pick_up.ogg'
	drop_sound = 'sound/items/handling/materials/skin_drop.ogg'

/obj/item/stack/sheet/hairlesshide/examine(mob/user)
	. = ..()
	. += span_notice("你可以用水清洗它。")

//Step three - drying
/obj/item/stack/sheet/wethide
	name = "湿兽皮"
	desc = "这张兽皮已经清洗过，但仍需晾干。"
	singular_name = "wet hide piece"
	icon_state = "sheet-wetleather"
	inhand_icon_state = null
	merge_type = /obj/item/stack/sheet/wethide
	pickup_sound = 'sound/items/handling/materials/skin_pick_up.ogg'
	drop_sound = 'sound/items/handling/materials/skin_drop.ogg'
	/// Reduced when exposed to high temperatures
	var/wetness = 30
	/// Kelvin to start drying
	var/drying_threshold_temperature = 500

/obj/item/stack/sheet/wethide/examine(mob/user)
	. = ..()
	. += span_notice("你可以把它晾干来制作皮革。")

/obj/item/stack/sheet/wethide/Initialize(mapload, new_amount, merge = TRUE, list/mat_override=null, mat_amt=1)
	. = ..()
	AddElement(/datum/element/atmos_sensitive, mapload)
	AddElement(/datum/element/dryable, /obj/item/stack/sheet/leather)
	AddElement(/datum/element/microwavable, /obj/item/stack/sheet/leather)
	AddComponent(/datum/component/grillable, /obj/item/stack/sheet/leather, rand(1 SECONDS, 3 SECONDS), TRUE)
	AddComponent(/datum/component/bakeable, /obj/item/stack/sheet/leather, rand(15 SECONDS, 20 SECONDS), TRUE, TRUE)

/obj/item/stack/sheet/wethide/burn()
	visible_message(span_notice("[src]变干了！"))
	new /obj/item/stack/sheet/leather(loc, amount) // all the sheets to incentivize not losing your whole stack by accident
	qdel(src)

/obj/item/stack/sheet/wethide/should_atmos_process(datum/gas_mixture/air, exposed_temperature)
	return (exposed_temperature > drying_threshold_temperature)

/obj/item/stack/sheet/wethide/atmos_expose(datum/gas_mixture/air, exposed_temperature)
	wetness--
	if(wetness == 0)
		new /obj/item/stack/sheet/leather(drop_location(), amount)
		wetness = initial(wetness)
		use(1)
