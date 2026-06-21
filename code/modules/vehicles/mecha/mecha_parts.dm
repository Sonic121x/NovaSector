/////////////////////////
////// Mecha Parts //////
/////////////////////////

/obj/item/mecha_parts
	name = "机甲部件"
	icon = 'icons/mob/rideables/mech_construct.dmi'
	icon_state = "blank"
	abstract_type = /obj/item/mecha_parts
	w_class = WEIGHT_CLASS_GIGANTIC
	obj_flags = CONDUCTS_ELECTRICITY
	sound_vary = TRUE
	pickup_sound = SFX_GENERIC_DEVICE_PICKUP
	drop_sound = SFX_GENERIC_DEVICE_DROP

/obj/item/mecha_parts/proc/try_attach_part(mob/user, obj/vehicle/sealed/mecha/M, attach_right = FALSE) //For attaching parts to a finished mech
	if(!user.transferItemToLoc(src, M))
		to_chat(user, span_warning("\The [src] 粘在了你手上，你无法把它放进\the [M]！"))
		return ITEM_INTERACT_BLOCKING
	user.visible_message(span_notice("[user] 将 [src] 安装到 [M] 上。"), span_notice("你将[src]安装到[M]上。"))
	return ITEM_INTERACT_SUCCESS

/obj/item/mecha_parts/part/try_attach_part(mob/user, obj/vehicle/sealed/mecha/M, attach_right = FALSE)
	return ITEM_INTERACT_SUCCESS

/obj/item/mecha_parts/chassis
	name = "机甲底盘"
	icon_state = "backbone"
	interaction_flags_item = NONE //Don't pick us up!!
	var/construct_type

/obj/item/mecha_parts/chassis/Initialize(mapload)
	. = ..()
	if(construct_type)
		AddComponent(construct_type)

/////////// Ripley

/obj/item/mecha_parts/chassis/ripley
	name = "\improper Ripley-雷普利 骨架"
	construct_type = /datum/component/construction/unordered/mecha_chassis/ripley

/obj/item/mecha_parts/part/ripley_torso
	name = "\improper Ripley-雷普利 躯干"
	desc = "Ripley APLU的躯干部件.包含了动力单元，处理核心和生命支持系统."
	icon_state = "ripley_harness"

/obj/item/mecha_parts/part/ripley_left_arm
	name = "\improper Ripley-雷普利 左臂"
	desc = "Ripley APLU的左臂部件.数据和电源接口与大部分机甲设备兼容."
	icon_state = "ripley_l_arm"

/obj/item/mecha_parts/part/ripley_right_arm
	name = "\improper Ripley-雷普利 右臂"
	desc = "Ripley APLU的右臂部件.数据和电源接口与大部分机甲设备兼容."
	icon_state = "ripley_r_arm"

/obj/item/mecha_parts/part/ripley_left_leg
	name = "\improper Ripley-雷普利 左腿"
	desc = "Ripley APLU的左腿部件.含有一些复杂的伺服驱动和平衡控制系统."
	icon_state = "ripley_l_leg"

/obj/item/mecha_parts/part/ripley_right_leg
	name = "\improper Ripley-雷普利 右腿"
	desc = "Ripley APLU的右腿部件.含有一些复杂的伺服驱动和平衡控制系统."
	icon_state = "ripley_r_leg"

///////// Odysseus

/obj/item/mecha_parts/chassis/odysseus
	name = "\improper Odysseus-奥德修斯 骨架"
	construct_type = /datum/component/construction/unordered/mecha_chassis/odysseus

/obj/item/mecha_parts/part/odysseus_head
	name = "\improper Odysseus-奥德修斯 头部"
	desc = "奥德修斯的头部。包含一个内置的医疗HUD扫描仪."
	icon_state = "odysseus_head"

/obj/item/mecha_parts/part/odysseus_torso
	name = "\improper Odysseus-奥德修斯 躯干"
	desc="奥德修斯的躯干部件。包含动力单元、处理核心和生命维持系统，以及一个用于安装休眠舱的附加端口。"
	icon_state = "odysseus_torso"

