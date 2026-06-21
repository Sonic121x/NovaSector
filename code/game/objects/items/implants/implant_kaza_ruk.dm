/obj/item/implant/kaza_ruk
	name = "卡扎·鲁克植入物"
	desc = "通过直接投射到您眼球中的5个简短教学视频，教授您提兹兰武术卡扎·鲁克。"
	icon = 'icons/obj/scrolls.dmi'
	icon_state ="scroll2"
	/// The martial art style this implant teaches.
	var/datum/martial_art/kaza_ruk/style

	implant_info = "Automatically activates upon implantation. Teaches the Tiziran martial arts of Kaza Ruk."

	implant_lore = "The Kaza Ruk Implant is an integrated training database consisting of five short instructional videos \
		beamed directly into the eyeballs, capable of being replayed on demand in order to review the fundamentals of the Tiziran \
		martial arts of Kaza Ruk, regardless of the host's previous martial arts skills or a distinct lack thereof."

/obj/item/implant/kaza_ruk/Initialize(mapload)
	. = ..()
	style = new(src)

/obj/item/implant/kaza_ruk/Destroy()
	QDEL_NULL(style)
	return ..()

/obj/item/implant/kaza_ruk/activate()
	. = ..()
	if(isnull(imp_in.mind))
		return
	if(style.unlearn(imp_in))
		return

	style.teach(imp_in)

/obj/item/implanter/kaza_ruk
	name = "植入器（卡扎·鲁克）"
	imp_type = /obj/item/implant/kaza_ruk

/obj/item/implantcase/kaza_ruk
	name = "植入物盒 - '卡扎·鲁克'"
	desc = "一个装有可教授使用者提兹兰武术卡扎·鲁克的植入物的玻璃盒。"
	imp_type = /obj/item/implant/kaza_ruk
