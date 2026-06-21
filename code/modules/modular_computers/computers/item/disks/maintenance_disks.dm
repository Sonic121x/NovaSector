/obj/item/disk/computer/maintenance
	name = "维护区数据磁盘"
	desc = "一个被遗忘在维护区深处的数据磁盘，上面可能有一些有用的程序。"

/// Medical health analyzer app
/obj/item/disk/computer/maintenance/scanner
	starting_programs = list(/datum/computer_file/program/maintenance/phys_scanner)

///Camera app, forced to always have largest image size
/obj/item/disk/computer/maintenance/camera
	starting_programs = list(/datum/computer_file/program/maintenance/camera)

///MODsuit UI, in your PDA!
/obj/item/disk/computer/maintenance/modsuit_control
	starting_programs = list(/datum/computer_file/program/maintenance/modsuit_control)

///Returns A 'spookiness' value based on the number of ghastly creature and hauntium and their distance from the PC.
/obj/item/disk/computer/maintenance/spectre_meter
	starting_programs = list(/datum/computer_file/program/maintenance/spectre_meter)

///A version of the arcade program with less HP/MP for the enemy and more for the player
/obj/item/disk/computer/maintenance/arcade
	starting_programs = list(/datum/computer_file/program/arcade/eazy)

/obj/item/disk/computer/maintenance/theme/Initialize(mapload)
	starting_programs = list(pick(subtypesof(/datum/computer_file/program/maintenance/theme)))
	return ..()

/obj/item/disk/computer/maintenance/cool_sword
	starting_programs = list(/datum/computer_file/program/maintenance/cool_sword)
