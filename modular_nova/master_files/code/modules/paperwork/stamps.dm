/obj/item/stamp/cat
	name = "\improper 官方猫咪印章"
	desc = "一个用于给重要性存疑的文件盖章的橡皮图章。"
	icon = 'modular_nova/master_files/icons/obj/bureaucracy.dmi'
	icon_state = "stamp-cat_blue"
	inhand_icon_state = "stamp"
// Radial menu options
	var/static/cat_blue = image(icon = 'modular_nova/master_files/icons/obj/bureaucracy.dmi', icon_state = "radial_cat_blue")
	var/static/paw_blue = image(icon = 'modular_nova/master_files/icons/obj/bureaucracy.dmi', icon_state = "radial_paw_blue")
	var/static/cat_red = image(icon = 'modular_nova/master_files/icons/obj/bureaucracy.dmi', icon_state = "radial_cat_red")
	var/static/paw_red = image(icon = 'modular_nova/master_files/icons/obj/bureaucracy.dmi', icon_state = "radial_paw_red")
	var/static/cat_orange = image(icon = 'modular_nova/master_files/icons/obj/bureaucracy.dmi', icon_state = "radial_cat_orange")
	var/static/paw_orange = image(icon = 'modular_nova/master_files/icons/obj/bureaucracy.dmi', icon_state = "radial_paw_orange")
	var/static/cat_green = image(icon = 'modular_nova/master_files/icons/obj/bureaucracy.dmi', icon_state = "radial_cat_green")
	var/static/paw_green = image(icon = 'modular_nova/master_files/icons/obj/bureaucracy.dmi', icon_state = "radial_paw_green")
// Choices for the radial menu
	var/static/list/radial_options = list(
		"cat_blue" = cat_blue,
		"paw_blue" = paw_blue,
		"cat_red" = cat_red,
		"paw_red" = paw_red,
		"cat_orange" = cat_orange,
		"paw_orange" = paw_orange,
		"cat_green" = cat_green,
		"paw_green" = paw_green
	)

/obj/item/stamp/cat/ui_interact(mob/user)
	. = ..()
	var/choice = show_radial_menu(user, src, radial_options)
	switch(choice)
		if("cat_blue")
			icon_state = "stamp-cat_blue"
			dye_color = DYE_HOP
			name = "\improper 官方猫咪印章"
		if("paw_blue")
			icon_state = "stamp-paw_blue"
			dye_color = DYE_HOP
			name = "\improper 爪印印章"

		if("cat_red")
			icon_state = "stamp-cat_red"
			dye_color = DYE_HOS
			name = "\improper 官方猫咪印章"
		if("paw_red")
			icon_state = "stamp-paw_red"
			dye_color = DYE_HOS
			name = "\improper 爪印印章"

		if("cat_orange")
			icon_state = "stamp-cat_orange"
			dye_color = DYE_QM
			name = "\improper 官方猫咪印章"
		if("paw_orange")
			icon_state = "stamp-paw_orange"
			dye_color = DYE_QM
			name = "\improper 爪印印章"

		if("cat_green")
			icon_state = "stamp-cat_green"
			dye_color = DYE_CENTCOM
			name = "\improper 官方猫咪印章"
		if("paw_green")
			icon_state = "stamp-paw_green"
			dye_color = DYE_CENTCOM
			name = "\improper 爪印印章"

		else
			return

/obj/item/stamp/nri
	name = "\improper 新俄罗斯帝国印章"
	desc = "一个用于在重要文件上盖章的橡皮图章。用于各种新罗西亚帝国文件。"
	icon = 'modular_nova/master_files/icons/obj/bureaucracy.dmi'
	icon_state = "stamp-nri"
	dye_color = DYE_CENTCOM

/obj/item/stamp/solfed
	name = "\improper 太阳联邦印章"
	icon = 'modular_nova/master_files/icons/obj/bureaucracy.dmi'
	icon_state = "stamp-solfed"
	dye_color = DYE_CE

/obj/item/stamp/tarkon
	name = "塔康港橡皮图章"
	icon = 'modular_nova/master_files/icons/obj/bureaucracy.dmi'
	icon_state = "stamp-tarkon"
	dye_color = DYE_QM

/obj/item/stamp/warden
	name = "典狱长的橡皮图章"
	icon = 'modular_nova/master_files/icons/obj/bureaucracy.dmi'
	icon_state = "stamp-warden"
	dye_color = DYE_HOS
