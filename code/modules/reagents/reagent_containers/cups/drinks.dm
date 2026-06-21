////////////////////////////////////////////////////////////////////////////////
/// Drinks.
////////////////////////////////////////////////////////////////////////////////
/obj/item/reagent_containers/cup/glass
	name = "饮品"
	desc = "味道好极了"
	icon = 'icons/obj/drinks/drinks.dmi'
	icon_state = "glass_empty"
	abstract_type = /obj/item/reagent_containers/cup/glass
	possible_transfer_amounts = list(5,10,15,20,25,30,50)
	resistance_flags = NONE

	isGlass = TRUE
	attack_verb_continuous = list("smashes", "bashes")
	attack_verb_simple = list("smash", "bash")

/obj/item/reagent_containers/cup/glass/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum, do_splash = TRUE)
	. = ..()
	if(!.) //if the bottle wasn't caught
		var/mob/thrower = throwingdatum?.get_thrower()
		if(!istype(thrower))
			return
		smash(hit_atom, thrower, throwingdatum)

/obj/item/reagent_containers/cup/glass/proc/smash(atom/target, mob/thrower, datum/thrownthing/throwingdatum, break_top = FALSE)
	if(!isGlass)
		return
	if(QDELING(src) || !target) //Invalid loc
		return
	if(bartender_check(target, thrower) && throwingdatum)
		return
	splash_reagents(QDELETED(target) ? target.drop_location() : target, thrower || throwingdatum?.get_thrower(), allow_closed_splash = TRUE)
	var/obj/item/broken_bottle/B = new (loc)
	B.mimic_broken(src, target, break_top)
	qdel(src)

/obj/item/reagent_containers/cup/glass/bullet_act(obj/projectile/proj)
	. = ..()
	if(QDELETED(src))
		return
	if(proj.damage > 0 && proj.damage_type == BRUTE)
		var/atom/T = get_turf(src)
		smash(T)


/obj/item/reagent_containers/cup/glass/trophy
	name = "锡杯"
	desc = "每个人都会得到一个奖杯。"
	icon = 'icons/obj/drinks/bottles.dmi'
	icon_state = "pewter_cup"
	w_class = WEIGHT_CLASS_TINY
	force = 1
	throwforce = 1
	amount_per_transfer_from_this = 5
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT)
	has_variable_transfer_amount = FALSE
	volume = 5
	obj_flags = CONDUCTS_ELECTRICITY
	resistance_flags = FIRE_PROOF
	isGlass = FALSE

/obj/item/reagent_containers/cup/glass/trophy/gold_cup
	name = "金杯"
	desc = "你是真正的赢家！"
	icon = 'icons/obj/drinks/bottles.dmi'
	icon_state = "golden_cup"
	inhand_icon_state = "golden_cup"
	w_class = WEIGHT_CLASS_BULKY
	force = 14
	throwforce = 10
	amount_per_transfer_from_this = 20
	custom_materials = list(/datum/material/gold=HALF_SHEET_MATERIAL_AMOUNT)
	volume = 150

/obj/item/reagent_containers/cup/glass/trophy/gold_cup/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/cuffable_item) //closed handles

/obj/item/reagent_containers/cup/glass/trophy/silver_cup
	name = "银杯"
	desc = "最成功的输家！"
	icon = 'icons/obj/drinks/bottles.dmi'
	icon_state = "silver_cup"
	w_class = WEIGHT_CLASS_NORMAL
	force = 10
	throwforce = 8
	amount_per_transfer_from_this = 15
	custom_materials = list(/datum/material/silver=SMALL_MATERIAL_AMOUNT*8)
	volume = 100

/obj/item/reagent_containers/cup/glass/trophy/silver_cup/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/cuffable_item) //closed handle

/obj/item/reagent_containers/cup/glass/trophy/bronze_cup
	name = "铜杯"
	desc = "至少你得了个奖."
	icon = 'icons/obj/drinks/bottles.dmi'
	icon_state = "bronze_cup"
	w_class = WEIGHT_CLASS_SMALL
	force = 5
	throwforce = 4
	amount_per_transfer_from_this = 10
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT * 4)
	volume = 25

///////////////////////////////////////////////Drinks
//Notes by Darem: Drinks are simply containers that start preloaded. Unlike condiments, the contents can be ingested directly
// rather then having to add it to something else first. They should only contain liquids. They have a default container size of 50.
// Formatting is the same as food.

/obj/item/reagent_containers/cup/glass/coffee
	name = "强健咖啡"
	desc = "小心，你想品尝的这款饮料非常烫。"
	icon = 'icons/obj/drinks/coffee.dmi'
	icon_state = "coffee"
	base_icon_state = "coffee"
	list_reagents = list(/datum/reagent/consumable/coffee = 30)
	resistance_flags = FREEZE_PROOF
	isGlass = FALSE
	drink_type = BREAKFAST

	/// Is our lid currently removed?
	var/lid_open = FALSE

/obj/item/reagent_containers/cup/glass/coffee/no_lid
	icon_state = "coffee_empty"
	list_reagents = null
	lid_open = TRUE

/obj/item/reagent_containers/cup/glass/coffee/Initialize(mapload)
	. = ..()
	register_context()

/obj/item/reagent_containers/cup/glass/coffee/examine(mob/user)
	. = ..()
	. += span_notice("Alt-点击以切换杯盖。")
	return

/obj/item/reagent_containers/cup/glass/coffee/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	. = ..()
	context[SCREENTIP_CONTEXT_ALT_LMB] = "[lid_open ? "Add" : "Remove"] Lid"
	return CONTEXTUAL_SCREENTIP_SET

/obj/item/reagent_containers/cup/glass/coffee/click_alt(mob/user)
	lid_open = !lid_open
	update_icon_state()
	return CLICK_ACTION_SUCCESS

/obj/item/reagent_containers/cup/glass/coffee/update_icon_state()
	if(lid_open)
		icon_state = reagents.total_volume ? "[base_icon_state]_full" : "[base_icon_state]_empty"
	else
		icon_state = base_icon_state
	return ..()

/obj/item/reagent_containers/cup/glass/ice
	name = "冰杯"
	desc = "当心，低温寒冰，请勿咬食。"
	custom_price = PAYCHECK_LOWER * 0.6
	icon_state = "icecup"
	list_reagents = list(/datum/reagent/consumable/ice = 30)
	isGlass = FALSE

/obj/item/reagent_containers/cup/glass/ice/prison
	name = "有污垢的冰杯"
	desc = "要么是纳米传讯的供水受到了污染，要么这台机器实际上出售的是柠檬、巧克力和樱桃口味的雪糕。"
	list_reagents = list(/datum/reagent/consumable/ice = 25, /datum/reagent/consumable/liquidgibs = 5)

/obj/item/reagent_containers/cup/glass/mug // parent type is literally just so empty mug sprites are a thing
	name = "马克杯"
	desc = "精致的马克杯中装有某种饮品。"
	icon = 'icons/obj/drinks/coffee.dmi'
	icon_state = "tea_empty"
	base_icon_state = "tea"
	inhand_icon_state = "coffee"

/obj/item/reagent_containers/cup/glass/mug/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/cuffable_item)

/obj/item/reagent_containers/cup/glass/mug/update_icon_state()
	icon_state = "[base_icon_state][reagents.total_volume ? null : "_empty"]"
	return ..()

/obj/item/reagent_containers/cup/glass/mug/tea
	name = "紫丁香茶"
	desc = "侮辱紫丁香茶就是侮辱太空女王！如果你弄脏了这杯茶的话，任何有教养的绅士都会跟你拼命的。"
	icon_state = "tea"
	list_reagents = list(/datum/reagent/consumable/tea = 30)

/obj/item/reagent_containers/cup/glass/mug/coco
	name = "荷兰热可可"
	desc = "产自太空南美洲。"
	icon_state = "tea"
	list_reagents = list(/datum/reagent/consumable/hot_coco = 15, /datum/reagent/consumable/sugar = 5)
	drink_type = SUGAR
	resistance_flags = FREEZE_PROOF
	custom_price = PAYCHECK_CREW * 1.2

