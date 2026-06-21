// Special ammo

// .980 grenades

/obj/item/ammo_box/magazine/ammo_stack/c980
	name = ".980 泰德豪尔榴弹"
	desc = "一叠 .980 泰德豪尔榴弹。"
	caliber = CALIBER_980TYDHOUER
	ammo_type = /obj/item/ammo_casing/c980grenade
	casing_phrasing = "shell"
	max_ammo = 6
	casing_w_spacing = 3
	casing_z_padding = 9

/obj/item/ammo_box/magazine/ammo_stack/c980/prefilled
	name = ".980 泰德豪尔训练榴弹"
	start_empty = FALSE

/obj/item/ammo_box/magazine/ammo_stack/c980/prefilled/smoke
	name = ".980 泰德豪尔烟雾榴弹"
	ammo_type = /obj/item/ammo_casing/c980grenade/smoke

/obj/item/ammo_box/magazine/ammo_stack/c980/prefilled/gas
	name = ".980 泰德豪尔催泪瓦斯榴弹"
	ammo_type = /obj/item/ammo_casing/c980grenade/riot

/obj/item/ammo_box/magazine/ammo_stack/c980/prefilled/shrap
	name = ".980 泰德豪尔破片榴弹"
	ammo_type = /obj/item/ammo_casing/c980grenade/shrapnel
	icon_state = "stack_spec"

/obj/item/ammo_box/magazine/ammo_stack/c980/prefilled/fire
	name = ".980 泰德豪尔磷光榴弹"
	ammo_type = /obj/item/ammo_casing/c980grenade/shrapnel/phosphor
	icon_state = "stack_spec"

/obj/item/ammo_box/magazine/ammo_stack/c980/prefilled/conc
	name = ".980 泰德豪尔动能震荡榴弹"
	ammo_type = /obj/item/ammo_casing/c980grenade/concussive
	icon_state = "stack_spec"

// 12ga shotgun shells

/obj/item/ammo_casing/shotgun
	ammo_stack_type = /obj/item/ammo_box/magazine/ammo_stack/s12gauge

/obj/item/ammo_box/magazine/ammo_stack/s12gauge
	name = "12号霰弹"
	desc = "一叠 12号霰弹。"
	caliber = CALIBER_SHOTGUN
	ammo_type = /obj/item/ammo_casing/shotgun
	casing_phrasing = "shell"
	max_ammo = 8
	casing_w_spacing = 3
	casing_z_padding = 4

/obj/item/ammo_box/magazine/ammo_stack/s12gauge/prefilled
	name = "12号独头弹"
	start_empty = FALSE

/obj/item/ammo_box/magazine/ammo_stack/s12gauge/prefilled/antitide
	name = "12号闪电霰弹"
	ammo_type = /obj/item/ammo_casing/shotgun/antitide
	icon_state = "stack_spec"

/obj/item/ammo_box/magazine/ammo_stack/s12gauge/prefilled/beanbag
	name = "12号豆袋弹"
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag

/obj/item/ammo_box/magazine/ammo_stack/s12gauge/prefilled/beehive
	name = "12号蜂群弹"
	ammo_type = /obj/item/ammo_casing/shotgun/beehive
	icon_state = "stack_spec"

/obj/item/ammo_box/magazine/ammo_stack/s12gauge/prefilled/breacher
	name = "12号口径破门弹"
	ammo_type = /obj/item/ammo_casing/shotgun/breacher
	icon_state = "stack_spec"

/obj/item/ammo_box/magazine/ammo_stack/s12gauge/prefilled/buckshot
	name = "12号口径鹿弹"
	ammo_type = /obj/item/ammo_casing/shotgun/buckshot

/obj/item/ammo_box/magazine/ammo_stack/s12gauge/prefilled/dragonsbreath
	name = "12号口径龙息弹"
	ammo_type = /obj/item/ammo_casing/shotgun/dragonsbreath
	icon_state = "stack_spec"

/obj/item/ammo_box/magazine/ammo_stack/s12gauge/prefilled/express
	name = "12号口径速射弹"
	ammo_type = /obj/item/ammo_casing/shotgun/express