/obj/item/mecha_parts/part/odysseus_left_arm
	name = "\improper Odysseus-奥德修斯 左臂"
	desc = "奥德修斯的左臂部件。数据和电源接口与专用医疗设备兼容."
	icon_state = "odysseus_l_arm"

/obj/item/mecha_parts/part/odysseus_right_arm
	name = "\improper Odysseus-奥德修斯 右臂"
	desc = "奥德修斯的右臂部件。数据和电源接口与专用医疗设备兼容."
	icon_state = "odysseus_r_arm"

/obj/item/mecha_parts/part/odysseus_left_leg
	name = "\improper Odysseus-奥德修斯 左腿"
	desc = "奥德修斯的左腿部件.含有一些复杂的伺服驱动和平衡控制系统能用来稳定转移危重的伤员。"
	icon_state = "odysseus_l_leg"

/obj/item/mecha_parts/part/odysseus_right_leg
	name = "\improper Odysseus-奥德修斯 右腿"
	desc = "奥德修斯的右腿部件.含有一些复杂的伺服驱动和平衡控制系统能用来稳定转移危重的伤员。"
	icon_state = "odysseus_r_leg"

///////// Gygax

/obj/item/mecha_parts/chassis/gygax
	name = "\improper Gygax-吉加斯 骨架"
	construct_type = /datum/component/construction/unordered/mecha_chassis/gygax

/obj/item/mecha_parts/part/gygax_torso
	name = "\improper Gygax-吉加斯 躯干"
	desc = "吉加斯的躯干部件.包含了动力单元，处理核心和生命支持系统."
	icon_state = "gygax_harness"

/obj/item/mecha_parts/part/gygax_head
	name = "\improper Gygax-吉加斯 头部"
	desc = "吉加斯的头部。装配有先进的监视和瞄准传感器."
	icon_state = "gygax_head"

/obj/item/mecha_parts/part/gygax_left_arm
	name = "\improper Gygax-吉加斯 左臂"
	desc = "吉加斯的右臂部件。数据和电源接口与大部分机甲设备和武器兼容."
	icon_state = "gygax_l_arm"

/obj/item/mecha_parts/part/gygax_right_arm
	name = "\improper Gygax-吉加斯 右臂"
	desc = "吉加斯的右臂部件。数据和电源接口与大部分机甲设备和武器兼容."
	icon_state = "gygax_r_arm"

/obj/item/mecha_parts/part/gygax_left_leg
	name = "\improper Gygax-吉加斯 左腿"
	desc = "吉加斯的左腿部件.采用先进的伺服机构和制动器，能够更高速的移动。"
	icon_state = "gygax_l_leg"

/obj/item/mecha_parts/part/gygax_right_leg
	name = "\improper Gygax-吉加斯 右腿"
	desc = "吉加斯的右腿部件.采用先进的伺服机构和制动器，能够更高速的移动。"
	icon_state = "gygax_r_leg"

/obj/item/mecha_parts/part/gygax_armor
	gender = PLURAL
	name = "\improper Gygax-吉加斯 装甲板"
	desc = "一套用于吉加斯的装甲板。设计于使用轻质装甲来有效地偏转损害."
	icon_state = "gygax_armor"


//////////// Durand

/obj/item/mecha_parts/chassis/durand
	name = "\improper Durand-杜兰德 骨架"
	construct_type = /datum/component/construction/unordered/mecha_chassis/durand

/obj/item/mecha_parts/part/durand_torso
	name = "\improper Durand-杜兰德 躯干"
	desc = "杜兰德的躯干部件.坚固的机体保护框架内包含了动力单元，处理核心和生命支持系统."
	icon_state = "durand_harness"

/obj/item/mecha_parts/part/durand_head
	name = "\improper Durand-杜兰德 头部"
	desc = "杜兰德的头部。装配有先进的监视和瞄准传感器."
	icon_state = "durand_head"

/obj/item/mecha_parts/part/durand_left_arm
	name = "\improper Durand-杜兰德 左臂"
	desc = "吉加斯的左臂部件。数据和电源接口与大部分机甲设备和武器兼容.还有威力强大的拳击功能。"
	icon_state = "durand_l_arm"

