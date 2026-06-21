/obj/item/clothing/mask/gas/glass
	icon = 'modular_nova/master_files/icons/obj/clothing/masks.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/mask.dmi'
	name = "玻璃面罩防毒面具"
	desc = "一种可以连接到供气系统的面部遮盖面罩。不过这款不会遮挡你的面容。"
	icon_state = "gas_clear"
	flags_inv = NONE

/obj/item/clothing/mask/gas/atmos/glass
	icon = 'modular_nova/master_files/icons/obj/clothing/masks.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/mask.dmi'
	name = "高级防毒面具"
	desc = "一种可以连接到供气系统的面部遮盖面罩。不过这款不会遮挡你的面容。"
	icon_state = "gas_clear"
	flags_inv = NONE

/obj/item/clothing/mask/gas/alt
	icon = 'modular_nova/master_files/icons/obj/clothing/masks.dmi'
	icon_state = "gas_alt2"
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/mask.dmi'
	dirt_state = "gas_wide_dirt"

/obj/item/clothing/mask/gas/hecu
	name = "M40防毒面具"
	desc = "一种在20世纪于索尔-3开发的、现已过时的野战防护面具。设计用于防护化学战剂、生物战剂和核辐射尘埃颗粒。它不能保护使用者免受氨气或缺氧的伤害，不过其过滤器可以替换为连接任何气罐的软管。"
	icon = 'modular_nova/master_files/icons/obj/clothing/masks.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/mask.dmi'
	worn_icon_teshari = 'modular_nova/master_files/icons/mob/clothing/species/teshari/mask.dmi'
	icon_state = "hecu"

/obj/item/clothing/mask/gas/clown_colourable
	name = "可着色小丑面具"
	desc = "纯粹邪恶的面孔，如今色彩斑斓。"
	clothing_flags = MASKINTERNALS
	flags_cover = MASKCOVERSEYES
	resistance_flags = FLAMMABLE
	icon = 'icons/map_icons/clothing/mask.dmi'
	icon_state = "/obj/item/clothing/mask/gas/clown_colourable"
	post_init_icon_state = "gags_mask"
	greyscale_config = /datum/greyscale_config/clown_mask
	greyscale_config_worn = /datum/greyscale_config/clown_mask/worn
	greyscale_colors = "#FFFFFF#F20018#0000FF#00CC00"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/mask/gas/clownbald
	name = "秃头小丑面具"
	desc = "他秃了！他他妈秃了！"
	clothing_flags = MASKINTERNALS
	icon = 'modular_nova/master_files/icons/obj/clothing/masks.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/mask.dmi'
	icon_state = "baldclown"
	inhand_icon_state = null
	flags_cover = MASKCOVERSEYES
	resistance_flags = FLAMMABLE

/obj/item/clothing/mask/gas/pink_clown_wig
	name = "粉色小丑假发"
	desc = "一团棉花糖粉色的假发。配有一个圆润、光泽的红色小丑鼻子，可以紧密地固定在脸上。"
	clothing_flags = MASKINTERNALS
	icon = 'modular_nova/master_files/icons/obj/clothing/masks.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/mask.dmi'
	icon_state = "pink_clown_wig"
	inhand_icon_state = null
	flags_inv = HIDEHAIR
	resistance_flags = FLAMMABLE

/obj/item/clothing/mask/gas/respirator
	name = "半面罩呼吸器"
	desc = "一个半面罩呼吸器，其实就是把标准防毒面具的玻璃镜片取掉了。"
	worn_icon = 'modular_nova/modules/GAGS/icons/masks.dmi'
	inhand_icon_state = "sechailer"
	w_class = WEIGHT_CLASS_SMALL
	clothing_flags = BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS
	flags_inv = HIDEFACIALHAIR|HIDESNOUT
	flags_cover = MASKCOVERSMOUTH
	flags_1 = IS_PLAYER_COLORABLE_1
	greyscale_colors = "#2E3333"
	icon = 'icons/map_icons/clothing/mask.dmi'
	icon_state = "/obj/item/clothing/mask/gas/respirator"
	post_init_icon_state = "respirator"
	greyscale_config = /datum/greyscale_config/respirator
	greyscale_config_worn = /datum/greyscale_config/respirator/worn
	//NIGHTMARE NIGHTMARE NIGHTMARE
	greyscale_config_worn_digi = /datum/greyscale_config/respirator/worn/snouted
	greyscale_config_worn_better_vox = /datum/greyscale_config/respirator/worn/better_vox
	greyscale_config_worn_vox = /datum/greyscale_config/respirator/worn/vox
	greyscale_config_worn_teshari = /datum/greyscale_config/respirator/worn/teshari

/obj/item/clothing/mask/gas/respirator/examine(mob/user)
	. = ..()
	. += span_notice("你可以用<b>Ctrl+点击</b>来切换其是否模糊你的TTS语音。")

/obj/item/clothing/mask/gas/respirator/item_ctrl_click(mob/user)
	if(!isliving(user))
		return CLICK_ACTION_BLOCKING
	if(user.get_active_held_item() != src)
		to_chat(user, span_warning("你必须将[src]拿在手中才能这样做！"))
		return CLICK_ACTION_BLOCKING
	voice_filter = voice_filter ? null : initial(voice_filter)
	to_chat(user, span_notice("面罩声音模糊[voice_filter ? "enabled" : "disabled"]。"))
	return CLICK_ACTION_SUCCESS

