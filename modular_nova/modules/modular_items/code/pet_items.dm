/obj/item/pet_food
	name = "\improper 通用宠物零食"
	desc = "对你的宠物或现实来说都太寡淡了。你不应该看到这个。"
	icon = 'icons/obj/food/meat.dmi'
	icon_state = "skeletonmeat"
	w_class = WEIGHT_CLASS_SMALL

/obj/item/pet_food/interact_with_atom(mob/living/basic/interacting_with, mob/living/user, list/modifiers)
	if(!istype(interacting_with) || user.combat_mode)
		return NONE
	if(interacting_with.stat)
		to_chat(user, span_warning("宠物已经死了！"))
		return ITEM_INTERACT_BLOCKING
	if(!is_path_in_list(interacting_with.type, assoc_to_values(GLOB.possible_player_pet)))
		to_chat(user, span_warning("这个零食对[interacting_with]无效！"))
		return ITEM_INTERACT_BLOCKING
	return ITEM_INTERACT_SUCCESS

/obj/item/pet_food/pet_space_treat
	name = "\improper 宠物太空零食"
	desc = "一种美味的零食，能让任何可爱的伙伴对讨厌的太空真空产生抵抗力！（如果宠物实际上无法承受太空真空，保修无效，过程不可逆）"
	icon = 'modular_nova/modules/modular_items/icons/pet_items.dmi'
	icon_state = "pet_space_treat"

/obj/item/pet_food/pet_space_treat/interact_with_atom(mob/living/basic/target_pet, mob/living/user, list/modifiers)
	. = ..()
	if(. != ITEM_INTERACT_SUCCESS)
		return
	if(HAS_TRAIT(target_pet, TRAIT_PET_SPACE_TREAT))
		to_chat(user, span_warning("这只宠物已经吃过太空零食了！"))
		return ITEM_INTERACT_BLOCKING
	if(!target_pet.unsuitable_atmos_damage || !target_pet.minimum_survivable_temperature || !target_pet.maximum_survivable_temperature)
		to_chat(user, span_warning("这种零食不适合这只宠物！"))
		return ITEM_INTERACT_BLOCKING
	ADD_TRAIT(target_pet, TRAIT_PET_SPACE_TREAT, user)
	target_pet.RemoveElement(/datum/element/atmos_requirements, target_pet.habitable_atmos, target_pet.unsuitable_atmos_damage)
	target_pet.RemoveElement(/datum/element/body_temp_sensitive, target_pet.minimum_survivable_temperature, target_pet.maximum_survivable_temperature, target_pet.unsuitable_cold_damage, target_pet.unsuitable_heat_damage)
	target_pet.unsuitable_atmos_damage = 0
	target_pet.minimum_survivable_temperature = TCMB
	target_pet.maximum_survivable_temperature = NPC_DEFAULT_MAX_TEMP
	target_pet.apply_atmos_requirements()
	target_pet.apply_temperature_requirements()
	target_pet.desc += span_notice("\n[target_pet.p_They()] 似乎[target_pet.p_s()]更能抵御太空的虚空。")
	to_chat(user, span_notice("你将零食喂给了[target_pet]，它很快就狼吞虎咽地吃掉了。"))
	qdel(src)
