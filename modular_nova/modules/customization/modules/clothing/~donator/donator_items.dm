//In the event someone needs one.
/obj/item/storage/box/donator
	name = "个人物品箱"
	desc = "里面装满了你从家里带来的东西。"

//Donator reward for UltramariFox
/obj/item/cigarette/khi
	name = "\improper 北狐奇点香烟"
	icon = 'modular_nova/master_files/icons/obj/clothing/masks.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/mask.dmi'
	icon_state = "khioff"
	icon_on = "khion"
	icon_off = "khioff"
	type_butt = /obj/item/cigbutt/khi
	list_reagents = list(/datum/reagent/drug/nicotine = 10, /datum/reagent/toxin/mindbreaker = 5)

/obj/item/cigbutt/khi
	icon = 'modular_nova/master_files/icons/obj/cigarettes_khi.dmi'
	icon_state = "khibutt"

/obj/item/storage/fancy/cigarettes/khi
	name = "\improper 北狐奇点烟盒"
	icon = 'modular_nova/master_files/icons/obj/cigarettes_khi.dmi'
	icon_state = "khi_cig_packet"
	base_icon_state = "khi_cig_packet"
	spawn_type = /obj/item/cigarette/khi

//Donator reward for Stonetear
/obj/item/hairbrush/switchblade
	name = "弹簧梳"
	icon = 'modular_nova/master_files/icons/donator/obj/custom.dmi'
	icon_state = "switchblade"
	base_icon_state = "switchblade"
	desc = "一把锋利、可隐藏的弹簧式梳子。"
	hitsound = 'sound/items/weapons/genhit.ogg'
	resistance_flags = FIRE_PROOF
	var/extended = FALSE

/obj/item/hairbrush/switchblade/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

///This is called when you transform it
/obj/item/hairbrush/switchblade/attack_self(mob/user, modifiers)
	extended = !extended
	icon_state = "switchblade[extended ? "_on" : ""]"

	playsound(user || src, 'sound/items/weapons/batonextend.ogg', 30, TRUE)


/// This makes it so you have to extend it.
/obj/item/hairbrush/switchblade/attack(mob/target, mob/user)
	if(!extended)
		to_chat(user, span_warning("先试试把刀刃弹出来啊，笨蛋！"))
		return COMPONENT_CANCEL_ATTACK_CHAIN

	if(target.stat == DEAD)
		to_chat(user, span_warning("给一个不懂得欣赏的人梳头没什么意义！"))
		return COMPONENT_CANCEL_ATTACK_CHAIN

	brush(target, user)

	return COMPONENT_CANCEL_ATTACK_CHAIN


#define TURN_DIAL 		0
#define TAP_SCREEN		1
#define PRESS_KEYS		2
#define EXTEND_ANTENNA	3
#define SLAP_SIDE		4

//Donation reward for Thedragmeme, avalible to craft publicly
/datum/crafting_recipe/stellar_bouquet
	name = "星辰花束"
	result = /obj/item/bouquet/stellar
	reqs = list(
		/obj/item/food/grown/poppy/lily = 2,
		/obj/item/food/grown/rose = 2,
		/obj/item/food/grown/poppy/geranium = 2,
		/obj/item/stack/sheet/mineral/silver = 1,
	)
	category = CAT_ENTERTAINMENT

/obj/item/donator/transponder
	name = "损坏的赫利安应答器"
	desc = "被赫利安人用来与母舰通信，屏幕碎裂，边缘磨损。这东西已经风光不再了。"
	icon = 'modular_nova/master_files/icons/donator/obj/custom.dmi'
	worn_icon = 'modular_nova/master_files/icons/donator/mob/clothing/custom_w.dmi'
	lefthand_file = 'modular_nova/master_files/icons/donator/mob/inhands/donator_left.dmi'
	righthand_file = 'modular_nova/master_files/icons/donator/mob/inhands/donator_right.dmi'
	icon_state = "transponder"
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_BELT
	var/datum/effect_system/basic/spark_spread/sparks
	var/current_state = TURN_DIAL
	var/next_activate = 0

/obj/item/donator/transponder/Initialize(mapload)
	. = ..()
	sparks = new(src, 2, FALSE)
	sparks.attach(src)
	sparks.start()

/obj/item/donator/transponder/Destroy()
	if(sparks)
		QDEL_NULL(sparks)
	return ..()

