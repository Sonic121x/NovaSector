/obj/item/encryptionkey
	name = "标准加密密钥"
	icon = 'icons/map_icons/items/encryptionkey.dmi'
	icon_state = "/obj/item/encryptionkey"
	post_init_icon_state = "cypherkey_basic"
	desc = "用于无线电耳机的加密密钥。"
	w_class = WEIGHT_CLASS_TINY
	greyscale_config = /datum/greyscale_config/encryptionkey_basic
	greyscale_colors = "#820a16#3758c4"
	/// What channels does this encryption key grant to the parent headset.
	var/list/channels = list()
	/// Flags for which "special" radio networks should be accessible
	var/special_channels = NONE
	/// Assoc list of language to how well understood it is. 0 is invalid, 100 is perfect.
	var/list/language_data

/obj/item/encryptionkey/examine(mob/user)
	. = ..()
	if(!LAZYLEN(channels) && !(special_channels & RADIO_SPECIAL_BINARY) && !LAZYLEN(language_data))
		. += span_warning("里面没有特殊代码。你或许应该告诉程序员！")
		return

	var/list/examine_text_list = list()
	for(var/i in channels)
		examine_text_list += "[GLOB.channel_tokens[i]] - [LOWER_TEXT(i)]"

	if(special_channels & RADIO_SPECIAL_BINARY)
		examine_text_list += "[GLOB.channel_tokens[MODE_BINARY]] - [MODE_BINARY]"

	if(length(examine_text_list))
		. += span_notice("它可以访问以下频道；[jointext(examine_text_list, ", ")]。")

	var/list/language_text_list = list()
	for(var/lang in language_data)
		var/langstring = "[GLOB.language_datum_instances[lang].name]"
		switch(language_data[lang])
			if(25 to 50)
				langstring += " (poor)"
			if(50 to 75)
				langstring += " (average)"
			if(75 to 100)
				langstring += " (good)"
		language_text_list += langstring

	if(length(language_text_list))
		. += span_notice("它可以翻译以下语言；[jointext(language_text_list, ", ")]。")

/obj/item/encryptionkey/syndicate
	name = "辛迪加加密密钥"
	icon = 'icons/map_icons/items/encryptionkey.dmi'
	icon_state = "/obj/item/encryptionkey/syndicate"
	post_init_icon_state = "cypherkey_syndicate"
	channels = list(RADIO_CHANNEL_SYNDICATE = 1)
	special_channels = RADIO_SPECIAL_SYNDIE
	greyscale_config = /datum/greyscale_config/encryptionkey_syndicate
	greyscale_colors = "#171717#990000"

/obj/item/encryptionkey/binary
	name = "二进制翻译密钥"
	icon = 'icons/map_icons/items/encryptionkey.dmi'
	icon_state = "/obj/item/encryptionkey/binary"
	post_init_icon_state = "cypherkey_basic"
	special_channels = RADIO_SPECIAL_BINARY
	language_data = list(
		/datum/language/machine = 100,
	)
	greyscale_config = /datum/greyscale_config/encryptionkey_basic
	greyscale_colors = "#24a157#3758c4"

/obj/item/encryptionkey/headset_sec
	name = "安全无线电加密密钥"
	icon = 'icons/map_icons/items/encryptionkey.dmi'
	icon_state = "/obj/item/encryptionkey/headset_sec"
	post_init_icon_state = "cypherkey_security"
	channels = list(RADIO_CHANNEL_SECURITY = 1)
	greyscale_config = /datum/greyscale_config/encryptionkey_security
	greyscale_colors = "#820a16#280b1a"

/obj/item/encryptionkey/headset_eng
	name = "工程无线电加密密钥"
	icon = 'icons/map_icons/items/encryptionkey.dmi'
	icon_state = "/obj/item/encryptionkey/headset_eng"
	post_init_icon_state = "cypherkey_engineering"
	channels = list(RADIO_CHANNEL_ENGINEERING = 1)
	greyscale_config = /datum/greyscale_config/encryptionkey_engineering
	greyscale_colors = "#f8d860#dca01b"