/obj/item/reagent_containers/cup/glass/mug/nanotrasen
	name = "\improper 纳米传讯马克杯"
	desc = "展示公司自豪感的马克杯。"
	icon_state = "mug_nt_empty"
	base_icon_state = "mug_nt"

/obj/item/reagent_containers/cup/glass/coffee_cup
	name = "咖啡杯"
	desc = "一个热成型的塑料咖啡杯。如果你敢尝试，理论上也可以用来装其他热饮。"
	icon = 'icons/obj/drinks/coffee.dmi'
	icon_state = "coffee_cup_e"
	base_icon_state = "coffee_cup"
	possible_transfer_amounts = list(10)
	volume = 30
	isGlass = FALSE

/obj/item/reagent_containers/cup/glass/coffee_cup/update_icon_state()
	icon_state = reagents.total_volume ? base_icon_state : "[base_icon_state]_e"
	return ..()

/obj/item/reagent_containers/cup/glass/dry_ramen
	name = "杯面"
	desc = "只需加入5毫升水，它就可以自己发热了！这味道会让你回想起自己的学生时代。现在，咸盐口味新品上市！"
	icon_state = "ramen"
	list_reagents = list(/datum/reagent/consumable/dry_ramen = 15, /datum/reagent/consumable/salt = 3)
	drink_type = GRAIN
	isGlass = FALSE
	custom_price = PAYCHECK_CREW * 0.9

/obj/item/reagent_containers/cup/glass/waterbottle
	name = "瓶装水"
	desc = "一瓶在地球旧瓶装厂灌注的水。"
	icon = 'icons/obj/drinks/bottles.dmi'
	icon_state = "smallbottle"
	inhand_icon_state = null
	list_reagents = list(/datum/reagent/water = 49.5, /datum/reagent/fluorine = 0.5)//see desc, don't think about it too hard
	custom_materials = list(/datum/material/plastic = SHEET_MATERIAL_AMOUNT)
	volume = 50
	amount_per_transfer_from_this = 10
	fill_icon_thresholds = list(0, 10, 25, 50, 75, 80, 90)
	isGlass = FALSE
	// The 2 bottles have separate cap overlay icons because if the bottle falls over while bottle flipping the cap stays fucked on the moved overlay
	var/cap_icon = 'icons/obj/drinks/drink_effects.dmi'
	var/cap_icon_state = "bottle_cap_small"
	var/start_capped = TRUE
	var/cap_lost = FALSE
	var/mutable_appearance/cap_overlay
	var/flip_chance = 10
	custom_price = PAYCHECK_LOWER * 0.8
	reagent_container_liquid_sound = SFX_PLASTIC_BOTTLE_LIQUID_SLOSH

/obj/item/reagent_containers/cup/glass/waterbottle/Initialize(mapload)
	cap_overlay = mutable_appearance(cap_icon, cap_icon_state)
	. = ..()
	if(start_capped)
		// this is not done via initial_reagent_flags because it represents state
		update_container_flags(SEALED_CONTAINER | TRANSPARENT)
		update_appearance()

/obj/item/reagent_containers/cup/glass/waterbottle/update_overlays()
	. = ..()
	if(!is_open_container())
		. += cap_overlay

/obj/item/reagent_containers/cup/glass/waterbottle/examine(mob/user)
	. = ..()
	if(cap_lost)
		. += span_notice("瓶盖似乎不见了。")
	else if(!is_open_container())
		. += span_notice("瓶盖已拧紧以防泼洒。Alt-点击以取下瓶盖。")
	else
		. += span_notice("瓶盖已被取下。Alt-点击以盖上瓶盖。")