/obj/item/ammo_box/magazine/ammo_stack/s12gauge/prefilled/flechette
	name = "12号口径撕裂者箭形弹"
	ammo_type = /obj/item/ammo_casing/shotgun/flechette_nova
	icon_state = "stack_spec"

/obj/item/ammo_box/magazine/ammo_stack/s12gauge/prefilled/frag12
	name = "12号口径破片弹"
	ammo_type = /obj/item/ammo_casing/shotgun/frag12
	icon_state = "stack_spec"

/obj/item/ammo_box/magazine/ammo_stack/s12gauge/prefilled/hunter
	name = "12号口径猎手弹"
	ammo_type = /obj/item/ammo_casing/shotgun/hunter
	icon_state = "stack_spec"

/obj/item/ammo_box/magazine/ammo_stack/s12gauge/prefilled/incendiary
	name = "12号口径燃烧弹"
	ammo_type = /obj/item/ammo_casing/shotgun/incendiary
	icon_state = "stack_spec"

/obj/item/ammo_box/magazine/ammo_stack/s12gauge/prefilled/magnum
	name = "12号口径马格南弹"
	ammo_type = /obj/item/ammo_casing/shotgun/magnum

/obj/item/ammo_box/magazine/ammo_stack/s12gauge/prefilled/rubbershot
	name = "12号口径橡胶弹"
	ammo_type = /obj/item/ammo_casing/shotgun/rubbershot

/obj/item/ammo_box/magazine/ammo_stack/s12gauge/prefilled/milspec
	name = "12号口径军用独头弹"
	ammo_type = /obj/item/ammo_casing/shotgun/milspec

/obj/item/ammo_box/magazine/ammo_stack/s12gauge/prefilled/frangible
	name = "12 gauge frangible shells"
	ammo_type = /obj/item/ammo_casing/shotgun/frangible
	icon_state = "stack_spec"

/obj/item/ammo_box/magazine/ammo_stack/s12gauge/prefilled/buckshot/milspec
	name = "12号口径军用鹿弹"
	ammo_type = /obj/item/ammo_casing/shotgun/buckshot/milspec

// Pistol ammo

// .35 sol short

/obj/item/ammo_box/magazine/ammo_stack/c35_sol
	name = ".35索尔短弹弹壳"
	desc = "一叠.35索尔短弹弹壳。"
	caliber = CALIBER_SOL35SHORT
	ammo_type = /obj/item/ammo_casing/c35sol
	max_ammo = 12
	casing_w_spacing = 2
	casing_z_padding = 6

/obj/item/ammo_box/magazine/ammo_stack/c35_sol/prefilled
	start_empty = FALSE

/obj/item/ammo_box/magazine/ammo_stack/c35_sol/prefilled/incapacitator
	name = ".35索尔短弹失能弹弹壳"
	ammo_type = /obj/item/ammo_casing/c35sol/incapacitator
	icon_state = "stack_spec"

/obj/item/ammo_box/magazine/ammo_stack/c35_sol/prefilled/ripper
	name = ".35索尔短弹撕裂者弹弹壳"
	ammo_type = /obj/item/ammo_casing/c35sol/ripper
	icon_state = "stack_spec"

// .27-54 Cesarzowa

/obj/item/ammo_box/magazine/ammo_stack/c27_54cesarzowa
	name = ".27-54切萨佐瓦弹弹壳"
	desc = "一叠.27-54切萨佐瓦弹弹壳。"
	caliber = CALIBER_CESARZOWA
	ammo_type = /obj/item/ammo_casing/c27_54cesarzowa
	max_ammo = 18
	casing_w_spacing = 2
	casing_z_padding = 6

/obj/item/ammo_box/magazine/ammo_stack/c27_54cesarzowa/prefilled
	start_empty = FALSE

/obj/item/ammo_box/magazine/ammo_stack/c27_54cesarzowa/prefilled/incapacitator
	name = ".27-54切萨佐瓦橡胶弹弹壳"
	ammo_type = /obj/item/ammo_casing/c27_54cesarzowa/rubber
	icon_state = "stack_spec"

// .585 trappiste

