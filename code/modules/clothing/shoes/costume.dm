/obj/item/clothing/shoes/roman
	name = "罗马凉鞋"
	desc = "带扣皮带的凉鞋。"
	icon_state = "roman"
	inhand_icon_state = "wizshoe"
	strip_delay = 10 SECONDS
	equip_delay_other = 10 SECONDS
	armor_type = /datum/armor/shoes_roman
	fastening_type = SHOES_STRAPS
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT)

/obj/item/clothing/shoes/griffin
	name = "狮鹫靴"
	desc = "一双仿鸟爪的戏服靴。"
	icon_state = "griffinboots"
	inhand_icon_state = null
	lace_time = 8 SECONDS

/datum/armor/shoes_roman
	bio = 10

/obj/item/clothing/shoes/griffin/Initialize(mapload)
	. = ..()

	create_storage(storage_type = /datum/storage/pockets/shoes)

/obj/item/clothing/shoes/singery
	name = "黄色舞者靴"
	desc = "这是一双舞靴。"
	icon_state = "ysing"
	equip_delay_other = 5 SECONDS

/obj/item/clothing/shoes/singerb
	name = "蓝色舞者靴"
	desc = "这是一双舞靴。"
	icon_state = "bsing"
	equip_delay_other = 5 SECONDS

/obj/item/clothing/shoes/singerr
	name = "红色表演者靴子"
	desc = "These boots were made for dancing."
	icon_state = "rsing"
	equip_delay_other = 5 SECONDS

/obj/item/clothing/shoes/bronze
	name = "青铜靴"
	desc = "一双又大又笨重的粗青铜鞋。为什么会有人戴这个？"
	icon = 'icons/obj/clothing/shoes.dmi'
	icon_state = "clockwork_treads"
	fastening_type = SHOES_SLIPON
	custom_materials = list(/datum/material/bronze = SHEET_MATERIAL_AMOUNT)

/obj/item/clothing/shoes/bronze/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/squeak, list('sound/machines/clockcult/integration_cog_install.ogg' = 1, 'sound/effects/magic/clockwork/fellowship_armory.ogg' = 1), 50, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)
	AddElement(/datum/element/adjust_fishing_difficulty, 4)

/obj/item/clothing/shoes/cookflops
	desc = "所有这些关于反派 灰潮 乱搞的...我他喵的只想烧烤！"
	name = "烧烤凉鞋"
	icon_state = "cookflops"
	inhand_icon_state = "cookflops"
	fastening_type = SHOES_SLIPON
	species_exception = list(/datum/species/golem)

/obj/item/clothing/shoes/jackbros
	name = "frosty boots"
	desc = "当你准备踏上征途时。"
	icon_state = "JackFrostShoes"
	inhand_icon_state = null

/obj/item/clothing/shoes/swagshoes
	name = "潮鞋"
	desc = "他们就是为了我的泡沫鞋抓我的！"
	icon_state = "SwagShoes"
	inhand_icon_state = null
	clothing_flags = parent_type::clothing_flags | CARP_STYLE_FACTOR

/obj/item/clothing/shoes/glow
	name = "发光鞋"
	desc = "你永远也找不到比这更酷的鞋子了。"
	icon = 'icons/map_icons/clothing/shoes.dmi'
	icon_state = "/obj/item/clothing/shoes/glow"
	post_init_icon_state = "glow_shoes"
	inhand_icon_state = null
	greyscale_config = /datum/greyscale_config/glow_shoes
	greyscale_config_worn = /datum/greyscale_config/glow_shoes/worn
	greyscale_colors = "#4A3A40#8EEEEE"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/shoes/glow/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/gags_recolorable)
	update_icon(UPDATE_OVERLAYS)

/obj/item/clothing/shoes/glow/worn_overlays(mutable_appearance/standing, isinhands, icon_file)
	. = ..()
	if(!isinhands)
		. += emissive_appearance(DEFAULT_SHOES_FILE, "glow_shoes_emissive", src, alpha = src.alpha)

/obj/item/clothing/shoes/glow/update_overlays()
	. = ..()
	. += emissive_appearance('icons/obj/clothing/shoes.dmi', "glow_shoes_emissive", offset_spokesman = src, alpha = src.alpha)

/obj/item/clothing/shoes/saints
	name = "圣徒运动鞋"
	desc = "官方冠名圣徒运动鞋。非常有价值!"
	icon_state = "saints_shoes"
	inhand_icon_state = null

/obj/item/clothing/shoes/jester_shoes
	name = "小丑鞋"
	desc = "每走一步都会叮当作响的鞋子！！"
	icon = 'icons/map_icons/clothing/shoes.dmi'
	icon_state = "/obj/item/clothing/shoes/jester_shoes"
	post_init_icon_state = "jester_map"
	inhand_icon_state = null
	greyscale_config = /datum/greyscale_config/jester_shoes
	greyscale_config_worn = /datum/greyscale_config/jester_shoes/worn
	greyscale_colors = "#00ff00#ff0000"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/shoes/jester_shoes/Initialize(mapload)
	. = ..()

	LoadComponent(/datum/component/squeak, list('sound/effects/jingle.ogg' = 1), 50, falloff_exponent = 20, step_delay_override = 0)

/obj/item/clothing/shoes/ducky_shoes
	name = "小鸭鞋"
	desc = "我有一双靴子，走起路来会*嘎嘎嘎嘎嘎。"
	icon_state = "ducky_shoes"
	inhand_icon_state = "ducky_shoes"

/obj/item/clothing/shoes/ducky_shoes/Initialize(mapload)
	. = ..()

	create_storage(storage_type = /datum/storage/pockets/shoes)
	LoadComponent(/datum/component/squeak, list('sound/effects/quack.ogg' = 1), 50, falloff_exponent = 20)
	AddElement(/datum/element/adjust_fishing_difficulty, -7) //deploy tactical duckling lure

/obj/item/clothing/shoes/ducky_shoes/equipped(mob/living/user, slot)
	. = ..()
	if(slot & ITEM_SLOT_FEET)
		user.AddElementTrait(TRAIT_WADDLING, SHOES_TRAIT, /datum/element/waddling)

/obj/item/clothing/shoes/ducky_shoes/dropped(mob/living/user)
	. = ..()
	REMOVE_TRAIT(user, TRAIT_WADDLING, SHOES_TRAIT)