/obj/item/encryptionkey/headset_rob
	name = "机器人学无线电加密密钥"
	icon = 'icons/map_icons/items/encryptionkey.dmi'
	icon_state = "/obj/item/encryptionkey/headset_rob"
	post_init_icon_state = "cypherkey_engineering"
	channels = list(RADIO_CHANNEL_SCIENCE = 1, RADIO_CHANNEL_ENGINEERING = 1)
	greyscale_config = /datum/greyscale_config/encryptionkey_engineering
	greyscale_colors = "#793a80#dca01b"

/obj/item/encryptionkey/headset_med
	name = "医疗无线电加密密钥"
	icon = 'icons/map_icons/items/encryptionkey.dmi'
	icon_state = "/obj/item/encryptionkey/headset_med"
	post_init_icon_state = "cypherkey_medical"
	channels = list(RADIO_CHANNEL_MEDICAL = 1)
	greyscale_config = /datum/greyscale_config/encryptionkey_medical
	greyscale_colors = "#ebebeb#69abd1"

/obj/item/encryptionkey/headset_sci
	name = "科学无线电加密密钥"
	icon = 'icons/map_icons/items/encryptionkey.dmi'
	icon_state = "/obj/item/encryptionkey/headset_sci"
	post_init_icon_state = "cypherkey_research"
	channels = list(RADIO_CHANNEL_SCIENCE = 1)
	greyscale_config = /datum/greyscale_config/encryptionkey_research
	greyscale_colors = "#793a80#bc4a9b"

/obj/item/encryptionkey/headset_medsci
	name = "医学研究无线电加密密钥"
	icon = 'icons/map_icons/items/encryptionkey.dmi'
	icon_state = "/obj/item/encryptionkey/headset_medsci"
	post_init_icon_state = "cypherkey_medical"
	channels = list(RADIO_CHANNEL_SCIENCE = 1, RADIO_CHANNEL_MEDICAL = 1)
	greyscale_config = /datum/greyscale_config/encryptionkey_medical
	greyscale_colors = "#ebebeb#9d1de8"

/obj/item/encryptionkey/headset_srvsec
	name = "法律与秩序无线电加密密钥"
	icon = 'icons/map_icons/items/encryptionkey.dmi'
	icon_state = "/obj/item/encryptionkey/headset_srvsec"
	post_init_icon_state = "cypherkey_service"
	channels = list(RADIO_CHANNEL_SERVICE = 1, RADIO_CHANNEL_SECURITY = 1)
	greyscale_config = /datum/greyscale_config/encryptionkey_service
	greyscale_colors = "#820a16#3bca5a"

/obj/item/encryptionkey/headset_srvmed
	name = "心理学无线电加密密钥"
	icon = 'icons/map_icons/items/encryptionkey.dmi'
	icon_state = "/obj/item/encryptionkey/headset_srvmed"
	post_init_icon_state = "cypherkey_service"
	channels = list(RADIO_CHANNEL_MEDICAL = 1, RADIO_CHANNEL_SERVICE = 1)
	greyscale_config = /datum/greyscale_config/encryptionkey_service
	greyscale_colors = "#ebebeb#3bca5a"

/obj/item/encryptionkey/headset_srvent
	name = "新闻无线电加密密钥"
	icon = 'icons/map_icons/items/encryptionkey.dmi'
	icon_state = "/obj/item/encryptionkey/headset_srvent"
	post_init_icon_state = "cypherkey_service"
	channels = list(RADIO_CHANNEL_SERVICE = 1, RADIO_CHANNEL_ENTERTAINMENT = 0)
	greyscale_config = /datum/greyscale_config/encryptionkey_service
	greyscale_colors = "#83eb8f#3bca5a"

/obj/item/encryptionkey/headset_com
	name = "指挥无线电加密密钥"
	icon = 'icons/map_icons/items/encryptionkey.dmi'
	icon_state = "/obj/item/encryptionkey/headset_com"
	post_init_icon_state = "cypherkey_cube"
	channels = list(RADIO_CHANNEL_COMMAND = 1)
	greyscale_config = /datum/greyscale_config/encryptionkey_cube
	greyscale_colors = "#2b2793#67a552"

/obj/item/encryptionkey/heads
	flags_1 = parent_type::flags_1 | NO_NEW_GAGS_PREVIEW_1

