/// Item you use on a mob to make it bigger and stronger
/obj/item/fugu_gland
	name = "温博里安河豚腺体"
	desc = "这是温博里安河豚能够任意增加其质量的关键，这个令人作呕的残留物可以将同样的效果施加于其他生物，赋予它们巨大的力量。"
	icon = 'icons/obj/medical/organs/organs.dmi'
	icon_state = "fugu_gland"
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_NORMAL
	layer = MOB_LAYER
	/// List of mob types which you can't apply the gland to
	var/static/list/fugu_blacklist

/obj/item/fugu_gland/Initialize(mapload)
	. = ..()
	if(fugu_blacklist)
		return
	fugu_blacklist = typecacheof(list(
		/mob/living/basic/guardian,
	))

/obj/item/fugu_gland/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!isanimal_or_basicmob(interacting_with) || fugu_blacklist[interacting_with.type])
		return NONE
	var/mob/living/animal = interacting_with

	if(animal.stat == DEAD || HAS_TRAIT(animal, TRAIT_FAKEDEATH))
		balloon_alert(user, "它死了！")
		return ITEM_INTERACT_BLOCKING
	if(HAS_TRAIT(animal, TRAIT_FUGU_GLANDED))
		balloon_alert(user, "已经够大了！")
		return ITEM_INTERACT_BLOCKING

	ADD_TRAIT(animal, TRAIT_FUGU_GLANDED, type)
	animal.AddComponent(/datum/component/seethrough_mob)
	animal.maxHealth *= 1.5
	animal.health = min(animal.maxHealth, animal.health * 1.5)
	animal.melee_damage_lower = max((animal.melee_damage_lower * 2), 10)
	animal.melee_damage_upper = max((animal.melee_damage_upper * 2), 10)
	animal.update_transform(2)
	animal.AddElement(/datum/element/wall_tearer)
	to_chat(user, span_info("你增大了[animal]的体型，让[animal.p_them()]获得了力量激增！"))
	qdel(src)
	return ITEM_INTERACT_SUCCESS
