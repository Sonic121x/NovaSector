// Folder which supplies the vouchers to the player
/obj/item/folder/syndicate/vouchers
	name = "装备凭证文件夹"
	icon_state = "folder_sblue"

/obj/item/folder/syndicate/vouchers/Initialize(mapload)
	. = ..()
	new /obj/item/paper/fluff/midround_traitor/voucher_instruction(src)
	new /obj/item/paper/paperslip/corporate/syndicate/traitor/primary(src)
	new /obj/item/paper/paperslip/corporate/syndicate/traitor/secondary(src)
	new /obj/item/paper/paperslip/corporate/syndicate/traitor/exosuit(src)
	new /obj/item/paper/paperslip/corporate/syndicate/traitor/implant(src)
	new /obj/item/paper/paperslip/corporate/syndicate/traitor/supplies(src)
	update_appearance()
	enable_shine()
	RegisterSignal(src, COMSIG_ITEM_EQUIPPED, PROC_REF(disable_shine))

/obj/item/folder/syndicate/vouchers/proc/enable_shine()
	add_filter("shine", 1, list("type" = "rays", "size" = 28, "color" = COLOR_VIVID_YELLOW))
	animate(get_filter("shine"), offset = 100, time = 2 MINUTES, loop = -1, flags = ANIMATION_PARALLEL)

/obj/item/folder/syndicate/vouchers/proc/disable_shine()
	SIGNAL_HANDLER
	remove_filter("shine")
	UnregisterSignal(src, COMSIG_ITEM_EQUIPPED)

// Plastic slips
/obj/item/paper/paperslip/corporate/syndicate
	icon = 'modular_nova/master_files/icons/obj/bureaucracy.dmi' //https://github.com/tgstation/tgstation/pull/92091
	icon_state = "slip_red"

/obj/item/paper/paperslip/corporate/syndicate/traitor
	desc = "一张印有数据字符串的塑料卡片。这些卡片作为装备凭证，其数据字符串可被各种机器下载以解锁装备。"

/obj/item/paper/paperslip/corporate/syndicate/traitor/Initialize(mapload)
	. = ..()
	var/list/characters = list()
	characters += GLOB.alphabet
	characters += GLOB.alphabet_upper
	characters += GLOB.numerals
	var/data_string = random_string(rand(180,220), characters)
	add_raw_text(data_string)
	update_appearance()

/obj/item/paper/paperslip/corporate/syndicate/traitor/primary
	name = "主武器凭证"
	icon_state = "slip_red_stripe"

/obj/item/paper/paperslip/corporate/syndicate/traitor/secondary
	name = "副武器凭证"
	icon_state = "slip_red"

/obj/item/paper/paperslip/corporate/syndicate/traitor/exosuit
	name = "机器人外骨骼凭证"
	icon_state = "slip_purple"

/obj/item/paper/paperslip/corporate/syndicate/traitor/implant
	name = "医疗植入体凭证"
	icon_state = "slip_lightblue"

/obj/item/paper/paperslip/corporate/syndicate/traitor/supplies
	name = "通用补给凭证"
	icon_state = "slip_brown"
