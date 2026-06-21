/obj/structure/chair/pew
	name = "木制长椅"
	desc = "跪在这里祈祷吧。"
	icon = 'icons/obj/chairs_wide.dmi'
	icon_state = "pewmiddle"
	resistance_flags = FLAMMABLE
	max_integrity = 70
	buildstacktype = /obj/item/stack/sheet/mineral/wood
	buildstackamount = 3
	item_chair = null
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 3)

///This proc adds the rotate component, overwrite this if you for some reason want to change some specific args.
/obj/structure/chair/pew/MakeRotate()
	AddElement(/datum/element/simple_rotation, ROTATION_REQUIRE_WRENCH|ROTATION_IGNORE_ANCHORED)

/obj/structure/chair/pew/left
	name = "木制长椅左端"
	icon_state = "pewend_left"
	has_armrest = TRUE

/obj/structure/chair/pew/right
	name = "木制长椅右端"
	icon_state = "pewend_right"
	has_armrest = TRUE
