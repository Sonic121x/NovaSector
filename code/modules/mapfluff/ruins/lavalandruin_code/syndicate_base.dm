//lavaland_surface_syndicate_base1.dmm and it's modules
/obj/modular_map_root/syndicatebase
	config_file = "strings/modular_maps/syndicatebase.toml"

/obj/structure/closet/crate/secure/freezer/commsagent
	name = "各式各样的舌头及舌头装饰品"
	desc = "发现这件事或许是个错误。"

/obj/structure/closet/crate/secure/freezer/commsagent/PopulateContents()
	. = ..() //Contains a variety of less exotic tongues (And tongue accessories) for the comms agent to mess with.
	new /obj/item/organ/tongue(src)
	new /obj/item/organ/tongue/lizard(src)
	new /obj/item/organ/tongue/fly(src)
	new /obj/item/organ/tongue/zombie(src)
	new /obj/item/organ/tongue/bone(src)
	new /obj/item/organ/tongue/robot(src) //DANGER! CRYSTAL HYPERSTRUCTURE-
	new /obj/item/organ/tongue/ethereal(src)
	new /obj/item/autosurgeon/syndicate/commsagent(src)
	new /obj/item/book/granter/sign_language(src)
	new	/obj/item/clothing/gloves/radio(src)

/obj/machinery/power/supermatter_crystal/shard/syndicate
	name = "辛迪加超物质碎片"
	desc = "你的赞助者‘方便地’忘了提它已经组装好了。"
	anchored = TRUE
	radio_key = /obj/item/encryptionkey/syndicate
	emergency_channel = "Syndicate"
	warning_channel = "Syndicate"
	include_in_cims = FALSE

/obj/machinery/power/supermatter_crystal/shard/syndicate/attackby(obj/item/item, mob/living/user, list/modifiers, list/attack_modifiers)
	if(istype(item, /obj/item/scalpel/supermatter)) //You can already yoink the docs as a free objective win, another would be just gross
		to_chat(user, span_danger("这块碎片已在辛迪加保管之下，再次取走它可能弊大于利。"))
		return
	else
		. = ..()
