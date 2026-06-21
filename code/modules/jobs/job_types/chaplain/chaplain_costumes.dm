//Chaplain Suit Subtypes
//If any new staple chaplain items get added, put them in these lists
/obj/item/clothing/suit/chaplainsuit
	allowed = null
	icon = 'icons/obj/clothing/suits/chaplain.dmi'
	worn_icon = 'icons/mob/clothing/suits/chaplain.dmi'

/obj/item/clothing/suit/chaplainsuit/Initialize(mapload)
	. = ..()
	allowed = GLOB.chaplain_suit_allowed

/obj/item/clothing/suit/chaplainsuit/armor
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	armor_type = /datum/armor/chaplainsuit_armor
	strip_delay = 8 SECONDS
	equip_delay_other = 6 SECONDS

/datum/armor/chaplainsuit_armor
	melee = 50
	bullet = 10
	laser = 10
	energy = 10
	fire = 80
	acid = 80
	wound = 20

/obj/item/clothing/suit/hooded/chaplainsuit
	allowed = null

/obj/item/clothing/suit/hooded/chaplainsuit/Initialize(mapload)
	. = ..()
	allowed = GLOB.chaplain_suit_allowed

//Suits
/obj/item/clothing/suit/chaplainsuit/holidaypriest
	name = "节日牧师"
	desc = "这是个美好的节日，我的孩子。"
	icon_state = "holidaypriest"
	inhand_icon_state = "w_suit"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	flags_inv = HIDEJUMPSUIT|HIDEBELT

/obj/item/clothing/suit/chaplainsuit/nun
	name = "修女袍"
	desc = "本星系最虔诚的服饰。"
	icon_state = "nun"
	inhand_icon_state = "nun"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS|HANDS
	flags_inv = HIDEJUMPSUIT|HIDEBELT

/obj/item/clothing/suit/chaplainsuit/habit
	name = "宗教束腰外衣"
	desc = "绝非无意义的服装。"
	icon_state = "habit"
	alternate_worn_layer = GLOVES_LAYER // since the sleeves cover a part of the hands, this way it looks better while retaining glove overlay correctly.
	body_parts_covered = CHEST|GROIN|LEGS|ARMS|HANDS
	flags_inv = HIDEJUMPSUIT|HIDEBELT

/obj/item/clothing/suit/chaplainsuit/bishoprobe
	name = "主教长袍"
	desc = "很高兴看到你征收的什一税花得其所。"
	icon_state = "bishoprobe"
	inhand_icon_state = "bishoprobe"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	flags_inv = HIDEJUMPSUIT|HIDEBELT

/obj/item/clothing/suit/chaplainsuit/armor/studentuni
	name = "学生长袍"
	desc = "一所昔日学府的制服。"
	icon_state = "studentuni"
	inhand_icon_state = null
	body_parts_covered = ARMS|CHEST

/obj/item/clothing/suit/chaplainsuit/armor/witchhunter
	name = "猎巫者装束"
	desc = "这件破旧的装束在过去曾频繁使用。"
	icon_state = "witchhunter"
	inhand_icon_state = null
	body_parts_covered = CHEST|GROIN|LEGS|ARMS

/obj/item/clothing/suit/hooded/chaplainsuit/monkhabit
	name = "修士服"
	desc = "比粗麻布衣稍好一些。"
	icon_state = "monkfrock"
	icon = 'icons/obj/clothing/suits/chaplain.dmi'
	worn_icon = 'icons/mob/clothing/suits/chaplain.dmi'
	inhand_icon_state = "monkfrock"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	hoodtype = /obj/item/clothing/head/hooded/monkhabit

/obj/item/clothing/head/hooded/monkhabit
	name = "修士兜帽"
	desc = "用于遮盖修士的剃发部位。"
	icon = 'icons/obj/clothing/head/chaplain.dmi'
	worn_icon = 'icons/mob/clothing/head/chaplain.dmi'
	icon_state = "monkhood"
	inhand_icon_state = null
	body_parts_covered = HEAD
	flags_inv = HIDEHAIR|HIDEEARS

