
/obj/item/fish/holo
	name = "全息金鱼"
	fish_id = "hologoldfish"
	desc = "一条普通金鱼的全息影像，正从它的全息栖息地中取出，缓慢地闪烁消失。"
	icon_state = /obj/item/fish/goldfish::icon_state
	fish_flags = parent_type::fish_flags & ~(FISH_FLAG_SHOW_IN_CATALOG|FISH_FLAG_EXPERIMENT_SCANNABLE)
	random_case_rarity = FISH_RARITY_NOPE
	dedicated_in_aquarium_icon_state = /obj/item/fish/goldfish::dedicated_in_aquarium_icon_state
	aquarium_vc_color = /obj/item/fish/goldfish::aquarium_vc_color
	sprite_width = /obj/item/fish/goldfish::sprite_width
	sprite_height = /obj/item/fish/goldfish::sprite_height
	stable_population = 1
	average_size = /obj/item/fish/goldfish::average_size
	average_weight = /obj/item/fish/goldfish::average_weight
	required_fluid_type = AQUARIUM_FLUID_ANADROMOUS
	fillet_type = null
	death_text = "%SRC gently disappears."
	fish_traits = list(/datum/fish_trait/no_mating) //just to be sure, these shouldn't reproduce
	beauty = /obj/item/fish/goldfish::beauty

/obj/item/fish/holo/Initialize(mapload, apply_qualities = TRUE)
	. = ..()
	var/area/station/holodeck/holo_area = get_area(src)
	if(!istype(holo_area))
		addtimer(CALLBACK(src, PROC_REF(set_status), FISH_DEAD), 1 MINUTES)
		return
	holo_area.linked.add_to_spawned(src)

/obj/item/fish/holo/make_edible(weight_val)
	return

/obj/item/fish/holo/set_status(new_status, silent = FALSE)
	. = ..()
	if(status == FISH_DEAD)
		animate(src, alpha = 0, 3 SECONDS, easing = SINE_EASING)
		QDEL_IN(src, 3 SECONDS)

/obj/item/fish/holo/suicide_act(mob/living/user)
	visible_message(span_suicide("[user]把[src]整个吞了下去！看起来[user.p_theyre()]想把自己[user.p_them()]反渲染掉！"))
	var/area/station/holodeck/holo_area = get_area(src)
	if(!istype(holo_area))
		user.dust(just_ash = TRUE, drop_items = TRUE)
		return MANUAL_SUICIDE
	holo_area.linked.add_to_spawned(user) // oh no
	return MANUAL_SUICIDE_NONLETHAL

/obj/item/fish/holo/crab
	name = "全息螃蟹"
	fish_id = "holocrab"
	desc = "一只令人心碎地毫无灵魂的螃蟹的全息影像，不像偶尔四处游荡的那些可爱螃蟹。它用空洞、珠子般的眼睛盯着你。"
	icon_state = "crab"
	dedicated_in_aquarium_icon_state = null
	aquarium_vc_color = null
	average_size = 30
	average_weight = 1000
	sprite_height = 6
	sprite_width = 10
	beauty = FISH_BEAUTY_GOOD

/obj/item/fish/holo/puffer
	name = "全息河豚"
	fish_id = "holopufferfish"
	desc ="一条100%安全可食用的河豚的全息影像……当然，前提是全息鱼真的能吃的话。"
	icon_state = /obj/item/fish/pufferfish::icon_state
	dedicated_in_aquarium_icon_state = /obj/item/fish/pufferfish::dedicated_in_aquarium_icon_state
	aquarium_vc_color = /obj/item/fish/pufferfish::aquarium_vc_color
	average_size = /obj/item/fish/pufferfish::average_size
	average_weight = /obj/item/fish/pufferfish::average_weight
	sprite_height = /obj/item/fish/pufferfish::sprite_height
	sprite_width = /obj/item/fish/pufferfish::sprite_width
	beauty = /obj/item/fish/pufferfish::beauty

/obj/item/fish/holo/angel
	name = "全息天使鱼"
	fish_id = "holoangelfish"
	desc = "一条天使鱼的全息影像。关于这个我没什么俏皮话可说。"
	icon_state = /obj/item/fish/angelfish::icon_state
	dedicated_in_aquarium_icon_state = /obj/item/fish/angelfish::dedicated_in_aquarium_icon_state
	aquarium_vc_color = /obj/item/fish/angelfish::aquarium_vc_color
	average_size = /obj/item/fish/angelfish::average_size
	average_weight = /obj/item/fish/angelfish::average_weight
	sprite_height = /obj/item/fish/angelfish::sprite_height
	sprite_width = /obj/item/fish/angelfish::sprite_width
	beauty = /obj/item/fish/angelfish::beauty

/obj/item/fish/holo/clown
	name = "全息小丑鱼"
	fish_id = "holoclownfish"
	icon_state = "holo_clownfish"
	desc = "一条小丑鱼的全息影像，或者至少是五个世纪前它们的样子。"
	dedicated_in_aquarium_icon_state = null
	aquarium_vc_color = /obj/item/fish/clownfish::aquarium_vc_color
	average_size = /obj/item/fish/clownfish::average_size
	average_weight = /obj/item/fish/clownfish::average_weight
	sprite_height = /obj/item/fish/clownfish::sprite_height
	sprite_width = /obj/item/fish/clownfish::sprite_width
	required_fluid_type = /obj/item/fish/clownfish::required_fluid_type
	beauty = /obj/item/fish/clownfish::beauty

/obj/item/fish/holo/checkered
	name = "未渲染的全息鱼"
	fish_id = "checkered"
	desc = "一个灼热的紫色与漆黑相间的棋盘格轮廓呈现在你眼前，如同现实织物上的一道裂痕。看着它令人痛苦。"
	icon_state = "checkered" //it's a meta joke, buddy.
	dedicated_in_aquarium_icon_state = null
	aquarium_vc_color = null
	average_size = 30
	average_weight = 500
	sprite_width = 4
	sprite_height = 3
	beauty = FISH_BEAUTY_NULL

/obj/item/fish/holo/checkered/suicide_act(mob/living/carbon/user)
	if(!iscarbon(user))
		return ..()

	for(var/obj/item/bodypart/limb in user.get_bodyparts())
		limb.add_color_override(COLOR_WHITE, LIMB_COLOR_CS_SOURCE_SUICIDE)
		limb.add_bodypart_overlay(new /datum/bodypart_overlay/texture/checkered(), update = FALSE)

	var/obj/item/bodypart/head/head = user.get_bodypart(BODY_ZONE_HEAD)
	if(!isnull(head))
		head.head_flags &= ~HEAD_EYESPRITES
	user.update_body()
	return ..()

/obj/item/fish/holo/halffish
	name = "全息半鱼"
	fish_id = "halffish"
	desc = "一条……只剩下骨头（除了头部）的鱼的全息影像。它不应该已经死了吗？呃，全息死亡？"
	icon_state = "half_fish"
	dedicated_in_aquarium_icon_state = null
	aquarium_vc_color = null
	sprite_height = 4
	sprite_width = 10
	average_size = 50
	average_weight = 500
	beauty = FISH_BEAUTY_UGLY
