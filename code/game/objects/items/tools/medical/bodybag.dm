
/obj/item/bodybag
	name = "尸体袋"
	desc = "一种设计用于储存和运输尸体的折叠袋。"
	icon = 'icons/obj/medical/bodybag.dmi'
	icon_state = "bodybag_folded"
	w_class = WEIGHT_CLASS_SMALL
	///Stored path we use for spawning a new body bag entity when unfolded.
	var/unfoldedbag_path = /obj/structure/closet/body_bag

/obj/item/bodybag/attack_self(mob/user)
	if(user.is_holding(src))
		deploy_bodybag(user, get_turf(user))
	else
		deploy_bodybag(user, get_turf(src))

/obj/item/bodybag/interact_with_atom(atom/interacting_with, mob/living/user, flags)
	if(isopenturf(interacting_with))
		deploy_bodybag(user, interacting_with)
		return ITEM_INTERACT_SUCCESS
	return NONE

/obj/item/bodybag/attempt_pickup(mob/user)
	// can't pick ourselves up if we are inside of the bodybag, else very weird things may happen
	if(contains(user))
		return TRUE
	return ..()

/**
 * Creates a new body bag item when unfolded, at the provided location, replacing the body bag item.
 * * mob/user: User opening the body bag.
 * * atom/location: the place/entity/mob where the body bag is being deployed from.
 */
/obj/item/bodybag/proc/deploy_bodybag(mob/user, atom/location)
	var/obj/structure/closet/body_bag/item_bag = new unfoldedbag_path(location)
	item_bag.open(user)
	item_bag.add_fingerprint(user)
	item_bag.foldedbag_instance = src
	moveToNullspace()
	return item_bag

/obj/item/bodybag/suicide_act(mob/living/user)
	if(isopenturf(user.loc))
		user.visible_message(span_suicide("[user] 正爬进 [src]！看起来 [user.p_theyre()] 试图自杀！"))
		var/obj/structure/closet/body_bag/R = new unfoldedbag_path(user.loc)
		R.add_fingerprint(user)
		qdel(src)
		user.forceMove(R)
		playsound(src, 'sound/items/zip/zip.ogg', 15, TRUE, -3)
		return OXYLOSS

// Bluespace bodybag

/obj/item/bodybag/bluespace
	name = "蓝空尸体袋"
	desc = "一种设计用于储存和运输尸体的折叠蓝空尸体袋。"
	icon = 'icons/obj/medical/bodybag.dmi'
	icon_state = "bluebodybag_folded"
	unfoldedbag_path = /obj/structure/closet/body_bag/bluespace
	w_class = WEIGHT_CLASS_SMALL
	item_flags = NO_MAT_REDEMPTION

/obj/item/bodybag/bluespace/examine(mob/user)
	. = ..()
	if(contents.len)
		var/s = contents.len == 1 ? "" : "s"
		. += span_notice("你可以透过布料辨认出[s]个物体[contents.len]的形状[s]。")

/obj/item/bodybag/bluespace/Destroy()
	for(var/atom/movable/A in contents)
		A.forceMove(get_turf(src))
		if(isliving(A))
			to_chat(A, span_notice("你突然感到周围的空间被撕裂了！你自由了！"))
	return ..()

/obj/item/bodybag/bluespace/deploy_bodybag(mob/user, atom/location)
	var/obj/structure/closet/body_bag/item_bag = new unfoldedbag_path(location)
	for(var/atom/movable/inside in contents)
		inside.forceMove(item_bag)
		if(isliving(inside))
			to_chat(inside, span_notice("你突然感觉到周围的空气！你自由了！"))
	item_bag.open(user)
	item_bag.add_fingerprint(user)
	item_bag.foldedbag_instance = src
	moveToNullspace()
	return item_bag

