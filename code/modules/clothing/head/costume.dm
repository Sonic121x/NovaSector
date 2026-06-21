/obj/item/clothing/head/costume
	icon = 'icons/obj/clothing/head/costume.dmi'
	worn_icon = 'icons/mob/clothing/head/costume.dmi'
	abstract_type = /obj/item/clothing/head/costume

/obj/item/clothing/head/costume/powdered_wig
	name = "粉末式假发"
	desc = "一顶粉末式假发"
	icon_state = "pwig"
	inhand_icon_state = "pwig"

/obj/item/clothing/head/costume/hasturhood
	name = "哈斯塔头巾"
	desc = "它是 <i>不可名状的</i> 时髦。"
	icon_state = "hasturhood"
	flags_inv = HIDEHAIR
	flags_cover = HEADCOVERSEYES

/obj/item/clothing/head/syndicatefake
	name = "黑色太空头盔复制品"
	icon = 'icons/obj/clothing/head/spacehelm.dmi'
	worn_icon = 'icons/mob/clothing/head/spacehelm.dmi'
	icon_state = "syndicate-helm-black-red"
	inhand_icon_state = "syndicate-helm-black-red"
	desc = "A plastic replica of a Syndicate agent's space helmet. You'll look just like a real murderous Syndicate agent in this! This is a toy, it is not made for use in space!"
	clothing_flags = SNUG_FIT | STACKABLE_HELMET_EXEMPT
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT

/obj/item/clothing/head/costume/cueball
	name = "光头球头盔"
	desc = "一个大而没有特点的白色圆球，设计用来戴在头上。你究竟怎么从里面看东西？"
	icon_state = "cueball"
	inhand_icon_state = null
	clothing_flags = SNUG_FIT
	flags_cover = HEADCOVERSEYES|HEADCOVERSMOUTH
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT

/obj/item/clothing/head/costume/snowman
	name = "雪人头"
	desc = "一团白色泡沫塑料球。真有节日气氛。"
	icon_state = "snowman_h"
	inhand_icon_state = null
	clothing_flags = SNUG_FIT
	flags_cover = HEADCOVERSEYES
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT

/obj/item/clothing/head/costume/witchwig
	name = "女巫服装假发"
	desc = "咦~嘻嘻嘻嘻嘻嘻！"
	icon_state = "witch"
	inhand_icon_state = null
	flags_inv = HIDEHAIR

/obj/item/clothing/head/costume/maid_headband
	name = "女仆发带"
	desc = "就像那些中国动画片里的场景一样！"
	greyscale_colors = "#494955#EEEEEE"
	icon = 'icons/map_icons/clothing/head/_head.dmi'
	icon_state = "/obj/item/clothing/head/costume/maid_headband"
	post_init_icon_state = "maid"
	greyscale_config = /datum/greyscale_config/maid_headband
	greyscale_config_worn = /datum/greyscale_config/maid_headband/worn
	greyscale_config_inhand_left = /datum/greyscale_config/maid_headband_inhands_left
	greyscale_config_inhand_right = /datum/greyscale_config/maid_headband_inhands_right
	inhand_icon_state = "maid"
	flags_1 = IS_PLAYER_COLORABLE_1
	clothing_flags = parent_type::clothing_flags | CARP_STYLE_FACTOR

/obj/item/clothing/head/costume/chicken
	name = "小鸡服头"
	desc = "呱呱！"
	icon_state = "chickenhead"
	inhand_icon_state = "chicken_head"
	clothing_flags = SNUG_FIT
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT

/obj/item/clothing/head/costume/griffin
	name = "狮鹫头"
	desc = "为什么不是“鹰头”？谁知道呢。"
	icon_state = "griffinhat"
	inhand_icon_state = null
	clothing_flags = SNUG_FIT
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT

/obj/item/clothing/head/costume/xenos
	name = "异形头盔"
	icon_state = "xenos"
	inhand_icon_state = "xenos_helm"
	desc = "由甲壳状外星皮制成的头盔。"
	clothing_flags = SNUG_FIT
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH

/obj/item/clothing/head/costume/lobsterhat
	name = "泡沫龙虾头"
	desc = "当一切都乱套时，保护好你的头是最明智的选择。"
	icon_state = "lobster_hat"
	clothing_flags = SNUG_FIT
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT

/obj/item/clothing/head/costume/lobsterhat/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/speechmod, replacements = strings("crustacean_replacement.json", "crustacean"))

/obj/item/clothing/head/costume/drfreezehat
	name = "冷冻博士的假发"
	desc = "酷人专用的帅气假发。"
	icon_state = "drfreeze_hat"
	flags_inv = HIDEHAIR

/obj/item/clothing/head/costume/shrine_wig
	name = "巫女假发"
	desc = "华丽的退治！"
	flags_inv = HIDEHAIR //bald
	icon_state = "shrine_wig"
	inhand_icon_state = null
	worn_y_offset = 1

