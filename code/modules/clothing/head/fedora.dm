/obj/item/clothing/head/fedora
	name = "软呢帽"
	desc = "A really cool hat if you're a mobster. A really lame hat if you're not."
	icon_state = "fedora"
	icon = 'icons/obj/clothing/head/hats.dmi'
	worn_icon = 'icons/mob/clothing/head/hats.dmi'
	hair_mask = /datum/hair_mask/standard_hat_low

/obj/item/clothing/head/fedora/Initialize(mapload)
	. = ..()

	create_storage(storage_type = /datum/storage/pockets/small/fedora)

/obj/item/clothing/head/fedora/white
	name = "白色软呢帽"
	icon_state = "fedora_white"
	inhand_icon_state = null

/obj/item/clothing/head/fedora/beige
	name = "米色软呢帽"
	icon_state = "fedora_beige"
	inhand_icon_state = null

/obj/item/clothing/head/fedora/suicide_act(mob/living/user)
	if(user.gender == FEMALE)
		return
	var/mob/living/carbon/human/H = user
	user.visible_message(span_suicide("[user] 戴上了 [src]！看起来 [user.p_theyre()] 想对女孩们表现得友好些。"))
	user.say("M'lady.", forced = "fedora suicide")
	sleep(1 SECONDS)
	H.facial_hairstyle = "Neckbeard"
	return BRUTELOSS

/obj/item/clothing/head/fedora/carpskin
	name = "鲤鱼皮软呢帽"
	icon_state = "fedora_carpskin"
	inhand_icon_state = null

/obj/item/clothing/head/fedora/carpskin/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, -6)

/obj/item/clothing/head/fedora/beige/press
	name = "记者软呢帽"
	desc = "一顶米色软呢帽，帽檐上别着一张写着\"PRESS\"的纸条。"
	icon_state = "fedora_press"
	inhand_icon_state = null

/obj/item/clothing/head/fedora/greyscale
	inhand_icon_state = null
	icon = 'icons/map_icons/clothing/head/_head.dmi'
	icon_state = "/obj/item/clothing/head/fedora/greyscale"
	post_init_icon_state = "fedora_greyscale"
	greyscale_config = /datum/greyscale_config/fedora
	greyscale_config_worn = /datum/greyscale_config/fedora/worn
	greyscale_colors = "#F0DAB4#794D2E"
	flags_1 = IS_PLAYER_COLORABLE_1
