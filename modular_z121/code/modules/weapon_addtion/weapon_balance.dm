/// 各种武器平衡
/obj/item/gun/ballistic/automatic/pistol/sol // 我都没见过有人买这枪
	projectile_damage_multiplier = 1.5 // 16x1.5=24，作为单手武器刚刚好

/obj/item/gun/ballistic/revolver/takbok // 诶呦我去，后座极大，且只有6发子弹的枪，不加强谁爱用啊？
	recoil = 1 // 3 → 1

/obj/item/gun/ballistic/revolver/bluvolva // 去掉后座，提一提手感
	recoil = 0 // 1 → 0

/obj/item/gun/ballistic/automatic/miecz // 0.35射速？15外伤？30穿甲？不加强不如wt550穿甲弹
	fire_delay = 0.25 SECONDS //0.35 → 0.25
	fire_sound_volume = 40 // 诶呦我滴妈呀……我的耳膜

/obj/item/gun/ballistic/shotgun/katyusha // 0.8秒太慢了，不如用M64，或者战斗霰弹枪
	fire_delay = 0.6 SECONDS // 0.8 → 0.6

// /obj/item/gun/ballistic/automatic/lanca
// 	projectile_speed_multiplier = 1.2

/obj/item/gun/ballistic/revolver/shotgun_revolver // 一个弹匣容量4发的半自动左轮？还没有射速限制？还不要持枪证？太离谱了！
	fire_delay = 0.7 SECONDS // 0.4 → 0.7

// /obj/item/gun/ballistic/automatic/pistol/zashch
// 	fire_delay = 0.8 SECONDS

/obj/item/ammo_box/magazine/zashch // 10mm？20发？什么亚空间弹匣？
	max_ammo = 12 // 20 → 12

/obj/item/gun/ballistic/automatic/napad // 不加强，无人问津……
	fire_delay = 0.4 SECONDS // 0.55 → 0.4

/obj/item/ammo_box/magazine/napad // 这弹匣太大了！还只能装40发
	w_class = WEIGHT_CLASS_SMALL

/obj/item/ammo_casing/energy/lasergun/carbine // 数值怪！
	delay = 0.8 SECONDS

/obj/item/ammo_casing/energy/lasergun/assault // 高伤！高射速！高弹速！太恐怖了！！！
	delay = 0.8 SECONDS

/obj/item/gun/ballistic/rifle/pulse_sniper // 我希望它可以刚好三枪击倒无甲人
	projectile_damage_multiplier = 2 // 1.8 → 2

// /obj/item/gun/ballistic/automatic/wylom
// 	fire_delay = 1.5 SECONDS

/obj/item/gun/ballistic/rifle/sks // 我不希望伤害太高
	projectile_damage_multiplier = 0.7 // 50x0.7=35
	projectile_speed_multiplier = 0.9 // 1.5x0.9=1.35

/// 弹药数值平衡
/obj/projectile/bullet/strilka310 // .310 Strilka没法完美做到3枪击倒人，我将它的伤害调高了5点。使用这种子弹的枪，要么射速慢，要么操作繁琐，我提高了的弹速
	damage = 50  // 45 → 50
	speed = 1.5 // 1.25 → 1.5

/obj/projectile/bullet/strilka310/rubber
	stamina = 50 // 35 → 50
// .310 Strilka AP穿透已经够高了，作为弹药已经非常强大了
// /obj/projectile/bullet/strilka310/ap
// 	damage = 40 // 35 → 40

/obj/projectile/bullet/c40sol/fragmentation // .40sol 的橡胶弹数值有点低，如果有护甲弱效，泛用性会大打折扣
	stamina = 30 // 26 → 30
	weak_against_armour = FALSE // TRUE → FALSE

/obj/projectile/bullet/c35sol/ripper // .35sol 撕裂弹几乎没用，打人形目标，但护甲弱效，人形目标大部分有甲。打简单生物，伤害不够
	wound_bonus = 30 // 20 → 30 是的，我希望它更容易重伤流血
	weak_against_armour = FALSE // TRUE → FALSE

/obj/projectile/bullet/c585trappiste // 我认为，585 的伤害应该再高一点点
	damage = 35  // 30 → 35

/obj/projectile/bullet/c585trappiste/incapacitator
	stamina = 40 // 30 → 40
	weak_against_armour = FALSE // TRUE → FALSE

/obj/projectile/bullet/c27_54cesarzowa/rubber // 橡胶弹带护甲弱效没有大用，我移除了护甲弱效
	weak_against_armour = FALSE // TRUE → FALSE

// /obj/projectile/bullet/p60strela
// 	damage = 60 // 50 → 60

// /obj/projectile/beam/xray/no_wallbang
// 	reflectable = FALSE // TRUE → FALSE
