/obj/item/stack/cannonball
	name = "大炮炮弹"
	desc = "一堆沉重的钢制炮弹，太空时代的枪炮！"
	icon_state = "cannonballs"
	base_icon_state = "cannonballs"
	max_amount = 14
	singular_name = "cannonball"
	merge_type = /obj/item/stack/cannonball
	throwforce = 10
	obj_flags = CONDUCTS_ELECTRICITY
	custom_materials = list(/datum/material/alloy/plasteel=SHEET_MATERIAL_AMOUNT)
	resistance_flags = FIRE_PROOF
	throw_speed = 5
	throw_range = 3
	///the type of projectile this type of cannonball item turns into.
	var/obj/projectile/projectile_type = /obj/projectile/bullet/cannonball

/obj/item/stack/cannonball/update_icon_state()
	. = ..()
	icon_state = (amount == 1) ? "[base_icon_state]" : "[base_icon_state]_[min(amount, 14)]"

/obj/item/stack/cannonball/fourteen
	amount = 14

/obj/item/stack/cannonball/four
	amount = 4

/obj/item/stack/cannonball/shellball
	name = "爆炸性炮弹"
	singular_name = "explosive shellball"
	desc = "一种爆炸性的反器材和步兵炮弹，在任何墙壁上都能很好地工作，便于突入。"
	color = COLOR_RED
	merge_type = /obj/item/stack/cannonball/shellball
	projectile_type = /obj/projectile/bullet/cannonball/explosive

/obj/item/stack/cannonball/shellball/seven
	amount = 7

/obj/item/stack/cannonball/shellball/fourteen
	amount = 14

/obj/item/stack/cannonball/emp
	name = "一些维护弹"
	singular_name = "malfunction shot"
	icon_state = "emp_cannonballs"
	base_icon_state = "emp_cannonballs"
	desc = "一种内部填充两个腔体的注射弹，碰撞瞬间混合腔内容物以产生化学电磁脉冲（EMP）。这到底是什么意思？天晓得。现代海盗搞出这些新花样，真是把老本行的魂儿都丢光了。"
	max_amount = 4
	merge_type = /obj/item/stack/cannonball/emp
	projectile_type = /obj/projectile/bullet/cannonball/emp

/obj/item/stack/cannonball/the_big_one
	name = "\"大的们要来了\""
	singular_name = "\"The Biggest One\""
	desc = "大量的炸药被塞进了一颗巨大的加农炮弹里。这会是你们发射的最后一发弹药，因为所有敌人都会被炸的稀巴烂。"
	max_amount = 5
	icon_state = "biggest_cannonballs"
	base_icon_state = "biggest_cannonballs"
	merge_type = /obj/item/stack/cannonball/the_big_one
	projectile_type = /obj/projectile/bullet/cannonball/biggest_one

/obj/item/stack/cannonball/the_big_one/five
	amount = 5

/obj/item/stack/cannonball/trashball
	name = "垃圾球"
	singular_name = "trashball"
	desc = "一堆被压紧的垃圾。能被塞进炮管当弹药打出去，放进真的加农炮里当炮弹会有点伤炮。"
	max_amount = 4
	icon_state = "trashballs"
	base_icon_state = "trashballs"
	merge_type = /obj/item/stack/cannonball/trashball
	projectile_type = /obj/projectile/bullet/cannonball/trashball
	custom_materials = list(/datum/material/alloy/plasteel = SHEET_MATERIAL_AMOUNT)

/obj/item/stack/cannonball/trashball/four
	amount = 4
