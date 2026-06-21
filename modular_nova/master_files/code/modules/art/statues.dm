//Initializing the glow for the steles.
/obj/structure/statue/silver/nova/Initialize(mapload)
	. = ..()
	update_appearance(UPDATE_OVERLAYS)

//Adding the glowing runes overlay to the steles.
/obj/structure/statue/silver/nova/large/glow/update_overlays()
	. = ..()
	. += add_statue_glow()

/obj/structure/statue/silver/nova/small/glow/update_overlays()
	. = ..()
	. += add_statue_glow()

/// Will attempt to add glow to ALL statues if possible, otherwise do nothing
/obj/structure/statue/proc/add_statue_glow()

	return emissive_appearance(
		src.icon,
		"[icon_state]-emissive",
		src,
		alpha = src.alpha
	)

/// Base statue, do not the statue please
/obj/structure/statue/silver/nova
	name = "心脏雕像"
	desc = "一座描绘心脏的小雕像..."
	icon = 'modular_nova/master_files/icons/obj/art/statue.dmi'
	icon_state = "statue_heart"

/*
	Small Statues
*/

/obj/structure/statue/silver/nova/small
	name = "字母雕像"
	desc = "一座描绘字母的雕像"
	icon_state = "statue_a"

/obj/structure/statue/silver/nova/small/b
	icon_state = "statue_b"

/obj/structure/statue/silver/nova/small/c
	icon_state = "statue_c"

/obj/structure/statue/silver/nova/small/d
	icon_state = "statue_d"

/obj/structure/statue/silver/nova/small/e
	icon_state = "statue_e"

/obj/structure/statue/silver/nova/small/f
	icon_state = "statue_f"

/obj/structure/statue/silver/nova/small/g
	icon_state = "statue_g"

/obj/structure/statue/silver/nova/small/h
	icon_state = "statue_h"

/obj/structure/statue/silver/nova/small/i
	icon_state = "statue_i"

/obj/structure/statue/silver/nova/small/j
	icon_state = "statue_j"

/obj/structure/statue/silver/nova/small/k
	icon_state = "statue_k"

/obj/structure/statue/silver/nova/small/l
	icon_state = "statue_l"

/obj/structure/statue/silver/nova/small/m
	icon_state = "statue_m"

/obj/structure/statue/silver/nova/small/n
	icon_state = "statue_n"

/obj/structure/statue/silver/nova/small/o
	icon_state = "statue_o"

/obj/structure/statue/silver/nova/small/p
	icon_state = "statue_p"

/obj/structure/statue/silver/nova/small/q
	icon_state = "statue_q"

/obj/structure/statue/silver/nova/small/r
	icon_state = "statue_r"

/obj/structure/statue/silver/nova/small/s
	icon_state = "statue_s"

/obj/structure/statue/silver/nova/small/t
	icon_state = "statue_t"

/obj/structure/statue/silver/nova/small/u
	icon_state = "statue_u"

/obj/structure/statue/silver/nova/small/v
	icon_state = "statue_v"

/obj/structure/statue/silver/nova/small/w
	icon_state = "statue_w"

/obj/structure/statue/silver/nova/small/x
	icon_state = "statue_x"

/obj/structure/statue/silver/nova/small/y
	icon_state = "statue_y"

/obj/structure/statue/silver/nova/small/z
	icon_state = "statue_z"

/*
	Small Statues but glowy
*/

/obj/structure/statue/silver/nova/small/glow
	name = "好奇雕像"
	desc = "一座描绘古人类及其太阳系的雕像，它的过去展示了他们曾经所知甚少，以及他们的决心如何帮助他们升入星空。"
	icon_state = "statue_curiosity"

/*
	Large Statues
*/

/obj/structure/statue/silver/nova/large
	name = "太阳联邦纪念像"
	desc = "献给所有英勇牺牲、在保卫这美丽银河系的职责中倒下的士兵们..."
	icon = 'modular_nova/master_files/icons/obj/art/statuelarge.dmi'
	icon_state = "obelisk_solfed"

	max_integrity = 120
	impressiveness = 35
	custom_materials = list(/datum/material/silver=SHEET_MATERIAL_AMOUNT*10)

/obj/structure/statue/silver/nova/large/obelisk
	name = "方尖碑"
	desc = "你不确定它为何在此……它只是一块铁块，然而……它却充满威胁……如同一根立柱……切割得如此干净利落……它的棱角看起来锋利得无法触碰……"
	icon_state = "obelisk_base"

/obj/structure/statue/silver/nova/large/obelisk/dark
	icon_state = "obelisk_base_dark"

/*
	Large Glowing Statues
*/

/obj/structure/statue/silver/nova/large/glow
	name = "远古双子雕像"
	desc = "一座描绘双生姐妹的雕像，她们为宇宙的火焰赋予生命，维系着宇宙的生机与秩序……每一颗余烬都是一颗星辰，处于其无限的混沌之中。"
	icon_state = "twins"

/obj/structure/statue/silver/nova/large/glow/twins_light
	icon_state = "twins_light"

/obj/structure/statue/silver/nova/large/glow/telekenesis
	name = "念力雕像"
	desc = "一座描绘念力行为的雕像……然而你却感觉自己的思想正被这座雕像入侵……"
	icon_state = "telekenesis"

/obj/structure/statue/silver/nova/large/glow/honor
	name = "荣耀誓约者雕像"
	desc = "一座精心制作的雕像，描绘了荣誉、尊严与孤独，其中个人的荣誉绝不容玷污。"
	icon_state = "honour"

/obj/structure/statue/silver/nova/large/glow/honor_lights
	icon_state = "honour_light"

/obj/structure/statue/silver/nova/large/glow/truelight
	name = "光明雕像"
	desc = "一座描绘黑暗的铁制雕像，然而它却激起一丝微弱的感觉，仿佛追随光明将指引你归家。"
	icon_state = "light_statue"

/obj/structure/statue/silver/nova/large/glow/order
	name = "秩序雕像"
	desc = "一座雕像，散发着强烈的秩序感与社群感，通过团结与秩序得以体现。"
	icon_state = "order"

/obj/structure/statue/silver/nova/large/glow/love
	name = "爱之雕像"
	desc = "当你凝视这座雕像时，一种微弱的喜爱与关怀之情似乎浮现在你脑海中……然而……你却感觉不到任何东西……"
	icon_state = "statue_love"

/obj/structure/statue/silver/nova/large/glow/curiosity
	name = "好奇雕像"
	desc = "一座描绘古人类及其太阳系的雕像，它的过往展示了他们曾经所知甚少，以及他们的决心如何帮助他们飞升至星辰之间"
	icon_state = "curiosity"
