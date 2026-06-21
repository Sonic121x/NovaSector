/datum/design/cyberimp_mantis
	name = "Mantis Blade Implant"
	desc = "A long, sharp, mantis-like blade installed within the forearm, acting as a deadly self defense weapon."
	id = "ci-mantis"
	build_type = MECHFAB
	materials = list (
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT,
	)
	construction_time = 20 SECONDS
	build_path = /obj/item/organ/cyberimp/arm/toolkit/armblade
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_COMBAT,
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/cyberimp_razorwire
	name = "Razorwire Spool Implant"
	desc = "A long length of cutting wire so impossibly thin that it causes grievous wounds in anything you slash with it. \
		It's long enough that you'd probably be able to hit someone with it from a little further away than normal."
	id = "combat_implant_razorwire"
	build_type = MECHFAB
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/gold = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT,
	)
	construction_time = 30 SECONDS
	build_path = /obj/item/organ/cyberimp/arm/toolkit/razorwire
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_COMBAT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/cyberimp_shell_launcher
	name = "Shell Launch System Implant"
	desc = "A complex housing for implanting a shell launch system into an arm. Holds a single shot barrel that can hold either twelve gauge or .980 Tydhouer shells."
	id = "combat_implant_shell_launcher"
	build_type = MECHFAB
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/gold = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT,
	)
	construction_time = 30 SECONDS
	build_path = /obj/item/organ/cyberimp/arm/toolkit/shell_launcher
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_COMBAT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/cyberimp_sandy
	name = "Qani-Laaca Sensory Computer Implant"
	desc = "An experimental implant replacing the spine of organics. When activated, it can give a temporary boost to mental processing speed, \
		Which many users perceive as a slowing of time and quickening of their ability to act. Due to its nature, it is incompatible with \
		system that heavily influence the user's nervous system, like the central nervous system rebooter. \
		As a bonus effect, you are immune to the burst of heart damage that comes at the end of twitch usage, as the computer is able to regulate \
		your heart's rhythm back to normal after its use."
	id = "combat_implant_sandy"
	build_type = MECHFAB
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/gold = SHEET_MATERIAL_AMOUNT * 2,
	)
	construction_time = 30 SECONDS
	build_path = /obj/item/organ/cyberimp/sensory_enhancer
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_COMBAT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/cyberimp_hackerman
	name = "Binyat Wireless Hacking System Implant"
	desc = "A rare-to-find neural chip that allows its user to interface with nearby machinery \
		and effect it in (usually) beneficial ways. Due to the rudimentary connection, fine manipulation \
		isn't possible, however the deck will drop a payload into the target's systems that will attempt \
		hacking for you. Due to their complexity, the system does not appear to work on cyborgs."
	id = "combat_implant_hackerman"
	build_type = MECHFAB
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 5,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/gold = SHEET_MATERIAL_AMOUNT * 2,
	)
	construction_time = 30 SECONDS
	build_path = /obj/item/organ/cyberimp/hackerman_deck
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_COMBAT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/cyberimp_claws
	name = "Razor Claws Implant"
	desc = "Long, sharp, double-edged razors installed within the fingers, functional for cutting. All kinds of cutting."
	id = "ci-razor"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	materials = list (
		/datum/material/iron = SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT,
	)
	construction_time = 20 SECONDS
	build_path = /obj/item/organ/cyberimp/arm/toolkit/razor_claws
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_TOOLS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SECURITY

/datum/design/cyberimp_drill
	name = "Dalba Masterworks 'Burrower' Integrated Drill"
	desc = "Extending from a stabilization bracer built into the upper forearm, this implant allows for a steel mining drill to extend over the user's hand. Little by little, we advance a bit further with each turn. That's how a drill works!"
	id = "ci-drill"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	materials = list (
		/datum/material/iron = SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT,
	)
	construction_time = 20 SECONDS
	build_path = /obj/item/organ/cyberimp/arm/toolkit/mining_drill
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_TOOLS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_CARGO

