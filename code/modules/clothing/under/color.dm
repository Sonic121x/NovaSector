/obj/item/clothing/under/color
	name = "连身衣"
	desc = "一件标准的彩色连身衣。变化是生活的调味品！"
	icon = 'icons/map_icons/clothing/under/color.dmi'
	icon_state = "/obj/item/clothing/under/color"
	post_init_icon_state = "jumpsuit"
	inhand_icon_state = "jumpsuit"
	worn_icon_state = "jumpsuit"
	worn_icon = 'icons/mob/clothing/under/color.dmi'
	dying_key = DYE_REGISTRY_UNDER
	greyscale_colors = "#3f3f3f"
	greyscale_config = /datum/greyscale_config/jumpsuit
	greyscale_config_worn = /datum/greyscale_config/jumpsuit/worn
	greyscale_config_inhand_left = /datum/greyscale_config/jumpsuit/inhand_left
	greyscale_config_inhand_right = /datum/greyscale_config/jumpsuit/inhand_right
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/under/color/jumpskirt
	icon_state = "/obj/item/clothing/under/color/jumpskirt"
	post_init_icon_state = "jumpskirt"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	greyscale_config_worn_digi = null //NOVA EDIT ADDITION - Mutant Greyscale

/// Returns a random, acceptable jumpsuit typepath
/proc/get_random_jumpsuit()
	return pick(
		subtypesof(/obj/item/clothing/under/color) \
			- typesof(/obj/item/clothing/under/color/jumpskirt) \
			- /obj/item/clothing/under/color/random \
			- /obj/item/clothing/under/color/grey/ancient \
			- /obj/item/clothing/under/color/black/ghost \
			- /obj/item/clothing/under/rank/prisoner \
	)

/obj/item/clothing/under/color/random
	icon = 'icons/obj/clothing/under/color.dmi'
	icon_state = "random_jumpsuit"
	flags_1 = parent_type::flags_1 | NO_NEW_GAGS_PREVIEW_1

/obj/item/clothing/under/color/random/Initialize(mapload)
	..()
	var/obj/item/clothing/under/color/C = get_random_variant() // NOVA EDIT CHANGE - use local proc that handles prefs
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		H.equip_to_slot_or_del(new C(H), ITEM_SLOT_ICLOTHING, initial=TRUE) //or else you end up with naked assistants running around everywhere...
	else
		new C(loc)
	return INITIALIZE_HINT_QDEL

/// Returns a random, acceptable jumpskirt typepath
/proc/get_random_jumpskirt()
	return pick(
		subtypesof(/obj/item/clothing/under/color/jumpskirt) \
			- /obj/item/clothing/under/color/jumpskirt/random \
			- /obj/item/clothing/under/rank/prisoner/skirt \
	)

/obj/item/clothing/under/color/jumpskirt/random
	icon = 'icons/obj/clothing/under/color.dmi'
	icon_state = "random_jumpsuit" //Skirt variant needed
	flags_1 = parent_type::flags_1 | NO_NEW_GAGS_PREVIEW_1

/obj/item/clothing/under/color/jumpskirt/random/Initialize(mapload)
	..()
	var/obj/item/clothing/under/color/jumpskirt/C = get_random_jumpskirt()
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		H.equip_to_slot_or_del(new C(H), ITEM_SLOT_ICLOTHING, initial=TRUE)
	else
		new C(loc)
	return INITIALIZE_HINT_QDEL

/obj/item/clothing/under/color/black
	name = "黑色连身衣"
	resistance_flags = NONE
	flags_1 = parent_type::flags_1 | NO_NEW_GAGS_PREVIEW_1

/obj/item/clothing/under/color/jumpskirt/black
	name = "黑色连身裙"
	flags_1 = parent_type::flags_1 | NO_NEW_GAGS_PREVIEW_1

/obj/item/clothing/under/color/black/ghost
	item_flags = DROPDEL

/obj/item/clothing/under/color/black/ghost/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CULT_TRAIT)

