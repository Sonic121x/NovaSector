/obj/effect/spawner/costume
	name = "服装生成器"
	icon = 'icons/hud/screen_gen.dmi'
	icon_state = "x2"
	color = COLOR_VIBRANT_LIME

	var/list/items

/obj/effect/spawner/costume/Initialize(mapload)
	. = ..()
	if(items?.len)
		for(var/path in items)
			new path(loc)

/obj/effect/spawner/costume/chicken
	name = "小鸡服装生成器"
	items = list(
		/obj/item/clothing/suit/costume/chickensuit,
		/obj/item/clothing/head/costume/chicken,
		/obj/item/food/egg,
	)

/obj/effect/spawner/costume/gladiator
	name = "角斗士服装生成器"
	items = list(
		/obj/item/clothing/under/costume/gladiator,
		/obj/item/clothing/head/helmet/gladiator,
	)

/obj/effect/spawner/costume/madscientist
	name = "疯狂科学家服装生成器"
	items = list(
		/obj/item/clothing/under/costume/captain,
		/obj/item/clothing/head/flatcap,
		/obj/item/clothing/suit/toggle/labcoat/mad,
	)

/obj/effect/spawner/costume/elpresidente
	name = "总统服装生成器"
	items = list(
		/obj/item/clothing/under/costume/captain,
		/obj/item/clothing/head/flatcap,
		/obj/item/cigarette/cigar/havana,
		/obj/item/clothing/shoes/jackboots,
	)

/obj/effect/spawner/costume/nyangirl
	name = "猫娘服装生成器"
	items = list(
		/obj/item/clothing/under/costume/seifuku,
		/obj/item/clothing/head/costume/kitty,
		/obj/item/clothing/glasses/blindfold,
	)

/obj/effect/spawner/costume/maid
	name = "女仆装生成器"
	items = list(
		/obj/item/clothing/under/dress/skirt,
		/obj/effect/spawner/random/clothing/beret_or_rabbitears,
		/obj/item/clothing/glasses/blindfold,
	)


/obj/effect/spawner/costume/butler
	name = "管家服装生成器"
	items = list(
		/obj/item/clothing/accessory/waistcoat,
		/obj/item/clothing/under/costume/buttondown/slacks/service,
		/obj/item/clothing/neck/tie/black,
		/obj/item/clothing/head/hats/tophat,
	)

/obj/effect/spawner/costume/referee
	name = "裁判服装生成器"
	items = list(
		/obj/item/clothing/mask/whistle,
		/obj/item/clothing/gloves/latex,
		/obj/item/clothing/shoes/laceup,
		/obj/item/clothing/head/soft/black,
		/obj/item/clothing/under/costume/referee,
	)

/obj/effect/spawner/costume/highlander
	name = "高地人服装生成器"
	items = list(
		/obj/item/clothing/under/costume/kilt,
		/obj/item/clothing/head/beret,
	)

/obj/effect/spawner/costume/prig
	name = "古板者服装生成器"
	items = list(
		/obj/item/clothing/accessory/waistcoat,
		/obj/item/clothing/glasses/monocle,
		/obj/effect/spawner/random/clothing/bowler_or_that,
		/obj/item/clothing/shoes/sneakers/black,
		/obj/item/cane,
		/obj/item/clothing/under/costume/buttondown/slacks/service,
		/obj/item/clothing/mask/fakemoustache,
	)

/obj/effect/spawner/costume/plaguedoctor
	name = "瘟疫医生服装生成器"
	items = list(
		/obj/item/clothing/suit/bio_suit/plaguedoctorsuit,
		/obj/item/clothing/head/bio_hood/plague,
		/obj/item/clothing/mask/gas/plaguedoctor,
	)

/obj/effect/spawner/costume/nightowl
	name = "夜猫子服装生成器"
	items = list(
		/obj/item/clothing/suit/toggle/owlwings,
		/obj/item/clothing/under/costume/owl,
		/obj/item/clothing/mask/gas/owl_mask,
	)

/obj/effect/spawner/costume/griffin
	name = "狮鹫服装生成器"
	items = list(
		/obj/item/clothing/suit/toggle/owlwings/griffinwings,
		/obj/item/clothing/shoes/griffin,
		/obj/item/clothing/under/costume/griffin,
		/obj/item/clothing/head/costume/griffin,
	)

