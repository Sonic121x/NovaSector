
//BeanieStation13 Redux

//Plus a bobble hat, lets be inclusive!!

/obj/item/clothing/head/beanie
	name = "便帽"
	desc = "一顶时髦的无边帽。对于那些有敏锐时尚触觉的人，以及那些无法忍受头顶冷风的人来说，这是一个完美的冬季配饰。"
	icon = 'icons/map_icons/clothing/head/_head.dmi'
	worn_icon = 'icons/mob/clothing/head/beanie.dmi'
	icon_state = "/obj/item/clothing/head/beanie"
	post_init_icon_state = "beanie"
	custom_price = PAYCHECK_CREW * 1.2
	greyscale_config = /datum/greyscale_config/beanie
	greyscale_config_worn = /datum/greyscale_config/beanie/worn
	greyscale_colors = "#EEEEEE#EEEEEE"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/head/beanie/black
	name = "黑色便帽"
	icon_state = "/obj/item/clothing/head/beanie/black"
	greyscale_colors = "#4A4A4B#4A4A4B"

/obj/item/clothing/head/beanie/red
	name = "红色便帽"
	icon_state = "/obj/item/clothing/head/beanie/red"
	greyscale_colors = "#D91414#D91414"

/obj/item/clothing/head/beanie/darkblue
	name = "深蓝色便帽"
	icon_state = "/obj/item/clothing/head/beanie/darkblue"
	greyscale_colors = "#1E85BC#1E85BC"

/obj/item/clothing/head/beanie/yellow
	name = "黄色便帽"
	icon_state = "/obj/item/clothing/head/beanie/yellow"
	greyscale_colors = "#E0C14F#E0C14F"

/obj/item/clothing/head/beanie/orange
	name = "橙色便帽"
	icon_state = "/obj/item/clothing/head/beanie/orange"
	greyscale_colors = "#C67A4B#C67A4B"

/obj/item/clothing/head/beanie/christmas
	name = "圣诞便帽"
	icon_state = "/obj/item/clothing/head/beanie/christmas"
	greyscale_colors = "#038000#960000"

/obj/item/clothing/head/beanie/durathread
	name = "杜拉棉便帽"
	desc = "一顶用杜拉纤维制成的无檐小便帽。其坚韧的纤维能为佩戴者提供一些保护。"
	icon_state = "/obj/item/clothing/head/beanie/durathread"
	greyscale_colors = "#8291A1#8291A1"
	armor_type = /datum/armor/beanie_durathread

/obj/item/clothing/head/rasta
	name = "倪哥帽"
	desc = "很适合塞脏辫。"
	icon = 'icons/obj/clothing/head/beanie.dmi'
	worn_icon = 'icons/mob/clothing/head/beanie.dmi'
	icon_state = "beanierasta"

/obj/item/clothing/head/waldo
	name = "红色条纹泡泡帽"
	desc = "如果你要去世界各地徒步旅行，你需要一些防寒措施。"
	icon = 'icons/obj/clothing/head/beanie.dmi'
	worn_icon = 'icons/mob/clothing/head/beanie.dmi'
	icon_state = "waldo_hat"

//No dog fashion sprites yet :(  poor Ian can't be dope like the rest of us yet

/obj/item/clothing/head/beanie/black/dboy
	name = "测试用贝尼帽"
	desc = "一顶又脏又破的黑帽子。那是粘液还是油脂？"
	/// Used for the extra flavor text the d-boy himself sees
	var/datum/weakref/beanie_owner = null

/datum/armor/beanie_durathread
	melee = 15
	bullet = 5
	laser = 15
	energy = 25
	bomb = 10
	fire = 30
	acid = 5

/obj/item/clothing/head/beanie/black/dboy/equipped(mob/user, slot)
	. = ..()
	if(iscarbon(user) && !beanie_owner)
		beanie_owner = WEAKREF(user)

/obj/item/clothing/head/beanie/black/dboy/examine(mob/user)
	. = ..()
	if(IS_WEAKREF_OF(user, beanie_owner))
		. += span_purple("它覆盖着只有你那被毁坏到一定程度的眼睛才能看到的异界碎屑。")