/obj/item/donator/transponder/attack_self(mob/user)
	if(QDELETED(src) || (next_activate > world.time))
		return FALSE

	add_fingerprint(user)

	switch(current_state)
		if(TURN_DIAL)
			user.visible_message(
				"[icon2html(src, oviewers(2, user))] As [user] turns the red dial on the side of \the [src], it spits out some encrypted static and warbles before silencing itself.",
				"[icon2html(src, user)] As you turn the red dial on the side of the device, it spits out some encrypted static and warbles before silencing itself.",
				vision_distance=2)
			playsound(user, 'modular_nova/master_files/sound/effects/bab1.ogg', 100, TRUE)
			sparks.start()
			current_state = TAP_SCREEN
			next_activate = world.time + 20
			return
		if(TAP_SCREEN)
			user.visible_message(
				"[icon2html(src, oviewers(2, user))] [user] taps the screen of \the [src], making it light up and starting the boot sequence. \the [src] displays an error message and shuts off.",
				"[icon2html(src, user)] You tap the device's screen, making it light up and starting the boot sequence. The device displays an error message and shuts off.",
				vision_distance=2)
			playsound(user, 'modular_nova/master_files/sound/effects/platform_call.ogg', 100, TRUE)
			current_state = PRESS_KEYS
			next_activate = world.time + 20
			return
		if(PRESS_KEYS)
			user.visible_message(
				"[icon2html(src, oviewers(2, user))] [user] presses some keys, producing some promising beeps, before a harsh buzz returns [src] to silence again.",
				"[icon2html(src, user)] You press some keys, producing some promising beeps, before a harsh buzz returns the device to silence again.",
				vision_distance=2)
			sparks.start()
			playsound(user, 'modular_nova/master_files/sound/effects/gmalfunction.ogg', 100, TRUE)
			current_state = EXTEND_ANTENNA
			next_activate = world.time + 20
			return
		if(EXTEND_ANTENNA)
			user.visible_message(
				"[icon2html(src, oviewers(2, user))] [user] extends the antennae on \the [src], yielding a progress bar, but no amount of adjusting gets it to 100%. [user] returns them to normal.",
				"[icon2html(src, user)] You extend the antennae, yielding a progress bar, but no amount of adjusting gets it to 100%. You return them to normal.",
				vision_distance=2)
			current_state = SLAP_SIDE
			next_activate = world.time + 20
			return
		if(SLAP_SIDE)
			user.visible_message(
				"[icon2html(src, oviewers(2, user))] [user] slaps the side of \the [src] and it whirrs into life, before thunking and remains still.",
				"[icon2html(src, user)] You slap the side of the device and it whirrs into life, before thunking and remaining still.",
				vision_distance=2)
			playsound(user, 'modular_nova/master_files/sound/effects/hacked.ogg', 100, TRUE)
			sparks.start()
			current_state = TURN_DIAL
			next_activate = world.time + 110
			return
		else
			current_state = TURN_DIAL
			next_activate = world.time + 20
			return

#undef TURN_DIAL
#undef TAP_SCREEN
#undef PRESS_KEYS
#undef EXTEND_ANTENNA
#undef SLAP_SIDE

// Donation rewards for SQNZTB
/obj/item/storage/box/donator/sqn

/obj/item/storage/box/donator/sqn/PopulateContents()
	new /obj/item/holosign_creator/hardlight_wheelchair(src)
	new /obj/item/nanite_leg_reinforcement(src)
	new /obj/item/lipstick/quantum/sqn(src)
	new /obj/item/clothing/glasses/hud/ar/projector/science/sqn(src)

/obj/vehicle/ridden/wheelchair/hardlight
	name = "硬光轮椅"
	desc = "一把由硬光制成的轮椅，由微型化的蓝空技术驱动。"
	alpha = 150 // Just to help differentiate it from a real wheelchair, and to show that it's a bit squishier.
	max_integrity = 10 //standard wheelchairs have 100, motorized 150
	/// The projector associated with this wheelchair.
	/// Only used so that we can remove this wheelchair from it when it gets destroyed.
	var/obj/item/holosign_creator/projector = null
	foldabletype = null


/obj/vehicle/ridden/wheelchair/hardlight/Initialize(mapload, source_projector)
	. = ..()
	if(source_projector)
		projector = source_projector
		LAZYADD(projector.signs, src)


