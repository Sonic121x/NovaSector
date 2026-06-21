
///basic bow, used for medieval sim
/obj/item/gun/ballistic/bow/longbow
	name = "长弓"
	desc = "虽然制作相当精良，但在这个时代你肯定能找到更好的东西来用。"

/// Shortbow, made via the crafting recipe
/obj/item/gun/ballistic/bow/shortbow
	name = "短弓"
	desc = "一把简单的自制短弓。非常适合真人角色扮演。或者戳瞎别人的眼睛。"
	obj_flags = UNIQUE_RENAME
	projectile_damage_multiplier = 0.5
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 4, /datum/material/iron = SHEET_MATERIAL_AMOUNT)

///chaplain's divine archer bow
/obj/item/gun/ballistic/bow/divine
	name = "神圣之弓"
	desc = "刺穿罪人灵魂的神圣武器。"
	icon_state = "holybow"
	inhand_icon_state = "holybow"
	base_icon_state = "holybow"
	worn_icon_state = "holybow"
	slot_flags = ITEM_SLOT_BACK
	obj_flags = UNIQUE_RENAME
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/bow/holy
	projectile_damage_multiplier = 1 // NOVA EDIT: ORIGINAL projectile_damage_multiplier = 0.6
	projectile_speed_multiplier = 1.5

/obj/item/ammo_box/magazine/internal/bow/holy
	name = "神圣弓弦"
	ammo_type = /obj/item/ammo_casing/arrow/holy

/obj/item/gun/ballistic/bow/divine/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/nullrod_core)
	RegisterSignal(src, COMSIG_ITEM_SUBTYPE_PICKER_SELECTED, PROC_REF(on_selected))

/obj/item/gun/ballistic/bow/divine/proc/on_selected(datum/source, obj/item/nullrod/old_weapon, mob/picker)
	SIGNAL_HANDLER
	new /obj/item/storage/bag/quiver/holy(loc)

/// Ashen bow, crafted from watcher sinew and animal bones.
/obj/item/gun/ballistic/bow/ashenbow
	name = "灰烬之弓"
	desc = "一把由守望者肌腱和骨头制成的弓。似乎散发着一种近乎诡异的微光。"
	icon_state = "ashenbow"
	inhand_icon_state = "ashenbow"
	base_icon_state = "ashenbow"
	worn_icon_state = "ashenbow"
	slot_flags = ITEM_SLOT_BACK
	obj_flags = UNIQUE_RENAME
	projectile_damage_multiplier = 0.5
	custom_materials = list(/datum/material/bone = SHEET_MATERIAL_AMOUNT * 6)