/obj/item/encryptionkey/heads/captain
	name = "\proper 舰长的加密密钥"
	icon = 'icons/map_icons/items/encryptionkey.dmi'
	icon_state = "/obj/item/encryptionkey/heads/captain"
	post_init_icon_state = "cypherkey_cube"
	channels = list(RADIO_CHANNEL_COMMAND = 1, RADIO_CHANNEL_SECURITY = 1, RADIO_CHANNEL_ENGINEERING = 0, RADIO_CHANNEL_SCIENCE = 0, RADIO_CHANNEL_MEDICAL = 0, RADIO_CHANNEL_SUPPLY = 0, RADIO_CHANNEL_SERVICE = 0)
	greyscale_config = /datum/greyscale_config/encryptionkey_cube
	greyscale_colors = "#2b2793#dca01b"

/obj/item/encryptionkey/heads/rd
	name = "\proper 研究主管的加密密钥"
	icon = 'icons/map_icons/items/encryptionkey.dmi'
	icon_state = "/obj/item/encryptionkey/heads/rd"
	post_init_icon_state = "cypherkey_research"
	channels = list(RADIO_CHANNEL_SCIENCE = 1, RADIO_CHANNEL_COMMAND = 1)
	greyscale_config = /datum/greyscale_config/encryptionkey_research
	greyscale_colors = "#bc4a9b#793a80"

/obj/item/encryptionkey/heads/hos
	name = "\proper 安全部长的加密密钥"
	icon = 'icons/map_icons/items/encryptionkey.dmi'
	icon_state = "/obj/item/encryptionkey/heads/hos"
	post_init_icon_state = "cypherkey_security"
	channels = list(RADIO_CHANNEL_SECURITY = 1, RADIO_CHANNEL_COMMAND = 1)
	greyscale_config = /datum/greyscale_config/encryptionkey_security
	greyscale_colors = "#280b1a#820a16"

/obj/item/encryptionkey/heads/ce
	name = "\proper 总工程师的加密密钥"
	icon = 'icons/map_icons/items/encryptionkey.dmi'
	icon_state = "/obj/item/encryptionkey/heads/ce"
	post_init_icon_state = "cypherkey_engineering"
	channels = list(RADIO_CHANNEL_ENGINEERING = 1, RADIO_CHANNEL_COMMAND = 1)
	greyscale_config = /datum/greyscale_config/encryptionkey_engineering
	greyscale_colors = "#dca01b#f8d860"

/obj/item/encryptionkey/heads/cmo
	name = "\proper 首席医疗官的加密密钥"
	icon = 'icons/map_icons/items/encryptionkey.dmi'
	icon_state = "/obj/item/encryptionkey/heads/cmo"
	post_init_icon_state = "cypherkey_medical"
	channels = list(RADIO_CHANNEL_MEDICAL = 1, RADIO_CHANNEL_COMMAND = 1)
	greyscale_config = /datum/greyscale_config/encryptionkey_medical
	greyscale_colors = "#ebebeb#2b2793"

/obj/item/encryptionkey/heads/hop
	name = "\proper 人事部长的加密密钥"
	icon = 'icons/map_icons/items/encryptionkey.dmi'
	icon_state = "/obj/item/encryptionkey/heads/hop"
	post_init_icon_state = "cypherkey_cube"
	channels = list(RADIO_CHANNEL_SERVICE = 1, RADIO_CHANNEL_COMMAND = 1)
	greyscale_config = /datum/greyscale_config/encryptionkey_cube
	greyscale_colors = "#2b2793#c2c1c9"

/obj/item/encryptionkey/heads/qm
	name = "\proper 军需官的加密密钥"
	icon = 'icons/map_icons/items/encryptionkey.dmi'
	icon_state = "/obj/item/encryptionkey/heads/qm"
	post_init_icon_state = "cypherkey_cargo"
	channels = list(RADIO_CHANNEL_SUPPLY = 1, RADIO_CHANNEL_COMMAND = 1)
	greyscale_config = /datum/greyscale_config/encryptionkey_cargo
	greyscale_colors = "#49241a#dca01b"

/obj/item/encryptionkey/headset_cargo
	name = "补给无线电加密密钥"
	icon = 'icons/map_icons/items/encryptionkey.dmi'
	icon_state = "/obj/item/encryptionkey/headset_cargo"
	post_init_icon_state = "cypherkey_cargo"
	channels = list(RADIO_CHANNEL_SUPPLY = 1)
	greyscale_config = /datum/greyscale_config/encryptionkey_cargo
	greyscale_colors = "#49241a#7b3f2e"

