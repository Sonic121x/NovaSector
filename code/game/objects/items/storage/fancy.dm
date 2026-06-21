/*
 * The 'fancy' path is for objects like donut boxes that show how many items are in the storage item on the sprite itself
 * .. Sorry for the shitty path name, I couldnt think of a better one.
 *
 * Contains:
 * Donut Box
 * Egg Box
 * Candle Box
 * Cigarette Box
 * Rolling Paper Pack
 * Cigar Case
 * Heart Shaped Box w/ Chocolates
 * Coffee condiments display
 */

/obj/item/storage/fancy
	icon = 'icons/obj/food/containers.dmi'
	abstract_type = /obj/item/storage/fancy
	resistance_flags = FLAMMABLE
	custom_materials = list(/datum/material/cardboard = SHEET_MATERIAL_AMOUNT)
	/// Used by examine to report what this thing is holding.
	var/contents_tag = "errors"
	/// What type of thing to fill this storage with.
	var/spawn_type
	/// How many of the things to fill this storage with.
	var/spawn_count = 0
	/// Whether the container is open, always open, or closed
	var/open_status = FANCY_CONTAINER_CLOSED
	/// What material do we get when we fold this box?
	var/foldable_result = /obj/item/stack/sheet/cardboard
	/// Whether it supports open and closed state icons.
	var/has_open_closed_states = TRUE

/obj/item/storage/fancy/PopulateContents()
	if(!spawn_type)
		return
	for(var/i = 1 to spawn_count)
		var/thing_in_box = pick(spawn_type)
		new thing_in_box(src)

/obj/item/storage/fancy/update_icon_state()
	icon_state = "[base_icon_state][has_open_closed_states && open_status ? contents.len : null]"
	return ..()

/obj/item/storage/fancy/examine(mob/user)
	. = ..()
	if(!open_status)
		return
	if(length(contents) == 1)
		. += "There is one [contents_tag] left."
	else
		. += "There are [contents.len <= 0 ? "no" : "[contents.len]"] [contents_tag]s left."

/obj/item/storage/fancy/attack_self(mob/user)
	if(open_status == FANCY_CONTAINER_CLOSED)
		open_status = FANCY_CONTAINER_OPEN
	else if(open_status == FANCY_CONTAINER_OPEN)
		open_status = FANCY_CONTAINER_CLOSED

	update_appearance()
	. = ..()
	if(contents.len)
		return
	if(!foldable_result || (flags_1 & HOLOGRAM_1))
		return
	var/obj/item/result = new foldable_result(user.drop_location())
	balloon_alert(user, "已折叠")
	// Gotta delete first, so then the cardboard appears in the same hand
	qdel(src)
	user.put_in_hands(result)

/obj/item/storage/fancy/Exited(atom/movable/gone, direction)
	. = ..()
	if(open_status == FANCY_CONTAINER_CLOSED)
		open_status = FANCY_CONTAINER_OPEN
	update_appearance()

/obj/item/storage/fancy/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()
	if(open_status == FANCY_CONTAINER_CLOSED)
		open_status = FANCY_CONTAINER_OPEN
	update_appearance()

#define DONUT_INBOX_SPRITE_WIDTH 4

/*
 * Donut Box
 */

/obj/item/storage/fancy/donut_box
	name = "甜甜圈盒"
	desc = "嗯。甜甜圈。"
	icon = 'icons/obj/food/donuts.dmi'
	icon_state = "donutbox_open" //composite image used for mapping
	base_icon_state = "donutbox"
	spawn_type = /obj/item/food/donut/plain
	spawn_count = 6
	open_status = TRUE
	appearance_flags = KEEP_TOGETHER|LONG_GLIDE
	custom_premium_price = PAYCHECK_COMMAND * 1.75
	contents_tag = "donut"
	storage_type = /datum/storage/donut_box

/obj/item/storage/fancy/donut_box/PopulateContents()
	. = ..()
	update_appearance()