/obj/vehicle/ridden/wheelchair/hardlight/Destroy()
	if(projector)
		LAZYREMOVE(projector.signs, src)
		projector = null

	return ..()


/obj/vehicle/ridden/wheelchair/hardlight/post_unbuckle_mob()
	. = ..()

	visible_message(span_notice("[src] 闪烁并随着硬光发射器关闭而消失。"))
	qdel(src)


/obj/vehicle/ridden/wheelchair/hardlight/make_ridable()
	AddElement(/datum/element/ridable, /datum/component/riding/vehicle/wheelchair/hardlight)


// Custom riding component for this wheelchair, so that it behaves properly.
/datum/component/riding/vehicle/wheelchair/hardlight/driver_move(obj/vehicle/vehicle_parent, mob/living/user, direction)
	var/delay_multiplier = 6.7 // magic number from wheelchair code
	//setting speed divisor to 3. original formula from the motorized chair code is:
	//vehicle_move_delay = round(CONFIG_GET(number/movedelay/run_delay) * delay_multiplier) / speed
	//this makes it slightly slower than a motorized wheelchair with t1 parts.
	vehicle_move_delay = round(CONFIG_GET(number/movedelay/run_delay) * delay_multiplier) / 3
	return ..()


// The actual item they will be using.
/obj/item/holosign_creator/hardlight_wheelchair
	name = "硬光轮椅发射器"
	desc = "一个能投射出可骑乘但脆弱的硬光轮椅的发射器。"
	icon_state = "signmaker_med"
	holosign_type = /obj/vehicle/ridden/wheelchair/hardlight
	max_signs = 1


/obj/item/holosign_creator/hardlight_wheelchair/examine(mob/user)
	. = ..()
	. += span_tinynoticeital("\n<i>手柄下方似乎刻着什么，你可以再仔细看看……</i>")


/obj/item/holosign_creator/hardlight_wheelchair/examine_more(mob/user)
	. = ..()
	. += span_notice("<i>手柄下方刻有如下信息：</i>\n")
	. += span_smallnoticeital("\"我告诉过你我会找到让这一切都变简单的方法。\" - A.H.")


/datum/action/innate/nanite_leg_reinforcement
	name = "切换腿部强化"
	desc = "获得暂时站立的能力。"
	button_icon = 'icons/obj/clothing/shoes.dmi'
	button_icon_state = "jackboots"
	/// Type of the quirk we want to stash away.
	var/quirk_to_stash = /datum/quirk/paraplegic
	/// Reference to the quirk that was stashed away.
	var/datum/quirk/stashed_quirk

/datum/action/innate/nanite_leg_reinforcement/Activate()
	var/mob/living/living_owner = owner
	stashed_quirk = living_owner.get_quirk(quirk_to_stash)
	stashed_quirk.remove_from_current_holder(TRUE)
	active = TRUE

/datum/action/innate/nanite_leg_reinforcement/Deactivate()
	stashed_quirk.add_to_holder(owner, TRUE)
	stashed_quirk = null
	active = FALSE
	build_all_button_icons(UPDATE_BUTTON_BACKGROUND)

/obj/item/nanite_leg_reinforcement
	name = "纳米腿部强化装置"
	desc = "让你能够引导纳米机器人，使你能够站立一段时间。"
	icon = 'modular_nova/modules/modular_implants/icons/obj/nifs.dmi'
	icon_state = "base_nif"
	/// Which action this item grants you.
	var/action_to_grant = /datum/action/innate/nanite_leg_reinforcement

/obj/item/nanite_leg_reinforcement/attack_self(mob/user, modifiers)
	. = ..()
	var/mob/living/living_user = user
	if(!istype(user) || !living_user.has_quirk(/datum/quirk/paraplegic))
		to_chat(user, "你觉得[src]对你没什么帮助。")
		return
	var/datum/action/action = new action_to_grant(user)
	action.Grant(user)
	to_chat(user, "[src] 在一阵烟雾中消失了！")
	qdel(src)

/obj/item/lipstick/quantum/sqn
	name = "\improper SW:10KK 唇膏"
	desc = "星光漫游者牌万吻口红，可调节色素。保证不晕染、不沾色、不留唇印，除非您希望如此。这支口红看起来使用痕迹很重。"

/obj/item/clothing/glasses/hud/ar/projector/science/sqn
	name = "微视网膜显示器"
	desc = "一个如此微小的视网膜显示器，除了你之外对所有人都不可见。"
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/under/misc.dmi'
	worn_icon_state = "gear_harness"

