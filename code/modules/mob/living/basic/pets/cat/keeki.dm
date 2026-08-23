// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/mob/living/basic/pet/cat/cak
	name = "Keeki"
	desc = "She is a cat made out of cake."
	icon_state = "cak"
	icon_living = "cak"
	icon_dead = "cak_dead"
	health = 50
	maxHealth = 50
	gender = FEMALE
	butcher_results = list(
		/obj/item/organ/brain = 1,
		/obj/item/organ/heart = 1,
		/obj/item/food/cakeslice/birthday = 3,
		/obj/item/food/meat/slab = 2
	)
	response_harm_continuous = "takes a bite out of"
	response_harm_simple = "take a bite out of"
	ai_controller = /datum/ai_controller/basic_controller/cat/cake
	attacked_sound = 'sound/items/eatfood.ogg'
	death_message = "loses her false life and collapses!"
	death_sound = SFX_BODYFALL
	held_state = "cak"
	can_interact_with_stove = TRUE
	//just ensuring the mats contained by the cat when spawned are the same of when crafted
	custom_materials = list(/datum/material/meat = MEATSLAB_MATERIAL_AMOUNT * 3)

/mob/living/basic/pet/cat/cak/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/regenerator,\
		regeneration_delay = 1 SECONDS,\
		brute_per_second = 5,\
		outline_colour = COLOR_PINK,\
	)
	var/static/list/on_consume = list(
		/datum/reagent/consumable/nutriment = 0.4,
		/datum/reagent/consumable/nutriment/vitamin = 0.4,
	)
	AddElement(/datum/element/consumable_mob, reagents_list = on_consume)

/mob/living/basic/pet/cat/cak/add_cell_sample()
	return

/mob/living/basic/pet/cat/cak/on_craft_completion(list/components, datum/crafting_recipe/current_recipe, atom/crafter)
	. = ..()
	var/obj/item/organ/brain/candidate = locate(/obj/item/organ/brain) in contents
	if(isnull(candidate?.brainmob?.mind))
		return
	var/datum/mind/candidate_mind = candidate.brainmob.mind
	candidate_mind.transfer_to(src)
	candidate_mind.grab_ghost()
	to_chat(src, LANG("mob.01f31d85713158d8", list(span_boldbig("You are a cak!"))))
	var/default_name = initial(name)
	var/new_name = sanitize_name(reject_bad_text(tgui_input_text(src, LANG("mob.e36094c4548f3f49", list(src)), LANG("mob.b4bf4c54d223e79b", null), default_name, MAX_NAME_LEN)), cap_after_symbols = FALSE)
	if(new_name)
		to_chat(src, span_notice(LANG("mob.e590eb95cb295f60", list(new_name))))
		name = new_name

/mob/living/basic/pet/cat/cak/spin(spintime, speed)
	. = ..()
	for(var/obj/item/food/donut/target in oview(1, src))
		if(!target.is_decorated)
			target.decorate_donut()
