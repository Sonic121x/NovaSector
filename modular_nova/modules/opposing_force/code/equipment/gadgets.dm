/datum/opposing_force_equipment/gadget
	category = OPFOR_EQUIPMENT_CATEGORY_GADGET

/datum/opposing_force_equipment/gadget/agentcard
	name = "特工卡"
	item_type = /obj/item/card/id/advanced/chameleon/elite
	description = "一张高度先进的变色龙ID卡。将此卡触碰另一张ID卡或玩家以选择要复制的权限。具有特殊的磁性，能使其强制位于钱包最前面。"

/datum/opposing_force_equipment/gadget/chameleonheadsetdeluxe
	name = "高级变色龙耳机"
	item_type = /obj/item/radio/headset/chameleon/advanced
	description = "A premium model Chameleon Headset. All the features you love of the original, but now with flashbang \
	protection, voice amplification, memory-foam, HD Sound Quality, and extra-wide spectrum dial. Usually reserved \
	for high-ranking Cybersun officers, a few spares have been reserved for field agents."

/datum/opposing_force_equipment/gadget/smtheft_kit
	admin_note = "A kit liberated from Progression Traitor, allows someone to cut off a piece of the SM. Mishandling of the sliver can result in user being dusted. Upon successful extraction the SM will gain a quirk that turns its delamination countdown from its usual 15 seconds (at 0 Integrity) to 5 seconds; it will also slowly gather up 800 energy, potentially setting it on course for delamination."
	item_type = /obj/item/storage/box/syndie_kit/supermatter

/datum/opposing_force_equipment/gadget/nuketheft_kit
	admin_note = "A kit liberated from Progression Traitor, allows someone to screw open and secure the nuclear payload within the vault. Once secured it is mechanically irretrievable."
	item_type = /obj/item/storage/box/syndie_kit/nuke

/datum/opposing_force_equipment/gadget/holoparasite
	item_type = /obj/item/guardian_creator/tech/choose/traitor
	admin_note = "Lets a ghost take control of a guardian spirit bound to the user. RRs both the ghost and user on death."

/datum/opposing_force_equipment/gadget/gorilla_cubes
	name = "一盒大猩猩方块"
	item_type = /obj/item/storage/box/gorillacubes
	description = "A box with three gorilla cubes. Eat big to get big. \
			Caution: Product may rehydrate when exposed to water."

/datum/opposing_force_equipment/gadget/sentry_gun
	name = "工具箱哨戒炮"
	item_type = /obj/item/storage/toolbox/emergency/turret
	description = "一个伪装成工具箱的、一次性哨戒炮部署系统，使用扳手以激活功能。"
	admin_note = "Needs a combat-wrench to be used."

/datum/opposing_force_equipment/gadget/hypnoflash
	name = "催眠闪光"
	item_type = /obj/item/assembly/flash/hypnotic
	description = "一种经过改造的闪光灯，能够催眠目标。如果目标不处于精神脆弱状态，则只会暂时使其困惑并镇静。"
	admin_note = "Able to hypnotize people with the next phrase said after exposure."

/datum/opposing_force_equipment/gadget/hypnobang
	name = "催眠闪光弹"
	item_type = /obj/item/grenade/hypnotic
	description = "一种经过改造的闪光弹，能够催眠目标。如果目标不处于精神脆弱状态，则只会暂时使其困惑并镇静。"
	admin_note = "Able to hypnotize people with the next phrase said after exposure."


/datum/opposing_force_equipment/gadget_stealth
	category = OPFOR_EQUIPMENT_CATEGORY_GADGET_STEALTH

/datum/opposing_force_equipment/gadget_stealth/emag
	name = "密码破译器"
	item_type = /obj/item/card/emag
	description = "一种用于破坏机器和禁用安全措施的电磁ID卡。以被辛迪加特工使用而臭名昭著，如今是黑市上常见的交易硬件。"

/datum/opposing_force_equipment/gadget_stealth/doormag
	name = "气闸门覆写卡"
	item_type = /obj/item/card/emag/doorjack
	description = "通常被称为\"门禁破解器\"，这张非法改装的ID卡可以干扰气闸门电子系统。拥有自充电电池。"

/datum/opposing_force_equipment/gadget_stealth/stoolbelt
	name = "辛迪加工具带"
	description = "一个装满工具的工具带，包含战斗级扳手。"
	item_type = /obj/item/storage/belt/utility/syndicate

/datum/opposing_force_equipment/gadget_stealth/syndiejaws
	name = "辛迪加救生颚"
	item_type = /obj/item/crowbar/power/syndicate
	description = "Based on a Nanotrasen model, this powerful tool can be used as both a crowbar and a pair of wirecutters. \
	In its crowbar configuration, it can be used to force open airlocks. Very useful for entering the station or its departments."

/datum/opposing_force_equipment/gadget_stealth/hair_tie
	name = "辛迪加发带"
	description = "一个不起眼的发圈，能够被精准投掷。有助于让你摆脱棘手的局面。"
	item_type = /obj/item/clothing/head/hair_tie/syndicate