/obj/item/clothing/suit/chaplainsuit/monkrobeeast
	name = "东方僧袍"
	desc = "最好搭配光头。"
	icon_state = "monkrobeeast"
	inhand_icon_state = null
	body_parts_covered = GROIN|LEGS
	flags_inv = HIDEJUMPSUIT|HIDEBELT
	clothing_flags = parent_type::clothing_flags | CARP_STYLE_FACTOR

/obj/item/clothing/suit/chaplainsuit/whiterobe
	name = "白色长袍"
	desc = "适合神职人员或困倦的船员。"
	icon_state = "whiterobe"
	inhand_icon_state = null
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	flags_inv = HIDEJUMPSUIT|HIDEBELT

/obj/item/clothing/suit/chaplainsuit/clownpriest
	name = "鸣叫圣母之袍"
	desc = "专为神职小丑准备。"
	icon_state = "clownpriest"
	inhand_icon_state = "clownpriest"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	flags_inv = HIDEJUMPSUIT|HIDEBELT
	allowed = list(/obj/item/megaphone/clown, /obj/item/soap, /obj/item/food/pie/cream, /obj/item/bikehorn, /obj/item/bikehorn/golden, /obj/item/bikehorn/airhorn, /obj/item/instrument/bikehorn, /obj/item/reagent_containers/cup/soda_cans/canned_laughter, /obj/item/toy/crayon, /obj/item/toy/crayon/spraycan, /obj/item/toy/crayon/spraycan/lubecan, /obj/item/grown/bananapeel, /obj/item/food/grown/banana)

/obj/item/clothing/head/helmet/chaplain/clock
	name = "被遗忘的头盔"
	desc = "它有着一位被永恒遗忘的神祇那不屈不挠的凝视。"
	icon_state = "clockwork_helmet"
	inhand_icon_state = null
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	dog_fashion = null

/obj/item/clothing/suit/chaplainsuit/armor/clock
	name = "被遗忘的盔甲"
	desc = "它听起来像是嘶嘶的蒸汽、滴答作响的齿轮，归于沉寂。它看起来像一台死去的机器，试图用生命滴答作响。"
	icon_state = "clockwork_cuirass"
	inhand_icon_state = null
	slowdown = 0

/obj/item/clothing/suit/chaplainsuit/armor/clock/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_PLATE_ARMOR_RUSTLE, 8)

/obj/item/clothing/head/helmet/chaplain
	name = "十字军头盔"
	desc = "Deus Vult。"
	icon = 'icons/obj/clothing/head/chaplain.dmi'
	worn_icon = 'icons/mob/clothing/head/chaplain.dmi'
	icon_state = "knight_templar"
	inhand_icon_state = null
	armor_type = /datum/armor/chaplainsuit_armor
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	strip_delay = 8 SECONDS
	dog_fashion = null

/obj/item/clothing/suit/chaplainsuit/armor/templar
	name = "十字军盔甲"
	desc = "上帝旨意！"
	icon_state = "knight_templar"
	inhand_icon_state = null
	slowdown = 0

/obj/item/clothing/suit/chaplainsuit/armor/templar/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_PLATE_ARMOR_RUSTLE, 8)

/obj/item/clothing/head/helmet/chaplain/cage
	name = "笼子"
	desc = "一个束缚自我意志的笼子，让人得以看清这个亵渎世界的本来面目。"
	flags_inv = NONE
	icon_state = "cage"
	inhand_icon_state = null
	worn_y_offset = 7

/obj/item/clothing/head/helmet/chaplain/ancient
	name = "古老头盔"
	desc = "禁止通行！"
	icon_state = "knight_ancient"
	inhand_icon_state = null

/obj/item/clothing/suit/chaplainsuit/armor/ancient
	name = "古老盔甲"
	desc = "守护宝藏……"
	icon_state = "knight_ancient"
	inhand_icon_state = null
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS

/obj/item/clothing/suit/chaplainsuit/armor/ancient/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_PLATE_ARMOR_RUSTLE, 8)

/obj/item/clothing/head/helmet/chaplain/witchunter_hat
	name = "猎巫帽"
	desc = "这顶帽子在过去派上了不少用场。"
	icon_state = "witchhunterhat"
	inhand_icon_state = null
	flags_cover = HEADCOVERSEYES
	flags_inv = HIDEEYES