/datum/design/cyberimp_diamond_drill
	name = "Dalba Masterworks 'Tunneler' Diamond Drill"
	desc = "Extending from a stabilization bracer built into the upper forearm, this implant allows for a masterwork diamond mining drill to extend over the user's hand. This drill will open a hole in the universe, and that hole will be a path for those behind us!"
	id = "ci-drill-diamond"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT*3,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/diamond = SHEET_MATERIAL_AMOUNT,
	)
	construction_time = 30 SECONDS
	build_path = /obj/item/organ/cyberimp/arm/toolkit/mining_drill/diamond
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MINING
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_CARGO

/datum/design/cyberimp_flash
	name = "光子投射器植入物"
	desc = "一个集成在使用者手臂上的投射器，可用作强力闪光灯。"
	id = "ci-flash"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	materials = list (
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT,
	)
	construction_time = 20 SECONDS
	build_path = /obj/item/organ/cyberimp/arm/toolkit/flash
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_COMBAT,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cyberimp_botany
	name = "植物学手臂植入物"
	desc = "植物学家所需的一切功能都集成在一个手臂植入物中，设计用于安装在对象的手臂上。"
	id = "ci-botany"
	build_type = MECHFAB | PROTOLATHE
	materials = list (
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/plastic = SHEET_MATERIAL_AMOUNT,
	)
	construction_time = 20 SECONDS
	build_path = /obj/item/organ/cyberimp/arm/toolkit/botany
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_TOOLS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SERVICE

/datum/design/cyberimp_nv
	name = "夜视义眼"
	desc = "这些赛博义眼将赋予你夜视能力。又大、又凶、又绿。"
	id = "ci-nv"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 6 SECONDS
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT * 6,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT * 6,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT * 6,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT * 6,
		/datum/material/uranium = HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/organ/eyes/night_vision/cyber
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_UTILITY,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cyberimp_antisleep
	name = "中枢神经系统起搏器植入体"
	desc = "该植入体会自动尝试将你从无意识状态中电击唤醒，每次电击之间有短暂的冷却时间。与中枢神经系统重启器冲突。"
	id = "ci-antisleep"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 6 SECONDS
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT * 6,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT * 6,
		/datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/gold = HALF_SHEET_MATERIAL_AMOUNT,
		)
	build_path = /obj/item/organ/cyberimp/brain/anti_sleep
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_COMBAT,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cyberimp_scanner
	name = "内置医疗分析仪"
	desc = "该植入体与宿主的身体连接，可通过意念指令发送关于该容器状况的详细读数。"
	id = "ci-scanner"
	build_type = MECHFAB | PROTOLATHE
	construction_time = 4 SECONDS
	materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/glass = SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/silver = SHEET_MATERIAL_AMOUNT,
		/datum/material/gold = HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/organ/cyberimp/chest/scanner
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_HEALTH,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/design/cyberimp_janitor
	name = "清洁工手臂植入体"
	desc = "一套安装在手臂植入体中的清洁工具，设计用于安装在受试者的手臂上。"
	id = "ci-janitor"
	build_type = PROTOLATHE | MECHFAB
	materials = list (
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT,
	)
	construction_time = 20 SECONDS
	build_path = /obj/item/organ/cyberimp/arm/toolkit/janitor
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_TOOLS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SERVICE

/datum/design/cyberimp_lighter
	name = "打火机手臂植入体"
	desc = "一个安装在受试者手臂上的打火机。极其无用。"
	id = "ci-lighter"
	build_type = PROTOLATHE | MECHFAB
	materials = list (
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT,
	)
	construction_time = 10 SECONDS
	build_path = /obj/item/organ/cyberimp/arm/toolkit/lighter
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_MISC,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SERVICE

/datum/design/cyberimp_thermals
	name = "热成像义眼"
	id = "ci-thermals"
	build_type = AWAY_LATHE | MECHFAB
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY

/datum/design/cyberimp_reviver
	name = "复活者植入体"
	id = "ci-reviver"
	category = list(
		RND_CATEGORY_CYBERNETICS + RND_SUBCATEGORY_CYBERNETICS_IMPLANTS_COMBAT,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL
