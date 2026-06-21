/obj/effect/spawner/random/bureaucracy
	name = "官僚主义战利品生成器"
	desc = "为了那门整理文件的奇特艺术。"

/obj/effect/spawner/random/bureaucracy/pen
	name = "笔生成器"
	icon_state = "pen"
	loot = list(
		/obj/item/pen = 30,
		/obj/item/pen/blue = 5,
		/obj/item/pen/red = 5,
		/obj/item/flashlight/pen = 5,
		/obj/item/pen/fourcolor = 2,
		/obj/item/flashlight/pen/paramedic = 2,
		/obj/item/pen/fountain = 1,
	)

/obj/effect/spawner/random/bureaucracy/stamp
	name = "印章生成器"
	icon_state = "stamp"
	loot = list(
		/obj/item/stamp/granted = 3,
		/obj/item/stamp/denied = 1,
		/obj/item/stamp/void = 1,
	)

/obj/effect/spawner/random/bureaucracy/crayon
	name = "蜡笔生成器"
	icon_state = "crayon"
	loot = list(
		/obj/item/toy/crayon/red,
		/obj/item/toy/crayon/orange,
		/obj/item/toy/crayon/yellow,
		/obj/item/toy/crayon/green,
		/obj/item/toy/crayon/blue,
		/obj/item/toy/crayon/purple,
		/obj/item/toy/crayon/black,
		/obj/item/toy/crayon/white,
	)

/obj/effect/spawner/random/bureaucracy/paper
	name = "纸张生成器"
	icon_state = "paper"
	loot = list(
		/obj/item/paper = 20,
		/obj/item/paperplane = 2,
		/obj/item/paper/crumpled = 2,
		/obj/item/paper/crumpled/bloody = 2,
		/obj/item/paper/crumpled/muddy = 2,
		/obj/item/paper/construction = 1,
		/obj/item/paper/carbon = 1,
	)

/obj/effect/spawner/random/bureaucracy/briefcase
	name = "公文包生成器"
	icon_state = "briefcase"
	loot = list(
		/obj/item/storage/briefcase = 3,
		/obj/item/storage/briefcase/secure = 1,
	)

/obj/effect/spawner/random/bureaucracy/folder
	name = "文件夹生成器"
	icon_state = "folder"
	loot = list(
		/obj/item/folder/blue,
		/obj/item/folder/red,
		/obj/item/folder/yellow,
		/obj/item/folder/white,
		/obj/item/folder,
	)

/obj/effect/spawner/random/bureaucracy/birthday_wrap
	name = "额外包装纸生成器"
	icon_state = "wrapping_paper"
	spawn_all_loot = TRUE
	loot = list(
		/obj/item/stack/wrapping_paper,
		/obj/item/stack/wrapping_paper,
		/obj/item/stack/wrapping_paper,
	)

/obj/effect/spawner/random/bureaucracy/birthday_wrap/Initialize(mapload)
	if(!HAS_TRAIT(SSstation, STATION_TRAIT_BIRTHDAY))
		spawn_loot_chance = 0
	return ..()
