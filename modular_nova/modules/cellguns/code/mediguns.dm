// Base medigun code
/obj/item/gun/energy/cell_loaded/medigun
	name = "\improper 医疗枪"
	desc = "这是我的智能枪。它不会伤害任何友善目标；事实上，它会治疗他们！如果你以某种方式获得了这把枪，请告知GitHub。"
	icon = 'modular_nova/modules/cellguns/icons/obj/guns/mediguns/projectile.dmi'
	icon_state = "medigun"
	inhand_icon_state = "chronogun" // Fits best with how the medigun looks, might be changed in the future
	abstract_type = /obj/item/gun/energy/cell_loaded/medigun
	ammo_type = list(/obj/item/ammo_casing/energy/medical) // The default option that heals oxygen
	w_class = WEIGHT_CLASS_NORMAL
	cell_type = /obj/item/stock_parts/power_store/cell/medigun
	modifystate = 1
	ammo_x_offset = 3
	charge_sections = 3
	maxcells = 3
	allowed_cells = list(/obj/item/weaponcell/medical)
	item_flags = null
	gun_flags = TURRET_INCOMPATIBLE

/obj/item/gun/energy/cell_loaded/medigun/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/manufacturer_examine, COMPANY_VEYMED)

// Standard medigun - this is what you will get from Cargo, most likely.
/obj/item/gun/energy/cell_loaded/medigun/standard
	name = "\improper Vey-Medical CWM-479 单元驱动医疗枪"
	desc = "这是Vey-Med为在非理想场景下治疗而生产的标准型号医疗枪。其弹仓额定可容纳三个医疗单元。"

// Upgraded medigun
/obj/item/gun/energy/cell_loaded/medigun/upgraded
	name = "\improper Vey-Medical CWM-479-FC 单元驱动医疗枪"
	desc = "这是标准CWM-479医疗枪的升级型号。其弹仓经过扩容，可容纳额外的医疗单元，并配备了更大、充电更快的电池。"
	cell_type = /obj/item/stock_parts/power_store/cell/medigun/upgraded
	maxcells = 4

/obj/item/gun/energy/cell_loaded/medigun/upgraded/Initialize(mapload)
	. = ..()
	var/mutable_appearance/fastcharge_medigun = mutable_appearance('modular_nova/modules/cellguns/icons/obj/guns/mediguns/projectile.dmi', "medigun_fastcharge")
	add_overlay(fastcharge_medigun)

// CMO and CC MediGun
/obj/item/gun/energy/cell_loaded/medigun/cmo
	name = "\improper Vey-Medical CWM-479-CC 单元供能医疗枪"
	desc = "这是CWM-479系列医疗枪中最先进的型号。它拥有五个医疗单元插槽，并配备了Vey-Med生产的最大的电池。"
	cell_type = /obj/item/stock_parts/power_store/cell/medigun/experimental
	maxcells = 5
	selfcharge = 1
	can_charge = FALSE

/obj/item/gun/energy/cell_loaded/medigun/cmo/Initialize(mapload)
	. = ..()
	var/mutable_appearance/cmo_medigun = mutable_appearance('modular_nova/modules/cellguns/icons/obj/guns/mediguns/projectile.dmi', "medigun_cmo")
	add_overlay(cmo_medigun)

// Medigun power cells
/obj/item/stock_parts/power_store/cell/medigun // This is the cell that mediguns from cargo will come with
	name = "基础医疗枪单元"
	maxcharge = STANDARD_CELL_CHARGE * 1.2
	emp_damage_modifier = 5

/obj/item/stock_parts/power_store/cell/medigun/upgraded
	name = "升级型医疗枪单元"
	maxcharge = STANDARD_CELL_CHARGE * 1.5
	chargerate = STANDARD_CELL_CHARGE * 0.1

/obj/item/stock_parts/power_store/cell/medigun/experimental // This cell type is meant to be used in self charging mediguns like CMO and ERT one.
	name = "实验型医疗枪单元"
	maxcharge = STANDARD_CELL_CHARGE * 1.8
	chargerate = STANDARD_CELL_CHARGE * 0.1

// End of power cells

