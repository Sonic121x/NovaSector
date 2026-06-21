//Gun crafting parts til they can be moved elsewhere

// PARTS //
/obj/item/weaponcrafting
	abstract_type = /obj/item/weaponcrafting

/obj/item/weaponcrafting/Initialize(mapload)
	. = ..()
	create_slapcraft_component()

/obj/item/weaponcrafting/proc/create_slapcraft_component()
	return

/obj/item/weaponcrafting/receiver
	name = "模块化枪机"
	desc = "一个用于枪械的原型模块化枪机和扳机组件。"
	icon = 'icons/obj/weapons/improvised.dmi'
	icon_state = "receiver"
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5.5, /datum/material/cardboard = SHEET_MATERIAL_AMOUNT)

/obj/item/weaponcrafting/receiver/create_slapcraft_component()
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/pipegun)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/weaponcrafting/stock
	name = "步枪枪托"
	desc = "一个经典的步枪枪托，兼作握把，由木头粗略雕刻而成。"
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 8)
	resistance_flags = FLAMMABLE
	icon = 'icons/obj/weapons/improvised.dmi'
	icon_state = "riflestock"

/obj/item/weaponcrafting/stock/create_slapcraft_component()
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/smoothbore_disabler, /datum/crafting_recipe/laser_musket)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/weaponcrafting/giant_wrench
	name = "大拍子零件套件"
	desc = "制造俗称“大拍子”的巨型扳手的非法零件。"
	icon = 'icons/obj/weapons/improvised.dmi'
	icon_state = "weaponkit_gw"

/obj/item/weaponcrafting/giant_wrench/create_slapcraft_component() // slappycraft
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/giant_wrench)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

///These gun kits are printed from the security protolathe to then be used in making new weapons

// GUN PART KIT //

/obj/item/weaponcrafting/gunkit // These don't get a slapcraft component, it's added to the gun - more intuitive player-facing to slap the kit onto the gun.
	name = "通用枪械零件套件"
	desc = "这是个空的枪械零件容器！你为什么会有这个？"
	icon = 'icons/obj/weapons/improvised.dmi'
	icon_state = "kitsuitcase"

/obj/item/weaponcrafting/gunkit/nuclear
	name = "高级能量枪零件套件（致命/非致命）"
	desc = "一个手提箱，内含将标准能量枪改装为高级能量枪所需的枪械零件。"
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT,
		/datum/material/uranium = SHEET_MATERIAL_AMOUNT * 1.5,
		/datum/material/titanium = HALF_SHEET_MATERIAL_AMOUNT,
	)

/obj/item/weaponcrafting/gunkit/tesla
	name = "特斯拉炮零件套件（致命）"
	desc = "一个手提箱，内含围绕稳定通量异常构建特斯拉炮所需的枪械零件。小心处理。"
	icon_state = "weaponskit_tesla"
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5, /datum/material/glass = SHEET_MATERIAL_AMOUNT * 5, /datum/material/silver = SHEET_MATERIAL_AMOUNT * 5)

/obj/item/weaponcrafting/gunkit/xray
	name = "X射线激光枪零件套件（致命）"
	desc = "一个手提箱，内含将激光枪改装为X射线激光枪所需的枪械零件。请勿将大部分零件直接对准面部。"
	custom_materials = list(
		/datum/material/gold = SHEET_MATERIAL_AMOUNT * 2.5,
		/datum/material/uranium = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2.5,
		/datum/material/titanium = SHEET_MATERIAL_AMOUNT,
		/datum/material/bluespace = SHEET_MATERIAL_AMOUNT,
	)

/obj/item/weaponcrafting/gunkit/ion
	name = "离子卡宾枪零件套件（非致命/高破坏性/对硅基生命体非常致命）"
	desc = "一个手提箱，内含将标准激光枪改装为离子卡宾枪所需的枪械零件。对付你没有权限的储物柜再合适不过了。"
	custom_materials = list(/datum/material/silver = SHEET_MATERIAL_AMOUNT * 3, /datum/material/iron = SHEET_MATERIAL_AMOUNT * 4, /datum/material/uranium = SHEET_MATERIAL_AMOUNT)

/obj/item/weaponcrafting/gunkit/temperature
	name = "温度枪零件套件（低致命性/对蜥蜴人非常致命）"
	desc = "一个手提箱，内含将标准能量枪改装为温度枪所需的枪械零件。在生日派对和消灭蜥蜴人土著居民方面效果极佳。"
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 5, /datum/material/silver = SHEET_MATERIAL_AMOUNT * 1.5)

/obj/item/weaponcrafting/gunkit/beam_rifle
	name = "\improper 事件视界反存在光束步枪零件套件（末日装置，请勿制造）"
	desc = "是怎样的狂热头脑造就了这可怕的构造套件？是为了创造一个框架来驾驭那些流经旋臂星区的奇异能量，并将其导向如此可怕的暴力行径吗？"
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/glass =SHEET_MATERIAL_AMOUNT * 2.5,
		/datum/material/diamond = SHEET_MATERIAL_AMOUNT * 2.5,
		/datum/material/uranium = SHEET_MATERIAL_AMOUNT * 4,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 2.25,
		/datum/material/gold = SHEET_MATERIAL_AMOUNT * 2.5,
	)

/obj/item/weaponcrafting/gunkit/ebow
	name = "能量弩零件套件（非致命）"
	desc = "高度非法的武器翻新套件，可将标准原动加速器改造成近乎复刻的能量弩。几乎和真品一样！"
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2.5,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT * 1.5,
		/datum/material/uranium = HALF_SHEET_MATERIAL_AMOUNT * 1.5,
		/datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT * 1.5,
	)

/obj/item/weaponcrafting/gunkit/hellgun
	name = "地狱火激光枪劣化套件（战争罪行级致命）"
	desc = "拿一把功能完好的激光枪。粗暴地改造枪械内部，让它运行得更热更凶残。现在你得到了一把地狱火激光枪。你这个怪物。"

/obj/item/weaponcrafting/gunkit/photon
	name = "光子炮零件套件（非致命）"
	desc = "一个手提箱，内含围绕稳定通量异常构建光子炮所需的枪械零件。将太阳的力量，掌握在你的掌心。"
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 3, /datum/material/glass = SHEET_MATERIAL_AMOUNT * 7, /datum/material/gold = SHEET_MATERIAL_AMOUNT * 5)

/obj/item/weaponcrafting/gunkit/sks
	name = "\improper 萨赫诺SKS半自动步枪零件套件（致命）"
	desc = "一个手提箱，内含构建萨赫诺SKS半自动步枪所需的枪械零件。这些东西在边疆世界随处可见。"