/obj/item/clothing/head/helmet/chaplain/adept
	name = "修士兜帽"
	desc = "只有别人做的时候才算异端。"
	icon_state = "crusader"
	inhand_icon_state = null
	flags_cover = HEADCOVERSEYES
	flags_inv = HIDEHAIR|HIDEFACE|HIDEEARS

/obj/item/clothing/suit/chaplainsuit/armor/adept
	name = "修士长袍"
	desc = "焚烧异教徒的理想装束。"
	icon_state = "crusader"
	inhand_icon_state = null
	body_parts_covered = CHEST|GROIN|LEGS

/obj/item/clothing/suit/chaplainsuit/armor/crusader
	name = "十字军铠甲"
	desc = "由金属和布料构成的铠甲。"
	icon_state = "crusader"
	w_class = WEIGHT_CLASS_BULKY
	slowdown = 2.0 //gotta pretend we're balanced.
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	armor_type = /datum/armor/armor_crusader

/obj/item/clothing/suit/chaplainsuit/armor/crusader/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_PLATE_ARMOR_RUSTLE, 8)


/datum/armor/armor_crusader
	melee = 50
	bullet = 50
	laser = 50
	energy = 50
	bomb = 60
	fire = 60
	acid = 60

/obj/item/clothing/suit/chaplainsuit/armor/crusader/red
	icon_state = "crusader-red"

/obj/item/clothing/suit/chaplainsuit/armor/crusader/blue
	icon_state = "crusader-blue"

/obj/item/clothing/head/helmet/chaplain/heretic
	name = "秘术师兜帽"
	desc = "将你的面容隐藏在那些回望之物的视线之外。"
	icon_state = "heretichood"
	inhand_icon_state = null
	flags_cover = HEADCOVERSEYES
	flags_inv = HIDEHAIR|HIDEFACE|HIDEEARS

/obj/item/clothing/suit/chaplainsuit/armor/heretic
	name = "秘术师长袍"
	desc = "保护你的身体免受他人未能察觉之物的侵害。"
	icon_state = "hereticrobe"
	inhand_icon_state = null
	body_parts_covered = CHEST|GROIN|LEGS

/obj/item/clothing/suit/hooded/chaplain_hoodie
	name = "追随者连帽衫"
	desc = "为牧师助手准备的连帽衫。"
	icon_state = "chaplain_hoodie"
	icon = 'icons/obj/clothing/suits/chaplain.dmi'
	worn_icon = 'icons/mob/clothing/suits/chaplain.dmi'
	inhand_icon_state = null
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	allowed = null
	hoodtype = /obj/item/clothing/head/hooded/chaplain_hood

/obj/item/clothing/suit/hooded/chaplain_hoodie/Initialize(mapload)
	. = ..()
	allowed = GLOB.chaplain_suit_allowed

/obj/item/clothing/head/hooded/chaplain_hood
	name = "追随者兜帽"
	desc = "为牧师助手准备的兜帽。"
	icon = 'icons/obj/clothing/head/chaplain.dmi'
	worn_icon = 'icons/mob/clothing/head/chaplain.dmi'
	icon_state = "chaplain_hood"
	body_parts_covered = HEAD
	flags_inv = HIDEHAIR|HIDEFACE|HIDEEARS

/obj/item/clothing/suit/hooded/chaplain_hoodie/leader
	name = "领袖连帽衫"
	desc = "现在你准备好享用50美元的奢华圣水了。"
	icon_state = "chaplain_hoodie_leader"
	inhand_icon_state = null
	hoodtype = /obj/item/clothing/head/hooded/chaplain_hood/leader

/obj/item/clothing/head/hooded/chaplain_hood/leader
	name = "领袖兜帽"
	desc = "我是说，你并不/一定/要去追求奢华圣水。我只是觉得你应该去。"
	icon_state = "chaplain_hood_leader"

/obj/item/clothing/suit/chaplainsuit/shrinehand
	name = "神殿侍者长袍"
	desc = "虽然不能帮你与灵体沟通，但至少看起来像那么回事。"
	icon_state = "shrinehand"
	inhand_icon_state = "shrinehand"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	flags_inv = HIDEJUMPSUIT|HIDEBELT