/obj/item/storage/fancy/donut_box/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state][open_status ? "_inner" : null]"

/obj/item/storage/fancy/donut_box/update_overlays()
	. = ..()
	if(!open_status)
		return

	var/donuts = 0
	for(var/_donut in contents)
		var/obj/item/food/donut/donut = _donut
		if (!istype(donut))
			continue

		var/image/donut_image = image(icon = initial(icon), icon_state = donut.in_box_sprite())
		donut_image.pixel_w = donuts * DONUT_INBOX_SPRITE_WIDTH
		. += donut_image
		donuts += 1

	. += image(icon = initial(icon), icon_state = "[base_icon_state]_top")

#undef DONUT_INBOX_SPRITE_WIDTH

/*
 * Egg Box
 */

/obj/item/storage/fancy/egg_box
	icon = 'icons/obj/food/containers.dmi'
	inhand_icon_state = "eggbox"
	icon_state = "eggbox"
	base_icon_state = "eggbox"
	lefthand_file = 'icons/mob/inhands/items/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/food_righthand.dmi'
	name = "鸡蛋盒"
	desc = "一个用来装鸡蛋的纸盒。"
	spawn_type = /obj/item/food/egg
	spawn_count = 12
	contents_tag = "egg"
	storage_type = /datum/storage/egg_box

/*
 * Fertile Egg Box
 */

/obj/item/storage/fancy/egg_box/fertile
	name = "受精鸡蛋盒"
	desc = "这里只有一样东西是能生育的，而且不是鸡蛋。"
	spawn_type = /obj/item/food/egg/fertile
	spawn_count = 6

/*
 * Candle Box
 */

/obj/item/storage/fancy/candle_box
	name = "蜡烛包"
	desc = "一包红色蜡烛。"
	icon = 'icons/obj/candle.dmi'
	icon_state = "candlebox5"
	base_icon_state = "candlebox"
	inhand_icon_state = null
	worn_icon_state = "cigpack"
	throwforce = 2
	slot_flags = ITEM_SLOT_BELT
	spawn_type = /obj/item/flashlight/flare/candle
	spawn_count = 5
	open_status = FANCY_CONTAINER_ALWAYS_OPEN
	contents_tag = "candle"
	storage_type = /datum/storage/candle_box

////////////
//CIG PACK//
////////////
/obj/item/storage/fancy/cigarettes
	name = "\improper 太空牌香烟包"
	desc = "最受欢迎的香烟品牌，太空奥运会的赞助商。包装背面宣传自己是唯一能在太空真空中吸食的品牌。"
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cig"
	inhand_icon_state = "cigpacket"
	worn_icon_state = "cigpack"
	base_icon_state = "cig"
	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
	slot_flags = ITEM_SLOT_BELT
	spawn_type = /obj/item/cigarette/space_cigarette
	spawn_count = 6
	custom_price = PAYCHECK_CREW
	age_restricted = TRUE
	contents_tag = "cigarette"
	storage_type = /datum/storage/cigarette_box
	drop_sound = SFX_CIG_PACK_DROP
	pickup_sound = SFX_CIG_PACK_PICKUP
	throw_drop_sound = SFX_CIG_PACK_THROW_DROP
	sound_vary = TRUE

	///for cigarette overlay
	var/candy = FALSE
	/// Does this cigarette packet come with a coupon attached?
	var/spawn_coupon = TRUE
	/// For VV'ing, set this to true if you want to force the coupon to give an omen
	var/rigged_omen = FALSE
	///Do we not have our own handling for cig overlays?
	var/display_cigs = TRUE

/obj/item/storage/fancy/cigarettes/attack_self(mob/user)
	if(contents.len != 0 || !spawn_coupon)
		return ..()

	playsound(src, storage_type.rustle_sound, 50, TRUE)

	balloon_alert(user, "哦，免费优惠券")
	var/obj/item/coupon/attached_coupon = new
	user.put_in_hands(attached_coupon)
	attached_coupon.generate(rigged_omen ? COUPON_OMEN : null, null, user)
	attached_coupon = null
	spawn_coupon = FALSE
	name = "丢弃的香烟盒"
	desc = "一个背面被撕掉的旧香烟盒，现在一文不值。"
	atom_storage.max_slots = 0

