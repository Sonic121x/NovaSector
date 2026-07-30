// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/book/granter/crafting_recipe
	/// A list of all recipe types we grant on learn
	var/list/crafting_recipe_types = list()

/obj/item/book/granter/crafting_recipe/on_reading_finished(mob/user)
	. = ..()
	if(!user.mind)
		return
	for(var/crafting_recipe_type in crafting_recipe_types)
		user.mind.teach_crafting_recipe(crafting_recipe_type)
		var/datum/crafting_recipe/recipe = GLOB.cooking_recipes_by_typepath[crafting_recipe_type] || GLOB.crafting_recipes_by_typepath[crafting_recipe_type]
		to_chat(user, span_notice(LANG("obj.c57b7f17", list(recipe.name))))

/obj/item/book/granter/crafting_recipe/dusting
	icon_state = "book1"

/obj/item/book/granter/crafting_recipe/dusting/recoil(mob/living/user)
	to_chat(user, span_warning(LANG("obj.00d3a38e", null)))
	qdel(src)