/obj/item/encryptionkey/headset_mining
	name = "采矿无线电加密密钥"
	icon = 'icons/map_icons/items/encryptionkey.dmi'
	icon_state = "/obj/item/encryptionkey/headset_mining"
	post_init_icon_state = "cypherkey_cargo"
	channels = list(RADIO_CHANNEL_SUPPLY = 1, RADIO_CHANNEL_SCIENCE = 1)
	greyscale_config = /datum/greyscale_config/encryptionkey_cargo
	greyscale_colors = "#49241a#bc4a9b"

/obj/item/encryptionkey/headset_service
	name = "服务无线电加密密钥"
	icon = 'icons/map_icons/items/encryptionkey.dmi'
	icon_state = "/obj/item/encryptionkey/headset_service"
	post_init_icon_state = "cypherkey_service"
	channels = list(RADIO_CHANNEL_SERVICE = 1)
	greyscale_config = /datum/greyscale_config/encryptionkey_service
	greyscale_colors = "#3758c4#3bca5a"

/obj/item/encryptionkey/headset_cent
	name = "\improper 中央司令部无线电加密密钥"
	icon = 'icons/map_icons/items/encryptionkey.dmi'
	icon_state = "/obj/item/encryptionkey/headset_cent"
	post_init_icon_state = "cypherkey_centcom"
	special_channels = RADIO_SPECIAL_CENTCOM
	channels = list(RADIO_CHANNEL_CENTCOM = 1)
	greyscale_config = /datum/greyscale_config/encryptionkey_centcom
	greyscale_colors = "#24a157#dca01b"

/obj/item/encryptionkey/ai //ported from NT, this goes 'inside' the AI.
	flags_1 = parent_type::flags_1 | NO_NEW_GAGS_PREVIEW_1
	channels = list(
		RADIO_CHANNEL_COMMAND = 1,
		RADIO_CHANNEL_SECURITY = 1,
		RADIO_CHANNEL_ENGINEERING = 1,
		RADIO_CHANNEL_SCIENCE = 1,
		RADIO_CHANNEL_MEDICAL = 1,
		RADIO_CHANNEL_SUPPLY = 1,
		RADIO_CHANNEL_SERVICE = 1,
		RADIO_CHANNEL_AI_PRIVATE = 1,
		RADIO_CHANNEL_ENTERTAINMENT = 1,
	)

/obj/item/encryptionkey/ai_with_binary
	name = "人工智能加密密钥"
	flags_1 = parent_type::flags_1 | NO_NEW_GAGS_PREVIEW_1
	channels = list(
		RADIO_CHANNEL_COMMAND = 1,
		RADIO_CHANNEL_SECURITY = 1,
		RADIO_CHANNEL_ENGINEERING = 1,
		RADIO_CHANNEL_SCIENCE = 1,
		RADIO_CHANNEL_MEDICAL = 1,
		RADIO_CHANNEL_SUPPLY = 1,
		RADIO_CHANNEL_SERVICE = 1,
		RADIO_CHANNEL_AI_PRIVATE = 1,
		RADIO_CHANNEL_ENTERTAINMENT = 1,
	)
	special_channels = RADIO_SPECIAL_BINARY
	language_data = list(
		/datum/language/machine = 100,
	)

/obj/item/encryptionkey/ai/evil //ported from NT, this goes 'inside' the AI.
	name = "辛迪加二进制加密密钥"
	icon = 'icons/map_icons/items/encryptionkey.dmi'
	icon_state = "/obj/item/encryptionkey/ai_with_binary"
	post_init_icon_state = "cypherkey_syndicate"
	channels = list(RADIO_CHANNEL_SYNDICATE = 1)
	special_channels = RADIO_SPECIAL_SYNDIE
	greyscale_config = /datum/greyscale_config/encryptionkey_syndicate
	greyscale_colors = "#171717#990000"

/obj/item/encryptionkey/secbot
	channels = list(RADIO_CHANNEL_AI_PRIVATE = 1, RADIO_CHANNEL_SECURITY = 1)