/obj/item/storage/fancy/cigarettes/Initialize(mapload)
	. = ..()

	register_context()
	if(!spawn_count)
		update_appearance()

/obj/item/storage/fancy/cigarettes/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	. = ..()
	if(interacting_with != user) // you can quickly put a cigarette in your mouth only
		return ..()
	quick_remove_item(/obj/item/cigarette, user, equip_to_mouth = TRUE)

/obj/item/storage/fancy/cigarettes/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	quick_remove_item(/obj/item/cigarette, user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/storage/fancy/cigarettes/click_alt(mob/user)
	var/obj/item/lighter = locate(/obj/item/lighter) in contents
	if(lighter)
		quick_remove_item(lighter, user)
	else
		quick_remove_item(/obj/item/cigarette, user)
	return CLICK_ACTION_SUCCESS

/obj/item/storage/fancy/cigarettes/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()
	if(locate(/obj/item/lighter) in contents)
		context[SCREENTIP_CONTEXT_ALT_LMB] = "Remove lighter"
	context[SCREENTIP_CONTEXT_RMB] = "Remove [contents_tag]"
	return CONTEXTUAL_SCREENTIP_SET

/obj/item/storage/fancy/cigarettes/examine(mob/user)
	. = ..()

	if(spawn_coupon)
		. += span_notice("包装背面有一张优惠券！等它空了你可以把它撕下来。")

/obj/item/storage/fancy/cigarettes/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state][contents.len ? null : "_empty"]"

/obj/item/storage/fancy/cigarettes/proc/open_icon_state()
	return "[icon_state]_open"

/obj/item/storage/fancy/cigarettes/update_overlays()
	. = ..()
	if(!open_status || !contents.len)
		return

	. += open_icon_state()

	if(!display_cigs)
		return

	var/cig_position = 1
	for(var/C in contents)
		var/use_icon_state = ""

		if(istype(C, /obj/item/lighter/greyscale))
			use_icon_state = "lighter_in"
		else if(istype(C, /obj/item/lighter))
			use_icon_state = "zippo_in"
		else if(candy)
			use_icon_state = "candy"
		else
			use_icon_state = "cigarette"

		. += "[use_icon_state]_[cig_position]"
		cig_position++

/obj/item/storage/fancy/cigarettes/empty
	spawn_count = 0
	spawn_coupon = FALSE
	open_status = FANCY_CONTAINER_OPEN

/obj/item/storage/fancy/cigarettes/dromedaryco
	name = "\improper 单峰驼公司烟包"
	desc = "一包六支进口的单峰驼公司癌症棒。包装上的标签写着：“缓慢的死亡不也是一种改变吗？”"
	icon_state = "dromedary"
	base_icon_state = "dromedary"
	spawn_type = /obj/item/cigarette/dromedary

/obj/item/storage/fancy/cigarettes/dromedaryco/empty
	spawn_count = 0
	spawn_coupon = FALSE
	open_status = FANCY_CONTAINER_OPEN

/obj/item/storage/fancy/cigarettes/cigpack_uplift
	name = "\improper 提神顺滑烟包"
	desc = "你最喜欢的品牌，现在是薄荷味。"
	icon_state = "uplift"
	base_icon_state = "uplift"
	spawn_type = /obj/item/cigarette/uplift

/obj/item/storage/fancy/cigarettes/cigpack_uplift/empty
	spawn_count = 0
	spawn_coupon = FALSE
	open_status = FANCY_CONTAINER_OPEN

/obj/item/storage/fancy/cigarettes/cigpack_robust
	name = "\improper 劲道烟包"
	desc = "劲道之人所吸。"
	icon_state = "robust"
	base_icon_state = "robust"
	spawn_type = /obj/item/cigarette/robust

