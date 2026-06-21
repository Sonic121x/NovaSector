// .27-54 Cesarzowa
// Small caliber pistol round meant to be fired out of something that shoots real quick like

/obj/item/ammo_casing/c27_54cesarzowa
	name = ".27-54 切萨佐瓦穿甲弹弹壳"
	desc = "一个紫色弹体的无壳弹，内含一枚带有精细尖头的小型弹头。"

	icon = 'modular_nova/modules/modular_weapons/icons/obj/company_and_or_faction_based/szot_dynamica/ammo.dmi'
	icon_state = "27-54cesarzowa"

	caliber = CALIBER_CESARZOWA
	projectile_type = /obj/projectile/bullet/c27_54cesarzowa
	ammo_stack_type = /obj/item/ammo_box/magazine/ammo_stack/c27_54cesarzowa

/obj/item/ammo_casing/c27_54cesarzowa/Initialize(mapload)
	. = ..()

	AddElement(/datum/element/caseless)

/obj/projectile/bullet/c27_54cesarzowa
	name = ".27-54 切萨佐瓦穿甲弹"
	damage = 15
	armour_penetration = 30
	wound_bonus = -20
	exposed_wound_bonus = 20 // if we're hitting exposed, the negative should be canceled by the exposure? maybe? probably.

/obj/item/ammo_box/c27_54cesarzowa
	name = "弹药盒 (.27-54 切萨佐瓦穿甲弹)"
	desc = "一盒.27-54切萨佐瓦穿甲手枪弹，内装二十八发子弹。"

	icon = 'modular_nova/modules/modular_weapons/icons/obj/company_and_or_faction_based/szot_dynamica/ammo.dmi'
	icon_state = "27-54cesarzowa_box"

	multiple_sprites = AMMO_BOX_FULL_EMPTY

	w_class = WEIGHT_CLASS_NORMAL

	caliber = CALIBER_CESARZOWA
	ammo_type = /obj/item/ammo_casing/c27_54cesarzowa
	max_ammo = 28

// .27-54 Cesarzowa rubber
// Small caliber pistol round meant to be fired out of something that shoots real quick like, this one is less lethal

/obj/item/ammo_casing/c27_54cesarzowa/rubber
	name = ".27-54 切萨佐瓦橡胶弹弹壳"
	desc = "一个紫色弹体的无壳弹，内含一枚带有扁平橡胶弹头的小型弹头。"

	icon_state = "27-54cesarzowa_rubber"
	ammo_categories = AMMO_CLASS_NONE
	projectile_type = /obj/projectile/bullet/c27_54cesarzowa/rubber

/obj/projectile/bullet/c27_54cesarzowa/rubber
	name = ".27-54 切萨佐瓦橡胶弹"
	stamina = 18
	damage = 5
	weak_against_armour = TRUE
	wound_bonus = -30
	exposed_wound_bonus = -10
	sharpness = NONE

/obj/item/ammo_box/c27_54cesarzowa/rubber
	name = "弹药盒 (.27-54 切萨佐瓦橡胶弹)"
	desc = "一盒.27-54切萨佐瓦橡胶手枪弹，内装二十八发子弹。"

	icon_state = "27-54cesarzowa_box_rubber"

	ammo_type = /obj/item/ammo_casing/c27_54cesarzowa/rubber