/obj/item/clothing/under/color/grey
	name = "灰色连身衣"
	desc = "一件雅致的灰色连身裤，让你想起过去的美好时光。"
	icon_state = "/obj/item/clothing/under/color/grey"
	greyscale_colors = "#b3b3b3"

/obj/item/clothing/under/color/jumpskirt/grey
	name = "灰色连身裙"
	desc = "一条雅致的灰色连身裙，让你想起过去的美好时光。"
	icon_state = "/obj/item/clothing/under/color/jumpskirt/grey"
	greyscale_colors = "#b3b3b3"

/obj/item/clothing/under/color/grey/ancient
	name = "远古连身衣"
	desc = "一件破烂不堪的灰色连身衣。看起来有十多年没洗过了。"
	icon = 'icons/obj/clothing/under/color.dmi'
	icon_state = "grey_ancient"
	post_init_icon_state = null
	inhand_icon_state = "gy_suit"
	greyscale_config = null
	greyscale_config_inhand_left = null
	greyscale_config_inhand_right = null
	greyscale_config_worn = null
	can_adjust = FALSE

/obj/item/clothing/under/color/blue
	name = "蓝色连身衣"
	icon_state = "/obj/item/clothing/under/color/blue"
	greyscale_colors = "#52aecc"

/obj/item/clothing/under/color/jumpskirt/blue
	name = "蓝色连身裙"
	icon_state = "/obj/item/clothing/under/color/jumpskirt/blue"
	greyscale_colors = "#52aecc"

/obj/item/clothing/under/color/green
	name = "绿色连身衣"
	icon_state = "/obj/item/clothing/under/color/green"
	greyscale_colors = "#9ed63a"

/obj/item/clothing/under/color/jumpskirt/green
	name = "绿色连身裙"
	icon_state = "/obj/item/clothing/under/color/jumpskirt/green"
	greyscale_colors = "#9ed63a"

/obj/item/clothing/under/color/orange
	name = "橙色连身衣"
	desc = "别在疑神疑鬼的安保面前穿这个。"
	icon_state = "/obj/item/clothing/under/color/orange"
	greyscale_colors = "#ff8c19"

/obj/item/clothing/under/color/jumpskirt/orange
	name = "橙色连身裙"
	icon_state = "/obj/item/clothing/under/color/jumpskirt/orange"
	greyscale_colors = "#ff8c19"

/obj/item/clothing/under/color/pink
	name = "粉色连身衣"
	desc = "光是看着这个就让你觉得<i>棒极了</i>。"
	icon_state = "/obj/item/clothing/under/color/pink"
	greyscale_colors = "#ffa69b"

/obj/item/clothing/under/color/jumpskirt/pink
	name = "粉色连身裙"
	icon_state = "/obj/item/clothing/under/color/jumpskirt/pink"
	greyscale_colors = "#ffa69b"

/obj/item/clothing/under/color/red
	name = "红色连身衣"
	icon_state = "/obj/item/clothing/under/color/red"
	greyscale_colors = "#eb0c07"

/obj/item/clothing/under/color/jumpskirt/red
	name = "红色连身裙"
	icon_state = "/obj/item/clothing/under/color/jumpskirt/red"
	greyscale_colors = "#eb0c07"

/obj/item/clothing/under/color/white
	name = "白色连身衣"
	icon_state = "/obj/item/clothing/under/color/white"
	greyscale_colors = "#ffffff"

/obj/item/clothing/under/color/jumpskirt/white
	name = "白色连身裙"
	icon_state = "/obj/item/clothing/under/color/jumpskirt/white"
	greyscale_colors = "#ffffff"

/obj/item/clothing/under/color/yellow
	name = "黄色连身衣"
	icon_state = "/obj/item/clothing/under/color/yellow"
	greyscale_colors = "#ffe14d"

/obj/item/clothing/under/color/jumpskirt/yellow
	name = "黄色连身裙"
	icon_state = "/obj/item/clothing/under/color/jumpskirt/yellow"
	greyscale_colors = "#ffe14d"