/obj/effect/spawner/costume/waiter
	name = "侍者服装生成器"
	items = list(
		/obj/item/clothing/under/suit/waiter,
		/obj/effect/spawner/random/clothing/kittyears_or_rabbitears,
		/obj/item/clothing/suit/apron,
	)

/obj/effect/spawner/costume/pirate
	name = "海盗服装生成器"
	items = list(
		/obj/item/clothing/under/costume/pirate,
		/obj/item/clothing/suit/costume/pirate,
		/obj/effect/spawner/random/clothing/pirate_or_bandana,
		/obj/item/clothing/glasses/eyepatch,
	)

/obj/effect/spawner/costume/commie
	name = "同志服装生成器"
	items = list(
		/obj/item/clothing/under/costume/soviet,
		/obj/item/clothing/head/costume/ushanka,
	)

/obj/effect/spawner/costume/imperium_monk
	name = "帝国僧侣服装生成器"
	items = list(
		/obj/item/clothing/suit/costume/imperium_monk,
		/obj/effect/spawner/random/clothing/twentyfive_percent_cyborg_mask,
	)

/obj/effect/spawner/costume/holiday_priest
	name = "节日牧师服装生成器"
	items = list(/obj/item/clothing/suit/chaplainsuit/holidaypriest)

/obj/effect/spawner/costume/marisawizard
	name = "雾雨魔理沙巫师服装生成器"
	items = list(
		/obj/item/clothing/shoes/sneakers/marisa,
		/obj/item/clothing/head/wizard/marisa/fake,
		/obj/item/clothing/suit/wizrobe/marisa/fake,
	)

/obj/effect/spawner/costume/tape_wizard
	name = "胶带巫师服装生成器"
	items = list(
		/obj/item/clothing/head/wizard/tape/fake,
		/obj/item/clothing/suit/wizrobe/tape/fake,
		/obj/item/staff/tape,
	)

/obj/effect/spawner/costume/cutewitch
	name = "可爱女巫服装生成器"
	items = list(
		/obj/item/clothing/under/dress/sundress,
		/obj/item/clothing/head/costume/witchwig,
		/obj/item/staff/broom,
	)

/obj/effect/spawner/costume/wizard
	name = "巫师服装生成器"
	items = list(
		/obj/item/clothing/shoes/sandal,
		/obj/item/clothing/suit/wizrobe/fake,
		/obj/item/clothing/head/wizard/fake,
		/obj/item/staff,
	)

/obj/effect/spawner/costume/sexyclown
	name = "性感小丑服装生成器"
	items = list(
		/obj/item/clothing/mask/gas/sexyclown,
		/obj/item/clothing/under/rank/civilian/clown/sexy,
	)

/obj/effect/spawner/costume/sexymime
	name = "性感默剧演员服装生成器"
	items = list(
		/obj/item/clothing/mask/gas/sexymime,
		/obj/item/clothing/under/rank/civilian/mime/sexy,
	)

/obj/effect/spawner/costume/mafia
	name = "黑色黑手党套装生成器"
	items = list(
		/obj/item/clothing/head/fedora,
		/obj/item/clothing/under/suit/black,
		/obj/item/clothing/shoes/laceup,
	)

/obj/effect/spawner/costume/mafia/white
	name = "白色黑手党套装生成器"
	items = list(
		/obj/item/clothing/head/fedora/white,
		/obj/item/clothing/under/suit/white,
		/obj/item/clothing/shoes/laceup,
	)

/obj/effect/spawner/costume/mafia/checkered
	name = "方格纹黑手党套装生成器"
	items = list(
		/obj/item/clothing/head/fedora,
		/obj/item/clothing/under/suit/checkered,
		/obj/item/clothing/shoes/laceup,
	)

/obj/effect/spawner/costume/mafia/beige
	name = "米色黑手党套装生成器"
	items = list(
		/obj/item/clothing/head/fedora/beige,
		/obj/item/clothing/under/suit/beige,
		/obj/item/clothing/shoes/laceup,
	)