/obj/item/clothing/head/costume/cardborg
	name = "纸板机器人头盔"
	desc = "用盒子做成的头盔。"
	icon_state = "cardborg_h"
	inhand_icon_state = "cardborg_h"
	clothing_flags = SNUG_FIT
	flags_cover = HEADCOVERSEYES
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	custom_materials = list(/datum/material/cardboard = SHEET_MATERIAL_AMOUNT)

	dog_fashion = /datum/dog_fashion/head/cardborg

/obj/item/clothing/head/costume/cardborg/equipped(mob/living/user, slot)
	..()
	if(ishuman(user) && (slot & ITEM_SLOT_HEAD))
		var/mob/living/carbon/human/human_user = user
		if(istype(human_user.wear_suit, /obj/item/clothing/suit/costume/cardborg))
			var/obj/item/clothing/suit/costume/cardborg/suit = human_user.wear_suit
			suit.disguise(user, src)

/obj/item/clothing/head/costume/bronze
	name = "青铜帽"
	desc = "一顶用青铜片粗制成的头盔。它所提供的保护微乎其微。"
	icon_state = "clockwork_helmet_old"
	clothing_flags = SNUG_FIT
	flags_inv = HIDEEARS|HIDEHAIR
	armor_type = /datum/armor/costume_bronze
	custom_materials = list(/datum/material/bronze = SHEET_MATERIAL_AMOUNT)

/obj/item/clothing/head/costume/fancy
	name = "花哨的帽子"
	icon = 'icons/map_icons/clothing/head/_head.dmi'
	icon_state = "/obj/item/clothing/head/costume/fancy"
	post_init_icon_state = "fancy_hat"
	greyscale_config = /datum/greyscale_config/fancy_hat
	greyscale_config_worn = /datum/greyscale_config/fancy_hat/worn
	greyscale_colors = "#E3C937#782A81"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/head/costume/football_helmet
	name = "足球头盔"
	icon = 'icons/map_icons/clothing/head/_head.dmi'
	icon_state = "/obj/item/clothing/head/costume/football_helmet"
	post_init_icon_state = "football_helmet"
	greyscale_config = /datum/greyscale_config/football_helmet
	greyscale_config_worn = /datum/greyscale_config/football_helmet/worn
	greyscale_colors = "#D74722"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/head/costume/tv_head
	name = "电视头盔"
	desc = "一顶由空心化的地位象征遗骸制成的神秘头饰。你真是太有复古未来感了。"
	icon_state = "IPC_helmet"
	inhand_icon_state = "syringe_kit"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi' //Grandfathered in from the wallframe for status displays.
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	clothing_flags = SNUG_FIT
	flags_cover = HEADCOVERSEYES|HEADCOVERSMOUTH
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 7)

/datum/armor/costume_bronze
	melee = 5
	laser = -5
	energy = -15
	bomb = 10
	fire = 20
	acid = 20

/obj/item/clothing/head/costume/irs
	name = "公司内部服务帽"
	desc = "Even in space, you can't avoid the tax collectors."
	icon_state = "irs_hat"
	inhand_icon_state = null

/obj/item/clothing/head/costume/tmc
	name = "迷失M.C头巾"
	desc = "A small, red bandana tied thin."
	icon_state = "tmc_hat"
	inhand_icon_state = null

/obj/item/clothing/head/costume/deckers
	name = "Decker headphones"
	desc = "A neon-blue pair of headphones. They look neo-futuristic."
	icon_state = "decker_hat"
	inhand_icon_state = null
	equip_sound = SFX_HEADSET_EQUIP
	pickup_sound = SFX_HEADSET_PICKUP
	drop_sound = 'sound/items/handling/headset/headset_drop1.ogg'

/obj/item/clothing/head/costume/yuri
	name = "尤里新兵头盔"
	desc = "A strange, whitish helmet with 3 eyeholes."
	icon_state = "yuri_helmet"
	inhand_icon_state = null
	clothing_flags = SNUG_FIT
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT

/obj/item/clothing/head/costume/allies
	name = "盟军头盔"
	desc = "An ancient military helmet worn by the bravest of warriors. \
	It's only a replica, and probably wouldn't protect you from anything."
	icon_state = "allies_helmet"
	inhand_icon_state = null

/obj/item/clothing/head/costume/hairpin
	name = "fancy hairpin"
	desc = "A delicate hairpin normally paired with traditional clothing"
	icon_state = "hairpin_fancy"
	inhand_icon_state = "hairpin_fancy"
	clothing_flags = parent_type::clothing_flags | CARP_STYLE_FACTOR

/obj/item/clothing/head/costume/snakeeater
	name = "strange bandana"
	desc = "A bandana. It seems to have a little carp embroidered on the inside, as well as the kanji '魚'."
	icon_state = "snake_eater"
	inhand_icon_state = null
	clothing_traits = list(TRAIT_FISH_EATER)
	clothing_flags = parent_type::clothing_flags | CARP_STYLE_FACTOR

/obj/item/clothing/head/costume/knight
	name = "fake medieval helmet"
	desc = "A classic metal helmet. Though, this one seems to be very obviously fake..."
	icon = 'icons/obj/clothing/head/helmet.dmi'
	worn_icon = 'icons/mob/clothing/head/helmet.dmi'
	icon_state = "knight_green"
	inhand_icon_state = "knight_helmet"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	dog_fashion = null
