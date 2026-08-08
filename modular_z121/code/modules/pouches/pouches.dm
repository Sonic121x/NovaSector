

/obj/item/storage/pouch/generic_pouch
        name = "小型口袋"
        desc = "一个用来容纳物品的小型口袋, 能装下 2 个小物品"
        icon = 'modular_z121/icons/obj/clothing/pouch.dmi'
        icon_state = "small_generic"
        slot_flags = ITEM_SLOT_POCKETS

/obj/item/storage/pouch/generic_pouch/Initialize(mapload)
        . = ..()
        atom_storage.max_specific_storage = WEIGHT_CLASS_SMALL
        atom_storage.max_slots = 2
        atom_storage.max_total_storage = WEIGHT_CLASS_SMALL * 2

/obj/item/storage/pouch/expanded_pouch
        name = "扩容口袋"
        desc = "一个更大的口袋, 扩容后拥有更大的容量, 能装 3 个小物品"
        icon = 'modular_z121/icons/obj/clothing/pouch.dmi'
        icon_state = "medium_generic"
        slot_flags = ITEM_SLOT_POCKETS

/obj/item/storage/pouch/expanded_pouch/Initialize(mapload)
        . = ..()
        atom_storage.max_specific_storage = WEIGHT_CLASS_SMALL
        atom_storage.max_slots = 3
        atom_storage.max_total_storage = WEIGHT_CLASS_SMALL * 3
        atom_storage.numerical_stacking = FALSE

/obj/item/storage/pouch/carrying_pouch
        name = "载重口袋"
        desc = "一个增加载重能力的口袋,  能容纳 1 个普通物品"
        icon = 'modular_z121/icons/obj/clothing/pouch.dmi'
        icon_state = "large_generic"
        slot_flags = ITEM_SLOT_POCKETS

/obj/item/storage/pouch/carrying_pouch/Initialize(mapload)
        . = ..()
        atom_storage.max_specific_storage = WEIGHT_CLASS_NORMAL
        atom_storage.max_slots = 2
        atom_storage.max_total_storage = WEIGHT_CLASS_NORMAL + WEIGHT_CLASS_SMALL
        atom_storage.numerical_stacking = FALSE