/obj/item/instrument/piano_synth/headphones/catear_headphone
	name = "猫耳耳机"
	desc = "奇点撕裂者乐队电吉他手黛米·加尔甘的周边商品。它高度可定制，甚至还带有一条全息尾巴！"
	worn_icon = 'modular_nova/modules/GAGS/icons/head/catear_headphone.dmi'
	lefthand_file = 'modular_nova/modules/GAGS/icons/head/catear_headphone_inhand.dmi'
	righthand_file = 'modular_nova/modules/GAGS/icons/head/catear_headphone_inhand.dmi'
	inhand_icon_state = "catear_headphone"
	slot_flags = ITEM_SLOT_EARS | ITEM_SLOT_HEAD | ITEM_SLOT_NECK
	var/catTailToggled = FALSE
	instrument_range = 1
	greyscale_colors = "#FFFFFF#FFFFFF"
	icon = 'icons/map_icons/items/_item.dmi'
	icon_state = "/obj/item/instrument/piano_synth/headphones/catear_headphone"
	post_init_icon_state = "catear_headphone"
	greyscale_config = /datum/greyscale_config/catear_headphone
	greyscale_config_worn = /datum/greyscale_config/catear_headphone/worn
	greyscale_config_inhand_left = /datum/greyscale_config/catear_headphone_inhand_left
	greyscale_config_inhand_right = /datum/greyscale_config/catear_headphone_inhand_right
	flags_1 = IS_PLAYER_COLORABLE_1


/obj/item/instrument/piano_synth/headphones/catear_headphone/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/gags_recolorable)
	update_icon(UPDATE_OVERLAYS)

/obj/item/instrument/piano_synth/headphones/catear_headphone/worn_overlays(mutable_appearance/standing, isinhands, icon_file)
	. = ..()
	if(!isinhands)
		. += emissive_appearance('modular_nova/modules/GAGS/icons/head/catear_headphone.dmi', "catearphones_[song?.playing ? "on" : "off"]_emissive", src, alpha = src.alpha)
		if(catTailToggled)
			. += emissive_appearance('modular_nova/modules/GAGS/icons/head/catear_headphone.dmi', "catearphones_tail_on_emissive", src, alpha = src.alpha)
			icon_state = "catear_headphone_tail[song?.playing ? "_on" : null]"
		else
			icon_state = "catear_headphone[song?.playing ? "_on" : null]"

/obj/item/instrument/piano_synth/headphones/catear_headphone/click_alt(mob/user)
	catTailToggled = !catTailToggled
	user.update_worn_head()
	update_icon(UPDATE_OVERLAYS)
	return CLICK_ACTION_SUCCESS

/obj/item/instrument/piano_synth/headphones/catear_headphone/update_overlays()
	. = ..()
	. += emissive_appearance('modular_nova/modules/GAGS/icons/head/catear_headphone.dmi', "catearphones_obj_lights_emissive", src, alpha = src.alpha)

/obj/item/clothing/head/cone_of_shame
	name = "项圈锥"
	desc = "一种用于防止感染的防护罩。其广告宣称它：“用于防止不必要的抓挠、啃咬或舔舐伤口，以更好地促进愈合。对人和宠物同样有效！”你质疑它的功效，同时佩戴时也感到一丝轻微的羞耻。"
	base_icon_state = "cone"
	icon_state = "cone"
	worn_icon_state = "cone_close"
	icon = 'modular_nova/master_files/icons/donator/obj/clothing/hats.dmi'
	worn_icon = 'modular_nova/master_files/icons/donator/mob/clothing/head.dmi'
	alternate_worn_layer = ABOVE_BODY_FRONT_HEAD_LAYER - 0.1
	slot_flags = parent_type::slot_flags | ITEM_SLOT_NECK
	dog_fashion = /datum/dog_fashion/head/cone
	var/toggle_state = "close"
	custom_materials = list(/datum/material/plastic = SHEET_MATERIAL_AMOUNT)