/datum/opposing_force_equipment/gadget_stealth/jammer
	name = "无线电干扰器"
	item_type = /obj/item/jammer

/datum/opposing_force_equipment/gadget_stealth/flatsatchel
	item_type = /obj/item/storage/backpack/satchel/flat/with_tools

/datum/opposing_force_equipment/gadget_stealth/chameleon
	description = "A set of items that contain chameleon technology allowing you to disguise as pretty much anything on the station, and more! \
			Due to budget cuts, the shoes don't provide protection against slipping and skillchips are sold separately."
	item_type = /obj/item/storage/box/syndie_kit/chameleon

/datum/opposing_force_equipment/gadget_stealth/throwables
	name = "投掷武器箱"
	description = "A box of shurikens and reinforced bolas from ancient Earth martial arts. They are highly effective \
			throwing weapons. The bolas can knock a target down and the shurikens will embed into limbs."
	item_type = /obj/item/storage/box/syndie_kit/throwing_weapons

/datum/opposing_force_equipment/gadget_stealth/emp_box
	name = "电磁脉冲工具包"
	description = "一盒装满电磁脉冲手榴弹的箱子，非常适合瘫痪安保部门的装备。"
	item_type = /obj/item/storage/box/syndie_kit/emp

/datum/opposing_force_equipment/gadget_stealth/poisonkit
	name = "毒药工具包"
	description = "一套装在紧凑盒子里的致命化学品。附带一支注射器，用于更精确的施用。"
	item_type = /obj/item/storage/box/syndie_kit/chemical

/datum/opposing_force_equipment/gadget_stealth/sleepypen
	name = "催眠笔"
	description = "一支装有催眠剂的笔。片刻后会使受害者昏迷。"
	item_type = /obj/item/pen/sleepy

/datum/opposing_force_equipment/gadget_stealth/sleepy_neuroware
	name = "勒索软件神经芯片"
	description = "一块充满勒索软件病毒的神经植入芯片。片刻后会使受害者昏迷。"
	item_type = /obj/item/disk/neuroware/sleepy

/datum/opposing_force_equipment/gadget_stealth/carp
	name = "脱水太空鲤鱼"
	description = "一个太空鲤鱼毛绒玩具，遇水会变成真家伙。"
	item_type = /obj/item/toy/plush/carpplushie/dehy_carp

/datum/opposing_force_equipment/gadget_stealth/glue
	item_type = /obj/item/syndie_glue

/datum/opposing_force_equipment/gadget_stealth/shotglass
	name = "特大号辛迪加烈酒杯"
	description = "These modified shot glasses can hold up to 50 units of booze while looking like a regular 15 unit model \
	guaranteed to knock someone on their ass with a hearty dose of bacchus blessing. Look for the Snake underneath \
	to tell these are the real deal. Box of 7."
	item_type = /obj/item/storage/box/syndieshotglasses

/datum/opposing_force_equipment/gadget_stealth/ai_module
	name = "辛迪加AI定律模块"
	item_type = /obj/item/ai_module/syndicate
	description = "When used with an upload console, this module allows you to upload priority laws to an artificial intelligence. \
			Be careful with wording, as artificial intelligences may look for loopholes to exploit."

/datum/opposing_force_equipment/gadget_stealth/binary
	name = "二进制加密密钥"
	item_type = /obj/item/encryptionkey/binary

/datum/opposing_force_equipment/gadget_stealth/borgupgrader
	item_type = /obj/item/borg/upgrade/transform/syndicatejack

/datum/opposing_force_equipment/gadget_stealth/cloakerbelt
	item_type = /obj/item/shadowcloak
	description = "一条能让穿戴者暂时隐形的腰带。仅在黑暗区域充能。明智使用。"

/datum/opposing_force_equipment/gadget_stealth/projector
	name = "变色龙投影仪"
	item_type = /obj/item/chameleon

/datum/opposing_force_equipment/gadget_stealth/noslip
	name = "变色龙防滑鞋"
	item_type = /obj/item/clothing/shoes/chameleon/noslip
	description = "防滑变色龙鞋，为你计划穿越地狱再回来时准备。"

/datum/opposing_force_equipment/gadget_stealth/camera_app
	name = "辛迪加之眼程序"
	item_type = /obj/item/disk/computer/syndicate/camera_app

/datum/opposing_force_equipment/gadget_stealth/microlaser
	name = "放射性微激光器"
	item_type = /obj/item/healthanalyzer/rad_laser
	description = "A radioactive microlaser disguised as a standard Nanotrasen health analyzer. When used, it emits a \
			powerful burst of radiation, which, after a short delay, can incapacitate all but the most protected \
			of humanoids."
	admin_note = "WARNING: Is a knockout weapon with no warning, and 'infinite' use."

/datum/opposing_force_equipment/gadget_stealth/contacts
	name = "防闪光隐形眼镜"
	item_type = /obj/item/syndicate_contacts

/datum/opposing_force_equipment/gadget_stealth/suppressor
	item_type = /obj/item/suppressor