/obj/item/reagent_containers/cup/glass/waterbottle/click_alt(mob/user)
	if(cap_lost)
		to_chat(user, span_warning("瓶盖似乎不见了！它去哪了？"))
		return CLICK_ACTION_BLOCKING

	var/fumbled = HAS_TRAIT(user, TRAIT_CLUMSY) && prob(5)
	if(!is_open_container() || fumbled)
		reset_container_flags()
		animate(src, transform = null, time = 2, loop = 0)
		if(fumbled)
			to_chat(user, span_warning("你笨手笨脚地摆弄着[src]的瓶盖！瓶盖掉在地上，就这么消失了。它到底去哪了？"))
			cap_lost = TRUE
		else
			to_chat(user, span_notice("你取下了[src]的瓶盖。"))
			playsound(loc, 'sound/items/handling/reagent_containers/plastic_bottle/bottle_cap_open.ogg', 50, TRUE)
	else
		update_container_flags(SEALED_CONTAINER | TRANSPARENT)
		to_chat(user, span_notice("你给[src]盖上了瓶盖。"))
		playsound(loc, 'sound/items/handling/reagent_containers/plastic_bottle/bottle_cap_close.ogg', 50, TRUE)
	update_appearance()
	return CLICK_ACTION_SUCCESS

// heehoo bottle flipping
/obj/item/reagent_containers/cup/glass/waterbottle/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(QDELETED(src))
		return
	if(is_open_container() || !reagents.total_volume)
		return
	if(prob(flip_chance)) // landed upright
		src.visible_message(span_notice("[src]稳稳地立住了！"))
		var/mob/living/thrower = throwingdatum?.get_thrower()
		if(istype(thrower))
			thrower.add_mood_event("bottle_flip", /datum/mood_event/bottle_flip)
	else // landed on its side
		animate(src, transform = matrix(prob(50)? 90 : -90, MATRIX_ROTATE), time = 3, loop = 0)

/obj/item/reagent_containers/cup/glass/waterbottle/pickup(mob/user)
	. = ..()
	animate(src, transform = null, time = 1, loop = 0)

/obj/item/reagent_containers/cup/glass/waterbottle/empty
	list_reagents = list()
	start_capped = FALSE

/obj/item/reagent_containers/cup/glass/waterbottle/large
	desc = "一瓶全新的标准规格的矿泉水。"
	icon_state = "largebottle"
	custom_materials = list(/datum/material/plastic = SHEET_MATERIAL_AMOUNT * 3)
	list_reagents = list(/datum/reagent/water = 100)
	volume = 100
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,20,25,30,50,100)
	cap_icon_state = "bottle_cap"

/obj/item/reagent_containers/cup/glass/waterbottle/large/empty
	list_reagents = list()
	start_capped = FALSE

// Admin spawn
/obj/item/reagent_containers/cup/glass/waterbottle/relic
	name = "奇怪的瓶子"
	desc = "一个形状与水瓶颇为相似的瓶子，只是上面用记号笔潦草地写着一些字。它似乎正散发着某种能量。"
	flip_chance = 100 // FLIPP

/obj/item/reagent_containers/cup/glass/waterbottle/relic/Initialize(mapload)
	var/reagent_id = get_random_reagent_id()
	var/datum/reagent/random_reagent = new reagent_id
	list_reagents = list(random_reagent.type = 50)
	. = ..()
	desc += span_notice("The writing reads '[random_reagent.name]'.")
	update_appearance()


/obj/item/reagent_containers/cup/glass/sillycup
	name = "纸杯"
	desc = "一个纸质水杯。"
	icon_state = "water_cup_e"
	possible_transfer_amounts = list(10)
	volume = 10
	isGlass = FALSE
	custom_materials = list(/datum/material/paper = HALF_SHEET_MATERIAL_AMOUNT)

/obj/item/reagent_containers/cup/glass/sillycup/update_icon_state()
	icon_state = reagents.total_volume ? "water_cup" : "water_cup_e"
	return ..()

/obj/item/reagent_containers/cup/glass/bottle/juice/smallcarton
	name = "small carton"
	desc = "A small carton, intended for holding drinks."
	icon = 'icons/obj/drinks/boxes.dmi'
	icon_state = "juicebox"
	volume = 15
	drink_type = NONE
	custom_materials = list(/datum/material/cardboard = SHEET_MATERIAL_AMOUNT)

/obj/item/reagent_containers/cup/glass/bottle/juice/smallcarton/Initialize(mapload, vol)
	. = ..()
	AddComponent( \
		/datum/component/takes_reagent_appearance, \
		on_icon_changed = CALLBACK(src, PROC_REF(on_cup_change)), \
		on_icon_reset = CALLBACK(src, PROC_REF(on_cup_reset)), \
		base_container_type = /obj/item/reagent_containers/cup/glass/bottle/juice/smallcarton, \
	)

/obj/item/reagent_containers/cup/glass/bottle/juice/smallcarton/smash(atom/target, mob/thrower, datum/thrownthing/throwingdatum, break_top)
	if(bartender_check(target, thrower) && throwingdatum)
		return
	splash_reagents(QDELETED(target) ? target.drop_location() : target, thrower || throwingdatum?.get_thrower(), allow_closed_splash = TRUE)
	var/obj/item/broken_bottle/bottle_shard = new(drop_location())
	bottle_shard.mimic_broken(src, target)
	qdel(src)

/obj/item/reagent_containers/cup/glass/colocup
	name = "彩色杯"
	desc = "一种廉价、批量生产的杯子，通常在派对上使用。不知为何，它们似乎从来不会是红色的……"
	icon = 'icons/obj/drinks/colo.dmi'
	icon_state = "colocup"
	inhand_icon_state = "colocup"
	custom_materials = list(/datum/material/plastic = HALF_SHEET_MATERIAL_AMOUNT)
	possible_transfer_amounts = list(5, 10, 15, 20)
	volume = 20
	amount_per_transfer_from_this = 5
	isGlass = FALSE
	/// Allows the lean sprite to display upon crafting
	var/random_sprite = TRUE

/obj/item/reagent_containers/cup/glass/colocup/Initialize(mapload)
	. = ..()
	pixel_x = rand(-4,4)
	pixel_y = rand(-4,4)
	if(!random_sprite)
		return
	icon_state = "colocup[rand(0, 6)]"
	if(icon_state == "colocup6")
		desc = "一种廉价、批量生产的杯子，通常在派对上使用。哇，这个居然是红色的！搞什么鬼？"

/obj/item/reagent_containers/cup/glass/colocup/lean
	name = "紫水"
	desc = "一杯那种紫色的饮料，喝了会让你变得“气喘吁吁，宝贝”。"
	icon_state = "lean"
	list_reagents = list(/datum/reagent/consumable/lean = 20)
	random_sprite = FALSE

//////////////////////////drinkingglass and shaker//
//Note by Darem: This code handles the mixing of drinks. New drinks go in three places: In Chemistry-Reagents.dm (for the drink
// itself), in Chemistry-Recipes.dm (for the reaction that changes the components into the drink), and here (for the drinking glass
// icon states.


/obj/item/reagent_containers/cup/glass/shaker
	name = "摇壶"
	desc = "用于混合饮品的金属摇壶。"
	icon = 'icons/obj/drinks/bottles.dmi'
	icon_state = "shaker"
	custom_materials = list(/datum/material/iron= HALF_SHEET_MATERIAL_AMOUNT * 1.5)
	amount_per_transfer_from_this = 10
	volume = 100
	isGlass = FALSE
	interaction_flags_click = NEED_HANDS|FORBID_TELEKINESIS_REACH
	/// Whether or not poured drinks should use custom names and descriptions
	var/using_custom_drinks = FALSE
	/// Name custom drinks will have
	var/custom_drink_name = "Custom drink"
	/// Description custom drinks will have
	var/custom_drink_desc = "Mixed by your favourite bartender!"

/obj/item/reagent_containers/cup/glass/shaker/Initialize(mapload)
	. = ..()
	register_context()
	if(prob(10))
		name = "\improper 纳米传讯20周年纪念款摇壶"
		desc += " It has an emblazoned Nanotrasen logo on it."
		icon_state = "shaker_n"

/obj/item/reagent_containers/cup/glass/shaker/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()
	context[SCREENTIP_CONTEXT_ALT_LMB] = "[using_custom_drinks ? "Disable" : "Enable"] custom drinks"
	return CONTEXTUAL_SCREENTIP_SET

/obj/item/reagent_containers/cup/glass/shaker/examine(mob/user)
	. = ..()
	. += span_notice("Alt-点击以[using_custom_drinks ? "disable" : "enable"]自定义饮品命名")
	if(using_custom_drinks)
		. += span_notice("从此摇酒器倒出的饮品将使用以下名称：[custom_drink_name]")
		. += span_notice("从该调酒器中倒出的饮品将具有以下描述：[custom_drink_desc]")

/obj/item/reagent_containers/cup/glass/shaker/click_alt(mob/user)
	if(using_custom_drinks)
		using_custom_drinks = FALSE
		disable_custom_drinks()
		balloon_alert(user, "自定义饮品已禁用")
		return CLICK_ACTION_BLOCKING

	var/new_name = reject_bad_text(tgui_input_text(user, "饮品名称", "设置饮品名称", custom_drink_name, 45, FALSE), 64)
	if(!new_name)
		balloon_alert(user, "无效的饮品名称！")
		using_custom_drinks = FALSE
		return CLICK_ACTION_BLOCKING

	if(!user.can_perform_action(src, NEED_HANDS|FORBID_TELEKINESIS_REACH))
		return CLICK_ACTION_BLOCKING

	var/new_desc = reject_bad_text(tgui_input_text(user, "饮品描述", "设置饮品描述", custom_drink_desc, 64, TRUE), 128)
	if(!new_desc)
		balloon_alert(user, "无效的饮品描述！")
		using_custom_drinks = FALSE
		return CLICK_ACTION_BLOCKING

	if(!user.can_perform_action(src, NEED_HANDS|FORBID_TELEKINESIS_REACH))
		return CLICK_ACTION_BLOCKING

	using_custom_drinks = TRUE
	custom_drink_name = new_name
	custom_drink_desc = new_desc

	enable_custom_drinks()
	balloon_alert(user, "现在正在倒出自定义饮品")
	return CLICK_ACTION_SUCCESS

/obj/item/reagent_containers/cup/glass/shaker/proc/enable_custom_drinks()
	RegisterSignal(src, COMSIG_REAGENTS_CUP_TRANSFER_TO, PROC_REF(handle_transfer))

/obj/item/reagent_containers/cup/glass/shaker/proc/disable_custom_drinks()
	UnregisterSignal(src, COMSIG_REAGENTS_CUP_TRANSFER_TO)

/obj/item/reagent_containers/cup/glass/shaker/proc/handle_transfer(atom/origin, atom/target)
	SIGNAL_HANDLER
	// Should only work on drinking/shot glasses
	if(!istype(target, /obj/item/reagent_containers/cup/glass/drinkingglass))
		return

	var/obj/item/reagent_containers/cup/glass/drinkingglass/target_glass = target
	target_glass.name = custom_drink_name
	target_glass.desc = custom_drink_desc
	ADD_TRAIT(target_glass, TRAIT_WAS_RENAMED, SHAKER_LABEL_TRAIT)

/obj/item/reagent_containers/cup/glass/flask
	name = "酒壶"
	desc = "每个优秀的宇航员都知道，无论去哪儿都带上点威士忌是个不错的主意。"
	custom_price = PAYCHECK_COMMAND * 2
	icon = 'icons/obj/drinks/bottles.dmi'
	icon_state = "flask"
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*2.5)
	volume = 60
	isGlass = FALSE

/obj/item/reagent_containers/cup/glass/flask/gold
	name = "舰长的酒壶"
	desc = "归舰长所有的金酒壶。"
	icon_state = "flask_gold"
	custom_materials = list(/datum/material/gold=SMALL_MATERIAL_AMOUNT*5)

/obj/item/reagent_containers/cup/glass/flask/det
	name = "侦探的酒壶"
	desc = "侦探最好的朋友。"
	icon_state = "detflask"
	list_reagents = list(/datum/reagent/consumable/ethanol/whiskey = 30)

/obj/item/reagent_containers/cup/glass/flask/det/minor
	list_reagents = list(/datum/reagent/consumable/applejuice = 30)

/obj/item/reagent_containers/cup/glass/mug/britcup
	name = "杯子"
	desc = "一个印有红色五角星的杯子。"
	icon = 'icons/obj/drinks/coffee.dmi'
	icon_state = "britcup_empty"
	base_icon_state = "britcup"
	volume = 30