/obj/item/bodybag/bluespace/container_resist_act(mob/living/user)
	if(user.incapacitated)
		to_chat(user, span_warning("你这样被束缚着是出不去的！"))
		return
	user.changeNext_move(CLICK_CD_BREAKOUT)
	user.last_special = world.time + CLICK_CD_BREAKOUT
	to_chat(user, span_notice("你抓挠着 [src] 的织物，试图将其撕开……"))
	to_chat(loc, span_warning("有人开始试图挣脱 [src]！"))
	if(!do_after(user, 12 SECONDS, src, timed_action_flags = (IGNORE_TARGET_LOC_CHANGE|IGNORE_HELD_ITEM)))
		return
	// you are still in the bag? time to go unless you KO'd, honey!
	// if they escape during this time and you rebag them the timer is still clocking down and does NOT reset so they can very easily get out.
	if(user.incapacitated)
		to_chat(loc, span_warning("压力减轻了。看来他们已经停止反抗了……"))
		return
	loc.visible_message(span_warning("[user] 突然出现在 [loc] 面前！"), span_userdanger("[user] 挣脱了 [src]！"))
	qdel(src)

/obj/item/bodybag/environmental
	name = "环境防护袋"
	desc = "一种折叠的加固袋，设计用于抵御外行星环境风暴。"
	icon = 'icons/obj/medical/bodybag.dmi'
	icon_state = "envirobag_folded"
	unfoldedbag_path = /obj/structure/closet/body_bag/environmental
	w_class = WEIGHT_CLASS_NORMAL //It's reinforced and insulated, like a beefed-up sleeping bag, so it has a higher bulkiness than regular bodybag
	resistance_flags = ACID_PROOF | FIRE_PROOF | FREEZE_PROOF

/obj/item/bodybag/environmental/nanotrasen
	name = "精英环境防护袋"
	desc = "一种折叠的、高度加固且隔热的袋子，能够将其内容物与外部因素完全隔离。"
	icon_state = "ntenvirobag_folded"
	unfoldedbag_path = /obj/structure/closet/body_bag/environmental/nanotrasen
	resistance_flags = ACID_PROOF | FIRE_PROOF | FREEZE_PROOF | LAVA_PROOF

/obj/item/bodybag/environmental/prisoner
	name = "囚犯运输袋"
	desc = "专为在危险环境中运输囚犯而设计，这种折叠式环境防护袋配有固定带，可将乘员安全固定。"
	icon = 'icons/obj/medical/bodybag.dmi'
	icon_state = "prisonerenvirobag_folded"
	unfoldedbag_path = /obj/structure/closet/body_bag/environmental/prisoner

/obj/item/bodybag/environmental/prisoner/pressurized
	name = "加压囚犯运输袋"
	unfoldedbag_path = /obj/structure/closet/body_bag/environmental/prisoner/pressurized

/obj/item/bodybag/environmental/prisoner/syndicate
	name = "辛迪加囚犯运输袋"
	desc = "对纳米特拉森环境防护袋的改造，已用于数起高调绑架案。旨在使受害者保持昏迷、存活并安全固定，直至被运送到指定地点。"
	icon = 'icons/obj/medical/bodybag.dmi'
	icon_state = "syndieenvirobag_folded"
	unfoldedbag_path = /obj/structure/closet/body_bag/environmental/prisoner/pressurized/syndicate
	resistance_flags = ACID_PROOF | FIRE_PROOF | FREEZE_PROOF | LAVA_PROOF

/obj/item/bodybag/stasis
	name = /obj/structure/closet/body_bag/environmental/stasis::name
	desc = /obj/structure/closet/body_bag/environmental/stasis::desc
	max_integrity = /obj/structure/closet/body_bag/environmental/stasis::max_integrity
	icon = 'icons/obj/medical/bodybag.dmi'
	icon_state = "stasis_bag_folded"
	unfoldedbag_path = /obj/structure/closet/body_bag/environmental/stasis

/obj/item/bodybag/stasis/deploy_bodybag(mob/user, atom/location)
	var/obj/structure/closet/body_bag/environmental/stasis/bag = ..()
	bag.last_filter_update = -1
	bag.update_integrity(get_integrity())
	return bag