/obj/item/storage/fancy/cigarettes/cigpack_robust/empty
	spawn_count = 0
	spawn_coupon = FALSE
	open_status = FANCY_CONTAINER_OPEN

/obj/item/storage/fancy/cigarettes/cigpack_robustgold
	name = "\improper 劲道金装烟包"
	desc = "唯有真正的强者才配享用。"
	icon_state = "robustg"
	base_icon_state = "robustg"
	spawn_type = /obj/item/cigarette/robustgold

/obj/item/storage/fancy/cigarettes/cigpack_robustgold/empty
	spawn_count = 0
	spawn_coupon = FALSE
	open_status = FANCY_CONTAINER_OPEN

/obj/item/storage/fancy/cigarettes/cigpack_greytide
	name = "\improper 薄荷灰潮烟包"
	desc = "那道单薄的灰色防线。"
	icon_state = "greytide"
	base_icon_state = "greytide"
	spawn_type = /obj/item/cigarette/greytide

/obj/item/storage/fancy/cigarettes/cigpack_greytide/empty
	spawn_count = 0
	spawn_coupon = FALSE
	open_status = FANCY_CONTAINER_OPEN

/obj/item/storage/fancy/cigarettes/cigpack_carp
	name = "\improper 鲤鱼经典烟包"
	desc = "自2313年至今。"
	icon_state = "carp"
	base_icon_state = "carp"
	spawn_type = /obj/item/cigarette/carp

/obj/item/storage/fancy/cigarettes/cigpack_carp/empty
	spawn_count = 0
	spawn_coupon = FALSE
	open_status = FANCY_CONTAINER_OPEN

/obj/item/storage/fancy/cigarettes/cigpack_syndicate
	name = "香烟包"
	desc = "一个鲜为人知的香烟品牌。"
	icon_state = "syndie"
	base_icon_state = "syndie"
	spawn_type = /obj/item/cigarette/syndicate

/obj/item/storage/fancy/cigarettes/cigpack_syndicate/empty
	spawn_count = 0
	spawn_coupon = FALSE
	open_status = FANCY_CONTAINER_OPEN

/obj/item/storage/fancy/cigarettes/cigpack_midori
	name = "\improper 绿牌烟草包"
	desc = "你看不懂上面的符文，但这烟包闻起来怪怪的。"
	icon_state = "midori"
	base_icon_state = "midori"
	spawn_type = /obj/item/cigarette/rollie/nicotine

/obj/item/storage/fancy/cigarettes/cigpack_midori/empty
	spawn_count = 0
	spawn_coupon = FALSE
	open_status = FANCY_CONTAINER_OPEN

/obj/item/storage/fancy/cigarettes/cigpack_candy
	name = "\improper 提米的初代糖果烟包"
	desc = "对吸烟犹豫不决？想让孩子安全地融入家族传统？别再找了，试试这款特别烟包！内含100%*无尼古丁糖果香烟。"
	icon_state = "candy"
	base_icon_state = "candy"
	contents_tag = "candy cigarette"
	spawn_type = /obj/item/cigarette/candy
	candy = TRUE
	age_restricted = FALSE

/obj/item/storage/fancy/cigarettes/cigpack_candy/Initialize(mapload)
	. = ..()
	if(prob(7))
		spawn_type = /obj/item/cigarette/candy/nicotine //uh oh!

/obj/item/storage/fancy/cigarettes/cigpack_candy/empty
	spawn_count = 0
	spawn_coupon = FALSE
	open_status = FANCY_CONTAINER_OPEN

/obj/item/storage/fancy/cigarettes/cigpack_shadyjims
	name = "\improper  shady Jim's超细烟包"
	desc = "体重拖累了你？难以逃离引力奇点？管不住嘴？抽shady Jim's超细烟，看着脂肪燃烧殆尽。效果保证！"
	icon_state = "shadyjim"
	base_icon_state = "shadyjim"
	spawn_type = /obj/item/cigarette/shadyjims

