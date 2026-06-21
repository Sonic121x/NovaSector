
/obj/item/skillchip/basketweaving
	name = "Basketsoft 3000 技术芯片"
	desc = "水下版。"
	skill_name = "Underwater Basketweaving"
	skill_description = "Master intricate art of using twine to create perfect baskets while submerged."
	skill_icon = "shopping-basket"
	activate_message = span_notice("你与麻线和海洋融为一体。")
	deactivate_message = span_notice("水下编篮术的更高奥秘离开了你的脑海。")

/obj/item/skillchip/basketweaving/has_mob_incompatibility(mob/living/carbon/target)
	. = ..()
	if(.)
		return

	if(!target.mind)
		return "Target incapable of learning recipe."

/obj/item/skillchip/basketweaving/on_activate(mob/living/carbon/user, silent=FALSE)
	. = ..()
	if(!user.mind)
		return
	learn_recipes(user)
	//Prevent the skill from being transferred via mindswap. What an edge case
	RegisterSignal(user.mind, COMSIG_MIND_TRANSFERRED, PROC_REF(forget_recipes))
	RegisterSignal(user, COMSIG_MOB_MIND_TRANSFERRED_INTO, PROC_REF(learn_recipes))

/obj/item/skillchip/basketweaving/proc/learn_recipes(mob/source)
	SIGNAL_HANDLER
	for(var/recipe_type in typesof(/datum/crafting_recipe/underwater_basket))
		source.mind.teach_crafting_recipe(recipe_type)

/obj/item/skillchip/basketweaving/proc/forget_recipes(datum/mind/source, mob/previous_body)
	SIGNAL_HANDLER
	for(var/recipe_type in typesof(/datum/crafting_recipe/underwater_basket))
		source.forget_crafting_recipe(recipe_type)

/obj/item/skillchip/basketweaving/on_deactivate(mob/living/carbon/user, silent=FALSE)
	if(user.mind)
		forget_recipes(user.mind)
		UnregisterSignal(user.mind, COMSIG_MIND_TRANSFERRED)
		UnregisterSignal(user, COMSIG_MOB_MIND_TRANSFERRED_INTO)
	return ..()