/obj/item/mecha_parts/part/durand_right_arm
	name = "\improper Durand-杜兰德 右臂"
	desc = "吉加斯的右臂部件。数据和电源接口与大部分机甲设备和武器兼容.还有威力强大的拳击功能。"
	icon_state = "durand_r_arm"

/obj/item/mecha_parts/part/durand_left_leg
	name = "\improper Durand-杜兰德 左腿"
	desc = "杜兰德的左腿部件.特别加固的坚硬部件用于支撑杜兰德的自身重量和满足防御要求."
	icon_state = "durand_l_leg"

/obj/item/mecha_parts/part/durand_right_leg
	name = "\improper Durand-杜兰德 右腿"
	desc = "杜兰德的右腿部件.特别加固的坚硬部件用于支撑杜兰德的自身重量和满足防御要求."
	icon_state = "durand_r_leg"

/obj/item/mecha_parts/part/durand_armor
	gender = PLURAL
	name = "\improper Durand-杜兰德 装甲板"
	desc = "一套用于杜兰德的装甲板。体型笨重无比，用于抵挡难以置信的火力攻击."
	icon_state = "durand_armor"

////////// Clarke

/obj/item/mecha_parts/chassis/clarke
	name = "\improper Clarke-克拉克 骨架"
	construct_type = /datum/component/construction/unordered/mecha_chassis/clarke

/obj/item/mecha_parts/part/clarke_torso
	name = "\improper Clarke-克拉克 躯干"
	desc = "克拉克的躯干部件.包含了动力单元，处理核心和生命支持系统."
	icon_state = "clarke_harness"

/obj/item/mecha_parts/part/clarke_head
	name = "\improper Clarke-克拉克 头部"
	desc = "奥德修斯的头部。包含一个内置的诊断HUD扫描仪."
	icon_state = "clarke_head"

/obj/item/mecha_parts/part/clarke_left_arm
	name = "\improper Clarke-克拉克 左臂"
	desc = "克拉克的左臂部件.数据和电源接口与大部分机甲设备兼容."
	icon_state = "clarke_l_arm"

/obj/item/mecha_parts/part/clarke_right_arm
	name = "\improper Clarke-克拉克 右臂"
	desc = "克拉克的右臂部件.数据和电源接口与大部分机甲设备兼容."
	icon_state = "clarke_r_arm"

////////// HONK

/obj/item/mecha_parts/chassis/honker
	name = "\improper H.O.N.K 骨架"
	construct_type = /datum/component/construction/unordered/mecha_chassis/honker

/obj/item/mecha_parts/part/honker_torso
	name = "\improper H.O.N.K 躯干"
	desc = "躯干部分的H.O.N.K.包含笑声装置，香蕉核心和HONK支持系统。"
	icon_state = "honker_harness"

/obj/item/mecha_parts/part/honker_head
	name = "\improper H.O.N.K 头部"
	desc = "H.O.N.K 的头，看起来没有安装面罩。"
	icon_state = "honker_head"

/obj/item/mecha_parts/part/honker_left_arm
	name = "\improper H.O.N.K 左臂"
	desc = "这是H.O.N.K 左臂。其独特的安装孔可以装载小丑科学家们设计的各种奇特武器。"
	icon_state = "honker_l_arm"

/obj/item/mecha_parts/part/honker_right_arm
	name = "\improper H.O.N.K 右臂"
	desc = "这是H.O.N.K 右臂。其独特的安装孔可以装载小丑科学家们设计的各种奇特武器。"
	icon_state = "honker_r_arm"

/obj/item/mecha_parts/part/honker_left_leg
	name = "\improper H.O.N.K 左腿"
	desc = "这是H.O.N.K的左腿，脚恰到好处刚好穿进小丑鞋。"
	icon_state = "honker_l_leg"

/obj/item/mecha_parts/part/honker_right_leg
	name = "\improper H.O.N.K 右腿"
	desc = "这是H.O.N.K的右腿，脚恰到好处刚好穿进小丑鞋。"
	icon_state = "honker_r_leg"


////////// Phazon

/obj/item/mecha_parts/chassis/phazon
	name = "\improper Phazon-法宗 骨架"
	construct_type = /datum/component/construction/unordered/mecha_chassis/phazon

/obj/item/mecha_parts/part/phazon_torso
	name="\improper 相位机甲躯干"
	desc="一个相位机甲躯干部件。为外骨骼独特的相位驱动器供能的灵质核心插槽位于中部。"
	icon_state = "phazon_harness"

/obj/item/mecha_parts/part/phazon_head
	name="\improper 相位机甲头部"
	desc="一个相位机甲头部。其传感器经过精心校准，即使在外骨骼相位移动时也能提供视觉和数据。"
	icon_state = "phazon_head"

/obj/item/mecha_parts/part/phazon_left_arm
	name="\improper 相位机甲左臂"
	desc="一个相位机甲左臂。装甲板下设有数个微工具阵列，可根据当前情况进行调整。"
	icon_state = "phazon_l_arm"

/obj/item/mecha_parts/part/phazon_right_arm
	name="\improper 相位机甲右臂"
	desc="一个相位机甲右臂。装甲板下设有数个微工具阵列，可根据当前情况进行调整。"
	icon_state = "phazon_r_arm"

/obj/item/mecha_parts/part/phazon_left_leg
	name="\improper 相位机甲左腿"
	desc="一个相位机甲左腿。内含独特的相位驱动器，启动时可使外骨骼穿过固体物质。"
	icon_state = "phazon_l_leg"

/obj/item/mecha_parts/part/phazon_right_leg
	name="\improper 相位机甲右腿"
	desc="一个相位机甲右腿。内含独特的相位驱动器，启动时可使外骨骼穿过固体物质。"
	icon_state = "phazon_r_leg"

/obj/item/mecha_parts/part/phazon_armor
	name="相位机甲装甲"
	desc="相位机甲装甲板。它们覆有等离子层以保护驾驶员免受相位移动的压力，并具有不寻常的特性。"
	icon_state = "phazon_armor"

// Savannah-Ivanov

/obj/item/mecha_parts/chassis/savannah_ivanov
	name = "\improper Savannah-Ivanov 萨凡纳-伊万诺夫 骨架"
	construct_type = /datum/component/construction/unordered/mecha_chassis/savannah_ivanov

/obj/item/mecha_parts/part/savannah_ivanov_torso
	name="\improper 萨凡纳-伊万诺夫躯干"
	desc="一个萨凡纳-伊万诺夫躯干部件。它缺失了一大块空间……"
	icon_state = "savannah_ivanov_harness"

/obj/item/mecha_parts/part/savannah_ivanov_head
	name="\improper 萨凡纳-伊万诺夫头部"
	desc="一个萨凡纳-伊万诺夫头部。其传感器已调整为支持平稳着陆。"
	icon_state = "savannah_ivanov_head"

/obj/item/mecha_parts/part/savannah_ivanov_left_arm
	name="\improper 萨凡纳-伊万诺夫左臂"
	desc="一个萨凡纳-伊万诺夫左臂。手腕处包含隐藏的火箭制造装置。"
	icon_state = "savannah_ivanov_l_arm"

/obj/item/mecha_parts/part/savannah_ivanov_right_arm
	name="\improper 萨凡纳-伊万诺夫右臂"
	desc="一个萨凡纳-伊万诺夫左臂。手腕处包含隐藏的火箭制造装置。"
	icon_state = "savannah_ivanov_r_arm"

/obj/item/mecha_parts/part/savannah_ivanov_left_leg
	name="\improper 萨凡纳-伊万诺夫左腿"
	desc="一个萨凡纳-伊万诺夫左腿。在生产设计中，它们被用来承载超过两名乘客，因此添加了跳跃功能以避免浪费潜力。"
	icon_state = "savannah_ivanov_l_leg"

/obj/item/mecha_parts/part/savannah_ivanov_right_leg
	name="\improper 萨凡纳-伊万诺夫右腿"
	desc="一个萨凡纳-伊万诺夫左腿。在生产设计中，它们被用来承载超过两名乘客，因此添加了跳跃功能以避免浪费潜力。"
	icon_state = "savannah_ivanov_r_leg"

/obj/item/mecha_parts/part/savannah_ivanov_armor
	name="萨凡纳-伊万诺夫装甲"
	desc="萨凡纳-伊万诺夫装甲板。它们具有独特的形状和加固设计，以应对两名驾驶员、大幅跳跃和导弹带来的压力。"
	icon_state = "savannah_ivanov_armor"

///////// Circuitboards

/obj/item/circuitboard/mecha
	name = "机甲电路板"
	icon = 'icons/obj/devices/circuitry_n_data.dmi'
	icon_state = "std_mod"
	inhand_icon_state = "electronic"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	obj_flags = CONDUCTS_ELECTRICITY
	force = 5
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	throw_speed = 3
	throw_range = 7

/obj/item/circuitboard/mecha/ripley/peripherals
	name = "Ripley-雷普利 外设控制模块（机甲电路板）"
	icon_state = "mcontroller"

/obj/item/circuitboard/mecha/ripley/main
	name = "Ripley-雷普利 中央控制模块（机甲电路板）"
	icon_state = "mainboard"


/obj/item/circuitboard/mecha/gygax/peripherals
	name = "Gygax-吉加斯 外设控制模块（机甲电路板）"
	icon_state = "mcontroller"

/obj/item/circuitboard/mecha/gygax/targeting
	name = "Gygax-吉加斯 武器控制和瞄准模块（机甲电路板）"
	icon_state = "mcontroller"

/obj/item/circuitboard/mecha/gygax/main
	name = "Gygax-吉加斯 中央控制模块（机甲电路板）"
	icon_state = "mainboard"

/obj/item/circuitboard/mecha/durand/peripherals
	name = "Durand-杜兰德 外设控制模块（机甲电路板）"
	icon_state = "mcontroller"

/obj/item/circuitboard/mecha/durand/targeting
	name = "Durand-杜兰德 武器控制和瞄准模块（机甲电路板）"
	icon_state = "mcontroller"

/obj/item/circuitboard/mecha/durand/main
	name = "Durand-杜兰德 中央控制模块（机甲电路板）"
	icon_state = "mainboard"

/obj/item/circuitboard/mecha/honker/peripherals
	name = "H.O.N.K 外设控制模块（机甲电路板）"
	icon_state = "mcontroller"

/obj/item/circuitboard/mecha/honker/targeting
	name = "H.O.N.K 武器控制和瞄准模块（机甲电路板）"
	icon_state = "mcontroller"

/obj/item/circuitboard/mecha/honker/main
	name = "H.O.N.K 中央控制模块（机甲电路板）"
	icon_state = "mainboard"

/obj/item/circuitboard/mecha/odysseus/peripherals
	name = "Odysseus-奥德修斯 外设控制模块（机甲电路板）"
	icon_state = "mcontroller"

/obj/item/circuitboard/mecha/odysseus/main
	name = "Odysseus-奥德修斯 中央控制模块（机甲电路板）"
	icon_state = "mainboard"

/obj/item/circuitboard/mecha/phazon/peripherals
	name = "Phazon-法宗 外设控制模块（机甲电路板）"
	icon_state = "mcontroller"

/obj/item/circuitboard/mecha/phazon/targeting
	name = "Phazon-法宗 武器控制和瞄准模块（机甲电路板）"
	icon_state = "mcontroller"

/obj/item/circuitboard/mecha/phazon/main
	name = "Phazon-法宗 中央控制模块（机甲电路板）"

/obj/item/circuitboard/mecha/clarke/peripherals
	name = "Clarke-克拉克 外设控制模块（机甲电路板）"
	icon_state = "mcontroller"

/obj/item/circuitboard/mecha/clarke/main
	name = "Clarke-克拉克 中央控制模块（机甲电路板）"
	icon_state = "mainboard"

/obj/item/circuitboard/mecha/savannah_ivanov/peripherals
	name = "Savannah-萨凡纳 外设控制模块（机甲电路板）"
	icon_state = "mcontroller"

/obj/item/circuitboard/mecha/savannah_ivanov/targeting
	name = "Ivanov-伊万诺夫 武器控制和瞄准模块（机甲电路板）"
	icon_state = "mcontroller"

/obj/item/circuitboard/mecha/savannah_ivanov/main
	name = "Savannah-Ivanov-萨凡纳-伊万诺夫 组合控制锁定模块（机甲电路板）"
	icon_state = "mainboard"