/obj/item/storage/fancy/cigarettes/cigpack_shadyjims/empty
	spawn_count = 0
	spawn_coupon = FALSE
	open_status = FANCY_CONTAINER_OPEN

/obj/item/storage/fancy/cigarettes/cigpack_xeno
	name = "\improper 异形过滤嘴烟包"
	desc = "满载100%纯史莱姆精华。当然还有尼古丁。"
	icon_state = "slime"
	base_icon_state = "slime"
	spawn_type = /obj/item/cigarette/xeno

/obj/item/storage/fancy/cigarettes/cigpack_xeno/empty
	spawn_count = 0
	spawn_coupon = FALSE
	open_status = FANCY_CONTAINER_OPEN

/obj/item/storage/fancy/cigarettes/cigpack_cannabis
	name = "\improper 怪胎兄弟特供烟包"
	desc = "包装上的标签写着：“菲尼亚斯、弗雷迪和富兰克林倾情推荐。”"
	icon_state = "midori"
	base_icon_state = "midori"
	spawn_type = /obj/item/cigarette/rollie/cannabis

/obj/item/storage/fancy/cigarettes/cigpack_cannabis/empty
	spawn_count = 0
	spawn_coupon = FALSE
	open_status = FANCY_CONTAINER_OPEN

/obj/item/storage/fancy/cigarettes/cigpack_mindbreaker
	name = "\improper 利瑞的欢愉烟包"
	desc = "在超过36个星系中被禁止。"
	icon_state = "shadyjim"
	base_icon_state = "shadyjim"
	spawn_type = /obj/item/cigarette/rollie/mindbreaker

/obj/item/storage/fancy/cigarettes/cigpack_mindbreaker/empty
	spawn_count = 0
	spawn_coupon = FALSE
	open_status = FANCY_CONTAINER_OPEN

/obj/item/storage/fancy/cigarettes/flash_powder
	spawn_type = /obj/item/cigarette/flash_powder

/obj/item/storage/fancy/rollingpapers
	name = "卷烟纸包"
	desc = "一包纳米传讯品牌的卷烟纸。"
	w_class = WEIGHT_CLASS_TINY
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cig_paper_pack"
	base_icon_state = "cig_paper_pack"
	contents_tag = "rolling paper"
	spawn_type = /obj/item/rollingpaper
	spawn_count = 10
	custom_price = PAYCHECK_LOWER
	has_open_closed_states = FALSE
	storage_type = /datum/storage/rolling_paper_pack

/obj/item/storage/fancy/rollingpapers/Initialize(mapload)
	. = ..()

	if(!spawn_count)
		update_appearance()

/obj/item/storage/fancy/rollingpapers/update_overlays()
	. = ..()
	if(!contents.len)
		. += "[base_icon_state]_empty"

/obj/item/storage/fancy/rollingpapers/empty
	spawn_count = 0

/////////////
//CIGAR BOX//
/////////////

/obj/item/storage/fancy/cigarettes/cigars
	name = "\improper 高级雪茄盒"
	desc = "一盒高级雪茄。非常昂贵。"
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cigarcase"
	base_icon_state = "cigarcase"
	w_class = WEIGHT_CLASS_NORMAL
	contents_tag = "premium cigar"
	storage_type = /datum/storage/cigar_box
	spawn_type = /obj/item/cigarette/cigar/premium
	spawn_count = 5
	spawn_coupon = FALSE
	display_cigs = FALSE

/obj/item/storage/fancy/cigarettes/cigars/update_icon_state()
	. = ..()
	//reset any changes the parent call may have made
	icon_state = base_icon_state

/obj/item/storage/fancy/cigarettes/cigars/empty
	spawn_count = 0
	open_status = FANCY_CONTAINER_OPEN

/obj/item/storage/fancy/cigarettes/cigars/update_overlays()
	. = ..()
	if(!open_status)
		return
	var/cigar_position = 1 //generate sprites for cigars in the box
	for(var/obj/item/cigarette/cigar/smokes in contents)
		. += "[smokes.icon_off]_[cigar_position]"
		cigar_position++

/obj/item/storage/fancy/cigarettes/cigars/cohiba
	name = "\improper 高希霸罗伯图雪茄盒"
	desc = "一盒进口的高希霸雪茄，以其浓郁的风味而闻名。"
	icon_state = "cohibacase"
	base_icon_state = "cohibacase"
	spawn_type = /obj/item/cigarette/cigar/cohiba

/obj/item/storage/fancy/cigarettes/cigars/cohiba/empty
	spawn_count = 0
	open_status = FANCY_CONTAINER_OPEN

/obj/item/storage/fancy/cigarettes/cigars/havana
	name = "\improper 高级哈瓦那雪茄盒"
	desc = "一盒经典的古巴哈瓦那雪茄。"
	icon_state = "havanacase"
	base_icon_state = "havanacase"
	spawn_type = /obj/item/cigarette/cigar/havana


/obj/item/storage/fancy/cigarettes/cigars/havana/open_icon_state()
	return "cohibacase_open"

/obj/item/storage/fancy/cigarettes/cigars/havana/empty
	spawn_count = 0
	open_status = FANCY_CONTAINER_OPEN

/*
 * Heart Shaped Box w/ Chocolates
 */

/obj/item/storage/fancy/heart_box
	name = "心形盒子"
	desc = "一个用来装小巧克力的心形盒子。"
	icon = 'icons/obj/food/containers.dmi'
	inhand_icon_state = "chocolatebox"
	icon_state = "chocolatebox"
	base_icon_state = "chocolatebox"
	lefthand_file = 'icons/mob/inhands/items/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/food_righthand.dmi'
	contents_tag = "chocolate"
	spawn_type = list(
		/obj/item/food/bonbon,
		/obj/item/food/bonbon/chocolate_truffle,
		/obj/item/food/bonbon/caramel_truffle,
		/obj/item/food/bonbon/peanut_truffle,
		/obj/item/food/bonbon/peanut_butter_cup,
	)
	spawn_count = 8
	storage_type = /datum/storage/heart_box

/obj/item/storage/fancy/nugget_box
	name = "鸡块盒"
	desc = "一个用来装鸡块块的纸板盒。"
	icon = 'icons/obj/food/containers.dmi'
	icon_state = "nuggetbox"
	base_icon_state = "nuggetbox"
	inhand_icon_state = "nuggetbox"
	lefthand_file = 'icons/mob/inhands/items/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/food_righthand.dmi'
	contents_tag = "nugget"
	w_class = WEIGHT_CLASS_SMALL
	spawn_type = /obj/item/food/nugget
	spawn_count = 7
	storage_type = /datum/storage/nugget_box

/obj/item/storage/fancy/nugget_box/Initialize(mapload)
	. = ..()
	// It's a safe place for the Fryish/Fritterish
	AddElement(/datum/element/fish_safe_storage)

/obj/item/storage/fancy/nugget_box/red
	name = "red nugget box"
	icon_state = "rednuggetbox"
	base_icon_state = "rednuggetbox"
	inhand_icon_state = "rednuggetbox"

/obj/item/storage/fancy/wing_box
	name = "red wing box"
	desc = "A cardboard box used for holding chicken wangs."
	icon = 'icons/obj/food/containers.dmi'
	icon_state = "redwingbox5"
	base_icon_state = "redwingbox"
	inhand_icon_state = "redwingbox"
	lefthand_file = 'icons/mob/inhands/items/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/food_righthand.dmi'
	contents_tag = "wings"
	w_class = WEIGHT_CLASS_SMALL
	spawn_type = /obj/item/food/fried_chicken
	spawn_count = 5
	storage_type = /datum/storage/wing_box
	open_status = FANCY_CONTAINER_ALWAYS_OPEN

/obj/item/storage/fancy/fry_box
	name = "red fry box"
	desc = "A cardboard box used for holding fries."
	icon = 'icons/obj/food/containers.dmi'
	icon_state = "redfrybox2"
	base_icon_state = "redfrybox"
	inhand_icon_state = "redfrybox"
	lefthand_file = 'icons/mob/inhands/items/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/food_righthand.dmi'
	contents_tag = "fries"
	w_class = WEIGHT_CLASS_SMALL
	spawn_type = /obj/item/food/fries
	spawn_count = 2
	storage_type = /datum/storage/fry_box
	open_status = FANCY_CONTAINER_ALWAYS_OPEN

/*
 * Jar of pickles
 */

/obj/item/storage/fancy/pickles_jar
	icon = 'icons/obj/food/containers.dmi'
	icon_state = "pickles"
	base_icon_state = "pickles"
	name = "腌黄瓜"
	desc = "一个用来装腌黄瓜的罐子。"
	spawn_type = /obj/item/food/pickle
	spawn_count = 10
	contents_tag = "pickle"
	foldable_result = /obj/item/reagent_containers/cup/beaker/large
	custom_materials = list(/datum/material/glass = SHEET_MATERIAL_AMOUNT * 1.25)
	open_status = FANCY_CONTAINER_ALWAYS_OPEN
	has_open_closed_states = FALSE
	storage_type = /datum/storage/pickles_jar

/obj/item/storage/fancy/pickles_jar/update_icon_state()
	. = ..()
	if(!contents.len)
		icon_state = "[base_icon_state]_empty"
	else
		if(contents.len < 5)
			icon_state = "[base_icon_state]_[contents.len]"
		else
			icon_state = base_icon_state

/*
 * Coffee condiments display
 */

/obj/item/storage/fancy/coffee_condi_display
	icon = 'icons/obj/food/containers.dmi'
	icon_state = "coffee_condi_display"
	base_icon_state = "coffee_condi_display"
	name = "咖啡调味品展示架"
	desc = "一个整洁的小木盒，里面装着你最喜欢的咖啡调味品。"
	contents_tag = "coffee condiment"
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT/2)
	resistance_flags = FLAMMABLE
	foldable_result = /obj/item/stack/sheet/mineral/wood
	open_status = FANCY_CONTAINER_ALWAYS_OPEN
	has_open_closed_states = FALSE
	storage_type = /datum/storage/coffee_condi_display

/obj/item/storage/fancy/coffee_condi_display/update_overlays()
	. = ..()
	var/has_sugar = FALSE
	var/has_sweetener = FALSE
	var/has_creamer = FALSE
	var/has_chocolate = FALSE

	for(var/thing in contents)
		if(istype(thing, /obj/item/reagent_containers/condiment/pack/sugar))
			has_sugar = TRUE
		else if(istype(thing, /obj/item/reagent_containers/condiment/pack/astrotame))
			has_sweetener = TRUE
		else if(istype(thing, /obj/item/reagent_containers/condiment/creamer))
			has_creamer = TRUE
		else if(istype(thing, /obj/item/reagent_containers/condiment/chocolate))
			has_chocolate = TRUE

	if (has_sugar)
		. += "condi_display_sugar"
	if (has_sweetener)
		. += "condi_display_sweetener"
	if (has_creamer)
		. += "condi_display_creamer"
	if (has_chocolate)
		. += "condi_display_chocolate"

/obj/item/storage/fancy/coffee_condi_display/PopulateContents()
	for(var/i in 1 to 4)
		new /obj/item/reagent_containers/condiment/pack/sugar(src)
	for(var/i in 1 to 3)
		new /obj/item/reagent_containers/condiment/pack/astrotame(src)
	for(var/i in 1 to 4)
		new /obj/item/reagent_containers/condiment/creamer(src)
	for(var/i in 1 to 3)
		new /obj/item/reagent_containers/condiment/chocolate(src)
	update_appearance()