/obj/item/clothing/mask/gas/clown_hat/vox
	desc = "A true prankster's facial attire. A clown is incomplete without his wig and mask. This one's got an easily accessible feeding port to be more suitable for the Vox crewmembers."
	icon = 'modular_nova/master_files/icons/mob/clothing/species/vox/mask.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/species/vox/mask.dmi'
	worn_icon_better_vox = 'modular_nova/master_files/icons/mob/clothing/species/vox/mask.dmi'
	worn_icon_vox = 'modular_nova/master_files/icons/mob/clothing/species/vox/mask.dmi'
	starting_filter_type = /obj/item/gas_filter/vox

/obj/item/clothing/mask/gas/clown_hat/vox/Initialize(mapload)
	.=..()
	clownmask_designs = list(
		"True Form" = image(icon = src.icon, icon_state = "clown"),
		"The Feminist" = image(icon = src.icon, icon_state = "sexyclown"),
		"The Wizard" = image(icon = src.icon, icon_state = "wizzclown"),
		"The Jester" = image(icon = src.icon, icon_state = "chaos"),
		"The Madman" = image(icon = src.icon, icon_state = "joker"),
		"The Rainbow Color" = image(icon = src.icon, icon_state = "rainbow")
		)

/obj/item/clothing/mask/gas/clown_hat/vox/ui_action_click(mob/user)
	if(!istype(user) || user.incapacitated)
		return

	var/list/options = list()
	options["True Form"] = "clown"
	options["The Feminist"] = "sexyclown"
	options["The Wizard"] = "wizzclown"
	options["The Madman"] = "joker"
	options["The Rainbow Color"] = "rainbow"
	options["The Jester"] = "chaos"

	var/choice = show_radial_menu(user,src, clownmask_designs, custom_check = FALSE, radius = 36, require_near = TRUE)
	if(!choice)
		return FALSE

	if(src && choice && !user.incapacitated && in_range(user,src))
		icon_state = options[choice]
		user.update_worn_mask()
		update_item_action_buttons()
		to_chat(user, span_notice("你的小丑面具现已变形为[choice]，赞美Honkmother！"))
		return TRUE

/obj/item/clothing/mask/gas/mime/vox
	desc = "The traditional mime's mask. It has an eerie facial posture. This one's got an easily accessible feeding port to be more suitable for the Vox crewmembers."
	icon = 'modular_nova/master_files/icons/mob/clothing/species/vox/mask.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/species/vox/mask.dmi'
	worn_icon_vox = 'modular_nova/master_files/icons/mob/clothing/species/vox/mask.dmi'
	worn_icon_better_vox = 'modular_nova/master_files/icons/mob/clothing/species/vox/mask.dmi'
	starting_filter_type = /obj/item/gas_filter/vox

/obj/item/clothing/mask/gas/mime/vox/Initialize(mapload)
	.=..()
	mimemask_designs = list(
		"Blanc" = image(icon = src.icon, icon_state = "mime"),
		"Excité" = image(icon = src.icon, icon_state = "sexymime"),
		"Triste" = image(icon = src.icon, icon_state = "sadmime"),
		"Effrayé" = image(icon = src.icon, icon_state = "scaredmime")
		)

/obj/item/clothing/mask/gas/mime/vox/ui_action_click(mob/user)
	if(!istype(user) || user.incapacitated)
		return

	var/list/options = list()
	options["Blanc"] = "mime"
	options["Triste"] = "sadmime"
	options["Effrayé"] = "scaredmime"
	options["Excité"] = "sexymime"

	var/choice = show_radial_menu(user,src, mimemask_designs, custom_check = FALSE, radius = 36, require_near = TRUE)
	if(!choice)
		return FALSE

	if(src && choice && !user.incapacitated && in_range(user,src))
		var/mob/living/carbon/human/human_user = user
		if(human_user.dna.mutant_bodyparts[FEATURE_SNOUT])
			icon = 'modular_nova/master_files/icons/obj/clothing/masks.dmi'
			worn_icon = 'modular_nova/master_files/icons/mob/clothing/mask_muzzled.dmi'
		else
			icon = 'modular_nova/master_files/icons/mob/clothing/species/vox/mask.dmi'
			worn_icon = 'modular_nova/master_files/icons/mob/clothing/species/vox/mask.dmi'
			icon_state = options[choice]
		icon_state = options[choice]

		user.update_worn_mask()
		update_item_action_buttons()
		to_chat(user, span_notice("你的默剧面具现已变形为[choice]！"))
		return TRUE

/obj/item/clothing/mask/gas/atmos/vox
	desc = "大气技术人员使用的改进型防毒面具。它是防火的！这款面具有一个易于使用的进食口，更适合沃克斯族船员。"
	icon = 'modular_nova/master_files/icons/mob/clothing/species/vox/mask.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/species/vox/mask.dmi'
	worn_icon_vox = 'modular_nova/master_files/icons/mob/clothing/species/vox/mask.dmi'
	worn_icon_better_vox = 'modular_nova/master_files/icons/mob/clothing/species/vox/mask.dmi'
	starting_filter_type = /obj/item/gas_filter/vox

/obj/item/clothing/mask/gas/sechailer/vox
	desc = "安保部门标准配发的防毒面具，集成了'Compli-o-nator 3000'装置。可播放十几种预先录制的合规短语，旨在让渣滓在你电击他们时保持不动。请勿篡改该装置。这款面具有一个易于使用的进食口，更适合沃克斯族船员。"
	icon = 'modular_nova/master_files/icons/mob/clothing/species/vox/mask.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/species/vox/mask.dmi'
	worn_icon_vox = 'modular_nova/master_files/icons/mob/clothing/species/vox/mask.dmi'
	worn_icon_better_vox = 'modular_nova/master_files/icons/mob/clothing/species/vox/mask.dmi'
	clothing_flags = BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS | GAS_FILTERING
	visor_flags = BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS | GAS_FILTERING
	starting_filter_type = /obj/item/gas_filter/vox
