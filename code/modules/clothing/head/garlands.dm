/obj/item/clothing/head/costume/garland
	name = "花环"
	desc = "在某个地方，有人穿着这个正挨饿。而那绝对不是你。"
	icon_state = "garland"
	worn_icon_state = "garland"

/obj/item/clothing/head/costume/garland/equipped(mob/living/user, slot)
	. = ..()
	if(slot_flags & slot)
		user.add_mood_event("garland", /datum/mood_event/garland)

/obj/item/clothing/head/costume/garland/dropped(mob/living/user)
	. = ..()
	user.clear_mood_event("garland")

/obj/item/clothing/head/costume/garland/rainbowbunch
	name = "彩虹花冠"
	desc = "一顶用彩虹束植物的花朵制成的花冠。"
	icon_state = "rainbow_bunch_crown_1"
	base_icon_state = "rainbow_bunch_crown"
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 0.3, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 0.3) //tied together with cable coil

/obj/item/clothing/head/costume/garland/rainbowbunch/Initialize(mapload)
	. = ..()
	var/crown_type = rand(1,4)
	icon_state = "[base_icon_state]_[crown_type]"
	switch(crown_type)
		if(1)
			desc += " This one has red, yellow, and white flowers."
		if(2)
			desc += " This one has blue, yellow, green, and white flowers."
		if(3)
			desc += " This one has red, blue, purple, and pink flowers."
		if(4)
			desc += " This one has yellow, green, and white flowers."

/obj/item/clothing/head/costume/garland/sunflower
	name = "向日葵花冠"
	desc = "一顶用向日葵制成的明亮花冠，保证能让任何人的一天都亮起来！"
	icon_state = "sunflower_crown"
	worn_icon_state = "sunflower_crown"
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 0.3, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 0.3) //tied together with cable coil

/obj/item/clothing/head/costume/garland/poppy
	name = "罂粟花花冠"
	desc = "一顶用一串鲜红罂粟花制成的花冠。"
	icon_state = "poppy_crown"
	worn_icon_state = "poppy_crown"
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 0.3, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 0.3) //tied together with cable coil

/obj/item/clothing/head/costume/garland/lily
	name = "百合花花冠"
	desc = "一顶绿叶花冠，正面有一簇大白百合花。"
	icon_state = "lily_crown"
	worn_icon_state = "lily_crown"
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 0.3, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 0.3) //tied together with cable coil

