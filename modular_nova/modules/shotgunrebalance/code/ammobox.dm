/obj/item/ammo_box/advanced/s12gauge
	name = "弹药盒（独头弹）"
	desc = "一盒15发独头弹。威力强大的单发大口径子弹。"
	icon = 'modular_nova/modules/shotgunrebalance/icons/shotbox.dmi'
	icon_state = "slug"
	ammo_type = /obj/item/ammo_casing/shotgun
	max_ammo = 15

/obj/item/ammo_box/advanced/s12gauge/buckshot
	name = "弹药盒（鹿弹）"
	desc = "一盒15发鹿弹。这些子弹会散射出威力较弱的弹丸。"
	icon_state = "buckshot"
	ammo_type = /obj/item/ammo_casing/shotgun/buckshot
	max_ammo = 15

/obj/item/ammo_box/advanced/s12gauge/rubber
	name = "弹药盒（橡胶弹）"
	desc = "一盒15发橡胶弹。这些子弹会散射出威力较弱、非致命的弹丸。"
	icon_state = "rubber"
	ammo_type = /obj/item/ammo_casing/shotgun/rubbershot
	max_ammo = 15

/obj/item/ammo_box/advanced/s12gauge/bean
	name = "弹药盒（豆袋弹）"
	desc = "一盒15发豆袋独头弹。这些是大型的单发豆袋，具有非致命的冲击力。"
	icon_state = "bean"
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag
	max_ammo = 15

/obj/item/ammo_box/advanced/s12gauge/magnum
	name = "弹药盒（马格南块状弹）"
	desc = "一盒15发马格南块状弹。弹丸直径比典型霰弹更大，但每发弹壳内含的弹丸数量较少。"
	icon_state = "magnum"
	ammo_type = /obj/item/ammo_casing/shotgun/magnum
	max_ammo = 15

/obj/item/ammo_box/advanced/s12gauge/express
	name = "弹药盒（高速霰弹）"
	desc = "一盒15发高速霰弹。弹丸直径比典型霰弹更小，但每发弹壳内含的弹丸数量更多。"
	icon_state = "express"
	ammo_type = /obj/item/ammo_casing/shotgun/express
	max_ammo = 15

/obj/item/ammo_box/advanced/s12gauge/hunter
	name = "弹药盒（猎手独头弹）"
	desc = "一盒15发猎手独头弹。这些霰弹独头弹擅长伤害当地动物。"
	icon_state = "hunter"
	ammo_type = /obj/item/ammo_casing/shotgun/hunter
	max_ammo = 15

/obj/item/ammo_box/advanced/s12gauge/flechette
	name = "弹药盒（撕裂者箭弹）"
	desc = "一盒15发撕裂者箭弹。每发弹壳内含有一组翻滚的刀片，擅长造成可怕的伤口。"
	icon_state = "flechette"
	ammo_type = /obj/item/ammo_casing/shotgun/flechette_nova
	max_ammo = 15

/obj/item/ammo_box/advanced/s12gauge/frangible
	name = "Frangible Slug ammo box"
	desc = "A box of 10 Frangible slug. It's able to punches through windows, airlocks whatever with ease. Less-than-effective against people"
	icon_state = "slug"
	ammo_type = /obj/item/ammo_casing/shotgun/frangible
	max_ammo = 10

/obj/item/ammo_box/advanced/s12gauge/beehive
	name = "弹药盒（蜂巢弹）"
	desc = "一盒15发蜂巢弹。这些是低致命性弹头，会从墙壁反弹并导向附近的目标。"
	icon_state = "beehive"
	ammo_type = /obj/item/ammo_casing/shotgun/beehive
	max_ammo = 15

/obj/item/ammo_box/advanced/s12gauge/antitide
	name = "弹药盒（星尘弹）"
	desc = "一盒15发星尘弹。这些是低致命性弹头，发射一根电缆嵌入目标，在连接时以类似电击枪的方式消耗体力。"
	icon_state = "antitide"
	ammo_type = /obj/item/ammo_casing/shotgun/antitide
	max_ammo = 15

/obj/item/ammo_box/advanced/s12gauge/incendiary
	name = "弹药盒（燃烧独头弹）"
	desc = "一盒15发燃烧独头弹。这些弹头会点燃目标并在身后留下一道火焰轨迹。"
	icon_state = "incendiary"
	ammo_type = /obj/item/ammo_casing/shotgun/incendiary
	max_ammo = 15

/obj/item/ammo_box/advanced/s12gauge/honkshot
	name = "弹药盒（彩花弹）"
	desc = "一盒35发彩花弹，用于制造不必要的混乱。"
	icon_state = "honk"
	ammo_type = /obj/item/ammo_casing/shotgun/honkshot
	max_ammo = 35

/obj/item/ammo_box/advanced/s12gauge/milspec
	name = "弹药盒（军用规格独头弹）"
	desc = "一盒15发斯卡伯勒武器公司制造的热装药军用规格独头弹。比传统独头弹更快、威力更强。"
	icon_state = "mslug"
	ammo_type = /obj/item/ammo_casing/shotgun/milspec
	max_ammo = 15

/obj/item/ammo_box/advanced/s12gauge/milspec/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/manufacturer_examine, COMPANY_SCARBOROUGH)

/obj/item/ammo_box/advanced/s12gauge/buckshot/milspec
	name = "弹药盒（军用规格鹿弹）"
	desc = "一盒15发斯卡伯勒武器公司制造的热装药军用规格鹿弹。比传统鹿弹更快、威力更强。"
	icon_state = "mbuckshot"
	ammo_type = /obj/item/ammo_casing/shotgun/buckshot/milspec
	max_ammo = 15

/obj/item/ammo_box/advanced/s12gauge/buckshot/milspec/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/manufacturer_examine, COMPANY_SCARBOROUGH)
