
/obj/item/storage/box/lipsticks
	name = "口红盒"

/obj/item/storage/box/lipsticks/PopulateContents()
	..()
	new /obj/item/lipstick(src)
	new /obj/item/lipstick/purple(src)
	new /obj/item/lipstick/jade(src)
	new /obj/item/lipstick/black(src)

/obj/item/lipstick/quantum
	name = "量子口红"

/obj/item/lipstick/quantum/attack(mob/attacked_mob, mob/user)
	if(!open || !ismob(attacked_mob))
		return

	if(!ishuman(attacked_mob))
		to_chat(user, span_warning("那东西的嘴唇在哪儿？"))
		return

	INVOKE_ASYNC(src, PROC_REF(async_set_color), attacked_mob, user)

/obj/item/lipstick/quantum/proc/async_set_color(mob/attacked_mob, mob/user)
	var/new_color = tgui_color_picker(
			user,
			"Select lipstick color",
			null,
			COLOR_WHITE,
		)

	var/mob/living/carbon/human/target = attacked_mob
	if(target.is_mouth_covered())
		to_chat(user, span_warning("摘掉[ target == user ? "your" : "[target.p_their()]" ]面具！"))
		return
	if(target.lip_style) //if they already have lipstick on
		to_chat(user, span_warning("你需要先擦掉旧口红！"))
		return

	if(target == user)
		user.visible_message(span_notice("[user] 用\the [user.p_their()]涂了[src]的嘴唇。"), \
			span_notice("你花了一点时间涂上\the [src]。完美！"))
		target.update_lips("lipstick", new_color, lipstick_trait)
		return

	user.visible_message(span_warning("[user] 开始用\the [target]给[src]涂嘴唇。"), \
		span_notice("You begin to apply \the [src] on [target]'s lips..."))
	if(!do_after(user, 2 SECONDS, target = target))
		return
	user.visible_message(span_notice("[user] 用\the [target]给[src]涂好了嘴唇。"), \
		span_notice("You apply \the [src] on [target]'s lips."))
	target.update_lips("lipstick", new_color, lipstick_trait)

/obj/item/hairbrush/comb
	name = "梳子"
	desc = "一种相当简单的工具，用于理顺头发和其中的结。"
	icon = 'modular_nova/modules/salon/icons/items.dmi'
	icon_state = "blackcomb"

/obj/item/hairstyle_preview_magazine
	name = "时髦发型杂志"
	desc = "一本展示大量发型的杂志！"

/obj/item/hairstyle_preview_magazine/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	// A simple GUI with a list of hairstyles and a view, so people can choose a hairstyle!

/obj/effect/decal/cleanable/hair
	name = "剪下的头发"
	icon = 'modular_nova/modules/salon/icons/items.dmi'
	icon_state = "cut_hair"

/obj/item/razor
	name = "电动剃须刀"
	desc = "剃须科研领域诞生的最新最棒的电动剃须刀。"
	icon = 'modular_nova/modules/salon/icons/items.dmi'
	icon_state = "razor"
	obj_flags = CONDUCTS_ELECTRICITY
	w_class = WEIGHT_CLASS_TINY
	// How long do we take to shave someone's (facial) hair?
	var/shaving_time = 5 SECONDS

/obj/item/razor/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] 开始不用剃须刀防护罩刮[user.p_them()]自己！看起来[user.p_theyre()]试图自杀！"))
	shave(user, BODY_ZONE_PRECISE_MOUTH)
	shave(user, BODY_ZONE_HEAD)//doesnt need to be BODY_ZONE_HEAD specifically, but whatever
	return BRUTELOSS

/obj/item/razor/proc/shave(mob/living/carbon/human/target_human, location = BODY_ZONE_PRECISE_MOUTH)
	if(location == BODY_ZONE_PRECISE_MOUTH)
		target_human.set_facial_hairstyle("Shaved", update = TRUE)
	else
		target_human.set_hairstyle("Bald", update = TRUE)

	playsound(loc, 'sound/items/unsheath.ogg', 20, TRUE)