//Medigun lore
/obj/item/gun/energy/cell_loaded/medigun/add_deep_lore()
	AddElement(/datum/element/examine_lore, \
		lore_hint = span_notice("你可以 [EXAMINE_HINT("look closer")] 来了解更多关于 [src] 的信息。"), \
		lore = "The Vey-Medical CWM-479 line of mediguns is widely considered the foothold that brought the medical titan into \
			the niche where it is today, opening many lucrative doors for the continued development of luxury medical equipment.<br>\
			<br>\
			Although hard to imagine, Vey-Med's entrance into the corporate scene would be a shaky one, immediately facing pressure from \
			larger, more established groups like Zeng-Hu who boasted similar products for less. Things looked bleak financially until the \
			first sightings of handheld medical beamguns in the grips of Syndicate-backed mercenaries would shake the industry dramatically. \
			It's here that Nanotrasen themselves would enter the picture, poising themselves as angel investors to the fledgling company as long as \
			they could reproduce the technology for their own use, something that was accepted with open arms and bank accounts. <br>\
			<br>\
			In the following time, Vey-Med would enjoy otherwise smooth progress in trying to reverse-engineer captured devices, but would be \
			interrupted by a major roadblock. The energy throughput of anything less than some sort of mechanized suit prevented miniaturization \
			of the nanite stream for their research team. Frustrated, they decided on a radical rethinking of the concept: what if they harnessed the \
			body's natural energy to heal? <br>\
			<br>\
			By using a lower amount of energy and many proprietary principles, a CWM medigun can stimulate a patient's natural healing factor by \
			a factor of at least 7 times in an instant, far outpacing the gradual healing that they initially set out to achieve. Unfortunately, the \
			overloading of natural processes means that the device is prone to inducing superficial sickness when used carelessly on those with \
			less-than-ideal lifestyles. Despite this, many, from insane Solarian field doctors to remote colonial hospitals, would eagerly pay \
			the exorbitant price for the CWM-479, and Vey-Med is more than happy to provide it." \
	)

// Upgrade Kit
/obj/item/device/custom_kit/medigun_fastcharge
	name = "Vey-Medical CWM-479 升级套件"
	desc = "升级医疗枪的内部电池，以实现更快的充电速度、一个额外的医疗单元插槽以及更高的电池容量。升级前需先取出医疗枪内的所有单元！"
	// don't tinker with a loaded (medi)gun. fool
	from_obj = /obj/item/gun/energy/cell_loaded/medigun/standard
	to_obj = /obj/item/gun/energy/cell_loaded/medigun/upgraded

/obj/item/device/custom_kit/medigun_fastcharge/pre_convert_check(obj/target_obj, mob/user)
	var/obj/item/gun/energy/cell_loaded/medigun/standard/our_medigun = target_obj
	if(length(our_medigun.installedcells))
		balloon_alert(user, "先把它卸下来！")
		return FALSE
	return TRUE

// Medigun wiki book
/obj/item/book/manual/wiki/mediguns
	name = "医疗枪操作手册"
	icon = 'modular_nova/modules/cellguns/icons/obj/guns/mediguns/misc.dmi'
	icon_state = "manual"
	starting_author = "Vey-Medical"
	starting_title = "Medigun Operating Manual"
	page_link = "Guide_to_Mediguns"

// Medigun Gunsets
/obj/item/storage/briefcase/medicalgunset
	name = "医疗枪补给套件"
	desc = "一个医疗枪的补给套件。"
	icon = 'modular_nova/modules/cellguns/icons/obj/guns/mediguns/misc.dmi'
	icon_state = "case_standard"
	inhand_icon_state = "lockbox"
	lefthand_file = 'icons/mob/inhands/equipment/briefcase_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/briefcase_righthand.dmi'
	drop_sound = 'sound/items/handling/ammobox_drop.ogg'
	pickup_sound =  'sound/items/handling/ammobox_pickup.ogg'

/obj/item/storage/briefcase/medicalgunset/standard
	name = "Vey-Medical CWM-479 单元供能医疗枪箱"
	desc = "一个装有CWM-479医疗枪和说明手册的公文箱。"

/obj/item/storage/briefcase/medicalgunset/standard/PopulateContents()
	new /obj/item/gun/energy/cell_loaded/medigun/standard(src)
	new /obj/item/book/manual/wiki/mediguns(src)

/obj/item/storage/briefcase/medicalgunset/cmo
	name = "Vey-Medical CWM-479-CC 单元供能医疗枪箱"
	desc = "一个装有实验型CWM-479-CC医疗枪、一套三枚基础医疗枪单元和一本说明手册的公文箱。"
	icon_state = "case_cmo"

/obj/item/storage/briefcase/medicalgunset/cmo/PopulateContents()
	new /obj/item/gun/energy/cell_loaded/medigun/cmo(src)
	new /obj/item/weaponcell/medical/brute(src)
	new /obj/item/weaponcell/medical/burn(src)
	new /obj/item/weaponcell/medical/toxin(src)
	new /obj/item/book/manual/wiki/mediguns(src)

