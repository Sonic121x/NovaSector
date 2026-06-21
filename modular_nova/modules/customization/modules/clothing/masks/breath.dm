
// Supported TG Masks
/obj/item/clothing/mask/bandana
	greyscale_config_worn_muzzled = /datum/greyscale_config/bandana/worn/muzzled
	greyscale_config_worn_vox = /datum/greyscale_config/bandana/worn/vox

/obj/item/clothing/mask/bandana/striped
	greyscale_config_worn_muzzled = /datum/greyscale_config/bandana/striped/worn/muzzled
	greyscale_config_worn_vox = /datum/greyscale_config/bandana/striped/worn/vox

/obj/item/clothing/mask/bandana/skull
	greyscale_config_worn_muzzled = /datum/greyscale_config/bandana/skull/worn/muzzled
	greyscale_config_worn_vox = /datum/greyscale_config/bandana/skull/worn/vox

/obj/item/clothing/mask/muzzle/tape
	supports_variations_flags = CLOTHING_SNOUTED_VARIATION | CLOTHING_SNOUTED_VOX_VARIATION
	greyscale_config_worn_muzzled = /datum/greyscale_config/tape_piece/worn/muzzled
	greyscale_config_worn_vox = /datum/greyscale_config/tape_piece/worn/vox

/obj/item/clothing/mask/muzzle/tape/pointy
	greyscale_config_worn_muzzled = /datum/greyscale_config/tape_piece/worn/muzzled
	greyscale_config_worn_vox = /datum/greyscale_config/tape_piece/worn/vox

/obj/item/clothing/mask/cigarette
	supports_variations_flags = CLOTHING_SNOUTED_VOX_VARIATION

/obj/item/vape
	worn_icon_vox = 'modular_nova/master_files/icons/mob/clothing/species/vox/mask.dmi'
	supports_variations_flags = CLOTHING_SNOUTED_VOX_VARIATION
	greyscale_config_worn_vox = /datum/greyscale_config/vape/worn/vox

// Modular masks

/obj/item/clothing/mask/breath/vox
	desc = "一种可以连接到供气系统的贴合面罩。这款有一个易于使用的进食口，更适合沃克斯族船员。"
	name = "沃克斯呼吸面罩"
	actions_types = list()
	flags_cover = NONE

/obj/item/clothing/mask/balaclava/adjustable
	name = "可调节巴拉克拉法帽"
	desc = "这款面罩的眼部开口更宽，采用弹性材料制成，似乎能更好地贴合面部轮廓。"
	icon = 'modular_nova/master_files/icons/obj/clothing/masks.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/mask.dmi'
	icon_state = "balaclava_adj"
	var/open = 0 //0 = full, 1 = head only, 2 = face only
	actions_types = list(/datum/action/item_action/toggle)

/obj/item/clothing/mask/balaclava/adjustable/attack_self(mob/user)
	adjust_mask(user)

/obj/item/clothing/mask/balaclava/adjustable/proc/adjust_mask(mob/living/carbon/human/user)
	if(!istype(user))
		return
	if(!user.incapacitated)
		switch(open)
			if (0)
				flags_inv = HIDEHAIR
				icon_state = initial(icon_state) + "_open"
				to_chat(user, span_notice("你将巴拉克拉瓦头套拉下，露出了你的脸。"))
				open = 1
			if (1)
				flags_inv = HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
				icon_state = initial(icon_state) + "_mouth"
				to_chat(user, span_notice("你将巴拉克拉瓦头套向上调整以遮住嘴巴。"))
				open = 2
			else
				flags_inv = HIDEFACE|HIDEFACIALHAIR|HIDEHAIR
				icon_state = initial(icon_state)
				to_chat(user, span_notice("你将巴拉克拉瓦头套完全拉起，遮住了整个头部。"))
				open = 0
		user.update_clothing(slot_flags)

/obj/item/clothing/mask/balaclava/threehole
	name = "三孔巴拉克拉瓦头套"
	icon = 'modular_nova/master_files/icons/obj/clothing/masks.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/mask.dmi'
	icon_state = "balaclavam"
	inhand_icon_state = "balaclava"
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	visor_flags_inv = HIDEHAIR

/obj/item/clothing/mask/balaclava/threehole/green
	name = "绿色三孔巴拉克拉瓦头套"
	icon = 'modular_nova/master_files/icons/obj/clothing/masks.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/mask.dmi'
	icon_state = "swatclavam"
	inhand_icon_state = "balaclava"

/obj/item/clothing/mask/surgical/greyscale
	worn_icon = 'modular_nova/modules/GAGS/icons/masks.dmi'
	flags_1 = IS_PLAYER_COLORABLE_1
	greyscale_colors = "#AAE4DB"
	icon = 'icons/map_icons/clothing/mask.dmi'
	icon_state = "/obj/item/clothing/mask/surgical/greyscale"
	post_init_icon_state = "sterile"
	greyscale_config = /datum/greyscale_config/sterile_mask
	greyscale_config_worn = /datum/greyscale_config/sterile_mask/worn
	greyscale_config_worn_digi = /datum/greyscale_config/sterile_mask/worn/snouted
	greyscale_config_worn_better_vox = /datum/greyscale_config/sterile_mask/worn/better_vox
	greyscale_config_worn_vox = /datum/greyscale_config/sterile_mask/worn/vox
	greyscale_config_worn_teshari = /datum/greyscale_config/sterile_mask/worn/teshari
