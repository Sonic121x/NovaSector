#define TURRET_ASSEMBLY_START "start"
#define TURRET_ASSEMBLY_RECEIVER "receiver"
#define TURRET_ASSEMBLY_SEC_1 "secured_receiver"
#define TURRET_ASSEMBLY_SERVO "servo"
#define TURRET_ASSEMBLY_SEC_2 "secured_servo"
#define TURRET_ASSEMBLY_SENSOR "sensor"
#define TURRET_ASSEMBLY_SEC_3 "secured_sensor"
#define TURRET_ASSEMBLY_WRAPUP "finished_assembly"

/obj/item/turret_assembly
	name = "turret plate assembly"
	icon = 'modular_nova/modules/magfed_turret/icons/assembly.dmi'
	icon_state = "turret_assembly"
	desc = "A set of assembly parts for a magazine-fed turret, requiring a receiver, servo and sensor along with construction. This one seems to be for a basic outpost defense turret."
	/// modular receiver
	var/obj/item/receiver
	/// proximity sensor
	var/obj/item/sensor
	/// any stockpart servo
	var/obj/item/servo
	/// The turret being produced. Why so elaborate while everything else simple? iunno.
	var/obj/item/storage/toolbox/emergency/turret/mag_fed/design = /obj/item/storage/toolbox/emergency/turret/mag_fed/outpost
	/// step tracking
	var/step = TURRET_ASSEMBLY_START

/obj/item/turret_assembly/examine(mob/user)
	. = ..()
	var/display_text
	switch(step)
		if(TURRET_ASSEMBLY_START)
			display_text = "The turret head is missing a <b>modular receiver</b>..."
		if(TURRET_ASSEMBLY_RECEIVER)
			display_text = "The turret head's connecting bolts are <b>loose</b>..."
		if(TURRET_ASSEMBLY_SEC_1)
			display_text = "It looks like it's missing a <b>servo</b>..."
		if(TURRET_ASSEMBLY_SERVO)
			display_text = "It looks like its main chassis is <b>unsecured</b>..."
		if(TURRET_ASSEMBLY_SEC_2)
			display_text = "It looks like it's missing a <b>proximity sensor</b>..."
		if(TURRET_ASSEMBLY_SENSOR)
			display_text = "The sensor seems <b>unsecured</b>..."
		if(TURRET_ASSEMBLY_SEC_3)
			display_text = "The supports' bolts seem <b>loose</b>..."
		if(TURRET_ASSEMBLY_WRAPUP)
			display_text = "The circuitboard's CPU needs to be <b>activated</b>..."
	. += span_notice(display_text)

/obj/item/turret_assembly/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	. = ..()
	switch(step)
		if(TURRET_ASSEMBLY_START)
			if(!istype(tool, /obj/item/weaponcrafting/receiver))
				return
			if(!user.transferItemToLoc(tool, src))
				balloon_alert(user, LANG("obj.c89edc0c4b8c5b6d", null))
				return
			playsound(src, 'sound/machines/click.ogg', 30, TRUE)
			balloon_alert(user, LANG("obj.a836a1d088a1cbba", null))
			receiver = tool
			step = TURRET_ASSEMBLY_RECEIVER

		if(TURRET_ASSEMBLY_SEC_1)
			if(istype(tool, /obj/item/stock_parts/servo)) //Construct
				if(!user.transferItemToLoc(tool, src))
					balloon_alert(user, LANG("obj.52779bbb1d8777d4", null))
					return
				playsound(src, 'sound/machines/click.ogg', 30, TRUE)
				balloon_alert(user, LANG("obj.7cb93f71ce192d51", null))
				servo = tool
				step = TURRET_ASSEMBLY_SERVO

		if(TURRET_ASSEMBLY_SEC_2)
			if(istype(tool, /obj/item/assembly/prox_sensor)) //Construct
				if(!user.transferItemToLoc(tool, src))
					balloon_alert(user, LANG("obj.b75110d3a4288082", null))
					return
				playsound(src, 'sound/machines/click.ogg', 30, TRUE)
				balloon_alert(user, LANG("obj.1609b8bcf94efb3b", null))
				sensor = tool
				step = TURRET_ASSEMBLY_SENSOR

/obj/item/turret_assembly/multitool_act(mob/living/user, obj/item/tool)
	if(step == TURRET_ASSEMBLY_WRAPUP)
		if(tool.use_tool(src, user, 0, volume=30))
			playsound(src, 'sound/machines/click.ogg', 30, TRUE)
			var/obj/item/turretling = new design(drop_location())
			qdel(src)
			user.put_in_hands(turretling)
			turretling.balloon_alert(user, LANG("obj.19a41b0d43eecf40", null))

/obj/item/turret_assembly/wrench_act(mob/living/user, obj/item/tool)
	switch(step)
		if(TURRET_ASSEMBLY_SEC_3)
			if(tool.use_tool(src, user, 0, volume=30))
				balloon_alert(user, LANG("obj.40e42e4936c682ee", null))
				step = TURRET_ASSEMBLY_WRAPUP
				return // Last step leads to the next step
		if(TURRET_ASSEMBLY_WRAPUP)
			if(tool.use_tool(src, user, 0, volume=30))
				balloon_alert(user, LANG("obj.213e899ad76a6504", null))
				step = TURRET_ASSEMBLY_SEC_3
				return

/obj/item/turret_assembly/screwdriver_act(mob/living/user, obj/item/tool)
	switch(step)
		if(TURRET_ASSEMBLY_RECEIVER) //Construct
			if(tool.use_tool(src, user, 0, volume=30))
				balloon_alert(user, LANG("obj.70fad9f264b34f9d", null))
				step = TURRET_ASSEMBLY_SEC_1
				return //same as wrench
		if(TURRET_ASSEMBLY_SEC_1) //Deconstruct
			if(tool.use_tool(src, user, 0, volume=30))
				balloon_alert(user, LANG("obj.ec92076d7c7ebffe", null))
				step = TURRET_ASSEMBLY_RECEIVER
				return
		if(TURRET_ASSEMBLY_SERVO) //Construct
			if(tool.use_tool(src, user, 0, volume=30))
				balloon_alert(user, LANG("obj.465d6ae8c9bdc068", null))
				step = TURRET_ASSEMBLY_SEC_2
				return
		if(TURRET_ASSEMBLY_SEC_2) //Deconstruct
			if(tool.use_tool(src, user, 0, volume=30))
				balloon_alert(user, LANG("obj.c17533a83b5dae98", null))
				step = TURRET_ASSEMBLY_SERVO
				return
		if(TURRET_ASSEMBLY_SENSOR)//Construct
			if(tool.use_tool(src, user, 0, volume=30))
				balloon_alert(user, LANG("obj.5088e180db675153", null))
				step = TURRET_ASSEMBLY_SEC_3
				return
		if(TURRET_ASSEMBLY_SEC_3) //Deconstruct
			if(tool.use_tool(src, user, 0, volume=30))
				balloon_alert(user, LANG("obj.c17533a83b5dae98", null))
				step = TURRET_ASSEMBLY_SENSOR
				return

/obj/item/turret_assembly/crowbar_act(mob/living/user, obj/item/tool)
	switch(step)
		if(TURRET_ASSEMBLY_RECEIVER)
			if(tool.use_tool(src, user, 0, volume=30))
				receiver.forceMove(drop_location())
				balloon_alert(user, LANG("obj.5eb464bb00bb65f8", null))
				receiver = null
				step = TURRET_ASSEMBLY_START
				return
		if(TURRET_ASSEMBLY_SERVO)
			if(tool.use_tool(src, user, 0, volume=30))
				servo.forceMove(drop_location())
				balloon_alert(user, LANG("obj.88e677d2f89bcd4b", null))
				servo = null
				step = TURRET_ASSEMBLY_SEC_1
				return
		if(TURRET_ASSEMBLY_SENSOR)
			if(tool.use_tool(src, user, 0, volume=30))
				sensor.forceMove(drop_location())
				balloon_alert(user, LANG("obj.8e7d27a2bb825f1b", null))
				sensor = null
				step = TURRET_ASSEMBLY_SEC_2
				return

/obj/item/turret_assembly/Destroy()
	QDEL_NULL(receiver)
	QDEL_NULL(servo)
	QDEL_NULL(sensor)
	return ..()

/obj/item/turret_assembly/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == receiver)
		receiver = null
	if(gone == servo)
		servo = null
	if(gone == sensor)
		sensor = null

/obj/item/turret_assembly/twin_fang
	name = "twin_fang plate assembly"
	icon = 'modular_nova/modules/magfed_turret/icons/assembly.dmi'
	icon_state = "twinfang_assembly"
	desc = "A set of assembly parts for a magazine-fed turret, requiring a receiver, servo and sensor along with construction. This one is for a \"Twin-Fang\" model of the \"Spider\" turret type."
	design = /obj/item/storage/toolbox/emergency/turret/mag_fed/spider/twin_fang

/obj/item/turret_assembly/duster
	name = "duster plate assembly"
	icon = 'modular_nova/modules/magfed_turret/icons/assembly.dmi'
	icon_state = "duster_assembly"
	desc = "A set of assembly parts for a magazine-fed turret, requiring a receiver, servo and sensor along with construction. This one is for a \"Duster\" model of the \"Emergent\" turret type."
	design = /obj/item/storage/toolbox/emergency/turret/mag_fed/duster

#undef TURRET_ASSEMBLY_START
#undef TURRET_ASSEMBLY_RECEIVER
#undef TURRET_ASSEMBLY_SEC_1
#undef TURRET_ASSEMBLY_SERVO
#undef TURRET_ASSEMBLY_SEC_2
#undef TURRET_ASSEMBLY_SENSOR
#undef TURRET_ASSEMBLY_SEC_3
#undef TURRET_ASSEMBLY_WRAPUP