/*
* Medigun Cells - Spritework is done by Arctaisia!
*/

// Default Cell
/obj/item/weaponcell/medical
	name = "默认医疗单元"
	desc = "标准的氧气单元。大多数枪械出厂时已预装此单元。"
	icon = 'modular_nova/modules/cellguns/icons/obj/guns/mediguns/medicells.dmi'
	icon_state = "Oxy1"
	w_class = WEIGHT_CLASS_SMALL
	ammo_type = /obj/item/ammo_casing/energy/medical // This is the ammo type that all mediguns come with.
	medicell_examine = TRUE

/obj/item/weaponcell/medical/oxygen
	name = "氧气 I 型医疗电池"
	desc = "一个散发着微弱蓝光的小型电池。可用于医疗枪，以启用基础缺氧治疗功能。"

/*
* Tier I cells
*/

// Brute I
/obj/item/weaponcell/medical/brute
	name = "钝伤 I 型医疗电池"
	desc = "一个散发着微弱红光的小型电池。可用于医疗枪，以启用基础钝伤治疗功能。"
	icon_state = "Brute1"
	ammo_type = /obj/item/ammo_casing/energy/medical/brute1

// Burn I
/obj/item/weaponcell/medical/burn
	name = "烧伤 I 型医疗电池"
	desc = "一个散发着微弱黄光的小型电池。可用于医疗枪，以启用基础烧伤治疗功能。"
	icon_state = "Burn1"
	ammo_type = /obj/item/ammo_casing/energy/medical/burn1

/obj/item/weaponcell/medical/toxin
	name = "毒素 I 型医疗电池"
	desc = "一个散发着微弱绿光的小型电池。可用于医疗枪，以启用基础毒素伤害治疗功能。"
	icon_state = "Toxin1"
	ammo_type = /obj/item/ammo_casing/energy/medical/toxin1

/*
* Tier II Cells
*/

// Brute II
/obj/item/weaponcell/medical/brute/tier_2
	name = "钝伤 II 型医疗电池"
	desc = "一个散发着明显红光的小型电池。可用于医疗枪，以启用改进的钝伤治疗功能。"
	icon_state = "Brute2"
	ammo_type = /obj/item/ammo_casing/energy/medical/brute2

// Burn II
/obj/item/weaponcell/medical/burn/tier_2
	name = "烧伤 II 型医疗电池"
	desc = "一个散发着明显黄光的小型电池。可用于医疗枪，以启用改进的烧伤治疗功能。"
	icon_state = "Burn2"
	ammo_type = /obj/item/ammo_casing/energy/medical/burn2

// Toxin II
/obj/item/weaponcell/medical/toxin/tier_2
	name = "毒素 II 型医疗电池"
	desc = "一个散发着明显绿光的小型电池。可用于医疗枪，以启用改进的毒素伤害治疗功能。"
	icon_state = "Toxin2"
	ammo_type = /obj/item/ammo_casing/energy/medical/toxin2

// Oxygen II
/obj/item/weaponcell/medical/oxygen/tier_2
	name = "氧气 II 型医疗电池"
	desc = "一个散发着明显蓝光的小型电池。可用于医疗枪，以启用改进的缺氧治疗功能。"
	icon_state = "Oxy2"
	ammo_type = /obj/item/ammo_casing/energy/medical/oxy2

/*
* Tier III Cells
*/

// Brute III
/obj/item/weaponcell/medical/brute/tier_3
	name = "钝伤 III 型医疗电池"
	desc = "一个散发着强烈红光并带有加固外壳的小型电池。可用于医疗枪，以启用高级钝伤治疗功能。"
	icon_state = "Brute3"
	ammo_type = /obj/item/ammo_casing/energy/medical/brute3

// Burn III
/obj/item/weaponcell/medical/burn/tier_3
	name = "烧伤 III 型医疗电池"
	desc = "一个散发着强烈黄光并带有加固外壳的小型电池。可用于医疗枪，以启用高级烧伤治疗功能。"
	icon_state = "Burn3"
	ammo_type = /obj/item/ammo_casing/energy/medical/burn3

// Toxin III
/obj/item/weaponcell/medical/toxin/tier_3
	name = "毒素 III 型医疗单元"
	desc = "一个发出强烈绿光、外壳加固的小型单元。可用于医疗枪，以启用高级毒素伤害治疗功能。"
	icon_state = "Toxin3"
	ammo_type = /obj/item/ammo_casing/energy/medical/toxin3

