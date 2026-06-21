/datum/bounty/item/special
	unique = TRUE

/datum/bounty/item/special/alien_organs
	name = "外星器官"
	description = "纳米传讯有意研究异形生物学。运送一套器官将获得丰厚报酬。"
	reward = CARGO_CRATE_VALUE * 50
	required_count = 3
	wanted_types = list(
		/obj/item/organ/brain/alien = TRUE,
		/obj/item/organ/alien = TRUE,
		/obj/item/organ/body_egg/alien_embryo = TRUE,
		/obj/item/organ/liver/alien = TRUE,
		/obj/item/organ/tongue/alien = TRUE,
		/obj/item/organ/eyes/alien = TRUE,
	)

/datum/bounty/item/special/syndicate_documents
	name = "辛迪加文件"
	description = "关于辛迪加的情报在中央司令部价值连城。如果发现辛迪加文件，请运送过来。你可能会拯救生命。"
	reward = CARGO_CRATE_VALUE * 30
	wanted_types = list(
		/obj/item/documents/syndicate = TRUE,
		/obj/item/documents/photocopy = TRUE,
	)

/datum/bounty/item/special/syndicate_documents/applies_to(obj/O)
	if(!..())
		return FALSE
	if(istype(O, /obj/item/documents/photocopy))
		var/obj/item/documents/photocopy/Copy = O
		return (Copy.copy_type && ispath(Copy.copy_type, /obj/item/documents/syndicate))
	return TRUE

/datum/bounty/item/special/adamantine
	name = "精金"
	description = "Nanotrasen's anomalous materials division is in desperate need of adamantine. Send them a large shipment and we'll make it worth your while."
	reward = CARGO_CRATE_VALUE * 70
	required_count = 10
	wanted_types = list(/obj/item/stack/sheet/mineral/adamantine = TRUE)
