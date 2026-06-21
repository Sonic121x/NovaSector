/**
 * # secret documents
 *
 * Indestructible antag objective that can be photocopied.
 *
 * Photocopying this is handled in photocopier.dm.
 * Cannot be destroyed, but can be spaced.
 * Save for the inhand, this does not actually have anything in common with /obj/item/paper.
*/
/obj/item/documents
	name = "机密文件"
	desc = "\"绝密\"文件。"
	icon = 'icons/obj/service/bureaucracy.dmi'
	icon_state = "docs_generic"
	inhand_icon_state = "paper"
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_range = 1
	throw_speed = 1
	layer = MOB_LAYER
	pressure_resistance = 2
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF

///Nanotrasen documents
/obj/item/documents/nanotrasen
	desc = "\"绝密\"的纳能特拉森文件，充满了复杂的图表以及姓名、日期和坐标的列表。"
	icon_state = "docs_verified"

///Syndicate documents
/obj/item/documents/syndicate
	desc = "\"绝密\"文件，详细说明了辛迪加敏感的作战情报。"

///Syndicate documents with a red seal
/obj/item/documents/syndicate/red
	name = "红色机密文件"
	desc = "\"绝密\"文件，详细说明了辛迪加敏感的作战情报。这些文件盖有红色蜡封认证。"
	icon_state = "docs_red"

///Syndicate documents with a blue seal
/obj/item/documents/syndicate/blue
	name = "蓝色机密文件"
	desc = "\"绝密\"文件，详细说明了辛迪加敏感的作战情报。这些文件盖有蓝色蜡封认证。"
	icon_state = "docs_blue"

///Syndicate mining documents
/obj/item/documents/syndicate/mining
	desc = "\"绝密\"文件，详细说明了辛迪加的等离子体采矿行动。"

/**
 * # secret documents (photocopy)
 *
 * Outcome of photocopying documents. Can be copied, and can have a blue/red seal forged.
*/
/obj/item/documents/photocopy
	desc = "一些绝密文件的副本。没人会注意到它们不是原件……对吧？"
	///What seal was forged on the documents (color name string)
	var/forgedseal = 0
	///What was copied
	var/copy_type = null

/obj/item/documents/photocopy/Initialize(mapload, obj/item/documents/copy=null)
	. = ..()
	if(copy)
		copy_type = copy.type
		if(istype(copy, /obj/item/documents/photocopy)) // Copy Of A Copy Of A Copy
			var/obj/item/documents/photocopy/C = copy
			copy_type = C.copy_type

/obj/item/documents/photocopy/attackby(obj/item/O, mob/user, list/modifiers, list/attack_modifiers)
	if(istype(O, /obj/item/toy/crayon/red) || istype(O, /obj/item/toy/crayon/blue))
		if (forgedseal)
			to_chat(user, span_warning("你已经在 [src] 上伪造了印章！"))
		else
			var/obj/item/toy/crayon/C = O
			name = "[C.crayon_color] 机密文件"
			icon_state = "docs_[C.crayon_color]"
			forgedseal = C.crayon_color
			to_chat(user, span_notice("你用一根 [C.crayon_color] 蜡笔伪造了官方印章。没人会注意到……对吧？"))
			update_appearance()
