/datum/opposing_force_equipment/clothing_syndicate
	category = OPFOR_EQUIPMENT_CATEGORY_CLOTHING_SYNDICATE

/datum/opposing_force_equipment/clothing_syndicate/operative
	name = "辛迪加特工"
	description = "一套经典的可靠装备，配备多功能防御装备、战术背带、舒适的套头衫，甚至还有一个紧急太空服盒。"
	item_type = /obj/item/storage/backpack/duffelbag/syndie/operative

/obj/item/storage/backpack/duffelbag/syndie/operative/PopulateContents() //basically old insurgent bundle -nukie mod
	new /obj/item/clothing/under/syndicate/nova/tactical(src)
	new /obj/item/clothing/under/syndicate/nova/tactical/skirt(src)
	new /obj/item/clothing/suit/armor/bulletproof(src)
	new /obj/item/clothing/shoes/combat(src)
	new /obj/item/clothing/gloves/tackler/combat(src)
	new /obj/item/clothing/mask/gas/syndicate(src)
	new /obj/item/storage/belt/military(src)
	new /obj/item/radio/headset/syndicate/alt(src)
	new /obj/item/card/id/advanced/chameleon(src)
	new /obj/item/clothing/glasses/sunglasses(src)
	new /obj/item/storage/box/syndie_kit/space_suit(src)

/datum/opposing_force_equipment/clothing_syndicate/engineer
	name = "辛迪加工程师"
	description = "经典套装的变体，专为那些双手从不干净的人设计。牺牲了防御选择以换取实用性。附带一个紧急太空服盒。"
	item_type = /obj/item/storage/backpack/duffelbag/syndie/engineer

/obj/item/storage/backpack/duffelbag/syndie/engineer/PopulateContents()
	new /obj/item/clothing/under/syndicate/nova/overalls(src)
	new /obj/item/clothing/under/syndicate/nova/overalls/skirt(src)
	new /obj/item/clothing/suit/armor/bulletproof(src)
	new /obj/item/clothing/shoes/combat(src)
	new /obj/item/clothing/gloves/combat(src)
	new /obj/item/clothing/mask/gas/syndicate(src)
	new /obj/item/storage/belt/utility/syndicate(src)
	new /obj/item/radio/headset/syndicate/alt(src)
	new /obj/item/card/id/advanced/chameleon(src)
	new /obj/item/clothing/glasses/meson/night(src)
	new /obj/item/storage/box/syndie_kit/space_suit(src)

/datum/opposing_force_equipment/clothing_syndicate/spy
	name = "辛迪加间谍"
	description = "他们不必知道你是谁，他们也不会知道。附带紧急太空服盒。"
	item_type = /obj/item/storage/backpack/duffelbag/syndie/spy