/obj/item/clothing/head/cone_of_shame/click_alt(mob/user)
	if(toggle_state == "open")
		toggle_state = "close"
	else
		toggle_state = "open"

	balloon_alert(user, "[toggle_state == "open" ? "opened" : "closed"]")
	update_icon(UPDATE_ICON_STATE)

	var/mob/living/wearer = loc
	if(!istype(wearer))
		return CLICK_ACTION_SUCCESS

	var/equipped_slot = wearer.get_slot_by_item(src)
	if(equipped_slot & slot_flags)
		wearer.update_clothing(equipped_slot)
	return CLICK_ACTION_SUCCESS

/obj/item/clothing/head/cone_of_shame/equipped(mob/living/user, slot)
	if(slot & slot_flags)
		update_layer(user)
		RegisterSignal(user, COMSIG_ATOM_POST_DIR_CHANGE, PROC_REF(on_dir_change))
	return ..()

/obj/item/clothing/head/cone_of_shame/dropped(mob/user)
	if(user.get_slot_by_item(src) & slot_flags)
		UnregisterSignal(user, COMSIG_ATOM_POST_DIR_CHANGE)
	return ..()

/obj/item/clothing/head/cone_of_shame/proc/on_dir_change(mob/wearer, old_dir, new_dir)
	SIGNAL_HANDLER
	var/old_south = old_dir == SOUTH
	var/new_south = new_dir == SOUTH
	if(old_south == new_south)
		return // either still facing south or still not facing south
	update_layer(wearer)

/obj/item/clothing/head/cone_of_shame/proc/update_layer(mob/wearer)
	// renders behind hair only when facing exactly south, and above pretty much anything on the head any other direction
	// diagonals render as east/west first so only need the exact cardinal
	if(wearer.dir == SOUTH)
		alternate_worn_layer = HAIR_LAYER + 0.1
	else
		alternate_worn_layer = ABOVE_BODY_FRONT_HEAD_LAYER - 0.1
	wearer.update_clothing(wearer.get_slot_by_item(src))

/obj/item/clothing/head/cone_of_shame/update_icon_state()
	worn_icon_state = "[base_icon_state]_[toggle_state]"
	return ..()

// Kaynite Donor Item
/obj/item/storage/backpack/merctac_backpack
	name = "\improper Xplore Go! 背包"
	desc = "来自生存装备商Xplore的多功能单肩背包。一个20升的背包，配有一个可拆卸的保温水瓶和氧气罐，用于星际徒步旅行。"
	icon_state = "xplore_go_bag"
	icon = 'modular_nova/master_files/icons/donator/obj/clothing/back.dmi'
	worn_icon = 'modular_nova/master_files/icons/donator/mob/clothing/back.dmi'
	inhand_icon_state = "backpack"

// Latinfishy & HollandaiseSauce Donor Item
/obj/item/device/custom_kit/ak105
	name = "\improper AK-105 现代化改装套件"
	desc = "用于将米耶茨步枪改装为AK-105的旧枪械零件。"
	from_obj = /obj/item/gun/ballistic/automatic/miecz
	to_obj = /obj/item/gun/ballistic/automatic/miecz/ak105

/obj/item/gun/ballistic/automatic/miecz/ak105
	name = "\improper AK-105 短管步枪"
	desc = "一款经过现代化改造的轻型突击步枪，使用.27-54 Cesarzowa弹药，射速高。"
	lore_blurb = "An ancient design that has routes in the old sol nation of the Russian Federation, this rifle has been heavily modified with a modified barrel for extended firefights \
		alongside a modified grip allowing it to be used most form of combat gloves alongside being able to have a good grip with wet hands, the stock has been swapped for a completely \
		polymer design giving it a good form."
	icon = 'modular_nova/master_files/icons/donator/obj/guns48x.dmi'
	icon_state = "ak105sbr"
	worn_icon = 'modular_nova/master_files/icons/donator/mob/worn/weapons.dmi'
	worn_icon_state = "ak105sbr"
	lefthand_file = 'modular_nova/master_files/icons/donator/mob/inhands/donator_left.dmi'
	righthand_file = 'modular_nova/master_files/icons/donator/mob/inhands/donator_right.dmi'
	inhand_icon_state = "ak105sbr"
	suppressor_x_offset = 7
	suppressor_y_offset = 0

/obj/item/gun/ballistic/automatic/miecz/ak105/no_mag
	//Made this one for completion, the thing is, the kit doesnt affect no_mag, so, the day we change the paradigm of the miecz to spawn with no_mag, likely we want this one. (alternatively we do somethiing better thhan to use subtypes.)
	spawnwithmagazine = FALSE
