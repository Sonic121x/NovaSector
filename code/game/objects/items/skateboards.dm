
/obj/item/melee/skateboard
	name = "滑板"
	desc = "一块滑板。它可以放在轮子上骑行，或者用作一种激进的武器。"
	icon = 'icons/mob/rideables/vehicles.dmi'
	icon_state = "skateboard_held"
	inhand_icon_state = "skateboard"
	force = 12
	throwforce = 4
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb_continuous = list("smacks", "whacks", "slams", "smashes")
	attack_verb_simple = list("smack", "whack", "slam", "smash")
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 10)
	///The vehicle counterpart for the board
	var/board_item_type = /obj/vehicle/ridden/scooter/skateboard

/obj/item/melee/skateboard/attack_self(mob/user)
	var/obj/vehicle/ridden/scooter/skateboard/board = new board_item_type(get_turf(user), src)//this probably has fucky interactions with telekinesis but for the record it wasn't my fault
	board.buckle_mob(user)
	forceMove(board)

/obj/item/melee/skateboard/improvised
	name = "简易滑板"
	desc = "一个临时拼凑的滑板。它可以放在轮子上滑行，或者用作一件超酷的武器。"
	board_item_type = /obj/vehicle/ridden/scooter/skateboard/improvised

/obj/item/melee/skateboard/pro
	name = "滑板"
	desc = "一块EightO品牌的专业滑板。它看起来坚固且制作精良。"
	icon_state = "skateboard2_held"
	inhand_icon_state = "skateboard2"
	board_item_type = /obj/vehicle/ridden/scooter/skateboard/pro
	custom_premium_price = PAYCHECK_COMMAND * 5

/obj/item/melee/skateboard/hoverboard
	name = "悬浮滑板"
	desc = "来自过去的冲击，太复古了！"
	icon_state = "hoverboard_red_held"
	inhand_icon_state = "hoverboard_red"
	board_item_type = /obj/vehicle/ridden/scooter/skateboard/hoverboard
	custom_premium_price = PAYCHECK_COMMAND * 5.4 //If I can't make it a meme I'll make it RAD

/obj/item/melee/skateboard/hoverboard/admin
	name = "董事会"
	desc = "一艘宇宙飞船的工程复杂度浓缩在一块板子里。同样昂贵。"
	icon_state = "hoverboard_nt_held"
	inhand_icon_state = "hoverboard_nt"
	board_item_type = /obj/vehicle/ridden/scooter/skateboard/hoverboard/admin

/obj/item/melee/skateboard/holyboard
	name = "神圣滑板"
	desc = "A board blessed by the gods with the power to grind for our sins. Has the initials 'J.C.' on the underside."
	icon_state = "hoverboard_holy_held"
	inhand_icon_state = "hoverboard_holy"
	force = 18
	throwforce = 6
	w_class = WEIGHT_CLASS_NORMAL
	obj_flags = parent_type::obj_flags | UNIQUE_RENAME
	attack_verb_continuous = list("bashes", "crashes", "grinds", "skates")
	attack_verb_simple = list("bash", "crash", "grind", "skate")
	board_item_type = /obj/vehicle/ridden/scooter/skateboard/hoverboard/holyboarded

/obj/item/melee/skateboard/holyboard/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/nullrod_core)
