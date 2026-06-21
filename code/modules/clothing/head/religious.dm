/obj/item/clothing/head/chaplain/
	icon = 'icons/obj/clothing/head/chaplain.dmi'
	worn_icon = 'icons/mob/clothing/head/chaplain.dmi'

/obj/item/clothing/head/chaplain/clownmitre
	name = "小丑圣母之帽"
	desc = "当教区居民抬头仰望你华丽的帽子时，很难注意到地上的香蕉皮。"
	icon_state = "clownmitre"

/obj/item/clothing/head/chaplain/kippah
	name = "犹太帽"
	desc = "表明您遵守犹太教律法，会遮住头部，同时思想非常正统。"
	icon_state = "kippah"

/obj/item/clothing/head/chaplain/medievaljewhat
	name = "中世纪犹太帽"
	desc = "一顶傻傻的帽子，原本是打算戴在空间站受压迫的宗教少数群体头上。"
	icon_state = "medievaljewhat"

/obj/item/clothing/head/chaplain/taqiyah/white
	name = "白色花帽"
	desc = "一种额外且更为虔诚的对真主表达敬意的方式。"
	icon_state = "taqiyahwhite"

/obj/item/clothing/head/chaplain/taqiyah/white/Initialize(mapload)
	. = ..()

	create_storage(storage_type = /datum/storage/pockets/small)

/obj/item/clothing/head/chaplain/taqiyah/red
	name = "红色花帽"
	desc = "一种额外且更为虔诚的对真主表达敬意的方式。"
	icon_state = "taqiyahred"

/obj/item/clothing/head/chaplain/taqiyah/red/Initialize(mapload)
	. = ..()

	create_storage(storage_type = /datum/storage/pockets/small)