/obj/item/storage/backpack/duffelbag/syndie/spy/PopulateContents()
	new /obj/item/clothing/under/suit/black/armoured(src)
	new /obj/item/clothing/under/suit/black/skirt/armoured(src)
	new /obj/item/clothing/suit/jacket/det_suit/noir/armoured(src)
	new /obj/item/storage/belt/holster/detective/dark(src)
	new /obj/item/clothing/head/beret/frenchberet/armoured(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/clothing/neck/tie/red/hitman(src)
	new /obj/item/clothing/mask/gas/syndicate/ds(src) //a red spy is in the base
	new /obj/item/radio/headset/syndicate/alt(src)
	new /obj/item/card/id/advanced/chameleon(src)
	new /obj/item/clothing/glasses/sunglasses(src)
	new /obj/item/hhmirror/syndie(src)
	new /obj/item/storage/box/syndie_kit/space_suit(src)

/datum/opposing_force_equipment/clothing_syndicate/maid
	name = "辛迪加女仆"
	description = "..."
	item_type = /obj/item/storage/backpack/duffelbag/syndie/maid

/obj/item/storage/backpack/duffelbag/syndie/maid/PopulateContents() //by far the weakest bundle
	new /obj/item/clothing/under/syndicate/nova/maid(src)
	new /obj/item/clothing/gloves/combat/maid(src)
	new /obj/item/clothing/head/costume/maid_headband/syndicate(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/radio/headset/syndicate/alt(src)
	new /obj/item/card/id/advanced/chameleon(src)

/datum/opposing_force_equipment/clothing_syndicate/cybersun_operative
	name = "赛博太阳特工"
	description = "用于最隐秘的行动。附带紧急太空服盒。"
	item_type = /obj/item/storage/backpack/duffelbag/syndie/cybersun_operative

/obj/item/storage/backpack/duffelbag/syndie/cybersun_operative/PopulateContents() //drip maxxed
	new /obj/item/clothing/under/syndicate/combat(src)
	new /obj/item/clothing/suit/armor/bulletproof(src)
	new /obj/item/clothing/shoes/combat(src)
	new /obj/item/clothing/gloves/combat(src)
	new /obj/item/clothing/mask/neck_gaiter(src)
	new /obj/item/clothing/glasses/meson/night(src)
	new /obj/item/storage/belt/military/assault(src)
	new /obj/item/radio/headset/syndicate/alt(src)
	new /obj/item/card/id/advanced/chameleon(src)
	new /obj/item/storage/box/syndie_kit/space_suit(src)

/datum/opposing_force_equipment/clothing_syndicate/cybersun_hacker
	name = "赛博太阳黑客"
	description = "一些太空旅行者认为臭名昭著的太空忍者已不复存在，他们错了。"
	item_type = /obj/item/storage/backpack/duffelbag/syndie/cybersun_hacker

/obj/item/storage/backpack/duffelbag/syndie/cybersun_hacker/PopulateContents()
	new /obj/item/clothing/under/syndicate/ninja(src)
	new /obj/item/clothing/shoes/combat(src)
	new /obj/item/clothing/gloves/combat(src)
	new /obj/item/clothing/mask/gas/ninja(src)
	new /obj/item/clothing/glasses/hud/health/night/meson(src) //damn it's sexy
	new /obj/item/storage/belt/military/assault(src)
	new /obj/item/radio/headset/syndicate/alt(src)
	new /obj/item/card/id/advanced/chameleon(src)

/datum/opposing_force_equipment/clothing_syndicate/lone_gunman
	name = "独行枪手"
	description = "我的名字不重要。"
	admin_note = "Looks unarmoured, yet is very armoured"
	item_type = /obj/item/storage/backpack/duffelbag/syndie/lone_gunman

/obj/item/storage/backpack/duffelbag/syndie/lone_gunman/PopulateContents()
	new /obj/item/clothing/under/pants/track/robohand(src)
	new /obj/item/clothing/glasses/sunglasses/robohand(src)
	new /obj/item/clothing/suit/jacket/leather_trenchcoat/gunman(src)
	new /obj/item/clothing/shoes/combat(src)
	new /obj/item/radio/headset/syndicate/alt(src)
	new /obj/item/card/id/advanced/chameleon(src)


/datum/opposing_force_equipment/clothing_sol
	category = OPFOR_EQUIPMENT_CATEGORY_CLOTHING_SOL

/datum/opposing_force_equipment/clothing_sol/sol_militant
	name = "索尔激进分子"
	description = "一场战争正在进行，而战场就在这里。"
	item_type = /obj/item/storage/backpack/ert/odst/hecu/sol_militant

/obj/item/storage/backpack/ert/odst/hecu/sol_militant/PopulateContents()
	new /obj/item/clothing/under/sol_peacekeeper(src)
	new /obj/item/clothing/suit/armor/sf_peacekeeper(src)
	new /obj/item/clothing/head/helmet/sf_peacekeeper(src)
	new /obj/item/storage/belt/military/assault(src)
	new /obj/item/clothing/mask/gas/hecu(src)
	new /obj/item/clothing/shoes/combat(src)
	new /obj/item/clothing/gloves/combat(src)
	new /obj/item/clothing/glasses/night(src)
	new /obj/item/radio/headset/syndicate/alt(src)
	new /obj/item/card/id/advanced/chameleon(src)

/datum/opposing_force_equipment/clothing_sol/dogginos
	name = "多吉诺斯快递员"
	description = "你只是在做你的工作。"
	item_type = /obj/item/storage/backpack/satchel/leather/dogginos

/obj/item/storage/backpack/satchel/leather/dogginos/PopulateContents()
	new /obj/item/clothing/under/pizza(src)
	new /obj/item/clothing/suit/pizzaleader(src)
	new /obj/item/clothing/suit/toggle/jacket/nova/hoodie/pizza(src)
	new /obj/item/clothing/head/pizza(src)
	new /obj/item/clothing/head/soft/red(src)
	new /obj/item/clothing/glasses/regular/modern(src)
	new /obj/item/clothing/mask/fakemoustache/italian(src)
	new /obj/item/clothing/shoes/sneakers/red(src)
	new /obj/item/radio/headset/headset_cent/impostorsr(src)
	new /obj/item/card/id/advanced/chameleon(src)

/datum/opposing_force_equipment/clothing_sol/impostor
	name = "中央司令部冒名者"
	description = "别问我们是怎么搞到这玩意的。附带一张预装了指挥权限的特工ID卡。"
	item_type = /obj/item/storage/backpack/duffelbag/syndie/impostor

/obj/item/storage/backpack/duffelbag/syndie/impostor/PopulateContents()
	new /obj/item/clothing/under/rank/centcom/officer(src)
	new /obj/item/clothing/under/rank/centcom/officer_skirt(src)
	new /obj/item/clothing/head/hats/centcom_cap(src)
	new /obj/item/clothing/suit/armor/centcom_formal(src)
	new /obj/item/clothing/shoes/combat(src)
	new /obj/item/radio/headset/headset_cent/impostorsr(src)
	new /obj/item/clothing/glasses/sunglasses(src)
	new /obj/item/clipboard(src)
	new /obj/item/card/id/advanced/chameleon/elite/impostorsr(src) //this thing has bridge access, and no one knows about that
	new /obj/item/stamp/centcom(src)
	new /obj/item/clothing/gloves/combat(src)


/datum/opposing_force_equipment/clothing_pirate
	category = OPFOR_EQUIPMENT_CATEGORY_CLOTHING_PIRATE

/datum/opposing_force_equipment/clothing_pirate/space_pirate
	name = "太空海盗"
	description = "你是从船上掉下来的吗？"
	item_type = /obj/item/storage/backpack/duffelbag/syndie/space_pirate

/obj/item/storage/backpack/duffelbag/syndie/space_pirate/PopulateContents()
	new /obj/item/clothing/under/costume/pirate(src)
	new /obj/item/clothing/suit/space/pirate(src)
	new /obj/item/clothing/head/helmet/space/pirate(src)
	new /obj/item/clothing/head/costume/pirate/armored(src)
	new /obj/item/clothing/shoes/pirate/armored(src)
	new /obj/item/clothing/glasses/eyepatch(src)
	new /obj/item/radio/headset/syndicate/alt(src)
	new /obj/item/card/id/advanced/chameleon(src)

/datum/opposing_force_equipment/clothing_pirate/akula
	name = "阿祖兰登舰者"
	description = "先进的阿祖兰海盗装备，类似防暴盔甲但经过太空防护处理。永远不要在零重力环境下与阿祖兰登船者交手。"
	admin_note = "Uniquely spaceproofed."
	item_type = /obj/item/storage/backpack/duffelbag/syndie/akula

/obj/item/storage/backpack/duffelbag/syndie/akula/PopulateContents()
	new /obj/item/clothing/under/skinsuit(src)
	new /obj/item/clothing/suit/armor/riot/skinsuit_armor(src)
	new /obj/item/clothing/head/helmet/space/skinsuit_helmet(src)
	new /obj/item/clothing/gloves/tackler/combat(src) //tackles in space
	new /obj/item/clothing/shoes/combat(src)
	new /obj/item/storage/belt/military(src)
	new /obj/item/radio/headset/syndicate/alt(src)
	new /obj/item/card/id/advanced/chameleon(src)

/datum/opposing_force_equipment/clothing_pirate/nri_soldier
	name = "HC士兵"
	description = "空间站未能通过检查，现在他们得对付你了。"
	item_type = /obj/item/storage/backpack/industrial/cin_surplus/forest/nri_soldier

/obj/item/storage/backpack/industrial/cin_surplus/forest/nri_soldier/PopulateContents()
	new /obj/item/clothing/under/syndicate/rus_army(src)
	new /obj/item/clothing/shoes/combat(src)
	new /obj/item/clothing/gloves/tackler/combat(src)
	new /obj/item/clothing/mask/gas/hecu(src)
	new /obj/item/clothing/suit/armor/vest/marine(src)
	new /obj/item/clothing/head/beret/sec/nri(src)
	new /obj/item/storage/belt/military/nri/plus_mre(src)
	new /obj/item/radio/headset/syndicate/alt(src)
	new /obj/item/card/id/advanced/chameleon(src)
	new /obj/item/clothing/glasses/sunglasses(src)

/datum/opposing_force_equipment/clothing_pirate/heister
	name = "专业人士"
	description = "发薪日到了。"
	admin_note = "Has uniquely strong armour."
	item_type = /obj/item/storage/backpack/duffelbag/syndie/heister

/obj/item/storage/backpack/duffelbag/syndie/heister/PopulateContents()
	var/obj/item/clothing/new_mask = new /obj/item/clothing/mask/gas/clown_hat(src) //-animal mask +clow mask
	new_mask.set_armor(new_mask.get_armor().generate_new_with_specific(list(
		MELEE = 30,
		BULLET = 25,
		LASER = 25,
		ENERGY = 25,
		BOMB = 0,
		BIO = 0,
		FIRE = 100,
		ACID = 100,
	)))
	new /obj/item/storage/box/syndie_kit/space_suit(src)
	new /obj/item/clothing/gloves/latex/nitrile/heister(src)
	new /obj/item/clothing/under/suit/black(src)
	new /obj/item/clothing/under/suit/black/skirt(src)
	new /obj/item/clothing/neck/tie/red/hitman(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/clothing/suit/jacket/det_suit/noir/heister(src)
	new /obj/item/clothing/glasses/sunglasses(src)
	new /obj/item/radio/headset/syndicate/alt(src)
	new /obj/item/card/id/advanced/chameleon(src)
	new /obj/item/restraints/handcuffs/cable/zipties(src)
	new /obj/item/restraints/handcuffs/cable/zipties(src)


/datum/opposing_force_equipment/clothing_magic
	category = OPFOR_EQUIPMENT_CATEGORY_CLOTHING_MAGIC

/datum/opposing_force_equipment/clothing_magic/wizard
	name = "巫师"
	description = "基础款彩色巫师服饰。"
	item_type = /obj/item/storage/backpack/satchel/leather/wizard

/obj/item/storage/backpack/satchel/leather/wizard/PopulateContents()
	switch(pick(list("yellow", "blue", "red", "black")))
		if("yellow")
			new /obj/item/clothing/head/wizard/yellow(src)
			new /obj/item/clothing/suit/wizrobe/yellow(src)
		if("blue")
			new /obj/item/clothing/head/wizard(src)
			new /obj/item/clothing/suit/wizrobe(src)
		if("red")
			new /obj/item/clothing/head/wizard/red(src)
			new /obj/item/clothing/suit/wizrobe/red(src)
		if("black")
			new /obj/item/clothing/head/wizard/black(src)
			new /obj/item/clothing/suit/wizrobe/black(src)
	new /obj/item/staff(src)
	new /obj/item/clothing/shoes/sandal/magic(src)
	new /obj/item/radio/headset/syndicate/alt(src)
	new /obj/item/card/id/advanced/chameleon(src)

/datum/opposing_force_equipment/clothing_magic/wizard_broom
	name = "扫帚巫师"
	description = "拿着扫帚的巫师，严格来说算女巫。"
	item_type = /obj/item/storage/backpack/satchel/leather/wizard_broom

/obj/item/storage/backpack/satchel/leather/wizard_broom/PopulateContents()
	new /obj/item/clothing/suit/wizrobe/marisa(src)
	new /obj/item/clothing/head/wizard/marisa(src)
	new /obj/item/staff/broom(src)
	new /obj/item/clothing/shoes/sneakers/marisa(src)
	new /obj/item/radio/headset/syndicate/alt(src)
	new /obj/item/card/id/advanced/chameleon(src)

/datum/opposing_force_equipment/clothing_magic/wizard_tape
	name = "胶带巫师"
	description = "一套巫师装束，不过是手工制作的。非常不错。"
	item_type = /obj/item/storage/backpack/satchel/leather/wizard_tape

/obj/item/storage/backpack/satchel/leather/wizard_tape/PopulateContents()
	new /obj/item/clothing/suit/wizrobe/tape(src)
	new /obj/item/clothing/head/wizard/tape(src)
	new /obj/item/staff/tape(src)
	new /obj/item/clothing/shoes/sandal/magic(src)
	new /obj/item/radio/headset/syndicate/alt(src)
	new /obj/item/card/id/advanced/chameleon(src)

/datum/opposing_force_equipment/clothing_magic/zealot
	name = "狂热信徒"
	description = "施法是被禁止的，不过那也拦不住你。"
	item_type = /obj/item/storage/backpack/satchel/leather/zealot

/obj/item/storage/backpack/satchel/leather/zealot/PopulateContents()
	new /obj/item/clothing/suit/hooded/cultrobes/eldritch(src)
	new /obj/item/clothing/glasses/hud/health/night/cultblind_unrestricted(src)
	new /obj/item/clothing/shoes/cult(src)
	new /obj/item/radio/headset/syndicate/alt(src)
	new /obj/item/card/id/advanced/chameleon(src)

/datum/opposing_force_equipment/clothing_magic/narsian
	name = "纳尔西恩先知"
	description = "一个被阴影笼罩的邪教追随者，他们恰好在黑暗中最为兴盛。"
	item_type = /obj/item/storage/backpack/satchel/leather/narsian

/obj/item/storage/backpack/satchel/leather/narsian/PopulateContents()
	new /obj/item/clothing/suit/hooded/cultrobes/hardened(src)
	new /obj/item/clothing/head/hooded/cult_hoodie/hardened(src)
	new /obj/item/clothing/glasses/hud/health/night/cultblind_unrestricted/narsie(src)
	new /obj/item/clothing/shoes/cult/alt(src)
	new /obj/item/bedsheet/cult(src)
	new /obj/item/radio/headset/syndicate/alt(src)
	new /obj/item/card/id/advanced/chameleon(src)