// Oxygen III
/obj/item/weaponcell/medical/oxygen/tier_3
	name = "氧气 III 型医疗单元"
	desc = "一个发出强烈蓝光、外壳加固的小型单元。可用于医疗枪，以启用高级缺氧治疗功能。"
	icon_state = "Oxy3"
	ammo_type = /obj/item/ammo_casing/energy/medical/oxy3

/*
* Utility Cells
*/

/obj/item/weaponcell/medical/utility
	name = "通用型医疗单元"
	desc = "你本不该看到这个。如果你看到了，请向你本地的程序员大喊大叫。"

/obj/item/weaponcell/medical/utility/clotting
	name = "凝血医疗单元"
	desc = "一种设计用于帮助处理出血患者的医疗单元。"
	icon_state = "clotting"
	ammo_type = /obj/item/ammo_casing/energy/medical/utility/clotting

/obj/item/weaponcell/medical/utility/temperature
	name = "体温调节医疗单元"
	desc = "一种将患者体温调整到“血液在血管中冻结”和“血液在血管中闪沸”之间理想点的医疗单元。"
	icon_state = "temperature"
	ammo_type = /obj/item/ammo_casing/energy/medical/utility/temperature

/obj/item/weaponcell/medical/utility/hardlight_gown
	name = "硬光手术袍医疗单元"
	desc = "一种在目标身上生成硬光手术袍的医疗单元。"
	icon_state = "gown"
	ammo_type = /obj/item/ammo_casing/energy/medical/utility/gown

/obj/item/weaponcell/medical/utility/salve
	name = "硬光药膏医疗单元"
	desc = "一种向患者施用合成植物物质愈合小球的医疗单元。"
	icon_state = "salve"
	ammo_type = /obj/item/ammo_casing/energy/medical/utility/salve

/obj/item/weaponcell/medical/utility/bed
	name = "硬光担架床医疗单元"
	desc = "一种在已躺在地板上的患者下方召唤临时担架床的医疗单元。"
	icon_state = "gown"
	ammo_type = /obj/item/ammo_casing/energy/medical/utility/bed

/obj/item/weaponcell/medical/utility/body_teleporter
	name = "躯体传送医疗单元"
	desc = "一种允许使用者将一具尸体传送到自己身边的医疗单元。"
	icon_state = "body"
	ammo_type = /obj/item/ammo_casing/energy/medical/utility/body_teleporter

/obj/item/weaponcell/medical/utility/relocation
	name = "压迫性力量转移医疗单元"
	desc = "一种医疗单元，如果由拥有适当权限的人员在适当指定区域（通常是医疗湾）内使用，可在给定宽限期后安全转移人员。"
	icon_state =  "body"
	ammo_type = /obj/item/ammo_casing/energy/medical/utility/relocation/standard

/obj/item/weaponcell/medical/utility/relocation/upgraded
	name = "升级版压迫力场重定位医疗单元"
	desc = "重定位医疗单元的升级版本。它移除了访问权限和区域要求，并禁用了标准的宽限期。"
	ammo_type = /obj/item/ammo_casing/energy/medical/utility/relocation

//Empty Medicell//
/obj/item/device/custom_kit/empty_cell //Having the empty cell as an upgrade kit sounds jank, but it should work well.
	name = "空药膏医疗单元"
	icon = 'modular_nova/modules/cellguns/icons/obj/guns/mediguns/medicells.dmi'
	icon_state = "empty"
	desc = "一个未激活的药膏医疗单元。将其用于芦荟叶上，即可将其制成可用的单元。"
	from_obj = /obj/item/food/grown/aloe
	to_obj = /obj/item/weaponcell/medical/utility/salve

/obj/item/device/custom_kit/empty_cell/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/item_scaling, 0.5, 1)

/obj/item/device/custom_kit/empty_cell/body_teleporter
	name = "空身体传送医疗单元"
	desc = "一个未激活的身体传送医疗单元。将其用于蓝空黏液提取物上，即可将其制成可用的单元。"
	from_obj = /obj/item/slime_extract/bluespace
	to_obj = /obj/item/weaponcell/medical/utility/body_teleporter

/obj/item/device/custom_kit/empty_cell/relocator
	name = "空压迫力场重定位医疗单元"
	desc = "一个未激活的压迫力场重定位医疗单元。将其用于蓝空黏液提取物上，即可将其制成可用的单元。"
	from_obj = /obj/item/slime_extract/bluespace
	to_obj = /obj/item/weaponcell/medical/utility/relocation