/obj/item/razor/attack(mob/attacked_mob, mob/living/user)
	if(!ishuman(attacked_mob))
		return ..()

	var/mob/living/carbon/human/target_human = attacked_mob
	var/location = user.zone_selected
	var/obj/item/bodypart/head/noggin = target_human.get_bodypart(BODY_ZONE_HEAD)
	var/static/list/head_zones = list(BODY_ZONE_PRECISE_MOUTH, BODY_ZONE_HEAD)

	if(!noggin && (location in head_zones))
		to_chat(user, span_warning("[target_human] 没有头！"))
		return

	if(!(location in head_zones) && !user.combat_mode)
		to_chat(user, span_warning("你停下来，低头看了看手里的东西，心想：“这大概是用来处理他们的头发或胡须的。”"))
		return

	if(location == BODY_ZONE_PRECISE_MOUTH)
		if(!(noggin.head_flags & HEAD_FACIAL_HAIR))
			to_chat(user, span_warning("没有胡须可剃！"))
			return

		var/covering = target_human.is_mouth_covered()
		if(covering)
			to_chat(user, span_warning("[covering] 挡着呢！"))
			return

		if(HAS_TRAIT(target_human, TRAIT_SHAVED))
			to_chat(user, span_warning("[target_human] 已经剃得太干净了。真的，非常非常干净。"))
			return

		if(target_human.facial_hairstyle == "Shaved")
			to_chat(user, span_warning("已经刮得很干净了！"))
			return

		var/self_shaving = target_human == user // Shaving yourself?
		user.visible_message(span_notice("[user] 开始用[self_shaving ? user.p_their() : "[target_human]'s"]给[src]剃头发。"), \
			span_notice("你花点时间用[self_shaving ? "your" : "[target_human]'s" ]给[src]剃头发..."))

		if(do_after(user, shaving_time, target = target_human))
			user.visible_message(span_notice("[user] 用[self_shaving ? user.p_their() : "[target_human]'s"]把[src]的头发剃干净了。"), \
				span_notice("你用[self_shaving ? "your" : " [target_human]'s"]给[src]剃完了头发。又快又干净！"))

			shave(target_human, location)

	else if(location == BODY_ZONE_HEAD)
		if(!(noggin.head_flags & HEAD_HAIR))
			to_chat(user, span_warning("没有头发可剃！"))
			return

		if(!target_human.is_location_accessible(location))
			to_chat(user, span_warning("头饰挡着呢！"))
			return

		if(target_human.hairstyle == "Bald" || target_human.hairstyle == "Balding Hair" || target_human.hairstyle == "Skinhead")
			to_chat(user, span_warning("剩下的头发不够剃了！"))
			return

		if(HAS_TRAIT(target_human, TRAIT_SHAVED))
			to_chat(user, span_warning("[target_human] 已经剃得太干净了。真的，非常非常干净。"))
			return

		var/self_shaving = target_human == user // Shaving yourself?
		user.visible_message(span_notice("[user] 开始用[self_shaving ? user.p_their() : "[target_human]'s"]给[src]剃头发。"), \
			span_notice("你花点时间用[self_shaving ? "your" : "[target_human]'s" ]给[src]剃头发..."))

		if(do_after(user, shaving_time, target = target_human))
			user.visible_message(span_notice("[user] 用[self_shaving ? user.p_their() : "[target_human]'s"]把[src]的头发剃干净了。"), \
				span_notice("你用[self_shaving ? "your" : " [target_human]'s"]刮完了[src]毛发。又快又干净！"))

			shave(target_human, location)

		return

	return ..()

/obj/structure/sign/barber
	name = "理发店招牌"
	desc = "一条红蓝白三色发光的条纹，你绝不会认错！"
	icon = 'modular_nova/modules/salon/icons/items.dmi'
	icon_state = "barber"
	buildable_sign = FALSE // Don't want them removed, they look too jank.

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/barber, 13)

/obj/structure/sign/barber/Initialize(mapload)
	. = ..()
	if(mapload)
		find_and_mount_on_atom()

/obj/structure/sign/barber/get_turfs_to_mount_on()
	return list(get_step(src, dir))

/obj/item/storage/box/perfume
	name = "香水盒"

/obj/item/storage/box/perfume/PopulateContents()
	new /obj/item/perfume/cologne(src)
	new /obj/item/perfume/wood(src)
	new /obj/item/perfume/rose(src)
	new /obj/item/perfume/jasmine(src)
	new /obj/item/perfume/mint(src)
	new /obj/item/perfume/vanilla(src)
	new /obj/item/perfume/pear(src)
	new /obj/item/perfume/strawberry(src)
	new /obj/item/perfume/cherry(src)
	new /obj/item/perfume/amber(src)