/obj/item/ammo_box/magazine/ammo_stack/c585_trappiste
	name = ".585特拉皮斯特弹弹壳"
	desc = "一叠 .585 特拉皮斯特弹壳。"
	caliber = CALIBER_585TRAPPISTE
	ammo_type = /obj/item/ammo_casing/c585trappiste
	max_ammo = 6
	casing_w_spacing = 2
	casing_z_padding = 9

/obj/item/ammo_box/magazine/ammo_stack/c585_trappiste/prefilled
	start_empty = FALSE

/obj/item/ammo_box/magazine/ammo_stack/c585_trappiste/prefilled/incapacitator
	name = ".585 特拉皮斯特平头弹壳"
	ammo_type = /obj/item/ammo_casing/c585trappiste/incapacitator
	icon_state = "stack_spec"

/obj/item/ammo_box/magazine/ammo_stack/c585_trappiste/prefilled/incendiary
	name = ".585 特拉皮斯特燃烧弹壳"
	ammo_type = /obj/item/ammo_casing/c585trappiste/incendiary
	icon_state = "stack_spec"

// Rifle ammo

// .40 sol long

/obj/item/ammo_box/magazine/ammo_stack/c40_sol
	name = ".40 索尔长弹壳"
	desc = "一叠 .40 索尔长弹壳。"
	caliber = CALIBER_SOL40LONG
	ammo_type = /obj/item/ammo_casing/c40sol
	max_ammo = 15
	casing_w_spacing = 2
	casing_z_padding = 6

/obj/item/ammo_box/magazine/ammo_stack/c40_sol/prefilled
	start_empty = FALSE

/obj/item/ammo_box/magazine/ammo_stack/c40_sol/prefilled/frag
	name = ".40 索尔长弹破片弹壳"
	ammo_type = /obj/item/ammo_casing/c40sol/fragmentation
	icon_state = "stack_spec"

/obj/item/ammo_box/magazine/ammo_stack/c40_sol/prefilled/incendiary
	name = ".40 索尔长弹燃烧弹壳"
	ammo_type = /obj/item/ammo_casing/c40sol/incendiary
	icon_state = "stack_spec"

/obj/item/ammo_box/magazine/ammo_stack/c40_sol/prefilled/match
	name = ".40 索尔长弹比赛级弹壳"
	ammo_type = /obj/item/ammo_casing/c40sol/pierce
	icon_state = "stack_spec"

// .310 strilka

/obj/item/ammo_casing/strilka310
	ammo_stack_type = /obj/item/ammo_box/magazine/ammo_stack/c310_strilka

/obj/item/ammo_box/magazine/ammo_stack/c310_strilka
	name = ".310 斯特里尔卡弹壳"
	desc = "一叠 .310 斯特里尔卡弹壳。"
	caliber = CALIBER_STRILKA310
	ammo_type = /obj/item/ammo_casing/strilka310
	max_ammo = 5
	casing_w_spacing = 2
	casing_z_padding = 8

/obj/item/ammo_box/magazine/ammo_stack/c310_strilka/prefilled
	start_empty = FALSE

/obj/item/ammo_box/magazine/ammo_stack/c310_strilka/prefilled/incapacitator
	name = ".310 斯特里尔卡橡胶弹壳"
	ammo_type = /obj/item/ammo_casing/strilka310/rubber
	icon_state = "stack_spec"

/obj/item/ammo_box/magazine/ammo_stack/c310_strilka/prefilled/dollar_tree
	name = ".310 斯特里尔卡剩余弹壳"
	ammo_type = /obj/item/ammo_casing/strilka310/surplus

/obj/item/ammo_box/magazine/ammo_stack/c310_strilka/prefilled/ap
	name = ".310 斯特里尔卡穿甲弹壳"
	ammo_type = /obj/item/ammo_casing/strilka310/ap
	icon_state = "stack_spec"

// .60 strela

/obj/item/ammo_box/magazine/ammo_stack/c60_strela
	name = ".60 斯特雷拉弹壳"
	desc = "一叠 .60 斯特雷拉弹壳。"
	caliber = CALIBER_60STRELA
	ammo_type = /obj/item/ammo_casing/p60strela
	max_ammo = 6
	casing_w_spacing = 3
	casing_z_padding = 9

/obj/item/ammo_box/magazine/ammo_stack/c60_strela/prefilled
	start_empty = FALSE
