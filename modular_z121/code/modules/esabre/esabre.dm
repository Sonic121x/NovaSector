/obj/item/melee/energy/esabre
	name = "舰长型动力军刀"
	desc = "这种动力武器也只会配发给纳米传讯的高级官员以及那些权势之人，比如舰长、纳米官员或是应急响应小组中的军官等。优雅而有效的动力剑也让使用者有了更多的攻击手段和防御方式，无论使用着是否擅长近战，动力剑都会是这些人的最好选择。"
	icon = 'modular_z121/icons/obj/melee/esabre.dmi'
	icon_state = "esabre"
	inhand_icon_state = "esabre"
	base_icon_state = "esabre"
	lefthand_file = 'modular_z121/icons/mob/melee/esabre_lefthand.dmi'
	righthand_file = 'modular_z121/icons/mob/melee/esabre_righthand.dmi'
	hitsound = 'sound/items/weapons/bladeslice.ogg'
	attack_verb_continuous = list("slashes","thorns")
	attack_verb_simple = list("immolated", "slashed")
	force = 20
	throwforce = 10
	throw_speed = 3
	throw_range = 5
	block_chance = 10
	armour_penetration = 75
	block_sound = 'sound/items/weapons/block_blade.ogg'
	sharpness = SHARP_EDGED
	w_class = WEIGHT_CLASS_BULKY

	active_force = 26
	active_throwforce = 15

/obj/item/melee/energy/esabre/make_transformable()
	AddComponent(
		/datum/component/transforming, \
		force_on = active_force, \
		throwforce_on = active_throwforce, \
		throw_speed_on = throw_speed, \
		sharpness_on = sharpness, \
		w_class_on = active_w_class, \
	)
	RegisterSignal(src, COMSIG_TRANSFORMING_ON_TRANSFORM, PROC_REF(on_transform))

/obj/item/melee/energy/esabre/on_exit_storage(datum/storage/container)
	playsound(container.parent, 'sound/items/unsheath.ogg', 25, TRUE)

/obj/item/melee/energy/esabre/on_enter_storage(datum/storage/container)
	playsound(container.parent, 'sound/items/sheath.ogg', 25, TRUE)

/obj/item/melee/energy/esabre/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] swings [src] towards [user.p_their()] head! It looks like [user.p_theyre()] trying to commit suicide!"))
	return (BRUTELOSS|FIRELOSS)

/obj/item/weaponcrafting/swordkit/esabre
	name = "舰长动力军刀升级套件"
	desc = "用于升级舰长军刀为舰长型动力军刀"
	icon = 'icons/obj/weapons/improvised.dmi'
	icon_state = "kitsuitcase"

/datum/crafting_recipe/esabre
	name = "舰长型动力军刀"
	reqs = list(/obj/item/melee/sabre = 1,/obj/item/weaponcrafting/swordkit/esabre = 1,
	)

	result =  /obj/item/melee/energy/esabre
	category = CAT_WEAPON_MELEE

/datum/storage/sabre_belt/New(atom/parent, max_slots, max_specific_storage, max_total_storage)
	. = ..()
	set_holdable(list(
		/obj/item/melee/sabre,
		/obj/item/melee/energy/esabre,
	))

/obj/structure/closet/secure_closet/captains/populate_contents_immediate()
	new /obj/item/gun/energy/e_gun(src)
	new /obj/item/storage/belt/sabre(src)
	new /obj/item/weaponcrafting/swordkit/esabre(src)