/obj/item/clothing/under/color/darkblue
	name = "深蓝色连身衣"
	icon_state = "/obj/item/clothing/under/color/darkblue"
	greyscale_colors = "#3285ba"

/obj/item/clothing/under/color/jumpskirt/darkblue
	name = "深蓝色连身裙"
	icon_state = "/obj/item/clothing/under/color/jumpskirt/darkblue"
	greyscale_colors = "#3285ba"

/obj/item/clothing/under/color/teal
	name = "鸭绿色连身衣"
	icon_state = "/obj/item/clothing/under/color/teal"
	greyscale_colors = "#77f3b7"

/obj/item/clothing/under/color/jumpskirt/teal
	name = "鸭绿色连身裙"
	icon_state = "/obj/item/clothing/under/color/jumpskirt/teal"
	greyscale_colors = "#77f3b7"

/obj/item/clothing/under/color/lightpurple
	name = "浅紫色连身衣"
	icon_state = "/obj/item/clothing/under/color/lightpurple"
	greyscale_colors = "#9f70cc"

/obj/item/clothing/under/color/jumpskirt/lightpurple
	name = "浅紫色连身裙"
	icon_state = "/obj/item/clothing/under/color/jumpskirt/lightpurple"
	greyscale_colors = "#9f70cc"

/obj/item/clothing/under/color/darkgreen
	name = "深绿色连身衣"
	icon_state = "/obj/item/clothing/under/color/darkgreen"
	greyscale_colors = "#6fbc22"

/obj/item/clothing/under/color/jumpskirt/darkgreen
	name = "深绿色连身裙"
	icon_state = "/obj/item/clothing/under/color/jumpskirt/darkgreen"
	greyscale_colors = "#6fbc22"

/obj/item/clothing/under/color/lightbrown
	name = "浅棕色连身衣"
	icon_state = "/obj/item/clothing/under/color/lightbrown"
	greyscale_colors = "#c59431"

/obj/item/clothing/under/color/jumpskirt/lightbrown
	name = "浅棕色连身裙"
	icon_state = "/obj/item/clothing/under/color/jumpskirt/lightbrown"
	greyscale_colors = "#c59431"

/obj/item/clothing/under/color/brown
	name = "褐色连身衣"
	icon_state = "/obj/item/clothing/under/color/brown"
	greyscale_colors = "#a17229"

/obj/item/clothing/under/color/jumpskirt/brown
	name = "褐色连身裙"
	icon_state = "/obj/item/clothing/under/color/jumpskirt/brown"
	greyscale_colors = "#a17229"

/obj/item/clothing/under/color/maroon
	name = "褐红色连身衣"
	icon_state = "/obj/item/clothing/under/color/maroon"
	greyscale_colors = "#cc295f"

/obj/item/clothing/under/color/jumpskirt/maroon
	name = "褐红色连身裙"
	icon_state = "/obj/item/clothing/under/color/jumpskirt/maroon"
	greyscale_colors = "#cc295f"

/obj/item/clothing/under/color/rainbow
	name = "彩虹连身衣"
	desc = "多色连体衣！"
	icon = 'icons/obj/clothing/under/color.dmi'
	icon_state = "rainbow"
	post_init_icon_state = null
	inhand_icon_state = "rainbow"
	greyscale_config = null
	greyscale_config_inhand_left = null
	greyscale_config_inhand_right = null
	greyscale_config_worn = null
	can_adjust = FALSE
	flags_1 = NONE

/obj/item/clothing/under/color/rainbow/get_general_color(icon/base_icon)
	return "#3f3f3f"

/obj/item/clothing/under/color/jumpskirt/rainbow
	name = "彩虹连身裙"
	desc = "多色连身裙！"
	icon = 'icons/obj/clothing/under/color.dmi'
	icon_state = "rainbow_skirt"
	post_init_icon_state = null
	inhand_icon_state = "rainbow"
	greyscale_config = null
	greyscale_config_inhand_left = null
	greyscale_config_inhand_right = null
	greyscale_config_worn = null
	can_adjust = FALSE
	flags_1 = NONE
