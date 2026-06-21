/datum/design/beanbag_slug
	name = "豆袋弹（低致命性）"
	id = "beanbag_slug"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 3)
	build_path = /obj/item/ammo_casing/shotgun/beanbag
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/rubbershot
	name = "橡胶弹（低致命性）"
	id = "rubber_shot"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 3)
	build_path = /obj/item/ammo_casing/shotgun/rubbershot
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/c38
	name = "快速装弹器（.38）（致命）"
	id = "c38"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*3)
	build_path = /obj/item/ammo_box/speedloader/c38
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/recorder
	name = "通用记录仪"
	id = "recorder"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*0.6, /datum/material/glass = SMALL_MATERIAL_AMOUNT*0.3)
	build_path = /obj/item/taperecorder/empty
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SECURITY,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/tape
	name = "通用记录仪磁带"
	id = "tape"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*0.2, /datum/material/glass = SMALL_MATERIAL_AMOUNT*0.2)
	build_path = /obj/item/tape/random
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SECURITY,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/foam_dart
	name = "泡沫飞镖盒（无害）"
	id = "foam_dart"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/ammo_box/foambox
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/flamethrower
	name = "火焰喷射器（致命/高破坏性）"
	id = "flamethrower"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/flamethrower/full
	category = list(
		RND_CATEGORY_HACKED,
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_RANGED,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/electropack
	name = "电击项圈"
	id = "electropack"
	build_type = AUTOLATHE | PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*5, /datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT*2.5)
	build_path = /obj/item/electropack
	category = list(
		RND_CATEGORY_HACKED,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SECURITY,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/handcuffs
	name = "手铐"
	id = "handcuffs"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT*5)
	build_path = /obj/item/restraints/handcuffs
	category = list(
		RND_CATEGORY_HACKED,
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SECURITY,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/handcuffs/sec
	id = "handcuffs_s"
	build_type = PROTOLATHE | AWAY_LATHE
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SECURITY,
	)
	autolathe_exportable = FALSE

/datum/design/receiver
	name = "模块化接收器"
	id = "receiver"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*7.5)
	build_path = /obj/item/weaponcrafting/receiver
	category = list(
		RND_CATEGORY_HACKED,
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_PARTS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/shotgun_dart
	name = "霰弹枪镖弹（致命）"
	id = "shotgun_dart"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 3)
	build_path = /obj/item/ammo_casing/shotgun/dart
	category = list(
		RND_CATEGORY_HACKED,
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/incendiary_slug
	name = "燃烧独头弹（致命）"
	id = "incendiary_slug"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 3)
	build_path = /obj/item/ammo_casing/shotgun/incendiary
	category = list(
		RND_CATEGORY_HACKED,
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/riot_dart
	name = "泡沫防暴镖弹（非致命）"
	id = "riot_dart"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT) //Discount for making individually - no box = less iron!
	build_path = /obj/item/ammo_casing/foam_dart/riot
	category = list(
		RND_CATEGORY_HACKED,
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/riot_darts
	name = "泡沫防暴镖弹盒（非致命）"
	id = "riot_darts"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*25) //Comes with 40 darts
	build_path = /obj/item/ammo_box/foambox/riot
	category = list(
		RND_CATEGORY_HACKED,
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/a357
	name = ".357弹壳（极高致命性）"
	id = "a357"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 3)
	build_path = /obj/item/ammo_casing/c357
	category = list(
		RND_CATEGORY_HACKED,
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/strilka310_surplus
	name = ".310剩余子弹弹壳（极高致命性）"
	id = "strilka310_surplus"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 3)
	build_path = /obj/item/ammo_casing/strilka310/surplus
	category = list(
		RND_CATEGORY_HACKED,
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/c10mm
	name = "弹药盒（10毫米）（致命）"
	id = "c10mm"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT * 300)
	build_path = /obj/item/ammo_box/c10mm
	category = list(
		RND_CATEGORY_HACKED,
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/c45
	name = "弹药盒（.45）（致命）"
	id = "c45"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT * 300)
	build_path = /obj/item/ammo_box/c45
	category = list(
		RND_CATEGORY_HACKED,
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/c9mm
	name = "弹药盒（9毫米）（致命）"
	id = "c9mm"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT * 300)
	build_path = /obj/item/ammo_box/c9mm
	category = list(
		RND_CATEGORY_HACKED,
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/telescreen_interrogation
	name = "审讯用远程屏幕"
	id = "telescreen_interrogation"
	build_type = PROTOLATHE
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT*5,
		/datum/material/glass =SHEET_MATERIAL_AMOUNT * 2.5,
	)
	build_path = /obj/item/wallframe/telescreen/interrogation
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MOUNTS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/telescreen_prison
	name = "监狱用远程屏幕"
	id = "telescreen_prison"
	build_type = PROTOLATHE
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT*5,
		/datum/material/glass =SHEET_MATERIAL_AMOUNT * 2.5,
	)
	build_path = /obj/item/wallframe/telescreen/prison
	category = list(
		RND_CATEGORY_INITIAL,
		RND_CATEGORY_CONSTRUCTION + RND_SUBCATEGORY_CONSTRUCTION_MOUNTS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY
