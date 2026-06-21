/obj/item/assembly/shock_kit
	name = "电头盔组件"
	desc = "这似乎是由电源包和头盔组成的。"
	icon = 'icons/obj/devices/assemblies.dmi'
	icon_state = "shock_kit"
	var/obj/item/clothing/head/helmet/helmet_part = null
	var/obj/item/electropack/electropack_part = null
	w_class = WEIGHT_CLASS_HUGE
	obj_flags = CONDUCTS_ELECTRICITY

/obj/item/assembly/shock_kit/Destroy()
	QDEL_NULL(helmet_part)
	QDEL_NULL(electropack_part)
	return ..()

/obj/item/assembly/shock_kit/Initialize(mapload)
	. = ..()
	if(!helmet_part)
		helmet_part = new(src)
		helmet_part.master = src
	if(!electropack_part)
		electropack_part = new(src)
		electropack_part.master = src

/obj/item/assembly/shock_kit/wrench_act(mob/living/user, obj/item/I)
	..()
	to_chat(user, span_notice("你拆解了[src]。"))
	if(helmet_part)
		helmet_part.forceMove(drop_location())
		helmet_part.master = null
		helmet_part = null
	if(electropack_part)
		electropack_part.forceMove(drop_location())
		electropack_part.master = null
		electropack_part = null
	qdel(src)
	return TRUE

/obj/item/assembly/shock_kit/attack_self(mob/user)
	helmet_part.attack_self(user)
	electropack_part.attack_self(user)
	add_fingerprint(user)
	return
